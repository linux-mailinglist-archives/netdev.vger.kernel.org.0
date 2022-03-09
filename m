Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE9D4D379C
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236402AbiCIQfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237694AbiCIQbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:31:05 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564C114893D;
        Wed,  9 Mar 2022 08:25:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B1196CE1FCB;
        Wed,  9 Mar 2022 16:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1881BC340EC;
        Wed,  9 Mar 2022 16:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646843096;
        bh=Us0ddea7M4LNimZ1TRqKszvcE3LyqV9O8BoBA/Mrw4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jIKRAHqJCdh/w9vYFXnjz2mbnvEHhfLoVWsLGWU/Uq0ZtOwfIgNXleZSOMIXUSCaR
         QMK3rlBT4iKudVeaD+WTbDLod3BVxOBNYABBqlek2FvHGFEDxxpEBd1BHBSyGH1ZoF
         /TlElIOzIf3IF3AoRm/RNzjm8CQQOeXt+cCO2LZteKRA1lL4zsE/RwaOpyZdZiOIHM
         HMWgPBmvF91/2l7s/JXI/0dNFnKA1xuXr1SdbzOmxwMDHeC4nvHvqKklmcALlPaLcN
         5pHIKWFrau3Fc9G6gHQPl+wN0RriPmpgKG4dqt3GvWyod7tzYWex+ZbxfY/t5GBhVO
         rlPEErfKWn/cA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 16/19] tcp: make tcp_read_sock() more robust
Date:   Wed,  9 Mar 2022 11:23:33 -0500
Message-Id: <20220309162337.136773-16-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309162337.136773-1-sashal@kernel.org>
References: <20220309162337.136773-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e3d5ea2c011ecb16fb94c56a659364e6b30fac94 ]

If recv_actor() returns an incorrect value, tcp_read_sock()
might loop forever.

Instead, issue a one time warning and make sure to make progress.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20220302161723.3910001-2-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 9f53d25e047e..4815cf72569e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1652,11 +1652,13 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 				if (!copied)
 					copied = used;
 				break;
-			} else if (used <= len) {
-				seq += used;
-				copied += used;
-				offset += used;
 			}
+			if (WARN_ON_ONCE(used > len))
+				used = len;
+			seq += used;
+			copied += used;
+			offset += used;
+
 			/* If recv_actor drops the lock (e.g. TCP splice
 			 * receive) the skb pointer might be invalid when
 			 * getting here: tcp_collapse might have deleted it
-- 
2.34.1

