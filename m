Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF70463368
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 12:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhK3L5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 06:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbhK3L5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 06:57:12 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CADBC061574;
        Tue, 30 Nov 2021 03:53:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 79312CE189B;
        Tue, 30 Nov 2021 11:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC94CC53FD1;
        Tue, 30 Nov 2021 11:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638273229;
        bh=hdq5rt7i+q0iK1lN8iX42IZ2F7IlQtbQa/uT0PrUyGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tutnxvlEEbWsm6kYuS/Q9tbv9ofoKrFSvqzXfHAj+xAuchdGc+8ibyElFUv6JHh0b
         bc09mhT6lQOVHEGsNerGRc8tb6i0KAv/uebzU2Ly5etDFhEMPde8WuqNJ7DO0pRPrz
         L3nEoRGKqIk3/9eEQYVFxiE9H4InX0UePcA2cf84DcPe4+8ZNjIN+YlQpARvXrH6rX
         kO8NfuX7PwvcbdbJQIIbnPlmCipy/fGW712x9NpaS5sF4S+fvx6lH6UZrfHQos+Lt6
         0hRmt+dCg7HumVV6y351t3QiX6eY7ehZeOLI5lRpMb+CSLXrn4f0tnDSn57NCvWvsu
         5F0mPyvPY1pFw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v19 bpf-next 01/23] net: skbuff: add size metadata to skb_shared_info for xdp
Date:   Tue, 30 Nov 2021 12:52:45 +0100
Message-Id: <9018e37a54c3d2dd9eaacd33a742cf779e5d468a.1638272238.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1638272238.git.lorenzo@kernel.org>
References: <cover.1638272238.git.lorenzo@kernel.org>
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
index 686a666d073d..2eecb6931975 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -535,6 +535,7 @@ struct skb_shared_info {
 	 * Warning : all fields before dataref are cleared in __alloc_skb()
 	 */
 	atomic_t	dataref;
+	unsigned int	xdp_frags_size;
 
 	/* Intermediate layers must ensure that destructor_arg
 	 * remains valid until skb destructor */
-- 
2.31.1

