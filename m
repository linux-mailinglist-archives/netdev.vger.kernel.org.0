Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33AA42B0D63
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgKLTDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727187AbgKLTDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:03:03 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E019FC0613D4
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:03:03 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id y22so3282201plr.6
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uBhuHxEFEMnspB71cOl9GHtE64ZEIdLY3Dvadheva4U=;
        b=Xp/N/hxoji6XQLgqhl/X/p+pEIPgAwjfyiB4NdwtQsFvVqzWdjFgTgapwuxL3s/OLe
         b8OPa34189evpzpj6I+K8nZgRlTQ5LaU1cqF6ysXMJ7GqpQAM1fA6Rm7pANhYfTOPUpf
         ht9tr2TRO8TH1zSNCEmYaH4tVtt7VClvycgTjsFx+RCQtvGB+MC2o62JzrWZQ1vkBxCa
         Rvj4nTI7PzFIw2HSw93Wj+MU8SJ2ckEfpZXrHD9h2cJOV3SD6kE4NDqpnuuE6bnSzEk6
         j6RUKetiN/+ke0F7ezxvWKI0lNTTC4xYLNGGOcxB/CMVq6Tbf8HMHNqjWUEkY9SVXZR/
         iQag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uBhuHxEFEMnspB71cOl9GHtE64ZEIdLY3Dvadheva4U=;
        b=iRwlgOTJnL9TfMxYNjexbubDD57Ri2C9q35qULbFyv9VCThkw6ukCKMQmBTVktxFD6
         qmJLD5uM5gdQJQZMPqn5kouHuGzkiAIg+6Wk8Dax5ZokT3mD0lqS1zukSuVsx0nNVnhV
         qiAigHWfSOCg1CUnkIJxYGosxNZq/7G+zUAzD9uiEmcwhu/o4lYn1rzkepdzgZI2Te4B
         Eqz60T1LNQZKp7wRdn4wlrGsO7oLy+q2Hc/7q5WLfywZ4vNNd92qInpd2l5t+vglFSvr
         s/OO4b8VZXt+WJafIo2fhSX81zGafhyJOqfJtCQLM3wIe45mJl/W9X4m/uckKdGpiLep
         l+yQ==
X-Gm-Message-State: AOAM5321MwIo5llqn57dxOolKK6gk+weayNyn5C0M2oJN8Gjhm/nvssH
        4uqsOQqAeqQpAFuIfqY95o0=
X-Google-Smtp-Source: ABdhPJws0f9F+EBNnZGx6T2aCT3y4t4QvMvRQul4f0u89g+MFyGGIp9pCTNhuGRXseraRfnDHyc15w==
X-Received: by 2002:a17:902:7e47:b029:d6:c9f2:d50 with SMTP id a7-20020a1709027e47b02900d6c9f20d50mr679234pln.81.1605207783518;
        Thu, 12 Nov 2020 11:03:03 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id z7sm7458809pfq.214.2020.11.12.11.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 11:03:03 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next 7/8] tcp: Set zerocopy hint when data is copied
Date:   Thu, 12 Nov 2020 11:02:04 -0800
Message-Id: <20201112190205.633640-8-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
In-Reply-To: <20201112190205.633640-1-arjunroy.kdev@gmail.com>
References: <20201112190205.633640-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

Set zerocopy hint, event when falling back to copy, so that the
pending data can be efficiently received using zerocopy when
possible.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>

---
 net/ipv4/tcp.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ca45a875147e..c06ba63f4caf 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1785,6 +1785,43 @@ static int find_next_mappable_frag(const skb_frag_t *frag,
 	return offset;
 }
 
+static void tcp_zerocopy_set_hint_for_skb(struct sock *sk,
+					  struct tcp_zerocopy_receive *zc,
+					  struct sk_buff *skb, u32 offset)
+{
+	u32 frag_offset, partial_frag_remainder = 0;
+	int mappable_offset;
+	skb_frag_t *frag;
+
+	/* worst case: skip to next skb. try to improve on this case below */
+	zc->recv_skip_hint = skb->len - offset;
+
+	/* Find the frag containing this offset (and how far into that frag) */
+	frag = skb_advance_to_frag(skb, offset, &frag_offset);
+	if (!frag)
+		return;
+
+	if (frag_offset) {
+		struct skb_shared_info *info = skb_shinfo(skb);
+
+		/* We read part of the last frag, must recvmsg() rest of skb. */
+		if (frag == &info->frags[info->nr_frags - 1])
+			return;
+
+		/* Else, we must at least read the remainder in this frag. */
+		partial_frag_remainder = skb_frag_size(frag) - frag_offset;
+		zc->recv_skip_hint -= partial_frag_remainder;
+		++frag;
+	}
+
+	/* partial_frag_remainder: If part way through a frag, must read rest.
+	 * mappable_offset: Bytes till next mappable frag, *not* counting bytes
+	 * in partial_frag_remainder.
+	 */
+	mappable_offset = find_next_mappable_frag(frag, zc->recv_skip_hint);
+	zc->recv_skip_hint = mappable_offset + partial_frag_remainder;
+}
+
 static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 			      int nonblock, int flags,
 			      struct scm_timestamping_internal *tss,
@@ -1811,6 +1848,14 @@ static int receive_fallback_to_copy(struct sock *sk,
 		return err;
 
 	zc->copybuf_len = err;
+	if (likely(zc->copybuf_len)) {
+		struct sk_buff *skb;
+		u32 offset;
+
+		skb = tcp_recv_skb(sk, tcp_sk(sk)->copied_seq, &offset);
+		if (skb)
+			tcp_zerocopy_set_hint_for_skb(sk, zc, skb, offset);
+	}
 	return 0;
 }
 
-- 
2.29.2.222.g5d2a92d10f8-goog

