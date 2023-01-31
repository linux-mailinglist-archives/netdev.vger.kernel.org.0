Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034BD682B3C
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 12:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbjAaLPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 06:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbjAaLO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 06:14:59 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A70E4B4B2;
        Tue, 31 Jan 2023 03:14:57 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id n6so11402325edo.9;
        Tue, 31 Jan 2023 03:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:date:cc:to:from
         :subject:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=rJ6oUhRQsdKJpSWApz0PU5q/d65KHu6fj0/NFeFyyPo=;
        b=Uo+JRdrdbMDcPUUK2QO20xye4voQrXk9zs9TSQWcFlFQz9+YY/R5M9nmeduY5/gLbT
         Z5zVJAR7PjeZQGpNzU9fxLJ/ZYRsZ0/pf05UwEw604xN5JQmlKS15M9hJJKJJsUeb539
         F1QEr0n0Lgcap65LnTYpFrs7zUOCrd8cO9D24nFzRs9tdhFyvXsGbN4ZG82SUp0pRF5n
         w0F6x9XUm0gMlHKIVd7w0m1f6Y/qd2rGLFT1CwdpuyAXMqbFgXnDkmlNGyhcFQszBO6p
         7+dG2TT3rUDkGSrg39RiJjvhdtQotdtE7/ZQMn8XdMxgegpPd7cN5YiRuDkvJNLuaVPc
         argA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:date:cc:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rJ6oUhRQsdKJpSWApz0PU5q/d65KHu6fj0/NFeFyyPo=;
        b=k9FolhluWiLdTaS+saUO16EHz3hRNn+0Uoqxteip2UI/wMxI7TMkHpXwdTDazyE/44
         ip+y6VKdDjq9vvb5N1itvk8Tw3oCmnyKXY3Nn9DItI7pa5Eg3tjUlmnUDekCEUPMX2bV
         uLwCco1L6hHiWfhsyWeLEHlznM+NTywjhwXCvoq4HJ1RGrS/pssT8rjmVK/hC+msyONd
         ySfY3nH2ZTzjXnmwvF3vWkzfm/r8cNfz5zi2L+E4/34/ZUCqH+ITWcFLyGoNQDGdL3tD
         eCIK1CiJNThcR0JWlJ4skmjWkdZ0mLycBsuO3EtIAREv4tC/k049vfJC6y7AMW8kdC0r
         PJbQ==
X-Gm-Message-State: AFqh2kooyWyq8x+L+rQ0kjauS/2SNIjCKOc6rX/7GRizi+2h/sgZl9ON
        EJzNI3Ur1doTds3KyMbyh0g=
X-Google-Smtp-Source: AMrXdXtJEdqczl4tefpLNLK5ZBH8a9GvarCeD9R6boDdER2RnVZV/nTbTouhytgSctfuvv0b5kTllg==
X-Received: by 2002:a05:6402:3709:b0:49e:baf:f6e9 with SMTP id ek9-20020a056402370900b0049e0baff6e9mr63783738edb.9.1675163695979;
        Tue, 31 Jan 2023 03:14:55 -0800 (PST)
Received: from touko.myxoz.lan (90-224-45-44-no2390.tbcn.telia.com. [90.224.45.44])
        by smtp.gmail.com with ESMTPSA id by13-20020a0564021b0d00b004a277d55a6csm76199edb.1.2023.01.31.03.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 03:14:55 -0800 (PST)
Message-ID: <7266fe67c835f90e5c257129014a63e79e849ef9.camel@gmail.com>
Subject: [UNTESTED PATCH] net/usb: kalmia: Fix uninit-value in
 kalmia_send_init_packet
From:   Miko Larsson <mikoxyzzz@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 31 Jan 2023 12:14:54 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.module_f37+15877+cf3308f9) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From ef617d8df22945b871ab989e25c07d7c60ae21f6 Mon Sep 17 00:00:00 2001
From: Miko Larsson <mikoxyzzz@gmail.com>
Date: Tue, 31 Jan 2023 11:01:20 +0100
Subject: [UNTESTED PATCH] net/usb: kalmia: Fix uninit-value in kalmia_send_=
init_packet

syzbot reports that act_len in kalmia_send_init_packet() is
uninitialized. Attempt to fix this by initializing it to 0.

Fixes: d40261236e8e ("net/usb: Add Samsung Kalmia driver for Samsung GT-B37=
30")
Reported-by: syzbot+cd80c5ef5121bfe85b55@syzkaller.appspotmail.com
Signed-off-by: Miko Larsson <mikoxyzzz@gmail.com>
---
 drivers/net/usb/kalmia.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/kalmia.c b/drivers/net/usb/kalmia.c
index 9f2b70ef39aa..b158fb7bf66a 100644
--- a/drivers/net/usb/kalmia.c
+++ b/drivers/net/usb/kalmia.c
@@ -56,7 +56,7 @@ static int
 kalmia_send_init_packet(struct usbnet *dev, u8 *init_msg, u8 init_msg_len,
 	u8 *buffer, u8 expected_len)
 {
-	int act_len;
+	int act_len =3D 0;
 	int status;
=20
 	netdev_dbg(dev->net, "Sending init packet");
--=20
2.39.1


