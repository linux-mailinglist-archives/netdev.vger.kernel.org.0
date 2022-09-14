Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796105B8430
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiINJIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbiINJG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:06:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13147695D;
        Wed, 14 Sep 2022 02:03:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 390DFCE0B6E;
        Wed, 14 Sep 2022 09:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15058C433D6;
        Wed, 14 Sep 2022 09:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146215;
        bh=AQZuKQTaFEv6omVx7VYtueIw0AkvLPRhTv6vG53HRwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n32EaNCsCue/dQMfVS5v4UybjqeztSPZn5AjnrKMkDc4uDxlvagPwuyhDsM7S3ESO
         KHX/QWne3bxb7jOIheXjF6mHtCtFBoTuJhsUuLxmND6SfeHpo42EsOtvUQg19uLBUU
         0uKWWKj42oDO8wfAIXVxpzUuRu3tMhVrBL7FQ5uakvqlsFpTo9NpYzZwk+N7g71+q7
         bI27S2UpqYzEY09uOlZxwVQwe17KBKKD7YHRutXaxnzQqShkQIN4XtnjOFj5d618Bk
         AhimOxaufhNLKXoezrpOuswsfgJOec07dqOUhxyqPUGrQR7UyPPxrMh9zTSPULCrUM
         ltb7f7HB1nh/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Soenke Huster <soenke.huster@eknoes.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 05/13] wifi: mac80211_hwsim: check length for virtio packets
Date:   Wed, 14 Sep 2022 05:03:07 -0400
Message-Id: <20220914090317.471116-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090317.471116-1-sashal@kernel.org>
References: <20220914090317.471116-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Soenke Huster <soenke.huster@eknoes.de>

[ Upstream commit 8c0427842aaef161a38ac83b7e8d8fe050b4be04 ]

An invalid packet with a length shorter than the specified length in the
netlink header can lead to use-after-frees and slab-out-of-bounds in the
processing of the netlink attributes, such as the following:

  BUG: KASAN: slab-out-of-bounds in __nla_validate_parse+0x1258/0x2010
  Read of size 2 at addr ffff88800ac7952c by task kworker/0:1/12

  Workqueue: events hwsim_virtio_rx_work
  Call Trace:
   <TASK>
   dump_stack_lvl+0x45/0x5d
   print_report.cold+0x5e/0x5e5
   kasan_report+0xb1/0x1c0
   __nla_validate_parse+0x1258/0x2010
   __nla_parse+0x22/0x30
   hwsim_virtio_handle_cmd.isra.0+0x13f/0x2d0
   hwsim_virtio_rx_work+0x1b2/0x370
   process_one_work+0x8df/0x1530
   worker_thread+0x575/0x11a0
   kthread+0x29d/0x340
   ret_from_fork+0x22/0x30
 </TASK>

Discarding packets with an invalid length solves this.
Therefore, skb->len must be set at reception.

Change-Id: Ieaeb9a4c62d3beede274881a7c2722c6c6f477b6
Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 8e412125a49c1..50190ded7edc7 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -4209,6 +4209,10 @@ static int hwsim_virtio_handle_cmd(struct sk_buff *skb)
 
 	nlh = nlmsg_hdr(skb);
 	gnlh = nlmsg_data(nlh);
+
+	if (skb->len < nlh->nlmsg_len)
+		return -EINVAL;
+
 	err = genlmsg_parse(nlh, &hwsim_genl_family, tb, HWSIM_ATTR_MAX,
 			    hwsim_genl_policy, NULL);
 	if (err) {
@@ -4251,7 +4255,8 @@ static void hwsim_virtio_rx_work(struct work_struct *work)
 	spin_unlock_irqrestore(&hwsim_virtio_lock, flags);
 
 	skb->data = skb->head;
-	skb_set_tail_pointer(skb, len);
+	skb_reset_tail_pointer(skb);
+	skb_put(skb, len);
 	hwsim_virtio_handle_cmd(skb);
 
 	spin_lock_irqsave(&hwsim_virtio_lock, flags);
-- 
2.35.1

