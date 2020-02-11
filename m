Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D843315989A
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 19:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731252AbgBKS3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 13:29:02 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42702 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730269AbgBKS3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 13:29:02 -0500
Received: by mail-qk1-f195.google.com with SMTP id q15so11052631qke.9;
        Tue, 11 Feb 2020 10:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D3SbOLV3+Uwj2Ppxr4M7HZACrTHgbipsb6A6sIbX/XU=;
        b=ZStZY4hbUoElUqoLRXtfCZM3Kst7j8iOc7yz+oU6viixZozDF8J0CESeSIUpYBg16F
         WfE03aN+R2HsdWRRLH/LGD9JeCd0OJh/NsEYGyvEdbCYh3J0+4eUXq5OujG21Q2Q39hM
         2riNNsKRBq5jCc3Ja689LbUyVhzfyNg50RBnmGefhFme/mRmkUuBfov1YNCoksdgw5VL
         +zhJIihi2DlrgUAKJHL4/IZ0StRaqxfPqcGwBe++FwAfsBZjyN+HSk5F6rezpa76viQH
         EQhNHlgMVHMhi0GLs1pZysrua1EfAstg2g3kf8i4v5UQc0nKOmMYv17ANankkvUJe4J9
         F49w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D3SbOLV3+Uwj2Ppxr4M7HZACrTHgbipsb6A6sIbX/XU=;
        b=q3BL6RR8+gdozyl/0CI0TUVjz/65TZkFKWgxYS8lL3m6+kujQDuntHN9ZZwvaHavS3
         e70sZRcX8s7hxTG0LoDwlk0zy/wYa9IrkeV9IBMPZOMaix4HI/6f+pT2t3Nh2OlfC67/
         3OrSCjH81rrhGojME3s+xNxydd7IhDapPxTFXebczCLhhKTSidiigFDwwKRh4ATpApdS
         B/Ok5wUDqLH4Y1KWmmddqjvRSQpa0wNkLjNs5PTfofzVofEbn/ITZwNFZ27CDlr2Cmd0
         6kZzxoNQLkxesGSLfXjJxwsAeewjGw/IepITJS+3Et/H7+2lyw6Xc6kgXl14LbYz/6hf
         1Kwg==
X-Gm-Message-State: APjAAAV5BXlYq3XLRrOVgw2q+R8v77+CH/9rqTP9gCdOAbDu5evf5U3h
        bjpR5o2sBkouPuEKoeUayvGZtUbeZgKllRwiOJGNOg==
X-Google-Smtp-Source: APXvYqw8APBhftBW2ys+3AzjeuazWJkrIRvqCympD++QNyLzMb/cA/j+caLSN42Om3aHGRzmE4USgIS5Rn+iIrTS8pM=
X-Received: by 2002:a37:2744:: with SMTP id n65mr7411848qkn.92.1581445741252;
 Tue, 11 Feb 2020 10:29:01 -0800 (PST)
MIME-Version: 1.0
References: <20200208154209.1797988-1-jolsa@kernel.org> <20200208154209.1797988-11-jolsa@kernel.org>
In-Reply-To: <20200208154209.1797988-11-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 11 Feb 2020 10:28:50 -0800
Message-ID: <CAEf4Bzb-J67oKcKtB-7TsO7wD7bnp57NAgqNJW9giZrhrqu_+g@mail.gmail.com>
Subject: Re: [PATCH 10/14] bpf: Re-initialize lnode in bpf_ksym_del
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 8, 2020 at 7:43 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> When bpf_prog is removed from kallsyms it's on the way
> out to be removed, so we don't care about lnode state.
>
> However the bpf_ksym_del will be used also by bpf_trampoline
> and bpf_dispatcher objects, which stay allocated even when
> they are not in kallsyms list, hence the lnode re-init.
>
> The list_del_rcu commentary states that we need to call
> synchronize_rcu, before we can change/re-init the list_head
> pointers.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Wouldn't it make more sense to have patches 7 though 10 as a one
patch? It's a generalization of ksym from being bpf_prog-specific to
be more general (which this initialization fix is part of, arguably).

>  kernel/bpf/core.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 73242fd07893..66b17bea286e 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -676,6 +676,13 @@ void bpf_ksym_del(struct bpf_ksym *ksym)
>         spin_lock_bh(&bpf_lock);
>         __bpf_ksym_del(ksym);
>         spin_unlock_bh(&bpf_lock);
> +
> +       /*
> +        * As explained in list_del_rcu, We must call synchronize_rcu
> +        * before changing list_head pointers.
> +        */
> +       synchronize_rcu();
> +       INIT_LIST_HEAD_RCU(&ksym->lnode);
>  }
>
>  static bool bpf_prog_kallsyms_candidate(const struct bpf_prog *fp)
> --
> 2.24.1
>
