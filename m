Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 019FEA91F7
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387730AbfIDSks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 14:40:48 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37737 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732465AbfIDSks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 14:40:48 -0400
Received: by mail-pf1-f193.google.com with SMTP id y9so13794304pfl.4
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 11:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Vrtqv1cFw27uAgADwsiiIYgq/XSGYJzvztXErTTVhxI=;
        b=ffAMriBnv/YvkWiIL2QcmeNNjHiBPSn3Tdjbpfsd+xrm9eHnAB+1ZcaBvRVA8Yton9
         VVau6qwfo3BYRzfWtlTM/Xkl6+IwLMC0gsa13AaGKs8RSxivRxDSrNYBZR1M1mNb8AM5
         nBLMUU1pJrySzI+5+EIWI2OOs2vCsrcbnwb7CfGzLGSaCHsSbud/7aaKu8sQiQEwcz+2
         8mKok5j8a0keHuATB8k+XgiKpoZO6x+zgtJrX8/STIhYUEghcfO0AyOLwxnC54dy+Cpi
         yHsQoMXsPnbAZ5yRwhQBcHeD/7IoamjF8vr+swkq6ySC1ivcbVCXJhhG3G2xGhQf5mcR
         8nrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Vrtqv1cFw27uAgADwsiiIYgq/XSGYJzvztXErTTVhxI=;
        b=jA+3z6w3tWUsqTKzd9idohZ/t+z9T7o/HPNDw5slz00L0odn17MpbzE0tJugh1p2eq
         3HQbPTS29FAXWvChAxvH7RrZK6zymn/x9wYza6k0nQQojXmLxn0ZJwzTyZkjxDaEw8or
         Ik4/1U4MsZEUwiWKVNudR3XhEwrEkvNODbyeoF6xu8D9hVYFK1Shj9R0NFkMc4AHITO5
         VDOfQug7vfZsjEP14redugpLKN1uzsYpINGrR0y6AARF66OtcoterqcWl9ahwbNVR90Q
         kawqmfZ0xlyuyaHOg5TFPLkkxBn+Mx61Z7yn+jWsxtFXYKSDz7v91Bs38tvbEv0ssG0v
         O0+A==
X-Gm-Message-State: APjAAAWa7x1EPYZcmVETWBchP0/XmiOfm2xirKRT3Kjn41Fn3z3xeh85
        82DnmKmYq2kHEVSRScRR5FYSNwHWW9E=
X-Google-Smtp-Source: APXvYqzB9RXhIKrX4n1iQ5ElIkela9+HlLOOZfgr/m9o3U4bwQvc5BgO5CvlEIW83/gneGEuuzYxXQ==
X-Received: by 2002:a17:90a:8c01:: with SMTP id a1mr6173268pjo.82.1567622447568;
        Wed, 04 Sep 2019 11:40:47 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.1.1.1.1 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id r1sm19115921pgv.70.2019.09.04.11.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 11:40:46 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        hare@suse.de, varun@chelsio.com, ubraun@linux.ibm.com,
        kgraul@linux.ibm.com
Cc:     ap420073@gmail.com
Subject: [PATCH net 08/11] macsec: fix refcnt leak in module exit routine
Date:   Thu,  5 Sep 2019 03:40:36 +0900
Message-Id: <20190904184036.15229-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
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

