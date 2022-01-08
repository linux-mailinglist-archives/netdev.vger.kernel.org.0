Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D430488352
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 12:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbiAHLxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 06:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234156AbiAHLxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 06:53:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9976DC061574;
        Sat,  8 Jan 2022 03:53:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38B0060B52;
        Sat,  8 Jan 2022 11:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE95C36AE5;
        Sat,  8 Jan 2022 11:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641642832;
        bh=7WMMzdMairMGQWTqXc8j5X+zOfq1O5agFsy0LbA6Ac0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uaAJgSnxQXeG4h3AxWfw0pbZA9SwVm6VkJPq/MzfB51Hl3nUBnDJdTfIj/Ry6nV2Z
         j3kTBD2hQzCyNLtwn6k/XDzCxK4mgMlMrFg56XUZ1/AEEwJPbzTtm5UYYvrnnlWWLU
         QAG443nD/8o3ISdzE27mnKa2G2SUfl8bY5G/3wRQwXqnxu/j+w8ktPf/jGOptbTeYu
         XihBlE8aV67EOxiTwUeuakr7vGTqvG3CsCMef3nyNMaLldQE9PPgvDvKfFpjXFFl9x
         8wA1p25ofcxR056ai3LrzfSCx4KpD29/qIT8WLPCrydJa8c+mhQInkOLuQMbkg45Wi
         Y7qKEy7qWEUxQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v21 bpf-next 01/23] net: skbuff: add size metadata to skb_shared_info for xdp
Date:   Sat,  8 Jan 2022 12:53:04 +0100
Message-Id: <9bb7c3c6993d81859173c60a9a0b586b71e32d39.1641641663.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1641641663.git.lorenzo@kernel.org>
References: <cover.1641641663.git.lorenzo@kernel.org>
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

Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/linux/skbuff.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 642acb0d1646..d6d2ca936ddf 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -539,6 +539,7 @@ struct skb_shared_info {
 	 * Warning : all fields before dataref are cleared in __alloc_skb()
 	 */
 	atomic_t	dataref;
+	unsigned int	xdp_frags_size;
 
 	/* Intermediate layers must ensure that destructor_arg
 	 * remains valid until skb destructor */
-- 
2.33.1

