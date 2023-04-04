Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 760706D5A3E
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 10:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234020AbjDDIDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 04:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233991AbjDDIDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 04:03:36 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BCF129
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 01:03:35 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id l27so31810661wrb.2
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 01:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680595414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uLC0a7DxplgQxhIinAhxaMbouy0O0EScetwGutLULnU=;
        b=C3umL2sL2L6g2WqZKMb0qBoqC/R/7Wc4c9y3uWodvXoc+RVrPC19CYhM2St2UIMx3b
         5p5L6w1mNQZgefefOcHQ9umqINmgluIKQK40iGF7qlayGUn2FYFCGtE8MgN7tM0Nx3+S
         GldxFgDidl6qU2lnBrYEY++kpoDXMX88krsysAVeoiMYVF97fPVfRIXLNDaPdWpiPsRU
         mIwfUDqmrswLWJ9IDgxx5EkbNl55nSViMxcFpKcaeAdZhf6JJBPvXrcNcWvw62OpR5Xz
         FfsOxZ07bJ1AdPogkmQLXBquyahpxXBFwbDW/49vEG7x2UgSFd4L/5plxjYjo88nxWJV
         FJow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680595414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uLC0a7DxplgQxhIinAhxaMbouy0O0EScetwGutLULnU=;
        b=xx2z+RwmHnWS92SEA5EfLwOCL7a/NIWDixfVTas/Kwewi9XK2YNzJKKYAUV5rKUBgI
         3ik3WOhvYIcr4DZCVjy/oc1w+08RlgJ4DiNlSTTOz3FzZLV7C5I2LOivDHt/+0/9xLcG
         +rL+eWoC8O3qvFbZ78AxtDQeW4N4IxUWa3TTsPFs7y/4ArzF1Gwx1CAA/5hnlLLvSi5F
         7qYVtHYQHgsd3LWn+zefFKyyPrdTXhiSmj5H3N/zU+RWH10iio9BO/v8wJ0g7DvplNAi
         JZpsbhLQ415o9D6nNLvdF/24A8dn3hR9AYywXmFVeglakxo4Nec4MPdFm7YSrzKlIRAg
         jgeQ==
X-Gm-Message-State: AAQBX9ddMfffTR68Jxgx1nTpQjtQgrjDt0Q8lWb0BtU8eyu/M2ZEv4PM
        ANWaDj8wn3rmpASsKt0b7PDafQ/4VWW1upjl4X0PPZ57zaQHQMF0+InWb41S
X-Google-Smtp-Source: AKy350YLJ96zdBbRett0klbxo1wfSOXdCaDrjZo6zvSllhNbJZUoNm0XGqSD+c313mEEEKX1C+cxuRZyRP7KjxGQDDA=
X-Received: by 2002:a5d:5649:0:b0:2e4:cbef:9f36 with SMTP id
 j9-20020a5d5649000000b002e4cbef9f36mr278319wrw.12.1680595413631; Tue, 04 Apr
 2023 01:03:33 -0700 (PDT)
MIME-Version: 1.0
References: <ZCvSskSPwFv6kYrD@kernel-bug-kernel-bug>
In-Reply-To: <ZCvSskSPwFv6kYrD@kernel-bug-kernel-bug>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 4 Apr 2023 10:03:21 +0200
Message-ID: <CANn89iLpqh3vZ2qEYhhL12qDgVH1rgSJWqHf42cfX0qQfCvQ_w@mail.gmail.com>
Subject: Re: [PATCH net v2] net: openvswitch: fix race on port output
To:     Felix Huettner <felix.huettner@mail.schwarz>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com, kuba@kernel.org,
        pshelar@ovn.org, davem@davemloft.net, luca.czesla@mail.schwarz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 4, 2023 at 9:33=E2=80=AFAM Felix Huettner
<felix.huettner@mail.schwarz> wrote:
>
> assume the following setup on a single machine:
> 1. An openvswitch instance with one bridge and default flows
> 2. two network namespaces "server" and "client"
> 3. two ovs interfaces "server" and "client" on the bridge
> 4. for each ovs interface a veth pair with a matching name and 32 rx and
>    tx queues
> 5. move the ends of the veth pairs to the respective network namespaces
> 6. assign ip addresses to each of the veth ends in the namespaces (needs
>    to be the same subnet)
> 7. start some http server on the server network namespace
> 8. test if a client in the client namespace can reach the http server
>
> when following the actions below the host has a chance of getting a cpu
> stuck in a infinite loop:
> 1. send a large amount of parallel requests to the http server (around
>    3000 curls should work)
> 2. in parallel delete the network namespace (do not delete interfaces or
>    stop the server, just kill the namespace)
>

> Fixes: 7f8a436eaa2c ("openvswitch: Add conntrack action")
> Co-developed-by: Luca Czesla <luca.czesla@mail.schwarz>
> Signed-off-by: Luca Czesla <luca.czesla@mail.schwarz>
> Signed-off-by: Felix Huettner <felix.huettner@mail.schwarz>
> ---
> v2:
>   - replace BUG_ON with DEBUG_NET_WARN_ON_ONCE
>   - use netif_carrier_ok() instead of checking for NETREG_REGISTERED
> v1: https://lore.kernel.org/netdev/ZCaXfZTwS9MVk8yZ@kernel-bug-kernel-bug=
/
>
>  net/core/dev.c            | 1 +
>  net/openvswitch/actions.c | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 253584777101..37b26017f458 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3199,6 +3199,7 @@ static u16 skb_tx_hash(const struct net_device *dev=
,
>         }
>
>         if (skb_rx_queue_recorded(skb)) {
> +               DEBUG_NET_WARN_ON_ONCE(unlikely(qcount =3D=3D 0));

No need for unlikely(), it is already done in DEBUG_NET_WARN_ON_ONCE()

Thanks.
