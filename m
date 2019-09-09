Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9CF3ADF1E
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 20:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732284AbfIISqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 14:46:01 -0400
Received: from 2098.x.rootbsd.net ([208.79.82.66]:48633 "EHLO pilot.trilug.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727014AbfIISqA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 14:46:00 -0400
Received: by pilot.trilug.org (Postfix, from userid 8)
        id 9337C583BF; Mon,  9 Sep 2019 14:45:59 -0400 (EDT)
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on pilot.trilug.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable version=3.3.2
Received: from michaelmarley.com (cpe-2606-A000-BFC0-90-509-B1D3-C76D-19C7.dyn6.twc.com [IPv6:2606:a000:bfc0:90:509:b1d3:c76d:19c7])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pilot.trilug.org (Postfix) with ESMTPSA id 9D536581E8;
        Mon,  9 Sep 2019 14:45:57 -0400 (EDT)
Received: from michaelmarley.com (localhost [127.0.0.1])
        by michaelmarley.com (Postfix) with ESMTP id 68FC1180248;
        Mon,  9 Sep 2019 14:45:56 -0400 (EDT)
Received: from michaelmarley.com ([::1])
        by michaelmarley.com with ESMTPA
        id I/JmGeSddl2rUAAAnAHMIA
        (envelope-from <michael@michaelmarley.com>); Mon, 09 Sep 2019 14:45:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 09 Sep 2019 14:45:56 -0400
From:   Michael Marley <michael@michaelmarley.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        steffen.klassert@secunet.com
Subject: Re: ixgbe: driver drops packets routed from an IPSec interface with a
 "bad sa_idx" error
In-Reply-To: <4caa4fb7-9963-99ab-318f-d8ada4f19205@pensando.io>
References: <10ba81d178d4ade76741c1a6e1672056@michaelmarley.com>
 <4caa4fb7-9963-99ab-318f-d8ada4f19205@pensando.io>
User-Agent: Roundcube Webmail/1.4-rc1
Message-ID: <fb63dec226170199e9b0fd1b356d2314@michaelmarley.com>
X-Sender: michael@michaelmarley.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-09-09 14:21, Shannon Nelson wrote:
> On 9/6/19 11:13 AM, Michael Marley wrote:
>> (This is also reported at 
>> https://bugzilla.kernel.org/show_bug.cgi?id=204551, but it was 
>> recommended that I send it to this list as well.)
>> 
>> I have a put together a router that routes traffic from several local 
>> subnets from a switch attached to an i82599ES card through an IPSec 
>> VPN interface set up with StrongSwan.  (The VPN is running on an 
>> unrelated second interface with a different driver.)  Traffic from the 
>> local interfaces to the VPN works as it should and eventually makes it 
>> through the VPN server and out to the Internet.  The return traffic 
>> makes it back to the router and tcpdump shows it leaving by the 
>> i82599, but the traffic never actually makes it onto the wire and I 
>> instead get one of
>> 
>> enp1s0: ixgbe_ipsec_tx: bad sa_idx=64512 handle=0
>> 
>> for each packet that should be transmitted.  (The sa_idx and handle 
>> values are always the same.)
>> 
>> I realized this was probably related to ixgbe's IPSec offloading 
>> feature, so I tried with the motherboard's integrated e1000e device 
>> and didn't have the problem.  I tried using ethtool to disable all the 
>> IPSec-related offloads (tx-esp-segmentation, esp-hw-offload, 
>> esp-tx-csum-hw-offload), but the problem persisted.  I then tried 
>> recompiling the kernel with CONFIG_IXGBE_IPSEC=n and that worked 
>> around the problem.
>> 
>> I was also able to find another instance of the same problem reported 
>> in Debian at 
>> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=930443.  That person 
>> seems to be having exactly the same issue as me, down to the sa_idx 
>> and handle values being the same.
>> 
>> If there are any more details I can provide to make this easier to 
>> track down, please let me know.
>> 
>> Thanks,
>> 
>> Michael Marley
> 
> Hi Michael,
> 
> Thanks for pointing this out.  The issue this error message is
> complaining about is that the handle given to the driver is a bad
> value.  The handle is what helps the driver find the right encryption
> information, and in this case is an index into an array, one array for
> Rx and one for Tx, each of which have up to 1024 entries.  In order to
> encode them into a single value, 1024 is added to the Tx values to
> make the handle, and 1024 is subtracted to use the handle later.  Note
> that the bad sa_idx is 64512, which happens to also be -1024; if the
> Tx handle given to ixgbe for xmit is 0, we subtract 1024 from that and
> get this bad sa_idx value.
> 
> That handle is supposed to be an opaque value only used by the
> driver.  It looks to me like either (a) the driver is not setting up
> the handle correctly when the SA is first set up, or (b) something in
> the upper levels of the ipsec code is clearing the handle value. We
> would need to know more about all the bits in your SA set up to have a
> better idea what parts of the ipsec code are being exercised when this
> problem happens.
> 
> I currently don't have access to a good ixgbe setup on which to
> test/debug this, and I haven't been paying much attention lately to
> what's happening in the upper ipsec layers, so my help will be
> somewhat limited.  I'm hoping the the Intel folks can add a little
> help, so I've copied Jeff Kirsher on this (they'll probably point back
> to me since I wrote this chunk :-) ).  I've also copied Stephen
> Klassert for his ipsec thoughts.
> 
> In the meantime, can you give more details on the exact ipsec rules
> that are used here, and are there any error messages coming from ixgbe
> regarding the ipsec rule setup that might help us identify what's
> happening?
> 
> Thanks,
> sln

Hi Shannon,

Thanks for your response!  I apologize, I am a bit of a newbie to IPSec 
myself, so I'm not 100% sure what is the best way to provide the 
information you need, but here is the (slightly-redacted) output of 
swanctl --list-sas first from the server and then from the client:

<servername>: #24, ESTABLISHED, IKEv2, 3cb75c180ee5dc68_i 
cc7dae551b603bb7_r*
   local  '<serverip>' @ <serverip>[4500]
   remote '<clientip>' @ <clientip>[4500]
   AES_GCM_16-256/PRF_HMAC_SHA2_512/ECP_384
   established 174180s ago
   <servername>: #110, reqid 12, INSTALLED, TUNNEL-in-UDP, 
ESP:AES_GCM_16-256/ECP_384
     installed 469s ago
     in  c51a0f11 (-|0x00000064), 1548864 bytes, 19575 packets,     6s 
ago
     out c3bd9741 (-|0x00000064), 23618807 bytes, 22865 packets,     7s 
ago
     local  0.0.0.0/0 ::/0
     remote 0.0.0.0/0 ::/0

<clientname>: #1, ESTABLISHED, IKEv2, 3cb75c180ee5dc68_i* 
cc7dae551b603bb7_r
   local  '<clientip>' @ <clientip>[4500]
   remote '<serverip>' @ <serverip>[4500]
   AES_GCM_16-256/PRF_HMAC_SHA2_512/ECP_384
   established 174013s ago
   <clientname>: #54, reqid 1, INSTALLED, TUNNEL-in-UDP, 
ESP:AES_GCM_16-256/ECP_384
     installed 303s ago, rekeying in 2979s, expires in 3657s
     in  c3bd9741 (-|0x00000064), 23178523 bytes, 20725 packets,     0s 
ago
     out c51a0f11 (-|0x00000064), 1429124 bytes, 17719 packets,     0s 
ago
     local  0.0.0.0/0 ::/0
     remote 0.0.0.0/0 ::/0

It might also be worth mentioning that I am using an xfrm interface to 
do "regular" routing rather than the policy-based routing that 
StrongSwan/IPSec normally uses. If there is anything else that would 
help more, I would be happy to provide it.

Just to be clear though, I'm not trying to run IPSec on the ixgbe 
interface at all.  The ixgbe adapter is being used to connect the router 
to the switch on the LAN side of the network.  IPSec is running on the 
WAN interface without any hardware acceleration (besides AES-NI).  The 
problem occurs when a computer on the LAN tries to access the WAN.  The 
outgoing packets work as expected and the incoming packets are routed 
back out through the ixgbe device toward the LAN client, but the driver 
drops the packets with the sa_idx error.

I hope this helps.

Thanks,

Michael
