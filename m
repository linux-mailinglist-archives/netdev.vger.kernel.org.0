Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766E9571242
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 08:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiGLGa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 02:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiGLGaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 02:30:25 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1049EDE9C
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 23:30:25 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id bf13so6694119pgb.11
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 23:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y1gx0G8+fwpBv8Z6JzVW5MSAfRwOBb7OhXfOCHNmGVA=;
        b=zrjTDCZEURoYVYu5YRvryD13ADFZs/yRHLvjrkfHy04i4VTDnOuJ5wqoWlQjPts8oL
         K6JgGaDtLTT5V0Jaqgrh+58AP32Y/a26wkaoVs4/wo3kjLvMoNqjYZOeSAQ7fAiKkVzv
         keqr0g9te6oypRlPig0AGzQZS24ZfhlqNTA98RMyIM8jYMBtVsv3gbh/GYAgVvIk4QCo
         xdPgcEgpQ9cxoTiPFZ7yGuFSOB1Barua+1eg30zu1aHxUawCZNxDn166FhPlREVvAW1N
         i26sWb+kD1Q9lkj/ff+cFbj0geA6IcDwLRbdZet3g2l/91omNLnWQhwIqRaPw6uUEPP2
         lUVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y1gx0G8+fwpBv8Z6JzVW5MSAfRwOBb7OhXfOCHNmGVA=;
        b=3d0A2cP9Lr+of9itLoze8s8OWgRMaAMh2bjyo7ZnPKjZPS8MvQKZL2xCliw+kZf/vc
         sMjOuphkmz3spDieXGxdhbiPeUrfB5ENrUWYhjUrYkp46XtOQgFXxU7OI8c/4sgYpEN3
         Nrn1CbLa4R+j2Aw+qVyUs4gb2oLWqAmCdnqkOurzZyzjz2VO/ycEpoFGKyzdwmOzJLfP
         16FyHdw8p2o6XSZB0BrE1d1OsST+hSEmB2iNwdRjFNpsSwRiK3GMBZ5N2ygJfbz1cQCJ
         IlvSfclDu3GSKf6c4keejufGoTCaKv/yrbfetroHly9k4CnITlsBvzHSbJ8H2QyfK1vB
         lBGg==
X-Gm-Message-State: AJIora8S6mnp/BVGDqVXiDKPk+0i9gQRTNL6I7QCW/GT+j7A7Ukth5BL
        hKrgUWYVFV7l8/zvJoDg4qT6fCNxTG4HHijhoI3exQ==
X-Google-Smtp-Source: AGRyM1tqx5D6lU/noxZ0+BPio8e158qdAMrsQyy31jNXyqA65dwh1b2LgOzCUQNnUPn1fkWAvLBSMfYTY6VJht8CuR4=
X-Received: by 2002:a05:6a00:1da9:b0:52a:c339:c520 with SMTP id
 z41-20020a056a001da900b0052ac339c520mr13028005pfw.70.1657607424533; Mon, 11
 Jul 2022 23:30:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220711112832.2634312-1-alvaro.karsz@solid-run.com> <20220711203659.012a79b8@kernel.org>
In-Reply-To: <20220711203659.012a79b8@kernel.org>
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
Date:   Tue, 12 Jul 2022 09:29:48 +0300
Message-ID: <CAJs=3_BMz2DN6L=emd6C5nJux1ZAKXT0VYD+vRmLZ-2rM1Kj6A@mail.gmail.com>
Subject: Re: [PATCH] net: virtio_net: notifications coalescing support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Try building with sparse

Ok, Thanks.
I will wait a few more hours for more comments and create a new version.
