Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB995225FF
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 23:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbiEJVCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 17:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235548AbiEJVBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 17:01:36 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6861FA6E34;
        Tue, 10 May 2022 14:01:35 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id x88so330886pjj.1;
        Tue, 10 May 2022 14:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j3rcz6qVNZi20/uUbB9766ZMC6kcEWw22DciqK9/zDQ=;
        b=M5ccWIy7d+bh8DqBj2aI3HFZZKskE0cwfDgQq3SKLrVgdAEFxXFPBkEBMgJ4qngmA2
         6H8woKrDHM1reouusOvd4aPscHfCRI6hEodeZJsd4D6vPzWpj+/ESYcRIaKuxdIo+A+Q
         REO2UUrR8BzAZBYQDBIpzFkYPdqzj+joI8K38ONynFtD+rXLjCemnJJiB6b4CFMkjshY
         CYR1R/+q+MdBzjd4wFuiVS17ecBinIwmowmWql+VGUH65xm+Uu8/uHde/uKwZ03XLtU1
         905SUSDqeXRgRwg7ZHM6aBsoRSIR0O+RAeQn1ZgTa7JGGDNCVlqjo9fhIzsr4tSQQYUz
         Sx6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=j3rcz6qVNZi20/uUbB9766ZMC6kcEWw22DciqK9/zDQ=;
        b=PuKCPaS0HAsSgcgGWarDJAeAuq/XZCODbc8Y8ueM9uOubhSOSuc2+yJsirFQ9Q/9H2
         dbMPqAWwzqJSV+J3HgK1VY+ZChtMU/KchCUCnROPvmwljKmCUzWlGPPdiqtIYOFv9UIx
         jqFBeZknXRQtjtJp2eKiTUETqqJeIa+SZBC6zZsMAFu95wDG1OOC+FQxakRQ6yQxfdiR
         qxsd1j/Xi1GfBjLV5sCXBhT+yCzlrw+CtE2wVtrjofUvY0APfFPKh8XBJGNw0ELOEwpX
         bR21oPc/Wo6VdsMC6QCN9RNJ52TBKAAG/wrMB38chIpGu050hnnQyu8uoeLAlUkUN68j
         WDGw==
X-Gm-Message-State: AOAM531m4bsLk/SaREZ7hMrUtGmAu1rpb18G2gWnYVHAYrvKW0xlcvy5
        KgJYCHU4MU/RC1eQe3BRjwI=
X-Google-Smtp-Source: ABdhPJy9jdEXmmo87FTb0xRrE+zHyYpgKETtEix579sUr19jNrUhpmBxb5moGjeyn6lcojK04HS9pw==
X-Received: by 2002:a17:902:ce02:b0:153:bd65:5c0e with SMTP id k2-20020a170902ce0200b00153bd655c0emr22083797plg.160.1652216494792;
        Tue, 10 May 2022 14:01:34 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::4:6c64])
        by smtp.gmail.com with ESMTPSA id j4-20020a632304000000b003c15f7f2914sm162632pgj.24.2022.05.10.14.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 14:01:34 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 10 May 2022 11:01:32 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        cgroups@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next 1/9] bpf: introduce CGROUP_SUBSYS_RSTAT
 program type
Message-ID: <YnrSrKFTBn3IyUfa@slm.duckdns.org>
References: <20220510001807.4132027-1-yosryahmed@google.com>
 <20220510001807.4132027-2-yosryahmed@google.com>
 <Ynqyh+K1tMyNCTUW@slm.duckdns.org>
 <CAJD7tkZVXJY3s2k8M4pcq+eJVD+aX=iMDiDKtdE=j0_q+UWQzA@mail.gmail.com>
 <YnrEDfZs1kuB1gu5@slm.duckdns.org>
 <CAJD7tkahC1e-_K0xJMu-xXwd8WNVzYDRgJFua9=JhNRq7b+G8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJD7tkahC1e-_K0xJMu-xXwd8WNVzYDRgJFua9=JhNRq7b+G8A@mail.gmail.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, May 10, 2022 at 01:43:46PM -0700, Yosry Ahmed wrote:
> I assume if we do this optimization, and have separate updated lists
> for controllers, we will still have a "core" updated list that is not
> tied to any controller. Is this correct?

Or we can create a dedicated updated list for the bpf progs, or even
multiple for groups of them and so on.

> If yes, then we can make the interface controller-agnostic (a global
> list of BPF flushers). If we do the optimization later, we tie BPF
> stats to the "core" updated list. We can even extend the userland
> interface then to allow for controller-specific BPF stats if found
> useful.

We'll need that anyway as cpustats are tied to the cgroup themselves rather
than the cpu controller.

> If not, and there will only be controller-specific updated lists then,
> then we might need to maintain a "core" updated list just for the sake
> of BPF programs, which I don't think would be favorable.

If needed, that's fine actually.

> What do you think? Either-way, I will try to document our discussion
> outcome in the commit message (and maybe the code), so that
> if-and-when this optimization is made, we can come back to it.

So, the main focus is keeping the userspace interface as simple as possible
and solving performance issues on the rstat side. If we need however many
updated lists to do that, that's all fine. FWIW, the experience up until now
has been consistent with the assumptions that the current implementation
makes and I haven't seen real any world cases where the shared updated list
are problematic.

Thanks.

-- 
tejun
