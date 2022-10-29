Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3394612328
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 15:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiJ2NLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 09:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiJ2NLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 09:11:18 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51C46918F;
        Sat, 29 Oct 2022 06:11:11 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id h2so7076622pgp.4;
        Sat, 29 Oct 2022 06:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DZK5NQKMxu7Q7E+ji+/bWQancP2wJOHTkQ/B4KtPPIU=;
        b=FJ7o32Gllk7KI9sdfQ2eYONOatmIj1khojCKJVqftg8E5DWx6Ty8537rzVV2hveavq
         v6SF1dVE4KOC38S/3jV7BjoKPuHcSN3NhrmjaaS0BS+ri8Y0a86jh7nxZJdQ4FMCsVBV
         FB6wKOOSWUaJ4rsPjRmIK0LXT3JGJ70D7vC1osZbAcVn6teIGyUZHkNXIozn5NkK6Hun
         Yuq0xdxiG2yLaEbkcS+HR5SArtJj1dH58kUSyvWNIY8rWHsydHO3c0tyiQ6g0Ut8711j
         ZDeiw+iIrJhIzXBAjAgXIt5wuzoy2ZBfiuUN9uwYLmNIjtAe9VcAp64hPHc86iikMlR2
         hkIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DZK5NQKMxu7Q7E+ji+/bWQancP2wJOHTkQ/B4KtPPIU=;
        b=6xx+DfBzK7bBsxM6QV4hz1bmEkdrHmmDUp8VFjGXWoqgCiglnx66lHNTyTa9DnbsYV
         UEZKcUffy82E1q0tFsMHtuJCIEmwyIW9qbSh5TfzTHgQQAJu0YQqbvm1GssXi9pkKuVY
         CCUazm+yqe1cpmJ7fLG2w4SVG38/5zbauHV7dw6L+nMSqkr4NgKpzV6harqDbZ6ONMzH
         ESnqjS9UCbD8tB9bHCiqKrjxsf+McEHPuavUznn/UrmS45xU2SbNleJPmwbW8cj9bpZz
         r6KRzRwyTqldAO/5BIwfGVALErHDMIdHv7AWlNjZ0OuTfAbIZ5V6NPiqqXSHG3Yj7Yv/
         GB2Q==
X-Gm-Message-State: ACrzQf1KG5atgFFVu6XimgS8wU0IpKZKou11u890LVLIixbDAic5Ksck
        sinEgkMYE02OVHjJ8peAmoY=
X-Google-Smtp-Source: AMsMyM73K1AEIikHJOwXjIXlHiTHy6r83LgmB8Ser1SvqGSb/X4kqUfikm3y15sA15v5mJxWjdkI/g==
X-Received: by 2002:a62:19cd:0:b0:56b:6a55:ffba with SMTP id 196-20020a6219cd000000b0056b6a55ffbamr4259598pfz.85.1667049071233;
        Sat, 29 Oct 2022 06:11:11 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.21])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902988700b001811a197797sm1244069plp.194.2022.10.29.06.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 06:11:10 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com, kuba@kernel.org
Cc:     davem@davemloft.net, pabeni@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, imagedong@tencent.com, kafai@fb.com,
        asml.silence@gmail.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 2/9] net: tcp: add 'drop_reason' field to struct tcp_skb_cb
Date:   Sat, 29 Oct 2022 21:09:50 +0800
Message-Id: <20221029130957.1292060-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221029130957.1292060-1-imagedong@tencent.com>
References: <20221029130957.1292060-1-imagedong@tencent.com>
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

From: Menglong Dong <imagedong@tencent.com>

Because of the long call chain on processing skb in TCP protocol, it's
hard to pass the drop reason to the code where the skb is freed.

Therefore, we can store the drop reason to skb->cb, and pass it to
kfree_skb_reason(). I'm lucky, the struct tcp_skb_cb still has 4 bytes
spare space for this purpose.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/net/tcp.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 14d45661a84d..0b6e39ca83b4 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -888,6 +888,7 @@ struct tcp_skb_cb {
 			has_rxtstamp:1,	/* SKB has a RX timestamp	*/
 			unused:5;
 	__u32		ack_seq;	/* Sequence number ACK'd	*/
+	enum skb_drop_reason drop_reason; /* Why skb is dropped */
 	union {
 		struct {
 #define TCPCB_DELIVERED_CE_MASK ((1U<<20) - 1)
@@ -912,6 +913,8 @@ struct tcp_skb_cb {
 };
 
 #define TCP_SKB_CB(__skb)	((struct tcp_skb_cb *)&((__skb)->cb[0]))
+#define TCP_SKB_DR(__skb, reason) \
+	(TCP_SKB_CB(__skb)->drop_reason = SKB_DROP_REASON_##reason)
 
 extern const struct inet_connection_sock_af_ops ipv4_specific;
 
-- 
2.37.2

