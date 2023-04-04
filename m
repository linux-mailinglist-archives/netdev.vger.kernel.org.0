Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7806D67D9
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 17:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbjDDPvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 11:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231972AbjDDPvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 11:51:22 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E869EC
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 08:51:21 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id ja10so31711238plb.5
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 08:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680623481;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Nrb99iVWe7xBz/5G9AbuCi3bEzeVP+5sxnM/t8TAWGA=;
        b=NJriRdR0cC0IcoXsrCQ5t0IWto1C5t6Pouc9qcWx6LiUv2FmtML0YKN/7ncQ5+8Xj8
         ZDrGSID6sm+M861zb0SLcbG441quTUumn+N6sdLRHkTWz8AmenX/IYg8tKmBmxeEa3VQ
         kPDn0ZhSXpBu1tr0wD+R5sTU/HAcOjw0St/T6x7UlLXYDEgWu/cv6kjHEDEFkQTkrEuH
         FuvcfW5MPRR0LHzxtsI6r489/qK500xsIm1VNb8ZJl9F917CGzDT1Y4nrOwtXPDaWtQX
         4kVo+kOr6AeGVMoEDTdGO5vvwuTD9S/qeALh81Enw2Vo3o2QDswnq793uPkEy7yI6BP9
         rEgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680623481;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Nrb99iVWe7xBz/5G9AbuCi3bEzeVP+5sxnM/t8TAWGA=;
        b=3mxS8iTxx9CV19xSD/PiqKs4GLe5XE0cMc9hyKMBmn4FkBBPhka7tsZefwfJE8fZZz
         a4XW1nqjFZ80HgAeTvJVi0CNjjRyJBB/m4L1dBpHXQEZNN1wiDFNLWy2enPMWrLgnliq
         wbuSsGxeVQYgFO3ENEXfF0BDYKDCeVsgp1Ek//K5LXws0OmV+KbVU7cQIdMSTOo22uvG
         Lln0tghY4mkHebKKyzOUlAwD3PkIjkex+AVuValdoa4QXwYvMd0WEiuAwYBKykp7uHwy
         Tt0ffx9cC1cWox2ivEdY3tffajGU8zSu3rKQnesL/xVpXWru2s9WC091LrUTP3Cy+Z8z
         PGXA==
X-Gm-Message-State: AAQBX9fghweVB/rwvjjK/BrgjdP2ZXG3W4uQS0RaME/ntMK5U5PEwyZj
        Naru8FD/jfY4PbLGqAs/Wy8=
X-Google-Smtp-Source: AKy350ZKkxIrIy9l+JbRzGklJ3YmPT5w25EzcsOVpQtUd0tFio6/5HxVY48c9G+gAPkc+xRn7BhsZA==
X-Received: by 2002:a17:90a:51c5:b0:234:d1c:f112 with SMTP id u63-20020a17090a51c500b002340d1cf112mr3335079pjh.0.1680623480428;
        Tue, 04 Apr 2023 08:51:20 -0700 (PDT)
Received: from [192.168.0.128] ([98.97.112.205])
        by smtp.googlemail.com with ESMTPSA id j12-20020a63e74c000000b00512fbdd8c47sm7886116pgk.45.2023.04.04.08.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 08:51:19 -0700 (PDT)
Message-ID: <7331d6d3f9044e386e425e89b1fc32d60b046cf3.camel@gmail.com>
Subject: Re: [PATCH] skbuff: Fix a race between coalescing and releasing SKBs
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Liang Chen <liangchen.linux@gmail.com>,
        ilias.apalodimas@linaro.org, hawk@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Date:   Tue, 04 Apr 2023 08:51:18 -0700
In-Reply-To: <20230404074733.22869-1-liangchen.linux@gmail.com>
References: <20230404074733.22869-1-liangchen.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-04-04 at 15:47 +0800, Liang Chen wrote:
> Commit 1effe8ca4e34 allowed coalescing to proceed with non page pool page
> and page pool page when @from is cloned, i.e.
>=20
> to->pp_recycle    --> false
> from->pp_recycle  --> true
> skb_cloned(from)  --> true
>=20
> However, it actually requires skb_cloned(@from) to hold true until
> coalescing finishes in this situation. If the other cloned SKB is
> released while the merging is in process, from_shinfo->nr_frags will be
> set to 0 toward the end of the function, causing the increment of frag
> page _refcount to be unexpectedly skipped resulting in inconsistent
> reference counts. Later when SKB(@to) is released, it frees the page
> directly even though the page pool page is still in use, leading to
> use-after-free or double-free errors. So it should be prohibitted.
>=20
> The double-free error message below prompted us to investigate:
> BUG: Bad page state in process swapper/1  pfn:0e0d1
> page:00000000c6548b28 refcount:-1 mapcount:0 mapping:0000000000000000
> index:0x2 pfn:0xe0d1
> flags: 0xfffffc0000000(node=3D0|zone=3D1|lastcpupid=3D0x1fffff)
> raw: 000fffffc0000000 0000000000000000 ffffffff00000101 0000000000000000
> raw: 0000000000000002 0000000000000000 ffffffffffffffff 0000000000000000
> page dumped because: nonzero _refcount
>=20
> CPU: 1 PID: 0 Comm: swapper/1 Tainted: G            E      6.2.0+
> Call Trace:
>  <IRQ>
> dump_stack_lvl+0x32/0x50
> bad_page+0x69/0xf0
> free_pcp_prepare+0x260/0x2f0
> free_unref_page+0x20/0x1c0
> skb_release_data+0x10b/0x1a0
> napi_consume_skb+0x56/0x150
> net_rx_action+0xf0/0x350
> ? __napi_schedule+0x79/0x90
> __do_softirq+0xc8/0x2b1
> __irq_exit_rcu+0xb9/0xf0
> common_interrupt+0x82/0xa0
> </IRQ>
> <TASK>
> asm_common_interrupt+0x22/0x40
> RIP: 0010:default_idle+0xb/0x20
>=20
> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> ---
>  net/core/skbuff.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
>=20
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 050a875d09c5..9be23ece5f03 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -5598,17 +5598,14 @@ bool skb_try_coalesce(struct sk_buff *to, struct =
sk_buff *from,
>  		return false;
> =20
>  	/* In general, avoid mixing slab allocated and page_pool allocated
> -	 * pages within the same SKB. However when @to is not pp_recycle and
> -	 * @from is cloned, we can transition frag pages from page_pool to
> -	 * reference counted.
> -	 *
> -	 * On the other hand, don't allow coalescing two pp_recycle SKBs if
> -	 * @from is cloned, in case the SKB is using page_pool fragment
> -	 * references (PP_FLAG_PAGE_FRAG). Since we only take full page
> -	 * references for cloned SKBs at the moment that would result in
> -	 * inconsistent reference counts.
> +	 * pages within the same SKB. However don't allow coalescing two
> +	 * pp_recycle SKBs if @from is cloned, in case the SKB is using
> +	 * page_pool fragment references (PP_FLAG_PAGE_FRAG). Since we only
> +	 * take full page references for cloned SKBs at the moment that would
> +	 * result in inconsistent reference counts.
>  	 */
> -	if (to->pp_recycle !=3D (from->pp_recycle && !skb_cloned(from)))
> +	if ((to->pp_recycle !=3D from->pp_recycle)
> +		|| (from->pp_recycle && skb_cloned(from)))
>  		return false;
> =20
>  	if (len <=3D skb_tailroom(to)) {

I'm not quite sure I agree with the fix. Couldn't we just modify the
check further down that does:

        if (!skb_cloned(from))
                from_shinfo->nr_frags =3D 0;

And instead just make that:
	if (!skb->cloned || (!skb_cloned(from) && !from->pp_recycle))
                from_shinfo->nr_frags =3D 0;

With that we would retain the existing behavior and in the case of
cloned from frames we would take the references and let the original
from skb freed to take care of pulling the pages from the page pool.


