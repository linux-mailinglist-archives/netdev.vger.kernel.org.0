Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C8264C235
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 03:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237095AbiLNCVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 21:21:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237088AbiLNCVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 21:21:11 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFD622513
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 18:21:05 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id t18so3480281pfq.13
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 18:21:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=eAoqOZ8ZbSqgEFdPwK8pbry7m5I06cbSVu8iUYEfTtE=;
        b=ErYoj0pZ8ddg2toQoCPB+2BNUFYT8M24DcNPUAZHqCS+tVKxAE6E8BLGfPCT4gNx7r
         3nxTkPh+ojbVRGdnEjzMWaIiT00i8LlkD3pBoUNyUNKaKPHtP4Jw6Ocs+va3KsYb+hZ6
         s1vwkirSNA8JpQ2j6fhxNpAdMquF7iNQy9+vcgZjqCiEGHTRsdeqduzeHgH8ObGJ3FD7
         cFfdodZRSPVPSax0inhq75FOodQ4oMFONozEMWnm158hA59JP2jMs+Sb/k+H+Pb472Mr
         bmuIDt0yFdJLbIZB6pGeNFl/M4m2Nhl6SenMU3l88EGI2URsYtLZ/HCyn0ArTV6kNyr5
         4ZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eAoqOZ8ZbSqgEFdPwK8pbry7m5I06cbSVu8iUYEfTtE=;
        b=6/L6zzSu8C9QUyuc44YKyN85sqBsbJzfPJWvf26sZGxmfz1FLzYc3BC4B8avrDGu+S
         4JsP4nhD5dMio/IhFDYL+QBwP3hDwfH+MyyHrS/pFyHBuW0audrIEqgrCmbKsXwAsShY
         PE7myJ1ulKQuFzSV8TaR2FSV3Xra8fiQkammslVWNJTR6a9NBoC+liTsIKocOMrZnT7E
         hI25268DhnBPKm/IKoWCMY3H1q/6UXm7yws0CcC2/lGD7/QFaFvElKsW/ySC+jpeqnW7
         tWP4W/x6l25ZVc9z4TQgZvqLDPAjStijNE4vpId3YZb+NRAsB82EtKkR8kGnJ1WeNgMN
         1HEg==
X-Gm-Message-State: ANoB5pnT2hgyU+UM0kIzLBjtf2Yg/ZsEsb6CGgPCovOhoUYlcAry7DFW
        0tEj0QftaUshUY+vbaK23CoVDHUybagCDZhb
X-Google-Smtp-Source: AA0mqf6A920phepY8dxUL+V3ECT6+1TXiQawfifkUxClmN7G/+cHj0hzR9R6IOoZgwrYgbkyIBX81g==
X-Received: by 2002:a05:6a00:1696:b0:56c:2049:f55b with SMTP id k22-20020a056a00169600b0056c2049f55bmr29195069pfc.26.1670984465021;
        Tue, 13 Dec 2022 18:21:05 -0800 (PST)
Received: from niej-dt-7B47.. (80.251.214.228.16clouds.com. [80.251.214.228])
        by smtp.gmail.com with ESMTPSA id r22-20020aa79636000000b005749f5d9d07sm8498977pfg.99.2022.12.13.18.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 18:21:04 -0800 (PST)
From:   Jun Nie <jun.nie@linaro.org>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v2] net: sched: ematch: reject invalid data
Date:   Wed, 14 Dec 2022 10:20:58 +0800
Message-Id: <20221214022058.3625300-1-jun.nie@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported below bug. Refuse to compare for invalid data case to fix
it.

general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 PID: 6 Comm: kworker/0:0 Not tainted 5.15.77-syzkaller-00764-g7048384c9872 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: wg-crypt-wg2 wg_packet_tx_worker
RIP: 0010:em_cmp_match+0x4e/0x5f0 net/sched/em_cmp.c:25
Call Trace:
 <TASK>
 tcf_em_match net/sched/ematch.c:492 [inline]
 __tcf_em_tree_match+0x194/0x720 net/sched/ematch.c:518
 tcf_em_tree_match include/net/pkt_cls.h:463 [inline]
 basic_classify+0xd8/0x250 net/sched/cls_basic.c:48
 __tcf_classify net/sched/cls_api.c:1549 [inline]
 tcf_classify+0x161/0x430 net/sched/cls_api.c:1589
 prio_classify net/sched/sch_prio.c:42 [inline]
 prio_enqueue+0x1d3/0x6a0 net/sched/sch_prio.c:75
 dev_qdisc_enqueue net/core/dev.c:3792 [inline]
 __dev_xmit_skb+0x35c/0x1650 net/core/dev.c:3876
 __dev_queue_xmit+0x8f3/0x1b50 net/core/dev.c:4193
 dev_queue_xmit+0x17/0x20 net/core/dev.c:4261
 neigh_hh_output include/net/neighbour.h:508 [inline]
 neigh_output include/net/neighbour.h:522 [inline]
 ip_finish_output2+0xc0f/0xf00 net/ipv4/ip_output.c:228
 __ip_finish_output+0x163/0x370
 ip_finish_output+0x20b/0x220 net/ipv4/ip_output.c:316
 NF_HOOK_COND include/linux/netfilter.h:299 [inline]
 ip_output+0x1e9/0x410 net/ipv4/ip_output.c:430
 dst_output include/net/dst.h:450 [inline]
 ip_local_out+0x92/0xb0 net/ipv4/ip_output.c:126
 iptunnel_xmit+0x4a2/0x890 net/ipv4/ip_tunnel_core.c:82
 udp_tunnel_xmit_skb+0x1b6/0x2c0 net/ipv4/udp_tunnel_core.c:175
 send4+0x78d/0xd20 drivers/net/wireguard/socket.c:85
 wg_socket_send_skb_to_peer+0xd5/0x1d0 drivers/net/wireguard/socket.c:175
 wg_packet_create_data_done drivers/net/wireguard/send.c:251 [inline]
 wg_packet_tx_worker+0x202/0x560 drivers/net/wireguard/send.c:276
 process_one_work+0x6db/0xc00 kernel/workqueue.c:2313
 worker_thread+0xb3e/0x1340 kernel/workqueue.c:2460
 kthread+0x41c/0x500 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298

Reported-by: syzbot+963f7637dae8becc038f@syzkaller.appspotmail.com
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jun Nie <jun.nie@linaro.org>
---
 net/sched/em_cmp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/sched/em_cmp.c b/net/sched/em_cmp.c
index f17b049ea530..0284394be53f 100644
--- a/net/sched/em_cmp.c
+++ b/net/sched/em_cmp.c
@@ -22,9 +22,14 @@ static int em_cmp_match(struct sk_buff *skb, struct tcf_ematch *em,
 			struct tcf_pkt_info *info)
 {
 	struct tcf_em_cmp *cmp = (struct tcf_em_cmp *) em->data;
-	unsigned char *ptr = tcf_get_base_ptr(skb, cmp->layer) + cmp->off;
+	unsigned char *ptr;
 	u32 val = 0;
 
+	if (!cmp)
+		return 0;
+
+	ptr = tcf_get_base_ptr(skb, cmp->layer) + cmp->off;
+
 	if (!tcf_valid_offset(skb, ptr, cmp->align))
 		return 0;
 
-- 
2.34.1

