Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2846F5F0F9A
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbiI3QJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiI3QJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:09:46 -0400
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA7A23BDE;
        Fri, 30 Sep 2022 09:09:44 -0700 (PDT)
Received: by mail-il1-f172.google.com with SMTP id j7so2413970ilu.7;
        Fri, 30 Sep 2022 09:09:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=zNh+fWMDwTGcr2BpFoXyyeGxIhB+H3qzeZZ4m5l8+ik=;
        b=xUAxd5m1BXT4Co8TGgACxwuigyj0I04zKdSaziqHAUuksQrLTryIVcQ73jmOqQtlcN
         tiPFfGbZkFPOQo0i7qajAwZJ27AMpwjCU8RL11UY0tDd0dNdWlKf4Xrxap7IUMj3jxxp
         LT8xhZEEgldXUC8Cq2rXmKI3WpMkU8kpKzFuB9QbzLlyEpNBj/JAbd0TtoRC3kxLvPwL
         q0Abfq1M3g5DWY3Ck4JHb22vwhiS2XVlO92lanqYzZJTW6ak4a27JMLWXkD05GHw5wiE
         vnDDwpkmDlDCB3Pv0YSy3n/aaDc1yernkWdQSSo2d+SuxpIyfTOHBVpxgcbqGPQG8jEb
         4UGQ==
X-Gm-Message-State: ACrzQf2jX9TkHk87GSUxxCs5Gzj9Ak5m46orCDFh1kO7Cp47ydat0Aoq
        ZDOWMqE/i8LKVLZAoa9DBj6bl7G70yOcDQ==
X-Google-Smtp-Source: AMsMyM4XZqM+H4sFt9W42XxbCHGm2rvfwNtl0tYFBEHkkLEsQpr9NWkvLNuxXb8XcAAC9ks1dHsaBg==
X-Received: by 2002:a05:6e02:148c:b0:2f7:5790:7c3c with SMTP id n12-20020a056e02148c00b002f757907c3cmr4630125ilk.150.1664554183826;
        Fri, 30 Sep 2022 09:09:43 -0700 (PDT)
Received: from noodle.cs.purdue.edu (switch-lwsn2133-z1r11.cs.purdue.edu. [128.10.127.250])
        by smtp.googlemail.com with ESMTPSA id t2-20020a056e02060200b002eae6cf8898sm1093832ils.30.2022.09.30.09.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 09:09:43 -0700 (PDT)
From:   Sungwoo Kim <iam@sung-woo.kim>
To:     luiz.dentz@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, iam@sung-woo.kim,
        johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller@googlegroups.com
Subject: Re: KASAN: use-after-free in __mutex_lock
Date:   Fri, 30 Sep 2022 12:08:44 -0400
Message-Id: <20220930160843.818893-1-iam@sung-woo.kim>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CABBYNZKSnFJkyMoHn-TU1VJQz3WNNt0pC8Nvzdxb3-4-RtcQGw@mail.gmail.com>
References: <CABBYNZKSnFJkyMoHn-TU1VJQz3WNNt0pC8Nvzdxb3-4-RtcQGw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dentz,
How about to use l2cap_get_chan_by_scid because it looks resposible to
handle ref_cnt.

Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
---
 net/bluetooth/l2cap_core.c | 24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 2c9de67da..d3a074cbc 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4291,26 +4291,18 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 	BT_DBG("dcid 0x%4.4x scid 0x%4.4x result 0x%2.2x status 0x%2.2x",
 	       dcid, scid, result, status);
 
-	mutex_lock(&conn->chan_lock);
-
 	if (scid) {
-		chan = __l2cap_get_chan_by_scid(conn, scid);
-		if (!chan) {
-			err = -EBADSLT;
-			goto unlock;
-		}
+		chan = l2cap_get_chan_by_scid(conn, scid);
+		if (!chan)
+			return -EBADSLT;
 	} else {
-		chan = __l2cap_get_chan_by_ident(conn, cmd->ident);
-		if (!chan) {
-			err = -EBADSLT;
-			goto unlock;
-		}
+		chan = l2cap_get_chan_by_ident(conn, cmd->ident);
+		if (!chan)
+			return -EBADSLT;
 	}
 
 	err = 0;
 
-	l2cap_chan_lock(chan);
-
 	switch (result) {
 	case L2CAP_CR_SUCCESS:
 		l2cap_state_change(chan, BT_CONFIG);
@@ -4336,9 +4328,7 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 	}
 
 	l2cap_chan_unlock(chan);
-
-unlock:
-	mutex_unlock(&conn->chan_lock);
+	l2cap_chan_put(chan);
 
 	return err;
 }
-- 
2.25.1

