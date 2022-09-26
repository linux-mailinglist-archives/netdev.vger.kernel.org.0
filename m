Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5C05EB427
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 00:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiIZWGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 18:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiIZWGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 18:06:40 -0400
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAA05A16E;
        Mon, 26 Sep 2022 15:06:38 -0700 (PDT)
Received: by mail-il1-f182.google.com with SMTP id a2so4242585iln.13;
        Mon, 26 Sep 2022 15:06:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=l96haFyrXxNTE1u1owFXDxJUOTDMZwvAkT0nT31cjps=;
        b=l4xnb/r/YWDspzyK5mtU8kiVDBAglOiWxQeSOFV8mtsUIPzp0RFe1pBroSjAf6u/hq
         PI/cfsWHJn7eW7LKThT8YwyR4KjbdsSFoWPMrhKtVZK77dDvXGWi2x8A2qRs+OUMabIA
         lK31XRnwf3pnDiK0LJBJaoH+v05CjlG9vO6OLyge/fPj9AeXktmqmTvjfWseIxnI4zZD
         nhwef14RlZN8+Y9Niw/DaICcsWlfA29/qB2m9wnIZwO7Y4iVX8C1T5kJtG6pQeXbCRGc
         FIJPp0wdwWOwcdlmBkSDRj1TfmYCgnW0/Enz0SRYDwEv0CNPSG8dSbh8mfjLaUcOUqi0
         vXGQ==
X-Gm-Message-State: ACrzQf2I5JS1Nq4QParzpo+gVTpf1YsPWZEjtRe3vVFRjZ21mTud5Bdd
        VJ7/arIEkzAOVK47v1i5gXM=
X-Google-Smtp-Source: AMsMyM78bs8n3LoZHbCbdd8YueYP7TNZGVDaVL1FukYZZipfjUCZ1G4r9bgOBDFSz/rHewjDKFcIOg==
X-Received: by 2002:a05:6e02:1645:b0:2f8:3545:5470 with SMTP id v5-20020a056e02164500b002f835455470mr5100167ilu.245.1664229997262;
        Mon, 26 Sep 2022 15:06:37 -0700 (PDT)
Received: from noodle.cs.purdue.edu (switch-lwsn2133-z1r11.cs.purdue.edu. [128.10.127.250])
        by smtp.googlemail.com with ESMTPSA id a65-20020a021644000000b0034af3f3f9c0sm7471223jaa.118.2022.09.26.15.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 15:06:36 -0700 (PDT)
From:   Sungwoo Kim <iam@sung-woo.kim>
To:     luiz.dentz@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, iam@sung-woo.kim,
        johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH] Bluetooth: L2CAP: fix an illegal state transition from BT_DISCONN
Date:   Mon, 26 Sep 2022 18:02:13 -0400
Message-Id: <20220926220212.3170191-1-iam@sung-woo.kim>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CABBYNZLdvOzTwnHp4GX9PiXVMr2SDjD1NCXLRJw1_XLvSuZyjw@mail.gmail.com>
References: <CABBYNZLdvOzTwnHp4GX9PiXVMr2SDjD1NCXLRJw1_XLvSuZyjw@mail.gmail.com>
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

Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
---
 net/bluetooth/l2cap_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 2c9de67da..029de9f35 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4294,13 +4294,13 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 	mutex_lock(&conn->chan_lock);
 
 	if (scid) {
-		chan = __l2cap_get_chan_by_scid(conn, scid);
+		chan = l2cap_get_chan_by_scid(conn, scid);
 		if (!chan) {
 			err = -EBADSLT;
 			goto unlock;
 		}
 	} else {
-		chan = __l2cap_get_chan_by_ident(conn, cmd->ident);
+		chan = l2cap_get_chan_by_ident(conn, cmd->ident);
 		if (!chan) {
 			err = -EBADSLT;
 			goto unlock;
@@ -4336,6 +4336,7 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 	}
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 unlock:
 	mutex_unlock(&conn->chan_lock);
-- 
2.25.1

