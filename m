Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702704DE729
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 10:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240909AbiCSJDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 05:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiCSJDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 05:03:15 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B482E8CDA;
        Sat, 19 Mar 2022 02:01:55 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id w21so3023988pgm.7;
        Sat, 19 Mar 2022 02:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e/dFcz4P6IgKHiXznx7AmwYwJykX2xkD2n01/GT01yE=;
        b=jLZibxbrUBZUjT+x7UEYWA2ErB8y74n498/mD1uLg9vgr0g1tnVUzsOWKHzcMW5i0d
         vD/E2CFFWDrtasnmXK6Axj30L1YSPQgVbyBY7FrPFLWZzkW6umzF0jWEusrIGcnP6P4N
         BdJbp3LQGNZTgu0y5LkZrkrdgmoy/KUwaARQMNbr1jfKP3B3iEqeVOy6Y7I2lRdoKgSM
         u4C7JahBtQ9U/2/2cYuYcSs78Ye53aPklDm3zlcd0txnI6bjhcTVyg2V8dMGJJL6q1a5
         tWJ2FU5CWG5MCnkUBEwmpyrova0DYxbuVceeBQc6dEfoWiifwp2HWGyZB5S+a0rJiLve
         eI8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e/dFcz4P6IgKHiXznx7AmwYwJykX2xkD2n01/GT01yE=;
        b=0pnMbMlX3t8rXjakWHzqAU41/fcKKhJr3vmN7UonLqHMzw/wQtnCzE5a8ShqjN2qxl
         98YwzVxYiZP8ElNxCMbSi998hiALRrLeQTXiQIgD48d4zyy//aHtBsoD3RQMi5njL5kB
         kRYJTBvbNgLTRdYCtrihbX24EbkrT0k0UVfNMHOPHmO0XRYLv0wMTLxeqTwM0IGJVkhb
         99KOfcO3MomHxIuOXAzTSv6q/rueAw2Jr4PWXW9+9MNv73ltFpA2Utxtb+FUkmGvFJBD
         mKOPWXHvLqzt/uVmKqwlxfoBO0HLKHRocIJqwkwGzMBKarpwuAMqOx5sVD/x6jX6L5xj
         Q8LA==
X-Gm-Message-State: AOAM532bsy2TDLlIGvsz8c3Y4drPY6NRbLZY4pUAy2/BITgCTX/gV0KA
        4qPQAOYbAt9t/rFV+vz8TmM=
X-Google-Smtp-Source: ABdhPJxuF4a6T+R9xwNesLAP3GfNtOXVM2KzrB7mC0CW+ECy9rMWUUlvHpakDwILz5jleVVbB94UPQ==
X-Received: by 2002:a62:840b:0:b0:4fa:31ae:7739 with SMTP id k11-20020a62840b000000b004fa31ae7739mr14288202pfd.6.1647680514448;
        Sat, 19 Mar 2022 02:01:54 -0700 (PDT)
Received: from localhost.localdomain ([85.203.23.81])
        by smtp.gmail.com with ESMTPSA id h13-20020a056a00170d00b004f757a795fesm12179415pfc.219.2022.03.19.02.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 02:01:53 -0700 (PDT)
From:   zhouzhouyi@gmail.com
To:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Zhouyi Zhou <zhouzhouyi@gmail.com>, Wei Xu <xuweihf@ustc.edu.cn>
Subject: [PATCH] net:ipv4: send an ack when seg.ack > snd.nxt
Date:   Sat, 19 Mar 2022 17:01:42 +0800
Message-Id: <20220319090142.137998-1-zhouzhouyi@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhouyi Zhou <zhouzhouyi@gmail.com>

In RFC 793, page 72: If the ACK acks something not yet sent
(SEG.ACK > SND.NXT) then send an ACK, drop the segment,
and return. Fix Linux's behavior according to RFC 793.

Reported-by: Wei Xu <xuweihf@ustc.edu.cn>
Signed-off-by: Wei Xu <xuweihf@ustc.edu.cn>
Signed-off-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
---
 net/ipv4/tcp_input.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index bfe4112e000c..c10f84599655 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3771,11 +3771,13 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 		goto old_ack;
 	}
 
-	/* If the ack includes data we haven't sent yet, discard
-	 * this segment (RFC793 Section 3.9).
+	/* If the ack includes data we haven't sent yet, then send
+	 * an ack, drop this segment, and return (RFC793 Section 3.9).
 	 */
-	if (after(ack, tp->snd_nxt))
+	if (after(ack, tp->snd_nxt)) {
+		tcp_send_ack(sk);
 		return -1;
+	}
 
 	if (after(ack, prior_snd_una)) {
 		flag |= FLAG_SND_UNA_ADVANCED;
-- 
2.25.1

