Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BFB57CCD3
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 16:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiGUOFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 10:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiGUOFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 10:05:10 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2B3637D
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 07:05:09 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id e69so2955918ybh.2
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 07:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5RleLJjzore0hrU6Ayka4+YUanubDQ3xuIKFETK5cTk=;
        b=W+edDvnLZ9Sr9mcSIQ7TiS0u8MtrXcbwNUizswad0LOHm3QTu2DE1BmhPPtbXxYudZ
         ukWmVX0gHJ/OjvEUWvBYiJCvDhFoipqP7oQ6920RbA2bS3PrndgzbWOn/bSBfL2Ywdej
         xTPnRQeShtZEbvuqyEoDVmkeXu1aVGAS5sjDq9Y6zyoVVVfzgwa4J/yW17hmqXoEXUYb
         iFkcfmM2+7cXVRG8bMynC9RDHETWVH0E3dACthWCGLe/KvQjtjgcSDp+OLEYEOl61lsa
         pcR+AiBYE2tfOtnyqh0SdPLLR3jNYxxJS0tPCp4Yx09GGs/kwJvVga68RlfZsYEbSZVe
         Qt8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5RleLJjzore0hrU6Ayka4+YUanubDQ3xuIKFETK5cTk=;
        b=33KLTRjHnpnf5EeN7YkdnZPKpp9KJRT/lHDsqfVzmlRNCd4wqtO0mt2IoC+pTE2zAz
         QwUxk+osRFRlyvRPL2cZj8oeLxvelvnZ2w9ELT4Bwwji78cut8ueO0dVNNO/ne3DERv9
         GtBKRNZtH/SZBMCQNiYPEQLRWa0D6LPmLHDqMWZh0sleW4J9Ufqyk4iqmh6OAWfsSiEY
         VJ34ccf9/D5b7mFzM3+CrrmJSKPNhpTkugfm+g8Xgzxb/NvOwgXviasrbXcWiIq4eH7V
         uQaCYZMI0Eeug8040CcEKWORVNbU3o0k2XR0nekY2ocriEq2YDfFMkukrEtFpKkzRPLN
         LOrw==
X-Gm-Message-State: AJIora+JpOTrmddljpyJCCG3/cZQ01lAI8/bzhN2ChoksnXlECP6s2Q5
        zDXaiX5bbyW3PQaHF+RckGnUZJtmZdv3cP/5LLvrcw==
X-Google-Smtp-Source: AGRyM1v9hiMjb+QWMEdJeXGRq/47gCmys36Vgg6njVoQP5wHj8e85n7mqoPDzhe5lc7M3J7dvSoQt44DVg8cX+U99Uk=
X-Received: by 2002:a25:aacc:0:b0:66f:f1ca:409c with SMTP id
 t70-20020a25aacc000000b0066ff1ca409cmr30608213ybi.36.1658412308298; Thu, 21
 Jul 2022 07:05:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220721120316.17070-1-ap420073@gmail.com>
In-Reply-To: <20220721120316.17070-1-ap420073@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 21 Jul 2022 16:04:57 +0200
Message-ID: <CANn89iJjc+jcyWZS1L+EfSkZYRaeVSmUHAkLKAFDRN4bCOcVyg@mail.gmail.com>
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

On Thu, Jul 21, 2022 at 2:03 PM Taehee Yoo <ap420073@gmail.com> wrote:
>
> mld works are supposed to be executed in mld_wq.
> But mld_{query | report}_work() calls schedule_delayed_work().
> schedule_delayed_work() internally uses system_wq.
> So, this would cause the reference count leak.

I do not think the changelog is accurate.
At least I do not understand it yet.

We can not unload the ipv6 module, so destroy_workqueue(mld_wq) is never used.



>
> splat looks like:
>  unregister_netdevice: waiting for br1 to become free. Usage count = 2
>  leaked reference.
>   ipv6_add_dev+0x3a5/0x1070
>   addrconf_notify+0x4f3/0x1760
>   notifier_call_chain+0x9e/0x180
>   register_netdevice+0xd10/0x11e0
>   br_dev_newlink+0x27/0x100 [bridge]
>   __rtnl_newlink+0xd85/0x14e0
>   rtnl_newlink+0x5f/0x90
>   rtnetlink_rcv_msg+0x335/0x9a0
>   netlink_rcv_skb+0x121/0x350
>   netlink_unicast+0x439/0x710
>   netlink_sendmsg+0x75f/0xc00
>   ____sys_sendmsg+0x694/0x860
>   ___sys_sendmsg+0xe9/0x160
>   __sys_sendmsg+0xbe/0x150
>   do_syscall_64+0x3b/0x90
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> Fixes: f185de28d9ae ("mld: add new workqueues for process mld events")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>  net/ipv6/mcast.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
> index 7f695c39d9a8..87c699d57b36 100644
> --- a/net/ipv6/mcast.c
> +++ b/net/ipv6/mcast.c
> @@ -1522,7 +1522,6 @@ static void mld_query_work(struct work_struct *work)
>
>                 if (++cnt >= MLD_MAX_QUEUE) {
>                         rework = true;
> -                       schedule_delayed_work(&idev->mc_query_work, 0);
>                         break;
>                 }
>         }
> @@ -1533,8 +1532,10 @@ static void mld_query_work(struct work_struct *work)
>                 __mld_query_work(skb);
>         mutex_unlock(&idev->mc_lock);
>
> -       if (!rework)
> -               in6_dev_put(idev);
> +       if (rework && queue_delayed_work(mld_wq, &idev->mc_query_work, 0))

It seems the 'real issue' was that
schedule_delayed_work(&idev->mc_query_work, 0) could be a NOP
because the work queue was already scheduled ?



> +               return;
> +
> +       in6_dev_put(idev);
>  }
>
>  /* called with rcu_read_lock() */
> @@ -1624,7 +1625,6 @@ static void mld_report_work(struct work_struct *work)
>
>                 if (++cnt >= MLD_MAX_QUEUE) {
>                         rework = true;
> -                       schedule_delayed_work(&idev->mc_report_work, 0);
>                         break;
>                 }
>         }
> @@ -1635,8 +1635,10 @@ static void mld_report_work(struct work_struct *work)
>                 __mld_report_work(skb);
>         mutex_unlock(&idev->mc_lock);
>
> -       if (!rework)
> -               in6_dev_put(idev);
> +       if (rework && queue_delayed_work(mld_wq, &idev->mc_report_work, 0))
> +               return;
> +
> +       in6_dev_put(idev);
>  }
>
>  static bool is_in(struct ifmcaddr6 *pmc, struct ip6_sf_list *psf, int type,
> --
> 2.17.1
>
