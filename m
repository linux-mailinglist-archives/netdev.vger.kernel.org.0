Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDD79122A8F
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 12:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbfLQLqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 06:46:49 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46776 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfLQLqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 06:46:48 -0500
Received: by mail-lj1-f194.google.com with SMTP id z17so10524564ljk.13
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 03:46:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=AFL4QcknGHjxO2FTQDYNilNBXs3j45wi3MjuY5Jhgjs=;
        b=0Ij+xd7detohgBBkrDNSTSOaEtCND+t39Xj7vRHjwzP1ODLFmQYS3A8ixlCA31Do09
         kIZV3YQCmDy1j2r2M9GlaAE/YJSfUqXEJ+iuUiA7KhRbxsOqqhO/R7dxwgx+lhgOrylU
         tYt2GmEBFR84nXOfxEFsrZA8zOK5+e1AnrAfSACJXjwHuycxhtQ10YKDlf4ao4S8K2ud
         L4+Z+Ua2Y7FRwyoroqDcw7kUkBbHiJ1ikObrZzsnDEyAbOkCOPnQBH9UzbEXcTj2NQiR
         mdhq18JNDnLaIiXqDlbseVYWfBDSjfQLDN6Bd8FPELiGyIaQBzKNNUra3SOBOkI6NHx5
         5yJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AFL4QcknGHjxO2FTQDYNilNBXs3j45wi3MjuY5Jhgjs=;
        b=ZCjuDD21iymTiTYz5F88tIUJSJHByywjCYNuRINsydSERiGsm37iU29KDYpizlbNxt
         L7Zo/syO4rKBcOaql3hKJWzsyBUA5a3BBwOFGmE/HTNaMADTVhtEEMuOAeL5P+9WZLCj
         K+m6nLSKgzZYsD407Yss2SDccRGkpRPXrQMsVVWoNtAkSwiq1Gd2PCJJht5YOfESzEg5
         Ym7raEuwdqldNFA1qA1O6psTcSRX/hcTr2E8h7Hqlz+JFERYT/hsSXq46b3eSIx0NMW3
         YCr4nzpWl2qggcz6uP0m7K2DA2E/Bn50YiVtYXnLWMaNYsdG1L84lxt7imgavhp77I9v
         BsAw==
X-Gm-Message-State: APjAAAX0Sulk5R6ZtsdXRH0cW4vinGGMTGlrxKhg3ENcOqvLWZCEbAUb
        acs2c+dr8nhKve4nXD/1OX3DN+mEL48=
X-Google-Smtp-Source: APXvYqzEVevvsbi8/4Eb5Qv1VFh9welvdj4nXDsrSgJvrUQqO8k//lSU8HZh7V45BU5GAbMjJIsgFQ==
X-Received: by 2002:a2e:8152:: with SMTP id t18mr2811717ljg.255.1576583206223;
        Tue, 17 Dec 2019 03:46:46 -0800 (PST)
Received: from localhost.localdomain ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id m11sm10729269lfj.89.2019.12.17.03.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 03:46:45 -0800 (PST)
From:   jouni.hogander@unikie.com
To:     netdev@vger.kernel.org
Cc:     Jouni Hogander <jouni.hogander@unikie.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        David Miller <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] net-sysfs: Call dev_hold always in rx_queue_add_kobject
Date:   Tue, 17 Dec 2019 13:46:34 +0200
Message-Id: <20191217114634.9428-1-jouni.hogander@unikie.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jouni Hogander <jouni.hogander@unikie.com>

Dev_hold has to be called always in rx_queue_add_kobject.
Otherwise usage count drops below 0 in case of failure in
kobject_init_and_add.

Fixes: b8eb718348b8 ("net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject")
Reported-by: syzbot <syzbot+30209ea299c09d8785c9@syzkaller.appspotmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Miller <davem@davemloft.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
---
 net/core/net-sysfs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 5c4624298996..4c826b8bf9b1 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -919,14 +919,17 @@ static int rx_queue_add_kobject(struct net_device *dev, int index)
 	struct kobject *kobj = &queue->kobj;
 	int error = 0;
 
+	/* Kobject_put later will trigger rx_queue_release call which
+	 * decreases dev refcount: Take that reference here
+	 */
+	dev_hold(queue->dev);
+
 	kobj->kset = dev->queues_kset;
 	error = kobject_init_and_add(kobj, &rx_queue_ktype, NULL,
 				     "rx-%u", index);
 	if (error)
 		goto err;
 
-	dev_hold(queue->dev);
-
 	if (dev->sysfs_rx_queue_group) {
 		error = sysfs_create_group(kobj, dev->sysfs_rx_queue_group);
 		if (error)
-- 
2.17.1

