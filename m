Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6D535C483
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 12:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239789AbhDLK7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 06:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239697AbhDLK7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 06:59:13 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1572DC061574;
        Mon, 12 Apr 2021 03:58:55 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id a36so3965955ljq.8;
        Mon, 12 Apr 2021 03:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dp6p0gMd3x2WXvScuMIZoyQe18FTdqYLYhIX49taeDA=;
        b=huoc3k6DOHXu3TPGdUcKmvoWbYk+TP0aFv2jZnVxgDanJ30IFs9Pfs1a/+4MS3Y/sD
         4HWslI+beUxY8OzNpT3QtFmK6rI9X/4I0Oj+WCvloec0X5KwVF2OF925qqkl4G8KYRV5
         MMwFlt6C4qOU83kzRZnz+asWJbW4wMR9T1KF0BHde04sBLTursEw4GmpHnrUQG2QcLQg
         pvlEJG6Mexhqh3Na3eIJQ+jbp0K+gbr6OXDrGUH5muitIlbCLWK6PzChNumI5to6Uom0
         EYSdZsR/jfTf+Qm81VG4d7lHomS9FJIgWyWFgHsDRciYMAdq2ffWqyA8dFqNxWXLzqKT
         g49A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dp6p0gMd3x2WXvScuMIZoyQe18FTdqYLYhIX49taeDA=;
        b=mWGixyRSDUQX3EqXGc4NOP6fcMhky6y0vCwlVUE8lkj1a38skQo5PfeShgc+mhKTe8
         iy+09OZS8/W0ZAg9W6x6OtYHiECptLUhphozapj+qzFYGrUc5XIJB3+xQjdYwl7zmmGZ
         wY3R0+n7gSiXCHKaSFm6SkC5kYH71xuG9ykgGdV8/Z3i2AOMQkUy63TgH1SW1W5h+qtX
         svN/P3H9KP+rI9ZqVS7maPR9TkK0Ily9S0z1z3YiwPn7XDjbyKZhalXAGDJmoz5c+1hf
         19sKOG4d1DbBq19xWbc1jlIzoCQ/vOqrNLDo1U+K43tOL2IBtH4Vb7iBZuOLIEJKa1i6
         YJgw==
X-Gm-Message-State: AOAM533AGCk409dNGN3PpgohftwkiB+YmkyFuxZBlL8ulNMdm1SDgkvA
        pH1nzA3ywMIi9DYcvD/jv3k=
X-Google-Smtp-Source: ABdhPJw4yuYM4gwVm5IZiH8q/+G1wmoYG1WZJYnhf3o8o9uVM0lccGmML1GIVYv0nzbjpK/ndx6ZfA==
X-Received: by 2002:a2e:9082:: with SMTP id l2mr1725290ljg.272.1618225133461;
        Mon, 12 Apr 2021 03:58:53 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.90])
        by smtp.gmail.com with ESMTPSA id g18sm2317167lfr.8.2021.04.12.03.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 03:58:53 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        davem@davemloft.net
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+bf8b5834b7ec229487ce@syzkaller.appspotmail.com
Subject: [PATCH] net: mac802154: fix WARNING in ieee802154_del_device
Date:   Mon, 12 Apr 2021 13:58:51 +0300
Message-Id: <20210412105851.24809-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported WARNING in ieee802154_del_device. The problem
was in uninitialized mutex. In case of NL802154_IFTYPE_MONITOR
mutex won't be initialized, but ieee802154_del_device() accessing it.

Reported-by: syzbot+bf8b5834b7ec229487ce@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/mac802154/iface.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
index 1cf5ac09edcb..be8d2a02c882 100644
--- a/net/mac802154/iface.c
+++ b/net/mac802154/iface.c
@@ -599,6 +599,7 @@ ieee802154_setup_sdata(struct ieee802154_sub_if_data *sdata,
 
 		break;
 	case NL802154_IFTYPE_MONITOR:
+		mutex_init(&sdata->sec_mtx);
 		sdata->dev->needs_free_netdev = true;
 		sdata->dev->netdev_ops = &mac802154_monitor_ops;
 		wpan_dev->promiscuous_mode = true;
-- 
2.31.1

