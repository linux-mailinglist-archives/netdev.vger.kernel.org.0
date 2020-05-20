Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A86C1DBDE5
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 21:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgETTWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 15:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgETTWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 15:22:30 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB010C061A0E;
        Wed, 20 May 2020 12:22:30 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ci21so1775903pjb.3;
        Wed, 20 May 2020 12:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Di5GhhIVk5+nln0iwOVokfXWhv8Y+Qgt7aCSLcBIvXI=;
        b=OMobGvX6GuqmTRQPro3ahC3dGlOzclyXLO2yxPghXuQ9W+1URuCc29EFet3q1w6YO2
         dFFHDwKXzmFT7LNb6l0qUA1iE4ORfSXr1sAjA5hrNSbUllrgrKIk4jUWXjMEbINtpx1E
         Gd+tdPYsAGOhcB5ix8AngfA424w0udgtWXa3bGb4/9SZS9VA82gw2rtql4Kt9W2WysF1
         yQkNn0ST6nHEZ7TgcD/WPdUBYX5wtUzu/bfkRI/hSUgHsyoQ01nn3wze6OtaePRyTMCX
         +IrJo0T8AO49MyJP+FSWdh2B5QlMBfU144+YNyc6m415w1Hzacnh4MLnBKEA1o22MjNb
         TrmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Di5GhhIVk5+nln0iwOVokfXWhv8Y+Qgt7aCSLcBIvXI=;
        b=ZxEaCrczOLiizfkvts2XbDajUbhsja3xZrvVj6fTvtBgqSY7hq0xLEi0gDrnW5Ior/
         keAbmNDKNm7es4fkiTH/7HWGHoA/U6XqHnRDZn0MNaJc0CyprDmpzLsCRdvmgOelmAxm
         nIWSM8FVcP8fN4up5KcXfzxINry6rdgdi8B0seDMFz0hKpc+G0ijiPJZO0oFTZnrd541
         8ZC33swE0WnOApjv4n5rrKhqW/Z5NtuAlQ0gGCPuwlxiasDHyzvJsVQzkLmUE5mM4sKS
         OGOIIII1u2ePmZ7PfImlPOMW4ve1cVS5W5pFV0tJ3P1Q0evfajQ3EXaYbjp5DV8N/kEZ
         r/3w==
X-Gm-Message-State: AOAM53092hCbeBveKEfCKLpzJv82yi6T8SleSU5fp8J6FbHY/4mUtLFE
        CGfI4NQbI+OhuoxITGRW8rc=
X-Google-Smtp-Source: ABdhPJyMF5iHn2a51GFWDNoICicGKSj5Zj5BnzcCLs/U/64onI9lZLPfUp4pcA0rfnYeQyXLM+tCZQ==
X-Received: by 2002:a17:902:8b84:: with SMTP id ay4mr6052074plb.167.1590002550296;
        Wed, 20 May 2020 12:22:30 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id 62sm2762424pfc.204.2020.05.20.12.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 12:22:29 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com
Subject: [PATCH bpf-next v5 13/15] xdp: simplify xdp_return_{frame,frame_rx_napi,buff}
Date:   Wed, 20 May 2020 21:21:01 +0200
Message-Id: <20200520192103.355233-14-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200520192103.355233-1-bjorn.topel@gmail.com>
References: <20200520192103.355233-1-bjorn.topel@gmail.com>
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

