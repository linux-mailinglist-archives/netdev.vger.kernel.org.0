Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014F26183BB
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 17:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbiKCQII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 12:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiKCQHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 12:07:45 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EF81705F;
        Thu,  3 Nov 2022 09:07:21 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id u6so2338443plq.12;
        Thu, 03 Nov 2022 09:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ObeLcsj3nE9gnGWSU04jueaoflUbLzWwQVpy0WCWEUg=;
        b=Ydy4NwzRVs+sKAteh+nyUyz52gUutmhusxHJwQH9FMye8SKVC5WA1kdkQ98hTeWT43
         w7LbJCyJlUmmcfIbs+trw7uxcKaNPb8tTxFiZmBWcm7+n+6hxxcjGOJUR+TixFyYoSip
         9goUSWAQ/FrIyQwhli4NEPCZ397seRc+ahfKT/nvSldrU/hlsufE6eS/V+ur8TMQLwWo
         /cCkF/RtwKSAbzplVZ1HqWTCLNycCeflRkfQmgG2MePwpbc0w96VDcmBZ1FZFmgOmD2W
         Y1a3t5Cjpya7+n6Dw8g2DqGScG3syFpAbehDtqj3R2lTrA0NW/mbHuRNLn0H7TSqmyAy
         Z+dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ObeLcsj3nE9gnGWSU04jueaoflUbLzWwQVpy0WCWEUg=;
        b=jPzLQ9LfeGL14ZqjyVYn6JiJH6T7ZRRLIhdrOphXXaB1rT3Wf0Hv1XSu9TIPvOZwbh
         Nb/5v2f0Psss7KecIPL9ewjQbAH89oqO9+S8bX/Vu70VFvlRd9cGYyrZsutcio35PEX4
         6ZU/+RUGyZJZPyp33H9AoJ710M3MQHdC3NUls6IO/ni7NHOn0cdlt8+KMHzMT3pQiD7F
         6na5x0ACCi6O4lZlf0aCeb70LoS1W7kms3mEYn890sgkhFhvdcumSaAYHV1EHet/wjVB
         IwsqoqY7/P5UaWMv1i+Xk6ViEBPV2qUqrmuWQlo0hr1xNlirNUlvr+yem3txf1kG8q6P
         G9vQ==
X-Gm-Message-State: ACrzQf1Yn1s/KXjpsT/EcK8IDlVLfaDm89Kc2vnAABtAS5slxABuINui
        dJzG6woHHHBu7Yok2tQh2M0=
X-Google-Smtp-Source: AMsMyM4AspEOOfYu1TOrjbycqVKFRnhD6LEjYnSnNrzdmQhhrtoarPaLPkLM6np/pZIb1yaYehHjBA==
X-Received: by 2002:a17:90b:1982:b0:212:fe7f:4a49 with SMTP id mv2-20020a17090b198200b00212fe7f4a49mr49645540pjb.156.1667491641125;
        Thu, 03 Nov 2022 09:07:21 -0700 (PDT)
Received: from localhost ([223.104.41.9])
        by smtp.gmail.com with ESMTPSA id nw1-20020a17090b254100b00205db4ff6dfsm138640pjb.46.2022.11.03.09.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 09:07:20 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     kuba@kernel.org
Cc:     18801353760@163.com, davem@davemloft.net, edumazet@google.com,
        jhs@mojatatu.com, jiri@resnulli.us, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com,
        yin31149@gmail.com
Subject: Re: [PATCH] net: sched: fix memory leak in tcindex_set_parms
Date:   Fri,  4 Nov 2022 00:07:00 +0800
Message-Id: <20221103160659.22581-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221102202604.0d316982@kernel.org>
References: <20221102202604.0d316982@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,
On Thu, 3 Nov 2022 at 11:26, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 31 Oct 2022 14:08:35 +0800 Hawkins Jiawei wrote:
> > Kernel will uses tcindex_change() to change an existing
>
> s/will//
>
> > traffic-control-indices filter properties. During the
> > process of changing, kernel will clears the old
>
> s/will//
>
> > traffic-control-indices filter result, and updates it
> > by RCU assigning new traffic-control-indices data.
> >
> > Yet the problem is that, kernel will clears the old
>
> s/will//
Thanks for the suggestion. I will amend these in the v2 patch.

>
> > traffic-control-indices filter result, without destroying
> > its tcf_exts structure, which triggers the above
> > memory leak.
> >
> > This patch solves it by using tcf_exts_destroy() to
> > destroy the tcf_exts structure in old
> > traffic-control-indices filter result.
> >
>
> Please provide a Fixes tag to where the problem was introduced
> (or the initial git commit).
Thanks for reminding, it seems that the problem was 
introduced by commit 
b9a24bb76bf6 ("net_sched: properly handle failure case of tcf_exts_init()"),
because it was in this commit that kernel allocated the struct tcf_exts
for new traffic-control-indices filter result in tcindex_alloc_perfect_hash().

I will add the tag in the v2 patch.

>
> > Link: https://lore.kernel.org/all/0000000000001de5c505ebc9ec59@google.com/
> > Reported-by: syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com
> > Tested-by: syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com
> > Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
> > ---
> >  net/sched/cls_tcindex.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
> > index 1c9eeb98d826..dc872a794337 100644
> > --- a/net/sched/cls_tcindex.c
> > +++ b/net/sched/cls_tcindex.c
> > @@ -338,6 +338,9 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
> >       struct tcf_result cr = {};
> >       int err, balloc = 0;
> >       struct tcf_exts e;
> > +#ifdef CONFIG_NET_CLS_ACT
> > +     struct tcf_exts old_e = {};
> > +#endif
>
> Why all the ifdefs?
Thanks for suggestion, it seems that these ifdefs are not needed.
I will delete these in the v2 patch.

>
> >       err = tcf_exts_init(&e, net, TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
> >       if (err < 0)
> > @@ -479,6 +482,14 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
> >       }
> >
> >       if (old_r && old_r != r) {
> > +#ifdef CONFIG_NET_CLS_ACT
> > +             /* r->exts is not copied from old_r->exts, and
> > +              * the following code will clears the old_r, so
> > +              * we need to destroy it after updating the tp->root,
> > +              * to avoid memory leak bug.
> > +              */
> > +             old_e = old_r->exts;
> > +#endif
>
> Can't you localize all the changes to this if block?
>
> Maybe add a function called tcindex_filter_result_reinit()
> which will act more appropriately?
I think we shouldn't put the tcf_exts_destroy(&old_e)
into this if block, or other RCU readers may derefer the
freed memory (Please correct me If I am wrong).

So I put the tcf_exts_destroy(&old_e) near the tcindex 
destroy work, after the RCU updateing.

>
> >               err = tcindex_filter_result_init(old_r, cp, net);
> >               if (err < 0) {
> >                       kfree(f);
> > @@ -510,6 +521,9 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
> >               tcf_exts_destroy(&new_filter_result.exts);
> >       }
> >
> > +#ifdef CONFIG_NET_CLS_ACT
> > +     tcf_exts_destroy(&old_e);
> > +#endif
> >       if (oldp)
> >               tcf_queue_work(&oldp->rwork, tcindex_partial_destroy_work);
> >       return 0;
