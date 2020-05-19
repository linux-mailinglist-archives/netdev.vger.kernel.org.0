Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16DB91D92CA
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 10:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728685AbgESI6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 04:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgESI6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 04:58:39 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F4DC061A0C;
        Tue, 19 May 2020 01:58:39 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 23so6214139pfy.8;
        Tue, 19 May 2020 01:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Di5GhhIVk5+nln0iwOVokfXWhv8Y+Qgt7aCSLcBIvXI=;
        b=WC4KbSxD5vQiCm0fzHRjWGZA46Ir3F3gluza2uwvYErl9HYAiwTFs662jfopqRE8TU
         R6xjEVv4kY58FVWjmM/3M/mRjsH9oebnpslyV1KrFByA9iU1XBXskdFw1wNCgXIMHOcy
         LGWPFb8LikcZ2hfPWVgy/TbbBY902UsEQYy363y6sgwznKdJeHJV6gSr6wUCsL/NOYsu
         4H8mod9BDMVMuUMlkRJr1ufXDM0JMdyV76AVyHfPCMvLVBJvllDvqXuJa6+KBMbnY/Xb
         R7Vqkn7NrF+95ozHR25HSLacWWJ+D0pQoJMjphv8htDRdlkGrHxQX30jOwJ7zqX8jDZd
         E4Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Di5GhhIVk5+nln0iwOVokfXWhv8Y+Qgt7aCSLcBIvXI=;
        b=Zd96RiZdzqL4LiyvxK2M29SNpBxWITpqR7ABINkJe0W8maHMIy2/nS8SGXZCQX95SI
         9Fn2WzgFOjQQnHq+uQ4qcFmt6pIbzZFkUKHbPWPmiGgIuhq7kocsbJmiKRM8B8P+HeAJ
         d4bzAjiCF9BCOafKDHkZWiAub/9zjWubpzEgPB5h29DQUP2zBAvAFz1PoMsU9w+NT5OQ
         MIlbFvCu9O9jGis2IqWMKFYc5qwj/HCDOt9ew8ziCYI0v8jLe7/t52rbP0jyfZgCxfAI
         FmgJYuF2s29+7lEjyf6imX7dZT6t2CJcbSKvAMgEL/qg27v2unl3sCaZeOL0rKnUitNm
         laTQ==
X-Gm-Message-State: AOAM533OIwqG3Ig7tgaXJmb56oSNlqSYT3t+78zF8bFcFk51b3aaIlBt
        d4+wUPgp+RCXQl7hYDl3cfo=
X-Google-Smtp-Source: ABdhPJytjqCWh6vH1VOWy3zT+RrfZb/Ubkw55YYDeVrR6FOf8UGoY66fYYSl7M3y4k0gWzSNh7wTZQ==
X-Received: by 2002:aa7:9302:: with SMTP id 2mr10965933pfj.164.1589878718907;
        Tue, 19 May 2020 01:58:38 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.45])
        by smtp.gmail.com with ESMTPSA id k18sm5765748pfg.217.2020.05.19.01.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 01:58:38 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com
Subject: [PATCH bpf-next v3 13/15] xdp: simplify xdp_return_{frame,frame_rx_napi,buff}
Date:   Tue, 19 May 2020 10:57:22 +0200
Message-Id: <20200519085724.294949-14-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200519085724.294949-1-bjorn.topel@gmail.com>
References: <20200519085724.294949-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The xdp_return_{frame,frame_rx_napi,buff} function are never used,
except in xdp_convert_zc_to_xdp_frame(), by the MEM_TYPE_XSK_BUFF_POOL
memory type.

To simplify and reduce code, change so that
xdp_convert_zc_to_xdp_frame() calls xsk_buff_free() directly since the
type is know, and remove MEM_TYPE_XSK_BUFF_POOL from the switch
statement in __xdp_return() function.

Suggested-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/core/xdp.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index a8c2f243367d..90f44f382115 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -335,10 +335,11 @@ EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_mem_model);
  * scenarios (e.g. queue full), it is possible to return the xdp_frame
  * while still leveraging this protection.  The @napi_direct boolean
  * is used for those calls sites.  Thus, allowing for faster recycling
- * of xdp_frames/pages in those cases.
+ * of xdp_frames/pages in those cases. This path is never used by the
+ * MEM_TYPE_XSK_BUFF_POOL memory type, so it's explicitly not part of
+ * the switch-statement.
  */
-static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
-			 struct xdp_buff *xdp)
+static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct)
 {
 	struct xdp_mem_allocator *xa;
 	struct page *page;
@@ -360,33 +361,29 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
 		page = virt_to_page(data); /* Assumes order0 page*/
 		put_page(page);
 		break;
-	case MEM_TYPE_XSK_BUFF_POOL:
-		/* NB! Only valid from an xdp_buff! */
-		xsk_buff_free(xdp);
-		break;
 	default:
 		/* Not possible, checked in xdp_rxq_info_reg_mem_model() */
+		WARN(1, "Incorrect XDP memory type (%d) usage", mem->type);
 		break;
 	}
 }
 
 void xdp_return_frame(struct xdp_frame *xdpf)
 {
-	__xdp_return(xdpf->data, &xdpf->mem, false, NULL);
+	__xdp_return(xdpf->data, &xdpf->mem, false);
 }
 EXPORT_SYMBOL_GPL(xdp_return_frame);
 
 void xdp_return_frame_rx_napi(struct xdp_frame *xdpf)
 {
-	__xdp_return(xdpf->data, &xdpf->mem, true, NULL);
+	__xdp_return(xdpf->data, &xdpf->mem, true);
 }
 EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
 
 void xdp_return_buff(struct xdp_buff *xdp)
 {
-	__xdp_return(xdp->data, &xdp->rxq->mem, true, xdp);
+	__xdp_return(xdp->data, &xdp->rxq->mem, true);
 }
-EXPORT_SYMBOL_GPL(xdp_return_buff);
 
 /* Only called for MEM_TYPE_PAGE_POOL see xdp.h */
 void __xdp_release_frame(void *data, struct xdp_mem_info *mem)
@@ -467,7 +464,7 @@ struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp)
 	xdpf->metasize = metasize;
 	xdpf->mem.type = MEM_TYPE_PAGE_ORDER0;
 
-	xdp_return_buff(xdp);
+	xsk_buff_free(xdp);
 	return xdpf;
 }
 EXPORT_SYMBOL_GPL(xdp_convert_zc_to_xdp_frame);
-- 
2.25.1

