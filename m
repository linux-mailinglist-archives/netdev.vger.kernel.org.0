Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7865D4C6E27
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 14:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235980AbiB1N2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 08:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236032AbiB1N2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 08:28:39 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C286B30F6F;
        Mon, 28 Feb 2022 05:28:00 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id q11so10707506pln.11;
        Mon, 28 Feb 2022 05:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=y1lfQkaMWFdWKl8tBqnI/TXOCG2pTT27XRwhXLuxq6k=;
        b=AOGl3kXEr5wLLSx++P32sRbRmd3mcW6LtIDUENN/eveEgyrfi/v5AelyysX4lbBn5N
         WPhdFkslH5lJwIm16GPhYrhymCV8ajEeo877j8SKQ5DcBwAdKpbYxpHSEY65/jcMRuCp
         ATK18qik38Iggpo6jeWvvzcx9+lXn4QYumRL5i0UogAlQp2D7ug9ADScxFvF3fObdubG
         7ZmlHVakD/Gi/PiBMuP6cnnV9PmSf71VwM2FGLVidjnCwhKXMq5v4XF5N1Vvv4G5BLVF
         XBBZIJKasLp4askqQVDn+VAy17phnSJqY92JYiG8ZthysCfkWRbcyL1hOFxJNCUDWKHw
         gH6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=y1lfQkaMWFdWKl8tBqnI/TXOCG2pTT27XRwhXLuxq6k=;
        b=AYoaeaoDmZA0Pb9o5Nbuaf7fKRrhIyJjdnPm5niMmKm0VJ4SjBSHlwRuTkoFk3OVDu
         mh8Yp4X76+LGN+dxxRrPJ++ajyI5OtPR6ZFk7alu8W8SZb1DZfI2Ylhl2zF3tOwoM4CI
         y1rzNOiQlmhz1x7s3lDPQiaNoBNyVOVk8wRB8KEluo+Ofae/sMx5PjMImPofgizRAkdQ
         l3SNce6N7Ww0sF2lnrjwoxUuWwK0J6D1LcebBoVn36fl1rJrm5simcCntKdMq2xZrW9/
         3gwe7GozpSC0VO/4RjAndkUDriEfX1RUI2etoNhP6YRJu5rNZfhnhWdQhzch+Gt6LvWO
         oD6Q==
X-Gm-Message-State: AOAM5314rXdG3EpfhkS1wf6bowHQl/c4AQOUsJLq/flb4SY/HDcB//L9
        0aBaATvf3E65CZB6Sf4dhAbQG56Fu5Or2DCMtXOXSoG5b4o=
X-Google-Smtp-Source: ABdhPJzu7wWsHJhfI60JHYyIhEtqGy54QKziY7rmxV8/+HA9syr0Sbr+ChrV/y5HvtKZAMtK0MAyfv8/FxMWwGDmwVc=
X-Received: by 2002:a17:90a:b307:b0:1bd:37f3:f0fc with SMTP id
 d7-20020a17090ab30700b001bd37f3f0fcmr7439953pjr.132.1646054880182; Mon, 28
 Feb 2022 05:28:00 -0800 (PST)
MIME-Version: 1.0
References: <20220228094552.10134-1-magnus.karlsson@gmail.com> <CAJ+HfNiMQOgnKfa2EtnazK8MuQx5zUtF8GzQjdo-kUAoDv+Z1A@mail.gmail.com>
In-Reply-To: <CAJ+HfNiMQOgnKfa2EtnazK8MuQx5zUtF8GzQjdo-kUAoDv+Z1A@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 28 Feb 2022 14:27:49 +0100
Message-ID: <CAJ8uoz0NRRoviHd4tthsyMyAqw2FRUeWn17VP4k-7=9uJ3Kitw@mail.gmail.com>
Subject: Re: [PATCH bpf v2] xsk: fix race at socket teardown
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, Elza Mathew <elza.mathew@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 2:21 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> On Mon, 28 Feb 2022 at 10:46, Magnus Karlsson <magnus.karlsson@gmail.com>=
 wrote:
> >
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Fix a race in the xsk socket teardown code that can lead to a null
> > pointer dereference splat. The current xsk unbind code in
> > xsk_unbind_dev() starts by setting xs->state to XSK_UNBOUND, sets
> > xs->dev to NULL and then waits for any NAPI processing to terminate
> > using synchronize_net(). After that, the release code starts to tear
> > down the socket state and free allocated memory.
> >
> [...]
> >
> > v1 -> v2:
> > * Naming xsk_zc_xmit() -> xsk_wakeup() [Maciej]
> >
>
> Magnus,
>
> You forgot to include my ACK! So, again:
>
> Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>

Sorry for that Bj=C3=B6rn.

/Magnus

>
> Cheers,
> Bj=C3=B6rn
