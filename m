Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840A8495D53
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 11:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379856AbiAUKLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 05:11:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379872AbiAUKKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 05:10:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028DBC06173F;
        Fri, 21 Jan 2022 02:10:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFA7BB81ED8;
        Fri, 21 Jan 2022 10:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75373C340E1;
        Fri, 21 Jan 2022 10:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642759844;
        bh=iCDA64QsPXudOAGQnpu8WTHtqksQdMhtdJfZ1+l6gaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tc+TYpM/kiYzS6pAghmC/eTBesZiN9oxlBmwzhRY9H/6nv1KGr4sP/HC613yOyXpr
         VNpT2JFmAUw1Fv9VxNNI8GQH08cNywhRV03EIeePNj2LlISZXddkYFpqsuYWy6bHuc
         0eaNclZHn8OEpy8B4ZrWT91r490yo7/La9/l+Q9fvTI/4m+2gngmM23BaVORvwfR5W
         0maEscBBj+rQjuvzTUOFyX204XxeCNEnvuFedkwzEGeJVEo6jy+ZKmhWtZQ9pTxfTy
         PG/iGLTRhtpaXKiiPkp186X15F35Qv6TKju2djmdF1agSm8wrkNsr+6GWFhnxwP743
         xvYFYMocQGlog==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH v23 bpf-next 01/23] net: skbuff: add size metadata to skb_shared_info for xdp
Date:   Fri, 21 Jan 2022 11:09:44 +0100
Message-Id: <8a849819a3e0a143d540f78a3a5add76e17e980d.1642758637.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1642758637.git.lorenzo@kernel.org>
References: <cover.1642758637.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp_frags_size field in skb_shared_info data structure
to store xdp_buff/xdp_frame frame paged size (xdp_frags_size will
be used in xdp frags support). In order to not increase
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

