Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DA436D08B
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 04:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237781AbhD1C3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 22:29:49 -0400
Received: from mail.as397444.net ([69.59.18.99]:35338 "EHLO mail.as397444.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235901AbhD1C3s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 22:29:48 -0400
Received: by mail.as397444.net (Postfix) with UTF8SMTPSA id 530FE559C09;
        Wed, 28 Apr 2021 02:29:03 +0000 (UTC)
X-DKIM-Note: Keys used to sign are likely public at https://as397444.net/dkim/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mattcorallo.com;
        s=1619575263; t=1619576943;
        bh=uoElVMvzWf0yTWv6ifdIp3u4Ka8rvsdR/7kJRQft+Kk=;
        h=Date:To:Cc:From:Subject:From;
        b=xWFUiR+wsR8dwvp+aF43MOK8jGf+RyUIepieiQrKJtaUtanpyalnkpsN3eDDFCmXy
         nw+KJeKkAZ/0h47MyHNPlsEI2qKD5OFs7qw3pado16Qr2VB6gR1P8TtK8ZX1BDXxET
         E+tnBoaylilex6Uj7PYoYXKaNCgl4GzJSnb3mVErslUE1xRWYMv/DaWPr/6yCQ9E7z
         +sf2RkPlBO0qms2/EELGXtOiZb4RzVvJ+yhAkGlO6MeA3WMq0xXo4i5FA8niBQkaHZ
         riZQkCAapNUuV2h4uXDBAQM2LfH+RyC74SLxbqwWDSD35hD/TWxK0aE3cBSXY8sw5n
         FAVySmUG2xvzA==
Message-ID: <d840ddcf-07a6-a838-abf8-b1d85446138e@bluematt.me>
Date:   Tue, 27 Apr 2021 22:29:03 -0400
MIME-Version: 1.0
Content-Language: en-US
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        Keyu Man <kman001@ucr.edu>
From:   Matt Corallo <netdev-list@mattcorallo.com>
Subject: [PATCH net-next] Reduce IP_FRAG_TIME fragment-reassembly timeout to
 1s, from 30s
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
fragment reassembly buffer (across all senders) exceeds
net.ipv4.ipfrag_high_thresh (or the equivalent for IPv6), it
silently drops all future fragments fragments until the timers on
the original expire.

All the way in 2021, these numbers feel almost comical. The default
buffer size for fragmentation reassembly is hard-coded at 4MiB as
`net->ipv4.fqdir->high_thresh = 4 * 1024 * 1024;` capping a host at
1.06Mb/s of lost fragments before all fragments received on the
host are dropped (with independent limits for IPv6).

At 1.06Mb/s of lost fragments, we move from DoS attack threshold to
real-world scenarios - at moderate loss rates on consumer networks
today its fairly easy to hit this, causing end hosts with their MTU
(mis-)configured to fragment to have nearly 10-20 second blocks of
100% packet loss.

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
  #define IP_MF        0x2000        /* Flag: "More Fragments"    */
  #define IP_OFFSET    0x1FFF        /* "Fragment Offset" part    */

-#define IP_FRAG_TIME    (30 * HZ)        /* fragment lifetime    */
+#define IP_FRAG_TIME    (1 * HZ)        /* fragment lifetime    */

  struct msghdr;
  struct net_device;
-- 
2.30.2
