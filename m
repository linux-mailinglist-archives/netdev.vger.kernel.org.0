Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3639657A010
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234840AbiGSNur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236906AbiGSNua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 09:50:30 -0400
Received: from mail-m973.mail.163.com (mail-m973.mail.163.com [123.126.97.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB46781B0E;
        Tue, 19 Jul 2022 06:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=7TN6Y
        s6lyWLDn5YUA0Tv3OcWK4i5YKVKHK2RMkEF81k=; b=pfIMkLvrClzv+tPblYxnN
        BRSjghAtS0XZj2Sh4P1ks+cNl6ZLka48JcjSuiHaM9UZSox7XcUQTOJo9fUT4h+R
        sE74bC2KWJKCoADeMl35MftzBFBVHdNTB1Smzjiyd23VTv7UK+J7ML4gS67m8jKd
        MNiHass6M2iGTt2adNsSg8=
Received: from localhost.localdomain (unknown [112.95.163.118])
        by smtp3 (Coremail) with SMTP id G9xpCgDXc5VUq9ZixZwlQA--.4530S2;
        Tue, 19 Jul 2022 21:02:28 +0800 (CST)
From:   LemmyHuang <hlm3280@163.com>
To:     edumazet@google.com, davem@davemloft.net, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        LemmyHuang <hlm3280@163.com>
Subject: [PATCH net-next] tcp: fix condition for increasing pingpong count
Date:   Tue, 19 Jul 2022 21:01:37 +0800
Message-Id: <20220719130136.11907-1-hlm3280@163.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: G9xpCgDXc5VUq9ZixZwlQA--.4530S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GFWxZFy8Ary7tF1UAF4rGrg_yoWfArbEkw
        1DGrZFyr43Jrn7t34093yYqFy8KrsxWF1Fkr13uas3t3W8tF1DCrZ3Cry3ZrsYkr45Wry5
        Zws8tF1UZ342qjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_SdgJUUUUU==
X-Originating-IP: [112.95.163.118]
X-CM-SenderInfo: pkopjjiyq6il2tof0z/1tbiWAVD+VuHzZ1pcQAAsz
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_HZ defaults to 1000Hz and the network transmission time is
less than 1ms, lsndtime and lrcvtime are likely to be equal, which will
lead to hundreds of interactions before entering pingpong mode.

Signed-off-by: LemmyHuang <hlm3280@163.com>
---
 net/ipv4/tcp_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 858a15cc2..35ed65f80 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -172,7 +172,7 @@ static void tcp_event_data_sent(struct tcp_sock *tp,
 	 * and it is a reply for ato after last received packet,
 	 * increase pingpong count.
 	 */
-	if (before(tp->lsndtime, icsk->icsk_ack.lrcvtime) &&
+	if ((tp->lsndtime <= icsk->icsk_ack.lrcvtime) &&
 	    (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
 		inet_csk_inc_pingpong_cnt(sk);
 
-- 
2.27.0

