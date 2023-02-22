Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C6E69EBAC
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 01:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbjBVAJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 19:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbjBVAJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 19:09:34 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCE4265B2
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 16:09:26 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id w3-20020aa78583000000b005d244af158eso908310pfn.23
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 16:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZCzl63HJ+kqOaqrd0SKFlWgpIbxPIOYTA/3AaIJbOmU=;
        b=DMsAdrwlOWOh+lDWt6KAWAmHY+xU0+Wppx7ZSEqrbMPVOJo75bTAz0oE7rAU5aScHL
         y3yRUJsXtkYzzZyQCaOYNHrLFlMcOW2iUhOoIwZww8hfseI/xNxZFeAvDBvsoxiVbruD
         GWVsEGPSv+JOxpaf7yocT6lph9F3h+7uoiaTY1atlpnAtHCmBgyUmPSxSR1yQ8OM9x66
         XfSmyIr5ycJiPjHdu+x8jE7aVqmZ/+bxMfq19a0xWq8an8UwG9GpYt6hBi1mNOpe1pFZ
         jjDSX5Yzmg9fpbpkD/OQDNYSRIc61CHYFDo/RZpLVBh3dl35ntqK1+zX9WQLbdowlf2V
         zbuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZCzl63HJ+kqOaqrd0SKFlWgpIbxPIOYTA/3AaIJbOmU=;
        b=zXx22FlcPriifvH19Sfdu/i6XSFOp3LPBwkez2DbHFqFAdkabT+047J7HQ0QghloLF
         7NYP8bnnEbtpDwEZu6MehJLG1ftrfZw3cu/CPf39dkWi7cPoQdZ45w/IrWqBOReLhxwk
         tq6J5e6pvs5ZlRZfoTHVpq7CkDAwjNP7Z8a4NFUUQY0km1s/Jg46yUY0WfMaY+CioRYv
         Lhvtphtkbuf7eTB8/vcJAP9pA6cxY4v+Z6Qc26la2Accd1l6FMu2qfCu/Bj/WM1kaWE8
         h8Zluz5WcYfP6t+XkMn7cWKMba9PilyXbkLtnq9PkrLhLz0mYcnvHFEfS92k46G5wG/o
         Ax9A==
X-Gm-Message-State: AO0yUKUehiNpuZjmrVwmqotdpZbBG1KBQ7Cd4nxsme+FCn+ak9sBKBJH
        oc+VEoBHBJl2wmk8fHeKKXGVLnFQKCdl
X-Google-Smtp-Source: AK7set9P8J2ZMVQnExTEr/f8yGKCAK1D2UMzTZK1yMvW4ey7FBf9mZbCeF6GCykBrVwQhj4fHaO1Y6PuOEwY
X-Received: from jiangzp-glinux-dev.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:4c52])
 (user=jiangzp job=sendgmr) by 2002:a63:3c58:0:b0:4fb:933a:91d with SMTP id
 i24-20020a633c58000000b004fb933a091dmr874838pgn.11.1677024566128; Tue, 21 Feb
 2023 16:09:26 -0800 (PST)
Date:   Tue, 21 Feb 2023 16:09:14 -0800
In-Reply-To: <20230222000915.2843208-1-jiangzp@google.com>
Mime-Version: 1.0
References: <20230222000915.2843208-1-jiangzp@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230221160910.kernel.v1.1.If0578b001c1f12567f2ebcac5856507f1adee745@changeid>
Subject: [kernel PATCH v1 1/1] Bluetooth: hci_sync: clear workqueue before
 clear mgmt cmd
From:   Zhengping Jiang <jiangzp@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     chromeos-bluetooth-upstreaming@chromium.org, mmandlik@google.com,
        Zhengping Jiang <jiangzp@google.com>,
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

Clear cmd_sync_work queue before clearing the mgmt cmd list to avoid
racing conditions which cause use-after-free.

When powering off the adapter, the mgmt cmd list will be cleared. If a
work is queued in the cmd_sync_work queue at the same time, it will
cause the risk of use-after-free, as the cmd pointer is not checked
before use.

Signed-off-by: Zhengping Jiang <jiangzp@google.com>
---

Changes in v1:
- Clear cmd_sync_work queue before clearing the mgmt cmd list

 net/bluetooth/hci_sync.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 117eedb6f709..6609434e3125 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4840,6 +4840,8 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 
 	auto_off = hci_dev_test_and_clear_flag(hdev, HCI_AUTO_OFF);
 
+	hci_cmd_sync_clear(hdev);
+
 	if (!auto_off && hdev->dev_type == HCI_PRIMARY &&
 	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
 	    hci_dev_test_flag(hdev, HCI_MGMT))
-- 
2.39.2.637.g21b0678d19-goog

