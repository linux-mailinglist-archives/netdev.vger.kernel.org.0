Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 936EC65316B
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 14:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiLUNL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 08:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234438AbiLUNLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 08:11:43 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA71A1A045
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 05:11:35 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id d10so1692123pgm.13
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 05:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QSNOsGN2qb70CCKMWtOU8vZy1lX7BQUW0taanK2NRTg=;
        b=m3JQPJw1F5Dfhve6kFgqnqsgLdsP35eNp3g/WyNqic5L3Ehc0tPR5pJ52OTXtO5re3
         gXQdmc5yEmwmXxzfU8sWLJ5oDUyrRTNoZKIaGEVbkuGNcPXE/PPvdHcES6Z4V97y52Ar
         hprPjIRiINLpE/GoEY4Wxeru3TVci3nciSimqO2QIVntobgU9cyNUiFhKCP5BYC2d8h7
         QthjdWga2g3fs8s+4VpMwktDIDrNGW4IUAspwTkazR7n/4d3M2+kql8ow/U0xsm5uy4b
         f8b7UVBwH/Ogjrpgmm1VCm5xB4UQJo738dEvHhr8HVW2lFJjFitAKILSb09HWNLKednt
         qFrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QSNOsGN2qb70CCKMWtOU8vZy1lX7BQUW0taanK2NRTg=;
        b=j65vHwi3DwowlWcBD8/XsoxEvd2LN0VMCoixY33etZy1YNxDc3CbTUpX4Oa5jV8G5S
         nLU/aDRef7ZDQcjgJm4o+dh9lJkrXr46eSqgU0cTFCmbMYaBav4Egmr+KkPPAluQ6Y42
         EsvPC61kqEmh7wp55sUieWZZPe10bYgtYf/rt1+f/OcZkpzqMZ1ZhefUZqMvKRW78bST
         DRIFF7ee8+KJoVGRlJpX5B025mGV7aQpvXtVzq6dJkus4Y9P0Mce3qb4JkyXkmZgrTao
         Kum95rDiZARcYDCOh0UicilFYVXZm42tUVdqHMPIpIiWGxeZsBkNvo/hS3s3wdFd4GzC
         bj6g==
X-Gm-Message-State: AFqh2krMtQneKCXh3jNQyE9BnfAgszWwnwTEIZI7eJKVcd0Xr12eTK0/
        yZd3LbQldSYjBI0kP5rDkA6U+FnSDIFDLAtgpMUdKw==
X-Google-Smtp-Source: AMrXdXvjvGzRnkeU1lpripARhNqzfJQlNaaaHci6GDm4B86DMWRyQnDoAVFlRpGvKsp1ypQs07LR3wDADnmG7hYgZDM=
X-Received: by 2002:aa7:9811:0:b0:572:5c03:f7ad with SMTP id
 e17-20020aa79811000000b005725c03f7admr123710pfl.17.1671628295408; Wed, 21 Dec
 2022 05:11:35 -0800 (PST)
MIME-Version: 1.0
References: <20221221120618.652074-1-alvaro.karsz@solid-run.com>
 <20221221073256-mutt-send-email-mst@kernel.org> <CAJs=3_CVUydOpH=a-RJLWUQ0_1EbkwKtGD2F3Xvw=dR5QFXP5g@mail.gmail.com>
 <20221221075855-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221221075855-mutt-send-email-mst@kernel.org>
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
Date:   Wed, 21 Dec 2022 15:10:58 +0200
Message-ID: <CAJs=3_AdY5y58rgfE43eEwO_K+=cbaZooAiDnHx8rAy3+tjxoA@mail.gmail.com>
Subject: Re: [PATCH] virtio_net: send notification coalescing command only if
 value changed
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> We'll always just do 2 commands, right?

This is my point, we are sending 2 commands at the moment, even though
one of them may be unnecessary.

> E.g. if a card lost the config resending it might help fix things.

How can it lose the config?
We can  say the same about every command sent through the control vq.

> I don't think we should bother at this point.

Ok, I'll drop it.


Alvaro
