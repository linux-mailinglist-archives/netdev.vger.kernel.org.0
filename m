Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347505389A2
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 03:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242574AbiEaBeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 21:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233538AbiEaBeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 21:34:11 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498C8939CC
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 18:34:10 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id x65so12291933qke.2
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 18:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uffzShh5elCYixAow4RscM/AbZaQFpC6YmLJIO+JfHA=;
        b=FnDFsuGZn1VY19zvuNG6URN+kIRgv8IAMhLXW9rulh9k1U1/ModmJylS6UiAn51KWu
         qGAlCWFYHoKShLam2cdlLUw4elPn0C/fTdCb8SK9UwZ+GwU46oarLdddJD1Y8KTIJKD7
         gC8k8w3D1j10jyuA4N/FGDTBzQoXB0Cl1slQtxfhPj1JHQM+5As2Hgk5dQf/OX71TiLe
         7btN1kkH76EJSSELad5Z0TGCKBHHV05yYYrrwGONrPzABUG2v6DUGNlPxIxKdMLPD4nj
         yxJgTJbwjVPQZgY8YDj05cxHjnP1CBUdJxi9+W/atjMymrBHe1PnjUeqL7+qLX9SEF2x
         m/nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uffzShh5elCYixAow4RscM/AbZaQFpC6YmLJIO+JfHA=;
        b=BYnGDmw1Jn+ZnU3rusGkhbHKdY2iUIXhgMbrdSzlZkvwHC51mJuhzDXViL0qIl9HzP
         qqrdiCjEVie+QVb3m1ujFbBvJP/+GBVxy7vdtUDsjH2wK0vaTzEB9hBVo/0AvLbhbDoq
         P73Sfhc1KRsZ+k5JyvsJ2TEwPsa778dvm/J6RFHFWJG2IxnScqm52zIlZGrQjp280lML
         kqRN3R9zsX+Tty5OjzrR+TfSjZtYkwuho/y/NUCjA5tAv+VAVkkgIqMDPVMN+pBEE5p+
         weuUUDZpeczfl5YudnunyjD2yF5KAFsEdjnETm+4bd1JZjIjP6/EIEWr4K33vp9cGEfi
         VC+Q==
X-Gm-Message-State: AOAM533NLCDnAYAKVgmaTbj5DxvqtWcL3GSLvj9kr+BWfvsAByxNiqpo
        ye/QrKWL3YuTClDnJdBDsjZXwSvGEX296dE9qkJbT5MVEnA1zA==
X-Google-Smtp-Source: ABdhPJy20S/7fwEs+f7Tp9H446gG/hWENL9HhcJjWKc8+o9vnkMGukflXlpEGyHbtZ5HY06NEfmRrstHe1m5csJXys8=
X-Received: by 2002:a05:620a:1aa1:b0:6a3:8dd8:7173 with SMTP id
 bl33-20020a05620a1aa100b006a38dd87173mr28998984qkb.434.1653960849259; Mon, 30
 May 2022 18:34:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220530213713.601888-1-eric.dumazet@gmail.com>
In-Reply-To: <20220530213713.601888-1-eric.dumazet@gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 30 May 2022 21:33:53 -0400
Message-ID: <CADVnQynvKRveLu5JKG698+0hLGpugF=8Qic=tvx72QaGuT7DhQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: tcp_rtx_synack() can be called from process context
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Laurent Fasnacht <laurent.fasnacht@proton.ch>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 5:37 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Laurent reported the enclosed report [1]
>
> This bug triggers with following coditions:
>
> 0) Kernel built with CONFIG_DEBUG_PREEMPT=y
>
> 1) A new passive FastOpen TCP socket is created.
>    This FO socket waits for an ACK coming from client to be a complete
>    ESTABLISHED one.
> 2) A socket operation on this socket goes through lock_sock()
>    release_sock() dance.
> 3) While the socket is owned by the user in step 2),
>    a retransmit of the SYN is received and stored in socket backlog.
> 4) At release_sock() time, the socket backlog is processed while
>    in process context.
> 5) A SYNACK packet is cooked in response of the SYN retransmit.
> 6) -> tcp_rtx_synack() is called in process context.
>
> Before blamed commit, tcp_rtx_synack() was always called from BH handler,
> from a timer handler.
>
> Fix this by using TCP_INC_STATS() & NET_INC_STATS()
> which do not assume caller is in non preemptible context.
>
> [1]
> BUG: using __this_cpu_add() in preemptible [00000000] code: epollpep/2180
> caller is tcp_rtx_synack.part.0+0x36/0xc0
> CPU: 10 PID: 2180 Comm: epollpep Tainted: G           OE     5.16.0-0.bpo.4-amd64 #1  Debian 5.16.12-1~bpo11+1
> Hardware name: Supermicro SYS-5039MC-H8TRF/X11SCD-F, BIOS 1.7 11/23/2021
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x48/0x5e
>  check_preemption_disabled+0xde/0xe0
>  tcp_rtx_synack.part.0+0x36/0xc0
>  tcp_rtx_synack+0x8d/0xa0
>  ? kmem_cache_alloc+0x2e0/0x3e0
>  ? apparmor_file_alloc_security+0x3b/0x1f0
>  inet_rtx_syn_ack+0x16/0x30
>  tcp_check_req+0x367/0x610
>  tcp_rcv_state_process+0x91/0xf60
>  ? get_nohz_timer_target+0x18/0x1a0
>  ? lock_timer_base+0x61/0x80
>  ? preempt_count_add+0x68/0xa0
>  tcp_v4_do_rcv+0xbd/0x270
>  __release_sock+0x6d/0xb0
>  release_sock+0x2b/0x90
>  sock_setsockopt+0x138/0x1140
>  ? __sys_getsockname+0x7e/0xc0
>  ? aa_sk_perm+0x3e/0x1a0
>  __sys_setsockopt+0x198/0x1e0
>  __x64_sys_setsockopt+0x21/0x30
>  do_syscall_64+0x38/0xc0
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Fixes: 168a8f58059a ("tcp: TCP Fast Open Server - main code path")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Laurent Fasnacht <laurent.fasnacht@proton.ch>
> ---
>  net/ipv4/tcp_output.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index b4b2284ed4a2c9e2569bd945e3b4e023c5502f25..1c054431e358328fe3849f5a45aaa88308a1e1c8 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -4115,8 +4115,8 @@ int tcp_rtx_synack(const struct sock *sk, struct request_sock *req)
>         res = af_ops->send_synack(sk, NULL, &fl, req, NULL, TCP_SYNACK_NORMAL,
>                                   NULL);
>         if (!res) {
> -               __TCP_INC_STATS(sock_net(sk), TCP_MIB_RETRANSSEGS);
> -               __NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNRETRANS);
> +               TCP_INC_STATS(sock_net(sk), TCP_MIB_RETRANSSEGS);
> +               NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNRETRANS);
>                 if (unlikely(tcp_passive_fastopen(sk)))
>                         tcp_sk(sk)->total_retrans++;
>                 trace_tcp_retransmit_synack(sk, req);
> --

Nice diagnosis and fix! Thanks, Eric!

Acked-by: Neal Cardwell <ncardwell@google.com>

neal
