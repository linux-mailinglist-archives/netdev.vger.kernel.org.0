Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D985CC8DFA
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbfJBQMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:12:54 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51907 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728076AbfJBQMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:12:48 -0400
Received: by mail-wm1-f66.google.com with SMTP id 7so7853570wme.1
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 09:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Os/eX6BBvnN2Mvum7RYEFx/X4z66th5+MJOO6R38FSU=;
        b=Xx8IQwHcaGQFUr0HR9MJ5mYUAiVH5pfh5fZSfILZy+VTd/uJ2lTs+fgEph0noxlBYp
         jwCyUOu3Jcjeg/CxKV8x1hbISFSjY2HX9cH/YN6CtbFrggF/O5+RVN42Ooh/MmhGIHpV
         eKwzpQeSAwT6be3uCv2XVRv/MsfAhwk8B//ZSSKuF+sIG+AX8Zr2KAx0NYtZAbH1k5JG
         rF2C5UnffvzwqGBn1w49Z3p0wv2n1+qQlhLNdUhfkKxno82eOm0x2Qk972vdBNhpkW2V
         o7ZSMnpN/C6L5lVxJw0af6y6BVxAy6LYoQ3KaBevrEFJCcjTxPA3DfsGk1sORbuTt1bI
         R6oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Os/eX6BBvnN2Mvum7RYEFx/X4z66th5+MJOO6R38FSU=;
        b=rNOB5Fpynpg2ahr/d3OH8Z3NBUzicUhTmfMJNW4xRgTuU+/P5EtLDyG+ceQRed3LEa
         Bx9sjfzhcGzfMsRpy59CtwnHH924RM4T2ywozaKD53lvJABCV+VjURbpAYaGOEYgeLfN
         AbabX24/8tQaX78YxjT1BYZ3c05KiiJgM9yNrcGfn9oR4+SGgH2/WMysFQZVa2huN3Wq
         rmJ57lX/ZVa7MKA/NTHhYtVXBNtSWHvIqNJ2VtYM7eWivjcCp3DwWNSzqzMJubwGI8l4
         feGbUYnF67veA7GA3p0C/GXz3I7NMHaw57nEykE10suqcqQrdvBv9LsoahenV7lobQYK
         /kag==
X-Gm-Message-State: APjAAAVzbqtl7Ph4ilULKhcRavi76qNyQ/n5MxuYvCa8GO2/UAmbMdxk
        q6ikASyPLP4sQs6tfe0+Op77xt4Fb1M=
X-Google-Smtp-Source: APXvYqxWDO8sqqtDTqzsZIjbdOZEWXXLaHmoBiZYzMvTl9O9JG3gbRUNaoptlDKrXz2QDJhZtYW4Fg==
X-Received: by 2002:a1c:7c10:: with SMTP id x16mr3395459wmc.175.1570032765922;
        Wed, 02 Oct 2019 09:12:45 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id y18sm3940091wro.36.2019.10.02.09.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 09:12:45 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next v2 12/15] netdevsim: register port netdevices into net of device
Date:   Wed,  2 Oct 2019 18:12:28 +0200
Message-Id: <20191002161231.2987-13-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191002161231.2987-1-jiri@resnulli.us>
References: <20191002161231.2987-1-jiri@resnulli.us>
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

