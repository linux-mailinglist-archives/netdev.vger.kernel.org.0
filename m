Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474E266BCF1
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 12:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjAPLbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 06:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjAPLbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 06:31:10 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4361DBB3
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 03:31:07 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id vw16so4224617ejc.12
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 03:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=SAOnHwXPVdXtwryZfI27E5TBP69wt16pOek6ktQQ6k4=;
        b=YPSxKdyv0vemU3n3JeBYbWHou1RxJV+ZCMpOJ7hPMdx5tZtYicYHOui+jxhh+tyP2u
         rKfjR+NYG6nJKaWYJ2nHV9ka5Ocuuq9vHvAX7MnwHVc5t73GJ500oA4u6OhnUmaIGxxy
         h2uVA7B5bKCEz67iqSKGh23bdiu5Ty3Cu0VrA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SAOnHwXPVdXtwryZfI27E5TBP69wt16pOek6ktQQ6k4=;
        b=TiZ1BrgjwIZPJcjgJIYQuFVFF/FYwuFGX6dZRau6BKSYxAPyuqeocWpHdS8q8Q79pv
         dMydfVSheoib1E5ztTTdeSZfQfC5kvlxPQAoNpCCP6OJpUyUI2QpbiXnIYMxjUqQyPQi
         ghCTIgGD8Y/mHavzN7Sa+9ix8hHn0HDDTjtB1mgw3cAH+jdRjwBS7UwzXb4pB4+65ktg
         s5bHagfMv/Y0W3iz46WaVxkWegO2trvis9U6n3EB3g6RhTtD8RcZy1FeysHvAVwFgugR
         xkkBPEiI+tdrQJ88+KcNgyTkcR1KnBWxtyuXGFkbMKedC4sU9VarYOMWzfkpMd8MkGqw
         bgiA==
X-Gm-Message-State: AFqh2koS1lEeaj+ETC2QTizfW9TkUjCbeU9cKhas2bY7oF6iAsBhTHj/
        YFdjjGK2k6WjwRKi7uJmJGnDbw==
X-Google-Smtp-Source: AMrXdXszUtRHn1sJvd2uIBJcBgsvnMr1m2Iqr0V4lqgHz6GwPtmxkNqKtoaZku1DmjVLfTfNQEOeGg==
X-Received: by 2002:a17:906:3687:b0:86b:914a:571 with SMTP id a7-20020a170906368700b0086b914a0571mr10054431ejc.5.1673868666301;
        Mon, 16 Jan 2023 03:31:06 -0800 (PST)
Received: from cloudflare.com (79.184.151.107.ipv4.supernova.orange.pl. [79.184.151.107])
        by smtp.gmail.com with ESMTPSA id p21-20020a056402045500b0048aff8b5b70sm11257374edw.67.2023.01.16.03.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 03:31:05 -0800 (PST)
References: <20230113-sockmap-fix-v1-1-d3cad092ee10@cloudflare.com>
 <202301141018.w4fQc4gd-lkp@intel.com> <87sfgayeg9.fsf@cloudflare.com>
 <CANn89iLanM-OJu8hThK__G_gQj0z39Rnj-5Fk=kQEmbhs2OPfA@mail.gmail.com>
User-agent: mu4e 1.6.10; emacs 28.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Dan Carpenter <error27@gmail.com>, oe-kbuild@lists.linux.dev,
        netdev@vger.kernel.org, lkp@intel.com,
        oe-kbuild-all@lists.linux.dev, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        syzbot+04c21ed96d861dccc5cd@syzkaller.appspotmail.com
Subject: Re: [PATCH bpf 1/3] bpf, sockmap: Check for any of tcp_bpf_prots
 when cloning a listener
Date:   Mon, 16 Jan 2023 12:27:10 +0100
In-reply-to: <CANn89iLanM-OJu8hThK__G_gQj0z39Rnj-5Fk=kQEmbhs2OPfA@mail.gmail.com>
Message-ID: <87lem2yavb.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 11:39 AM +01, Eric Dumazet wrote:
> We might add a generic helper to make all this a bit more clear ?
>
> +#define is_insidevar(PTR, VAR) (                       \
> +       ((void *)(PTR) <= (void *)(VAR)) &&             \
> +       ((void *)(PTR) <= (void *)(VAR) + sizeof(VAR)))
> +
>
>
> ...
>
> if (is_insidevar(prot, tcp_bpf_prots))
>      newsk->sk_prot = sk->sk_prot_creator;

Sure can do. Thanks for the suggestion. I adjusted it a bit:
 - added cast to char * so we don't offend -Wpointer-arith,
 - fixed the lower and upper bound check.

Final form would look like:

#define is_insidevar(ptr, var)						\
	((void *)(ptr) >= (void *)(var)) &&				\
	((void *)(ptr) <  (void *)((char *)(var) + sizeof(var)))

Not sure where to stuff it. I propose include/linux/util_macros.h.
