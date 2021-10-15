Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2ECA42F1C4
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 15:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239301AbhJONLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 09:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:32984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239295AbhJONLh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 09:11:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83DF2610E5;
        Fri, 15 Oct 2021 13:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634303370;
        bh=pDtVSoNi/JbR3Nu6XM5I5zaUiINhhd68H2LIM6iqbF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CWRMX3zfIijco0zAJL9UGYHQvxR8I5R5FBmCK6E+yFPmMZtsw3OiV1Owj2/Dvrl+F
         TENnTmvkJmwu2s7olvEp7AqxKM6i7N1wS/d0YtE2vuNX2DOrXP54m9VcnvWJMd5DC2
         JRA5vB21g3X8sl5jZZLwUCuzIm8RxuQPwR53BlGKv7syL438ZxLLIy10IUAe/CoysA
         qBPTfIRkDuPDbvG/wacUxiHttBe3335OHFfckk6sBhf6LSb+Htnqi6hPmeOFXbZ63s
         WvFXSu+gSnjqa/Op5M1o2fjYOJmoZXO36Zn9xhLY+WQ70O/2jvt8sRy5qHlSlwDjWH
         osmRzf5D7FwhQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v16 bpf-next 01/20] net: skbuff: add size metadata to skb_shared_info for xdp
Date:   Fri, 15 Oct 2021 15:08:38 +0200
Message-Id: <d9c8a0df0d9a7361713e10eeebdbc9d6f94f6c95.1634301224.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634301224.git.lorenzo@kernel.org>
References: <cover.1634301224.git.lorenzo@kernel.org>
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

