Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4551F354619
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 19:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbhDERkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 13:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234136AbhDERkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 13:40:12 -0400
X-Greylist: delayed 117 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 05 Apr 2021 10:40:05 PDT
Received: from mail.as397444.net (mail.as397444.net [IPv6:2620:6e:a000:dead:beef:15:bad:f00d])
        by lindbergh.monkeyblade.net (Postfix) with UTF8SMTPS id D21EBC061756
        for <netdev@vger.kernel.org>; Mon,  5 Apr 2021 10:40:05 -0700 (PDT)
Received: by mail.as397444.net (Postfix) with UTF8SMTPSA id A380A51538D;
        Mon,  5 Apr 2021 17:38:06 +0000 (UTC)
X-DKIM-Note: Keys used to sign are likely public at https://as397444.net/dkim/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mattcorallo.com;
        s=1617642064; t=1617644286;
        bh=xN/rVOY63VaNmaYocf9pUPpZ5ZOM5G3OiapUGD3CPIo=;
        h=Date:To:Cc:From:Subject:From;
        b=0fVEw2tXnFPH/hgy9MyK6CUycv4b2cglVvZWIiSamGcO4n3L7Fhduuzj6zgydU9Vr
         eiXYKomVQIQgxUbpT8Rfj6Gmq5OoRyvZQJ/cN85P1aB8lQAj5FVBcKw/KR+EVcW32s
         bvGXy6XpPkemQNZ+aBVBwNZKyp2WPr1RzYjkNAd+zjhiVPxXJSAqpU0iDK/0GPX73f
         8GORMOHCsaKi2IvMuqgHsIQ/3bPDFnJFqiNgP1O+uyEa9QO2MS6u1urCPrIiKS0vyB
         H4hF8UGcF9lQPpVnEjHg7RLUU4CMm4GT7fMYUh0r7ahI+HzPC6HpLlwhzuKyz3RTdn
         irEWHWapbEHDw==
Message-ID: <c3d462dd-9b33-8c06-2de5-35ea1cc55139@bluematt.me>
Date:   Mon, 5 Apr 2021 13:38:06 -0400
MIME-Version: 1.0
Content-Language: en-US
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
From:   Matt Corallo <netdev-list@mattcorallo.com>
Subject: [PATCH RESEND] Reduce IP_FRAG_TIME fragment-reassembly timeout to 1s,
 from 30s
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The default IP reassembly timeout of 30 seconds predates git
history (and cursory web searches turn up nothing related to it).
The only relevant source cited in net/ipv4/ip_fragment.c is RFC
791 defining IPv4 in 1981. RFC 791 suggests allowing the timer to
increase on the receipt of each fragment (which Linux deliberately
does not do), with a default timeout for each fragment of 15
seconds. It suggests 15s to cap a 10Kb/s flow to a 150Kb buffer of
fragments.

When Linux receives a fragment, if the total memory used for the
fragment reassembly buffer (across all hosts) exceeds
net.ipv4.ipfrag_high_thresh (or the equivalent for IPv6), it
silently drops all future fragments fragments until the timers on
the original expire.

All the way in 2021, these numbers feel almost comical. The default
buffer size for fragmentation reassembly is hard-coded at 4MiB as
`net->ipv4.fqdir->high_thresh = 4 * 1024 * 1024;` capping a host at
1.06Mb/s of lost fragments before all fragments received on the
host are dropped (with independent limits for IPv6).

Reducing the default fragment timeout to 1sec gives us 32Mb/s of
fragments before we drop all fragments, which is certainly more in
line with today's network speeds than 1.06Mb/s, though an optimal
value may be still lower. Sadly, reducing it further requires a
change to the sysctl interface, as net.ipv4.ipfrag_time is only
specified in seconds.
---
   include/net/ip.h | 2 +-
   1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 2d6b985d11cc..f1473ac5a27c 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -135,7 +135,7 @@ struct ip_ra_chain {
   #define IP_MF		0x2000		/* Flag: "More Fragments"	*/
   #define IP_OFFSET	0x1FFF		/* "Fragment Offset" part	*/

-#define IP_FRAG_TIME	(30 * HZ)		/* fragment lifetime	*/
+#define IP_FRAG_TIME	(1 * HZ)		/* fragment lifetime	*/

   struct msghdr;
   struct net_device;
-- 
2.30.2
