Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42CE74D3CC5
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 23:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234505AbiCIWTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 17:19:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238575AbiCIWTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 17:19:44 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7467D11943B
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 14:18:44 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id w27so6262806lfa.5
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 14:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BWHcqmg8Jl/pDjYFxNFIoMx9za7BtcKb+LqL6quSfGc=;
        b=JBSeZQVR2uJx6lhn0r/r5EYbLrVfz00Zsw3BXJynWJrUWxBjyZLMQRRqUzwINB6Asl
         IhP8O5f3AGqqa+4bVe3ZJRj4DkJriEYCPudUq4j5tF7ZnRXpA28Jio1P65LhtHRzISKp
         eUqgCoBPcZ3vxbqqZWdY88AkKNxFYF/4E1mLQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BWHcqmg8Jl/pDjYFxNFIoMx9za7BtcKb+LqL6quSfGc=;
        b=XFWHTPvTyS4xE05MPAHhBkQhr8h2UWc2x8K3IU0NXLvUqgSSgzSnkoskBV8SH70na4
         XD59W3u+isIgaFj4mXTPxpPLlA8EDvuMb1AjK9EkzZQj3nSMVaoRrkCjsT21jy/6jq84
         77BwyGwXB4A+psnXekLqryUIwn1hoquhBDHviRXxLzb+gpxBMK7PSK69ggVll5xC94fk
         k4XoU/wAGlUYtX5iDntR+jhBvHrHo4b6rSX2NiL0OOA2mZajV5UXKclAByEGxqCVNU4J
         BOKXTylOPE5I6M/q+vQZk20ysQmrYMAotV45fGKErWL2dPRHNTiotz5vSk7YgnYbsvdP
         lh4Q==
X-Gm-Message-State: AOAM530NMxXV3JGCJkG4N85KPgjknEVkxyJt75DzL/QSPFqs9hi6rLkw
        GIP4+fRYRTLVOrABzpBpGyfBhpKErbE0BLrOpRc=
X-Google-Smtp-Source: ABdhPJyzDYIHryASbL6YRKrbz2Xgoc5ixCqYvTRxvRC09d0bGbpCpi/dKLLkSeDRP3dtdWL+nQFknQ==
X-Received: by 2002:a05:6512:128e:b0:448:4aee:c5f0 with SMTP id u14-20020a056512128e00b004484aeec5f0mr1079251lfs.403.1646864322602;
        Wed, 09 Mar 2022 14:18:42 -0800 (PST)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id b13-20020a056512304d00b0044839225289sm610913lfb.218.2022.03.09.14.18.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 14:18:40 -0800 (PST)
Received: by mail-lf1-f44.google.com with SMTP id w12so6226983lfr.9
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 14:18:39 -0800 (PST)
X-Received: by 2002:a05:6512:e8a:b0:443:7b8c:579a with SMTP id
 bi10-20020a0565120e8a00b004437b8c579amr1080661lfb.687.1646864319396; Wed, 09
 Mar 2022 14:18:39 -0800 (PST)
MIME-Version: 1.0
References: <20211217165552.746-1-manishc@marvell.com> <ea05bcab-fe72-4bc2-3337-460888b2c44e@molgen.mpg.de>
 <BY3PR18MB46129282EBA1F699583134A4AB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
 <e884cf16-3f98-e9a7-ce96-9028592246cc@molgen.mpg.de> <BY3PR18MB4612BC158A048053BAC7A30EAB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
 <CAHk-=wjN22EeVLviARu=amf1+422U2iswCC6cz7cN8h+S9=-Jg@mail.gmail.com> <BY3PR18MB4612C2FFE05879E30BAD91D7AB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
In-Reply-To: <BY3PR18MB4612C2FFE05879E30BAD91D7AB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 9 Mar 2022 14:18:23 -0800
X-Gmail-Original-Message-ID: <CAHk-=whXCf43ieh79fujcF=u3Ow1byRvWp+Lt5+v3vumA+V0yA@mail.gmail.com>
Message-ID: <CAHk-=whXCf43ieh79fujcF=u3Ow1byRvWp+Lt5+v3vumA+V0yA@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH v2 net-next 1/2] bnx2x: Utilize firmware 7.13.21.0
To:     Manish Chopra <manishc@marvell.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "it+netdev@molgen.mpg.de" <it+netdev@molgen.mpg.de>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 9, 2022 at 11:46 AM Manish Chopra <manishc@marvell.com> wrote:
>
> This has not changed anything functionally from driver/device perspective, FW is still being loaded only when device is opened.
> bnx2x_init_firmware() [I guess, perhaps the name is misleading] just request_firmware() to prepare the metadata to be used when device will be opened.

So how do you explain the report by Paul Menzel that things used to
work and no longer work now?

You can't do request_firmware() early. When you actually then push the
firmware to the device is immaterial - but request_firmware() has to
be done after the system is up and running.

                 Linus
