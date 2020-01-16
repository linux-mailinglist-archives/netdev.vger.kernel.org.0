Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8859213D63D
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 09:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgAPIza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 03:55:30 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41817 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbgAPIza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 03:55:30 -0500
Received: by mail-pg1-f196.google.com with SMTP id x8so9558978pgk.8;
        Thu, 16 Jan 2020 00:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MUkLYY954rcoPOwsIZk8Xq7lxG3vBmq9NA/eH8KRrAo=;
        b=erukzg1UPJ4RYigm3alRCBb0FFY5YRajqg4zJ2WLA6riVm3ewh1QV1Xvp4Z/f1EUED
         C77llxgql6NOr9ia44I1TbHhbn8WaQVVX6T4fIM/7e1SIp+rFFJJQmuVRj8+LBaT2MRG
         ynuRD2ZEN5xE5yU4kANEoMuiCMQ9xNmLIqizQFaLasljCqT/hV2XW9f7jxKt3zFavJEv
         LF02f8PNmTe2uPVn986NM/kh86XzZGxCf5v4iAkhxEcWN+mZaffYDikKDN/jsVZs2PgH
         L2bSfFi4usaszH4kthgRgy3bTPm2rMMBe0yUHtEUl0g8jH+KO6KgIKghoFdhzGV2naed
         kq4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MUkLYY954rcoPOwsIZk8Xq7lxG3vBmq9NA/eH8KRrAo=;
        b=aquIkCSiY+4OqWULHS6Iobo2uscxfnNzaPFpk9LNaT+c3VH2wuryLl7nnfjwnJO9Xi
         SRfDkFOpdg1KxiUpr0od6XJ3tucLayFPuxDaQUrV2ygk0J1vQNxJUzgDBNllBAbGRczl
         TxbyQoP12ITR/9oYFw+5ZZbU57m36aTLv+wShnXH3UtQDWQUYCcSwwflQ/owF61kEAPC
         8A3mZvKdPsW7QbrUgkdLNTBbR5U3ZlN8Onlnmxl2JEIMj7JdzGZiHCK8HA5bTWhu0kAK
         JQU9D/gZlgAaLC3k6yP3Abqb9A69BJC3td2A+HHnyEONCaho9heGCnFCIh1wCB8yr2ZR
         zJnw==
X-Gm-Message-State: APjAAAUNB2QpfxlKjdgDRDDcuUGOBAjiCEQCbss8BByI3xIL9+Tu233x
        nCyXMwpntw3YvVJlZc/QTEo=
X-Google-Smtp-Source: APXvYqwbBp9GQ00fnhZdhEnrQ2l+l/LzSJ28bDhW1ZUC2hOZd32XMK7wPNy1SvbFLTj7J5uFVegzrg==
X-Received: by 2002:a63:eb02:: with SMTP id t2mr38147335pgh.289.1579164929558;
        Thu, 16 Jan 2020 00:55:29 -0800 (PST)
Received: from hpg8-3.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id h3sm2643746pjs.0.2020.01.16.00.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 00:55:29 -0800 (PST)
From:   Yoshiki Komachi <komachi.yoshiki@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf 1/2] flow_dissector: Fix to use new variables for port ranges in bpf hook
Date:   Thu, 16 Jan 2020 17:51:32 +0900
Message-Id: <20200116085133.392205-2-komachi.yoshiki@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200116085133.392205-1-komachi.yoshiki@gmail.com>
References: <20200116085133.392205-1-komachi.yoshiki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch applies new flag (FLOW_DISSECTOR_KEY_PORTS_RANGE) and
field (tp_range) to BPF flow dissector to generate appropriate flow
keys when classified by specified port ranges.

Fixes: 8ffb055beae5 ("cls_flower: Fix the behavior using port ranges with hw-offload")
Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>
---
 net/core/flow_dissector.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 2dbbb03..06bbcc3 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -876,10 +876,17 @@ static void __skb_flow_bpf_to_target(const struct bpf_flow_keys *flow_keys,
 		key_control->addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
 	}
 
-	if (dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_PORTS)) {
+	if (dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_PORTS))
 		key_ports = skb_flow_dissector_target(flow_dissector,
 						      FLOW_DISSECTOR_KEY_PORTS,
 						      target_container);
+	else if (dissector_uses_key(flow_dissector,
+				    FLOW_DISSECTOR_KEY_PORTS_RANGE))
+		key_ports = skb_flow_dissector_target(flow_dissector,
+						      FLOW_DISSECTOR_KEY_PORTS_RANGE,
+						      target_container);
+
+	if (key_ports) {
 		key_ports->src = flow_keys->sport;
 		key_ports->dst = flow_keys->dport;
 	}
-- 
1.8.3.1

