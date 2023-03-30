Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24EC6CF980
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 05:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjC3DQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 23:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjC3DQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 23:16:05 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E81525E
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 20:15:59 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id d22so6721240iow.12
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 20:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680146158;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bmo8fcMb411BgRi5TnlAHknPq0J8vGIg5HACLiFwYTg=;
        b=Zeyk3kHVPVGcXubaEB29l0XGNqgrav1H5wTH1CyxnkGmPSI5V9+PhPkXvMeqUqJvnh
         2Hq+jvDElNrKY4bFcxpltpDHSyhxHZIn3z5ozf+sbrX8MkwL+Tbf8XwU4L9vG+y2Tscx
         pO7ha8VzOL7ZFU86/tMMEHOHz20cqbcbYVQQIukDldX0UJMUqyrqOURoaQvr0TClrZ6Z
         opEMzqqUp20JGD2ITRTIt1QGjvKjzsSo28g5myMsR6xTOJlDNrviw/4UtIZnrfLSYCTU
         BkmQ+jG9neeeU/u93/yVAUM24w5aDPGyjhaSNgdpQMhTL0F82HhNNI7CrDyp0Cron9oC
         WRNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680146158;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bmo8fcMb411BgRi5TnlAHknPq0J8vGIg5HACLiFwYTg=;
        b=EKQ1Sm2cN/WcPMbubLnB+g5BoORXHbXln9wn/pMiXaAxWeqgQPsJaSIZqEFAm0swPU
         AgZ3KmtnVvyo12Hnnm+c0z1Tkni5DkL65SGHcbd/ymxoZnZZEU3Il5f88hTPTYg71QvH
         V2KQQnp0nrthcVu4Auvisd97rwuT+mlOi6ixgz69iwxma51dGiZQd2qK2yhodDQeVTqK
         RiSLxJbKRbxK37jWztn/y9R+vYT7J0IFJ3hT3r1WVqWQyhAUomWik6T/STk5SfWM+169
         JKakioL/sD1H5S+nMesC0BkY2783EOMUVtAalqF65fOyMWFZPBirkhABU9YaWVcHEYRa
         lalQ==
X-Gm-Message-State: AO0yUKXNaB4i6iEO9eOx4AqGHHxgkYAlOUwfhNF/OLPBZhlDbxKMRi2v
        51SGorfJCU5mJlf3muxcKzKwmr8z9OjLeaDHbIyowQ==
X-Google-Smtp-Source: AK7set+VQIRqUr1hlf0GeYesFUh+0uInQzWLVeRCO0uBXv/CkH+n6F4e+XV5k7WccxRPQogW++q0ugTwEu67mrqZj08=
X-Received: by 2002:a05:6638:1114:b0:3fc:e1f5:961a with SMTP id
 n20-20020a056638111400b003fce1f5961amr8499485jal.2.1680146158323; Wed, 29 Mar
 2023 20:15:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230328235021.1048163-1-edumazet@google.com> <20230329200403.095be0f7@kernel.org>
In-Reply-To: <20230329200403.095be0f7@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 30 Mar 2023 05:15:46 +0200
Message-ID: <CANn89iKtD8xiedfvDEWOPQAPeqwDM0HxWqMYgk7C9Ar_gTcGOA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] net: rps/rfs improvements
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Xing <kernelxing@tencent.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
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

On Thu, Mar 30, 2023 at 5:04=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Tue, 28 Mar 2023 23:50:17 +0000 Eric Dumazet wrote:
> > Overall, in an intensive RPC workload, with 32 TX/RX queues with RFS
> > I was able to observe a ~10% reduction of NET_RX_SOFTIRQ
> > invocations.
>
> small clarification on the testing:
>
> invocations =3D=3D calls to net_rx_action()
> or
> invocations =3D=3D calls to __raise_softirq_irqoff(NET_RX_SOFTIRQ)

This was from "grep NET_RX /proc/softirqs" (more exactly a tool
parsing /proc/softirqs)

So it should match the number of calls to net_rx_action(), but I can
double check if you want.

(I had a simple hack to enable/disable the optimizations with a hijacked sy=
sctl)

Turn on/off them with

echo 1001 /proc/sys/net/core/netdev_max_backlog
<gather stats>
echo 1000 >/proc/sys/net/core/netdev_max_backlog
<gather stats>

diff --git a/net/core/dev.c b/net/core/dev.c
index 0c4b21291348d4558f036fb05842dab023f65dc3..f8c6fde6100c8e4812037bd070e=
11733409bd0a0
100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6653,7 +6653,7 @@ static __latent_entropy void
net_rx_action(struct softirq_action *h)
        LIST_HEAD(repoll);

 start:
-       sd->in_net_rx_action =3D true;
+       sd->in_net_rx_action =3D (netdev_max_backlog & 1);
        local_irq_disable();
        list_splice_init(&sd->poll_list, &list);
        local_irq_enable();
