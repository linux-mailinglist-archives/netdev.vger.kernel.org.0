Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4EFE2B0D60
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgKLTC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727168AbgKLTCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:02:50 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE82C0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:02:50 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id v12so5375160pfm.13
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MhBcpjhEqXsppr3+44nUMYba1BpmJJZSblxJp5+le2M=;
        b=hHs3rQMo/0DpOnBirtN9fwQtsV7O8/Vn5K6kbcJNbvTQ2OGBwSh31xCZ7e5ADCFLl/
         oIkaBpOb0a/aXUTuTgzFXKpO/xwmO31nkSnYC5cxPFky38F1WPuHiqowDNoETKQQ2CzQ
         RYbgosTreRQKXO0kIwq9q1yBaINc8dxurSWx/rTgQLZ7FlMTW236BL5EoVfVHGHF79th
         WpDM2v8M94yD9wN1udxTMYm1fyIXMX6J2BtLC6jGorHSrx3FQ4I2jnrhlVmehf4kCTpQ
         JEeQrhHrk9AQAUV4yaiNVZwzzCQ9wdTlnChiKiMXJ4ppCpACn1xSExm+zK59ircFOBwM
         P4gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MhBcpjhEqXsppr3+44nUMYba1BpmJJZSblxJp5+le2M=;
        b=OGIRYKC/IT0UZEiB6qWg1rESL/ami+eVKftdhPsGoHiOMEF5v4QNC5P4h2jH31nA94
         kDBJf1juaWXJqOmZxyxxw+LPb6wOSoW4361HmO7MzBydILzK4ZRZbULAlL5k6lCLxBPs
         ard36ypzWmL06UTTuzTGWD+BOi5Zy2W0VA/4M4GXJlOv7ZThjnQ3cCWSTJwsynxhf2mW
         yWaduuelxBcgtEBqQTU2/GokyD083weHK/X19cBsnoul4HaCfzxUJYt1f5Dqt3lFT5xf
         RoRKGY+PIyLQvz7wNT3QR8wholXs/6QPsbl19aiD3NB4U4frKg9spp1Xe1xIVLuSIiIb
         vOWA==
X-Gm-Message-State: AOAM532aP5Qw0F+996Vl49d1z8oxJD5oIUVma1BiUT8w0d0BGSwvCQQS
        GFzO0f/p2gFnQkEX4JES38c=
X-Google-Smtp-Source: ABdhPJxGrknstaFjATZi4QXUC2uFCzdYz47larpPKUlHSux1KjvUX/gpuNi5ZkbE+NOjdcWWBxpRig==
X-Received: by 2002:a17:90a:b88e:: with SMTP id o14mr658030pjr.226.1605207770025;
        Thu, 12 Nov 2020 11:02:50 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id z7sm7458809pfq.214.2020.11.12.11.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 11:02:49 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next 3/8] tcp: Refactor skb frag fast-forward op for recv zerocopy.
Date:   Thu, 12 Nov 2020 11:02:00 -0800
Message-Id: <20201112190205.633640-4-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
In-Reply-To: <20201112190205.633640-1-arjunroy.kdev@gmail.com>
References: <20201112190205.633640-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

Refactor skb frag fast-forwarding for tcp receive zerocopy. This is
part of a patch set that introduces short-circuited hybrid copies
for small receive operations, which results in roughly 33% fewer
syscalls for small RPC scenarios.

skb_advance_to_frag(), given a skb and an offset into the skb,
iterates from the first frag for the skb until we're at the frag
specified by the offset. Assuming the offset provided refers to how
many bytes in the skb are already read, the returned frag points to
the next frag we may read from, while offset_frag is set to the number
of bytes from this frag that we have already read.

If frag is not null and offset_frag is equal to 0, then we may be able
to map this frag's page into the process address space with
vm_insert_page(). However, if offset_frag is not equal to 0, then we
cannot do so.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>

---
 net/ipv4/tcp.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 49e33222a68b..ab19d0d00db1 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1743,6 +1743,28 @@ int tcp_mmap(struct file *file, struct socket *sock,
 }
 EXPORT_SYMBOL(tcp_mmap);
 
+static skb_frag_t *skb_advance_to_frag(struct sk_buff *skb, u32 offset_skb,
+				       u32 *offset_frag)
+{
+	skb_frag_t *frag;
+
+	offset_skb -= skb_headlen(skb);
+	if ((int)offset_skb < 0 || skb_has_frag_list(skb))
+		return NULL;
+
+	frag = skb_shinfo(skb)->frags;
+	while (offset_skb) {
+		if (skb_frag_size(frag) > offset_skb) {
+			*offset_frag = offset_skb;
+			return frag;
+		}
+		offset_skb -= skb_frag_size(frag);
+		++frag;
+	}
+	*offset_frag = 0;
+	return frag;
+}
+
 static int tcp_copy_straggler_data(struct tcp_zerocopy_receive *zc,
 				   struct sk_buff *skb, u32 copylen,
 				   u32 *offset, u32 *seq)
@@ -1865,6 +1887,8 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	curr_addr = address;
 	while (length + PAGE_SIZE <= zc->length) {
 		if (zc->recv_skip_hint < PAGE_SIZE) {
+			u32 offset_frag;
+
 			/* If we're here, finish the current batch. */
 			if (pg_idx) {
 				ret = tcp_zerocopy_vm_insert_batch(vma, pages,
@@ -1885,16 +1909,9 @@ static int tcp_zerocopy_receive(struct sock *sk,
 				skb = tcp_recv_skb(sk, seq, &offset);
 			}
 			zc->recv_skip_hint = skb->len - offset;
-			offset -= skb_headlen(skb);
-			if ((int)offset < 0 || skb_has_frag_list(skb))
+			frags = skb_advance_to_frag(skb, offset, &offset_frag);
+			if (!frags || offset_frag)
 				break;
-			frags = skb_shinfo(skb)->frags;
-			while (offset) {
-				if (skb_frag_size(frags) > offset)
-					goto out;
-				offset -= skb_frag_size(frags);
-				frags++;
-			}
 		}
 		if (skb_frag_size(frags) != PAGE_SIZE || skb_frag_off(frags)) {
 			int remaining = zc->recv_skip_hint;
-- 
2.29.2.222.g5d2a92d10f8-goog

