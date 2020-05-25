Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EA51E121A
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 17:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391067AbgEYPxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 11:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388791AbgEYPxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 11:53:19 -0400
X-Greylist: delayed 399 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 25 May 2020 08:53:18 PDT
Received: from out2.virusfree.cz (out2.virusfree.cz [IPv6:2001:67c:1591::e2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59B0C061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 08:53:18 -0700 (PDT)
Received: (qmail 22205 invoked from network); 25 May 2020 17:46:36 +0200
Received: from out2.virusfree.cz by out2.virusfree.cz
 (VF-Scanner: Clear:RC:0(2001:67c:1591::6):SC:0(-2.7/5.0):CC:0:;
 processed in 0.4 s); 25 May 2020 15:46:36 +0000
X-VF-Scanner-Mail-From: pv@excello.cz
X-VF-Scanner-Rcpt-To: netdev@vger.kernel.org
X-VF-Scanner-ID: 20200525154635.976122.22169.out2.virusfree.cz.0
X-Spam-Status: No, hits=-2.7, required=5.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=excello.cz; h=
        date:message-id:from:to:subject:reply-to; q=dns/txt; s=default;
         t=1590421595; bh=D2NB0B1nNWW9+PqZLh+XgusboSNLV3L95Jp2Llp9dRA=; b=
        B7qibPGfO9jM/xkfx8B1yt/GNsrzFTsqG2g8rWzuDXixzKOkCIpuQnRbelxpblX5
        s4bh8j+yUu8emqdPZ0pxavZme/c0MsfpkXGeZwQqC8JyhAtmzWfyS/Arg233SqqL
        T/ynfEo8QlbNSqwzaCqHPoUm+h2sdO82E30Cl9h4ODQ=
Received: from posta.excello.cz (2001:67c:1591::6)
  by out2.virusfree.cz with ESMTPS (TLSv1.3, TLS_AES_256_GCM_SHA384); 25 May 2020 17:46:35 +0200
Received: from atlantis (unknown [IPv6:2001:67c:1590::2c8])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by posta.excello.cz (Postfix) with ESMTPSA id 38B8C9D7484;
        Mon, 25 May 2020 17:46:35 +0200 (CEST)
Date:   Mon, 25 May 2020 17:46:33 +0200
From:   Petr =?utf-8?B?VmFuxJtr?= <pv@excello.cz>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Petr =?utf-8?B?VmFuxJtr?= <pv@excello.cz>
Subject: [PATCH net-next] xfrm: no-anti-replay protection flag
Message-ID: <20200525154633.GB22403@atlantis>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC 4303 in section 3.3.3 suggests to disable anti-replay for manually
distributed ICVs.

This patch introduces new extra_flag XFRM_SA_XFLAG_NO_ANTI_REPLAY which
disables anti-replay for outbound packets if set. The flag is used only
in legacy and bmp code, because esn should not be negotiated if
anti-replay is disabled (see note in 3.3.3 section).

Signed-off-by: Petr Vaněk <pv@excello.cz>
---
 include/uapi/linux/xfrm.h |  1 +
 net/xfrm/xfrm_replay.c    | 12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index 5f3b9fec7b5f..4842b1ed49e9 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -387,6 +387,7 @@ struct xfrm_usersa_info {
 };
 
 #define XFRM_SA_XFLAG_DONT_ENCAP_DSCP	1
+#define XFRM_SA_XFLAG_NO_ANTI_REPLAY	2
 
 struct xfrm_usersa_id {
 	xfrm_address_t			daddr;
diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index 98943f8d01aa..1602843aa2ec 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -89,7 +89,8 @@ static int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb)
 	if (x->type->flags & XFRM_TYPE_REPLAY_PROT) {
 		XFRM_SKB_CB(skb)->seq.output.low = ++x->replay.oseq;
 		XFRM_SKB_CB(skb)->seq.output.hi = 0;
-		if (unlikely(x->replay.oseq == 0)) {
+		if (unlikely(x->replay.oseq == 0) &&
+		    !(x->props.extra_flags & XFRM_SA_XFLAG_NO_ANTI_REPLAY)) {
 			x->replay.oseq--;
 			xfrm_audit_state_replay_overflow(x, skb);
 			err = -EOVERFLOW;
@@ -168,7 +169,8 @@ static int xfrm_replay_overflow_bmp(struct xfrm_state *x, struct sk_buff *skb)
 	if (x->type->flags & XFRM_TYPE_REPLAY_PROT) {
 		XFRM_SKB_CB(skb)->seq.output.low = ++replay_esn->oseq;
 		XFRM_SKB_CB(skb)->seq.output.hi = 0;
-		if (unlikely(replay_esn->oseq == 0)) {
+		if (unlikely(replay_esn->oseq == 0) &&
+		    !(x->props.extra_flags & XFRM_SA_XFLAG_NO_ANTI_REPLAY)) {
 			replay_esn->oseq--;
 			xfrm_audit_state_replay_overflow(x, skb);
 			err = -EOVERFLOW;
@@ -572,7 +574,8 @@ static int xfrm_replay_overflow_offload(struct xfrm_state *x, struct sk_buff *sk
 
 		XFRM_SKB_CB(skb)->seq.output.hi = 0;
 		xo->seq.hi = 0;
-		if (unlikely(oseq < x->replay.oseq)) {
+		if (unlikely(oseq < x->replay.oseq) &&
+		    !(x->props.extra_flags & XFRM_SA_XFLAG_NO_ANTI_REPLAY)) {
 			xfrm_audit_state_replay_overflow(x, skb);
 			err = -EOVERFLOW;
 
@@ -611,7 +614,8 @@ static int xfrm_replay_overflow_offload_bmp(struct xfrm_state *x, struct sk_buff
 
 		XFRM_SKB_CB(skb)->seq.output.hi = 0;
 		xo->seq.hi = 0;
-		if (unlikely(oseq < replay_esn->oseq)) {
+		if (unlikely(oseq < replay_esn->oseq) &&
+		    !(x->props.extra_flags & XFRM_SA_XFLAG_NO_ANTI_REPLAY)) {
 			xfrm_audit_state_replay_overflow(x, skb);
 			err = -EOVERFLOW;
 
-- 
2.26.2

