Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12AF65DD6F
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 21:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235189AbjADUMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 15:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbjADUMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 15:12:41 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A9411C3A
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 12:12:39 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id d9so5633961wrp.10
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 12:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=t3m5rm0vLEhNoLeXbWadc3tr+UJkLBN4vKcrwKu3c4Y=;
        b=iKoOMwnktLlUy3dFHkImmBr3gWWah+qYAVtZ8+thpfNaoW/BM8wsUxMQtHCo/spDey
         yxMuwcTJRHp5xz0y/QUmDd4ym5abSjTqvsfY3NtdHsjO7t0DVEBmp225kjlvDQuhfnWJ
         aoARQvwEpTKn+lwPF/CFM6x2iqB+z983of/IqE83HlDtZGLyudUQNC4m+bMHwj01TRDD
         xdSocQQAmZyCgPBmmdC2RMC63rx8jh9JrOdnc3WMf5RFI69uwDNcTQmG4VGq+f7oGZ39
         dClAEe4meUzeuVPM+dbteE6B7tf6z87+PMGd5Em+SOpPvZA5+X6E4UGucgsC0CaEP2Kp
         zbPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t3m5rm0vLEhNoLeXbWadc3tr+UJkLBN4vKcrwKu3c4Y=;
        b=hpP9+9bnYrzVXsV2YkEb6tiOnaYL6sY1xUIPsFDR/hlFont1zMQksZMdqJxkAATvwK
         nu/6YDJLWX2iarjZLRLMssux5hF8WXDzrcOWvim2CF/8OJ7Tt6ybvJd7XouGfMxCDUpN
         88xW7msxWEeCqDrijTMqe67AUBH4hcT9YUy9WKqihtJTBBqWyr4FMlIsBfAZhW+WHeAS
         iapmpgOkS7wHcaFlStAstCYN1ZsjbluGxvCpMbR0Yj2qOd0RpCWFEyWmyxuV22izOEyL
         KMWZ+YYaCQH+dMSb6iPPjlpSkolUY+491lZtmxN/DYvtG/zm6e68T5Fa7ERghH/A9R9Q
         N/CA==
X-Gm-Message-State: AFqh2kqRKAzZ5yb5bDtAuPrdw4TyT4LzteRAZj6xuzpnDGPA6rQZO7BE
        K1p0ALVbLEFd0j5k5EsMUvmHRNrPtCH6sjYD9w4GHAg75r/ijUvw
X-Google-Smtp-Source: AMrXdXuO3sLGQk6SKEgR5FugSbQCGIbLOqocXS/sVMQJdt6f7qDopDBAYXzfAVV4Qym8O+c+IPdNLhi8oKMkmyYNrpE=
X-Received: by 2002:a05:6000:1f98:b0:2ae:e70f:4c20 with SMTP id
 bw24-20020a0560001f9800b002aee70f4c20mr36125wrb.615.1672863158285; Wed, 04
 Jan 2023 12:12:38 -0800 (PST)
MIME-Version: 1.0
References: <20230104174744.22280-1-rrameshbabu@nvidia.com>
In-Reply-To: <20230104174744.22280-1-rrameshbabu@nvidia.com>
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
Date:   Wed, 4 Jan 2023 22:12:11 +0200
Message-ID: <CAKErNvojEx1jeWfqoo+CA3iSJpc2URVbUvmdc=QtVEuif4_YNQ@mail.gmail.com>
Subject: Re: [PATCH net] sch_htb: Fix prematurely activating netdev during htb_destroy_class_offload
To:     Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Jan 2023 at 19:53, Rahul Rameshbabu <rrameshbabu@nvidia.com> wrote:
>
> When the netdev qdisc is updated correctly with the new qdisc before
> destroying the old qdisc, the netdev should not be activated till cleanup
> is completed. When htb_destroy_class_offload called htb_graft_helper, the
> netdev may be activated before cleanup is completed.

Oh, so that's what was happening! Now I get the full picture:

1. The user does RTM_DELQDISC.
2. qdisc_graft calls dev_deactivate, which sets dev_queue->qdisc to
NULL, but keeps dev_queue->qdisc_sleeping.
3. The loop in qdisc_graft calls dev_graft_qdisc(dev_queue, new),
where new is NULL, for each queue.
4. Then we get into htb_destroy_class_offload, and it's important
whether dev->qdisc is still HTB (before Eric's patch) or noop_qdisc
(after Eric's patch).
5. If dev->qdisc is noop_qdisc, and htb_graft_helper accidentally
activates the netdev, attach_default_qdiscs will be called, and
dev_queue->qdisc will no longer be NULL for the rest of the queues,
hence the WARN_ON triggering.

Nice catch indeed, premature activation of the netdev wasn't intended.

> The new netdev qdisc
> may be used prematurely by queues before cleanup is done. Call
> dev_graft_qdisc in place of htb_graft_helper when destroying the htb to
> prevent premature netdev activation.
>
> Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
> Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> Acked-by: Saeed Mahameed <saeedm@nvidia.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
> ---
>  net/sched/sch_htb.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
> index 2238edece1a4..f62334ef016a 100644
> --- a/net/sched/sch_htb.c
> +++ b/net/sched/sch_htb.c
> @@ -1557,14 +1557,16 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
>
>         WARN_ON(!q);
>         dev_queue = htb_offload_get_queue(cl);
> -       old = htb_graft_helper(dev_queue, NULL);
> -       if (destroying)
> +       if (destroying) {
> +               old = dev_graft_qdisc(dev_queue, NULL);
>                 /* Before HTB is destroyed, the kernel grafts noop_qdisc to
>                  * all queues.
>                  */
>                 WARN_ON(!(old->flags & TCQ_F_BUILTIN));

Now regarding this WARN_ON, I have concerns about its correctness.

Can the user replace the root qdisc from HTB to something else with a
single command? I.e. instead of `tc qdisc del dev eth2 root handle 1:`
do `tc qdisc replace ...` or whatever that causes qdisc_graft to be
called with new != NULL? If that is possible, then:

1. `old` won't be noop_qdisc, but rather the new qdisc (if it doesn't
support the attach callback) or the old one left from HTB (old == q,
if the new qdisc supports the attach callback). WARN_ON should
trigger.

2. We shouldn't even call dev_graft_qdisc in this case (if destroying
is true). Likewise, we shouldn't try to revert it on errors or call
qdisc_put on it.

Could you please try to reproduce this scenario of triggering WARN_ON?
I remember testing it, and something actually prevented me from doing
a replacement, but maybe I just missed something back then.

> -       else
> +       } else {
> +               old = htb_graft_helper(dev_queue, NULL);
>                 WARN_ON(old != q);
> +       }
>
>         if (cl->parent) {
>                 _bstats_update(&cl->parent->bstats_bias,
> --
> 2.36.2
>
