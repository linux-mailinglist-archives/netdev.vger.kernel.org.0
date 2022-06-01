Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D06F53A141
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 11:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351550AbiFAJul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 05:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349979AbiFAJui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 05:50:38 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D34E3120E;
        Wed,  1 Jun 2022 02:50:37 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id q21so2637351ejm.1;
        Wed, 01 Jun 2022 02:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zr1dEqY8ItmKj6ohcCJC2RtP4ZcxWkAs3yQd+Txnzkw=;
        b=NbSD0Fzfdi4WUSxPtr2kR4w0l3Nd3CxV5KtHEJzuaEdXGauwqzKScfMeas0qdMZvB0
         jBZ82G0LIjI6b3dLgUUOvRksGXMmo96wF0pcA2aMvkUiF0hWzA0lmcF+y8ILvJpuykS6
         o9yIZP+mjEWpO7AhrMkLK0vcSjZHKbrOas1oeQPSgLDJeWuB6fEVRz3qZfw/YBU5acwf
         NJarW5fNLvmAH10mcrTMFsnXZRT8+MTcZVXIafmBt2wVkFjuJv53msqKyFu5JMiHFA/n
         CV4DSW//5ARJi3YFrDUu7Le39KtAa1eYZBmYsoirkhKWR10Mx9/CZ5xKLn/nxz2NRzt1
         S3GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zr1dEqY8ItmKj6ohcCJC2RtP4ZcxWkAs3yQd+Txnzkw=;
        b=Ik2IrMJqCfKboZXD1t5USQ/5xra3NABsBfdGnlGa7x/c82PaQtGrTyG8u+Tuarm4tf
         0nLXff8U/Xnw3iIKIF6Ci9tyH/jqUUbW/gQyLA2ZJpYS458UlR4RfwW5RY4keAF74fUB
         3kvTQC2p7IvoI3RSz8I1hq0iFhUHPvm/yyUfVvyPrF0KiHtYmlRsiAnyh5CMO9Du8Bnw
         eRTeOuN+ientUkcRlZRlk39ZpUFWfEQqROs5eqDmZX7cWlXkArD5nng94FXBGHQrbtKj
         7/7k1s02N271sfgnO41KweRE+hfDUOy/7nOj7MiWUkDBy1iDxTKaFu5vH9p3P9HZlURs
         vLiQ==
X-Gm-Message-State: AOAM533FGMtZ3p86KbRhjvvmlO4sLOG0uSYEDuZZc7Bcs2UglT8nNn5g
        p3t5jA4CSufl/sShVEpWqGbDDPVAmFX5atISNSg=
X-Google-Smtp-Source: ABdhPJxqaqpBZBYLdiostxr4W50UUd7RNPPL2tAsq8mQoC7Kn3GrovtFdMCboYpRkLzTj97+v+mTWnrKiHGKi4SP/i4=
X-Received: by 2002:a17:907:3da1:b0:6fe:ae46:997d with SMTP id
 he33-20020a1709073da100b006feae46997dmr49788697ejc.633.1654077035904; Wed, 01
 Jun 2022 02:50:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220601084149.13097-1-zhoufeng.zf@bytedance.com> <20220601084149.13097-2-zhoufeng.zf@bytedance.com>
In-Reply-To: <20220601084149.13097-2-zhoufeng.zf@bytedance.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 1 Jun 2022 11:50:23 +0200
Message-ID: <CAADnVQJcbDXtQsYNn=j0NzKx3SFSPE1YTwbmtkxkpzmFt-zh9Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] bpf: avoid grabbing spin_locks of all cpus when no
 free elems
To:     Feng zhou <zhoufeng.zf@bytedance.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
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

On Wed, Jun 1, 2022 at 10:42 AM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
>
>  static inline void ___pcpu_freelist_push(struct pcpu_freelist_head *head,
> @@ -130,14 +134,19 @@ static struct pcpu_freelist_node *___pcpu_freelist_pop(struct pcpu_freelist *s)
>         orig_cpu = cpu = raw_smp_processor_id();
>         while (1) {
>                 head = per_cpu_ptr(s->freelist, cpu);
> +               if (READ_ONCE(head->is_empty))
> +                       goto next_cpu;
>                 raw_spin_lock(&head->lock);
>                 node = head->first;
>                 if (node) {

extra bool is unnecessary.
just READ_ONCE(head->first)
