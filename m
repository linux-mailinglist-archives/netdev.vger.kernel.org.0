Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9C9B65F31C
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 18:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbjAERsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 12:48:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235325AbjAERn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 12:43:27 -0500
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132073DBD0
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 09:43:26 -0800 (PST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-4a0d6cb12c5so198792367b3.7
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 09:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Uw3yh4XUgzRdyZp7xqO0OEvpAygRnM1Ze+HbGCZVi6I=;
        b=o2BzubLt1MqtpMQeWBr11Yc5bxYJqJ6nRVt1oVK2rCQ14Sls3Spo0zX2sviRTo9w1X
         1slAggyc9tOyoYWgHW/OTfncJx14lFpRbkJG8Ntq8Jdl85N+bkGBnS9NC3axKP5acVp1
         IPMfzU+BYQk7vKGT2ahLt+3dT/Zjby2BoNmBzvH5xVia+djHUpqpIeGYiziDj956THSH
         VJ2FN7Y1Bu+Q4yDzcx4dgIa2U0OSOfWPhRNJpocHeuxBI02I1ydaDss1cXzXo2UFYJb6
         ZiJWt9DLUIEFAtki9NxRKmW8zPtr4HpLqL6hZQAEvWEbJ6krAPC2yvndQjucD29QznLO
         b8iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uw3yh4XUgzRdyZp7xqO0OEvpAygRnM1Ze+HbGCZVi6I=;
        b=VklWObikjjX+KIb43ccgvcjmR4ZFd9MRWOAARA00bGdQvfezNdQ96hoJ0U+lssDD8V
         H1lbhaGxG2d9z00mtxfwc7PKkijOundZGdiAdsKACAGVmPi8dySf5JPQZZgxnxGLoln9
         5RBmRLGtw89dHFU7bw+RlV/yS52CEF3NxMhgBsT+lExFMTnYZziyOesH9lHccMiqgII0
         0GQu+BB5KH+mn7scT4LI6BjDeWntacu3iKL0slcPqYBIhoEai2z9oqUafW2pmnDMUGAT
         fAyjlAC7ZiIpjoyCzFftkxetgl2z6Yl2d7bYhbTbOLsRUvdYKkD+vvfvRn4GfZcESk2n
         MD0g==
X-Gm-Message-State: AFqh2ko7ldgKaP8C/otTZuvnz2JNkqhXQ8AQ7B6/eHw8qZjpt9d2fPU7
        CAr+q/3WpaqyNPeGX20p4IlPhMQ5uyAN5gCE0PDSVQ==
X-Google-Smtp-Source: AMrXdXuDbPsduFvsnLyXkmFiYWtCA2SLtQYory6OxRAiYbriCC45HQObB8jBxz2eaTQKny1t6BjD7HPNBmeT0FeE7mo=
X-Received: by 2002:a81:1b0a:0:b0:37e:6806:a5f9 with SMTP id
 b10-20020a811b0a000000b0037e6806a5f9mr6085204ywb.47.1672940605111; Thu, 05
 Jan 2023 09:43:25 -0800 (PST)
MIME-Version: 1.0
References: <CAK8fFZ5pzMaw3U1KXgC_OK4shKGsN=HDcR62cfPOuL0umXE1Ww@mail.gmail.com>
In-Reply-To: <CAK8fFZ5pzMaw3U1KXgC_OK4shKGsN=HDcR62cfPOuL0umXE1Ww@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 5 Jan 2023 18:43:13 +0100
Message-ID: <CANn89iJFmfv569Mu7REiP5OBMscuv8EBSGJqi_7c4pxcJymrKw@mail.gmail.com>
Subject: Re: Network performance regression with linux 6.1.y. Issue bisected
 to "5eddb24901ee49eee23c0bfce6af2e83fd5679bd" (gro: add support of (hw)gro
 packets to gro stack)
To:     Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Cc:     netdev@vger.kernel.org, lixiaoyan@google.com, pabeni@redhat.com,
        davem@davemloft.net, Igor Raits <igor.raits@gooddata.com>
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

On Thu, Jan 5, 2023 at 6:37 PM Jaroslav Pulchart
<jaroslav.pulchart@gooddata.com> wrote:
>
> Hello,
>
> I would like to report a 6.1,y regression in a network performance
> observed when using "git clone".
>
> BAD: "git clone" speed with kernel 6.1,y:
>    # git clone git@github.com:..../.....git
>    ...
>    Receiving objects:   8% (47797/571306), 20.69 MiB | 3.27 MiB/s
>
> GOOD: "git clone" speed with kernel 6.0,y:
>    # git clone git@github.com:..../.....git
>    ...
>    Receiving objects:  72% (411341/571306), 181.05 MiB | 60.27 MiB/s
>
> I bisected the issue to a commit
> 5eddb24901ee49eee23c0bfce6af2e83fd5679bd "gro: add support of (hw)gro
> packets to gro stack". Reverting it from 6.1.y branch makes the git
> clone fast like with 6.0.y.
>

Hmm, please provide more information.

NIC used ? (ethtool -i eth0)

ethtool -k eth0  # replace by your netdev name

And packet captures would be nice (with and without the patch)

Thanks.
