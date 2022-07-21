Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78CFD57C8EB
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 12:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbiGUK1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 06:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233137AbiGUK1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 06:27:08 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCB35E32B;
        Thu, 21 Jul 2022 03:27:07 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id b7-20020a17090a12c700b001f20eb82a08so4790697pjg.3;
        Thu, 21 Jul 2022 03:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AJvJg5VfHODuaSLzinSpGoi4mxTLG31Qh4uY2TFvOHM=;
        b=hwWVOGhTLPi+PgCS6IrtK53QHtd3Woi66ITng22SEJLrdK29CPYMk4RkNlQI3AX9Nn
         0r5C7SwnC8GrLfgzNzEsqB5HxWd/lNWPpEr6Pub2UdIChZzFaIa7MUeLYYtkRmZqDbSj
         7S/78ukBpSVmZPrYV1ILcGWHhpzJYDpMIlxNKF9PaOH3+eUlt+7V0koMHzUSWBsDD3mj
         7OOQGZW4P/+dW3ighZDzhJQIwd2qeYX0grjaMiZSOpdO1V/7XJjZe7OWGpLvdThX78Ja
         MCQ0MPqojmJ+kOP/DoZYZbBbis9/ER/Ha4N/KK1Jg/2cwxeNrw2giJiIAWz7BC89HprE
         oDAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AJvJg5VfHODuaSLzinSpGoi4mxTLG31Qh4uY2TFvOHM=;
        b=6eQ1jabYT0GnD5VZ7kpxI83SOmZ1hTKpHy7j3IwHEIKUoJLRS+M3K8G6eAgT50zGm2
         yvgkzb+bc7o+friGD+fisQMOQUbMa2r3hb9D4dEdRdyJLBj7Os83rVRZQHIi/GugRbea
         27j+XXPuwkDIAt0yTAvxZgz4Gk+EIALRndeGh6pEN0BqtGplKUzM0pppQuqRNBtt5FSh
         lFgcYo43oupulGM6M3FZ/qZjkZEsVSkF4bFamdHQ52ZwJtxqaoyvWvv9OHQbu/fl/4SU
         ZRQn6X6+ttFM33WIGjxSGMvEXrIcs0Uj8g1F2gVCj2g7/8cW26f3jkX+Qj+6tj2LpCLo
         fJAA==
X-Gm-Message-State: AJIora+FOk6GNgIqAUffkGWHqhn8UgItVEA0Cn9dSeUOyeJD80Du+ZmC
        2C0NGkbHUJNMBAHeVnO0UcufRc8XFYfs75Pif8A=
X-Google-Smtp-Source: AGRyM1vGqpgvHbjo2Zfhr1a2ZF5lPNbiBp1xUfhcvn8hWr6i3CW1Jq/K5UVHqLXdeZNttS3FIwSTEQ==
X-Received: by 2002:a17:902:ce8f:b0:16b:fbc1:9529 with SMTP id f15-20020a170902ce8f00b0016bfbc19529mr42595539plg.159.1658399226840;
        Thu, 21 Jul 2022 03:27:06 -0700 (PDT)
Received: from kvm.. ([58.76.185.115])
        by smtp.googlemail.com with ESMTPSA id f64-20020a17090a28c600b001ef7c7564fdsm3285752pjd.21.2022.07.21.03.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 03:27:06 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     netdev@vger.kernel.org
Cc:     tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, idosch@nvidia.com,
        petrm@nvidia.com, linux-kernel@vger.kernel.org,
        Juhee Kang <claudiajkang@gmail.com>
Subject: [PATCH net-next 2/2] net: marvell: prestera: use netif_is_any_bridge_port instead of open code
Date:   Thu, 21 Jul 2022 19:26:48 +0900
Message-Id: <20220721102648.2455-2-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220721102648.2455-1-claudiajkang@gmail.com>
References: <20220721102648.2455-1-claudiajkang@gmail.com>
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

The open code which is netif_is_bridge_port() || netif_is_ovs_port() is
defined as a new helper function on netdev.h like netif_is_any_bridge_port
that can check both IFF flags in 1 go. So use netif_is_any_bridge_port()
function instead of open code. This patch doesn't change logic.

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_router.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 3c8116f16b4d..58f4e44d5ad7 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -389,8 +389,8 @@ static int __prestera_inetaddr_event(struct prestera_switch *sw,
 				     unsigned long event,
 				     struct netlink_ext_ack *extack)
 {
-	if (!prestera_netdev_check(dev) || netif_is_bridge_port(dev) ||
-	    netif_is_lag_port(dev) || netif_is_ovs_port(dev))
+	if (!prestera_netdev_check(dev) || netif_is_any_bridge_port(dev) ||
+	    netif_is_lag_port(dev))
 		return 0;

 	return __prestera_inetaddr_port_event(dev, event, extack);
--
2.34.1

