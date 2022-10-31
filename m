Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612E06136B6
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 13:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbiJaMna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 08:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbiJaMnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 08:43:19 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263FCFAFC
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 05:43:01 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id bk15so15753955wrb.13
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 05:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4UpIgcCxpuX16JUndv1v99RKAxd8jzd6FAQ3FSiOEFo=;
        b=AnpODVlBYGC/Zx7OAp063dLAtBCKmjepugpxdyv6e64WqtZmZF49PBz/gOtnWe7whj
         /Q0WiHUrECupgAfOVE30HC4/KXLZXm4ckrCu5WyLDUnIJVTyuQCplUrRy8iv4gblV//7
         WpGCV2KP5gcGTV3sbCvsvBlHXTqlGkujQAyzG+6IcjL2t1v8EUU1ppoBodo3JFEccqep
         GcdnyTkDzA0m0hFWE2cQGA2j6J/pzSs5aDTxqWWPGyWwlfQWpUAb128ArBjCqPc9wWC5
         YSEMNmVYoAXGHKVxX966ZK+W1Fs3MLKHwp2Gye1QSgDge0HEcsCQIKmAu1lBzYbMpzLe
         ev0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4UpIgcCxpuX16JUndv1v99RKAxd8jzd6FAQ3FSiOEFo=;
        b=N2Ez1oUw1VY+qGvnYF5xLldgC4XkcS8m3cSpkgSc7UqutK4aJhcatvRO0vaRgxZoPN
         N7on3HeXr9+5+xX0bl92sThheNC6I0HAuoUbrCSY6Gc8oeqvWrBA2PziM/bcPYkOrlQH
         znb+QSKYNQP4K6ed3WoeD0tl/o9qD/W3KEhFQYl14+Phv8wUMHYXtpv+0W5PtLLBW4X1
         1ZW/ILuPa5hURyWw4d4GpvyRVONoOtDwikBVrbv760/gMk+duszr6x+f7sNCVVb/J7SG
         1N/qM9EjzSnzjfHNrK2qJF9Jia0WIKNBV85LgM24BCJf9Zq6KccOAFj97AQd4ToP9kJG
         G6Pw==
X-Gm-Message-State: ACrzQf3RQvX8CYj2gVjNh/gBuzybcyELSby7XVENyl2KEdGRfJcLUMH/
        G1GUWVXA9W2ykfwevrTVyFEEVX+RQbRH6L++
X-Google-Smtp-Source: AMsMyM5iD8h3apeFLEj9PsUinUyyxK0l/KQX2KL9gYF7EezBpiJ2nh10VZvfW85CsOcjlrOu2earWw==
X-Received: by 2002:adf:e3c1:0:b0:236:6d5d:ffa2 with SMTP id k1-20020adfe3c1000000b002366d5dffa2mr7932544wrm.557.1667220179699;
        Mon, 31 Oct 2022 05:42:59 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id k5-20020a05600c0b4500b003c6c4639ac6sm7110997wmr.34.2022.10.31.05.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 05:42:59 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v3 08/13] net: devlink: remove net namespace check from devlink_nl_port_fill()
Date:   Mon, 31 Oct 2022 13:42:43 +0100
Message-Id: <20221031124248.484405-9-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221031124248.484405-1-jiri@resnulli.us>
References: <20221031124248.484405-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index 70a374c828ae..d948bb2fdd5f 100644
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
2.37.3

