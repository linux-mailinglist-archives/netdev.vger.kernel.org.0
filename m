Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB80C5F937F
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 01:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbiJIXTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 19:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233546AbiJIXSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 19:18:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CBF34360A;
        Sun,  9 Oct 2022 15:44:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69B0360DB4;
        Sun,  9 Oct 2022 22:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8256C4347C;
        Sun,  9 Oct 2022 22:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354362;
        bh=m6NQJ5EmDqzyBSscFVL9+7RWcSwAfWV9TMWJzvPm/kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GSg20HMdsH/G0SMMROA9drv8IAux1Jgnl9/E6E8K2hKD+tpKtb6L1IzbhyfJ8ckKo
         fvdKVpzllF6p3nGNrVwPLCaC7vCUI4418NW9sZ+NempbJ5GKKwrs5FY58+appLmN1v
         gPozoR5/9JI2imn8E6cklf7XajCbbFrZPvHldrF/SPnRS/mLvylwXKJOykvwog82oX
         mWaDYRhfgZMjgsnulnEYaX3Z438C18A76jaBLV0CSPQVSVaVECMtujpC53TqSLkwD2
         3oMX9LWxDDAQGw7R0eyODBt7ZcCJ83ui7nDjFXAHQsEBnUtPsFtPrvSf5HQnMYlnEs
         qiK5qsACoFRkQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Pattrick <mkp@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, pshelar@ovn.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, dev@openvswitch.org
Subject: [PATCH AUTOSEL 4.14 02/23] openvswitch: Fix double reporting of drops in dropwatch
Date:   Sun,  9 Oct 2022 18:25:32 -0400
Message-Id: <20221009222557.1219968-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222557.1219968-1-sashal@kernel.org>
References: <20221009222557.1219968-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mike Pattrick <mkp@redhat.com>

[ Upstream commit 1100248a5c5ccd57059eb8d02ec077e839a23826 ]

Frames sent to userspace can be reported as dropped in
ovs_dp_process_packet, however, if they are dropped in the netlink code
then netlink_attachskb will report the same frame as dropped.

This patch checks for error codes which indicate that the frame has
already been freed.

Signed-off-by: Mike Pattrick <mkp@redhat.com>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2109946
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/datapath.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 3248cf04d0b3..42616aca0ce4 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -276,10 +276,17 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
 		upcall.portid = ovs_vport_find_upcall_portid(p, skb);
 		upcall.mru = OVS_CB(skb)->mru;
 		error = ovs_dp_upcall(dp, skb, key, &upcall, 0);
-		if (unlikely(error))
-			kfree_skb(skb);
-		else
+		switch (error) {
+		case 0:
+		case -EAGAIN:
+		case -ERESTARTSYS:
+		case -EINTR:
 			consume_skb(skb);
+			break;
+		default:
+			kfree_skb(skb);
+			break;
+		}
 		stats_counter = &stats->n_missed;
 		goto out;
 	}
-- 
2.35.1

