Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768A6643CC8
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 06:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbiLFFvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 00:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiLFFvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 00:51:08 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A886140FB
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 21:51:02 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-348608c1cd3so146124537b3.10
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 21:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NyW/rfXh4P/Tt56l6uyrhBuVWm09IWknOXBRq1BZU+o=;
        b=DP+nQhVosCb6MDAGvsvixZYlxfGKDzoRaBNkfcgm1FmP2EzcB0n1HCkSwTcIqsAwXs
         hZrA5Jy8Jl+Uk8RZcui7AMlfEHhWz6C1BGvkSWThGb5HG3U0s0GCA5dtNP2dJSQCdweC
         EZJDxBQvDjidf4Ua3SGRtu3xSgyosnBerIWem72zaW4HF6rJx0hh7xDCEHzW+j1ii5Jl
         W3WemoCXhW3qUDipjmhWKZt/fszl0SG9Ko5G8zKf6mSgEeAyM3YocK9h1iEQLFUg9EeG
         gvXyR+knGUD8mI88YrwAI8U2DkWz6tK7SQhKRr2uCfGJpYgUvuJElSftZoqmScq/bEbK
         4UUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NyW/rfXh4P/Tt56l6uyrhBuVWm09IWknOXBRq1BZU+o=;
        b=4PCvIEHO17Qfjiq0s11BX3xHq8EemGOT/dvQikdyvvczbmtkPgeX4tiLcFMTV8x3kt
         yUoJQBQG5l0CyWLmwAWF+7E7K4KmGsjCy/SKZdjbHx1P12g5z3hScY4WUdc8TWu70CdE
         4yE4877p/9WFwgDDxyVYM5DXu2vfnzSZtNFa4QhbmQ9SWDm1rkISU10o0sC7fQjy9wXB
         GkKGVtXp47R0MP8sCb/RJL0B5FDHCmTltpdu7JPzvj69G1pkN1UIafGKsWpdIttVWYkG
         Zta1AJqHP9CLDg+h8ADTjqQ5cmcCIAWra6l+yMDaOgklbl9EDOsXFVCfGv3Oi0ifknSI
         Edog==
X-Gm-Message-State: ANoB5plB6by2pQ80WdrmTvJcgawoAoHw71JruIWOfdQCQjYewq/PbAbz
        IhYTbzJHMhZ+jJOjq7Tbaaa0+QJjSZo+fQ==
X-Google-Smtp-Source: AA0mqf4JogLlD1aV8bJRMBqqwRhgWzhkoSwGYsrQeFRcps1KgvOcdVzQNpcQUP+TXoSiqlg3EHMBeKvIPpelsQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:285:0:b0:6dd:bd88:fedc with SMTP id
 x5-20020a5b0285000000b006ddbd88fedcmr61895393ybl.540.1670305861703; Mon, 05
 Dec 2022 21:51:01 -0800 (PST)
Date:   Tue,  6 Dec 2022 05:50:56 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221206055059.1877471-1-edumazet@google.com>
Subject: [PATCH net-next 0/3] mlx4: better BIG-TCP support
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>, Wei Wang <weiwan@google.com>,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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

Eric Dumazet (3):
  net/mlx4: rename two constants
  net/mlx4: MLX4_TX_BOUNCE_BUFFER_SIZE depends on MAX_SKB_FRAGS
  net/mlx4: small optimization in mlx4_en_xmit()

 drivers/net/ethernet/mellanox/mlx4/en_tx.c   | 18 ++++++++++--------
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h | 18 +++++++++++++-----
 2 files changed, 23 insertions(+), 13 deletions(-)

-- 
2.39.0.rc0.267.gcb52ba06e7-goog

