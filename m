Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C13E15F1A1C
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 08:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiJAGC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 02:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJAGCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 02:02:08 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E10B1806DC
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:02:02 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id l14so12899429eja.7
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Xkrdf+/gpeU5ZHA2wpZ8zSHF8UtvbLtsh5YT340b3BI=;
        b=EUXB6JTEq+XZIWmcvVfSjxf/+j+BqCHikoZMibFHB6WI4SAQGj0vH1G0siqrd2jfFu
         Ow7h7KN1PuAuHtKf0rUeP1pk0whrvHRQnfk5QLRyOEEESjyPNyVHL2Y5V9uJ9JzBwJZW
         DVuZGnVhKvlTEKzgYbLYzIwRKS665U8epAuZlyx/ZcJw/FZyKHTPj2mlr9b1FreH0XUf
         /KoqLl19FrlZ5zvvI943kfohPRAIPgtwXA5Q6zAAhD7WPHNFpp6BaxCGSm/TrT0DUa+4
         aeGkV7emLLKD+nqrPwZT1PPJrUtjU6TJd1Kh2CCZ4DvpqYj1aNeHiy3M7WaLAiIVIo9o
         kOkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Xkrdf+/gpeU5ZHA2wpZ8zSHF8UtvbLtsh5YT340b3BI=;
        b=1q3rxtVKsqOUzHmwe2Ndm1BUkTCUpMtyiIX2KBGsF0zOQmynnrAfZ8tjOJ9q+FZFe+
         ivQK0KBPiSV+XqjsuI/AygJ7DQC+050OirZz+b2PW/3JHeR1KI8KsJH5m01giLp4Eh+L
         7bYqjNvkKmHQ3wnGScrBILHJ/BotStmxvlD6kXaTvXFUxgyJsYngJ+Nz1U54IaxjrSor
         5joLhxX/QBWOtP9AtqMz/4+FKBaQgpNKiD2fG721OwuS/qQ/os4q4bqq9N1QKkpG6IOU
         revgnahv0eYSH+YjkPMwzDQwVpU+ZlMxTn9kxTINQP8LG91qTSODyDSENy7bg8Q8EUu1
         ON0Q==
X-Gm-Message-State: ACrzQf1FSMP1SS4HJoUbPrzoNP2ntzkPcju2gpwkhT0Eg88+/e6Vzqm1
        OjoEkDotIwwzR2mbyEnB32D7dyJwMBJSrSwI
X-Google-Smtp-Source: AMsMyM5P5Qo6cmszEUn4vxq7t2P4+IKqFYRYhXDKv5ljwPhcg7C/EV40OarNZvtqm3sqNzLy9YoGeQ==
X-Received: by 2002:a17:907:3206:b0:780:a882:a9ac with SMTP id xg6-20020a170907320600b00780a882a9acmr8610036ejb.765.1664604120854;
        Fri, 30 Sep 2022 23:02:00 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id m21-20020a50ef15000000b00458bb36042asm486296eds.1.2022.09.30.23.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 23:02:00 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com
Subject: [patch net-next 08/13] net: devlink: remove net namespace check from devlink_nl_port_fill()
Date:   Sat,  1 Oct 2022 08:01:40 +0200
Message-Id: <20221001060145.3199964-9-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221001060145.3199964-1-jiri@resnulli.us>
References: <20221001060145.3199964-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

It is ensured by the netdevice notifier event processing, that only
netdev pointers from the same net namespaces are filled. Remove the
net namespace check from devlink_nl_port_fill() as it is no longer
needed.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index f119ac43c50d..b5a452bec313 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1305,10 +1305,9 @@ static int devlink_nl_port_fill(struct sk_buff *msg,
 			devlink_port->desired_type))
 		goto nla_put_failure_type_locked;
 	if (devlink_port->type == DEVLINK_PORT_TYPE_ETH) {
-		struct net *net = devlink_net(devlink_port->devlink);
 		struct net_device *netdev = devlink_port->type_eth.netdev;
 
-		if (netdev && net_eq(net, dev_net(netdev)) &&
+		if (netdev &&
 		    (nla_put_u32(msg, DEVLINK_ATTR_PORT_NETDEV_IFINDEX,
 				 netdev->ifindex) ||
 		     nla_put_string(msg, DEVLINK_ATTR_PORT_NETDEV_NAME,
-- 
2.37.1

