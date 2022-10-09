Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE89E5F94BB
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 02:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbiJJAEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 20:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbiJJAEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 20:04:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2913351A29;
        Sun,  9 Oct 2022 16:37:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA1C560C91;
        Sun,  9 Oct 2022 22:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CCAEC433D6;
        Sun,  9 Oct 2022 22:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354101;
        bh=KOyJZ8EAro8rxOf+fthAnt3nxSGIZ91HYgHAzMiTWno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L2irWoyPQeAhkarMEdo5WKJztJ7q5lPVNDzqe+FxKmn5STLAlFergd6/pzFU8Edsg
         n98Z4CVS8laSfDkjtk4fOEZAusg0QUbCQdCfrovGSYUNnhQ6/yTjtWEkCENNFJzc6y
         H5LR+58LAo7R5WM7499AQO198ulTTU+jdiapzyrC9KwDlW+1ZXOkdlVz7/yOZrmtCX
         D9nEc74Z803drdJ9LuDwwKIZpYTMEjYzEFUq6J1nY4nwE7QO5iYs2sXvQ5WjdVWBIU
         SCtAayBy/zTdwWqEo6+jQlpkS5pXZntRMLQC267+TWv0VPzwS0NzT3HpNIvpCgvNxW
         zN7/TXXoQ3gOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Pattrick <mkp@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, pshelar@ovn.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, dev@openvswitch.org
Subject: [PATCH AUTOSEL 5.10 04/34] openvswitch: Fix double reporting of drops in dropwatch
Date:   Sun,  9 Oct 2022 18:20:58 -0400
Message-Id: <20221009222129.1218277-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222129.1218277-1-sashal@kernel.org>
References: <20221009222129.1218277-1-sashal@kernel.org>
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
index 9d6ef6cb9b26..4d2d91d6f990 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -241,10 +241,17 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
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

