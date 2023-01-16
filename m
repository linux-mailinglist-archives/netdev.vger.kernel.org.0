Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE19966BA89
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 10:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbjAPJgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 04:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbjAPJgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 04:36:43 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F27218B14
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 01:36:40 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id p188so29605462yba.5
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 01:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kH9aOCT6pj2r+4BZGThJVSbzJzQ1mNrsB6FBxKTTGqE=;
        b=eOtBVqiBeGmZPWN27QSU1M6fP7OicpcS+hV2YAjRQjwwvxMcwQWxgXQlQj9FKZWzub
         u/7PvvD4wY7SqD8VJrQXaB9lSJ8mXYzeXRg+8b2XDdpmNr0JACKxBG00I6alfq36srC6
         lHBo54oSyFPEbzTMfrJfM5/sfDwku8d8b0ulBgW7vEzxVwOiYPLdSLqicejJuyqisG19
         lXeltti1jfjhgUz3p3x3d44dt57IV/uzSzGN2o3hMT7/ApKfWcDQHMm0yDb7ctcT1pSi
         rzXSsAy6XUJ4AcEKpLnUpZt27wZARnUn2YVk9PkveQEU32S5BSADb3S8CoXxIrEKi7GB
         sCzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kH9aOCT6pj2r+4BZGThJVSbzJzQ1mNrsB6FBxKTTGqE=;
        b=K9nrKYv7EW6YZ7e7ENzXNpTiWRm1s4WDOjPdN1IiAfYD9CAKWvk9e0sIjJq+I7GOjx
         oVDE/11zJp6TncHK0sE2rek7b969kMvzAHaODXOgvN19K4eX/pLFt1Iu89G6HrKzDBwq
         PCu6brN821LF5EWjDFGL3sa75/kp4h+3MxY4EN+Ch8tBwykIU0WrPwI3AvAbskUbPM/H
         Hs1fGuvEaBfKlP8Da7E0eJtCkLex6uoyazQA+hp57rH7LDXIy4JiqNlaOvxZxoObSF6L
         jDdGvDYwgx8kbS+V47XrTd27fJNBs45iw4JrI7GdCryIPxKsjmyYKqWriraltqVCBU5M
         T/gg==
X-Gm-Message-State: AFqh2krFDgkQq0vsCUOtuiBJLNNijhUQpNPUtf0pVT1HDDD5NvdEXmK6
        I9e9bIDsnTyOeddaqF4osXbKm+nm0zIshPlMEV8dgQ==
X-Google-Smtp-Source: AMrXdXuD+tsmHoIqUJWVVTasVjhctdpPpJF8HvcFM29cYFrWRdfpAMv4nC3r4lpzdd67kAEfUsoyFcHL5UtSOpenRx8=
X-Received: by 2002:a25:46c6:0:b0:7b8:a0b8:f7ec with SMTP id
 t189-20020a2546c6000000b007b8a0b8f7ecmr4695150yba.36.1673861799025; Mon, 16
 Jan 2023 01:36:39 -0800 (PST)
MIME-Version: 1.0
References: <20230113164849.4004848-1-edumazet@google.com> <Y8Sb7LYDN/xjDBQy@pop-os.localdomain>
In-Reply-To: <Y8Sb7LYDN/xjDBQy@pop-os.localdomain>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 16 Jan 2023 10:36:28 +0100
Message-ID: <CANn89i+42Yk50N+D9KQmm+gvO84Wjnmk8WJa2mk++-kXy5CvEQ@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: sch_taprio: fix possible use-after-free
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>,
        Alexander Potapenko <glider@google.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
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

On Mon, Jan 16, 2023 at 1:35 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Fri, Jan 13, 2023 at 04:48:49PM +0000, Eric Dumazet wrote:
> > syzbot reported a nasty crash [1] in net_tx_action() which
> > made little sense until we got a repro.
> >
> > This repro installs a taprio qdisc, but providing an
> > invalid TCA_RATE attribute.
> >
> > qdisc_create() has to destroy the just initialized
> > taprio qdisc, and taprio_destroy() is called.
> >
> > However, the hrtimer used by taprio had already fired,
> > therefore advance_sched() called __netif_schedule().
> >
> > Then net_tx_action was trying to use a destroyed qdisc.
> >
> > We can not undo the __netif_schedule(), so we must wait
> > until one cpu serviced the qdisc before we can proceed.
> >
>
> This workaround looks a bit ugly. I think we _may_ be able to make
> hrtimer_start() as the last step of the initialization, IOW, move other
> validations and allocations before it.
>

taprio_init() detects no error.

So moving around the hrtimer_start() inside it won't help.

The error comes later from a wrong TCA_RATE attempt can then:

static struct Qdisc *qdisc_create(...
...
err = gen_new_estimator(...);
if (err) {
    NL_SET_ERR_MSG(extack, "Failed to generate new estimator");
    goto err_out4;
}

...

err_out4:
qdisc_put_stab(rtnl_dereference(sch->stab));
 if (ops->destroy)
     ops->destroy(sch);
goto err_out3;

This is why we need to make sure ->destroy will fully undo what ->init did,
including the possible fact that the hrtimer already fired.
This seems to be taprio specific.

Or we would need a new method, like   ->post_init(), that should be
called once all steps have been a success.

Or call the hrtimer_start() at first taprio_enqueue(), adding a
conditional in fast path...

> Can you share your reproducer?

Not publicly.

Although I think the bug is clear enough.
