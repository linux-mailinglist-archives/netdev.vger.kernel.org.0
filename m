Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC3151C5B0
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 19:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238942AbiEERJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 13:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241101AbiEERJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 13:09:40 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D322053A50
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 10:05:59 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id j2so8780092ybu.0
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 10:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oe/rYYTasOOuXncIj/zl0V3vg4VfEouNqi33u3n2IKI=;
        b=TipuelamOISErNpm8JLyDoQ/zn08Z1b9ZTFFwb7bN3WU/J6zbkWUKP4wJDgjxWAbyY
         1CG7TmymwGVMSVbXaQTApBrxpPf6B78qZoOgVuKqY2n/u/FTHdUf1lGSp0oofGCTGG/f
         pAGIJFyVZCj7WOv245N3LPBZLy2IZlpQ4Tj4wRxaNyL9MP8A9YGR2Bs6bON5SVWjC5tu
         U5AYM0JgwQcOaO+HV4Tbe+fl5tz7t8H+oeKiXXr3CzFhDkLDXmeZkAXxwPeONO98owtV
         CllCLuEIEpC9h1L4V6H+88OLhl+Tb5fWBaR/HrNMKFzkgZBwK84DUvYkk508BCjWHv/2
         QmfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oe/rYYTasOOuXncIj/zl0V3vg4VfEouNqi33u3n2IKI=;
        b=PvXp2TY8j89BiXtHeIj9QR5Jryom7V0WjVq3jA7njQJoGCCLlKvFqfC2EIghBDwwP6
         aGtJ7evuX8yBl5wocIF/9ox1ryYzGAH4/ertbwCNIHIYoGCLlohRFzGWM9EtdLpWYKKI
         dRsyoW6efg3wshd1ulIvFoZY90fvFb3arVnp4FiKuJp5Csv35OydQief+L56FP4rTUmb
         wRGi24X/HV9vdxsxFS8f8i7cIYi+C3eLTM87AoMKA4OedebX3ihUGAc5bSath+TjfYBM
         /ousfsLr1v4OKKcYQExzit9EK0efmazkoFtSpN5eDKm4yeuE+4fif9JowSkFLtDnJ98p
         2y0g==
X-Gm-Message-State: AOAM533Q+FoVIUpuWhuXQl9pDCmsK6oaT2WHlcItZgUmHuuN/p2PROU1
        eu4748SGUGTy6E3zthA1IvDbWkLHMI0EyzTD3I6otw==
X-Google-Smtp-Source: ABdhPJyZgVi4aw/3LlNbCibRn5C9FGIGejXNgeHLxetBGxIu37SBzNAm8SwQeM8q7xWBYhTic/kX9H5Mq4PDVLkwv2s=
X-Received: by 2002:a05:6902:c9:b0:641:1998:9764 with SMTP id
 i9-20020a05690200c900b0064119989764mr22015949ybs.427.1651770358833; Thu, 05
 May 2022 10:05:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220505161946.2867638-1-eric.dumazet@gmail.com> <20220505095753.614ddf1b@kernel.org>
In-Reply-To: <20220505095753.614ddf1b@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 5 May 2022 10:05:47 -0700
Message-ID: <CANn89iLbjpFbLLBEDwofxb=cpqSX=mvj1BNAxWg0POoEz3rhjw@mail.gmail.com>
Subject: Re: [PATCH net] netlink: do not reset transport header in netlink_recvmsg()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 5, 2022 at 9:57 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu,  5 May 2022 09:19:46 -0700 Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > netlink_recvmsg() does not need to change transport header.
> >
> > If transport header was needed, it should have been reset
> > by the producer (netlink_dump()), not the consumer(s).
>
> Should I insert a reference to commit 99c07327ae11 ("netlink: reset
> network and mac headers in netlink_dump()") when applying to give
> backporters an extra hint?

I thought about that, but CBPF has no business with transport header.

I felt this would confuse things.
