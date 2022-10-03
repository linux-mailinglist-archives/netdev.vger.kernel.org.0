Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5BBA5F34B5
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 19:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiJCRnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 13:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiJCRng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 13:43:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DE9165B7
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 10:43:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2CC1B811E4
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 17:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A41C4347C
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 17:43:32 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="fd6fkOzI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1664819009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yYd4/gITPb2ByrEthrf7B8sc++AL9q+Qc+enxsVE/pw=;
        b=fd6fkOzIDvayFBDwJszF/rtiNq56cwyweN14P8TGl8/oGT17VHl+UdJNFILpIR3HB6Wv8W
        /tjoXU9UjOzZmsTK30JLT5vymoVYleN67sd5mWqF38SCrZBilODO2xvq3dMKmaKX/796Fv
        2AKZ0KnfL3HhGA55YvTy4zXZz8Q0G/c=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 869fa192 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 3 Oct 2022 17:43:28 +0000 (UTC)
Received: by mail-vs1-f52.google.com with SMTP id n186so6287016vsc.9
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 10:43:28 -0700 (PDT)
X-Gm-Message-State: ACrzQf058bfWHO+WE6pnCv1ygCdzHggBC0aE2ropwH/Fnuka2A85CdsJ
        587NyUdU8y5v4nTgYQ24Cry4Rr/mmSS6Ve2C9Ng=
X-Google-Smtp-Source: AMsMyM5+sLs+IG2gREAcaydwHU3xLCrdQbaUdCdZdfWLCSvo1/qZsGxvxnQbsxsjw7KGgbR7RtFuCIe1PfME//y/sZ4=
X-Received: by 2002:a05:6102:2908:b0:398:ac40:d352 with SMTP id
 cz8-20020a056102290800b00398ac40d352mr7959811vsb.55.1664819006633; Mon, 03
 Oct 2022 10:43:26 -0700 (PDT)
MIME-Version: 1.0
References: <20221001205102.2319658-1-eric.dumazet@gmail.com>
 <YzjCzGGGE3WUsQr0@zx2c4.com> <20221003102520.75fc51b4@kernel.org>
In-Reply-To: <20221003102520.75fc51b4@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 3 Oct 2022 19:43:15 +0200
X-Gmail-Original-Message-ID: <CAHmME9oh1aFCMBeV-vvtfMoCx4N5r_tABp79tkPNNLJnc1ug7Q@mail.gmail.com>
Message-ID: <CAHmME9oh1aFCMBeV-vvtfMoCx4N5r_tABp79tkPNNLJnc1ug7Q@mail.gmail.com>
Subject: Re: [PATCH net-next] once: add DO_ONCE_SLOW() for sleepable contexts
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Willy Tarreau <w@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 3, 2022 at 7:25 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 2 Oct 2022 00:44:28 +0200 Jason A. Donenfeld wrote:
> > So instead, why not just branch on whether or not we can sleep here, if
> > that can be worked out dynamically?
>
> IDK if we can dynamically work out if _all_ _possible_ callers are
> in a specific context, can we?
>
> > If not, and if you really do need two sets of macros and functions,
> > at least you can call the new one something other than "slow"? Maybe
> > something about being _SLEEPABLE() instead?
>
> +1 for s/SLOW/SLEEPABLE/. I was about to suggest s/SLOW/TASK/.
> But I guess it's already applied..

I'll send a patch to change it in a minute.
