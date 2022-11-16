Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE6062C275
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 16:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbiKPP0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 10:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234566AbiKPP0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 10:26:12 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F04B17AA6
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 07:26:12 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id l6so16868388pjj.0
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 07:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YTozLiqwZumzef0OB+V0fMRxe855Mo/cj81wxryuuI8=;
        b=U5U7+SNR8L0MWG4wtxdSDPFIsePtxL6m0ljz7qz2CTmAguWVKAKaUm/08HZfC4Loic
         Y9M3o0aJ7l1s0ZlwMFAOM6UJkNv+NdU3Zd0e+erUGrjGupd1mzmBQgS0mrwho7W4gxh8
         goE6cigxvryXQMn8uZfT1/2/ztOYHpplb+GVvEg2lLqOVg7Hbelo2wEyt997NoZQci6j
         bo9wqjVE2eO7qAuoBwiBM6jTqz+YQbhdVoex2ymYGBstm6nSWxo5UfNC2S8JBZ02JmnO
         HsqCJhK+xHFyV6/8UkBuf4nliM611HCPlkVW2sd22AODWbaYnBRWj+Q/a6k24GxdVk4G
         g72Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YTozLiqwZumzef0OB+V0fMRxe855Mo/cj81wxryuuI8=;
        b=poO1IFApd+WY7gmajKzLsNZz/mu3cE6tb8KANKCxvySr0INAJswBpQwm5pW1jqzWfS
         A1fQNSRa+TRhWbQLjwgIXtpw/Dy/GtVhgiOQV1jl3gIoRsslUx2YjGkEhqZZ+8tiYeid
         CV0WYFacdg6hXrnmKxHbhPEZKybONgbtv1m+WAkUXwQG4eVabd91eyzYeyvc3djaIzjn
         MkTKt3C4LZCszEj0FwmJiXjQqxVe2qYIg5JyNDpPPjlqudkSeZ1sb5HctJClh3xUHGWi
         gU6NxnhcPa/99M1LPfAHSB/kUGRub61pT2gjkTF2OrwzoH4U0eYEi/QsOmdYGLQ5rYfv
         kjbw==
X-Gm-Message-State: ANoB5pkrF6sz8Odb8FyXcU56iX5A0XgRPYgmjfzrVFXLSi0pxgH741ad
        vD6Yvtx5pomG+C05+ko0/UmRHEtqfAPnwz2+bJw=
X-Google-Smtp-Source: AA0mqf5YbKjOXt2IrETfn3NlUwdbMwtRPbxuT0kmtI/XA89jK26ITvvlFBCdQs3f+MzigJ4umavKvdeB6kXFZ+Z4vyI=
X-Received: by 2002:a17:90a:67c4:b0:213:ba14:3032 with SMTP id
 g4-20020a17090a67c400b00213ba143032mr4290291pjm.111.1668612371401; Wed, 16
 Nov 2022 07:26:11 -0800 (PST)
MIME-Version: 1.0
References: <20221109180249.4721-1-dnlplm@gmail.com> <20221109180249.4721-3-dnlplm@gmail.com>
 <20221110173222.3536589-1-alexandr.lobakin@intel.com>
In-Reply-To: <20221110173222.3536589-1-alexandr.lobakin@intel.com>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Wed, 16 Nov 2022 16:19:48 +0100
Message-ID: <CAGRyCJHmNgzVVnGunUh7wwKxYA7GzSvfgqPDAxL+-NcO2P+1wg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: qualcomm: rmnet: add tx packets aggregation
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Alexander,

Il giorno gio 10 nov 2022 alle ore 18:35 Alexander Lobakin
<alexandr.lobakin@intel.com> ha scritto:
>
> Do I get the whole logics correctly, you allocate a new big skb and
> just copy several frames into it, then send as one chunk once its
> size reaches the threshold? Plus linearize every skb to be able to
> do that... That's too much of overhead I'd say, just handle S/G and
> fraglists and make long trains of frags from them without copying
> anything?

sorry for my question, for sure I'm lacking knowledge about this, but
I'm trying to understand how I can move forward.

Suppose I'm able to build the aggregated block as a train of
fragments, then I have to send it to the underlying netdevice that, in
my scenario, is created by the qmi_wwan driver: I could be wrong, but
my understanding is that it does not support fragments.

And, as far as I know, there's only another driver in mainline used
with rmnet (mhi_net) and that one also does not seem to support them
either.

Does this mean that once I have the aggregated block through fragments
it should be converted to a single linear skb before sending?

Thanks,
Daniele
