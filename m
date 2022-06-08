Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F53542CC9
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 12:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236538AbiFHKLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 06:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236079AbiFHKKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 06:10:34 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB1E1F98ED;
        Wed,  8 Jun 2022 02:55:49 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id f65so8223611pgc.7;
        Wed, 08 Jun 2022 02:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EQQonAR/17w7429qFSvl74TS1SwJXlMBX+AGITM2SpE=;
        b=fF4Mmpd/Y/QkgrJOZAWtOY9fZ2suYowaB1GZQuFrfZczoKKtjLjGOg70nZ/P3ozQE5
         BvAoxRoAvFOSZAJ5Ra11YGaN4yaKnS82bJqEI5FM+3aJd2YwI0WR1GCujxBFAn6m4a1X
         1N6K6mDGloH7h1CD3IOPV4Z9pw590XNzkW40/BOxKjJvSArRgQ5iXEo47flnhFNcAUyR
         gxJXc3O6KPYBKvVggfNmgZzAGMQ1DSgt9iSYNK1BmIx4ckq9ryQVqayQwwini0IE5Auj
         0tQL7wer2qKtnNxfkIQH0YfvMJnJ+un65QiH1DPLFNTP0IVlbj0dZ+2R9q5f4tnIs952
         rFmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EQQonAR/17w7429qFSvl74TS1SwJXlMBX+AGITM2SpE=;
        b=vOjEq7iDZQJvdN8i2OZh8j08V61DSRJPh7RS9UO/gDhVHsl49ByClX2wjFz7rEbfYX
         296woGyZR5MRqVPIiesuCX/78z/Wh3nChev8RvoqCNJV1Z9przfIe4GHeYpg/UY4YJO2
         isvYgT3vt5ZnG6J7zRrpKxi0o0+966QwEjS9XLsaqPQBw9nSYMvLmQYB49n4eVJE4vrM
         5pcvI2AEK8RE0xJvNId1gVkLzjwdAohZ6zkFLiKY0scsZyhIaaUxnDTKr3GrS07cPB6v
         AQ3MSvM0fzietCXGW9Akq62SBIp38qInAE7w/6nMKQ75lc0SYMH/+QFisdi+2jGoYrRt
         Or1g==
X-Gm-Message-State: AOAM531E5wUPbCtajmQJTdM0jluX/F9Ymxgbj26MMp8iKRSJHp4MCvVe
        g3N9V62b+5XFVvXfUwFzzYulvQn3F9E0LxSeFmzm1044HCo+UQ==
X-Google-Smtp-Source: ABdhPJxI45k6hpRTPF0dfmUz7W6IW9C5yI2jf78AE8/IXHDCrIns1Bea6cdgCUBEh7nuv66v7fmSC8k6xPbiLMGx5zk=
X-Received: by 2002:a62:868c:0:b0:51b:bd62:4c87 with SMTP id
 x134-20020a62868c000000b0051bbd624c87mr33401883pfd.83.1654682148458; Wed, 08
 Jun 2022 02:55:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220607142200.576735-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20220607142200.576735-1-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 8 Jun 2022 11:55:37 +0200
Message-ID: <CAJ8uoz0XWd=rWUupMnGEBTcwZ0xixKUx1pLuqGm=xXWJEnqvrA@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: Fix handling of invalid descriptors in XSK Tx
 batching API
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
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

On Tue, Jun 7, 2022 at 7:16 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> Xdpxceiver run on a AF_XDP ZC enabled driver revealed a problem with XSK
> Tx batching API. There is a test that checks how invalid Tx descriptors
> are handled by AF_XDP. Each valid descriptor is followed by invalid one
> on Tx side whereas the Rx side expects only to receive a set of valid
> descriptors.
>
> In current xsk_tx_peek_release_desc_batch() function, the amount of
> available descriptors is hidden inside xskq_cons_peek_desc_batch(). This
> can be problematic in cases where invalid descriptors are present due to
> the fact that xskq_cons_peek_desc_batch() returns only a count of valid
> descriptors. This means that it is impossible to properly update XSK
> ring state when calling xskq_cons_release_n().
>
> To address this issue, pull out the contents of
> xskq_cons_peek_desc_batch() so that callers (currently only
> xsk_tx_peek_release_desc_batch()) will always be able to update the
> state of ring properly, as total count of entries is now available and
> use this value as an argument in xskq_cons_release_n(). By
> doing so, xskq_cons_peek_desc_batch() can be dropped altogether.

Thank you for catching this Maciej!

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Fixes: 9349eb3a9d2a ("xsk: Introduce batched Tx descriptor interfaces")
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  net/xdp/xsk.c       | 5 +++--
>  net/xdp/xsk_queue.h | 8 --------
>  2 files changed, 3 insertions(+), 10 deletions(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index e0a4526ab66b..19ac872a6624 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -373,7 +373,8 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, u32 max_entries)
>                 goto out;
>         }
>
> -       nb_pkts = xskq_cons_peek_desc_batch(xs->tx, pool, max_entries);
> +       max_entries = xskq_cons_nb_entries(xs->tx, max_entries);
> +       nb_pkts = xskq_cons_read_desc_batch(xs->tx, pool, max_entries);
>         if (!nb_pkts) {
>                 xs->tx->queue_empty_descs++;
>                 goto out;
> @@ -389,7 +390,7 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, u32 max_entries)
>         if (!nb_pkts)
>                 goto out;
>
> -       xskq_cons_release_n(xs->tx, nb_pkts);
> +       xskq_cons_release_n(xs->tx, max_entries);
>         __xskq_cons_release(xs->tx);
>         xs->sk.sk_write_space(&xs->sk);
>
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index a794410989cc..fb20bf7207cf 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -282,14 +282,6 @@ static inline bool xskq_cons_peek_desc(struct xsk_queue *q,
>         return xskq_cons_read_desc(q, desc, pool);
>  }
>
> -static inline u32 xskq_cons_peek_desc_batch(struct xsk_queue *q, struct xsk_buff_pool *pool,
> -                                           u32 max)
> -{
> -       u32 entries = xskq_cons_nb_entries(q, max);
> -
> -       return xskq_cons_read_desc_batch(q, pool, entries);
> -}
> -
>  /* To improve performance in the xskq_cons_release functions, only update local state here.
>   * Reflect this to global state when we get new entries from the ring in
>   * xskq_cons_get_entries() and whenever Rx or Tx processing are completed in the NAPI loop.
> --
> 2.27.0
>
