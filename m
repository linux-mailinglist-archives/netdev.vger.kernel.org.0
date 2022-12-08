Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B445646FCE
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 13:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiLHMfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 07:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLHMfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 07:35:38 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C7B25D2;
        Thu,  8 Dec 2022 04:35:37 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id m4so1384856pls.4;
        Thu, 08 Dec 2022 04:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=aPejqImKeJACjxlDpRteAkjWCypMthLoPPS+cioqUB0=;
        b=CAn1O0Pr+l2EYqjzxkTv4zGzVihrx1hsEKK+UOepBUmWFzGDtwCT4+2YQC19RYhyq5
         IIhlWSiIo+ZAUSAhfNr46snURvjO1bjOPdqgbgsapUi0ccY6xDcE2cbctJZqGn7bLOpZ
         rTMoz7qHjw0l8liO88aPb2Z4tJjUaJ6LXGsxZz4mBGYV+U+dsHXE/cC7bSg/hZWj6IfJ
         fzaum5ukzwnQWTEWG+FPnvqd4GAtcqwvKlV0/T77O3PYXfNZr3yS/RBZacdtw7PZq0Fu
         s1CMuTIHsbAA6IKhrHz1kDwjdQag1bijchku5/hvmyhfRXo7Ya/9CQp7JW8R+zMsYKgT
         LEmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aPejqImKeJACjxlDpRteAkjWCypMthLoPPS+cioqUB0=;
        b=I3exX3suwS7FvNCf8iGdrRZM8xYzxLcABolDpPvQEMDTDNZUzKt/vLGtB8CrA/jOTJ
         FcF1i7Y6NqNrhN6tniRUUgzvCckRRsZSwGwSJDhHHWK4UxTo6xK2lGKzNVQ/rtldGQUU
         igD8TGrxKgYRHpwNN3kAWHAFzEOMRIcrN62w0B2EZ9KFG8O6LUAwWliUOFS0WTh1AupC
         L029XBRWfhGBPXtrQhQvgp/noOC6422DnTLdGQBtSM2s6ZAhyNgz/LFB9LgruTAoQ6Wr
         MAPi8qrlXs154kYjx58fajcbCE9oxAMGrb8ueGZtPzNDe6JKBV7bjEalUbTI/RDst0Kr
         yI2w==
X-Gm-Message-State: ANoB5pmVEY/rIdkunHpo+VTlfAXARn76dJFL1lMd5WFT26O5JbUKK0iq
        oTrBHCAtweqNcYWVW8ORETg=
X-Google-Smtp-Source: AA0mqf4yUBIlQcRcSbRehS75pJHiGoKamT+Wenu4imOten66RfyFaFPik50cDjpJLrGHWXHldAGLFQ==
X-Received: by 2002:a17:90b:3551:b0:218:f477:da29 with SMTP id lt17-20020a17090b355100b00218f477da29mr73539979pjb.245.1670502936887;
        Thu, 08 Dec 2022 04:35:36 -0800 (PST)
Received: from localhost.localdomain ([218.82.140.42])
        by smtp.gmail.com with ESMTPSA id d15-20020a170903230f00b0018911ae9dfasm5265745plh.232.2022.12.08.04.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 04:35:36 -0800 (PST)
From:   Qingfang DENG <dqfext@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] netfilter: flowtable: really fix NAT IPv6 offload
Date:   Thu,  8 Dec 2022 20:35:29 +0800
Message-Id: <20221208123529.567883-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The for-loop was broken from the start. It translates to:

	for (i = 0; i < 4; i += 4)

which means the loop statement is run only once, so only the highest
32-bit of the IPv6 address gets mangled.

Fix the loop increment.

Fixes: 0e07e25b481a ("netfilter: flowtable: fix NAT IPv6 offload mangling")
Fixes: 5c27d8d76ce8 ("netfilter: nf_flow_table_offload: add IPv6 support")
Signed-off-by: Qingfang DENG <dqfext@gmail.com>
---
 net/netfilter/nf_flow_table_offload.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 00b522890d77..921eddf96dc4 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -383,12 +383,12 @@ static void flow_offload_ipv6_mangle(struct nf_flow_rule *flow_rule,
 				     const __be32 *addr, const __be32 *mask)
 {
 	struct flow_action_entry *entry;
-	int i, j;
+	int i;
 
-	for (i = 0, j = 0; i < sizeof(struct in6_addr) / sizeof(u32); i += sizeof(u32), j++) {
+	for (i = 0; i < sizeof(struct in6_addr) / sizeof(u32); i++) {
 		entry = flow_action_entry_next(flow_rule);
 		flow_offload_mangle(entry, FLOW_ACT_MANGLE_HDR_TYPE_IP6,
-				    offset + i, &addr[j], mask);
+				    offset + i * sizeof(u32), &addr[i], mask);
 	}
 }
 
-- 
2.34.1

