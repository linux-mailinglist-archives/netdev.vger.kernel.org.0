Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39EC844588B
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233910AbhKDRip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:38:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233896AbhKDRim (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 13:38:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2F4761076;
        Thu,  4 Nov 2021 17:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636047363;
        bh=FdxDufx42oG2Uhhf2gTV6tStVhPE5m8IXwvTE7Oq8PM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rzZJjey0lv27CSxYL8QVVwWfXIDvevIheifmfhaIrTZCPRhRifzezkNcXNifJ7TDX
         pTbeuEO8ykWnDohQjh0LZlMQ84qyoBfhYKOWY721cZGXFZ75ylYxfEdIgR7uk6b0GI
         N2ubB6b8fpZcwz7vpm+DHjAKNQmg8YCZJUiJMl7g9+4tqTlP7KKiB9OnTDwmpoabxl
         2YNeBzgc3rkc9TA+9dY8rb5ryZdN+N6Act1qQwJcDjtP5WdEtSFh4tsfVgwyKezCP7
         JCMjg6byKuMryy0xiTM4ZVS+oqJuCqikiuwprM0awSDZ/aHMUOTUDfP6fq8pijXk4q
         W7Wh6HKHpQOUA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v17 bpf-next 01/23] net: skbuff: add size metadata to skb_shared_info for xdp
Date:   Thu,  4 Nov 2021 18:35:21 +0100
Message-Id: <c47f51771c583268562548309d5ead64c1d71350.1636044387.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1636044387.git.lorenzo@kernel.org>
References: <cover.1636044387.git.lorenzo@kernel.org>
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

