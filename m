Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8579527922C
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbgIYUdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727258AbgIYU2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 16:28:35 -0400
Received: from mail.buslov.dev (mail.buslov.dev [IPv6:2001:19f0:5001:2e3f:5400:1ff:feed:a259])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DEFC0613B5
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 12:50:14 -0700 (PDT)
Received: from vlad-x1g6.mellanox.com (unknown [IPv6:2a0b:2bc3:193f:1:a5fe:a7d6:6345:fe8d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id F1CC520B4F;
        Fri, 25 Sep 2020 22:45:11 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=buslov.dev; s=2019;
        t=1601063112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=byEbDwzk5WHU4FygOZ8muKPjI0PrrXeInFq+yfTsF0A=;
        b=KHTgSAACBr8CjcReRiWRDgaCKlHhGvHqKHfhGGk9+ud+ETFcVzicu3dFOh4SvpgQoTgnRZ
        TP5RzIO8cYeMRVcH5x/Y+ascqLwYOGx5gpOI9tH2k80WDv/f9qybCQ1WzSrpy08fQzUfjk
        9466FXzL/yFQ8HNF+eCwXd9dvJ5l/UMIcB2yQzpJWgXjtEn5YHAr6qXZ1jeXvXGkICa+1X
        ASnuSAW7dgh97ehueAJTlgnNWZOm4LjpPupbGeErZrwBJPu9kljICzvUpgNXqd6V/KCaGB
        +sgpzXoAitb6JLvK4ZU75U6BbfiEqWdtobc6Cx++wu0iNTf0+ILWZr1Ua8iMlw==
References: <20200923035624.7307-1-xiyou.wangcong@gmail.com> <20200923035624.7307-2-xiyou.wangcong@gmail.com> <877dsh98wq.fsf@buslov.dev> <CAM_iQpXy4GuHidnLAL+euBaNaJGju6KFXBZ67WS_Pws58sD6+g@mail.gmail.com>
User-agent: mu4e 1.4.13; emacs 26.3
From:   Vlad Buslov <vlad@buslov.dev>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net 1/2] net_sched: defer tcf_idr_insert() in tcf_action_init_1()
In-reply-to: <CAM_iQpXy4GuHidnLAL+euBaNaJGju6KFXBZ67WS_Pws58sD6+g@mail.gmail.com>
Message-ID: <8736358wu0.fsf@buslov.dev>
Date:   Fri, 25 Sep 2020 22:45:11 +0300
MIME-Version: 1.0
Content-Type: text/plain
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=vlad@buslov.dev smtp.mailfrom=vlad@buslov.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 25 Sep 2020 at 22:22, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Fri, Sep 25, 2020 at 8:24 AM Vlad Buslov <vlad@buslov.dev> wrote:
>> > +     if (TC_ACT_EXT_CMP(a->tcfa_action, TC_ACT_GOTO_CHAIN) &&
>> > +         !rcu_access_pointer(a->goto_chain)) {
>> > +             tcf_action_destroy_1(a, bind);
>> > +             NL_SET_ERR_MSG(extack, "can't use goto chain with NULL chain");
>> > +             return ERR_PTR(-EINVAL);
>> > +     }
>>
>> I don't think calling tcf_action_destoy_1() is enough here. Since you
>> moved this block before assigning cookie and releasing the module, you
>> also need to release them manually in addition to destroying the action
>> instance.
>>
>
> tcf_action_destoy_1() eventually calls free_tcf() which frees cookie and
> tcf_action_destroy() which releases module refcnt.
>
> What am I missing here?
>
> Thanks.

The memory referenced by the function local pointer "cookie" hasn't been
assigned yet to the a->act_cookie because in your patch you moved
goto_chain validation code before the cookie change. That means that if
user overwrites existing action, then action old a->act_cookie will be
freed by tcf_action_destroy_1() but new cookie that was allocated by
nla_memdup_cookie() will leak.

Regards,
Vlad

