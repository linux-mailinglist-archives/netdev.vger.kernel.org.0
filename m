Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2FA689417
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbjBCJkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbjBCJjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:39:48 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA3325BA3
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 01:39:41 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5258dd49a5cso9991197b3.5
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 01:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QN14ziO4JxILP7mp40ANOysEeXcgBUkL5cm+RkfL8ZI=;
        b=ALQj60Z8rE+o1jswa2sIaTx9ItPQ/H6fcei4FBro1MVoWPnvBFJmIRPFr3A5je5c+/
         XXcuJ5tLa0Iu4OvJYbcRxIRzENg+rRn8Y19EEwtQXH3D4sE+UOgMF12sDkCo80rYqtwo
         YiD4S0CqHRfYLQQGF+iZ+sH1mmhzL/ujWr2AoiBZTRi62GjDS3inDI9mbBcG9YoOYsk+
         vbq15f4bmy1zPTWlVHdvFNH7HWSPhf8Zy0ekRbboT+LJ5SvX3cQAOmpdRh6oeRbg9NZh
         sJhvGWAa9fI0MXDId99AiT9ATmaoarGE7RwdXyOhuelp1HzXWVfS9VFMERg60w0+5ueD
         we5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QN14ziO4JxILP7mp40ANOysEeXcgBUkL5cm+RkfL8ZI=;
        b=shKY8chLigocIrrWB9MPZx1bHK67j7LzwiUtfBYgkSPrVw+WZymICE/IAzKe9BVDiS
         TUiX7sVxG7Y6LBMf0WE/yQXemBovWcTHEmvbLQ50VoOzv2Uzr6LCZbt2SOcUVJH3fFJG
         va6+Ek6J8Sj2JEoQOaxHE57v/oSFt8Ob5yfsRDtI96EvAv94iuyHOabJNBAVjSC765uA
         Ss3JvA+c8h86zhwPz7+PvG3EPy9cITFR8rL5rKgaQ+irds3xJSoeEk4657tIezRTi87y
         eWVt1TgGdYyOdVP1Ono5CvGVX+LEW7Dz2y+Chy5spHVh1F22iWBv+pLzDRmfqncIDaGG
         E2QA==
X-Gm-Message-State: AO0yUKVSSLU4IP7FlGgmZbJSbhH2EHpoVek9sk3zAb8Y7Vu1sVOBq3dN
        1j2fmeT9AqCjqvQ+fxCAALKKQlGFNJ58
X-Google-Smtp-Source: AK7set/E9XfPkDUc7TDF1CbiQthpXU/qBRltk6TmvylDtTmU566EojX9yMs6MRHtiyH8PAMAq8X0TmpCgD0I
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:17:dc12:2976:77a:8cb7])
 (user=apusaka job=sendgmr) by 2002:a81:ac4d:0:b0:507:739d:e0ca with SMTP id
 z13-20020a81ac4d000000b00507739de0camr1073769ywj.495.1675417181195; Fri, 03
 Feb 2023 01:39:41 -0800 (PST)
Date:   Fri,  3 Feb 2023 17:39:36 +0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230203173900.1.I9ca803e2f809e339da43c103860118e7381e4871@changeid>
Subject: [PATCH] Bluetooth: Make sure LE create conn cancel is sent when timeout
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Ying Hsu <yinghsu@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
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

From: Archie Pusaka <apusaka@chromium.org>

When sending LE create conn command, we set a timer with a duration of
HCI_LE_CONN_TIMEOUT before timing out and calling
create_le_conn_complete. Additionally, when receiving the command
complete, we also set a timer with the same duration to call
le_conn_timeout.

Usually the latter will be triggered first, which then sends a LE
create conn cancel command. However, due to the nature of racing, it
is possible for the former to be called first, thereby calling the
chain hci_conn_failed -> hci_conn_del -> cancel_delayed_work, thereby
preventing LE create conn cancel to be sent. In this situation, the
controller will be stuck in trying the LE connection.

This patch flushes le_conn_timeout on create_le_conn_complete to make
sure we always send LE create connection cancel, if necessary.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Ying Hsu <yinghsu@chromium.org>

---

 net/bluetooth/hci_conn.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 61a34801e61e..f2c7edaa7145 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1243,6 +1243,8 @@ static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
 	if (conn != hci_lookup_le_connect(hdev))
 		goto done;
 
+	/* Flush to make sure we send create conn cancel command if needed */
+	flush_delayed_work(&conn->le_conn_timeout);
 	hci_conn_failed(conn, bt_status(err));
 
 done:
-- 
2.39.1.519.gcb327c4b5f-goog

