Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66D43C9B0F
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 11:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbfJCJuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 05:50:08 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40382 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729334AbfJCJt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 05:49:58 -0400
Received: by mail-wr1-f68.google.com with SMTP id l3so2212195wru.7
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 02:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Os/eX6BBvnN2Mvum7RYEFx/X4z66th5+MJOO6R38FSU=;
        b=lCmMuYJ39Vw0EH0Du3fnQCCy/2vrJb1CcWG5Sb4CpGiNXacEDMSqkRYUEQPjCoPl2W
         EkrbIJmpNylvDrZEVcf7jvAKtnMQco1AmLCVFcp8GLcsxKM58+surU/CDWYlKsr9Fe+g
         3+r3dXSq5OzYoJ2Nc/pyx4pPTbKKmtVp/+FS9d0jnwmYTYOhGZ1tDDNMeHhoyLxDJEZA
         YXBDvFMIuOrzEMtCNPEZOLh8ABXDOAV8v+0d6m0jl3Esgf059T1ohOPUK3Neuu9JEbPB
         17lFqKb5lNoq2/Ufef4XhXanysoTj+QfchjtMxTagDWb8ER9NsN3CvFmPRg5Uz6ISDsr
         r/cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Os/eX6BBvnN2Mvum7RYEFx/X4z66th5+MJOO6R38FSU=;
        b=JcR4uZXvqK82a1fMzdcaG0aeftU/IIF0WGOckAvAREOZp10Cm5A7VUI7QCFK01WkcC
         8cv2y27cQFKxhCMaEA0mwzusoka4Vy+KWpXS6DUIL718W1HAO7YqkNY8hGxIDYD2z9+3
         Nv3EPz2FmneEzLs04Vd0OkDwyX588mlVK6s0Z29xVDBjkaygBwC1OzLzx6Rp8YoXf975
         07Y03tMjDRVMdlvdNnW9IQazMskd0NDINFlRq+o0Kp4o+u8qDzotcS10UCO1mMgL5BOv
         cxsKwgT9d35mWf3klGp3vKV9S8QzJFdV5kF9/1XzyrQLxEIFplSiOrKRCz955IlDfams
         f/gw==
X-Gm-Message-State: APjAAAWD/Wdj0wFhS59qi51BLzqiiFbyZcjuFhxjcfxTWOuzQzLyIeAL
        RPyoc9EGM83KAm4lVorjuPCSZIaJ8S8=
X-Google-Smtp-Source: APXvYqwylfbMjnoOh2G/P2L5AaZbqjPdjn3ns8x+NK6bBmHTG3SuLUzkELoGvvUPRbbvDLQRKa91ZQ==
X-Received: by 2002:adf:ea10:: with SMTP id q16mr6620004wrm.356.1570096196455;
        Thu, 03 Oct 2019 02:49:56 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id o188sm5248697wma.14.2019.10.03.02.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 02:49:55 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next v3 12/15] netdevsim: register port netdevices into net of device
Date:   Thu,  3 Oct 2019 11:49:37 +0200
Message-Id: <20191003094940.9797-13-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191003094940.9797-1-jiri@resnulli.us>
References: <20191003094940.9797-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Register newly created port netdevice into net namespace
that the parent device belongs to.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/netdev.c    | 1 +
 drivers/net/netdevsim/netdevsim.h | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 0740940f41b1..2908e0a0d6e1 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -290,6 +290,7 @@ nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port)
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
+	dev_net_set(dev, nsim_dev_net(nsim_dev));
 	ns = netdev_priv(dev);
 	ns->netdev = dev;
 	ns->nsim_dev = nsim_dev;
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 702d951fe160..198ca31cec94 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -164,6 +164,11 @@ struct nsim_dev {
 	struct devlink_region *dummy_region;
 };
 
+static inline struct net *nsim_dev_net(struct nsim_dev *nsim_dev)
+{
+	return devlink_net(priv_to_devlink(nsim_dev));
+}
+
 int nsim_dev_init(void);
 void nsim_dev_exit(void);
 int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev);
-- 
2.21.0

