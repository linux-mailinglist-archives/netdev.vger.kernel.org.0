Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2DE3119B5
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 15:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfEBNFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 09:05:30 -0400
Received: from rs07.intra2net.com ([85.214.138.66]:41340 "EHLO
        rs07.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfEBNFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 09:05:30 -0400
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 May 2019 09:05:29 EDT
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by rs07.intra2net.com (Postfix) with ESMTPS id F2BA515001F6
        for <netdev@vger.kernel.org>; Thu,  2 May 2019 14:58:37 +0200 (CEST)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id B62F4858
        for <netdev@vger.kernel.org>; Thu,  2 May 2019 14:58:37 +0200 (CEST)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.54.20,VDF=8.15.28.254)
X-Spam-Status: 
X-Spam-Level: 0
Received: from rocinante.m.i2n (rocinante.m.i2n [172.16.1.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: smtp-auth-user)
        by mail.m.i2n (Postfix) with ESMTPSA id D0D6859E
        for <netdev@vger.kernel.org>; Thu,  2 May 2019 14:58:35 +0200 (CEST)
From:   Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
To:     netdev@vger.kernel.org
Subject: Re: [bisected regression] e1000e: "Detected Hardware Unit Hang"
Date:   Thu, 02 May 2019 14:58:35 +0200
Message-ID: <2623037.2OFtx9BLgF@rocinante.m.i2n>
In-Reply-To: <1970944.Bv0UlMJzsJ@storm>
References: <1719052.SGOfRAJhfQ@storm> <309B89C4C689E141A5FF6A0C5FB2118B78DDC307@ORSMSX101.amr.corp.intel.com> <1970944.Bv0UlMJzsJ@storm>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All.

While updating to kernel 4.19, we realised that a problem reported in 2015 for 
kernel 3.7 is still around. Please see this link for more details: https://
marc.info/?l=linux-netdev&m=142124954120315

Basically, when using the e1000e driver, each few minutes the following 
messages appear in dmesg or system log.

[12465.174759] e1000e 0000:00:19.0 eth0: Detected Hardware Unit Hang:
  TDH                  <c6>
  TDT                  <fb>
  next_to_use          <fb>
  next_to_clean        <c4>
buffer_info[next_to_clean]:
  time_stamp           <2e5e92>
  next_to_watch        <c6>
  jiffies              <2e67e8>
  next_to_watch.status <0>
MAC Status             <40080083>
PHY Status             <796d>
PHY 1000BASE-T Status  <7800>
PHY Extended Status    <3000>
PCI Status             <10>

Back in 2015, we applied a workaround that decreases the page size:

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 85ab7d7..9f0ef97 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2108,7 +2108,7 @@ static inline void __skb_queue_purge(struct 
sk_buff_head *list)
                kfree_skb(skb);
 }
 
-#define NETDEV_FRAG_PAGE_MAX_ORDER get_order(32768)
+#define NETDEV_FRAG_PAGE_MAX_ORDER get_order(4096)
 #define NETDEV_FRAG_PAGE_MAX_SIZE  (PAGE_SIZE << NETDEV_FRAG_PAGE_MAX_ORDER)
 #define NETDEV_PAGECNT_MAX_BIAS           NETDEV_FRAG_PAGE_MAX_SIZE
 

Testing kernel 4.19 with the same hardware showed the same problems, so we 
tried to adapt the old workaround to the current code:

diff -u -r -p linux-4.19.i686/net/core/sock.c linux-4.19.i686.e1000e/net/core/
sock.c
--- linux-4.19.i686/net/core/sock.c     2019-03-22 13:55:24.198266383 +0100
+++ linux-4.19.i686.e1000e/net/core/sock.c      2019-03-22 13:56:43.165765856 
+0100
@@ -2183,7 +2183,8 @@ static void sk_leave_memory_pressure(str
 }
 
 /* On 32bit arches, an skb frag is limited to 2^15 */
-#define SKB_FRAG_PAGE_ORDER    get_order(32768)
+/* Limit to 4096 instead of 32768 */
+#define SKB_FRAG_PAGE_ORDER    get_order(4096)
 
 /**
  * skb_page_frag_refill - check that a page_frag contains enough room


Unfortunately, this patch does not help with the "Unit Hang" messages anymore, 
the problem occurs with any page size.


Some insight in how to deal with this problem would be very much appreciated.

Thank you!





