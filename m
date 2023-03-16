Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54406BC69F
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 08:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjCPHMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 03:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjCPHMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 03:12:08 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A91ABB2E
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 00:11:25 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5447558ae68so7304137b3.13
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 00:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678950682;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ONiyvATRP+sYO0cUaYvRRKjkxrSOSKrIRA+wHss4tjQ=;
        b=H+FPljJIIomYtc/NnrAnTTyoSPEooxmuWOrMvbKEhQcBQTU6TLkGYtIcd72fxkZvyj
         ie4ciSX2lkqv/NX/kCkLwzLilcEM6aXv10YrWNeWoQaLO15Xermeog90+uTvTpnHWn9a
         LCOzRiuMI2QAQcQ3ma6g8fWFPt11FPw6Kek0XN71XeoLf/ax/V0r1XeKEtXoKoPH8i1z
         jtATqW2Mjg6A4sHs1ca+plj8mOV4o48m7NU7R0ctNpQTVCx/mhO54JK46OaytnhUD81v
         zPTNtMnHE9ZDYVprOfQfORuUbZXvSbZE/QRBIsu0UrRtZEv9Vy2XUXNP/S1TumsnPT8D
         2lAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678950682;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ONiyvATRP+sYO0cUaYvRRKjkxrSOSKrIRA+wHss4tjQ=;
        b=4FNbzv1C1JPv0xFkcMXhxLLtMpAU9ZhyBC2eYk0ETdXVQA/njC54yjCtiHnBCJvUVY
         fomMg64W7ee182SdLJMKClBDCsJajjls0MkMHCEk2kfCOUD5IG6NB7Z6i2eB13ZRQjCx
         7iid275IkckT9agnNPxTRXavGbc3GNHECQWgcmdWetDKaSYUw+ZamgwxUPd+b3ih9QJI
         p3++InqNFZ+VkHVUyTIYTAHGzZzhnsLweZqz2Ioee+kPfW8nR2RNvdDGQUS3osrS9jbT
         Med2dfi6g2a48cbRzLFlmpZVf3qUEtHYophqlAZzQpl0+lmXafWR3DF1++OXuU3mKfZ6
         G8Qw==
X-Gm-Message-State: AO0yUKWfvy+fNpNuA5uRQty8N8LBPgLc3FEiwWbzRaZxiTRtm2fWXKeb
        iECRYxYgm18RDWltZnGKaQJ0XmSXkfENTnuX0Q==
X-Google-Smtp-Source: AK7set91b5nUXx5SrhOK3n4qjarCprO5irMkIBZbqna7UYe5L25YhwrToCIxOTjZ6NIUBw4kz/evVHiPgmdEpjmCwQ==
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:17:5470:81fd:9c7f:513a])
 (user=howardchung job=sendgmr) by 2002:a81:4317:0:b0:52e:f77c:315d with SMTP
 id q23-20020a814317000000b0052ef77c315dmr1629424ywa.3.1678950682470; Thu, 16
 Mar 2023 00:11:22 -0700 (PDT)
Date:   Thu, 16 Mar 2023 15:10:58 +0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230316151018.v1.1.I9113bb4f444afc2c5cb19d1e96569e01ddbd8939@changeid>
Subject: [PATCH v1] Bluetooth: mgmt: Fix MGMT add advmon with RSSI command
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        howardchung <howardchung@google.com>,
        Archie Pusaka <apusaka@chromium.org>,
        Brian Gix <brian.gix@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: howardchung <howardchung@google.com>

The MGMT command: MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI uses variable
length argumenent. This patch adds right the field.

Reviewed-by: Archie Pusaka <apusaka@chromium.org>
Fixes: b338d91703fa ("Bluetooth: Implement support for Mesh")
Signed-off-by: howardchung <howardchung@google.com>
---

 net/bluetooth/mgmt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 39589f864ea7..249dc6777fb4 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9357,7 +9357,8 @@ static const struct hci_mgmt_handler mgmt_handlers[] = {
 	{ add_ext_adv_data,        MGMT_ADD_EXT_ADV_DATA_SIZE,
 						HCI_MGMT_VAR_LEN },
 	{ add_adv_patterns_monitor_rssi,
-				   MGMT_ADD_ADV_PATTERNS_MONITOR_RSSI_SIZE },
+				   MGMT_ADD_ADV_PATTERNS_MONITOR_RSSI_SIZE,
+						HCI_MGMT_VAR_LEN },
 	{ set_mesh,                MGMT_SET_MESH_RECEIVER_SIZE,
 						HCI_MGMT_VAR_LEN },
 	{ mesh_features,           MGMT_MESH_READ_FEATURES_SIZE },
-- 
2.40.0.rc2.332.ga46443480c-goog

