Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4B3671BF3
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 13:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjARMXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 07:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjARMWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 07:22:31 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB70D5A812
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 03:43:43 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-4c24993965eso456971127b3.12
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 03:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HBeC917hyxhJkLItckuHGUlIZdx8buVEDMCa+icWbmA=;
        b=KIKa1SEpLAKZ7QiWVDmJTOhIrXlZz4ZwklkIMEN9UrWNaHVU2PiyO3o7ZCwS0egUrq
         06IwlcCawMG+Abc6umQVtWen6SDIawFqvYzK1bDRH3wN8mVu1B/RgkSe3aCf5Ms8eZrN
         Tl4cN8hNRz/AGJG1dpo90qZBX5yWB3N+pA2pRpbBJybUBbb062mm6HXPNtrrtOXX+v+y
         ftDmPjplCdOPTF0Zo6EkvhEbnU6AqIz22lww+EdvevTpH+SfI04RHtPELkC/Ws9EBqae
         UNjMibNTciNdwBRVPa1csIfPW9bbZ4plCliCZ5pXQhFp/Esf//wKLq5Ng2NGmIdgFLpO
         ypVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HBeC917hyxhJkLItckuHGUlIZdx8buVEDMCa+icWbmA=;
        b=qwslrkJMyUIiCxsGwUlJM9Kw4POYLUAt8J1lFRiXp/A/+keMBvAzYCAicWEzcUYYsp
         yad/ED3+NV5dDz3UI3g2Yq8L95jpUvAnRL5y+Hu1bB2wZ+Z2cMlvQS4GdRcbH1i2Dpaq
         IvoxXI4J3/QzM8f4zsDAORsAYlgik9vT4uVxhpnMCYwbfKJwCoG7acvnKdsNw7+LQz/2
         wbq22cWtbOA4klAE1n4u1zNi/AKJCBHqgEX9OZHXNPNj0zeL/PYF75OcYQfHEJfgjoFj
         hdJVdItiaNKk1AaajYAz78/zTrqpcF4NHNwd5/7YbcQcaSHpzBgoHTqOfi/IV7QiJusm
         BzIQ==
X-Gm-Message-State: AFqh2krbh1bpN4ggQiZEzV2GxZA9toO7myXSrYf1NzJ+uKJsrAnn8vR4
        6Kdq04+9b76+LZziVkkc7UCFB/GWnm99//fEDEYURg==
X-Google-Smtp-Source: AMrXdXs0X0KBiSICtMIafqp0H77dnNrOlyP3WQbqBuzsPIt7hG/bULORVutYHQh4l/2pfYJzmAxIfvi1sOVQXmtLjuM=
X-Received: by 2002:a81:351:0:b0:36c:aaa6:e571 with SMTP id
 78-20020a810351000000b0036caaa6e571mr589296ywd.467.1674042222653; Wed, 18 Jan
 2023 03:43:42 -0800 (PST)
MIME-Version: 1.0
References: <20230113164849.4004848-1-edumazet@google.com> <871qny9f4l.fsf@intel.com>
In-Reply-To: <871qny9f4l.fsf@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 18 Jan 2023 12:43:31 +0100
Message-ID: <CANn89i+iHh3Bvnn100D4YUvRLFyq7SnsOHRJWtKVr8299QmREQ@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: sch_taprio: fix possible use-after-free
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>,
        Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 14, 2023 at 12:41 AM Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> Hi,
>
>
> From the commit message, I got the impression that only the one
> qdisc_synchronize() in taprio_destroy() would be needed.
>

Hmm, I think you are right, qdisc_reset() is probably called while
qdisc lock is held,
with BH disabled.

So calling msleep() from qdisc_reset() is a no go.

I will send a patch removing the change in taprio_reset(), thanks.
