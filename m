Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0CF957E50C
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 19:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbiGVRHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 13:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236061AbiGVRGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 13:06:48 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D815232ED8
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 10:06:47 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id c6so974309plc.5
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 10:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=MymOgYG9JoBkp23zdUNnPbG4phT1niah04TdEouQTAQ=;
        b=QpyXki6x/Vdk8VLjIZgRZjiVKunYnm4/Iols3X1WoI6NasxTlUerJGIguf1cbA5UCu
         PZgZz2l26BnKq1vV3ip5gjrP4gG2HvnEuEaXECSmngOs1XOCQX5nRhfnjg4yYI+6W4AJ
         Y9iW23L2KtxgXlfGhyHPBKkO4DRgjzIMJp7iU0vMJFDByA0JTVCckCU3Im9rr38PJVS3
         hZZS4L6FX8rABij5xbeFmB2AhUs4OcBnwHvPT8p/tCRf9UCMRleJvvFMTqPcWNFWedaS
         Fzfg0AL54E5XCphiUbU8a5bGTBtkRizyp0cCwqLCKIxaL4jxosnC5uo+1GN6Tc6l/zNI
         spPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MymOgYG9JoBkp23zdUNnPbG4phT1niah04TdEouQTAQ=;
        b=WU0yerIHv45+Xzw5jUaVs52YBDdcxYyRoyN5RGtkHQNdfFhxPF4o1M7mib50GvRMhu
         9lun5dEvpfrlE65NrB8Uw8BAz+5qtLcOquqzK3hwfMYP87PKiDAKlxVdAzsRnTKurv3f
         40gooD/P/XHi0lTQwgGWk/LGzis5qpSFTAhjmZHgcguyzA+sscy/SdN79BW1EJg5G1t8
         M3L+W49d47fu3sIDg1BpH504uYvoujY7njFCOgjHxoWM1W6V52pNmuoorObNCFRl/tuk
         U2bhKBiSw2Z+o3LGjPhKc00J35oP3oWzvLaXGMnSVkEpd/7XBohN6q7/92ATmbPrFV13
         AHSg==
X-Gm-Message-State: AJIora9mAiTBJ5pICgWM27Iq7ndfCpXoUV2q/iAV7Emzf3EgtFGfWzR+
        I+9P2pM6yn0eLvmfdQeJ8Eo=
X-Google-Smtp-Source: AGRyM1tC1uGWNZkuc8edcTY1sL5PWD//qs02ffZgzbDdaodXoVq2jYayHBxBDjzuG0HB7SQ9WU1kZw==
X-Received: by 2002:a17:90a:4402:b0:1f2:3507:5f96 with SMTP id s2-20020a17090a440200b001f235075f96mr640006pjg.22.1658509607139;
        Fri, 22 Jul 2022 10:06:47 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id k12-20020a170902ce0c00b0016c46ff9741sm3970522plg.67.2022.07.22.10.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 10:06:46 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com, liuhangbin@gmail.com
Subject: [PATCH net v2] net: mld: fix reference count leak in mld_{query | report}_work()
Date:   Fri, 22 Jul 2022 17:06:35 +0000
Message-Id: <20220722170635.14847-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mld_{query | report}_work() processes queued events.
If there are too many events in the queue, it re-queue a work.
And then, it returns without in6_dev_put().
But if queuing is failed, it should call in6_dev_put(), but it doesn't.
So, a reference count leak would occur.

THREAD0				THREAD1
mld_report_work()
				spin_lock_bh()
				if (!mod_delayed_work())
					in6_dev_hold();
				spin_unlock_bh()
	spin_lock_bh()
	schedule_delayed_work()
	spin_unlock_bh()

Script to reproduce(by Hangbin Liu):
   ip netns add ns1
   ip netns add ns2
   ip netns exec ns1 sysctl -w net.ipv6.conf.all.force_mld_version=1
   ip netns exec ns2 sysctl -w net.ipv6.conf.all.force_mld_version=1

   ip -n ns1 link add veth0 type veth peer name veth0 netns ns2
   ip -n ns1 link set veth0 up
   ip -n ns2 link set veth0 up

   for i in `seq 50`; do
           for j in `seq 100`; do
                   ip -n ns1 addr add 2021:${i}::${j}/64 dev veth0
                   ip -n ns2 addr add 2022:${i}::${j}/64 dev veth0
           done
   done
   modprobe -r veth
   ip -a netns del

splat looks like:
 unregister_netdevice: waiting for veth0 to become free. Usage count = 2
 leaked reference.
  ipv6_add_dev+0x324/0xec0
  addrconf_notify+0x481/0xd10
  raw_notifier_call_chain+0xe3/0x120
  call_netdevice_notifiers+0x106/0x160
  register_netdevice+0x114c/0x16b0
  veth_newlink+0x48b/0xa50 [veth]
  rtnl_newlink+0x11a2/0x1a40
  rtnetlink_rcv_msg+0x63f/0xc00
  netlink_rcv_skb+0x1df/0x3e0
  netlink_unicast+0x5de/0x850
  netlink_sendmsg+0x6c9/0xa90
  ____sys_sendmsg+0x76a/0x780
  __sys_sendmsg+0x27c/0x340
  do_syscall_64+0x43/0x90
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

Tested-by: Hangbin Liu <liuhangbin@gmail.com>
Fixes: f185de28d9ae ("mld: add new workqueues for process mld events")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2:
 - Fix commit message
 - Add reproducer script by Hangbin Liu

 net/ipv6/mcast.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 7f695c39d9a8..87c699d57b36 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1522,7 +1522,6 @@ static void mld_query_work(struct work_struct *work)
 
 		if (++cnt >= MLD_MAX_QUEUE) {
 			rework = true;
-			schedule_delayed_work(&idev->mc_query_work, 0);
 			break;
 		}
 	}
@@ -1533,8 +1532,10 @@ static void mld_query_work(struct work_struct *work)
 		__mld_query_work(skb);
 	mutex_unlock(&idev->mc_lock);
 
-	if (!rework)
-		in6_dev_put(idev);
+	if (rework && queue_delayed_work(mld_wq, &idev->mc_query_work, 0))
+		return;
+
+	in6_dev_put(idev);
 }
 
 /* called with rcu_read_lock() */
@@ -1624,7 +1625,6 @@ static void mld_report_work(struct work_struct *work)
 
 		if (++cnt >= MLD_MAX_QUEUE) {
 			rework = true;
-			schedule_delayed_work(&idev->mc_report_work, 0);
 			break;
 		}
 	}
@@ -1635,8 +1635,10 @@ static void mld_report_work(struct work_struct *work)
 		__mld_report_work(skb);
 	mutex_unlock(&idev->mc_lock);
 
-	if (!rework)
-		in6_dev_put(idev);
+	if (rework && queue_delayed_work(mld_wq, &idev->mc_report_work, 0))
+		return;
+
+	in6_dev_put(idev);
 }
 
 static bool is_in(struct ifmcaddr6 *pmc, struct ip6_sf_list *psf, int type,
-- 
2.17.1

