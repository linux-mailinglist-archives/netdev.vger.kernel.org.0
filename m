Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBBE50C416
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbiDVWLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbiDVWKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:10:12 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358942FABE2
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 13:56:44 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id dw17so6946507qvb.9
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 13:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cuN2njjkwnaOzxB27P2h9XJ9ZnSOg35uhbORLwLX32w=;
        b=JZ/yZDqHsI+P4fQyH/fTSC0sNPSNwj+59csO570zum/4SHsGKAg3WUaud6EwxTp+Fk
         pK8AvEXPPuMd48OtAvlXPAb1hezQ7uLgdpm6KlHqf0BGvcyaxJjNe8reqSzNzpUlcB2h
         qp0cjPLSC4X4wRc3V/WvBVr6xaV2EjX+8iiGuybaxTRBfZFLBKt8kDfxkl4p63AQZSV6
         liIbELc2EkxndOHlYEDpL4lfF73iBxMB326xaTJF1RUcY78YLu0vM8UXs7NhmfJp1Ajo
         d7cCgoe6HJImb/sfeVM4N9vwveh9VEZuqL0sMqE4I8zmli3CDm1wk/c2WSOLbDK481uv
         PeVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cuN2njjkwnaOzxB27P2h9XJ9ZnSOg35uhbORLwLX32w=;
        b=vVPfa0G7lbo3WSa0cpr56akfZYtlvpuQlXLyvmqQexDf3NDqpWoFTpMkgZLuJbaOqi
         nmGK+hg3QT2xlE3bHnR/cjMot7Dt6IBKOTh4K0ulhSFRMk24zfnkXX9raASj/WXuC6Wp
         ZwKEwZttefz6mvq1YYGXDPnmOAHKNYfwoqx6+Nb3XWZz9VL6Jnp27X1dyKwjKxT56no/
         fgZe4/wXYT1nTDkkm48K4to3PcXGJFX/evzibpIrPlwDsmqkt/BudA8JVD7TA2nv5Q/R
         DqCokrme/teCRNImZZG0rHf39m2V88+2WE02Yqi/c/d7yhEBlhfuDtNc98BxJb7xsB7k
         ZnMA==
X-Gm-Message-State: AOAM530YubcZ49r3g5JRHE/dWVcvGUe6ADdXga6hS61uaqkqSOdEVGBc
        I2mod3vOM78ya3zXg0gBi/AvzhWNPjYms1/tVqLTFg==
X-Google-Smtp-Source: ABdhPJyDzMqmBX7OqVAM9uAV0isl0UvCzJngZVgGktEAYcsr4lT65NV0ghsny8ewzvtb/0DjcIoqu0lF+ik4zPTK+fA=
X-Received: by 2002:a05:6214:20cf:b0:44c:3127:cbbf with SMTP id
 15-20020a05621420cf00b0044c3127cbbfmr5136779qve.39.1650661003188; Fri, 22 Apr
 2022 13:56:43 -0700 (PDT)
MIME-Version: 1.0
References: <1650422081-22153-1-git-send-email-yangpc@wangsu.com> <20220422133712.17eebbcb@kernel.org>
In-Reply-To: <20220422133712.17eebbcb@kernel.org>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 22 Apr 2022 16:56:27 -0400
Message-ID: <CADVnQynYun2+wdWDv9EL+CWW_fzmrFmRnw9w1K+cej=28-MbYg@mail.gmail.com>
Subject: Re: [PATCH net v3] tcp: ensure to use the most recently sent skb when
 filling the rate sample
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pengcheng Yang <yangpc@wangsu.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
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

On Fri, Apr 22, 2022 at 4:37 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 20 Apr 2022 10:34:41 +0800 Pengcheng Yang wrote:
> > If an ACK (s)acks multiple skbs, we favor the information
> > from the most recently sent skb by choosing the skb with
> > the highest prior_delivered count. But in the interval
> > between receiving ACKs, we send multiple skbs with the same
> > prior_delivered, because the tp->delivered only changes
> > when we receive an ACK.
> >
> > We used RACK's solution, copying tcp_rack_sent_after() as
> > tcp_skb_sent_after() helper to determine "which packet was
> > sent last?". Later, we will use tcp_skb_sent_after() instead
> > in RACK.
> >
> > Fixes: b9f64820fb22 ("tcp: track data delivery rate for a TCP connection")
> > Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> > Cc: Neal Cardwell <ncardwell@google.com>
> > Cc: Paolo Abeni <pabeni@redhat.com>
>
> Somehow this patch got marked as archived in patchwork. Reviving it now.
>
> Eric, Neal, ack?

Acked-by: Neal Cardwell <ncardwell@google.com>
Tested-by: Neal Cardwell <ncardwell@google.com>

Looks good to me. Thanks for the patch!

neal
