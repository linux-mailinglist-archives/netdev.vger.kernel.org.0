Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2820330A49
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 10:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhCHJ1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 04:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbhCHJ1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 04:27:35 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD8AC06174A;
        Mon,  8 Mar 2021 01:27:35 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id x29so6037810pgk.6;
        Mon, 08 Mar 2021 01:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FkcecBQ/uWNOh6SH1+lVeHED1t6Xg7QLIjl+W6LrKKI=;
        b=IF9T0ZtK+A7Xu9/M6ex4Kvc/Hmy1QnWC5CQjIzyP6MVjbd6GamZLDrKjDhUYI4k5XP
         9lZ0m5vRe/9CddhARoTqjBJhMbrZbo3hgfA+Bk6WKRzaVeG5TWug6r54lBJB0JR48HSi
         Sqvz9KiyoN8hTCFthIv1lrt4r7up6e1OviRVzNeq/YstKp4Ahzp7Ka5ULxQ+okpvpNpE
         zJq7Ir2bcnBahTrp8vAXUSbm/V6+TPTgp0XtZGYpFYjUWw4Exxafx1MeNkhRam1irniA
         aFQp82xi0DCezbvKjn739mXCT6+InYVyot/PWw1huC9DZwB9DErigUkRlUvXKqF5f3EZ
         E/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FkcecBQ/uWNOh6SH1+lVeHED1t6Xg7QLIjl+W6LrKKI=;
        b=WSk808CZQajSNOZn4hitA3XpIj6wAsThXkuhYo8FXMQwcpw8FzlNM+KeCUpxv03zcH
         Op2CO3Fy/n3xSD7NL3MAeiPUxq2dI/+nq7SGK6D3i+1iLWStNEQ7t5R8BTgFX7bO6LjM
         tYryqN7L7PN3Ds8nY3D8Vc2nQIIJufsI8ABFp4CDarEXu96K4RwzTaQLDXdB5/1C9zkZ
         G0I/8GBT+Xu+XGjIC1XJonjaHkeliHjYG3kDA7YPDu+stcHeqLBIgZHCyBYFd8gj6BlS
         167cVLeUbos1a1zbNVuzTm5U9RwRmUCpMMDPdsgZ+UcBP0r4G1czvP5Q+6MzoEs5wPCl
         wopA==
X-Gm-Message-State: AOAM532aFLXjKGC4007X8DayMzBXrEoYpnWCMT5DbO/p7eHKHxDXyKQx
        gM7EKqa7rBYHSAMMgsh8rLQ=
X-Google-Smtp-Source: ABdhPJyg0J+RG8DJ7HUAvCH/220Jxex5/mLy5l2vWTnWB+rHIE/EbU2o1v5mSwfpTLwvTQPKfA1kig==
X-Received: by 2002:a65:41c6:: with SMTP id b6mr19364742pgq.7.1615195655142;
        Mon, 08 Mar 2021 01:27:35 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.99])
        by smtp.gmail.com with ESMTPSA id a15sm10408491pju.34.2021.03.08.01.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 01:27:34 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: ieee802154: fix error return code of raw_sendmsg()
Date:   Mon,  8 Mar 2021 01:27:20 -0800
Message-Id: <20210308092720.9552-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When sock_alloc_send_skb() returns NULL to skb, no error return code of
raw_sendmsg() is assigned.
To fix this bug, err is assigned with -ENOMEM in this case.

Fixes: 78f821b64826 ("ieee802154: socket: put handling into one file")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 net/ieee802154/socket.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index a45a0401adc5..3d76b207385e 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -277,8 +277,10 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	tlen = dev->needed_tailroom;
 	skb = sock_alloc_send_skb(sk, hlen + tlen + size,
 				  msg->msg_flags & MSG_DONTWAIT, &err);
-	if (!skb)
+	if (!skb) {
+		err = -ENOMEM;
 		goto out_dev;
+	}
 
 	skb_reserve(skb, hlen);
 
-- 
2.17.1

