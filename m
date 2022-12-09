Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEDD6484EE
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 16:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiLIPWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 10:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbiLIPVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 10:21:49 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462268D663
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 07:21:47 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-3cbdd6c00adso56000217b3.11
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 07:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2+mnzttDRrZL4jubISGmMwdgtj3XMMFHwL38AYGjbcY=;
        b=eOqm4TFv/Df9rRhZYgEsid4Nrg75ebQpLjDaSe8mFghfDNcx6HxeTAgX0VFcagNtsz
         OBib6ZZA8uLmJ0nIzRs0LozgyGxZikc9mHqkFzUecHKn/vrFO4uYGQ/iIqMeNe3GC2tf
         2NnhcbP6j9utR7rg489K+53x2/LmgmK7n1EFHS1mGoXJGGOAXvCObiuv1grYdLTWNE2P
         lg0vZGsIVJq17kEtrbP19pazW2aro4fJA+Fm6vNt0NDv1OEWdKXo+VeHdHsZukq/0lLP
         jHshLzJaW3BVlm+4bf4SXIGmfYgNCvDIGjsHm5p22DigaQE/3AYa725/aChuXIZq+meT
         3Mlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2+mnzttDRrZL4jubISGmMwdgtj3XMMFHwL38AYGjbcY=;
        b=B6P92KMUgD7hy0MvNMm/KFR8SY98qtNNG8uIt9Ma27Ug0TqQQHJL5WJhZ4yezk4in/
         RSH5orIjkhObrclAiF0uhU3/GPmACGaT484Gt7+YxBT4xlQrUKopGQ/AtA4dvClZKKVB
         vq+bB2l8KfphFsYXQaKBmW76HZDtaCkljpA91d7MPnvBMnTZguI2RkaW8YAl7g3Kqfd5
         h9gM29VI2EkakPn7x70JJKoPzZjqcW8p9+J+AzDtft/71882GVPmlpvf/+blgbQJpJ2f
         LnsHtkK0HyHZ6wQodbFGglYynGRoa6/PoKsmI4C5DCJD+hn2TaY1RVbHrK1XwtznCnql
         1Utg==
X-Gm-Message-State: ANoB5pmUclzpJJ/lEtDnX8eNuI7GwLnS1ZvKQ1ju9kRR2/NAJ8wcCB3C
        IMLSGkuggaVkwv/P0p4CnxTa8FDWYhrMyA==
X-Google-Smtp-Source: AA0mqf7jl7E88PkYleGFZRatkNKccWuVEPVcal3J0X8hrc9OAzF/l9Da9ibiOJH2dkiqiz4HM1/F2A==
X-Received: by 2002:a05:7500:140f:b0:ea:5d80:2833 with SMTP id v15-20020a057500140f00b000ea5d802833mr548053gaa.58.1670599306334;
        Fri, 09 Dec 2022 07:21:46 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id i26-20020a05620a0a1a00b006fbae4a5f59sm39699qka.41.2022.12.09.07.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 07:21:45 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        LiLiang <liali@redhat.com>
Subject: [PATCH net-next 3/3] net: failover: use IFF_NO_ADDRCONF flag to prevent ipv6 addrconf
Date:   Fri,  9 Dec 2022 10:21:40 -0500
Message-Id: <313ff2644295062566673f7130636a6a6e88682b.1670599241.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1670599241.git.lucien.xin@gmail.com>
References: <cover.1670599241.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to Bonding and Team, to prevent ipv6 addrconf with
IFF_NO_ADDRCONF in slave_dev->priv_flags for slave ports
is also needed in net failover.

Note that dev_open(slave_dev) is called in .slave_register,
which is called after the IFF_NO_ADDRCONF flag is set in
failover_slave_register().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/core/failover.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/failover.c b/net/core/failover.c
index 655411c4ca51..2a140b3ea669 100644
--- a/net/core/failover.c
+++ b/net/core/failover.c
@@ -80,14 +80,14 @@ static int failover_slave_register(struct net_device *slave_dev)
 		goto err_upper_link;
 	}
 
-	slave_dev->priv_flags |= IFF_FAILOVER_SLAVE;
+	slave_dev->priv_flags |= (IFF_FAILOVER_SLAVE | IFF_NO_ADDRCONF);
 
 	if (fops && fops->slave_register &&
 	    !fops->slave_register(slave_dev, failover_dev))
 		return NOTIFY_OK;
 
 	netdev_upper_dev_unlink(slave_dev, failover_dev);
-	slave_dev->priv_flags &= ~IFF_FAILOVER_SLAVE;
+	slave_dev->priv_flags &= ~(IFF_FAILOVER_SLAVE | IFF_NO_ADDRCONF);
 err_upper_link:
 	netdev_rx_handler_unregister(slave_dev);
 done:
@@ -121,7 +121,7 @@ int failover_slave_unregister(struct net_device *slave_dev)
 
 	netdev_rx_handler_unregister(slave_dev);
 	netdev_upper_dev_unlink(slave_dev, failover_dev);
-	slave_dev->priv_flags &= ~IFF_FAILOVER_SLAVE;
+	slave_dev->priv_flags &= ~(IFF_FAILOVER_SLAVE | IFF_NO_ADDRCONF);
 
 	if (fops && fops->slave_unregister &&
 	    !fops->slave_unregister(slave_dev, failover_dev))
-- 
2.31.1

