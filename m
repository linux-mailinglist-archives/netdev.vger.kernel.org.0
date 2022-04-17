Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54F55049CA
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 00:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbiDQWoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 18:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbiDQWo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 18:44:29 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A948C13EB8
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 15:41:52 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id t67so23041314ybi.2
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 15:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jXQsgNAGgngB8eQTDw1MMX1dEMKwcFidBB0WaJDHcMU=;
        b=YmUDSkrNtUkJqJHt2c4zniQEkvjRAMIlQ2HM8N1O4aIUn5NLhZzeA/0fhaxOeH1FqP
         GaOBKfZkSAOGbFk8xAAUG2ezZC3dGaPyaV8fkvuxFjTh+i6DT1UAHWNEOuwdlImIrSzB
         T/KV0Gb4bNGE7Zn29zuo96acjB+Tpt9mhpXpPUlis8kaBiOYx/7JiAZl4+K5uLro/iRS
         Y1hCt7aoUJwfda4GXgfzPKgma6qdDbOlvwpUw6YR4uEd3/BVx0MeL5Cr4FAgrqaikIye
         QpWHTZRfwcocksh/f5RMOGu5bihx6WrTgUQ5JZ9dbsrWpIj4KjyJSqihDqxZe0ox/yyr
         XcFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jXQsgNAGgngB8eQTDw1MMX1dEMKwcFidBB0WaJDHcMU=;
        b=x86lPgJlrsckwYspvzlkcvdlez3iXb9Pd2rl7JLA8sSLSZLT9Db7DDDM7wlLcuSSWJ
         lkzbl4RXoDkkslKnCvI8FzVYJ/MnLRCsLSdRIls/LnI2GxY7RmFeYOYWTNJ97pqyVfQi
         +jcKz2oWDCIBS6W7k4BvtfxngIU2YCX+v1p7h63KtMKHkTH0SRTXRFAd9g0K2gdEzZZX
         Ugh8Vbg3GlGCl4Hmo0cH7A8MmJ6WWg6uxD1upw5uXINhl5FLPhA3YYivoZCMv96vuMWB
         hLiwcR+eJgPKnL+YYGjNPbZKHrV5omTHrdkg7jzpLADmVb2SatpOjn4dnUTZ/7qy3niM
         foig==
X-Gm-Message-State: AOAM531E5jLmNeCoHJJnCj55bHywP/2LzGKF4WXgGzV+LIDjLmuFMPGH
        n4ytggH8sHCQHGyBS/GZU2FeB7XWVN27r4l//41wIXAqdJGVkM/e
X-Google-Smtp-Source: ABdhPJy5PXOfrzrJFSJj93UsZk8Y6Sr3r00l/z9t5nCvR7H6nrTPZqHrQvPyuv9mGwCaiaE4dMsgrkJa0VevuB9CDWQ=
X-Received: by 2002:a25:ea48:0:b0:644:e2e5:309 with SMTP id
 o8-20020a25ea48000000b00644e2e50309mr3643866ybe.407.1650235311504; Sun, 17
 Apr 2022 15:41:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220414011004.2378350-1-eric.dumazet@gmail.com> <CAM_iQpXb=-hdGbdbpTbDBGJKyYPhn3SxXUUowHg5gTy20W=iiQ@mail.gmail.com>
In-Reply-To: <CAM_iQpXb=-hdGbdbpTbDBGJKyYPhn3SxXUUowHg5gTy20W=iiQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 17 Apr 2022 15:41:40 -0700
Message-ID: <CANn89iLrk_iQ8MJTLcueijnmowkuJEVSO_kBmm7y8Z--AGpz4g@mail.gmail.com>
Subject: Re: [PATCH net-next] net_sched: make qdisc_reset() smaller
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>
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

On Sun, Apr 17, 2022 at 3:30 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Wed, Apr 13, 2022 at 6:11 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > From: Eric Dumazet <edumazet@google.com>
> >
> > For some unknown reason qdisc_reset() is using
> > a convoluted way of freeing two lists of skbs.
> >
> > Use __skb_queue_purge() instead.
> [...]
> >
> > -       skb_queue_walk_safe(&qdisc->gso_skb, skb, tmp) {
> > -               __skb_unlink(skb, &qdisc->gso_skb);
> > -               kfree_skb_list(skb);
>
> Isn't it precisely because of this kfree_skb_list()?

Note the __skb_unlink(skb, &qdisc->gso_skb) which happens at the line above.

__skb_unlink(...)
{
...
skb->next  = skb->prev = NULL;
...
}

This means skb->next is NULL, thus there is no list of skb attached to @skb ?

kfree_skb_list(skb) is thus a convoluted way to call kfree_skb(skb)

It seems to me that this construct had been copy/pasted from elsewhere.
