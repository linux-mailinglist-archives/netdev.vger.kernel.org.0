Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479C46C4743
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 11:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjCVKLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 06:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjCVKLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 06:11:31 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA6B5CC05
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 03:11:30 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id e19so15738943vsu.4
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 03:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679479889;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IafJreLySfd3MASc8cxT/2Y6WBOvzFufHv4VLDHTTeQ=;
        b=HFaqUEWqVXW/5CsUbV/OddVkdqh595d7LFT8iwGlZRwvw4TN95d0rEnipMONb24/ry
         kJgysTThBH8AU23xVymKR2QdVeku98oOEroAtTO/GnUdQ4acuPcKjy7priO0wYQvsg0j
         uJPb6htPOIJMIQ/2szCA/coE0Q5d3j8h1BE0BsWMTe42GFIy8NuZw5SVHPq9jztFEqww
         2Qbf7VPRM21xAh1sqLyHLXkigQUAJntiTS1JQ+xeLie6Ehg1AyuetSW0cxKqHSGiIKFV
         3T5LR2DGSM13YyYvg4fmGGXbVXxT3Z6rABGl20/4Cb7+Ft8MpBjpTtS5RzejsnJvFFBq
         vmqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679479889;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IafJreLySfd3MASc8cxT/2Y6WBOvzFufHv4VLDHTTeQ=;
        b=xTxfHFKa9bqdHsbcaOmv/d7ddYtlx9DMjtn5egWYZmfE2EPnOFlK9v/wUJKNn6j8yc
         lM3n81Ynt2/TCb4DuSMIJd6EHXZWfHUXCXr3DNFpnCMSME9TSdAqFyLJaf+iZ8F66XSf
         TNiPxzF4vm3v9VJZEVF/zXd8zPrjlvXKC8RIOC6fZNNMKiti5N2QXZngiiUKHudyZCfP
         MVFcQuPiQM1Hyfpw+6E9KvRHWd6fMZyo1KlzCPlkQJQJAV/10Jsi94UdNecw08aGY62F
         ucTHUnCdZPjyDAlHs6HlFZf9Sow0umzqSl8VnPDn5puFgZd4v+O06PzUpOFnbjevHz89
         +D5Q==
X-Gm-Message-State: AO0yUKXKoicm0BfYs/HEgUJJVB09+ne5kH1vEYGxEOhgKCfU4i3Ul99o
        6KcYxFS8oYACGnyXFPI+n07BP11uqTZk9ZLqviDxLQ==
X-Google-Smtp-Source: AK7set91bQA2qMqsWs4iqweENTZVavI1PGtrRcZD2M6PDz6B24imVqlCPbOuXqYOWZA5xEpqbkVlZKse6AodxFWVOtA=
X-Received: by 2002:a67:e04a:0:b0:425:f836:59ba with SMTP id
 n10-20020a67e04a000000b00425f83659bamr3629620vsl.7.1679479889494; Wed, 22 Mar
 2023 03:11:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230320163703.GA27712@debian> <20230320170009.GA27961@debian> <889f2dc5e646992033e0d9b0951d5a42f1907e07.camel@redhat.com>
In-Reply-To: <889f2dc5e646992033e0d9b0951d5a42f1907e07.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 22 Mar 2023 03:11:18 -0700
Message-ID: <CANn89iK_bsPoaRVe+FNZ7LF_eLbz2Af6kju4j9TVHtbgkpcn5g@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] gro: optimise redundant parsing of packets
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Richard Gobert <richardbgobert@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, dsahern@kernel.org, alexanderduyck@fb.com,
        lucien.xin@gmail.com, lixiaoyan@google.com, iwienand@redhat.com,
        leon@kernel.org, ye.xingchen@zte.com.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Wed, Mar 22, 2023 at 2:59=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On Mon, 2023-03-20 at 18:00 +0100, Richard Gobert wrote:
> > Currently the IPv6 extension headers are parsed twice: first in
> > ipv6_gro_receive, and then again in ipv6_gro_complete.
> >
> > By using the new ->transport_proto field, and also storing the size of =
the
> > network header, we can avoid parsing extension headers a second time in
> > ipv6_gro_complete (which saves multiple memory dereferences and conditi=
onal
> > checks inside ipv6_exthdrs_len for a varying amount of extension header=
s in
> > IPv6 packets).
> >
> > The implementation had to handle both inner and outer layers in case of
> > encapsulation (as they can't use the same field). I've applied a simila=
r
> > optimisation to Ethernet.
> >
> > Performance tests for TCP stream over IPv6 with a varying amount of
> > extension headers demonstrate throughput improvement of ~0.7%.
>
> I'm surprised that the improvement is measurable: for large aggregate
> packets a single ipv6_exthdrs_len() call is avoided out of tens calls
> for the individual pkts. Additionally such figure is comparable to
> noise level in my tests.
>
> This adds a couple of additional branches for the common (no extensions
> header) case.
>
> while patch 1/2 could be useful, patch 2/2 overall looks not worthy to
> me.
>
> I suggest to re-post for inclusion only patch 1, unless others have
> strong different opinions.
>

+2

I have the same feeling/opinion.

> Cheers,
>
> Paolo
>
