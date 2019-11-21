Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D302104911
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 04:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfKUDTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 22:19:14 -0500
Received: from mail-yw1-f73.google.com ([209.85.161.73]:37584 "EHLO
        mail-yw1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbfKUDTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 22:19:13 -0500
Received: by mail-yw1-f73.google.com with SMTP id 12so1203048ywr.4
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 19:19:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=649w9NPZH4a33tdCKHIJx9A/bxLeL3sF3iibuigtKuY=;
        b=O/wA9wtYYLYwbqmDxABd+k6vcQFy4NvSTAj3DRniuP9y+gcOyL1B0wgO2X0VXe4Ot9
         prwoWQWA7sjNkVfltoFXc6Uyp16bSjptnGBcyCYNsMh3wND/0+V52GYYKPzNSe4itibh
         t9jymMzhiRHwHrGTGtP+C5hkLkMM2QkajCH23POldiIyjbZfohqg0OrgIpHiiikA9J7G
         rBFauVuDLTIEyN4ocjEYmMrZcHj6nY+gtkB2xyKOtwdgUA2gxC6ugjov5VDv6j/SFFeH
         HQTYzpiYPCqzfy+roaSLPo5I3UWOwhUguXEvcXOc0rrpNpEfC0zxgQL5yin9J/cF9ReH
         xfjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=649w9NPZH4a33tdCKHIJx9A/bxLeL3sF3iibuigtKuY=;
        b=P5aaIhSp8WZaPE7vtazLEo+cBEZ1N3HyvinKA4KrYdEhSoDFObY3WVgnXac9xHAjHd
         Z3WsOg7WZLNdzKPYW3aV9Cgd48nGo9cb3FTuImdKK23k9WV+DJj1GorcPLyDDd02rLj6
         9DN2Ygkl8KYh9/4TXBScKOxqfki3ivftKFcnjnrNZlKmRaZyv+BRueDDP9x4VACac1Im
         HZ7kSb1WU6dcY04bL98kvHm/M+SOZOc9c0sXkwwPMPaoCixf1IQAcBawVGhASEXVIvNR
         7jUM6XkZ2gGHXxjypF0NQFkpKaRoAwGqsfoMD4cfMGxrFdtA6fM1fpStXFyeErlXDzSa
         bpjQ==
X-Gm-Message-State: APjAAAXkABwdgDbNWKpSzNB23x606oU6pe2YZGYDqqoCBxdYCGByEtMj
        whb6P/10iKn1zrbHrTcVntS06ztOXtsXrQ==
X-Google-Smtp-Source: APXvYqzg5cJGb9m3qBSM+FWaPbPvQ8G4Yp0gmo8/vXvHgf1vyhrmBDrIdzmeEJoK6l2ssvkkEsaEyfwBdAFTGA==
X-Received: by 2002:a0d:d692:: with SMTP id y140mr4216855ywd.151.1574306351280;
 Wed, 20 Nov 2019 19:19:11 -0800 (PST)
Date:   Wed, 20 Nov 2019 19:19:07 -0800
Message-Id: <20191121031907.159416-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net] net-sysfs: fix netdev_queue_add_kobject() breakage
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jouni Hogander <jouni.hogander@unikie.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kobject_put() should only be called in error path.

Fixes: b8eb718348b8 ("net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jouni Hogander <jouni.hogander@unikie.com>
---
 net/core/net-sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 4f404bf33e44c977c1a8ba00706817b76215b75c..ae3bcb1540ec57df311dac6847323a23a74ec960 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1474,6 +1474,7 @@ static int netdev_queue_add_kobject(struct net_device *dev, int index)
 #endif
 
 	kobject_uevent(kobj, KOBJ_ADD);
+	return 0;
 
 err:
 	kobject_put(kobj);
-- 
2.24.0.432.g9d3f5f5b63-goog

