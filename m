Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC473AC6D2
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 15:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403863AbfIGNrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 09:47:33 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45136 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733278AbfIGNrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 09:47:33 -0400
Received: by mail-pl1-f196.google.com with SMTP id x3so4491865plr.12
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 06:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=k34hpd5H8YR3N6QwzXuXUSdBWScoRUdvuwOxEUNEpPc=;
        b=TzRzCrOh7PYkLlH9gIVpMzLyPcG9Kg0+vyncfwzSG4YwSMRS1FTOnU+EH1ppRgBnMY
         QhkUl7UCc+0rg1DlCW9c3E8vXngT/XSpujqWndC4gQRtz4QmTZBMl+IPtVaF0MhvrtGg
         4PsITYq5v7D7Qpxv7OlogARzldCHSSlplNpETPtK5NGvQ9G68yTvYFErUO1RGFryk50h
         rmspB6xv0ntHw1EfVYDgucB+dy2JnZ22OsrEm3F/zk69xf+1R8IJvI+3XR7d4New1FkB
         K0Z1opIFxHaLmrQ793zF7cBVVmulY5WUwfORmdRYVIi8ejuuxecJvA1PrxU+hOFpOSiE
         hP2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=k34hpd5H8YR3N6QwzXuXUSdBWScoRUdvuwOxEUNEpPc=;
        b=nBEGwhUQzBTmjKLd0yPoWPZIbdtI3TvpGEuXiIpiLzWKzOymY8MpQtcqtWdhNMqvk0
         RaZTgncbJEAYPFPwo4ay2a3ajbIZIQ5HrzHS8h//UUpcVr9hXRvkBbd/ZDK195T9Nij9
         zwmR7RqIpRezthgB2vZOiBnxtVr5hPIZM7Vyys6nsJRo9w8in6DZaSM133tQduwF96pd
         UrqVXuio25Adhq1s6ibjV1qLlf2mPtcN4cAwK6Br560SU+UVYszIV7TSp7kL+NdIe4Y6
         bX/DM3C7xmBab0k40V+tiTAfcVhq3Px2ULY/A7O+1vDQ4SuDX8l/Hs4M3UNhhKYpv6Gg
         AZWw==
X-Gm-Message-State: APjAAAXvtjQu8pj5uYsMzrkJXyvLJajVIT70WKsjxxTD7+oKmz+31wnL
        /M6TPWbhj0xniGQXro69BqQ=
X-Google-Smtp-Source: APXvYqz6xFLM51efz7IN0OXeLOyHIdZkBQmfJz/U+U2weaqIbx4hPALRXOuN4GaLMEwrs/TA91JmiA==
X-Received: by 2002:a17:902:96a:: with SMTP id 97mr14561450plm.264.1567864052714;
        Sat, 07 Sep 2019 06:47:32 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id z23sm11274220pgi.78.2019.09.07.06.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2019 06:47:31 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        hare@suse.de, varun@chelsio.com, ubraun@linux.ibm.com,
        kgraul@linux.ibm.com, jay.vosburgh@canonical.com
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 08/11] macsec: fix refcnt leak in module exit routine
Date:   Sat,  7 Sep 2019 22:47:22 +0900
Message-Id: <20190907134722.345-1-ap420073@gmail.com>
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

v1 -> v2 : this patch isn't changed

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

