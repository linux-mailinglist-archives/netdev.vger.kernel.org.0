Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F2F2CCA0B
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387777AbgLBWzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387665AbgLBWzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:55:15 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B36C061A4D
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 14:54:00 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id l11so57490plt.1
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 14:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ITgCJpbibuIyjnACDvxhxEJWpu8sUCdte6M77XSzcUs=;
        b=RjXL6Kzn6h35JZbmGzF9X+wJKk85NzHbW+kKJuUTea8eHr90kZ0GEGDkISbUbU2ryx
         EPQrvOd5KKBtH0XJU1I3eznzGsrksflWOhS/VBQOLbhcz1YpVO2/+fcJ89ySraHO2jTE
         eyhrxQiKdxtFjQqDidCmfEO4Dbugy4DPqk76FWnVWzm7nk1SCq9VBKGHp8GFScgPd0AF
         NhXbKhWA/629KPYUwEHCzMPCFqF4Eoojx92EK8pTvVOCTT3FjzO1NyVx3FaZj1oAPTfU
         pTfe09VJzhOkD2oW/+AozUmGBmmxN4bi+pMQFSbwZall5VPcRt0SaSPB0HTeuNhOgHrl
         wn8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ITgCJpbibuIyjnACDvxhxEJWpu8sUCdte6M77XSzcUs=;
        b=qBUTu/G3vpCZh4DzwRyMvkaQmWVU9oaqprDNd9yoiMkKYjtGrprWk0hHZq4QMfdbh9
         bIQMroF3lyqKwWyzc6YrFvyjXd1qjBu6eTTxxP4FQamRZmWvkpAmtu3Zz8kQd0R8sTvA
         0YY6FkjZvZ9yAIFapWPvfdAf6tcPAa7DI8Z4kJIE18PN5jI4zPFAAmZK1Q1z8Me+ReOo
         Z8xOpWtoR65F9vDQVAvqLcMqp1kgkw8iNPzdqk8rIYPHFkWvO62Skbh7pX2wp/GU9z3G
         +ov2l5pW0ELypoL9B5EjRs8v9JDs7AdLf7PPWGyv5Xh1SdNIY7lW4fj/iPzBS+c63lTx
         jH2A==
X-Gm-Message-State: AOAM530lSzDO2Hvl0s0SWufs1uwjMaxCKvYKG8xXvEzuK6fLMfmLKt55
        LWEgmS0vh9rnjA8gj+JeHqme9/0GbRI=
X-Google-Smtp-Source: ABdhPJy/+Bo+9kBTNd+V3mnhK/F9YWQ+4JL8rLRr2AjcQMwDZ7ylWOoCAoHnnn/UiaRYYWIO/lwffA==
X-Received: by 2002:a17:90a:f0c1:: with SMTP id fa1mr194111pjb.148.1606949640527;
        Wed, 02 Dec 2020 14:54:00 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id i3sm39962pjs.34.2020.12.02.14.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:54:00 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next v3 7/8] net-zerocopy: Set zerocopy hint when data is copied
Date:   Wed,  2 Dec 2020 14:53:48 -0800
Message-Id: <20201202225349.935284-8-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
In-Reply-To: <20201202225349.935284-1-arjunroy.kdev@gmail.com>
References: <20201202225349.935284-1-arjunroy.kdev@gmail.com>
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
index f67dd732a47b..49480ce162db 100644
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
@@ -1815,6 +1852,14 @@ static int receive_fallback_to_copy(struct sock *sk,
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
2.29.2.576.ga3fc446d84-goog

