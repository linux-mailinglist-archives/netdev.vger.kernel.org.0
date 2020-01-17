Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF9F140442
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 08:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729221AbgAQHJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 02:09:26 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37020 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729011AbgAQHJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 02:09:26 -0500
Received: by mail-pl1-f196.google.com with SMTP id c23so9483135plz.4;
        Thu, 16 Jan 2020 23:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DCEXZjiPuUDxze4sqKJXmHDwjjbO/PgAp/+TH+NfY1o=;
        b=Nkb72vbrRG9CkP2Lj9OEsbs1AL4IqDsNYT5BEwrP8XHOHQHEy594SPH+roF8VIObW2
         NTOSxtdcnwKemmlhJgPBbECBVP3WRgaZq6Ehc3Qs9DOF4CNwiEQqCrtba3D9NBu9lK8J
         ENrGs9xXJTo0PkfdGVDKzmruRWbVz3hpgDDbF05xfn3kTezOtu2VSjoMminJKCEQICIb
         tcGRWTg+YccQFeS/sxGlzXLIqBmhK/yQj1w3lcyhUt34JzUdb9AThZ0Yon+eJXz7wqVM
         WxIk/+Y0wEl3ivVAroN871+uFOmSFng6bfzhb0ZKkiIkOb1VQ2o/rmZeoKW/OmyUFlR/
         7fUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DCEXZjiPuUDxze4sqKJXmHDwjjbO/PgAp/+TH+NfY1o=;
        b=nfOm8sV2562u/vjRANhnqTYQVZ7LbwiqPD7w1I9F5+/dzs82pCaUmgvvvcmOKbhZs1
         dPA10ht6BsW6TMrhGBe8ft1M1bUx7EiyqwNFm+VuYOLWZunC4PtHy0nZyxg2eG6ezqls
         CmtERgt+iKkE+rYNU92VH2A0EBABWHDjKr/LVZ3MsB6U9BOV0poSRglpxEtuojN+b1Lo
         HVvTpjCbio+oxLFB1Oo7LBKxFiKmcec/M2XPPPfvYBkuaY/wRQu+wQq/+Xkcnd7jaZJJ
         8fn4XwnfW51kvWYOpbX403q5VX+KsE7ce204Tshu+LA6PXa/Y3c8MW3hoHedlsRygfi4
         EaYg==
X-Gm-Message-State: APjAAAUcsNgw9KxZFd2CDsw5i8nDa8mO3p48dTAFmnnxMCgRW94LfVsq
        HsWoHfCLAZN1msqPW6i/Kg8=
X-Google-Smtp-Source: APXvYqxlPi81D9YnMewagzW+lZt9lwDL1Kfg2M6Z46J5RqarAXbt2TAGXZc6u2jRpsAii1qnRkmfbA==
X-Received: by 2002:a17:90a:98d:: with SMTP id 13mr4021119pjo.102.1579244965420;
        Thu, 16 Jan 2020 23:09:25 -0800 (PST)
Received: from hpg8-3.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id d4sm407499pjg.19.2020.01.16.23.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 23:09:25 -0800 (PST)
From:   Yoshiki Komachi <komachi.yoshiki@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Petar Penkov <ppenkov.kernel@gmail.com>
Cc:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v2 bpf 1/2] flow_dissector: Fix to use new variables for port ranges in bpf hook
Date:   Fri, 17 Jan 2020 16:05:32 +0900
Message-Id: <20200117070533.402240-2-komachi.yoshiki@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200117070533.402240-1-komachi.yoshiki@gmail.com>
References: <20200117070533.402240-1-komachi.yoshiki@gmail.com>
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
 net/core/flow_dissector.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 2dbbb03..cc32d1d 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -834,10 +834,10 @@ static void __skb_flow_bpf_to_target(const struct bpf_flow_keys *flow_keys,
 				     struct flow_dissector *flow_dissector,
 				     void *target_container)
 {
+	struct flow_dissector_key_ports *key_ports = NULL;
 	struct flow_dissector_key_control *key_control;
 	struct flow_dissector_key_basic *key_basic;
 	struct flow_dissector_key_addrs *key_addrs;
-	struct flow_dissector_key_ports *key_ports;
 	struct flow_dissector_key_tags *key_tags;
 
 	key_control = skb_flow_dissector_target(flow_dissector,
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

