Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F2B490F6D
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235962AbiAQR3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:29:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40748 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235553AbiAQR3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:29:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5468CB81134;
        Mon, 17 Jan 2022 17:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D73C36AE7;
        Mon, 17 Jan 2022 17:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642440556;
        bh=EG0/1fA8U/lAUpmpPK9rnsdngP5E35DuXrdpbzwzSO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U8oOL7mNBGYtekiTJUCFtK0r2eONOnxlKQXK56ANNm6EDunBpZfWBd/4lxIBlygmJ
         d0UDpwUI/YTSH1s0sS42c/usjLkU4UVSsucdxDb7Ztfn2fJGYiKvUAryMXusmt+mpJ
         vRmNUZxVQWalwIZk8NF8Hb+TbidUplwVSk65fu2VEW1ggCmfnMdGfWlZGv1MouxZJZ
         ETLwRDTQAAZAtN3JKT1I8eD2KbYgi5jhjS9LYZAG/KCvCPmQP91VkgnOmGvAmFcK9+
         okndz1MC9kC2gwQH/NmnzEPQE6TMRg9cpVjQYFalT1vbvrDXXs9Tm+0IeYhyFm+MhI
         NX9jgtIekao9Q==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v22 bpf-next 01/23] net: skbuff: add size metadata to skb_shared_info for xdp
Date:   Mon, 17 Jan 2022 18:28:13 +0100
Message-Id: <c4072b0b416ec256c66b919e876031e18a4baed8.1642439548.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1642439548.git.lorenzo@kernel.org>
References: <cover.1642439548.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp_frags_size field in skb_shared_info data structure
to store xdp_buff/xdp_frame frame paged size (xdp_frags_size will
be used in xdp multi-frags support). In order to not increase
skb_shared_info size we will use a hole due to skb_shared_info
alignment.

Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/linux/skbuff.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index bf11e1fbd69b..8131d0de7559 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -557,6 +557,7 @@ struct skb_shared_info {
 	 * Warning : all fields before dataref are cleared in __alloc_skb()
 	 */
 	atomic_t	dataref;
+	unsigned int	xdp_frags_size;
 
 	/* Intermediate layers must ensure that destructor_arg
 	 * remains valid until skb destructor */
-- 
2.34.1

