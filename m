Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8506053452F
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 22:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbiEYUqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 16:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiEYUqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 16:46:48 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2919B66AE2
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 13:46:47 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id p5-20020a1c2905000000b003970dd5404dso2203wmp.0
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 13:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HmD+ILtmISWERAH4aIeV37560gKmnrBgHoVxxy91DLo=;
        b=qm6zlnD2jJQSksmBjVu8eXwaB8rnYKro7CS6Ukee0oTrP+yRDktH5Iv6IAEfHNzgCP
         EtzLJNIurN5qwRz+N8DX9A+4+82UgAwSOXVSzZeQ5+BEf1tL0m+ytUYo9rXkuNsGgyFW
         J5o8W4HBIKcrpGoNdHCw3zeNocwSoNrHZGba1A3brYQGWYc8BEjNwwh8nlxAVvZz0uqS
         ZF3QoxcTZGIf06RxYih8PQtBdnrZwPa/fy5lNzYZuh6dJ6VIJiXrMT5UCq+8b1K414kq
         CEDfEX2vt531WL/4Ojf2dgjFlYTv7LHS6Y2F3by19OmwNPOBQ5qYDChef2jOavOHaS+e
         Ko+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HmD+ILtmISWERAH4aIeV37560gKmnrBgHoVxxy91DLo=;
        b=ngGrfBiG+376QMnEgBl8Fx7n/Ib27/GaH54fMoFpin7Jlmrh3AylsZJkI9SHa+vkts
         u9SG5x665ljdq9pEfRILbNpCa6xOh/0b/MOsQ6Iv9X54DD3PSgVtMVZRxBB3OZ3R/iLj
         LhdJZW6z2tHBlCcuUbeVRMwqYkxY4PtYPTNT3scV033Vtn/9dvdVgYDllnievmzmq5/M
         gftwOUwsKX5FMYpcSxpV6T1Cj6KQAB1/CYzJXhTa778ReMtG4upDvebfq8RvWDxk+zpp
         dJEDY/3Gn13f0p8iwtYNBmQ+CUdb/JnQ5eXkx4gcvIuUjLZl/exAL0R8MqTTuIaEYRWo
         WT4Q==
X-Gm-Message-State: AOAM531EBAEJcD2VbdM6lz8udq6GGXQEmOciK3zMGU33vwfEnS0Uxs4q
        j7tCyfpVbESdT7oCsmDr2jM=
X-Google-Smtp-Source: ABdhPJx+ktsRVfd5B7Y2mZI2/NZa/bUlKDldznOHzmbX1ZGXFOkxXp34ORGdf4FV2Wk3kWM4IVBWNQ==
X-Received: by 2002:a7b:c187:0:b0:397:611b:2619 with SMTP id y7-20020a7bc187000000b00397611b2619mr7965329wmi.71.1653511605417;
        Wed, 25 May 2022 13:46:45 -0700 (PDT)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id i12-20020a05600c354c00b003942a244ee6sm3277062wmq.43.2022.05.25.13.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 13:46:44 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     dsahern@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH net] vrf: fix vrf driver unloading
Date:   Wed, 25 May 2022 23:46:28 +0300
Message-Id: <20220525204628.297931-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit referenced in the "Fixes" tag has removed the vrf driver
cleanup function leading to a "Device or resource busy" error when
trying to rmmod vrf.

Fix by re-introducing the cleanup function with the relevant changes.

Fixes: 9ab179d83b4e ("net: vrf: Fix dst reference counting")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

----

Note: the commit message in 9ab179d83b4e did not document it
and it is not apparent to me why the ability to rmmod the driver is
linked to that change, but maybe there's some hidden reason.
---
 drivers/net/vrf.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index cfc30ce4c6e1..7dff865d7283 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -2064,7 +2064,17 @@ static int __init vrf_init_module(void)
 	return rc;
 }
 
+static void __exit vrf_cleanup_module(void)
+{
+	rtnl_link_unregister(&vrf_link_ops);
+	l3mdev_table_lookup_unregister(L3MDEV_TYPE_VRF,
+				       vrf_ifindex_lookup_by_table_id);
+	unregister_pernet_subsys(&vrf_net_ops);
+	unregister_netdevice_notifier(&vrf_notifier_block);
+}
+
 module_init(vrf_init_module);
+module_exit(vrf_cleanup_module);
 MODULE_AUTHOR("Shrijeet Mukherjee, David Ahern");
 MODULE_DESCRIPTION("Device driver to instantiate VRF domains");
 MODULE_LICENSE("GPL");
-- 
2.34.1

