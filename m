Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA43242382
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 02:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgHLAsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 20:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgHLAsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 20:48:11 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67929C06174A;
        Tue, 11 Aug 2020 17:48:11 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id g19so830737ioh.8;
        Tue, 11 Aug 2020 17:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0XDgyn5BUfWSTBbklR5G9pMdaqRcJjaCci9jdLlWOiU=;
        b=ifuDOOFI2ZulTTZy5err/8h0FwMgYiiIidKn2aMbeCraw9vCxzGgQ+eqgFqLPzTK7n
         x+qxGHq2Y+oLA2ih08aW888aT1YQBwzKv8sRs0aRowvmlmYheifiSokqNNGbSJhbZW3G
         KFkkQZEfpvBc0KVsopTgZHKrBHUvCTo7P6bWvLG9lBgXXIqkC7v3di9d74SNSq/Ly25W
         8rdCpapuJ3hZy5VAbWIMMErvu6G7VrtXftk1ltusP2YHsrtu7z+42PEYacNjT0On0yr0
         YxxCvcC1GH1ivQ4F16Rr4Sqvpf+LrLq5S7zm/Dc3rhIpJbInXJYO4rbqxcwFW6qUKwyM
         U8jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0XDgyn5BUfWSTBbklR5G9pMdaqRcJjaCci9jdLlWOiU=;
        b=KuGazHn7w9DhW6vrYaINHW803v/+BnN8xNrD5bBCP82s7xNf4VZo9m1Et+wGr20QRK
         caP934NSLd++fnXB0qRQj2/I2dAaIv1V4J1Lcjb5hwzYv/eb7b21sBZ/PFDRqkvPgOGt
         OgQadB6WfwZt7SR8BA2Rc2YN+5rbMTsfP2Hw9hvtpFjvW2g/9UzdadQ+ZZK/OtroNlRQ
         VPQVZPP9h5DR9alUgecrUO01gDT1OPtck9NP9xDhj+2FoCxbthQU42Yl/JQvzEhuQLos
         noSw+RTBBGSdCDKs7c8/Al3H2JEYhmM62BaI0/sRxZcDwYGrz7lUTAEZgD5MA2+KUBeK
         i1Jw==
X-Gm-Message-State: AOAM5317VDf5iOdvSL7yG4f1yD86/j9YW7G0jVUbWnuFLKt2Wc/IXCbh
        zcnN8FPRLQ/OEaqAEajAucrexuB2TEbD4DXnzoCbZw==
X-Google-Smtp-Source: ABdhPJxWwLTeImwsj5VIsbnlOUDj74WtvkmdkuQMqptYzqv+dNeIsOU0JZwSBhL92bl/GRt8E9uqXgqeZfSfXU8u7/4=
X-Received: by 2002:a05:6638:250f:: with SMTP id v15mr29197761jat.75.1597193290690;
 Tue, 11 Aug 2020 17:48:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200811011001.75690-1-xiangxia.m.yue@gmail.com>
In-Reply-To: <20200811011001.75690-1-xiangxia.m.yue@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 11 Aug 2020 17:47:59 -0700
Message-ID: <CAM_iQpW5h=UCdhJQ7cKgihsn_NPRi8YjTes6R+TrA5WFfagSNA@mail.gmail.com>
Subject: Re: [PATCH] net: openvswitch: introduce common code for flushing flows
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        =?UTF-8?B?Sm9oYW4gS27DtsO2cw==?= <jknoos@google.com>,
        Gregory Rose <gvrose8192@gmail.com>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>, dev@openvswitch.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        rcu <rcu@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 6:14 PM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> To avoid some issues, for example RCU usage warning, we should
> flush the flows under ovs_lock. This patch refactors
> table_instance_destroy and introduces table_instance_flow_flush
> which can be invoked by __dp_destroy or ovs_flow_tbl_flush.
>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Please add a Fixes tag here, I think it is probably your memory leak fix
which introduced this issue. And a Reported-by, to give credits to bug
reporters.

Plus one minor issue below:

> -static void table_instance_destroy(struct flow_table *table,
> -                                  struct table_instance *ti,
> -                                  struct table_instance *ufid_ti,
> -                                  bool deferred)
> +/* Must be called with OVS mutex held. */
> +void table_instance_flow_flush(struct flow_table *table,
> +                              struct table_instance *ti,
> +                              struct table_instance *ufid_ti)
>  {
>         int i;
>
> -       if (!ti)
> -               return;
> -
> -       BUG_ON(!ufid_ti);
>         if (ti->keep_flows)
> -               goto skip_flows;
> +               return;
>
>         for (i = 0; i < ti->n_buckets; i++) {
> -               struct sw_flow *flow;
>                 struct hlist_head *head = &ti->buckets[i];
>                 struct hlist_node *n;
> +               struct sw_flow *flow;

This is at most a coding style change, please do not mix
coding style changes in bug fixes. You can always push coding
style changes separately when net-next is open.

Thanks.
