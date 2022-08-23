Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDA159CFD5
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 06:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237614AbiHWERF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 00:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiHWERD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 00:17:03 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB3E5D135
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 21:17:01 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id n30-20020a17090a5aa100b001fb0c492d5eso3481831pji.3
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 21:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=RQF+Hp7R78XaNSbP7FojiWh6Ao2+lXh+qmPouBKsoxs=;
        b=hvvCtSMC0Rq+dBBMJ5/nypqanMxOAHvudpyxc+IxZ6lJomJw9YZ+46Td1IjlOeO3sQ
         6jNaU3VtHrGBlpybAUUCHjrZbX//Xl5mS4RV2d40mCyQSKNo4ZucXdF7F8I1g1fvqZdM
         Sqpg4AMErjvRTLy6cINr88zSPKEpf9haHufA8oKfqPNnmE66jyNZt3Hbta+VPSyri8B5
         3plvN2/EuHLtLkTE+mPOETi1Ti3qioAIspnkbs8HD0h8Esn6G+fni3dezZppbtQ8ZtwJ
         UO9UneKitbkHzuBhN/xJxXiQIveSx4GJEPL06MLK9fyI4FVz9ZDtJeCDPiCj2vduLlpt
         3RfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=RQF+Hp7R78XaNSbP7FojiWh6Ao2+lXh+qmPouBKsoxs=;
        b=oawxji5BJgrdvt6EtP8lJ39YFaKt6j3mcF8JNEoeonRsZp4IuS2Vp+GozikmfWgZKx
         haHgxkV3K5qRx4JCWqo0E/AvJSzwl5Hx9XzS566uSS1xH2vnHBlgaYbClCFCPuKpOro4
         GzuKxTOJA5LIHtLOh8/xdOoUMqI5wHM3swhsxY0/hmd3i5HyYYh+TFv5uUoy2it+IS18
         JHP10oZ0zZkAILdCBjrfZJfmVLYTu3yAt94VmEIatXTwK2EKt5TT5MWun7ApTCHZ0r53
         KYSZoo5BwUm+W3TJniL00rUvAYcE8HqADO/LnEOy7wfE3Nm97ijzyIu3VvFvqe88dBUu
         CGKA==
X-Gm-Message-State: ACgBeo08uPxqsl0Uc1ztTbLX99OmqiBxmjYCcxFqqUfgHLlvjBLOZ8/s
        +cQXf/Xs2uAS/TEL/xR6URASoFvKdU20
X-Google-Smtp-Source: AA6agR5GsrlymQnzABGSg82b/1ULRf+EGCNJ+vYGzb2JaeGX2VQvvlFplwzTUlar4K29y9a31LyiQW1sAtAP
X-Received: from jiangzp-glinux-dev.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:4c52])
 (user=jiangzp job=sendgmr) by 2002:a17:90b:354e:b0:1fa:a4a3:bb3a with SMTP id
 lt14-20020a17090b354e00b001faa4a3bb3amr1542937pjb.134.1661228220929; Mon, 22
 Aug 2022 21:17:00 -0700 (PDT)
Date:   Mon, 22 Aug 2022 21:16:55 -0700
Message-Id: <20220823041656.3398118-1-jiangzp@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [kernel PATCH v1 0/1] Bluetooth: hci_sync: hold hdev->lock when
 cleanup hci_conn
From:   Zhengping Jiang <jiangzp@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc:     Zhengping Jiang <jiangzp@google.com>,
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hold hdev->lock for hci_conn_failed. There are possible race conditions
which may cause kernel crash.

Changes in v1:
- Hold hdev->lock for hci_conn_failed

Zhengping Jiang (1):
  Bluetooth: hci_sync: hold hdev->lock when cleanup hci_conn

 net/bluetooth/hci_sync.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

-- 
2.37.1.595.g718a3a8f04-goog

