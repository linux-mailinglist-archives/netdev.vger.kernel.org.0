Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A476C258A
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 00:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjCTXTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 19:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbjCTXSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 19:18:49 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403E931E16
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 16:18:47 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id j24so3062505wrd.0
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 16:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679354325;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VrqIlTu/0bIjVxyg2aK9thOX2j7rB6cRSfw/ei1FZ00=;
        b=euhBgoPyeT5CcuoxbMHNCinY4XY7MHhdsZdu71IeLvmmbYIO4iDYLB2tDM1h7VKMmX
         PMX8eoNHhw9RMJeeu/Hwgdfe/60vUo6nI0r5dQf/h35daSrnHN+1ICfbNfvXDBYCYln/
         cbupG8lPiQdCkbY9zPXbDpO2TzHf0CsL2gYjN0EYTh2aqUBD/vVXHdniLqZWR6JNsOpF
         11QkX0sX8zTvWbco1Ixin//Th8Kj00OIvhk/eok6L+Zl53F3d9Q+MUU81mf11KENnLOu
         BlGE5Sx2FDsOercdFEWdiC3U1PzlrbJjNmjkT4T5zNQ1bdYVQg6rXcHM+spDFBlAbJh3
         +OeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679354325;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VrqIlTu/0bIjVxyg2aK9thOX2j7rB6cRSfw/ei1FZ00=;
        b=lGKte9hx/kYmN0gMVT9BqownTKUdFkxeqP+bMjarR2+mkiqlHr7k0GuTcWcat/Xd6e
         WPDOJs2rl8PAWcJaSUpTgmAOY5th9gg6uDZoBh6JAnwzDRk3Olk+XExHRtD5nfqD4Uh9
         XgrzJyfw84DtUE0zWiEc27dogLT/FMxp/hb0l5k0CGJWmIoZ5YjqZm8/bEMkXOtxjhW6
         oe/GHLzWCvvDdZzVTUpP3z3j0HiFkSI049f85j7+1+B/dlSWhJjHHMBLNE3DCFmWb0bh
         k3Bx4BTrJaUDo1lOiIHXd3Dvv6dmT0MvS7ZKmEmCkLB/nj2t+qOM1cGWlhShUzT308gd
         yPPw==
X-Gm-Message-State: AO0yUKUbWQEnHFEKwcD+PWRRyDz0niOjZ8BtanPO1OhlWopBeEvb+N5W
        JNBPJkH3iJnkB+treI8CSdpwBUlF1RtE7Q==
X-Google-Smtp-Source: AK7set8+Zsg0MHLDMVteIfhHk2IbFxEWT9sFwtOoSuIo6qw1oFuJQU14A3UoVRnWQ4Y/lOcvWN+Zyw==
X-Received: by 2002:a5d:6387:0:b0:2ce:a250:df68 with SMTP id p7-20020a5d6387000000b002cea250df68mr693252wru.28.1679354324910;
        Mon, 20 Mar 2023 16:18:44 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id n17-20020a5d4c51000000b002c54c9bd71fsm9862661wrt.93.2023.03.20.16.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 16:18:44 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v1] rtnetlink: Return error when message too short
Date:   Mon, 20 Mar 2023 23:18:34 +0000
Message-Id: <20230320231834.66273-1-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtnetlink_rcv_msg currently returns 0 when the message length is too
short. This leads to either no response at all, or an ack response
if NLM_F_ACK was set in the request.

Change rtnetlink_rcv_msg to return -EINVAL which tells af_netlink to
generate a proper error response.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 net/core/rtnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 5d8eb57867a9..04b7f184f32e 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -6086,7 +6086,7 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	/* All the messages must have at least 1 byte length */
 	if (nlmsg_len(nlh) < sizeof(struct rtgenmsg))
-		return 0;
+		return -EINVAL;
 
 	family = ((struct rtgenmsg *)nlmsg_data(nlh))->rtgen_family;
 	kind = rtnl_msgtype_kind(type);
-- 
2.39.0

