Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9308C2CC968
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387514AbgLBWL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727452AbgLBWL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:11:28 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2F9C061A4A
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 14:10:24 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id e23so101045pgk.12
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 14:10:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AqjZOIuE4X85vaE2wxWXKVDHIkqqQieb92c3SlQLVn8=;
        b=GHs6vzsHcL9F4nZ5PaA4og5MVuN4KweozZy2IO+Ud3GCyUJclY0TefnEVDd68MJC1R
         5wYx9VA7p3Dw8A4fnZlK8OHuKSAhY/qQtmaeHq4qnKJgGzFD/qxm89HEeoxX6O1jx3sn
         HESc6fIg8EbyjM6FcbfeHOiwBoLzOF64bb5cL+2yJHbeo14RYdTvXykLv6/Zn6R2ZRNV
         vvWja/VvDHXscEFeV9LJVP5C2BtESSe+XGwf6CpN3U2eMCydU106VT6ssh5cy8agMDkb
         q6+ptTrOwx3XDw1MSuDmKSVYKtEnLo/QviNmNVedTIPQAmonXApPMnuuEYNLUTAtf/Jc
         9MPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AqjZOIuE4X85vaE2wxWXKVDHIkqqQieb92c3SlQLVn8=;
        b=mdDZvdJ1nxusER+YEE9J1hYfSTl1/h1mdfi5tUm92wmiwHoqjahS/La+imiSUwWLz1
         MVKDfujaVIRR8y1s6I3NOLS7Zu6Cbpaix2OqAcDr1vfgrP87VA774r7/F53ObaPioqBi
         biG6sAVC/OmawCjqJ2kxxyu/Y3ZRqaYtk1uunc8sAZiykIK3oso1fOlCaqmhHqIdHjRR
         HaYMBMmhfb/NlAG1NzKIFrsjgRcv/AgcB4VK+wU/wa/MZ8pIooLRFVzf1DcjYEe0qKIR
         veE9AXhkUTf7ncZ871Ue+JRMGB0Uo6apTttqM68MS2mMVEra9he8Wnp/DLW9CF3/Y7fk
         0OmQ==
X-Gm-Message-State: AOAM532w4TUeroqlGotFkPyEBAcplrnpbzR008ae0O2yxrlvZiNWOjsw
        MK46cKxtPalqa7gh8gD1Jlg=
X-Google-Smtp-Source: ABdhPJxjqnfn+dwJZv9M3PI5P0jMn2xOBPkesLHu1zLSZz02rpTMdATzHrgpJ2y/oJ3fy2RN1zx99w==
X-Received: by 2002:a62:5e81:0:b029:197:baa5:1792 with SMTP id s123-20020a625e810000b0290197baa51792mr76616pfb.80.1606947023805;
        Wed, 02 Dec 2020 14:10:23 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id p16sm4872pju.47.2020.12.02.14.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:10:23 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next v2 7/8] net-zerocopy: Set zerocopy hint when data is copied
Date:   Wed,  2 Dec 2020 14:09:44 -0800
Message-Id: <20201202220945.911116-8-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
In-Reply-To: <20201202220945.911116-1-arjunroy.kdev@gmail.com>
References: <20201202220945.911116-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

Set zerocopy hint, event when falling back to copy, so that the
pending data can be efficiently received using zerocopy when
possible.
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

