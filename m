Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D22687849
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 10:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbjBBJH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 04:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjBBJH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 04:07:57 -0500
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19DC5457E;
        Thu,  2 Feb 2023 01:07:54 -0800 (PST)
Received: by mail-il1-f169.google.com with SMTP id k12so511989ilv.10;
        Thu, 02 Feb 2023 01:07:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zIRdF85vz4XW6DcLekDt+urDLZMgRkhDxffDT09XGig=;
        b=v3/AjWBkPGYl8kZF6pnz+36Rs5AN0jHmUCERNFHTjZL+/aGN640pU7HIdm3j734V6i
         Miy1Tcc3w9MfVzJyV8/iEFWWOO3xGh8EzbALzUYhUhD8VwjAKDMpjNO7O6G52etYmiFn
         XWuqWZT7/M7y9XWEOHnL5f85f6aOxY7gS5x/L9ypzzBGKMlxH6TTZnIew14Vvdy+PvBs
         yvkq0SWRG8WidfW1jUh4BSbNmZ4u8CfNNtTTeMPwqaiAURiLEJTzA0qONRvJ5FAer6Mk
         SKzmpouLyjDAih6P8z3qEctda0plgayGq96lZOtyDWwqsfXqovXFOggjPaCsUGRsEWuQ
         5M9w==
X-Gm-Message-State: AO0yUKXbzENfXT0UsCFweJ1wnERo9ablNIXCQ83wIvQ2WH5q2P105Q/N
        +p1KJDq17S7c0R9yalFC0X8=
X-Google-Smtp-Source: AK7set8lXx3igPuv310qG/qtYBdKrnlNfIecy7hsXLIWasL58nylKiiZ/rDT5vvQZvxmn8FET4zRAw==
X-Received: by 2002:a92:c56a:0:b0:310:eb55:3856 with SMTP id b10-20020a92c56a000000b00310eb553856mr1376591ilj.9.1675328873930;
        Thu, 02 Feb 2023 01:07:53 -0800 (PST)
Received: from noodle.cs.purdue.edu (switch-lwsn2133-z1r11.cs.purdue.edu. [128.10.127.250])
        by smtp.googlemail.com with ESMTPSA id x12-20020a92dc4c000000b003110c59e2easm2060637ilq.37.2023.02.02.01.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 01:07:53 -0800 (PST)
From:   Sungwoo Kim <iam@sung-woo.kim>
To:     happiness.sung.woo@gmail.com
Cc:     benquike@gmail.com, davem@davemloft.net, daveti@purdue.edu,
        edumazet@google.com, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        pabeni@redhat.com, wuruoyu@me.com, Sungwoo Kim <iam@sung-woo.kim>
Subject: [PATCH] Bluetooth: L2CAP: Fix use-after-free
Date:   Thu,  2 Feb 2023 04:05:10 -0500
Message-Id: <20230202090509.2774062-1-iam@sung-woo.kim>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123091708.4112735-1-git@sung-woo.kim>
References: <20230123091708.4112735-1-git@sung-woo.kim>
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

Due to the race condition between l2cap_sock_cleanup_listen and
l2cap_sock_close_cb, l2cap_sock_kill can receive already freed sk,
resulting in use-after-free inside l2cap_sock_kill.
This patch prevent this by adding a null check in l2cap_sock_kill.

Context 1:
l2cap_sock_cleanup_listen();
  // context switched
  l2cap_chan_lock(chan);
  l2cap_sock_kill(sk); // <-- sk is already freed below

Context 2:
l2cap_chan_timeout();
  l2cap_chan_lock(chan);
  chan->ops->close(chan);
    l2cap_sock_close_cb()
    l2cap_sock_kill(sk); // <-- sk is freed here
  l2cap_chan_unlock(chan);

Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
---
 net/bluetooth/l2cap_sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index ca8f07f35..657704059 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1245,7 +1245,7 @@ static int l2cap_sock_recvmsg(struct socket *sock, struct msghdr *msg,
  */
 static void l2cap_sock_kill(struct sock *sk)
 {
-	if (!sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket)
+	if (!sk || !sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket)
 		return;
 
 	BT_DBG("sk %p state %s", sk, state_to_string(sk->sk_state));
-- 
2.25.1

