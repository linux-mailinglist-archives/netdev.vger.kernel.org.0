Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E77D57D35C
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 20:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbiGUSe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 14:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbiGUSet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 14:34:49 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38BE8CC92
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 11:34:48 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-31e560aa854so26504997b3.6
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 11:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QlAulcFkMUitv0+fArtp9z1DPxQvcUges5jlQSUpjVs=;
        b=lpFOrvDuWxVEMpnj8zeEwkvA0Sbrg41iZ3i0a3696qaQ8mj/Yj9+WtV9QO6BFy3f5A
         LgTCQiZHykGtps+HbbQ+kT2ZJ8SpGzT9qMgq9/gIj/++Shm/igIcLOLzqtKIQgHQDhu3
         QXeGlFG7MLhtw2B/EUHV7CXA78ze23YF80XMwCrKg3nm2lKXVe9XD+Zrp9oNli95wOju
         9iRi62GZy3Hrelh8mojJk0AUOMwoGWpvW2T22b4iUNTpotwuKtPkQIS8ZSAhhNWksI6Z
         +RLoxKkTZ7l88YmsBmptPixIX2+6IBr6xBb5iZQ6jLOx3gx2dW011qVluuu8llyTpM2u
         Uz6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QlAulcFkMUitv0+fArtp9z1DPxQvcUges5jlQSUpjVs=;
        b=Q3xjCnXe/YGRz+lSC5MWgIAjqDgApiZDoMNLioPW+ayoSviGv+a0lBo6dNQ80Czf22
         QFquybKklbErJlRWdryOeSthU2QLa3IWVmjC0TItKaklDEBRqkdZDui4JoCfW9VoXwFk
         bzEVS4RANs0SfryAm+hNoMKisZhRh/BeYlhYR5d9Jh5kGb0aEMTbz3DTSBoQz8H5lEhy
         HdO+jCqPhj3+F7AzzVDOz5yR8gii88Ii85s+ZR0TAzJGR4LwQ0j4rSFQuzl53orXn0ht
         E5qV1w17b97RGjZy0m1Pghy0dSci4geUQmsqzcimUTppU4D5UnYLOb8JSOAJBNIgZinQ
         zAMA==
X-Gm-Message-State: AJIora/Il3rfcfK45tkOVodDP0RZKn3ApNEPkjGJr4lGOFr6icPKLq1I
        2vbLt7KE9QhJ1Q+TzOKXirz3JO2bYrcsOfkRobKK+Q==
X-Google-Smtp-Source: AGRyM1tPfe6oGG36o7xiQsnVUJGeZH53WXojSMioeWyZa3K9w3PxTmpmbPoSdNomjWoxO4P0yW9Zh2/eOX2PfRA69so=
X-Received: by 2002:a81:6088:0:b0:31e:79fd:3dfa with SMTP id
 u130-20020a816088000000b0031e79fd3dfamr5758106ywb.47.1658428486602; Thu, 21
 Jul 2022 11:34:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220721120316.17070-1-ap420073@gmail.com> <CANn89iJjc+jcyWZS1L+EfSkZYRaeVSmUHAkLKAFDRN4bCOcVyg@mail.gmail.com>
 <ea287ba8-89d6-8175-0ebb-3269328a79b4@gmail.com>
In-Reply-To: <ea287ba8-89d6-8175-0ebb-3269328a79b4@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 21 Jul 2022 20:34:35 +0200
Message-ID: <CANn89iL=sLeDpPfM8OKbDc7L95p+exPynZNz+tUBUve7eA42Eg@mail.gmail.com>
Subject: Re: [PATCH net] net: mld: do not use system_wq in the mld
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        netdev <netdev@vger.kernel.org>
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

On Thu, Jul 21, 2022 at 7:53 PM Taehee Yoo <ap420073@gmail.com> wrote:
>
> Hi Eric,
> Thank you so much for your review!
>

...

> I think your assumption is right.
> I tested the below scenario, which occurs the real issue.
> THREAD0                            THREAD1
> mld_report_work()
>                                     spin_lock_bh()
>                                     if (!mod_delayed_work()) <-- queued
>                                             in6_dev_hold();
>                                     spin_unlock_bh()
> spin_lock_bh()
> schedule_delayed_work() <-- return false, already queued by THREAD1
> spin_unlock_bh()
> return;
> //no in6_dev_put() regardless return value of schedule_delayed_work().
>
> In order to check, I added printk like below.
>          if (++cnt >= MLD_MAX_QUEUE) {
>
>                  rework = true;
>
>                  if (!schedule_delayed_work(&idev->mc_report_work, 0))
>                          printk("[TEST]%s %u \n", __func__, __LINE__);
>                  break;
>
>
> If the TEST log message is printed, work is already queued by other logic.
> So, it indicates a reference count is leaked.
> The result is that I can see log messages only when the reference count
> leak occurs.
> So, although I tested it only for 1 hour, I'm sure that this bug comes
> from missing check a return value of schedule_delayed_work().
>
> As you said, this changelog is not correct.
> system_wq and mld_wq are not related to this issue.
>
> I would like to send a v2 patch after some more tests.
> The v2 patch will change the commit message.

Can you describe what kind of tests you are running ?
Was it a syzbot report ?
