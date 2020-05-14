Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77111D2A5B
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 10:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgENIiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 04:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725925AbgENIiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 04:38:21 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFBAC061A0C;
        Thu, 14 May 2020 01:38:21 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mq3so12263166pjb.1;
        Thu, 14 May 2020 01:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tz8I1ofrUYKZZa7+UlEDx8Su4gDS1jJlBTe3ya5G/ds=;
        b=hKpPWNqJiqjzoRbGHyoTNqtVyelNYSMj+PQL12MmxWqBhJ1ddM+R8S6RcygowUnjb3
         5Wv3apRllA69FMnVlXng0x3LHVudKWWiTr1M4cwBYyYUl0Iu/deVnZDoFXky7FiUa5Zs
         Xq108HpBbrFtVrn3dxf0sjvzJEEXdb9NIcesRgiuIYMAOkF4R4mo7KpaElGejjRefUPA
         JkWUavAkEeaHjqRJvuaW1SuAHYHoSZ44hPBk7mnTNlV8WgAcS3fix97zxuV1VP28U6lM
         7CdddA+BeVa+7LQzUB8+15uvPH1LrIdl1IuQpdHgTNmvjwToqbRJF9dT47tTr9PKr41U
         xiuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tz8I1ofrUYKZZa7+UlEDx8Su4gDS1jJlBTe3ya5G/ds=;
        b=ImESN74kwhpoC5FbWy6QtKCwhIU70uAdwT5o1Q6NmzBjB3hp0lSZAvmzFI5a13kCCF
         u3joJNtIIaGlO5IwzqI7sgOvlfCbedE/M2xigX6lD9AZYnBr476BxJweBqih+9KSYJZa
         A9B/Lx986zx5vS4acLDMODOPBPXtOJ1ZbOvcb4U186hIle4lbNg53ocnBxn5YkMw9pcV
         HoFUQylZHdItf8B8IMvgXOFJ5rLCRVrBdWvz67brJat2ZVIU8N8RDDPtK++uHBt006ck
         pv1x/9/+pSsSwZJQcYBO96HwPnb8FpGZ7SNQ8zKwFtOpARWYnRw1XaihKH3NJ/oTNGWu
         aOng==
X-Gm-Message-State: AGi0PubcmeCEO0EnzYOmKsvuPXXolJ+06pEvjiAes+vMYt8qc0pWYGDj
        8/5W1gwwdShDIFeRco2dtYA=
X-Google-Smtp-Source: APiQypJcVBu+NrqAAZ+F3SpqkxXA5p5/o1y6WzTWKZurO9Y/489tY77rqWaU1Cu+ZUHR4ZLWmLd1UQ==
X-Received: by 2002:a17:90a:b00d:: with SMTP id x13mr39569825pjq.227.1589445500930;
        Thu, 14 May 2020 01:38:20 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id k4sm1608058pgg.88.2020.05.14.01.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 01:38:20 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com
Subject: [PATCH bpf-next v2 12/14] xdp: simplify xdp_return_{frame,frame_rx_napi,buff}
Date:   Thu, 14 May 2020 10:37:08 +0200
Message-Id: <20200514083710.143394-13-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200514083710.143394-1-bjorn.topel@gmail.com>
References: <20200514083710.143394-1-bjorn.topel@gmail.com>
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
index 11273c976e19..7ab1f9014c5e 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -334,10 +334,11 @@ EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_mem_model);
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
@@ -359,33 +360,29 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
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
@@ -466,7 +463,7 @@ struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp)
 	xdpf->metasize = metasize;
 	xdpf->mem.type = MEM_TYPE_PAGE_ORDER0;
 
-	xdp_return_buff(xdp);
+	xsk_buff_free(xdp);
 	return xdpf;
 }
 EXPORT_SYMBOL_GPL(xdp_convert_zc_to_xdp_frame);
-- 
2.25.1

