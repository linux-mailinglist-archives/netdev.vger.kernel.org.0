Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE9934EC64E
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 16:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346690AbiC3OR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 10:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346662AbiC3OR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 10:17:26 -0400
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BD22A0449;
        Wed, 30 Mar 2022 07:15:40 -0700 (PDT)
Received: by mail-ed1-f52.google.com with SMTP id b24so24568060edu.10;
        Wed, 30 Mar 2022 07:15:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=osaI5vDvyie0naGhC7jW0FhuMDO52O2msNUBsd7/5oo=;
        b=Zkf6M0wl8XaVBVjBgWEvu5vdloLO9ll+oCUY23tNzgcaj2/EL+tEJXDbQbJ5a47faK
         rAzoh9UGYI0a9OvxidB8kFSMWXQAb1D7CahliTFw1rfHh/Pqh0+Qt28d0uXr3msmprcX
         KKU1236XvE8SyTEFOPRBBCELwgXGvT38v3AWpgWH3E41ATVh6PzhZqsQCIY+lI0nS5Xk
         ovBtm8O7s04DPXpkVLUpsfRks4rf5/7lj6tt/Q2MeS+oRBHsqKHXupaXDxM18k+uZDcj
         A/OG2TrKvrl6seDYimqQI/YBAqIsjE24uOYe8U+VVJhMfEX7azp5Lt182YjIutShWviQ
         UPYg==
X-Gm-Message-State: AOAM532hu6X+9v47Hc4327ze5qYDM0EfkhFEf8QSCvUPgN4h376MHFaf
        f+vVWPtbpGITxrjp/2QH9rBruxJqm4hGGA==
X-Google-Smtp-Source: ABdhPJz0sOg+N4zreJFTKa355Pn6fTGTHnQqLJmEkzHqshBwKf/W4i1nx8hUsLDy0Lq4KdyAZ4iUzQ==
X-Received: by 2002:a05:6402:50c9:b0:419:3019:2d35 with SMTP id h9-20020a05640250c900b0041930192d35mr11080053edb.95.1648649738803;
        Wed, 30 Mar 2022 07:15:38 -0700 (PDT)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com. [209.85.128.50])
        by smtp.gmail.com with ESMTPSA id qk32-20020a1709077fa000b006df6bb30b28sm8186582ejc.171.2022.03.30.07.15.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 07:15:38 -0700 (PDT)
Received: by mail-wm1-f50.google.com with SMTP id k124-20020a1ca182000000b0038c9cf6e2a6so63273wme.0;
        Wed, 30 Mar 2022 07:15:37 -0700 (PDT)
X-Received: by 2002:a7b:ce1a:0:b0:38c:eb9c:d522 with SMTP id
 m26-20020a7bce1a000000b0038ceb9cd522mr4617532wmc.113.1648649737669; Wed, 30
 Mar 2022 07:15:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220322162822.566705-1-butterflyhuangxx@gmail.com>
In-Reply-To: <20220322162822.566705-1-butterflyhuangxx@gmail.com>
From:   Marc Dionne <marc.dionne@auristor.com>
Date:   Wed, 30 Mar 2022 11:15:26 -0300
X-Gmail-Original-Message-ID: <CAB9dFdvLNPTkgzv5GJ9Mwdtpz-sk0XYWQ25hqxcpT_NPufnuKQ@mail.gmail.com>
Message-ID: <CAB9dFdvLNPTkgzv5GJ9Mwdtpz-sk0XYWQ25hqxcpT_NPufnuKQ@mail.gmail.com>
Subject: Re: [PATCH] rxrpc: fix some null-ptr-deref bugs in server_key.c
To:     Xiaolong Huang <butterflyhuangxx@gmail.com>
Cc:     David Howells <dhowells@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        linux-afs@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 1:28 PM Xiaolong Huang
<butterflyhuangxx@gmail.com> wrote:
>
> Some function calls are not implemented in rxrpc_no_security, there are
> preparse_server_key, free_preparse_server_key and destroy_server_key.
> When rxrpc security type is rxrpc_no_security, user can easily trigger a
> null-ptr-deref bug via ioctl. So judgment should be added to prevent it
>
> The crash log:
> user@syzkaller:~$ ./rxrpc_preparse_s
> [   37.956878][T15626] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [   37.957645][T15626] #PF: supervisor instruction fetch in kernel mode
> [   37.958229][T15626] #PF: error_code(0x0010) - not-present page
> [   37.958762][T15626] PGD 4aadf067 P4D 4aadf067 PUD 4aade067 PMD 0
> [   37.959321][T15626] Oops: 0010 [#1] PREEMPT SMP
> [   37.959739][T15626] CPU: 0 PID: 15626 Comm: rxrpc_preparse_ Not tainted 5.17.0-01442-gb47d5a4f6b8d #43
> [   37.960588][T15626] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
> [   37.961474][T15626] RIP: 0010:0x0
> [   37.961787][T15626] Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
> [   37.962480][T15626] RSP: 0018:ffffc9000d9abdc0 EFLAGS: 00010286
> [   37.963018][T15626] RAX: ffffffff84335200 RBX: ffff888012a1ce80 RCX: 0000000000000000
> [   37.963727][T15626] RDX: 0000000000000000 RSI: ffffffff84a736dc RDI: ffffc9000d9abe48
> [   37.964425][T15626] RBP: ffffc9000d9abe48 R08: 0000000000000000 R09: 0000000000000002
> [   37.965118][T15626] R10: 000000000000000a R11: f000000000000000 R12: ffff888013145680
> [   37.965836][T15626] R13: 0000000000000000 R14: ffffffffffffffec R15: ffff8880432aba80
> [   37.966441][T15626] FS:  00007f2177907700(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
> [   37.966979][T15626] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   37.967384][T15626] CR2: ffffffffffffffd6 CR3: 000000004aaf1000 CR4: 00000000000006f0
> [   37.967864][T15626] Call Trace:
> [   37.968062][T15626]  <TASK>
> [   37.968240][T15626]  rxrpc_preparse_s+0x59/0x90
> [   37.968541][T15626]  key_create_or_update+0x174/0x510
> [   37.968863][T15626]  __x64_sys_add_key+0x139/0x1d0
> [   37.969165][T15626]  do_syscall_64+0x35/0xb0
> [   37.969451][T15626]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   37.969824][T15626] RIP: 0033:0x43a1f9
>
> Signed-off-by: Xiaolong Huang <butterflyhuangxx@gmail.com>
> Tested-by: Xiaolong Huang <butterflyhuangxx@gmail.com>
> ---
>  net/rxrpc/server_key.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/net/rxrpc/server_key.c b/net/rxrpc/server_key.c
> index ead3471307ee..ee269e0e6ee8 100644
> --- a/net/rxrpc/server_key.c
> +++ b/net/rxrpc/server_key.c
> @@ -84,6 +84,9 @@ static int rxrpc_preparse_s(struct key_preparsed_payload *prep)
>
>         prep->payload.data[1] = (struct rxrpc_security *)sec;
>
> +       if (!sec->preparse_server_key)
> +               return -EINVAL;
> +
>         return sec->preparse_server_key(prep);
>  }
>
> @@ -91,7 +94,7 @@ static void rxrpc_free_preparse_s(struct key_preparsed_payload *prep)
>  {
>         const struct rxrpc_security *sec = prep->payload.data[1];
>
> -       if (sec)
> +       if (sec && sec->free_preparse_server_key)
>                 sec->free_preparse_server_key(prep);
>  }
>
> @@ -99,7 +102,7 @@ static void rxrpc_destroy_s(struct key *key)
>  {
>         const struct rxrpc_security *sec = key->payload.data[1];
>
> -       if (sec)
> +       if (sec && sec->destroy_server_key)
>                 sec->destroy_server_key(key);
>  }
>
>
> base-commit: b47d5a4f6b8d42f8a8fbe891b36215e4fddc53be
> --
> 2.25.1

Actually ran into this while experimenting; looks fine and fixes the problem.

Acked-by: Marc Dionne <marc.dionne@auristor.com>

Marc
