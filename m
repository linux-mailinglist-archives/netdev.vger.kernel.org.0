Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9133A72FD
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 02:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhFOAck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 20:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhFOAcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 20:32:39 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF095C0613A2
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 17:30:25 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id d2so22433935ljj.11
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 17:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1vr5tF9uC8zxJRF8P1lZIsvwQPoxIVBxYNMsYnxvUr8=;
        b=iXXMHLMK/C4kZn73PjvGLyTEW6fzshvSKprMvhSFRtKScU+yj8TIeYhcJtilMKagXh
         SZXz6IQvQoL0TkVrnqwD6yRp69vXB8lBdfbyxKW5bG2tyZRCQemt4SlFCsdHtR6dhYba
         1a9V3l5s0SoJYP+Yp+9Bsjq3ZAYzQXNFJVb4WoMOP8CrFieirlgQBU3K9PSYrTasUXTb
         cwnBRA7L2FUKClijUg6JQqMTMdNBBDP94JeFkbJpWxrjJW5D4NWdFyC2Xgy7C9k8iW+k
         FD5dVkDKDozd91H5jU7jc7XaxU7IXWXjUCBRdi/qgQPp0VI6tr/1jts6gLJtMoF3wjH1
         XmrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1vr5tF9uC8zxJRF8P1lZIsvwQPoxIVBxYNMsYnxvUr8=;
        b=k3T0gzqyF4EqgZ/5mbEsMVAn49Oxt6iUcwCJtkbAa07xRn1sT0UlfQ4j0zv925HhYP
         Yhv5UR/FydeNXuxrrVCxk1bGG2mziTERRGJIxXZe29nunCv0Ivgiw8KDYEiKlxPgSt2T
         vCfM8X4sMvA7R0dFmXEbfUrLa7/+TMakCNXAf0LN5OnNtUbKbLRrk5InbZMHak8qYLg2
         Xtn9YUfWD37RJS/muagK80ABDbS1BdOcyvdlv4+7VZZ/zhzSormWFAdi9qXZxw9uTmyN
         MHwafNsr2LKQjgzXDzsd/FAQCVcJ7hmKJJo9DCAjbskyvCEjcTBpkBzXKxRNLcJ5/t1L
         GY3Q==
X-Gm-Message-State: AOAM531P0MTtWj7kFvaSoPAq6GQAgUz6CcJJJCg6AVRD0YnN+t/EMeT1
        huY1ZqQyJKwAMimPVhMdLjM=
X-Google-Smtp-Source: ABdhPJwoyGWt0q7T5aHYlCKOgwRjJjgRgH4v5ZE8DwJnlsOzgYLabaHWPdJ9vWkqpCvu/QRP6gb4jQ==
X-Received: by 2002:a2e:585e:: with SMTP id x30mr15086173ljd.290.1623717024234;
        Mon, 14 Jun 2021 17:30:24 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id 9sm1635522lfy.41.2021.06.14.17.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 17:30:23 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 04/10] wwan: core: multiple netdevs deletion support
Date:   Tue, 15 Jun 2021 03:30:10 +0300
Message-Id: <20210615003016.477-5-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210615003016.477-1-ryazanov.s.a@gmail.com>
References: <20210615003016.477-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use unregister_netdevice_queue() instead of simple
unregister_netdevice() if the WWAN netdev ops does not provide a dellink
callback. This will help to accelerate deletion of multiple netdevs.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 drivers/net/wwan/wwan_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 259d49f78998..634f0a7a2dc6 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -874,7 +874,7 @@ static void wwan_rtnl_dellink(struct net_device *dev, struct list_head *head)
 	if (wwandev->ops->dellink)
 		wwandev->ops->dellink(wwandev->ops_ctxt, dev, head);
 	else
-		unregister_netdevice(dev);
+		unregister_netdevice_queue(dev, head);
 
 out:
 	/* release the reference */
-- 
2.26.3

