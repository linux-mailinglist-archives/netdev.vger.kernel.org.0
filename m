Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564D73FE45A
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 22:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243789AbhIAU6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 16:58:39 -0400
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:43641 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243757AbhIAU6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 16:58:37 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Sep 2021 16:58:37 EDT
Received: from cust-b66e5d83 ([IPv6:fc0c:c157:b88d:62c6:5e3c:5f07:82d0:1b4])
        by smtp-cloud8.xs4all.net with ESMTPA
        id LXBfmCPqBy7WyLXBgm5u0n; Wed, 01 Sep 2021 22:50:24 +0200
Received: from localhost (localhost [127.0.0.1])
        by keetweej.vanheusden.com (Postfix) with ESMTP id 6812E1621D5
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 22:50:23 +0200 (CEST)
Received: from keetweej.vanheusden.com ([127.0.0.1])
        by localhost (mauer.intranet.vanheusden.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id h4aRGA2H5Vrw for <netdev@vger.kernel.org>;
        Wed,  1 Sep 2021 22:50:18 +0200 (CEST)
Received: from belle.intranet.vanheusden.com (belle.intranet.vanheusden.com [192.168.64.100])
        by keetweej.vanheusden.com (Postfix) with ESMTP id 0F39F1621A3
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 22:42:05 +0200 (CEST)
Received: by belle.intranet.vanheusden.com (Postfix, from userid 1000)
        id 0091D162F75; Wed,  1 Sep 2021 22:42:04 +0200 (CEST)
Date:   Wed, 1 Sep 2021 22:42:04 +0200
From:   folkert <folkert@vanheusden.com>
To:     netdev@vger.kernel.org
Subject: masquerading AFTER first packet
Message-ID: <20210901204204.GB3350910@belle.intranet.vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Reply-By: Wed 01 Sep 2021 07:11:01 PM CEST
User-Agent: Mutt/1.10.1 (2018-07-13)
X-CMAE-Envelope: MS4xfCRgFVbG/bXUQwhyTULWpQcc9VFmWpOlb9xfcVbRjQXKBEaHyKVX9GbB7WbyWdrvA5izs8f2kNnKeYRHgdgJHyMjLroaR2N20ppOpTjpSIDifTQEbtw2
 BWEd/2Yu+TrWFdnLSakxc62t/hUqaOp09zMeouWyqCvbO8nxIWmey44CSGA9/2yUbkGam9145FFbxBDfejTbTNWznvjgW5rJBI29xV1scCt0RDrwY5nVqX8X
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm seeing something strange. I'm doing an snmpwalk on an snmp server of
mine (behing DNAT) , and after the first response it goes into a timeout.
I did a tcpdump and saw this:

1630528031.843264 IP 185.243.112.54.38377 > 37.34.63.177.161: GetNextRequest(23)  .1.3.6.1
1630528031.843924 IP 37.34.63.177.161 > 185.243.112.54.38377: GetResponse(34)  .1.3.6.1.2=0   <-- ok
1630528031.846950 IP 185.243.112.54.38377 > 37.34.63.177.161: GetNextRequest(24)  .1.3.6.1.2
1630528031.847415 IP 192.168.4.2.161 > 185.243.112.54.38377: GetResponse(35)  .1.3.6.1.2.1=0  <-- fail
1630528032.847649 IP 185.243.112.54.38377 > 37.34.63.177.161: GetNextRequest(24)  .1.3.6.1.2
1630528032.848081 IP 192.168.4.2.161 > 185.243.112.54.38377: GetResponse(35)  .1.3.6.1.2.1=0  <-- fail
...

What happens here: 192.168.4.2.161 is the snmp-server. It is
portforwarded by 37.34.63.177 and also masqueraded. All is fine for the
first request/response, after that as you see the internal ip address
is outputted (which is incorrect of course).

I thought that maybe I had the nat-connection tracking wrong but
everywhere on the internet it is written like this:

iptables -t nat -A PREROUTING -i eth0 -p udp --dport 161 -j LOG --log-prefix "DNAT: " --log-level 4                                    
iptables -t nat -A PREROUTING -i eth0 -p udp --dport 161 -j DNAT --to 192.168.4.2:161                                                  
iptables -A FORWARD -d 192.168.4.2 -p udp --dport 161 -j LOG --log-prefix "FWD: " --log-level 4                                          
iptables -A FORWARD -d 192.168.4.2 -p udp --dport 161 -j ACCEPT      

iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth1 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT

eth0 is the interface to the world, eth1 to the internal system.
An example pcap trace file is at: https://vps001.vanheusden.com/~folkert/masq.pcap

Also dmesg says:

[Wed Sep  1 22:40:08 2021] DNAT: IN=eth0 OUT= MAC=52:54:00:65:21:38:0c:86:10:b5:91:e0:08:00 SRC=185.243.112.54 DST=37.34.63.177 LEN=66 TOS=0x00 PREC=0x00 TTL=55 ID=32612 DF PROTO=UDP SPT=39397 DPT=161 LEN=46 
[Wed Sep  1 22:40:08 2021] FWD: IN=eth0 OUT=eth1 MAC=52:54:00:65:21:38:0c:86:10:b5:91:e0:08:00 SRC=185.243.112.54 DST=192.168.4.2 LEN=66 TOS=0x00 PREC=0x00 TTL=54 ID=32612 DF PROTO=UDP SPT=39397 DPT=161 LEN=46 
[Wed Sep  1 22:40:08 2021] FWD: IN=eth0 OUT=eth1 MAC=52:54:00:65:21:38:0c:86:10:b5:91:e0:08:00 SRC=185.243.112.54 DST=192.168.4.2 LEN=67 TOS=0x00 PREC=0x00 TTL=54 ID=32613 DF PROTO=UDP SPT=39397 DPT=161 LEN=47 
...
Notice that 'DNAT' is logged once while the FWD for each packet.


Any suggestions?
