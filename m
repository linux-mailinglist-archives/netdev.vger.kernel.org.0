Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E051BDF556
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 20:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730115AbfJUSs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 14:48:59 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44113 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730105AbfJUSs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 14:48:59 -0400
Received: by mail-pg1-f193.google.com with SMTP id e10so8329561pgd.11;
        Mon, 21 Oct 2019 11:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LbaZeGx+1xZ8STYTlMHYv50VhfIT/CH7lDrqU1lyXoc=;
        b=IpOroYmb4O12IJh3I5WN/9Sdi9D2i3oXOgczyh0ekgu/olmUf6KCeh5tnTC6hlgzD8
         SJGaaZKkT8fFJDEHg75B2LHEsJb1Pb5brJ8/aKZyR/8tA48efh5XvDLWdFYbojfcx6eW
         ffeDV9KZXawLkrY66cAIrsL6UpEvU1vA6Z7pzCJDxRoxEt9npQ7KEMGZxk8brAqST46s
         4ouBzRH7t7RRv9cS/44XPG9kjCg6vk2oa1mosXxJeiXoOQETEitqbP668yjLW5ZDFECy
         JORetG8wAGUnv0z0wOoLxIh+B8NfGI/hKeCWo/muaWK1Bce3whESFpH6E96bZ52ipO2S
         6drQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LbaZeGx+1xZ8STYTlMHYv50VhfIT/CH7lDrqU1lyXoc=;
        b=epDB11lUQ70uBKhVgEBRpZ45MxOIojYoVokvykq9Mhsk3ExK9J4gycFnh14pkr+1HX
         vsG/WtLadha3yDQ5ZL+jaaXm/6Y2lBnkfctcFe/LsLSzcncItYVAf+F75B9SpxZhaSDL
         MyONQNfJTSkEq4WV2xGHZMhnMCIgvAN0EW6FY2zZoY2ueveyrwAdLLgV8n3W+qU67TEE
         25yFl1c8NR9UYSq3p8ajeEuNFC/y5ydJl/jC8u26vLgNCpnMXuKYCD8wMsJM4wlyQ+FY
         EUcviFJYKrJpJ8LdEuCRL6lTgI4ZllQPYz7VMXNOljXIGydOZ4TlUrqq0j9A4krrroh9
         JWsg==
X-Gm-Message-State: APjAAAWlJI7no9ZukAPy10UGoMsUuTmFCIm9Wm9AxVh/P7s0/HRW1Dib
        QkuktsWbXXVw7nDySNS+lVicE/8CJno=
X-Google-Smtp-Source: APXvYqwKM920RFjnmi5s/zQfJYsc4/5tFeEMGzwssmXzO1mFNADk5+UaSsstEujyH0e7mFhfrfDn5w==
X-Received: by 2002:a65:628e:: with SMTP id f14mr27925411pgv.114.1571683738236;
        Mon, 21 Oct 2019 11:48:58 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id ev20sm14502835pjb.19.2019.10.21.11.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 11:48:57 -0700 (PDT)
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
Subject: [PATCH net v5 06/10] macsec: fix refcnt leak in module exit routine
Date:   Mon, 21 Oct 2019 18:47:55 +0000
Message-Id: <20191021184759.13125-6-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191021184759.13125-1-ap420073@gmail.com>
References: <20191021184759.13125-1-ap420073@gmail.com>
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

v1 -> v5 :
 - This patch is not changed

 drivers/net/macsec.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index e2a3d1d5795f..9e97b66b26d3 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3000,12 +3000,10 @@ static const struct nla_policy macsec_rtnl_policy[IFLA_MACSEC_MAX + 1] = {
 static void macsec_free_netdev(struct net_device *dev)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
-	struct net_device *real_dev = macsec->real_dev;
 
 	free_percpu(macsec->stats);
 	free_percpu(macsec->secy.tx_sc.stats);
 
-	dev_put(real_dev);
 }
 
 static void macsec_setup(struct net_device *dev)
@@ -3260,8 +3258,6 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 	if (err < 0)
 		return err;
 
-	dev_hold(real_dev);
-
 	macsec->nest_level = dev_get_nest_level(real_dev) + 1;
 
 	err = netdev_upper_dev_link(real_dev, dev, extack);
-- 
2.17.1

