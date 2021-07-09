Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6943C229A
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 13:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhGILNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 07:13:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229641AbhGILNe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 07:13:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E0BF613D6;
        Fri,  9 Jul 2021 11:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625829051;
        bh=oydCl5SC8mTDWkWcTTMhZldv5aPmKHXOWDlXgdsn6No=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hx+HgWKENwTuo/RuCLVSrd0dxu+dnKiRSXbnTQ496oHyef4buY2JrKSb7blS6+WSg
         7lwUxLqFRlaa4gyGWrzWIeh1xj5Z2XBo/XnVC4dDatWN24hca2KIQedqRDv+DzQYpv
         /e851+/QK/v+uQu54/BlU4wW7Kekid9ZjRdVt7H9OIhTPYOBHhT1bBrUa+52PeqYJn
         jDxP5b2fh+8h3vJywykXDPtVOpEs+RIybvxM1dt5QokAaXyoDA1QVZeYqMLx0/kgy1
         BqNh61N4+N6gQLmhWxEKkRxYslmTcGtJkeUdMGp+GYAWH65cP5GLNPMUoihu5kKwn0
         OT3pfwFFpC/eA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, alexander.duyck@gmail.com, brouer@redhat.com,
        echaudro@redhat.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH bpf-next 1/2] net: skbuff: add xdp_frags_tsize field to skb_shared_info
Date:   Fri,  9 Jul 2021 13:10:27 +0200
Message-Id: <2a37aaa826807751478a2003b83ccb9838323b17.1625828537.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1625828537.git.lorenzo@kernel.org>
References: <cover.1625828537.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xdp_frags_tsize field will be used to store paged frame
truesize for xdp_buff/xdp_frame. In order to not increase
skb_shared_info size we will use a hole due to skb_shared_info
alignment.
gso_type filed will be used to store paged frame size.
This is a preliminary patch to properly support xdp multi-buff

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/linux/skbuff.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index f19190820e63..0e345c5ccb4f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -522,6 +522,7 @@ struct skb_shared_info {
 	unsigned short	gso_segs;
 	struct sk_buff	*frag_list;
 	struct skb_shared_hwtstamps hwtstamps;
+	/* used for xdp_{buff,frame} paged size */
 	unsigned int	gso_type;
 	u32		tskey;
 
@@ -529,6 +530,7 @@ struct skb_shared_info {
 	 * Warning : all fields before dataref are cleared in __alloc_skb()
 	 */
 	atomic_t	dataref;
+	unsigned int	xdp_frags_tsize;
 
 	/* Intermediate layers must ensure that destructor_arg
 	 * remains valid until skb destructor */
-- 
2.31.1

