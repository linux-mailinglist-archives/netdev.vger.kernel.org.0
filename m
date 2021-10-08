Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480C9426B2A
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 14:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241597AbhJHMxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 08:53:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230204AbhJHMxB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 08:53:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4882B61027;
        Fri,  8 Oct 2021 12:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633697466;
        bh=pDtVSoNi/JbR3Nu6XM5I5zaUiINhhd68H2LIM6iqbF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K7PvQEG3D3TPRS8iKneofIa9u2TKpDN+Rje6+EWVL/vyLccI0veCKjAkPeJA/G8ow
         HPKCsYXvSSqqk/sLfZu7flYDTl+j0qdPr4gvcKpO+XkJLBAX0kDaeh/4rWCMIRNyfP
         8V98uD2yz8gxz2o6BI4bKyeAWBLjok5bkiXirMwl/ojEutzf3fKL7HN/M6/7pZ516I
         TMl2g2O/xnkbhypIe7dbcNFvLXz1TcVAXV+2XBVvywazfQLmEem3+ftgseTQUBGU65
         2qIgb6vNXhKMELRn9RNjkMiHSGDFx6aQ6EIIDxHVVwurc1xL75XglpKaBim7mI+7mD
         piwqnxJCZkKPw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v15 bpf-next 01/18] net: skbuff: add size metadata to skb_shared_info for xdp
Date:   Fri,  8 Oct 2021 14:49:39 +0200
Message-Id: <72546ad0b742461ce6102355dea69fcdcd0d14ad.1633697183.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1633697183.git.lorenzo@kernel.org>
References: <cover.1633697183.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp_frags_size field in skb_shared_info data structure
to store xdp_buff/xdp_frame frame paged size (xdp_frags_size will
be used in xdp multi-buff support). In order to not increase
skb_shared_info size we will use a hole due to skb_shared_info
alignment.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/linux/skbuff.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 841e2f0f5240..86f68042c533 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -529,6 +529,7 @@ struct skb_shared_info {
 	 * Warning : all fields before dataref are cleared in __alloc_skb()
 	 */
 	atomic_t	dataref;
+	unsigned int	xdp_frags_size;
 
 	/* Intermediate layers must ensure that destructor_arg
 	 * remains valid until skb destructor */
-- 
2.31.1

