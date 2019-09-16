Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36358B3BCB
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 15:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387932AbfIPNtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 09:49:12 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33990 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733128AbfIPNtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 09:49:12 -0400
Received: by mail-pg1-f195.google.com with SMTP id n9so56255pgc.1
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 06:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SJH1U+hbVAPZ8FanGy0kD29PtSPzpTKSJZxpdr+tM+Q=;
        b=RH2GJlPWH7GeT/OA85HwZn7qcWumE6+i1v26NX2/O5BupKxMGn+DBRaaMegw4yOywy
         91frXUMskuZ5ToogqRslEl/B7gq/WBFzMi7hB9YRRPJv98dCU5LvnVSJq56Rfw44tyai
         1oZ+N71EP+moVSAPAfmal2NUGGQTujmBUkin9xv0zU6ZL6gc/46Z/cDcJdgM1aASeHvE
         sV3S4YJeTliF7KW7JY2C6CSWUMDgJQXnqv1ko/zEZzNqgJFMjaJIg2PXOJ+X6xtdOkJ9
         mLuLLpo5pDtVJ0OW2r3/BmFsfbDgZ2qzz10Zoz9Dj5VyhU5lD3rv3wLNCEkC8fzMvvGI
         HA2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SJH1U+hbVAPZ8FanGy0kD29PtSPzpTKSJZxpdr+tM+Q=;
        b=P4SAl4gg6JFlDqWtpOJ55kuDYaMNQpBJK5SKpmxAaZDtCsB6EwqzcnVOX0qstgmL71
         324n5w1w78pXgXwyYFYEGQVd2uzcGDN5vpoNy7zqSudObaa+Nr1JTLXNu64YuS8m5vWk
         er4gdwgyxelMvwU7FUX61gttbYW/KrPAtBwSds1wqs9vL21nIbWvRpSiLTjl8dkzvVji
         YeWVLdQrPWL9J4BWclMBmZFGxxZlCxubHyCCfSwPIcBQIKPNRaMYKs3mtFnP1Ei1ydXG
         /G85H1DdtjZ4fF6lYrO68qrENlDHo99UnLitFDWvCKDPP7OlmSG06turHK40cwrxDXJx
         6ltQ==
X-Gm-Message-State: APjAAAUy1E0FJ2CimLfzBXfPmOphY1alZ51AV5KCU59HfENOy2+7yhWo
        xBrloz+cmBkru2786UQ+o8I=
X-Google-Smtp-Source: APXvYqxWbwu8d/4u/Bx+k/BhYKAdarT9DLtLNnmEiao0JNGZoo85rlZzmaawNJrCtSeyXCKY0fZsaQ==
X-Received: by 2002:a17:90a:2464:: with SMTP id h91mr102642pje.9.1568641751355;
        Mon, 16 Sep 2019 06:49:11 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.1.1.1.1 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id z20sm2822266pjn.12.2019.09.16.06.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 06:49:10 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com
Cc:     ap420073@gmail.com
Subject: [PATCH net v3 08/11] macsec: fix refcnt leak in module exit routine
Date:   Mon, 16 Sep 2019 22:47:59 +0900
Message-Id: <20190916134802.8252-9-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190916134802.8252-1-ap420073@gmail.com>
References: <20190916134802.8252-1-ap420073@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a macsec interface is created, it increases a refcnt to a lower
device(real device). when macsec interface is deleted, the refcnt is
decreased in macsec_free_netdev(), which is ->priv_destructor() of
macsec interface.

The problem scenario is this.
When nested macsec interfaces are exiting, the exit routine of the
macsec module makes refcnt leaks.

Test commands:
    ip link add dummy0 type dummy
    ip link add macsec0 link dummy0 type macsec
    ip link add macsec1 link macsec0 type macsec
    modprobe -rv macsec

[  208.629433] unregister_netdevice: waiting for macsec0 to become free. Usage count = 1

Steps of exit routine of macsec module are below.
1. Calls ->dellink() in __rtnl_link_unregister().
2. Checks refcnt and wait refcnt to be 0 if refcnt is not 0 in
netdev_run_todo().
3. Calls ->priv_destruvtor() in netdev_run_todo().

Step2 checks refcnt, but step3 decreases refcnt.
So, step2 waits forever.

This patch makes the macsec module do not hold a refcnt of the lower
device because it already holds a refcnt of the lower device with
netdev_upper_dev_link().

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2 -> v3 :
 - This patch is not changed
v1 -> v2 :
 - This patch is not changed

 drivers/net/macsec.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 25a4fc88145d..41ec1ed0d545 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3031,12 +3031,10 @@ static const struct nla_policy macsec_rtnl_policy[IFLA_MACSEC_MAX + 1] = {
 static void macsec_free_netdev(struct net_device *dev)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
-	struct net_device *real_dev = macsec->real_dev;
 
 	free_percpu(macsec->stats);
 	free_percpu(macsec->secy.tx_sc.stats);
 
-	dev_put(real_dev);
 }
 
 static void macsec_setup(struct net_device *dev)
@@ -3291,8 +3289,6 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 	if (err < 0)
 		return err;
 
-	dev_hold(real_dev);
-
 	macsec->nest_level = dev_get_nest_level(real_dev) + 1;
 
 	err = netdev_upper_dev_link(real_dev, dev, extack);
-- 
2.17.1

