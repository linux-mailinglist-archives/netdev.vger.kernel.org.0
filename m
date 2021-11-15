Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7740B4517C7
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 23:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237276AbhKOWqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 17:46:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:46036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240190AbhKOWgv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 17:36:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C81F361B6F;
        Mon, 15 Nov 2021 22:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637015632;
        bh=FdxDufx42oG2Uhhf2gTV6tStVhPE5m8IXwvTE7Oq8PM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UnU2OEMolQXtcK2sRi1UUQ+HRpBxYoDxSe25b+1/kgCIO+I4V8NKcGEOHEuR+JhSG
         R1sDYHjkjeU4tYSoEAPwPjxEuqmYAkFs+/mncrQ3ebzHFPl73pac7gDn/G47BDJhko
         o6NaZeP4QTYrkFx7NKmkRz3Xomh8jN1GVgp17Ig5W8BKFnqszPNNmszRdV32ChFIPj
         5xiTp/cIAB9qPoHV2LZBJMHFznIv+eKTj7WQYkQd00KrkG9P0lelarB6pMtcT/qKBr
         Ai4P/R0BAVDbNMIWEB65THqd5sG9IjADlNFhBlPfc6A9utVpyscSeWzwgQ0Bz08kZz
         k4PvIiYJx/6DQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v18 bpf-next 01/23] net: skbuff: add size metadata to skb_shared_info for xdp
Date:   Mon, 15 Nov 2021 23:32:55 +0100
Message-Id: <3dd1221d8bfdf05eac1461f5c5a1c9eb1c734316.1637013639.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1637013639.git.lorenzo@kernel.org>
References: <cover.1637013639.git.lorenzo@kernel.org>
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
index 0bd6520329f6..de85a76afbc1 100644
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

