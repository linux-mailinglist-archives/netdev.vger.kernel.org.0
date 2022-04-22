Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A22B50BD38
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 18:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449761AbiDVQil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 12:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392046AbiDVQik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 12:38:40 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB535EBC9;
        Fri, 22 Apr 2022 09:35:46 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id c15so10284306ljr.9;
        Fri, 22 Apr 2022 09:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M6cSf3rWybJaak8I5ckt3kVwPSyC+Ht3yWyW9Q792IM=;
        b=Sm8c4eAfIv0o+xf2IQZ0xOiTa9eR8RMQ6Y0jLcIPkfwWor0+zgK1lo6zGL5+1zmOjN
         u2WZSv0zsvOBABGm+SUxMcV7GiPA9e3WokAhnPL5oT97HV1sQwZWd/WLMu+cVYMTyO2r
         8E6SPzLiXvxZQ4N18DxT6ZKVrnvowato2uy+3oXOMPXdgmIXkfQF61ji72EJLRb+5oX0
         FTBwJBsbksmwTfF6Uk1sM98K6ehfdc3yC0672vZgSbHhRrl5+LopOZgZSEq2R+uv4BQp
         67ntIlf0zy8UJYpjIbJqXEp6VyxkMN/H6j8Ig1KpBHevTNCX8gNpZF5LAo7WV3hUhTNv
         yz8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M6cSf3rWybJaak8I5ckt3kVwPSyC+Ht3yWyW9Q792IM=;
        b=bWa2f6YL7BNMd+NntnTJzAuaJP9+fUUfvaAhI8VT9CbjJ369/fC/RhIbwRz5Dgossc
         Kl2L0InAxS+b7l55d8N1d7BvTwzM/VrOA17yjcqP9lp/F0TxYuXfnsFxc0GBc8NDJwnn
         GHX0QWkt5mZZRXnt0Dl7Au6KA5H8zJhwq0SwyLhoNAmf9AX1JUcIlzaF6n1SPVVmiTrn
         tHHhvoZ1H7ZWReZGVljeDlE/S6rOyY3tkvSFqcoDsJ/LaCL/2rvJCC74KvWmr3HYfhib
         SjjAc11I1LzehpUsy4K7W3QAykVRWK+H3jLgN68PsoQsiauQCRxUloUZpqvht78rZC9p
         I58g==
X-Gm-Message-State: AOAM531tV3rysBlbj72iov6IImB6YoomHVEWxlpOdQ5VgnD6+XILT6pw
        sGaQXPfIBraqX8GDJK3swaoxCLCcNPaqHTE1nPXVae7sKr8=
X-Google-Smtp-Source: ABdhPJzOYUBER/oqKzKvMuhm2RDD85bXcqgWlxmwa2hIva0T/DTuVh6cPegKLtrLDK3gLipky2xaaVWXc7bDf1krAe0=
X-Received: by 2002:a2e:894e:0:b0:24d:bc0f:2238 with SMTP id
 b14-20020a2e894e000000b0024dbc0f2238mr3247631ljk.509.1650645344918; Fri, 22
 Apr 2022 09:35:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1650575919.git.peilin.ye@bytedance.com> <b606e0355949a3ca8081ee29d9d22f2f30e898bd.1650575919.git.peilin.ye@bytedance.com>
In-Reply-To: <b606e0355949a3ca8081ee29d9d22f2f30e898bd.1650575919.git.peilin.ye@bytedance.com>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 22 Apr 2022 09:35:08 -0700
Message-ID: <CALDO+SYfemnqVkQY6kbQ23hgtdcUSimExJQob90rZLd8xvzsXw@mail.gmail.com>
Subject: Re: [PATCH net 3/3] ip_gre, ip6_gre: Fix race condition on o_seqno in
 collect_md mode
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        "xeb@mail.ru" <xeb@mail.ru>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
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

On Thu, Apr 21, 2022 at 3:09 PM Peilin Ye <yepeilin.cs@gmail.com> wrote:
>
> From: Peilin Ye <peilin.ye@bytedance.com>
>
> As pointed out by Jakub Kicinski, currently using TUNNEL_SEQ in
> collect_md mode is racy for [IP6]GRE[TAP] devices.  Consider the
> following sequence of events:
>
> 1. An [IP6]GRE[TAP] device is created in collect_md mode using "ip link
>    add ... external".  "ip" ignores "[o]seq" if "external" is specified,
>    so TUNNEL_SEQ is off, and the device is marked as NETIF_F_LLTX (i.e.
>    it uses lockless TX);
> 2. Someone sets TUNNEL_SEQ on outgoing skb's, using e.g.
>    bpf_skb_set_tunnel_key() in an eBPF program attached to this device;
> 3. gre_fb_xmit() or __gre6_xmit() processes these skb's:
>
>         gre_build_header(skb, tun_hlen,
>                          flags, protocol,
>                          tunnel_id_to_key32(tun_info->key.tun_id),
>                          (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++)
>                                               : 0);   ^^^^^^^^^^^^^^^^^
>
> Since we are not using the TX lock (&txq->_xmit_lock), multiple CPUs may
> try to do this tunnel->o_seqno++ in parallel, which is racy.  Fix it by
> making o_seqno atomic_t.
>
> As mentioned by Eric Dumazet in commit b790e01aee74 ("ip_gre: lockless
> xmit"), making o_seqno atomic_t increases "chance for packets being out
> of order at receiver" when NETIF_F_LLTX is on.
>
> Maybe a better fix would be:
>
> 1. Do not ignore "oseq" in external mode.  Users MUST specify "oseq" if
>    they want the kernel to allow sequencing of outgoing packets;
> 2. Reject all outgoing TUNNEL_SEQ packets if the device was not created
>    with "oseq".
>
> Unfortunately, that would break userspace.
>
> We could now make [IP6]GRE[TAP] devices always NETIF_F_LLTX, but let us
> do it in separate patches to keep this fix minimal.
>
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Fixes: 77a5196a804e ("gre: add sequence number for collect md mode.")
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
> ---

LGTM
Acked-by: William Tu <u9012063@gmail.com>
