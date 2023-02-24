Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFBE6A228A
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 20:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjBXTxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 14:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjBXTxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 14:53:17 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E913630B22
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 11:53:16 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id j10-20020a170902da8a00b00188cd4769bcso250960plx.0
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 11:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8YOzDd/6L/vKBnSebEe4nvaSdZD321OF0FG44WHcog8=;
        b=WT4/T85dVBxjE51E8WWLMhAavndjTBa0+BF4I0xQ0fDPyRnA/YzJQWGmLvkElaKV9m
         rQ0inlp89lgMu9ePvEB6QEv7X2KTJ4G8sjeEZyJtEvwcKX5TE2HXHesglNzDcXaYi7W6
         KJiY2HD9eKG8xBQ/wjBjvncL+2JIJ5wyLsVqIl7a5AWftGl/olQXcrPI0/CAI0FfZPvL
         yy4T+xereVFACpDEWXIH/gu2WuCAARPJIL072MgQnFEkwtkEtA+Sbcp0OxISt6vcu1S8
         VX05yw1pxu40eyDduVaiI3qwuWmbrkRH8Qny8CKmbLo74Rd5g88xKeAzMpOsPK7iROj6
         zFgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8YOzDd/6L/vKBnSebEe4nvaSdZD321OF0FG44WHcog8=;
        b=axXN0GPpDXW7M1xW45zW9JWRZS/JL+yGjpN9dyIzy4Z6nY34uyU+AplkCnK0Zpu0zM
         U1ryGdLcSwY0ZhYNIhfNFMP4cNp8Lid4pgqPptCwSrxSVJQZRpBlLlJ2aJfbRi4OJ9ZR
         gEGtsF5LGdfH0GDfaACXXhKlTgiINGfy4UApFXF8TVy10TxAMBLnKEO+wfsAwdmrXdIH
         llcoHUFdr2Zdi6ab7Ocx0og7Vr1TKuBSAs/F7FV2/ZQShq7t/cpy0asP1RX5/8D+DgvR
         ha0BAQ7p6d02FLEBXE0gJYSj2ujZ5xaNfAWakuQDBP0W/ScwOARgv+8roGal1POVl9VC
         U67Q==
X-Gm-Message-State: AO0yUKVUsNjEdu4IYCY13IVncYvXpz0CNBfm0SNW6pPcnlCRwze712yy
        eToRDD8qMXoHNs3RPdsKgpOL/uBv/Ku2
X-Google-Smtp-Source: AK7set+ODXNARgX9D6pi5xqfai89uMIZfQY62hBezj+LIOPmnNEWOBHm2uXgyNid4m3LOd11OtLnPqn+jS1c
X-Received: from jiangzp-glinux-dev.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:4c52])
 (user=jiangzp job=sendgmr) by 2002:a62:82ce:0:b0:5af:db19:b1c with SMTP id
 w197-20020a6282ce000000b005afdb190b1cmr3505514pfd.2.1677268395963; Fri, 24
 Feb 2023 11:53:15 -0800 (PST)
Date:   Fri, 24 Feb 2023 11:53:12 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230224195313.1877313-1-jiangzp@google.com>
Subject: [kernel PATCH v2 0/1] Clear workqueue to avoid use-after-free
From:   Zhengping Jiang <jiangzp@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     mmandlik@google.com, chromeos-bluetooth-upstreaming@chromium.org,
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


After the hci_sync rework, cmd_sync_work was cleared when calling
hci_unregister_dev, but not when powering off the adapter.
Use-after-free errors happen when a work is still scheduled
when cmd is freed by __mgmt_power_off.

Changes in v2:
- Add function to clear the queue without stop the timer

Changes in v1:
- Clear cmd_sync_work queue before clearing the mgmt cmd list

Zhengping Jiang (1):
  Bluetooth: hci_sync: clear workqueue before clear mgmt cmd

 net/bluetooth/hci_sync.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

-- 
2.39.2.722.g9855ee24e9-goog

