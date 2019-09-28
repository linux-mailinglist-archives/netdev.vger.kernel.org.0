Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0E0AC1163
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 18:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbfI1QuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 12:50:14 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39987 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfI1QuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 12:50:13 -0400
Received: by mail-pl1-f195.google.com with SMTP id d22so2252240pll.7;
        Sat, 28 Sep 2019 09:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RELvOnZgMNXNkz/88nqNg0MOKI1kSF+INp6xZR5cu74=;
        b=t8kx5/PvLh3jymMGBL4U3hbsEhJPsqQa21iM4ekVjHxC3T63z1DIbCtpUMqxseF+zH
         CGm8xI8tDYfPWrcnasd1uqxIwB4A6QoYjyfwaeLWr/fWbLWHFiKQkxopJCtSrYMQRrtT
         HAkDjlR3VwYMFdddelX/V+OssUPOcNPgDgpkW3tM8khNr1kkUvxXHRDnwGFMavYEHyYK
         OATWy72zZzN0Dd6NFg0gHIS2X0/L9nMiO1xE2vWHC9q517PN+M89A2++NhKO0vCfD0xe
         26+RhRoAPhLyPsqCf7yG74t8oHNAZ4oju8yiCq10KM23jwdbmm4/dZD5/p2sSLPhs5G7
         bQgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RELvOnZgMNXNkz/88nqNg0MOKI1kSF+INp6xZR5cu74=;
        b=jQYCIolKjkL81gyWitnIa9OhSsrfW1TdrTdIQ/87DHFXTisaFdo76ELv6UXkJYRyKD
         hqXFgRRI/AzTWBtIZHqLPkGtqZFT6G8WhhyhdnnV/E/G1rN92NExwXDE86c6oAnpOd24
         RKrGuUTNpesx2U+YNc+KzBTdJRcOc+wjszQHe/w1tZhG1jkwLtlTevH2bWxPX9JUxEK7
         SCdh7by5ebSroXpzFcpTSiqPhGgA4a7nPKpBL5yQPibkmZP/w9LsYgWHdPRnW4ptifYY
         xEfdkxWcNW+F6YthalVDzrMlASla+DL/C40SyZr+q9jaMkvlm2q039roSr8TViyVrRKv
         fZLQ==
X-Gm-Message-State: APjAAAVsmMAQLcWGjNFDb3SfWrAkUa30cFUdvOxGtcFnMdOQJfqsqg9j
        px81o5LOoGmPjtXddPlI/jWyvEdpfmr3ykb1
X-Google-Smtp-Source: APXvYqw75/3NjyxAlZpZdmmgMQtAIFzoDrIgXVVWV8JIXQl0aRnboJPFNwNHBM1p42I/7ij94Xyh4g==
X-Received: by 2002:a17:902:788f:: with SMTP id q15mr3200979pll.321.1569689412383;
        Sat, 28 Sep 2019 09:50:12 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id 30sm8663092pjk.25.2019.09.28.09.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2019 09:50:11 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, jakub.kicinski@netronome.com,
        johannes@sipsolutions.net, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jiri@resnulli.us, sd@queasysnail.net,
        roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com, schuffelen@google.com, bjorn@mork.no
Cc:     ap420073@gmail.com
Subject: [PATCH net v4 08/12] macsec: fix refcnt leak in module exit routine
Date:   Sat, 28 Sep 2019 16:48:39 +0000
Message-Id: <20190928164843.31800-9-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190928164843.31800-1-ap420073@gmail.com>
References: <20190928164843.31800-1-ap420073@gmail.com>
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

v1 -> v4 :
 - This patch is not changed

 drivers/net/macsec.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index c4a41b90c846..28972da4a0b3 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3032,12 +3032,10 @@ static const struct nla_policy macsec_rtnl_policy[IFLA_MACSEC_MAX + 1] = {
 static void macsec_free_netdev(struct net_device *dev)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
-	struct net_device *real_dev = macsec->real_dev;
 
 	free_percpu(macsec->stats);
 	free_percpu(macsec->secy.tx_sc.stats);
 
-	dev_put(real_dev);
 }
 
 static void macsec_setup(struct net_device *dev)
@@ -3292,8 +3290,6 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 	if (err < 0)
 		return err;
 
-	dev_hold(real_dev);
-
 	macsec->nest_level = dev_get_nest_level(real_dev) + 1;
 
 	err = netdev_upper_dev_link(real_dev, dev, extack);
-- 
2.17.1

