Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FADA3578A9
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 01:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhDGXua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 19:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhDGXua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 19:50:30 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF01C061760
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 16:50:19 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id t20so69367plr.13
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 16:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3q3exLOspHYyVsYZxEMidRhEI14kZ+zshkbyoS67Mrw=;
        b=YoNUnPbzNEU2hPv5itzikatofILHO4WQhXrj77msO35cN5+NadNgo0Re1CDKoMZdj3
         f/CQ+arv9JvSITsWwdesMR/my4zo+i99wod5zLBNBPnyWBz/8g1cabtEEyzSJcBS7b3n
         YmDEDBgOHcglKg38rSRcAgsa35TKmV0TCGWSA2Q4xBfTzZSUcIlHtmeUjLInJcgFPYMJ
         5XdoLQod/aHiBwDmrSEmnnyPnAIZ7zg9aMddQ959UGu0fJorZl/KajP7GXlRtnGRvyO1
         jsDqGPo4gQFS2iPZ2FbmZAqRAc9GT6iDQwhvZ1avJargpWjZMFDO294NBin+bvRpDmYx
         kvJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3q3exLOspHYyVsYZxEMidRhEI14kZ+zshkbyoS67Mrw=;
        b=TuzrpCx/yMCHaEs2CB5qzhWKVmTpsWQn2VSbfw173EAw60gAyqv+mywjcZPcxU7hDv
         jY86c5o8YOdRbFDzRKnuyLDXsyXfzlpOSIY/+c4t5aya1f1ZQvfElcOc37iMAAAeZDAz
         ylEZK8s5bhsTAA5l3cwPvXS9cFhJ2TjAUU3pl4JT8ZDU9Ud1ecxCuzcZNuEFbCl9t0LJ
         bvfzSe81FAeHSNCzO4k6pvv6RaWWp6agWUpr9vYCyZwurS0HTNrDZ5QWMnboeBADHdLH
         eD3jzi3ZVL7CEQsR8zLyR+zGmpt8fcaUwWBV6M3vHvkOk96LHcjzuL0xsd+mkR2px35S
         Ddzg==
X-Gm-Message-State: AOAM53292Tbq/E0t/Hb+aOl6kLcrF9Jwjr/RIW+tAqE+JZZu4Jg4W0Vs
        S+n2eb2/2+TYnaUVB049FbunarN4M/JmY4l1nR0=
X-Google-Smtp-Source: ABdhPJzhzxpNrpng4ebN/Ikaz0U//KyhRdwjS+U+NSmVF+AtjDBD+kcFzxf/GGFggEjNou4gZiZ3mVcxTVORYcTZ6go=
X-Received: by 2002:a17:90a:2bcd:: with SMTP id n13mr5641298pje.145.1617839419379;
 Wed, 07 Apr 2021 16:50:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210407153604.1680079-1-vladbu@nvidia.com> <20210407153604.1680079-3-vladbu@nvidia.com>
In-Reply-To: <20210407153604.1680079-3-vladbu@nvidia.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 7 Apr 2021 16:50:08 -0700
Message-ID: <CAM_iQpXEGs-Sq-SjNrewEyQJ7p2-KUxL5-eUvWs0XTKGoh7BsQ@mail.gmail.com>
Subject: Re: [PATCH net v2 2/3] net: sched: fix action overwrite reference counting
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 7, 2021 at 8:36 AM Vlad Buslov <vladbu@nvidia.com> wrote:
>
> Action init code increments reference counter when it changes an action.
> This is the desired behavior for cls API which needs to obtain action
> reference for every classifier that points to action. However, act API just
> needs to change the action and releases the reference before returning.
> This sequence breaks when the requested action doesn't exist, which causes
> act API init code to create new action with specified index, but action is
> still released before returning and is deleted (unless it was referenced
> concurrently by cls API).
>
> Reproduction:
>
> $ sudo tc actions ls action gact
> $ sudo tc actions change action gact drop index 1
> $ sudo tc actions ls action gact
>

I didn't know 'change' could actually create an action when
it does not exist. So it sets NLM_F_REPLACE, how could it
replace a non-existing one? Is this the right behavior or is it too
late to change even if it is not?

> Extend tcf_action_init() to accept 'init_res' array and initialize it with
> action->ops->init() result. In tcf_action_add() remove pointers to created
> actions from actions array before passing it to tcf_action_put_many().

In my last comments, I actually meant whether we can avoid this
'init_res[]' array. Since here you want to check whether an action
returned by tcf_action_init_1() is a new one or an existing one, how
about checking its refcnt? Something like:

  act = tcf_action_init_1(...);
  if (IS_ERR(act)) {
    err = PTR_ERR(act);
    goto err;
  }
  if (refcount_read(&act->tcfa_refcnt) == 1) {
    // we know this is a newly allocated one
  }

Thanks.
