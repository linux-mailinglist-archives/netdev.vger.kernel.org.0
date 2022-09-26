Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96F15EA633
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 14:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239321AbiIZMcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 08:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236865AbiIZMcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 08:32:13 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE3CD8E1F
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 04:10:56 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id nb11so13279665ejc.5
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 04:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=wI7HrNRBO0d7dglUkU4iYvgRqefxDdj6o6r69HsSzz8=;
        b=W9RaSkLlrs36WEBXN/ckvIMaX7Zhs8hb0CRTNTkxRHCVMzICgRsxgFulJqn1O2TAm2
         0S09n/3bFMN6GWAtykm6cqP4xTeN2nGv5p4Zknsr8Trwg1fzX6giSbOSwqMAxoFcJhp0
         WAkO1de/zj68f0g+uBxoFCHkNUPS/kNHQFtKn001XOB7OPfpak/AkBylI/Ajs/Ug4SFw
         ZhkV8eBvrjYaA8AmIJeY0K07C3A87wjNIo/IFenMC5/m4UnbSbYsx0LY5m9IJ4kj4psF
         9ubO92Dj8o0qvYpdONUsWA2EOa2OYQLaP+0x3wJSyztT+l9+lpZ7+CkfTo0yAFsQ4OLP
         1vPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=wI7HrNRBO0d7dglUkU4iYvgRqefxDdj6o6r69HsSzz8=;
        b=XGUebFxLDLc52D/1jRrSLFXJKNF10HlqjgbBrPdX1YjP4E4p7RrpvtV995Ki5TVjpJ
         vBbYdfsm0bllYfmC/94jO9s1IXkIImm53m/r3fOVTbelNRZKCcuROjJ+MV72uw2APiD2
         ZXMBf2O2IVutdWZxcIk/yAkO8F9OO+I77L3TXHkHUO19DKZ5nJgM5xmbBGXQE7dBNoPM
         lGIMnsRq8eNcw6ilXGYVmJPZj+Hf2kKFoyM+vglk9Yy8QRdREtBvW1MXvNtkFruG5dGB
         AkNbreLIhtk0Sw2J1cdURXNuLncvHfzjArMgBnNZtiq5zlaSzIz6JN1u/8RymYITop6j
         V2Cw==
X-Gm-Message-State: ACrzQf1CZvjbpNLTh6wIXKVyrmfRmijNVFt3P2vVsBydyCN/QWAbmT/f
        PXkaadnCb1mRNEJHKxOJ9K7HCEf3kaVRsWcqNsI=
X-Google-Smtp-Source: AMsMyM5/HBXehsaG1ccFSNmBAI12OhALHGotwKSUyKWaFKcd5RHg+Y+Q6CwDSxno1q+I5mX9nDdIlw==
X-Received: by 2002:a17:906:845b:b0:770:86da:9702 with SMTP id e27-20020a170906845b00b0077086da9702mr17073179ejy.244.1664190581516;
        Mon, 26 Sep 2022 04:09:41 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f11-20020a056402068b00b004572df40700sm2880039edy.81.2022.09.26.04.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 04:09:41 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dmichail@fungible.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        snelson@pensando.io, drivers@pensando.io, f.fainelli@gmail.com,
        yangyingliang@huawei.com
Subject: [patch net-next 1/3] funeth: unregister devlink port after netdevice unregister
Date:   Mon, 26 Sep 2022 13:09:36 +0200
Message-Id: <20220926110938.2800005-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220926110938.2800005-1-jiri@resnulli.us>
References: <20220926110938.2800005-1-jiri@resnulli.us>
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

Fix the order of destroy_netdev() flow and unregister the devlink port
after calling unregister_netdev().

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/fungible/funeth/funeth_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/fungible/funeth/funeth_main.c b/drivers/net/ethernet/fungible/funeth/funeth_main.c
index b6de2ad82a32..6980455fb909 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_main.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_main.c
@@ -1829,8 +1829,8 @@ static void fun_destroy_netdev(struct net_device *netdev)
 
 	fp = netdev_priv(netdev);
 	devlink_port_type_clear(&fp->dl_port);
-	devlink_port_unregister(&fp->dl_port);
 	unregister_netdev(netdev);
+	devlink_port_unregister(&fp->dl_port);
 	fun_ktls_cleanup(fp);
 	fun_free_stats_area(fp);
 	fun_free_rss(fp);
-- 
2.37.1

