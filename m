Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96225AA9CD
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 10:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235665AbiIBIUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 04:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbiIBIUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 04:20:38 -0400
Received: from giacobini.uberspace.de (giacobini.uberspace.de [185.26.156.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B210732077
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 01:20:34 -0700 (PDT)
Received: (qmail 32432 invoked by uid 990); 2 Sep 2022 08:20:32 -0000
Authentication-Results: giacobini.uberspace.de;
        auth=pass (plain)
From:   Soenke Huster <soenke.huster@eknoes.de>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Soenke Huster <soenke.huster@eknoes.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] wifi: mac80211_hwsim: check length for virtio packets
Date:   Fri,  2 Sep 2022 10:19:58 +0200
Message-Id: <20220902081957.9718-1-soenke.huster@eknoes.de>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: +
X-Rspamd-Report: R_MISSING_CHARSET(0.5) MIME_GOOD(-0.1) MID_CONTAINS_FROM(1) BAYES_HAM(-0.162514)
X-Rspamd-Score: 1.237485
Received: from unknown (HELO unkown) (::1)
        by giacobini.uberspace.de (Haraka/2.8.28) with ESMTPSA; Fri, 02 Sep 2022 10:20:32 +0200
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
---
v2: Spelling

 drivers/net/wireless/mac80211_hwsim.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 4fb8f68e5c3b..6bd9bd50071e 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -5436,6 +5436,10 @@ static int hwsim_virtio_handle_cmd(struct sk_buff *skb)
 
 	nlh = nlmsg_hdr(skb);
 	gnlh = nlmsg_data(nlh);
+
+	if (skb->len < nlh->nlmsg_len)
+		return -EINVAL;
+
 	err = genlmsg_parse(nlh, &hwsim_genl_family, tb, HWSIM_ATTR_MAX,
 			    hwsim_genl_policy, NULL);
 	if (err) {
@@ -5478,7 +5482,8 @@ static void hwsim_virtio_rx_work(struct work_struct *work)
 	spin_unlock_irqrestore(&hwsim_virtio_lock, flags);
 
 	skb->data = skb->head;
-	skb_set_tail_pointer(skb, len);
+	skb_reset_tail_pointer(skb);
+	skb_put(skb, len);
 	hwsim_virtio_handle_cmd(skb);
 
 	spin_lock_irqsave(&hwsim_virtio_lock, flags);
-- 
2.37.3

