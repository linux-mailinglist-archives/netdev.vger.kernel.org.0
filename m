Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1A0ABF4D
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 20:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436544AbfIFSXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 14:23:02 -0400
Received: from 2098.x.rootbsd.net ([208.79.82.66]:54014 "EHLO pilot.trilug.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404380AbfIFSXC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 14:23:02 -0400
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Sep 2019 14:23:02 EDT
Received: by pilot.trilug.org (Postfix, from userid 8)
        id 29F40581FE; Fri,  6 Sep 2019 14:13:57 -0400 (EDT)
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on pilot.trilug.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham version=3.3.2
Received: from michaelmarley.com (cpe-2606-A000-BFC0-90-509-B1D3-C76D-19C7.dyn6.twc.com [IPv6:2606:a000:bfc0:90:509:b1d3:c76d:19c7])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pilot.trilug.org (Postfix) with ESMTPSA id EB9E6581FB
        for <netdev@vger.kernel.org>; Fri,  6 Sep 2019 14:13:55 -0400 (EDT)
Received: from michaelmarley.com (localhost [127.0.0.1])
        by michaelmarley.com (Postfix) with ESMTP id E428118001F
        for <netdev@vger.kernel.org>; Fri,  6 Sep 2019 14:13:54 -0400 (EDT)
Received: from michaelmarley.com ([::1])
        by michaelmarley.com with ESMTPA
        id 2iaBN+Khcl1KGQIAnAHMIA
        (envelope-from <michael@michaelmarley.com>)
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 14:13:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 06 Sep 2019 14:13:54 -0400
From:   Michael Marley <michael@michaelmarley.com>
To:     netdev@vger.kernel.org
Subject: ixgbe: driver drops packets routed from an IPSec interface with a
 "bad sa_idx" error
User-Agent: Roundcube Webmail/1.4-rc1
Message-ID: <10ba81d178d4ade76741c1a6e1672056@michaelmarley.com>
X-Sender: michael@michaelmarley.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(This is also reported at 
https://bugzilla.kernel.org/show_bug.cgi?id=204551, but it was 
recommended that I send it to this list as well.)

I have a put together a router that routes traffic from several local 
subnets from a switch attached to an i82599ES card through an IPSec VPN 
interface set up with StrongSwan.  (The VPN is running on an unrelated 
second interface with a different driver.)  Traffic from the local 
interfaces to the VPN works as it should and eventually makes it through 
the VPN server and out to the Internet.  The return traffic makes it 
back to the router and tcpdump shows it leaving by the i82599, but the 
traffic never actually makes it onto the wire and I instead get one of

enp1s0: ixgbe_ipsec_tx: bad sa_idx=64512 handle=0

for each packet that should be transmitted.  (The sa_idx and handle 
values are always the same.)

I realized this was probably related to ixgbe's IPSec offloading 
feature, so I tried with the motherboard's integrated e1000e device and 
didn't have the problem.  I tried using ethtool to disable all the 
IPSec-related offloads (tx-esp-segmentation, esp-hw-offload, 
esp-tx-csum-hw-offload), but the problem persisted.  I then tried 
recompiling the kernel with CONFIG_IXGBE_IPSEC=n and that worked around 
the problem.

I was also able to find another instance of the same problem reported in 
Debian at https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=930443.  
That person seems to be having exactly the same issue as me, down to the 
sa_idx and handle values being the same.

If there are any more details I can provide to make this easier to track 
down, please let me know.

Thanks,

Michael Marley
