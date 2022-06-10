Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 397D7545DA2
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 09:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346519AbiFJHf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 03:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243558AbiFJHfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 03:35:17 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF502F64B
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 00:35:16 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id w2so45627576ybi.7
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 00:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7ePcvtrAfkDDMXBENLN5wUjeDPbbwzDe0oZvNvxzKMI=;
        b=iQ33QWZUIB+joeFDLf2jIZ39BXXh2xjPLpwX+yXbb6yVQYYr/hGUn97AjuBRUn5bzq
         MIBXrrIYvx+amFBeh2i4c0ZtPFJQKOmnKiJ+olioV+zq5N2EVcPdp97VpYEjRYhmaf/X
         9zqr5NAzlWJzvUnLyshBIzzJ1GPEAfFFs/spS29v1myE0I1H/MjFlnhLA2QR/IibECz2
         2oU2Vm0HgY1nlXFkBfpAu6wEugw/gstzWYQuows3fZWTw94iWyzi8YhiT/+J0avFdcAt
         lLb8vc6PpBZwhl6pdfHHnGSziPqJpn1cqYuBaAj2gZZZlccVu+Xh0kuWUWN9cqOBS2gg
         gFCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7ePcvtrAfkDDMXBENLN5wUjeDPbbwzDe0oZvNvxzKMI=;
        b=IE3aTi9+6iV0JFx/830Y/wk9DQnXwU9XVrpVCWT/WiMLgqneh/UFKReePhwB6LSOhu
         5lpG/WYgI1e1AdwDcPSGNsmV5lf7ibHauRbGmUN4k2iw7SLN7Zf+CqxLBBLWe2nQyCJy
         9nhdtLftR5DAwOwAzMi6R5zYrk3w/J/YEEt8yU57ZcBpM/pTnMcXU2aNA45nqF5ENE15
         Fu2IQYkqUOxhOuhZ/nmiaSgbkjYsUTFLJpXaj2w24d95g9L10/8wYzpXt+iSDqbH2wey
         y0+GARTNKCEwF/BF3oseClpSDS/k906JeGA15hZOiq64ogOnDqwPMIiyc3yzjY6ME8Lg
         aLmA==
X-Gm-Message-State: AOAM5300WW82D3HDdNlbxr2q6npEbSlBp4V7AL2NeUOPU9WnQtu/mSeM
        nwO1nJgcceOcoF1tS2uaNH7tr8Hj8Kpy17IYX3dwDw==
X-Google-Smtp-Source: ABdhPJxUeoqxYCw43kLFvWl9u/XspDZQiRg+1tO44tOFvdv0fzp7Aauqg6TmGklPZmpqMozaFMOe+EVigVqG53ea6EU=
X-Received: by 2002:a25:504:0:b0:664:621d:1af4 with SMTP id
 4-20020a250504000000b00664621d1af4mr1869951ybf.55.1654846515784; Fri, 10 Jun
 2022 00:35:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220610070529.1623-1-zhudi2@huawei.com> <CANn89iKvXUbunP6UtNE1tNCH7FwCux22_rqwhGigvGn_64-6FA@mail.gmail.com>
In-Reply-To: <CANn89iKvXUbunP6UtNE1tNCH7FwCux22_rqwhGigvGn_64-6FA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 10 Jun 2022 00:35:04 -0700
Message-ID: <CANn89i+PQ0Z5LHoTfBixJ9gzAcWD9_8dWccO80gSPx+uZ_wujA@mail.gmail.com>
Subject: Re: [PATCH] fq_codel: Discard problematic packets with pkt_len 0
To:     Di Zhu <zhudi2@huawei.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, rose.chen@huawei.com,
        syzbot+7a12909485b94426aceb@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 12:32 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Jun 10, 2022 at 12:07 AM Di Zhu <zhudi2@huawei.com> wrote:
> >
> > Syzbot found an issue [1]: fq_codel_drop() try to drop a flow whitout any
> > skbs, that is, the flow->head is null.
> > The root cause is that: when the first queued skb with pkt_len 0, backlogs
> > of the flow that this skb enqueued is still 0 and if sch->limit is set to
> > 0 then fq_codel_drop() will be called. At this point, the backlogs of all
> > flows are all 0, so flow with idx 0 is selected to drop, but this flow have
> > not any skbs.
> > skb with pkt_len 0 can break existing processing logic, so just discard
> > these invalid skbs.
> >
> > LINK: [1] https://syzkaller.appspot.com/bug?id=0b84da80c2917757915afa89f7738a9d16ec96c5
> >
> > Reported-by: syzbot+7a12909485b94426aceb@syzkaller.appspotmail.com
> > Signed-off-by: Di Zhu <zhudi2@huawei.com>
> > ---
> >  net/sched/sch_fq_codel.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
> > index 839e1235db05..c0f82b7358e1 100644
> > --- a/net/sched/sch_fq_codel.c
> > +++ b/net/sched/sch_fq_codel.c
> > @@ -191,6 +191,9 @@ static int fq_codel_enqueue(struct sk_buff *skb, struct Qdisc *sch,
> >         unsigned int pkt_len;
> >         bool memory_limited;
> >
> > +       if (unlikely(!qdisc_pkt_len(skb)))
> > +               return qdisc_drop(skb, sch, to_free);
> > +
>
>
> This has been discussed in the past.
>

https://www.spinics.net/lists/netdev/msg777503.html

> Feeding ndo_start_xmit() in hundreds of drivers with zero-length
> packets will crash anyway.
>
> We are not going to add such silly tests in all qdiscs, and then all
> ndo_start_xmit(), since qdiscs are not mandatory.
>
> Please instead fix BPF layer, instead of hundreds of drivers/qdiscs.
