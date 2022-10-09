Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297805F94C8
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 02:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiJJAL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 20:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiJJALD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 20:11:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0E588DE9;
        Sun,  9 Oct 2022 16:45:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A572CB80DEE;
        Sun,  9 Oct 2022 22:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FB1C433D6;
        Sun,  9 Oct 2022 22:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354437;
        bh=s8XvSJ0CBvwlnj1YP3pu0XkLAMDkv8P0FO3gc3W4WDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dBki8gONEH7amQcah7+A/Gp1KPCIff1PI7APirH6Tj8yhIg9jchw+99nEiwW5Rqe6
         lSwPU9K4d18o3utljZqIE8+olTjRSFW5b4XETUwYrQmQVGKkD+TOKIRVkMyuFbsHbh
         QEbj6Uq0XNjcApaVCfyRTCTlo1JvOskK0QAg3Chx2poDEqJNKRtoJwbsxfS3qziXIv
         HaCtN+Bi826/bckt17BY0VFL6NIvyeLIoDXjMVFCzXmGvb9pygG6r0qpFpfuOCXoN2
         eMXvpDeMW407hYXnmatNSWR8lcC6vB4vFv/BxslSXPIbBOoW1de1ez7DoyEiHPRcTj
         8x142O5OoV3tQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Pattrick <mkp@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, pshelar@ovn.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, dev@openvswitch.org
Subject: [PATCH AUTOSEL 4.9 02/16] openvswitch: Fix overreporting of drops in dropwatch
Date:   Sun,  9 Oct 2022 18:26:58 -0400
Message-Id: <20221009222713.1220394-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222713.1220394-1-sashal@kernel.org>
References: <20221009222713.1220394-1-sashal@kernel.org>
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
index ab318844a19b..10423757e781 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -555,8 +555,9 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
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

