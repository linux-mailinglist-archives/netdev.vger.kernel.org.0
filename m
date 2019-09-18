Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE34B6EEF
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 23:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732119AbfIRVhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 17:37:34 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40569 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbfIRVhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 17:37:34 -0400
Received: by mail-pf1-f195.google.com with SMTP id x127so829880pfb.7
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 14:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f6CI0OqiTk17UBvDR4/Iiv2nq/LDhecI+PY0tsbowgM=;
        b=GM9U91zwT/EWPcGSd6BLxBMoY92eKFUIEkG/l0GknDKSUP1Z2FK40Tt3MEj99/2A+r
         bypkOpDfvzfYa8LFpC0wiVyizFTKc5X7/1UyT4daol1nll2yE+QQ9tb6ebQaqlt12ERN
         J5glqLOgkPgNrpTAPlp/EnMIpNiKrF7lyhKLF3PDImuN3LHnzbE1aFVlxj8NHZ5/YORS
         2Cq+/2R7FEU0gbP5YsjR6VHAc4gQvWPh7j7gDeZpDG4PGwv7wUhO62/LYF7OeMW3X1Ri
         Uj2MrsN6SNGeQ12rzVMf3o+yb5SW6E6uSXlsFmGKr5JYWNnwahKObeyqaRyiIQ/JpdaY
         hVfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f6CI0OqiTk17UBvDR4/Iiv2nq/LDhecI+PY0tsbowgM=;
        b=BxKAbdwbnlWUc94mSpNAtucT4CO5zk8bd6xq3gg/NhCiBgeeaYTztGGhRWk1DTRzXk
         TYU1HWQT4xHtdd49+KNCn7zPYJ56qdVcIxJqFYpjk+RxImdux5o9FOWEOFssC+9zVSU9
         tdeDqSXmVRg4BlaF1gzJU1FbvE47a1Xchm0Rd72tIw5FrHPgyD0Iv1Cnx+HYMBCbctUl
         yGTBwaHgjivueZlw7MaJGp2A+9gqElv+QuwCNmVeV8760AIQpF78DNpVK+7nepeQFhSp
         vNk/0czcRh7rAqtifDx2VMpq8F8NI30vS8hzGoLZ0q4Y+7TTrhJkr722KP6SDGdZlqJs
         zdAA==
X-Gm-Message-State: APjAAAUlJrWzkSrw8ctdFvTkUEaHt8ShGR9Zx+ChqHvksXvPU9rtHbeC
        mxnJdUMO0SK05gyMvZ7G8G+vU/ruw3uPb8MtXBA=
X-Google-Smtp-Source: APXvYqySic/a+pVqG46s/uUROzbFqSLX2oOw7AEd7Kw1SETH1xg1XYXq77h1xSYd7GHUbqRhr0scZfT+hPUNbXQ3K40=
X-Received: by 2002:aa7:8ac3:: with SMTP id b3mr6439811pfd.242.1568842653763;
 Wed, 18 Sep 2019 14:37:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190918195704.218413-1-edumazet@google.com>
In-Reply-To: <20190918195704.218413-1-edumazet@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 18 Sep 2019 14:37:21 -0700
Message-ID: <CAM_iQpVyJDeScQDL6vHNAN9gu5a3c0forQ2Ko7eQihawRO_Sdw@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: fix possible crash in tcf_action_destroy()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 12:57 PM 'Eric Dumazet' via syzkaller
<syzkaller@googlegroups.com> wrote:
>
> If the allocation done in tcf_exts_init() failed,
> we end up with a NULL pointer in exts->actions.
...
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index efd3cfb80a2ad775dc8ab3c4900bd73d52c7aaad..9aef93300f1c11791acbb9262dfe77996872eafe 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3027,8 +3027,10 @@ static int tc_dump_chain(struct sk_buff *skb, struct netlink_callback *cb)
>  void tcf_exts_destroy(struct tcf_exts *exts)
>  {
>  #ifdef CONFIG_NET_CLS_ACT
> -       tcf_action_destroy(exts->actions, TCA_ACT_UNBIND);
> -       kfree(exts->actions);
> +       if (exts->actions) {

I think it is _slightly_ better to check exts->nr_actions!=0 here,
as it would help exts->actions!=NULL&& exts->nr_actions==0
cases too.

What do you think?
