Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4721DAF4B
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 11:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgETJtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 05:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgETJtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 05:49:35 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA37DC061A0E;
        Wed, 20 May 2020 02:49:35 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k22so1093018pls.10;
        Wed, 20 May 2020 02:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Di5GhhIVk5+nln0iwOVokfXWhv8Y+Qgt7aCSLcBIvXI=;
        b=BknWzpxL6+ChfVnS+zsdaDOAAYF6nfo3bA+dcUOsH2JfKC4nXgkFCFc9DQZxVjApbd
         50jHLgETBRGeS5TMpD/yye/yaE8nvyEjKZEB/Md8ZYJmAMPSeyDVnqKoCjQLhjtvTBcf
         hkwjxIIdg2/kjDhX6mW14/huQqaPC/o7NYD82nnXqX87M+urM5Rsq1wWLkJ8ZeqDtezn
         O5HnIcqxgYjOxbMwtzP9KGyep1owbY84X0IurU6lJNcHOqtjB9hqX7bGGQCOwgDSHJG4
         8BY4t9B6RqVzNbpDR46Zf2qnKFJ1hf8M3EgkyXy1Cxg9Jyg1LTJS/mBSzbvav+tsFq1f
         AUFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Di5GhhIVk5+nln0iwOVokfXWhv8Y+Qgt7aCSLcBIvXI=;
        b=l/BEshkFiETcAEpjsBYI4zRC8OXmoeWILxE8NqZ1/OFI+Njaymex54e+cVs/Z3kPCt
         n1NjTE+lQHRPDH4aPn4kbEqmT+wht0wmcOkvRArImYAydOT6meozB0uPFGiqs9iGkSMp
         Y9w9budkvpYK4/DhPqN72WDhrWtyZ/7gcScDWcNaLvSn1tuTKueI1f5OPNSFLQFxiZxr
         F0T7Ap+kxMS/5ozXyVRnGU8RAAMNYk+J3fhc9R1rxNxa8lRPejXOYq3bzCMPInlSVnBq
         Chlp+3W5I23G3V83yr7IjyPjUvq3MppcrWXmBH6tCrNJfwlMPQtPwn6yThfs0HcqVDRv
         V8wA==
X-Gm-Message-State: AOAM532n2vuc8btCYtOq0pQccWuE8P+mAkBGMpHDT8ap7MRgMEReFpB0
        zcVrQuoF93izPh5Vo5Qfgxw=
X-Google-Smtp-Source: ABdhPJw5krfhFJFeuJv4YE+ufDlGV3CdQp/tkjr6G8qKJmA82Et6WSJ5/zt0IhrYlrq8+efodzo+oQ==
X-Received: by 2002:a17:902:d68b:: with SMTP id v11mr3762715ply.295.1589968175182;
        Wed, 20 May 2020 02:49:35 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id c124sm1707494pfb.187.2020.05.20.02.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 02:49:34 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com
Subject: [PATCH bpf-next v4 13/15] xdp: simplify xdp_return_{frame,frame_rx_napi,buff}
Date:   Wed, 20 May 2020 11:47:40 +0200
Message-Id: <20200520094742.337678-14-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200520094742.337678-1-bjorn.topel@gmail.com>
References: <20200520094742.337678-1-bjorn.topel@gmail.com>
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

