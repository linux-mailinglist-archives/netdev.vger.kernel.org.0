Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4702F8A73
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729309AbhAPB1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbhAPB1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:27:12 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B43CC061796
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:25:53 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id u25so15909476lfc.2
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=4rDudkueB+J/rIldFghOHcw9v72dbdm42Obo+Ici9oM=;
        b=ZFhv6LPZepr53zK5PFNp/7F7jEvImHKGLn9Xj1hBMHImn7FFLM8yx6obegfINua2fY
         D84luhW8jKnabInRsw+uxqsHrQk/VOzHh/GQgmvFSPo1toLAEOQiZQcSYwPhLtQdI7Pg
         KKiCkTWDmQO0Jv7NNX0QWiEvCzLIZUzHqGRedAzsOQUvZGtvouOFJPCI5k3SxyfljmUn
         1Z197CnBoTrQJGSISwep/7X+Hs77FR7cfaHQYuFvKc2zXvvzb6wL7UaFMWQXVO4ihhnw
         K8Dvzm1ENRN+u9FfjMMzOmQbbK2dQz2n24cI2wL7DKkCNv7ljJh7GBMsuZCdptDG/3Jl
         Bvsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=4rDudkueB+J/rIldFghOHcw9v72dbdm42Obo+Ici9oM=;
        b=M/rod+xn+u+McdzyHH6lOL3ePAw/4lJhJouRY7Ve1iQN/CqNpOxZLI1T7UeybOABbN
         GC2yhwKp0iMQw0uT1ifMM3eEhUuAIJLRi/FvBqf2jFlpdFxiCIF0B7MWhjmo051/3snj
         z+Vvtt6NNxnn6Ff5LVRrmYR16FEtdekrnGj1MaqE5s49XcyE6QeK7gjEVBob6ewtuse2
         SlUNjARD5eFVx9BFINvjYXkkgQFrwXO1fKaSSITIgOt1owrD1Iu7XYw8crGw2zFe7eD8
         WzHOxZDvTMDE8jPzcwwmMVDd/Mmhg6FM1Lg5Q1xjgsOq8/2B8qaV1a+kDKL4U1tY4M11
         DIhA==
X-Gm-Message-State: AOAM532epdYf2kL3J/wIItYl7P5k0Xt7jFOQfWUtVtubV5ywfVpgijC2
        EyKM9+Qm1EG2RnIuutfHNUpD6g==
X-Google-Smtp-Source: ABdhPJy2LlIdwdu0VWicofDcfmHvFAqrAl2dOjHU2G5z5xxHluhxsrQWurEsQeuife0GPoAARk1wwg==
X-Received: by 2002:a19:8149:: with SMTP id c70mr6505366lfd.502.1610760352151;
        Fri, 15 Jan 2021 17:25:52 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id 198sm1085686lfn.51.2021.01.15.17.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 17:25:51 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        netdev@vger.kernel.org
Subject: [RFC net-next 5/7] net: dsa: Include bridge addresses in assisted CPU port learning
Date:   Sat, 16 Jan 2021 02:25:13 +0100
Message-Id: <20210116012515.3152-6-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210116012515.3152-1-tobias@waldekranz.com>
References: <20210116012515.3152-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that notifications are sent out for addresses added to the bridge
itself, extend DSA to include those addresses in the hardware FDB when
assisted CPU port learning is enabled.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/dsa/slave.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index dca393e45547..1ac46ad4a846 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2188,7 +2188,11 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 			struct net_device *br_dev;
 			struct dsa_slave_priv *p;
 
-			br_dev = netdev_master_upper_dev_get_rcu(dev);
+			if (netif_is_bridge_master(dev))
+				br_dev = dev;
+			else
+				br_dev = netdev_master_upper_dev_get_rcu(dev);
+
 			if (!br_dev)
 				return NOTIFY_DONE;
 
-- 
2.17.1

