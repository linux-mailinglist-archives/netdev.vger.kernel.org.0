Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D842749C6
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 11:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390408AbfGYJXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 05:23:05 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44766 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfGYJXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 05:23:05 -0400
Received: by mail-pg1-f194.google.com with SMTP id i18so22732308pgl.11;
        Thu, 25 Jul 2019 02:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6exXecWBG0k9kez9FGk7YSp5KXJbfwmTQdkFhgGKZo0=;
        b=lvtl5SCD1CEWdcHEeiLXUeefZs2wHJFEVwWdhOuxL6yoQJQ2dVxK94HvSLL10hRLn8
         CY5/8lhBKIIs8PSSGQVVO19ApVYQmKPJGD6VPxc8G+NGW99WNBTUPw83h9R9U2U/APPD
         0JLH8d3KWVnIWqNCjOMatP3FH+JoXvcKYgUT1neIRVe0i8txKc8MSb/3YHffdoovlJ3u
         3U6w4i7ISZzgGIlPO6UcOlMmsjGrIfPMckK2q+iu4zchp1P5u9dWC25Y6vYOBidkN/b4
         XFDOb8hyvdj/Ok3LIncMurg+dP3AvEaMIZIwNcQZ7a2KQJUrnzOw1zEjoeG512lvwU7L
         M+Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6exXecWBG0k9kez9FGk7YSp5KXJbfwmTQdkFhgGKZo0=;
        b=WIqXrGp3tAlntCjKHTfFhLcXjkfWuaual5eF9ZSJQUo6b63gy8PY4QTPMj/RWp0fH8
         nOH+ASk8hr0bZoybyth3qPewxu5E/9UuxRBVXDGsRIi6Zv7e7MdPdn2mUJUCXGPfTZnW
         QeAW67Ue3nd/FrvKaKU4eFJ6P0UMvIOdXjhdbFpRcyc/9ZAOF5OxbRLv9baCK+AYwXGi
         BcePuyVHMqAl2JbD+7F+WJiJwL1JQt7bECDOR3+iDNKcOLl27OxV+YBnzD6xPx1/pcsU
         qeqbFHXYd+DLr8thrk2ukDLE+XZi/YTewZXfykYjlBtuUcWZp9DNDEeJdcxaIvljA0S2
         FHcQ==
X-Gm-Message-State: APjAAAV1Da4kerPgKcoi4dnsZnF/B2PqXzJoktlhzaoWecJ0ZqUIPz/+
        PqiK8dkTW2lKEWwk2ylUB+Q=
X-Google-Smtp-Source: APXvYqwt5S251Ls8+WEXtgiOR2m0ZD3Z56AOdR4AQTJu22b6JGXpQi72qxEU3n7GR7KkY+NPG39i6A==
X-Received: by 2002:a17:90b:f0e:: with SMTP id br14mr91707102pjb.117.1564046584280;
        Thu, 25 Jul 2019 02:23:04 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id x9sm26549209pgp.75.2019.07.25.02.23.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 02:23:03 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: bluetooth: hci_sock: Fix a possible null-pointer dereference in hci_mgmt_cmd()
Date:   Thu, 25 Jul 2019 17:22:53 +0800
Message-Id: <20190725092253.15912-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In hci_mgmt_cmd(), there is an if statement on line 1570 to check
whether hdev is NULL:
    if (hdev && chan->hdev_init)

When hdev is NULL, it is used on line 1575:
    err = handler->func(sk, hdev, cp, len);

Some called functions of handler->func use hdev, such as:
set_appearance(), add_device() and remove_device() in mgmt.c.

Thus, a possible null-pointer dereference may occur.

To fix this bug, hdev is checked before calling handler->func().

This bug is found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 net/bluetooth/hci_sock.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index d32077b28433..18ea1e47ea48 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -1570,11 +1570,12 @@ static int hci_mgmt_cmd(struct hci_mgmt_chan *chan, struct sock *sk,
 	if (hdev && chan->hdev_init)
 		chan->hdev_init(sk, hdev);
 
-	cp = buf + sizeof(*hdr);
-
-	err = handler->func(sk, hdev, cp, len);
-	if (err < 0)
-		goto done;
+	if (hdev) {
+		cp = buf + sizeof(*hdr);
+		err = handler->func(sk, hdev, cp, len);
+		if (err < 0)
+			goto done;
+	}
 
 	err = msglen;
 
-- 
2.17.0

