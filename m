Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33E0358F89
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 23:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbhDHVz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 17:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbhDHVz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 17:55:26 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E63DC061760
        for <netdev@vger.kernel.org>; Thu,  8 Apr 2021 14:55:14 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id s11so2857231pfm.1
        for <netdev@vger.kernel.org>; Thu, 08 Apr 2021 14:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B+eFuRlEAY87if8k8D1jmsagdE/SOuhNQlNJxohJYbc=;
        b=ZZlgi5drI+VKlc6jdP7n+TxvL+rhN0kCwVBV+lAsshmbmsSHAhsJ9vyajER0rDDUh/
         J/dI5EVKfGdyaTcEDtzwrewojDaxpOL/z60OjbTTG2NoQFiKyLFxWucdePzDUFnl3w+0
         CxlLhXDpkRWcx+plmr7sCnNR3fgoyvN/gKGaSh2V9WpCC4P2NCps2WxflIuWA/P4deIu
         N280srLxrcpz+2nVQzp7K6pe25oN/YcxwBQwLewaejb0yHEaYYI+P0Zi+8EEOH2HHnfN
         RjcFZ3hqNCTcH/tiR5vclGI36W++L1C0CGLfxZcdK+bxpO9G6r+J1g3vH11nMzp/B3yg
         nqFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B+eFuRlEAY87if8k8D1jmsagdE/SOuhNQlNJxohJYbc=;
        b=XhGUGdu1o2mQez7ExXVaFJx/Mjue3pgQXxarvOcjRQ1Gs0PXB8tasKPhxVpFwRLRFA
         cXMyflJEkPBZcqG2TduOVVEE9bk+fsY+ncF0xC14cQMzbhv2l4/rSW0SlUOT3Q+srWPI
         G0UHl5A8+ie3/eOE5xylhVek30nhSFEZKdOFiIxq+4vtS8jmHTvNUfOcsa5HGK/jknZc
         FCdrCCCopU4r4+RAG51JufmbWpai1NFV3VuGmcd4NsH1K0wfrCERuZ2yNGowNGVXrocV
         x1xW71HLOmA1cbwhPoefW70Xy9oHoZGuiQQcPM+t9269SqxmUPkJJgOQ2JVBMsS1W54r
         vGpA==
X-Gm-Message-State: AOAM531vOO7/gl2VafY9wbdsOeSD7XvoHOb2PkRkeTWTxEuPFtBs3BaS
        NpNw3694pKBFITwU4uo40L5Sd8h8kGS8f3iC3wU=
X-Google-Smtp-Source: ABdhPJwCp8DHNOzR7KjfmeD/EiJ0ShGWYG0lQEsweCV4E+jLyxXCN1P3Y/vg4+mCd6L6j4w8l5s98uUuHT8UzJsqEN0=
X-Received: by 2002:a62:fb14:0:b029:22e:e189:c6b1 with SMTP id
 x20-20020a62fb140000b029022ee189c6b1mr9739412pfm.31.1617918914018; Thu, 08
 Apr 2021 14:55:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210407153604.1680079-1-vladbu@nvidia.com> <20210407153604.1680079-3-vladbu@nvidia.com>
 <CAM_iQpXEGs-Sq-SjNrewEyQJ7p2-KUxL5-eUvWs0XTKGoh7BsQ@mail.gmail.com> <6dd90b61-ad41-6e3a-bab7-1f6da2ed1905@mojatatu.com>
In-Reply-To: <6dd90b61-ad41-6e3a-bab7-1f6da2ed1905@mojatatu.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 8 Apr 2021 14:55:03 -0700
Message-ID: <CAM_iQpW6g=PxwuDuAAkmhuWhH3PjTSg7ft+FwO+wdoXT-DuYeQ@mail.gmail.com>
Subject: Re: [PATCH net v2 2/3] net: sched: fix action overwrite reference counting
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 8, 2021 at 4:59 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2021-04-07 7:50 p.m., Cong Wang wrote:
> > On Wed, Apr 7, 2021 at 8:36 AM Vlad Buslov <vladbu@nvidia.com> wrote:
> >>
> >> Action init code increments reference counter when it changes an action.
> >> This is the desired behavior for cls API which needs to obtain action
> >> reference for every classifier that points to action. However, act API just
> >> needs to change the action and releases the reference before returning.
> >> This sequence breaks when the requested action doesn't exist, which causes
> >> act API init code to create new action with specified index, but action is
> >> still released before returning and is deleted (unless it was referenced
> >> concurrently by cls API).
> >>
> >> Reproduction:
> >>
> >> $ sudo tc actions ls action gact
> >> $ sudo tc actions change action gact drop index 1
> >> $ sudo tc actions ls action gact
> >>
> >
> > I didn't know 'change' could actually create an action when
> > it does not exist. So it sets NLM_F_REPLACE, how could it
> > replace a non-existing one? Is this the right behavior or is it too
> > late to change even if it is not?
>
> Thats expected behavior for "change" essentially mapping
> to classical "SET" i.e.
> "create if it doesnt exist, replace if it exists"
> i.e NLM_F_CREATE | NLM_F_REPLACE
>
> In retrospect, "replace" should probably have been just NLM_F_REPLACE
> "replace if it exists, error otherwise".
> Currently there is no distinction between the two.

This is how I interpret "replace" too, but again it is probably too late
to change.

>
> "Add" is classical "CREATE" i.e "create if doesnt exist, otherwise
> error"
>
> It may be feasible to fix "replace" but not sure how many scripts over
> the years are now dependent on that behavior.

Right, we probably have to live with it forever.

Thanks.
