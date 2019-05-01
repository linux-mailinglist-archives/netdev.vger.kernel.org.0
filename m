Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60F5510977
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 16:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfEAOpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 10:45:07 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49392 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727092AbfEAOpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 10:45:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vemidzzB3WY/5PjAc5z5G1RZBRF0gJ18TRUKik+lPW0=; b=BPgD4kuzfEvGjBGlv56kr1ntR
        +qXDNG32ORRUh0lSqJK6TVvmxwaznFq8ClRIBlp7Ku2bS5NVafOPQTQeQtcYy0R8KZad0ndnG1sWH
        bGUJh95yjoD694PGiaiy81ECoFS4g13WhtSrPwwFzuIxr5EqaxTVW9KSrqdE0mSMmnWM+1NsSbrF8
        uUp+xArHh5TbNx7Ifvha5Jv2hOwZTRQ5tCWZlP5ehNALniBjQdwPAN9KKEee0pcIsvSu4Cy/EDZnv
        H+YoT14faffK//XsHobK19YTT/Zw7PGXShIOWSogeYpX/BbeHIF3c5d1CjVDlIe14zS+hMRIvIVk/
        Vf5SHLpVA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hLqTj-00025O-Hp; Wed, 01 May 2019 14:44:59 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH v2 1/7] net: Increase the size of skb_frag_t
Date:   Wed,  1 May 2019 07:44:51 -0700
Message-Id: <20190501144457.7942-2-willy@infradead.org>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190501144457.7942-1-willy@infradead.org>
References: <20190501144457.7942-1-willy@infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

To increase commonality between block and net, we are going to replace
the skb_frag_t with the bio_vec.  This patch increases the size of
skb_frag_t on 32-bit machines from 8 bytes to 12 bytes.  The size is
unchanged on 64-bit machines.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/skbuff.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9027a8c4219f..23f05c64aa31 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -318,13 +318,8 @@ struct skb_frag_struct {
 	struct {
 		struct page *p;
 	} page;
-#if (BITS_PER_LONG > 32) || (PAGE_SIZE >= 65536)
 	__u32 page_offset;
 	__u32 size;
-#else
-	__u16 page_offset;
-	__u16 size;
-#endif
 };
 
 /**
-- 
2.20.1

