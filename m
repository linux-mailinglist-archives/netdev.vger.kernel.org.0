Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3C947B08
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 09:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfFQHd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 03:33:29 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43551 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfFQHd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 03:33:29 -0400
Received: by mail-pg1-f196.google.com with SMTP id f25so5286323pgv.10
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 00:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=ywNd6FY7AUBT3sYTN6SV4oEzYtCXFGicyXDDl1jnLqI=;
        b=Ja48mdjzbIBjxM6ICHtJ7ZYhYq/LwS1xk4CacsW+A8a1K3qz3Hhpj3HSXJrkryfYPm
         dFDaREvX0HvAk6/MZS2lhiNwpUANqW26W4bBYPyE3sKl70P6npdcKBVGbrLaNmR6qSCf
         CoIb01mfDV17NZaDYhkwzUr6mioOg4bqY8n7CV1FNtMcY2NdiQEEuMvuZqRrDKk0C1yi
         LJXqdY/OE+3laUl0q+sTNSWfWvvIrdkRMiD9eohg9K7lQVCUKBN4Iy+FgQ7uPBUyGs2w
         /y2OKWQfq3Rw/A6BKNjNvrtPsGm09AgYHEW/Np6JFWlAv1ivxnrcV8PIjtvk0+Xfh4nz
         xagw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ywNd6FY7AUBT3sYTN6SV4oEzYtCXFGicyXDDl1jnLqI=;
        b=rO2+fWxJIqPBz0DVjeNRrbfzqs6fgyLcJyZUm7Wuzsimy3F9nSpqQ9TCt7yPaooUPm
         NVgy7T/fTVHM0ufDYT/1+5kua1tOIEVBWSLsuiUS+0iWGJfb/igjDZNdV383Xxo4eKEl
         IcIgZYOUUzQ+vuoIHrERNB324K+5N21E9FKymQs83f/I6rg6ZWAIUdXvrqRS71Tpa0Ta
         XftdYmtNociGbWjsBOs7EqR/HxeolBsiX9BPWuaFx4Yo2V3I1RJTbQotdaeH4mRWU9/i
         Y7a7tzgWg507PRfabUvb0AaFfM6lvSexsbGEgm+GglvnRpthKgCZ45szpMz+A1niJA5X
         n3Wg==
X-Gm-Message-State: APjAAAXDHdrcD3HScgzs5Mwa3cfL5dW6WXoKrz3hzyurM6y0g1yzJXpp
        d/2qMm560ZHl25XI6MNaa1UCWA==
X-Google-Smtp-Source: APXvYqzUCRcCkhiopQTKPFpTMQD0JpEn0caMNq9f267x29zEZrGw7/dAUhOvALVP4k9768QcQ+cLfw==
X-Received: by 2002:a63:e709:: with SMTP id b9mr46465039pgi.209.1560756808835;
        Mon, 17 Jun 2019 00:33:28 -0700 (PDT)
Received: from bogon.bytedance.net ([61.120.150.76])
        by smtp.gmail.com with ESMTPSA id f3sm3635830pfg.165.2019.06.17.00.33.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 17 Jun 2019 00:33:28 -0700 (PDT)
From:   Fei Li <lifei.shirley@bytedance.com>
To:     davem@davemloft.net, jasowang@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     zhengfeiran@bytedance.com, duanxiongchun@bytedance.com,
        Fei Li <lifei.shirley@bytedance.com>
Subject: [PATCH] Fix tun: wake up waitqueues after IFF_UP is set
Date:   Mon, 17 Jun 2019 15:33:20 +0800
Message-Id: <20190617073320.69015-1-lifei.shirley@bytedance.com>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently after setting tap0 link up, the tun code wakes tx/rx waited
queues up in tun_net_open() when .ndo_open() is called, however the
IFF_UP flag has not been set yet. If there's already a wait queue, it
would fail to transmit when checking the IFF_UP flag in tun_sendmsg().
Then the saving vhost_poll_start() will add the wq into wqh until it
is waken up again. Although this works when IFF_UP flag has been set
when tun_chr_poll detects; this is not true if IFF_UP flag has not
been set at that time. Sadly the latter case is a fatal error, as
the wq will never be waken up in future unless later manually
setting link up on purpose.

Fix this by moving the wakeup process into the NETDEV_UP event
notifying process, this makes sure IFF_UP has been set before all
waited queues been waken up.

Signed-off-by: Fei Li <lifei.shirley@bytedance.com>
---
 drivers/net/tun.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index c452d6d831dd..a3c9cab5a4d0 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1015,17 +1015,9 @@ static void tun_net_uninit(struct net_device *dev)
 static int tun_net_open(struct net_device *dev)
 {
 	struct tun_struct *tun = netdev_priv(dev);
-	int i;
 
 	netif_tx_start_all_queues(dev);
 
-	for (i = 0; i < tun->numqueues; i++) {
-		struct tun_file *tfile;
-
-		tfile = rtnl_dereference(tun->tfiles[i]);
-		tfile->socket.sk->sk_write_space(tfile->socket.sk);
-	}
-
 	return 0;
 }
 
@@ -3634,6 +3626,7 @@ static int tun_device_event(struct notifier_block *unused,
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct tun_struct *tun = netdev_priv(dev);
+	int i;
 
 	if (dev->rtnl_link_ops != &tun_link_ops)
 		return NOTIFY_DONE;
@@ -3643,6 +3636,14 @@ static int tun_device_event(struct notifier_block *unused,
 		if (tun_queue_resize(tun))
 			return NOTIFY_BAD;
 		break;
+	case NETDEV_UP:
+		for (i = 0; i < tun->numqueues; i++) {
+			struct tun_file *tfile;
+
+			tfile = rtnl_dereference(tun->tfiles[i]);
+			tfile->socket.sk->sk_write_space(tfile->socket.sk);
+		}
+		break;
 	default:
 		break;
 	}
-- 
2.11.0

