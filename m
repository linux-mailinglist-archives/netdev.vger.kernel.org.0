Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECD152078D
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 00:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbiEIW1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 18:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiEIW1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 18:27:34 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30AB520F76C
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 15:23:37 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id p8so13402137pfh.8
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 15:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B6lJSTUPK4LHqvVs3+0mu34hyeoz1R5gi+G+noJFjDQ=;
        b=QKz5cXrabeJM/9cOzId9Da/XNbh9N+G2Dnhor7rHG/pTcEFq5H7BePkcI+UkIpBACL
         yvesVYPLSDibRpSRO+s1JCZTFp5CYCK61QMluHxipy4P+7vVZbbSNhwjCjmkFiuKjQ9v
         pU6sEv/nSISnngWIOm6bKYfUfelGehEyXgc1o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B6lJSTUPK4LHqvVs3+0mu34hyeoz1R5gi+G+noJFjDQ=;
        b=KswE7FA+DSETvyyO8w3VxVzVsE+SFMZa5Zg+DXKV4XHQnEsIwqKEAr0zdR1LU/totl
         8ODIcafMgVgQ/d9ZXAI/hF8nimCaP1ebLDOnDevvSRiD1YBoF9JWA7B6JUw/IgKTjxbF
         P2+pWMkmBh+UtCLM2QtEUuh8OascGortM+ND+4jEbxBei8MGPFNJy788t4a+1GTAkwFo
         iQHQsDyxGOOtxgkEYMbu88ovUEoEuNUbk/c/25qUG/Y9eDxJRUjrdjBf431mqoivfeFa
         FoqrtWWQMTM8hpXKCO6Yu+Rh0nyjJ6K60LMD5kKfF+7eM5kvDOtIJvnRLktPUw+kjbUT
         vlqQ==
X-Gm-Message-State: AOAM530YfTAc9h5IaEiEURIwWKLmYEPF2mwQvEDExupeDqkNE6Qwj3DM
        Ca6g4U2xZ+z414N7lsFJptPa5w==
X-Google-Smtp-Source: ABdhPJxQzBV0HOL9DNGips6oFNJlye+ulI3x+eM5zG5rRMkyxudRHIk5DpV2O1AP92N3/ZQwlq5sZg==
X-Received: by 2002:a63:6bc2:0:b0:3c2:13cc:1dec with SMTP id g185-20020a636bc2000000b003c213cc1decmr14797792pgc.263.1652135016720;
        Mon, 09 May 2022 15:23:36 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g1-20020a170902e38100b0015e8d4eb1c8sm411488ple.18.2022.05.09.15.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 15:23:36 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Du Cheng <ducheng2@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vlastimil Babka <vbabka@suse.cz>,
        William Kucharski <william.kucharski@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] niu: Add "overloaded" struct page union member
Date:   Mon,  9 May 2022 15:23:33 -0700
Message-Id: <20220509222334.3544344-1-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5492; h=from:subject; bh=PZUzpl+cA9XKRfbb62HEvQKuPT5M7W5xUTbCCp1/MQQ=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBieZRlI3XZnkveDjJDfdSBXN0Hd8NE1TQW3FKORqB9 1XFDWf+JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYnmUZQAKCRCJcvTf3G3AJtD1D/ 9lWdJUTLAb2wBn5Kt21IXdFLuBgz9SUbBdid2456Gkq4Ox8iv93kryUidaJtQdQoIPYGDLQspQ09xB oxPVIzxO2gqwyxgpZ9GDGHQaNlrDQZo+wSN1BsJ4eVPO26Jk+MkPPwJLHFR/zb6P3QxfNok3ar+Fv9 9qwucwpTWAyD6CVDyCAEHYoawPXQ2W4+g2EnTWi3voBmpJ515OJXTqjTw63da4/2hte2X/ZvspnLLg wPKsr3PGhgl4qagNQ5noAp5s3g+z2Rk6oaCmrtJXKSDSQE2R8iANDaYMW6LDcZ45vhUhs/S/EWYCaQ eD5Zro4RRp50dV2Vhjx46uv914HimuxHAHXZiFlByueA7U4jxShniCLFja0qeKKkZh5vwwcN/Vk3Q5 qNQXS1Kq4gbg17e42eDpMRBk28MTYyWp5xgn56iM0hnwMe5WVOko7r0IS+nG4h4nDRUgP5u6RWWw7d VG29KCjyVy25hZgVRHi/ybdTGFp0IqFuHuCf183OtZ/obeD0hi3bSNQ14W9WR9x326oqppRBg27l+d iaeCdnmvs0s4UjntNbytxOOxZ6xqWecCJuIeODluaR6MhStaDVpqv/gIyBCeydTc7LzNwB0hYlmx7p uLE+NL94SQmh2X/CtRJQrtJ89Iicjoe7yGVSYnCZHAKCDR8pEYBVtMr7JLCw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The randstruct GCC plugin gets upset when it sees struct addresspace
(which is randomized) being assigned to a struct page (which is not
randomized):

drivers/net/ethernet/sun/niu.c: In function 'niu_rx_pkt_ignore':
drivers/net/ethernet/sun/niu.c:3385:31: note: randstruct: casting between randomized structure pointer types (ssa): 'struct page' and 'struct address_space'

 3385 |                         *link = (struct page *) page->mapping;
      |                         ~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

It looks like niu.c is looking for an in-line place to chain its
allocated pages together and is overloading the "mapping" member, as it
is unused.

I expect this change will be met with alarm, given the strange corner
case it is. I wonder if, instead of "mapping", niu.c should instead be
using the "private" member? It wasn't clear to me if this was safe, and
I have no hardware to test with.

No meaningful machine code changes result after this change, and source
readability is improved.

Drop the randstruct exception now that there is no "confusing" cross-type
assignment.

Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Du Cheng <ducheng2@gmail.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/sun/niu.c                | 17 ++++++++---------
 include/linux/mm_types.h                      |  7 +++++--
 scripts/gcc-plugins/randomize_layout_plugin.c |  2 --
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 42460c0885fc..75f0a1ce955b 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -3300,7 +3300,7 @@ static void niu_hash_page(struct rx_ring_info *rp, struct page *page, u64 base)
 	unsigned int h = niu_hash_rxaddr(rp, base);
 
 	page->index = base;
-	page->mapping = (struct address_space *) rp->rxhash[h];
+	page->overloaded = rp->rxhash[h];
 	rp->rxhash[h] = page;
 }
 
@@ -3382,11 +3382,11 @@ static int niu_rx_pkt_ignore(struct niu *np, struct rx_ring_info *rp)
 		rcr_size = rp->rbr_sizes[(val & RCR_ENTRY_PKTBUFSZ) >>
 					 RCR_ENTRY_PKTBUFSZ_SHIFT];
 		if ((page->index + PAGE_SIZE) - rcr_size == addr) {
-			*link = (struct page *) page->mapping;
+			*link = page->overloaded;
 			np->ops->unmap_page(np->device, page->index,
 					    PAGE_SIZE, DMA_FROM_DEVICE);
 			page->index = 0;
-			page->mapping = NULL;
+			page->overloaded = NULL;
 			__free_page(page);
 			rp->rbr_refill_pending++;
 		}
@@ -3451,11 +3451,11 @@ static int niu_process_rx_pkt(struct napi_struct *napi, struct niu *np,
 
 		niu_rx_skb_append(skb, page, off, append_size, rcr_size);
 		if ((page->index + rp->rbr_block_size) - rcr_size == addr) {
-			*link = (struct page *) page->mapping;
+			*link = page->overloaded;
 			np->ops->unmap_page(np->device, page->index,
 					    PAGE_SIZE, DMA_FROM_DEVICE);
 			page->index = 0;
-			page->mapping = NULL;
+			page->overloaded = NULL;
 			rp->rbr_refill_pending++;
 		} else
 			get_page(page);
@@ -3518,13 +3518,13 @@ static void niu_rbr_free(struct niu *np, struct rx_ring_info *rp)
 
 		page = rp->rxhash[i];
 		while (page) {
-			struct page *next = (struct page *) page->mapping;
+			struct page *next = page->overloaded;
 			u64 base = page->index;
 
 			np->ops->unmap_page(np->device, base, PAGE_SIZE,
 					    DMA_FROM_DEVICE);
 			page->index = 0;
-			page->mapping = NULL;
+			page->overloaded = NULL;
 
 			__free_page(page);
 
@@ -6440,8 +6440,7 @@ static void niu_reset_buffers(struct niu *np)
 
 				page = rp->rxhash[j];
 				while (page) {
-					struct page *next =
-						(struct page *) page->mapping;
+					struct page *next = page->overloaded;
 					u64 base = page->index;
 					base = base >> RBR_DESCR_ADDR_SHIFT;
 					rp->rbr[k++] = cpu_to_le32(base);
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 8834e38c06a4..1cd5a1a93916 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -95,8 +95,11 @@ struct page {
 					unsigned int mlock_count;
 				};
 			};
-			/* See page-flags.h for PAGE_MAPPING_FLAGS */
-			struct address_space *mapping;
+			union {
+				/* See page-flags.h for PAGE_MAPPING_FLAGS */
+				struct address_space *mapping;
+				void *overloaded;
+			};
 			pgoff_t index;		/* Our offset within mapping. */
 			/**
 			 * @private: Mapping-private opaque data.
diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index 727512eebb3b..38a8cf90f611 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -46,8 +46,6 @@ struct whitelist_entry {
 };
 
 static const struct whitelist_entry whitelist[] = {
-	/* NIU overloads mapping with page struct */
-	{ "drivers/net/ethernet/sun/niu.c", "page", "address_space" },
 	/* unix_skb_parms via UNIXCB() buffer */
 	{ "net/unix/af_unix.c", "unix_skb_parms", "char" },
 	{ }
-- 
2.32.0

