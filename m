Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A77607967
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 16:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiJUOWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 10:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiJUOWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 10:22:51 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4376A265C69
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 07:22:51 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id f22so1715353qto.3
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 07:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wNMbt44i9GLJs6vfdaRE6Jr0kQTB0qFi6v1dXWZLgTY=;
        b=YVg+Dy0uGv3W0m0cWg0ryvUIbjRLgJsckXEtp+TSo5eQF8VIye8ovJZ4YRIqevFNZv
         cmChqaI0vvZf4VuDkk0bq/tn+Yif/87uIcN1L8FbqlfpDYxt/4SBptOUTrQrCNIA4AdG
         BhK921Iek/jKGV86MU1al9uUaW+Hwia+Iv8vjhbCuqim17wUN6EVJk/OhCfUtOKYAJNV
         wUSlpnKPmm1iPh05q7HCQeEXgfwkmHPcBeaVD2sBKuJm3mRWrlAPAQT4rRV24gVWQJ0S
         Tx6sgewRYzowOxxghzl4vsuxgeNEMy4PQBCKg4Q4umQVt5LyLOgM0+kq8bb9EY01PIAg
         QsPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wNMbt44i9GLJs6vfdaRE6Jr0kQTB0qFi6v1dXWZLgTY=;
        b=UgpBgdafGOQ9mVX8ZX16XPpxJadFeQ4WU7/syLgS2NskWxgQOeHZzMvqSDZmiVLRw+
         hRzjGM8ZKxbH6Dz7EUIfB+cXvE3p0KtncoKBOg8kWdYIZU3j3oteaWHcDKr0voVzsRQu
         UGanQjbwf/kzSZJbJqwFkel6wH66+jGoralQUfPbS10wGIe45ssU1qBJ0ba1T2yPW29J
         6SOpPYjHJKkscrlmZeV6pauK+w5neB0MQyC2YCHLZzxx688t9tPp6+7j+fhZB480uyQI
         5ly7ud4Tl/0GKITunu88pI0hZhv8uO6Gz7VyTO+L6ldMFFI+0ZftZDESS1w9LCjQeSNk
         Jk2Q==
X-Gm-Message-State: ACrzQf1qxsW9CKvmFDjh/GmdoyuBme2t0dcGQ8iV12czwTp3ZdbmKqNL
        cjR5iCYhGzu77tcYQNcGiITcAw3bvC4=
X-Google-Smtp-Source: AMsMyM4nFHOeeHGdFN2SXh3TfRYqcU5R0c02QdGeWRYRG/aR9U06pUwyX1gYj07Dw7sdQ/1Isemgtg==
X-Received: by 2002:a05:622a:285:b0:39c:e04a:4f43 with SMTP id z5-20020a05622a028500b0039ce04a4f43mr16892866qtw.390.1666362170097;
        Fri, 21 Oct 2022 07:22:50 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id u7-20020a05620a430700b006cf8fc6e922sm9614093qko.119.2022.10.21.07.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 07:22:49 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Subject: [PATCH net] ethtool: eeprom: fix null-deref on genl_info in dump
Date:   Fri, 21 Oct 2022 10:22:47 -0400
Message-Id: <5575919a2efc74cd9ad64021880afc3805c54166.1666362167.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
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

The similar fix as commit 46cdedf2a0fa ("ethtool: pse-pd: fix null-deref on
genl_info in dump") is also needed for ethtool eeprom.

Fixes: c781ff12a2f3 ("ethtool: Allow network drivers to dump arbitrary EEPROM data")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ethtool/eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
index 1c94bb8ea03f..49c0a2a77f02 100644
--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -124,7 +124,7 @@ static int eeprom_prepare_data(const struct ethnl_req_info *req_base,
 	if (ret)
 		goto err_free;
 
-	ret = get_module_eeprom_by_page(dev, &page_data, info->extack);
+	ret = get_module_eeprom_by_page(dev, &page_data, info ? info->extack : NULL);
 	if (ret < 0)
 		goto err_ops;
 
-- 
2.31.1

