Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B71395523DA
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 20:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245383AbiFTS3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 14:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238810AbiFTS3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 14:29:10 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16522140B7
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 11:29:09 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id g8so10462819plt.8
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 11:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7sC/LkpqrzifaVuj/tRzbNz64Tj2h1uGYfKvsYILqdE=;
        b=XIr9YEmX+1nR6UUBkSWHQqRVBixoyURbH4gKyNh3VA9B74Exq6ZgW5ogb/m90crBzN
         bfHdX7Z8ACkBOXO/Ovm5VmUIsbjV95o/I1yPP613vzG5t9gKWyH9kvrdMnFjRlBLupAm
         7YoW1Se0osjCk6QEUlon7EAikIvjcdaB93NKYVVIkhlcD9nOxBcTB1jO9Z221ksPPGc/
         XJRiVRZX2+4r/+oFnADUE67p9hpGajdg22B8LZoo+6YJgPENmESIjGsXOhSDtZjUyLE2
         +iwJctqIQeKgJk5pgQG9HOdv+65Qs+GdOowkh0FbdYEB7JSeVuZ2w2jHCvUgs0l5oaWo
         25+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7sC/LkpqrzifaVuj/tRzbNz64Tj2h1uGYfKvsYILqdE=;
        b=1rem1ot+/3uLk6QRLjC0AxeSOSnb6W/AvhudkDPioTLGwZfWxKoQlcBmuAXnCyV5sU
         POKEFEotjw2+YbvHKPNJ8o2feINChWAsaMAV6TB4DvXiBF2rw3B7m2H5wMRd6mwSqTQy
         3nzpWCHsOBP1VhOCJEzgGv17ulsZmGajGGWmequy0mKvXPifBdaSzdHOZtJguDduV2mp
         M7BcgImr3/EQSQf5fKTwGH1nX5nJsgIEtQ+BM7LmILt+Qxzstg0Bv60QoS5z9oyx37kv
         kLvsGF/bCXIkajh1cfEW6uTS/vpACPWLf89zXoKuZWy+xCjzGXBkUWBB5ML7OhBWyALf
         BSMg==
X-Gm-Message-State: AJIora9lTXmjjOCsG7F2yLyyXFV4SJ1XvdagfAMYqwK3K+LtfsMDW7ld
        Qf2gsahbA74hK2/KEr5BURNvr+nVgBYZX2TYn328sf8GX1o=
X-Google-Smtp-Source: AGRyM1tk/IpiQ4NitWTxo1rH9JsC0+YRi1t8SltKl4loT51OmMOEPUBjNs9PPdbJ68ZnFuoyu4Qe5FJAemXssHM9A+w=
X-Received: by 2002:a17:903:1c2:b0:163:ef7b:e10f with SMTP id
 e2-20020a17090301c200b00163ef7be10fmr24630166plh.158.1655749748372; Mon, 20
 Jun 2022 11:29:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220618061840.1012529-1-chenzhen126@huawei.com>
In-Reply-To: <20220618061840.1012529-1-chenzhen126@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 20 Jun 2022 11:28:57 -0700
Message-ID: <CAM_iQpU00eJ3+_0-jQh-Fe7WN-v6ig-mfAfym=m6PTZjc9r--w@mail.gmail.com>
Subject: Re: [Patch net] net_sched: cls_route: free the old filter only when
 it has been removed
To:     chenzhen 00642392 <chenzhen126@huawei.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Chenxiang (EulerOS)" <rose.chen@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 17, 2022 at 11:20 PM chenzhen 00642392
<chenzhen126@huawei.com> wrote:
>
> From: Zhen Chen <chenzhen126@huawei.com>
>
> Syzbot reported a ODEBUG bug in route4_destroy(), it is actually a
> use-after-free issue when route4_destroy() goes through the hashtable.
>
> The root cause is that after route4_change() inserts a new filter into the
> hashtable and finds an old filter, it will not remove the old one from the
> table if fold->handle is 0, but free the fold as the final step.

This seems reasonable but see below.

>
> Fix this by putting the free logic together with the remove action.

This does not look correct. You just move the deletion logic upper to
a narrowed case. The if case you moved to also does the deletion
without your patch, so I fail to see how this could solve the problem.

If we just follow your logic here, should we have the following patch
instead? But I am still not sure whether we need to treat the 0 handle
special here.

diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index a35ab8c27866..758c21f9d628 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -526,7 +526,7 @@ static int route4_change(struct net *net, struct
sk_buff *in_skb,
        rcu_assign_pointer(f->next, f1);
        rcu_assign_pointer(*fp, f);

-       if (fold && fold->handle && f->handle != fold->handle) {
+       if (fold && f->handle != fold->handle) {
                th = to_hash(fold->handle);
                h = from_hash(fold->handle >> 16);
                b = rtnl_dereference(head->table[th]);
