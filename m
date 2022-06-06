Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940D653E899
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238783AbiFFNVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 09:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238784AbiFFNVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 09:21:13 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4AF2E59A7
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 06:21:11 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id n197so3742106qke.1
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 06:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kF2JkIIzVgU+z8msbPXJBNc/p52m57iR0iCBDDJhZDg=;
        b=NnZTlw2xIkUCiqoKzYGwdEtARNXy6lCK4mzuD2R3XBXFfts6+lZ/XO39dCpfs+rlYg
         CwsbK2VwfFRs6+/K+FmIAt7+6s3bYv6QCfMGnvXInSeL74+vGJnaDi4eDEThf0InskCs
         27HZ7fkYLk/NGvzW73Ph2w/YaEwpT40PSIzvNHawbVSmhzrNK5YT+VwbL6Azv83qDRE4
         4j98u3txfdwY5dNoQQpLls0cqzK3m55CSPNacf6px/o8W84AZL34yPB7P1UUS++82upg
         U0K32DbVJbZ0BkCUtDfxhlrQL1ZQg+ME2S71g8/shyRrHjlMArGM9xvuHKlS6/Kqi33R
         4ntw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kF2JkIIzVgU+z8msbPXJBNc/p52m57iR0iCBDDJhZDg=;
        b=UA9frZFCjUKxqC86IMYs0HAR6v5Ga++wZJxkcAunw8EpK5dOnylycluAp4tOeW7c8f
         uJ9G4GpXRGvQBml2BOg20qW7eT0LkvkEZInS7WWksltF5E3DrlCnpoB0TI6338N/4LbD
         N2nVEDs4AEcYlGXFpHvOPFdXCL/WFuRghf7J+y38lYh8fszl0vWOvt4bhzcQomhaV6bm
         1FR8aa7MJa0NEzvGetKK/mcYGCgNm1zRTgV34976A82e0P5DXcycV+QiCen6M1bdmMlC
         QHP2ocFjwFtXdDsvNX9+QYyIWvdyVq1tCtVI87S4MV/X2WJ/In0VG2CNwZjrZjV170XB
         ABVA==
X-Gm-Message-State: AOAM530t2P11XP/2cQAk9mqQ7tLJ0UIpFhqDBvj5xZKXPZsye6InOrCF
        aDv5yO4faQX+lQQBGy2uYNOj/jq7z/U=
X-Google-Smtp-Source: ABdhPJwlHCPiuAkJTSLQOhmIV4s1agWyrX6MBhoDLhRlFrli9XdCsBPpdju15AwmGBvVoGa8vMZ+iw==
X-Received: by 2002:a37:a8cb:0:b0:6a6:ae6a:f3cd with SMTP id r194-20020a37a8cb000000b006a6ae6af3cdmr6938916qke.215.1654521670715;
        Mon, 06 Jun 2022 06:21:10 -0700 (PDT)
Received: from willemb.c.googlers.com.com (55.87.194.35.bc.googleusercontent.com. [35.194.87.55])
        by smtp.gmail.com with ESMTPSA id p21-20020ac87415000000b00304df352f21sm6541745qtq.42.2022.06.06.06.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 06:21:10 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] ip_gre: test csum_start instead of transport header
Date:   Mon,  6 Jun 2022 09:21:07 -0400
Message-Id: <20220606132107.3582565-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

GRE with TUNNEL_CSUM will apply local checksum offload on
CHECKSUM_PARTIAL packets.

ipgre_xmit must validate csum_start after an optional skb_pull,
else lco_csum may trigger an overflow. The original check was

	if (csum && skb_checksum_start(skb) < skb->data)
		return -EINVAL;

This had false positives when skb_checksum_start is undefined:
when ip_summed is not CHECKSUM_PARTIAL. A discussed refinement
was straightforward

	if (csum && skb->ip_summed == CHECKSUM_PARTIAL &&
	    skb_checksum_start(skb) < skb->data)
		return -EINVAL;

But was eventually revised more thoroughly:
- restrict the check to the only branch where needed, in an
  uncommon GRE path that uses header_ops and calls skb_pull.
- test skb_transport_header, which is set along with csum_start
  in skb_partial_csum_set in the normal header_ops datapath.

Turns out skbs can arrive in this branch without the transport
header set, e.g., through BPF redirection.

Revise the check back to check csum_start directly, and only if
CHECKSUM_PARTIAL. Do leave the check in the updated location.
Check field regardless of whether TUNNEL_CSUM is configured.

Link: https://lore.kernel.org/netdev/YS+h%2FtqCJJiQei+W@shredder/
Link: https://lore.kernel.org/all/20210902193447.94039-2-willemdebruijn.kernel@gmail.com/T/#u
Fixes: 8a0ed250f911 ("ip_gre: validate csum_start only on pull")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/ipv4/ip_gre.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 7e474a85deaf..3b9cd487075a 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -629,21 +629,20 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
 	}
 
 	if (dev->header_ops) {
-		const int pull_len = tunnel->hlen + sizeof(struct iphdr);
-
 		if (skb_cow_head(skb, 0))
 			goto free_skb;
 
 		tnl_params = (const struct iphdr *)skb->data;
 
-		if (pull_len > skb_transport_offset(skb))
-			goto free_skb;
-
 		/* Pull skb since ip_tunnel_xmit() needs skb->data pointing
 		 * to gre header.
 		 */
-		skb_pull(skb, pull_len);
+		skb_pull(skb, tunnel->hlen + sizeof(struct iphdr));
 		skb_reset_mac_header(skb);
+
+		if (skb->ip_summed == CHECKSUM_PARTIAL &&
+		    skb_checksum_start(skb) < skb->data)
+			goto free_skb;
 	} else {
 		if (skb_cow_head(skb, dev->needed_headroom))
 			goto free_skb;
-- 
2.36.1.255.ge46751e96f-goog

