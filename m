Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 277F75F9004
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbiJIWT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbiJIWST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:18:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2E527FD8;
        Sun,  9 Oct 2022 15:16:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F83B60DC4;
        Sun,  9 Oct 2022 22:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22B0C433D6;
        Sun,  9 Oct 2022 22:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353741;
        bh=F91BAdOXkp+xhwYRMD0QHptsZMxc0ARjOGzeltr8YbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KLKT9LJYVcqDRUAkECaZqpbCTsEYbCITNL11U7mcx+ZS+UR4VrakQE/uMJPQLlBm+
         k94nBOadCntBBFDvpQn0d6MQ6Rr+oRwizVIgyDe9fkLr7GzoU7DQZFfE7GkD9ohYy2
         BDMi3eouXgb3sM7E6CaIwMX76yP6mRtL1MKWljZQKrhrdF2b6fDGTMCZQJd/nAXxip
         6ccjpUA4Mof0iXH5ZLfM5P09VoDwmuRHS1Y60FAI0oV8O1dEFFfyPyLIkZoerbS3pq
         645R76LPVWlMHvOwIUSXUkqwiMv45hg5Q7CIRG/DLm5a7xGp5PiNiPZxRJYzOyDnvX
         JhlR3iIiH8YLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Pattrick <mkp@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, pshelar@ovn.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, dev@openvswitch.org
Subject: [PATCH AUTOSEL 5.19 09/73] openvswitch: Fix overreporting of drops in dropwatch
Date:   Sun,  9 Oct 2022 18:13:47 -0400
Message-Id: <20221009221453.1216158-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221453.1216158-1-sashal@kernel.org>
References: <20221009221453.1216158-1-sashal@kernel.org>
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

[ Upstream commit c21ab2afa2c64896a7f0e3cbc6845ec63dcfad2e ]

Currently queue_userspace_packet will call kfree_skb for all frames,
whether or not an error occurred. This can result in a single dropped
frame being reported as multiple drops in dropwatch. This functions
caller may also call kfree_skb in case of an error. This patch will
consume the skbs instead and allow caller's to use kfree_skb.

Signed-off-by: Mike Pattrick <mkp@redhat.com>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2109957
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/datapath.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index b68ba3c72519..93c596e3b22b 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -558,8 +558,9 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
 out:
 	if (err)
 		skb_tx_error(skb);
-	kfree_skb(user_skb);
-	kfree_skb(nskb);
+	consume_skb(user_skb);
+	consume_skb(nskb);
+
 	return err;
 }
 
-- 
2.35.1

