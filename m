Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2B01226E5
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 09:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfLQIox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 03:44:53 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43053 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfLQIox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 03:44:53 -0500
Received: by mail-lf1-f66.google.com with SMTP id 9so6340447lfq.10
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 00:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=/xkY0g7qxUHP7EYLLuggYFIWKHlZr1MbxzsoA0kAQvg=;
        b=FhYk5ecZ4PBVKZ26ANGxqWEAQvFRVz7qc7fTnaEvbnfDBDWcvxQVoiNFvtIYtttvTn
         z2zP+YeQWsWzkhu4mSvZsu2oA4m5MV5DuQM7KVNOuGUbzO1szU5pvlGpbSC0FLGI4Dqb
         nxJM02zvmEigPIiYsf+bmUSJtBEzVTgW+rcThzb7kKp366uL19KxE407ldnlPA/z2+SF
         +HYtk8pBFQFI8cdMpbZCBNt/5oZjy6sCe9PKc82QMWIg5oC4Q0zz/0Ly+kAm32X/gn9z
         YeSvzro9Jn9XAPM5RFB0Wz/L2HJZA/ZwsEj7dCWevf6ivSxScQGbpo6fWUPEWnPbrGLO
         NoBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/xkY0g7qxUHP7EYLLuggYFIWKHlZr1MbxzsoA0kAQvg=;
        b=mt7HWJZuGoDTFgpm2Z+rLtTvdtmD8g5AfSINzn1W5KhPS95RR2gBcdvJ9dZOPElr6x
         TXk+fALfG6SS7hl4geE0qXC9YWuCpScoGzotdz9tmsDbbMycq3qYB9zfOr+2Bq8tIxH0
         XwlVvxgrvEUxV9NU3ZDAB30UkDdrNfwTeZFDlQIjMH2BfK/3jKv7iKY7kmbrbkyVZHrO
         Mf+YFSOIEXgG4/0zGNEwKXuIhNMWZ1JLz63yORVG3lnS2Z/S68NJd9M4W/TnsqrRM2Gt
         QmGQxqRO3zIenJjRSzo6DwzZO+X0JfuSKlT8FNOxVipxKw1hlwZFXkMe4e1FzdX9kP1K
         TIWg==
X-Gm-Message-State: APjAAAWRvJ8vp/4iRI0q23EaIhcTGByOASI3aeuV2NfuHfIg6Ozudr6/
        5Me+4IQvBjW2yNdSr5+O7a9tTlpyJCc=
X-Google-Smtp-Source: APXvYqyUhEbiyOnL9rOO+M+mO/Q1XTobOGiBDapBfV4DGuABj8s0sDjLxfM09W7EiOEoHLEL0VQX5g==
X-Received: by 2002:ac2:465e:: with SMTP id s30mr2082764lfo.134.1576572291811;
        Tue, 17 Dec 2019 00:44:51 -0800 (PST)
Received: from localhost.localdomain ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id j19sm12631738lfb.90.2019.12.17.00.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 00:44:51 -0800 (PST)
From:   jouni.hogander@unikie.com
To:     netdev@vger.kernel.org
Cc:     Jouni Hogander <jouni.hogander@unikie.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        David Miller <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] net-sysfs: Call dev_hold always in rx_queue_add_kobject
Date:   Tue, 17 Dec 2019 10:44:29 +0200
Message-Id: <20191217084429.28001-1-jouni.hogander@unikie.com>
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
Reported-by: Hulk Robot <hulkci@huawei.com>
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

