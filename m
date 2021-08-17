Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0043EF1D9
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 20:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbhHQSas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 14:30:48 -0400
Received: from aibo.runbox.com ([91.220.196.211]:39056 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhHQSar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 14:30:47 -0400
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <post@jbechtel.de>)
        id 1mG3qm-00058A-Ea; Tue, 17 Aug 2021 20:30:12 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (535840)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1mG3qT-0003BN-GK; Tue, 17 Aug 2021 20:29:53 +0200
Date:   Tue, 17 Aug 2021 20:21:35 +0200
From:   Jonas Bechtel <post@jbechtel.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: Re: ss command not showing raw sockets? (regression)
Message-ID: <20210817202135.6b42031f@mmluhan>
In-Reply-To: <20210817080451.34286807@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210815231738.7b42bad4@mmluhan>
        <20210816150800.28ef2e7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210817080451.34286807@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Claws Mail ~3.16
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/bAmSQg92fnYYSRNZtpOhdHQ"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--MP_/bAmSQg92fnYYSRNZtpOhdHQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline



On Tue, 17 Aug 2021 08:04:51 -0700
Jakub Kicinski <kuba@kernel.org> wrote with subject
"Re: ss command not showing raw sockets? (regression)":

> On Mon, 16 Aug 2021 15:08:00 -0700 Jakub Kicinski wrote:
> > On Sun, 15 Aug 2021 23:17:38 +0200 Jonas Bechtel wrote:
> > > I've got following installation:
> > > * ping 32 bit version
> > > * Linux 4.4.0 x86_64 (yes, somewhat ancient)
> > > * iproute2  4.9.0 or 4.20.0 or 5.10.0
> > > 
> > > With one ping command active, there are two raw sockets on my
> > > system: one for IPv4 and one for IPv6 (just one of those is used).
> > > 
> > > My problem is that
> > > 
> > > ss -awp
> > > 
> > > shows 
> > > * two raw sockets (4.9.0)
> > > * any raw socket = bug (4.20.0)
> > > * any raw socket = bug (5.10.0)  
> > 
> > Could you clarify how the bug manifests itself? Does ss crash?
> > 
> > > So is this a bug or is this wont-fix (then, if it is related to
> > > kernel version, package maintainers may be interested)?  
> 
> I had a look, I don't see anything out of the ordinary. I checked with
> v4.6, I don't have a 4.4 box handy. It seems ss got support for
> dumping over netlink in the 4.9. On a 4.4 kernel it should fall back
> to using procfs tho, raw_show() calls inet_show_netlink() which
> should fails and therefore the code should fall through to the old
> procfs stuff.
> 
> No idea why that doesn't happen for you. Is this vanilla 4.4 or does
> it have backports? Is there a /sys/module/raw_diag/ directory on your
> system after you run those commands?

It's was Knoppix distributed package. I don't know about the exact contents, there's also no hint in package description. I just know that it works without initrd, as it directly mounts the root disk.

No, there's /sys/module but no /sys/module/raw_diag/ neither before nor after running those commands.

> 
> Does setting PROC_NET_RAW make the newer iproute version work for you?
> 
> $ PROC_NET_RAW=/proc/net/raw ss -awp

Yes, this did the trick. (And again I was thinking programs were doing something "magical", but in the end it's just a file they access)


Furthermore I checked with Linux 4.19.0 amd64 RT (Debian package; from package description: "This kernel includes the PREEMPT_RT realtime patch set."). With this kernel there was no need for PROC_NET_RAW. All iproute versions worked out of the box and showed even command name, pid and fd number (that's why ss traverses all /proc/[pids]/fd/ directories?).


See attached log file, with kernel versions and iproute2 versions printed.


@kuba With PROC_NET_RAW I consider the problem is found, isn't it? So I will not download/bisect<->build or otherwise investigate the problem until one of you explicitely asks me to do so.

I have now redirected invocation of command with set PROC_NET_RAW on my system, and may (try to) update to Linux 4.19.

Thank you!


Best Regards
 jbechtel



--MP_/bAmSQg92fnYYSRNZtpOhdHQ
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=ss_debug-logs.txt



user@machine:~$ uname -a; for file in ./ss_{4.9.0,4.20.0,5.10.0}; do echo $file; $file -awp; PROC_NET_RAW=/proc/net/raw $file -awp; done
Linux machine 4.4.0-64 #2 SMP PREEMPT Mon Jan 25 01:54:18 CET 2016 x86_64 GNU/Linux
./ss_4.9.0
State      Recv-Q Send-Q Local Address:Port                 Peer Address:Port                
UNCONN     0      0          *:icmp                     *:*                    
UNCONN     0      0         :::ipv6-icmp               :::*                    
State      Recv-Q Send-Q Local Address:Port                 Peer Address:Port                
UNCONN     0      0          *:icmp                     *:*                    
UNCONN     0      0         :::ipv6-icmp               :::*                    
./ss_4.20.0
State    Recv-Q    Send-Q       Local Address:Port         Peer Address:Port    
State    Recv-Q   Send-Q      Local Address:Port            Peer Address:Port   
UNCONN   0        0                 0.0.0.0:icmp                 0.0.0.0:*      
UNCONN   0        0                       *:ipv6-icmp                  *:*      
./ss_5.10.0
State   Recv-Q   Send-Q     Local Address:Port     Peer Address:Port  Process   
State   Recv-Q  Send-Q   Local Address:Port         Peer Address:Port  Process  
UNCONN  0       0              0.0.0.0:icmp              0.0.0.0:*              
UNCONN  0       0                    *:ipv6-icmp               *:*              
user@machine:~$ # [kernel change, reboot, etc.]
user@machine:~$ uname -a; for file in ./ss_{4.9.0,4.20.0,5.10.0}; do echo $file; $file -awp; PROC_NET_RAW=/proc/net/raw $file -awp; done
Linux (none) 4.19.0-16-rt-amd64 #1 SMP PREEMPT RT Debian 4.19.181-1 (2021-03-19) x86_64 GNU/Linux
./ss_4.9.0
State      Recv-Q Send-Q Local Address:Port                 Peer Address:Port                
UNCONN     0      0          *:icmp                     *:*                     users:(("ping",pid=272,fd=3))
UNCONN     0      0         :::ipv6-icmp               :::*                     users:(("ping",pid=272,fd=4))
State      Recv-Q Send-Q Local Address:Port                 Peer Address:Port                
UNCONN     0      0          *:icmp                     *:*                     users:(("ping",pid=272,fd=3))
UNCONN     0      0         :::ipv6-icmp               :::*                     users:(("ping",pid=272,fd=4))
./ss_4.20.0
State    Recv-Q   Send-Q      Local Address:Port            Peer Address:Port                                                                                   
UNCONN   0        0                 0.0.0.0:icmp                 0.0.0.0:*       users:(("ping",pid=272,fd=3))                                                  
UNCONN   0        0                       *:ipv6-icmp                  *:*       users:(("ping",pid=272,fd=4))                                                  
State    Recv-Q   Send-Q      Local Address:Port            Peer Address:Port                                                                                   
UNCONN   0        0                 0.0.0.0:icmp                 0.0.0.0:*       users:(("ping",pid=272,fd=3))                                                  
UNCONN   0        0                       *:ipv6-icmp                  *:*       users:(("ping",pid=272,fd=4))                                                  
./ss_5.10.0
State  Recv-Q Send-Q Local Address:Port      Peer Address:PortProcess                       
UNCONN 0      0            0.0.0.0:icmp           0.0.0.0:*    users:(("ping",pid=272,fd=3))
UNCONN 0      0                  *:ipv6-icmp            *:*    users:(("ping",pid=272,fd=4))
State  Recv-Q Send-Q Local Address:Port      Peer Address:PortProcess                       
UNCONN 0      0            0.0.0.0:icmp           0.0.0.0:*    users:(("ping",pid=272,fd=3))
UNCONN 0      0                  *:ipv6-icmp            *:*    users:(("ping",pid=272,fd=4))
user@machine:~$ 
--MP_/bAmSQg92fnYYSRNZtpOhdHQ--
