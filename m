Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787D4645C21
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiLGOMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:12:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiLGOMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:12:44 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A6EE9D
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 06:12:40 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id b17-20020a25b851000000b006e32b877068so19260850ybm.16
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 06:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QBus2kVuCVtfR/Ds/j2TUk7lQmvmOJGwyNAUAM+O4a4=;
        b=kUg/dXumZHxz+4a1O9n3obhPbXABXx0cL2A3c6DqHsnkopp0ANdOtHZ/to0NJhijy6
         fCgVWEsdrhsx8XUhr5V5VLvc2QjpbzKRqScmKXr0M7r1IjAVk2YFqEm/w8dwpJcQ+yPI
         YVHWYm8udbKaVs+85dY9AquKum3bsgBHVjmnfUIoZQnr/XpQr0AtrWVwus+wk7ZNM0L0
         qxU96mY98OTeWtteIymVsBieYp8cHgzDK3IvO3sbcnJvTIC72c1bNxoMAUrR3nRoF2pk
         KhyMv4s0KbrVmLF1pSsCIGTUZFIgmuwusq1GFx+JKjsLgarFIQU9UMp1lfxfkHVA0upw
         wFrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QBus2kVuCVtfR/Ds/j2TUk7lQmvmOJGwyNAUAM+O4a4=;
        b=Wing0bVBmvXgli2e3kVxnCwzcfHVNmlwyb8YvBqqkpHRQCkbwmCCc8UFHDFYIq0R5D
         BIXu/2YIWuw3eFPuVFpR2F2ehWGGs/1By0eUG0BRuHcZxX9ef6CSru8+1iQ1YlhAhxw+
         fO2Nr7xUloKPfXL9sowQycWc8V7SuymqppiAvGS1TMd18y06/yyEnhygeSHUl8uSNM50
         bgmyEYFigqI1BLAtZs0QCZUeHJVAnpgGEudUGThO9GRSkd14TCXC64+nwsH43K65a/0N
         SFnO9nXh838PHX7bQXQTBqgzZIwvHyChHPThR+8oSzzPCy4FItK/g9WHi7h33m8J30Gh
         m5lQ==
X-Gm-Message-State: ANoB5pmU1+yUu3dPcHxIg/UwCn9aXhKsqKCQr9IKwrN8Ho/hsxVzCfEX
        sEKCMq4qNi6yXTEEc2/Hui3dPDn+e/9+nA==
X-Google-Smtp-Source: AA0mqf7oqU8Lq+/6Z3xelV/4xZTi1ocsXboBcJw2ZcOrqQ+IpTfntACX0di+6AimdUmcsHYOhRCt9hPTqzKA4w==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a0d:d40e:0:b0:367:23bc:6087 with SMTP id
 w14-20020a0dd40e000000b0036723bc6087mr22111784ywd.428.1670422359855; Wed, 07
 Dec 2022 06:12:39 -0800 (PST)
Date:   Wed,  7 Dec 2022 14:12:34 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221207141237.2575012-1-edumazet@google.com>
Subject: [PATCH v2 net-next 0/3] mlx4: better BIG-TCP support
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlx4 uses a bounce buffer in TX whenever the tx descriptors
wrap around the right edge of the ring.

Size of this bounce buffer was hard coded and can be
increased if/when needed.

v2: roundup MLX4_TX_BOUNCE_BUFFER_SIZE (Tariq)

Eric Dumazet (3):
  net/mlx4: rename two constants
  net/mlx4: MLX4_TX_BOUNCE_BUFFER_SIZE depends on MAX_SKB_FRAGS
  net/mlx4: small optimization in mlx4_en_xmit()

 drivers/net/ethernet/mellanox/mlx4/en_tx.c   | 18 ++++++++++--------
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h | 18 +++++++++++++-----
 2 files changed, 23 insertions(+), 13 deletions(-)

-- 
2.39.0.rc0.267.gcb52ba06e7-goog

