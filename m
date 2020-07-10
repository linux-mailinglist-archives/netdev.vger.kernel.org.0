Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E5D21B6E9
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbgGJNpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:45:53 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32697 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728349AbgGJNpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 09:45:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594388748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=lPlpIEpm5oUE43hFAFoTmnj/BXFQuZwXgNqQp7AmsxA=;
        b=YVNNslq7BI2rzGq9bu0hoDc4MO4ThqW08ZvtLYNQle4dUSYAGGL7uGzbRymV5f5U6PDVLJ
        GYtValqmRgpaIMJ9e6RkqJAZSBH5s1tFwP2IfFLb4iBOItR79SBDLdrehwP5/8Io/g4V/O
        w7Zhwgc8SyrrvSkUbwCB/IjUgtI/ZMA=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-qGtOsW_SO82heW6jydmh3A-1; Fri, 10 Jul 2020 09:45:47 -0400
X-MC-Unique: qGtOsW_SO82heW6jydmh3A-1
Received: by mail-qv1-f72.google.com with SMTP id ee9so3684116qvb.6
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 06:45:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lPlpIEpm5oUE43hFAFoTmnj/BXFQuZwXgNqQp7AmsxA=;
        b=kLM/48jI89zxB0L2Q7+Vycmb3zjUOvacAeZVqHBtJYqosZ4Ybse/ECC4R6KHMbEsLg
         5rjmm52hlIdX53/UeF8y07R7AiT3CcaC63YwpDJnFS0T3ccIwLZRoIZtJlzZd7URYwUT
         rzHnqoJxZAotBUGgMjjYHbIolXYFy8kv2FWgtb3STg+KA65PDjRBh/+6V391x4C6YBwl
         k+KCm+cz1fCPjLiQKp8gdX4AKTdeq9blhecEUUT6WB5GN0MjGZ6yztvU0B++A88XVqh/
         LEmzSF0O59jwEfi/LjZFA+wWs84OW4E+j6vBLRMdleCRhI9HCLfpnXtr9GodV1bchbk5
         GWWA==
X-Gm-Message-State: AOAM530R8kxd19F9uhqxNMASVg7yf3YytIjUOHzrWDJOseY/wspIkCBJ
        dowfprpVWp/nP6m8zoOBTzCPS4WuL8NZddLRMnnXxJ31w3tBt5QGyDB9MBV3rxfiUi66Pk+tDFv
        j2F8BIvUJd+/xzBJI
X-Received: by 2002:a37:9c51:: with SMTP id f78mr32001857qke.60.1594388744836;
        Fri, 10 Jul 2020 06:45:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwljFDiZqQSkAeAYfMmOidn6SEJGK6KdJbZ8RNJcV62h3bEKS3lxdeCTcgI/Er7wU4nz0Ue+A==
X-Received: by 2002:a37:9c51:: with SMTP id f78mr32001825qke.60.1594388744570;
        Fri, 10 Jul 2020 06:45:44 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id o12sm7258887qtl.48.2020.07.10.06.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 06:45:43 -0700 (PDT)
From:   trix@redhat.com
To:     robin@protonic.nl, linux@rempel-privat.de, kernel@pengutronix.de,
        socketcan@hartkopp.net, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, ecathinds@gmail.com, lkp@intel.com,
        bst@pengutronix.de, maxime.jayat@mobile-devices.fr
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] can: j1939: fix double free in j1939_netdev_start
Date:   Fri, 10 Jul 2020 06:45:36 -0700
Message-Id: <20200710134536.4399-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

clang static analysis flags this error

j1939/main.c:292:2: warning: Attempt to free released memory [unix.Malloc]
        kfree(priv);
        ^~~~~~~~~~~

The problem block of code is

	ret = j1939_can_rx_register(priv);
	if (ret < 0)
		goto out_priv_put;

	return priv;

 out_priv_put:
	j1939_priv_set(ndev, NULL);
	dev_put(ndev);
	kfree(priv);

When j1939_can_rx_register fails, it frees priv via the
j1939_priv_put release function __j1939_priv_release.

Since j1939_priv_put is used widely, remove the second
free from j1939_netdev_start.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")

Signed-off-by: Tom Rix <trix@redhat.com>
---
 net/can/j1939/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
index 137054bff9ec..991a74bc491b 100644
--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -289,7 +289,6 @@ struct j1939_priv *j1939_netdev_start(struct net_device *ndev)
  out_priv_put:
 	j1939_priv_set(ndev, NULL);
 	dev_put(ndev);
-	kfree(priv);
 
 	return ERR_PTR(ret);
 }
-- 
2.18.1

