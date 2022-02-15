Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F654B7A29
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 23:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243672AbiBOWFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 17:05:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235480AbiBOWFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 17:05:32 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B156A1EEC0;
        Tue, 15 Feb 2022 14:05:21 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id r76so210090pgr.10;
        Tue, 15 Feb 2022 14:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dDDOlmNFqQPUtIJmBHCY2QIaiUjiyb0ZsTU/D8n9slY=;
        b=QgZm8HhxITQBrEAP5EACOx4w9cYA2N4hu6QUDNkbuZo9+lcrR6l/odPwCEmGQfaewk
         vSqGM2hc3aTL0eYiYv9R3qDKAufy1qJ1Xuy5A6gs6HyhWfqxcYAPJR9+qunREaFBQzJV
         DUC/UkAqhfhF+HHi4E0Asx4OjVhgm2LRtPBrkWMvQpKecjZQB5yFEOuEY/w1toEone79
         bHKIfyI4PCf1m9WeTNweKwiD6pm3pPmYz+JKRtKk432Fxo1Mp1p7M72ZyvKeA0kaFAvA
         HkgEzGFT7Mb+MAulIRyEBwDxyGO9vRm605HdXR9qvfuLPZkzQEf8H9kLvVJZGaiVzbPI
         MYSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dDDOlmNFqQPUtIJmBHCY2QIaiUjiyb0ZsTU/D8n9slY=;
        b=yfpxdKiSdJFLnY/Dh85R3yj/1uO2LWTgzwhFE4RT4sDU4HkJ4Ru+IAkGGZUStr4wLl
         wQ3J3aEIeDgJCie5xjVusSlRIMrL1eYEuCdYG0HR45k/Ck0VmyBXHJCc1w29lWmREOWc
         D+pnDwQ62cK4l9tnG1Lp3yJ53iQvWbpcxhrnGXSZJFYQ47ZTLodlbrOufn3kUA5zTCNd
         NZraxjFIvRo2NNN7KH2ZRxv/MOX8tdyrqREvyONTlz9vh3wtRc2tAWjF9yrUImmlxjYs
         nh5d0wwhD973ouy2ny5k9hQbqVFpJ7aiqz9wb4KfznVcEpIXotoxb+YB54SJJIEF98GJ
         bWng==
X-Gm-Message-State: AOAM5334/zmUifjKtDgLTEQC+mA+0EhTo1rlAmnC720Av8W3XQsmvbSU
        vOsPp/XqC/f75WC/WNy4A7Q=
X-Google-Smtp-Source: ABdhPJwB0RRWOvxCp5oHvgXK7rKlYnzKA4PrLyq5QSqNxsoeCrskDVoa+6PGjvACOoGKvY0wUsiNGA==
X-Received: by 2002:a63:6cc1:: with SMTP id h184mr814216pgc.276.1644962721196;
        Tue, 15 Feb 2022 14:05:21 -0800 (PST)
Received: from jeffreyji1.c.googlers.com.com (180.145.227.35.bc.googleusercontent.com. [35.227.145.180])
        by smtp.gmail.com with ESMTPSA id om2sm3630952pjb.39.2022.02.15.14.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 14:05:20 -0800 (PST)
From:   Jeffrey Ji <jeffreyjilinux@gmail.com>
X-Google-Original-From: Jeffrey Ji <jeffreyji@google.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Brian Vazquez <brianvv@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Mahesh Bandewar <maheshb@google.com>,
        jeffreyji <jeffreyji@google.com>
Subject: [PATCH v1 net-next] teaming: deliver link-local packets with the link they arrive on
Date:   Tue, 15 Feb 2022 22:05:17 +0000
Message-Id: <20220215220517.2498751-1-jeffreyji@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
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

From: jeffreyji <jeffreyji@google.com>

skb is ignored if team port is disabled. We want the skb to be delivered
if it's an LLDP packet.

Issue is already fixed for bonding in commit
b89f04c61efe3b7756434d693b9203cc0cce002e

Signed-off-by: jeffreyji <jeffreyji@google.com>
---
 drivers/net/team/team.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 8b2adc56b92a..24d66dfbb2e1 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -734,6 +734,12 @@ static rx_handler_result_t team_handle_frame(struct sk_buff **pskb)
 	port = team_port_get_rcu(skb->dev);
 	team = port->team;
 	if (!team_port_enabled(port)) {
+		if (is_link_local_ether_addr(eth_hdr(skb)->h_dest))
+			/*
+			 * link-local packets are mostly useful when stack
+			 * receives them with the link they arrive on.
+			 */
+			return RX_HANDLER_PASS;
 		/* allow exact match delivery for disabled ports */
 		res = RX_HANDLER_EXACT;
 	} else {
-- 
2.35.1.265.g69c8d7142f-goog

