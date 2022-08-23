Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7B359EBB6
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 21:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbiHWTBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 15:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234392AbiHWTAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 15:00:43 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933DFD9D77
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 10:31:40 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-334d894afd8so251006237b3.19
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 10:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=yn+6KcdSjUbj8fiFrESi6rWr7GFxzW1P62BNa1n26Qc=;
        b=F/wa38ebtnf6p2G0h4tuwd4+Sps4tiDURiBiKdXCMXN0BonVuffQnbmF2ngVoFUeNq
         sZMTmw2BfxcEQxOHlXBQ2Nua7KD8YrGY3NvW+AI+gJLcEKiVwaspfOAd325ipIr/vA49
         aGCaGenMMvARROjfSTQp42c1/uWMk8EKyQMMr/hfZDZNnZ2Q00YWjn1lecnMCWt/F6mL
         7zpFm4Sm5+LIeHu28AKvBRv5nrxkSLZJZVy+l9OvJ8jFTM03t8ZR8GBcf8nob4daHrFl
         /urUEQPGewGxUBoqQ1N/lQ+qjGs0Mft37H3Ik/zajGXixMbr/o8JLIhd4F4pjSuXIgmQ
         hRvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=yn+6KcdSjUbj8fiFrESi6rWr7GFxzW1P62BNa1n26Qc=;
        b=x7X8TdGwfgCGolkVESvbx42u6M/gAdrSsJsBbMqyPjcfzwVplaNFrsLWTm5yCwYVu4
         Sl8m1tszQre4GWkyNH4a+F6OB9FojXzafKweFlvsZSGGJC1HPRmpxMKLa96MSSSXBFYB
         JRec+z08IInpD+yhLmdkopbvpu/FxBHQOCoXO308kmajNlNw/FW4SFpbicDZSvh7eaPq
         elRYF7ebLailH2/xcl9bRlfwBonOqDFrPEJBPhntLxG8hf7e/8kDo3vl/ixff+q5n54X
         Clmi/ZCtec1e5A94UehXjE5Ofa37hAhCH1fcT67k8AoWl+oreTK7Hwk2dGbwbFkdvQW8
         u5AQ==
X-Gm-Message-State: ACgBeo1/zJjqsAj4Si+X/eVZ2xK5ilHjv8CZZzK00TqdSKN5JH696OOR
        WfT+hQ/DEa/EGjb6IJbsmU1ykQo/dxcq
X-Google-Smtp-Source: AA6agR4PMULbgfNA1eniMg787393QqeoXOqpgtEpbM22gXlXqm78mqE1N/r/LLOqc91THCOKSROADhGgb8DC
X-Received: from jiangzp-glinux-dev.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:4c52])
 (user=jiangzp job=sendgmr) by 2002:a25:e401:0:b0:694:db13:aead with SMTP id
 b1-20020a25e401000000b00694db13aeadmr21148400ybh.149.1661275694093; Tue, 23
 Aug 2022 10:28:14 -0700 (PDT)
Date:   Tue, 23 Aug 2022 10:28:08 -0700
In-Reply-To: <20220823172808.3477638-1-jiangzp@google.com>
Message-Id: <20220823102800.kernel.v3.1.I1d10fc551cadae988dcf2fc66ad8c9eec2d7026b@changeid>
Mime-Version: 1.0
References: <20220823172808.3477638-1-jiangzp@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [kernel PATCH v3 1/1] Bluetooth: hci_sync: hold hdev->lock when
 cleanup hci_conn
From:   Zhengping Jiang <jiangzp@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Zhengping Jiang <jiangzp@google.com>,
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When disconnecting all devices, hci_conn_failed is used to cleanup
hci_conn object when the hci_conn object cannot be aborted.
The function hci_conn_failed requires the caller holds hdev->lock.

Fixes: 9b3628d79b46f ("Bluetooth: hci_sync: Cleanup hci_conn if it cannot be aborted")
Signed-off-by: Zhengping Jiang <jiangzp@google.com>
---

Changes in v3:
- Remove an empty line in commit message between Fixes and SoB

Changes in v2:
- Update commit message

Changes in v1:
- Hold hdev->lock for hci_conn_failed

 net/bluetooth/hci_sync.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 74a0cd5d0b37f..e08c0503027d8 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5034,9 +5034,11 @@ int hci_abort_conn_sync(struct hci_dev *hdev, struct hci_conn *conn, u8 reason)
 		/* Cleanup hci_conn object if it cannot be cancelled as it
 		 * likelly means the controller and host stack are out of sync.
 		 */
-		if (err)
+		if (err) {
+			hci_dev_lock(hdev);
 			hci_conn_failed(conn, err);
-
+			hci_dev_unlock(hdev);
+		}
 		return err;
 	case BT_CONNECT2:
 		return hci_reject_conn_sync(hdev, conn, reason);
-- 
2.37.1.595.g718a3a8f04-goog

