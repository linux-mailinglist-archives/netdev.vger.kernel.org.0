Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626262C6A7E
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 18:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731834AbgK0RSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 12:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731485AbgK0RSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 12:18:16 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A499C0613D1;
        Fri, 27 Nov 2020 09:18:16 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id t8so5106014pfg.8;
        Fri, 27 Nov 2020 09:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nUfK8fzSKVoF6iphTWhTeruR/Mw5b8HChKw2QUa6N2s=;
        b=VQAVfYTCECAe4WOofoGZ6v3oG5WtmL38r3I1PA6C7Z1LcuwbSIkGPVy90QPOKsSTXc
         s2tZXJVm4cc1CttoE2cRF6YPuKqnZ2MfjhuTHUAETm5NNHM/seQnafFHLvvOiTq4fpnb
         XNRD6w+Oqf8fOIozF6Ydds+NIx6lzaH/CFE4NumCrT8jvBXd9AioLoHKMNAIvbYXqfuo
         s8Bf5IGqa9P5Gu8qHKbnRz5DXUWhW6n2g5249rjBGqJR3NfcCOr1yzV+IqBPVPK2Ik3B
         94cH/T0KmZHS6JR/ikPakV2YVWCV9kyGVMb6JFgkTZnt+kRj0qNVNPq5oIXnjwXd3/jb
         uoVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nUfK8fzSKVoF6iphTWhTeruR/Mw5b8HChKw2QUa6N2s=;
        b=Iaf6DH4d2O5O15ADpzCEU22o00gOp++4nfqscZT+uXG3k3mHjRIezzQuq4J2uqS275
         P8WCsHSnJYfYwvXrG5oiRB+uZNeFDM9W3Qbu6KTXBhmJFwFt2+pPo2oono/8ZUkfFkzv
         +iYESeJ2gYXy8DMfUosqNTzlN9ylTNUpNf0IiJT4uVCZ4JzVmDrqe3hFb7LzbghQ0FlT
         tHgPPNf+mfeG6Tq+NZl1C6ks/JB+8P4RzDRh2OaIcbIcCYQvN2iKSm+j/RGlD9g//fTR
         lMfOj3xUU2JpPHJRfU/nPmilXU87G0AMS1WwI6IDu2xc8wFWm+lT8eYNaK06s6KT0s91
         4ygw==
X-Gm-Message-State: AOAM533eOHkpYcry59pN4UvD2LIkICTYVQfgdD/QG4/lJ0Dbu2LK7f4A
        2V7O1gBiSozarQjrfBuXxn4=
X-Google-Smtp-Source: ABdhPJye3164jDQnWGQNpc4vtxbNbgEV9AcrlEOocK4H38eTH7OTs0g1teV3EPeQGE4NkteR19vODA==
X-Received: by 2002:a63:3e86:: with SMTP id l128mr7487503pga.114.1606497496109;
        Fri, 27 Nov 2020 09:18:16 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id m73sm8346024pfd.106.2020.11.27.09.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 09:18:14 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        jonathan.lemon@gmail.com, magnus.karlsson@intel.com,
        maximmi@nvidia.com
Subject: [PATCH bpf] xdp: Handle MEM_TYPE_XSK_BUFF_POOL correctly in xdp_return_buff()
Date:   Fri, 27 Nov 2020 18:17:26 +0100
Message-Id: <20201127171726.123627-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

It turns out that it does exist a path where xdp_return_buff() is
being passed an XDP buffer of type MEM_TYPE_XSK_BUFF_POOL. This path
is when AF_XDP zero-copy mode is enabled, and a buffer is redirected
to a DEVMAP with an attached XDP program that drops the buffer.

This change simply puts the handling of MEM_TYPE_XSK_BUFF_POOL back
into xdp_return_buff().

Reported-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Fixes: 82c41671ca4f ("xdp: Simplify xdp_return_{frame, frame_rx_napi, buff}")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/core/xdp.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 48aba933a5a8..491ad569a79c 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -335,11 +335,10 @@ EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_mem_model);
  * scenarios (e.g. queue full), it is possible to return the xdp_frame
  * while still leveraging this protection.  The @napi_direct boolean
  * is used for those calls sites.  Thus, allowing for faster recycling
- * of xdp_frames/pages in those cases. This path is never used by the
- * MEM_TYPE_XSK_BUFF_POOL memory type, so it's explicitly not part of
- * the switch-statement.
+ * of xdp_frames/pages in those cases.
  */
-static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct)
+static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
+			 struct xdp_buff *xdp)
 {
 	struct xdp_mem_allocator *xa;
 	struct page *page;
@@ -361,6 +360,10 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct)
 		page = virt_to_page(data); /* Assumes order0 page*/
 		put_page(page);
 		break;
+	case MEM_TYPE_XSK_BUFF_POOL:
+		/* NB! Only valid from an xdp_buff! */
+		xsk_buff_free(xdp);
+		break;
 	default:
 		/* Not possible, checked in xdp_rxq_info_reg_mem_model() */
 		WARN(1, "Incorrect XDP memory type (%d) usage", mem->type);
@@ -370,19 +373,19 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct)
 
 void xdp_return_frame(struct xdp_frame *xdpf)
 {
-	__xdp_return(xdpf->data, &xdpf->mem, false);
+	__xdp_return(xdpf->data, &xdpf->mem, false, NULL);
 }
 EXPORT_SYMBOL_GPL(xdp_return_frame);
 
 void xdp_return_frame_rx_napi(struct xdp_frame *xdpf)
 {
-	__xdp_return(xdpf->data, &xdpf->mem, true);
+	__xdp_return(xdpf->data, &xdpf->mem, true, NULL);
 }
 EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
 
 void xdp_return_buff(struct xdp_buff *xdp)
 {
-	__xdp_return(xdp->data, &xdp->rxq->mem, true);
+	__xdp_return(xdp->data, &xdp->rxq->mem, true, xdp);
 }
 
 /* Only called for MEM_TYPE_PAGE_POOL see xdp.h */

base-commit: 9a44bc9449cfe7e39dbadf537ff669fb007a9e63
-- 
2.27.0

