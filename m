Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB6E2B0D61
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgKLTDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:03:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727162AbgKLTC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:02:57 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFD3C0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:02:57 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id v12so5375457pfm.13
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ENPO+v4os7TsDF1riNbiaNyIMFiM3yB/cjtGO2Qk/DI=;
        b=UdHAUUXvD2IAL0B8AgO/QOVsxduTcvJjhjtrtvJVBtIdry9/4u+jYXo0Zec0MPaDoR
         5bJZ7VT/M24wOJjob6rGHaSeYFxrA9qTaVvEeu53DC3b9ICjUj85OxBLSP9UUHVfQVkG
         knXq9sGpzVh3Gmq7tGU5pkBayabEIAA+1PT7f+T2+Roj/spqYSWOehCG5sxqkBEDkRWZ
         S45IYvnA6cheGc6Yg8ZWbk8332smnLyvSO2s584TRaNrnYowjcDK7Et+t2hj8TAHfwCp
         M2OEJwsnij4HKq+4WBBdq1s/LJDoehnsKU0aS9QdQiaqwX5my/MWggNoiex9bSVfTRbq
         kpUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ENPO+v4os7TsDF1riNbiaNyIMFiM3yB/cjtGO2Qk/DI=;
        b=in15RN4tF11JeDV4nr7vDNBwsf/IscmNLQF0SWcyvc2s8PcBqqbrALktJuNa2TTMiM
         Vw/aHNXZHpZTj7t6h6NJUwdwF1CosW+gVcc9aYM36hD10f3ZTKC9dsKKSCE09nvGqXVc
         0ElLwZ5dfUJqHYm2eZSW7UCR3WolNiEGYbtsXfjyArCROmCDH9jQGo2FSjM6WNj0NRyK
         HXf/NVsFc+wCeJNgjeJlU82oRU95Oo5wiaP7gSY9X7zh5ZD0s9HKpl0EJLk7Hy73Z8hA
         S1ofhK/Eq9nuFW5t+Pr4XqSdy8yhyHV33xicHaeNx2zu64IbDmCgyCTiwkuxT83o7Nv9
         TZ6w==
X-Gm-Message-State: AOAM531d13EzUurbaFShLExt8DHG1Tf2qM7SKiNvvAL1kC13/Up0m69/
        D2PG3nZdBLyQst7rTxpbSZQ=
X-Google-Smtp-Source: ABdhPJzgJUFaYb3C8gwM89KTlz+PlZh+qgKPusOydUC1MCe4lcr8Yqfg6lAXmtUEvvDbDPqUYJmM4g==
X-Received: by 2002:a63:6484:: with SMTP id y126mr794209pgb.320.1605207776855;
        Thu, 12 Nov 2020 11:02:56 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id z7sm7458809pfq.214.2020.11.12.11.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 11:02:56 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next 4/8] tcp: Refactor frag-is-remappable test for recv zerocopy.
Date:   Thu, 12 Nov 2020 11:02:01 -0800
Message-Id: <20201112190205.633640-5-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
In-Reply-To: <20201112190205.633640-1-arjunroy.kdev@gmail.com>
References: <20201112190205.633640-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

Refactor frag-is-remappable test for tcp receive zerocopy. This is
part of a patch set that introduces short-circuited hybrid copies
for small receive operations, which results in roughly 33% fewer
syscalls for small RPC scenarios.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>

---
 net/ipv4/tcp.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ab19d0d00db1..f3bd606a678d 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1765,6 +1765,26 @@ static skb_frag_t *skb_advance_to_frag(struct sk_buff *skb, u32 offset_skb,
 	return frag;
 }
 
+static bool can_map_frag(const skb_frag_t *frag)
+{
+	return skb_frag_size(frag) == PAGE_SIZE && !skb_frag_off(frag);
+}
+
+static int find_next_mappable_frag(const skb_frag_t *frag,
+				   int remaining_in_skb)
+{
+	int offset = 0;
+
+	if (likely(can_map_frag(frag)))
+		return 0;
+
+	while (offset < remaining_in_skb && !can_map_frag(frag)) {
+		offset += skb_frag_size(frag);
+		++frag;
+	}
+	return offset;
+}
+
 static int tcp_copy_straggler_data(struct tcp_zerocopy_receive *zc,
 				   struct sk_buff *skb, u32 copylen,
 				   u32 *offset, u32 *seq)
@@ -1886,6 +1906,8 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	ret = 0;
 	curr_addr = address;
 	while (length + PAGE_SIZE <= zc->length) {
+		int mappable_offset;
+
 		if (zc->recv_skip_hint < PAGE_SIZE) {
 			u32 offset_frag;
 
@@ -1913,15 +1935,11 @@ static int tcp_zerocopy_receive(struct sock *sk,
 			if (!frags || offset_frag)
 				break;
 		}
-		if (skb_frag_size(frags) != PAGE_SIZE || skb_frag_off(frags)) {
-			int remaining = zc->recv_skip_hint;
 
-			while (remaining && (skb_frag_size(frags) != PAGE_SIZE ||
-					     skb_frag_off(frags))) {
-				remaining -= skb_frag_size(frags);
-				frags++;
-			}
-			zc->recv_skip_hint -= remaining;
+		mappable_offset = find_next_mappable_frag(frags,
+							  zc->recv_skip_hint);
+		if (mappable_offset) {
+			zc->recv_skip_hint = mappable_offset;
 			break;
 		}
 		pages[pg_idx] = skb_frag_page(frags);
-- 
2.29.2.222.g5d2a92d10f8-goog

