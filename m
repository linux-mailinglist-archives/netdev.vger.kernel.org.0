Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB79534AD7
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 09:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240404AbiEZHfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 03:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbiEZHfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 03:35:22 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD51295494
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 00:35:21 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id i11so1550383ybq.9
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 00:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Oy8O9h93aEgh9vXu5a8+DJlsCKCBazqjwSFkJ3Ykx0A=;
        b=QTtEF5oSuMUHpjj2/U1ksB6+t1v/FSd60WF9fs1UH+wQ0IKksboPUceBH+rM8K3kM/
         dJrKtCOedsME9lQ4ru6i7YpCsbUHpTYVUHHj4/zSEwj/MiG7yJynrSCglciXIoETjnZ0
         ORpZUpoCa/5wDBBqjIhHYzYuqSNCL/ruzSdfprRr0v4BkodYbsyTXW2EHgoMlxy24RvA
         qrkC6CXaiICPaHQT2NDj5ZLJD3EKNbTnkLCe3kBBQBfYLWRUkhHr9Pk2Fzv/5z1seOBE
         beuLbmBaKMuITRdNo1MulF7nGZrfwdvxG9dBcM7QJ0AU3PJzKjxsjsJU/aO3fVKNpI0x
         ECSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Oy8O9h93aEgh9vXu5a8+DJlsCKCBazqjwSFkJ3Ykx0A=;
        b=1w5GaUWtj1bcv2GwHOU4n4frOnzmdZxJVZmg72uGFLZwCckuqSTOuzN5LbAc4aOw3M
         pwXZCzEuOdK0ddiPouGAyaxwTib2epl9Jo6Rz6JfQ2CPPjtAuMYCUtOWTrqzNxcdCzgg
         C45cz4GHtPQ5vjhGj6nQp21zjO/lIw93g5pfiCXlfDLK18RJvVxKsy693OtadB9DKnpM
         /gHO/kx0VE8snZi3LBrluqQ6Qd3tmefXHqtBMTE1UQ3q8RXeXfSxi/srtSzoFZxoGW+i
         1tC3ML0BvpzM5Gym/xfNWLTIvQkNpvNkt8Tx1U2Ln2lWlufTmXm7x6QVANmfp2ddwnpG
         cL/A==
X-Gm-Message-State: AOAM530awzFfjljlvbGIQ7y9cntS3X7XxaFTSAjo4SDbJgTai7rqptpf
        dDH6ZlnPpHp/F4Wre+6i1bOb1hJXc3p49sHCF2cFaZDbe+u0I4Ns
X-Google-Smtp-Source: ABdhPJxehA8aoKXoz7VmAWp5V3tSjXQPx/JgOuHAa4ppJjXHMrih2f21Iyy2lv3E3+oMZ2IOHwM+Mb2D1ax/vizW6iM=
X-Received: by 2002:a25:d313:0:b0:64f:6597:259a with SMTP id
 e19-20020a25d313000000b0064f6597259amr26560344ybf.228.1653550521026; Thu, 26
 May 2022 00:35:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220525204628.297931-1-eyal.birger@gmail.com> <df95ef08-4b8f-1b23-9a8e-ae9ad0538a9d@kernel.org>
In-Reply-To: <df95ef08-4b8f-1b23-9a8e-ae9ad0538a9d@kernel.org>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Thu, 26 May 2022 10:35:09 +0300
Message-ID: <CAHsH6Gs1V3kD7SytSkUA+sjMCfkOB1OMQ_xNQse8+PJg6b_ASQ@mail.gmail.com>
Subject: Re: [PATCH net] vrf: fix vrf driver unloading
To:     David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 12:12 AM David Ahern <dsahern@kernel.org> wrote:
>
> On 5/25/22 2:46 PM, Eyal Birger wrote:
> > The commit referenced in the "Fixes" tag has removed the vrf driver
> > cleanup function leading to a "Device or resource busy" error when
> > trying to rmmod vrf.
> >
> > Fix by re-introducing the cleanup function with the relevant changes.
> >
> > Fixes: 9ab179d83b4e ("net: vrf: Fix dst reference counting")
> > Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> >
> > ----
> >
> > Note: the commit message in 9ab179d83b4e did not document it
> > and it is not apparent to me why the ability to rmmod the driver is
> > linked to that change, but maybe there's some hidden reason.
>
> dst output handler references VRF functions. You can not remove the
> module until all dst references have been dropped. Since there is no way
> to know and the rmmod command can not just hang waiting for dst entries
> to be dropped the module can not be unloaded. The same is true for IPv6
> as module; it can not be removed and I believe for the same reason.
>
I thought it was related to such cleanup, but couldn't see why the device
unregistration wouldn't void the dsts.

Probably better be safe than sorry :)

Thanks for the clarification.
Eyal.
