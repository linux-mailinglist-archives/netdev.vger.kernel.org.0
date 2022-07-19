Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA485793E8
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 09:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbiGSHNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 03:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233789AbiGSHNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 03:13:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 58EA56176
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 00:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658214799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=clrYHBdx5WoC4+7AQXh+zMF89Sxl9nst0TkhbCWlmBI=;
        b=HQ2/1SXk4qpvWp1V7U1yRSlYSAt997n0Sc83D11p64EknCBNRRdFqjShG3HzKQwJrwyVtn
        FPJwONLzu1WhIlc/Er9yyQkqXzCIrQLIWsFv5yWsSseHLghaY6p1MtISa0Tf6+A3tOaXY0
        eS2eqtqhtpMis4XjoJ46RymEpOwC2tI=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-404-Un2z0jsAMQWDBHCzRDL3rg-1; Tue, 19 Jul 2022 03:13:12 -0400
X-MC-Unique: Un2z0jsAMQWDBHCzRDL3rg-1
Received: by mail-lf1-f71.google.com with SMTP id v4-20020a056512348400b0048a22a5f359so3879204lfr.6
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 00:13:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=clrYHBdx5WoC4+7AQXh+zMF89Sxl9nst0TkhbCWlmBI=;
        b=JEjOEAnQyQT0sZWC4IvtdEmkY1Q+CA3DrVQlIBeh18S6m2QeO8RtE2PGNtFy+9UOGT
         kp2P1VoSYsTxXdPHqkN8AjybyaRYy9IuODC0p2VJp0Oc7oFQJkjrnU1IaQtpDlmnMdOw
         X39wZGZ/lqzQg0i2dB9NtKdX3VVQoEauXP9fp/g1K/V9SwMIaPB2hB64+eZytdMVEV78
         Zv2n7aRDPCIbK3AKA8Ixa22ySEehvvveqpNcsb16vC5n/Ws8wgU1SFYpA5XqLfgBRo0c
         MORjf6bwM7Xn+QuCmOztO7qwmUyXpCvmvQMXDayBCr8A1qE/JcAKhe6g2aL5m58jK5Kg
         e6sw==
X-Gm-Message-State: AJIora/+e7sVyRSCxAb1KaE+uRIk8PFTM9/gVN/tZj43lK2LUxZkFmpZ
        6zoQSVfya/jgol2RAiAOr/Q1fPS4MKQY7cwCVhkju3bmmmwTWFa2SMYtZ8mDPW9jnsh5ljYqMfA
        YJ6NnN2419tbMVAeEguIJKfpvW0jzUbau
X-Received: by 2002:a05:6512:3d8a:b0:489:c93c:5970 with SMTP id k10-20020a0565123d8a00b00489c93c5970mr16975473lfv.575.1658214790290;
        Tue, 19 Jul 2022 00:13:10 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vJHmBrU96HNnt4pnJcTTlysdWS/ou9zIv8LFySL6Qk7YNI/KNlgsS7w90C0qUBKBj9iVCFxB1VAWfr8akQ/lA=
X-Received: by 2002:a05:6512:3d8a:b0:489:c93c:5970 with SMTP id
 k10-20020a0565123d8a00b00489c93c5970mr16975462lfv.575.1658214790098; Tue, 19
 Jul 2022 00:13:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220718091102.498774-1-alvaro.karsz@solid-run.com>
 <d6423ae9-aa8b-7213-17c9-6027e9096143@redhat.com> <CAJs=3_CQmOYsz5N0=tX-BKyAuiFge3pfzx9aR46hMzkcP7E4MQ@mail.gmail.com>
In-Reply-To: <CAJs=3_CQmOYsz5N0=tX-BKyAuiFge3pfzx9aR46hMzkcP7E4MQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 19 Jul 2022 15:12:58 +0800
Message-ID: <CACGkMEt-37P-Qc7_1hnEN91LRuP4-uQTMwk7E0kGp64MjsqUUg@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: virtio_net: notifications coalescing support
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 3:09 PM Alvaro Karsz <alvaro.karsz@solid-run.com> wrote:
>
> Hi Jason,
>
> > This seems an independent fix? I wonder what if we just leave it as before.
>
>
> Before this patch, only ETHTOOL_COALESCE_MAX_FRAMES was supported, now
> we support ETHTOOL_COALESCE_USECS as well.
>
> ETHTOOL_COALESCE_USECS is meaningless if VIRTIO_NET_F_NOTF_COAL
> feature is not negotiated, so I added the mentioned part.

Yes but this "issue" exists before VIRTIO_NET_F_NOTF_COAL. It might be
better to have an independent patch to fix.

Thanks

>

