Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADAA618C2DC
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 23:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgCSWPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 18:15:07 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36434 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727383AbgCSWPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 18:15:07 -0400
Received: by mail-qk1-f196.google.com with SMTP id d11so4978244qko.3
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 15:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=aq/zuI877ba72bpAXp93fd8HA00kjAK5+wwT6yu/AZQ=;
        b=HZp/whEyFLCjmHDFXISSZvWaXDg84oeR9HlfbsFLBjwEmVKXYqIOV2AaFNrztRA4PN
         OerITokpElPZCpRHkFaVYNTtT65TWrMjH6dUXgVF88Q4X/HYbO53BhfD8NUZmwFwxPbp
         k7C36tga/7GR88dL4IwCjPR/ovleFVE97Bm2tdgkihgVla1f4EWdtGbt1wWLGS+jtLvu
         QtkvyTP92bfpGJy4qV2uhTSqMw6kDqbGpAdzDFvgmROHWM3tU0xe30RLzv0JES2Jll11
         l1cZZwIgwvulyjEe9osO+JU4UIdsxM0nxtDbfbfRy9EYCwcSiAK0Yj3UA3zaSCI3mHym
         K4MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=aq/zuI877ba72bpAXp93fd8HA00kjAK5+wwT6yu/AZQ=;
        b=jgKwnKePGk6gj39w+5rD54ZCbJEZDlmgJZaQQ4uOiXJ2vS4qEbRG84KjyboO6pVXRE
         khdaFHKHExBVo3J6nhA4TWQ8hZfci9t1Mjc4ntT/GHwi8rzOD59Vd3Ku0bqFz+CLxNih
         6sSOCAbBTxE3H9Lm96abCbKHf5qGAIglTMwTMiYUXPGM/+O6nrOu9B3WuHAEAHjKRukx
         da20l+D42FDY1QLzK/H4GszJxX8yu5PgwPVhg3/im1hfswaTYrsAGSSoXtAgcjbk9bVX
         XZWz4pPXCmpWPFNnf+EjKCMjG432hNymjG0i9KM2UztTPx8BebYnHm2JXiwD2q+m9u5r
         JkEg==
X-Gm-Message-State: ANhLgQ1oppEQK2HoE9fWl3jgS3RKPXGOvKGylOtM2OxVYN1FK0fklk+5
        VwqnpQ99StH6IxcTI8IZ7KucUA==
X-Google-Smtp-Source: ADFU+vtWXsEEibolAaEXb6LmEZ6s7PdyXVsgf3Mhx0i+8h0RW8+WNe9sSZunJA4XK33WbkI1u+Iksw==
X-Received: by 2002:a05:620a:a90:: with SMTP id v16mr5149510qkg.46.1584656106381;
        Thu, 19 Mar 2020 15:15:06 -0700 (PDT)
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id j13sm2528014qkl.41.2020.03.19.15.15.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Mar 2020 15:15:05 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH] ipv4: fix a RCU-list bug in inet_dump_fib()
From:   Qian Cai <cai@lca.pw>
In-Reply-To: <20200319221141.8814-1-cai@lca.pw>
Date:   Thu, 19 Mar 2020 18:15:04 -0400
Cc:     alexander.h.duyck@linux.intel.com, kuznet@ms2.inr.ac.ru,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <7548E652-5F70-4920-9EC6-CAB469D0BD35@lca.pw>
References: <20200319221141.8814-1-cai@lca.pw>
To:     David Miller <davem@davemloft.net>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 19, 2020, at 6:11 PM, Qian Cai <cai@lca.pw> wrote:
>=20
> There is a place,
>=20
> inet_dump_fib()
>  fib_table_dump
>    fn_trie_dump_leaf()
>      hlist_for_each_entry_rcu()
>=20
> without rcu_read_lock() triggers a warning,
>=20
> WARNING: suspicious RCU usage
> -----------------------------
> net/ipv4/fib_trie.c:2216 RCU-list traversed in non-reader section!!
>=20
> other info that might help us debug this:
>=20
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> 1 lock held by ip/1923:
>  #0: ffffffff8ce76e40 (rtnl_mutex){+.+.}, at: netlink_dump+0xd6/0x840
>=20
> Call Trace:
>  dump_stack+0xa1/0xea
>  lockdep_rcu_suspicious+0x103/0x10d
>  fn_trie_dump_leaf+0x581/0x590
>  fib_table_dump+0x15f/0x220
>  inet_dump_fib+0x4ad/0x5d0
>  netlink_dump+0x350/0x840
>  __netlink_dump_start+0x315/0x3e0
>  rtnetlink_rcv_msg+0x4d1/0x720
>  netlink_rcv_skb+0xf0/0x220
>  rtnetlink_rcv+0x15/0x20
>  netlink_unicast+0x306/0x460
>  netlink_sendmsg+0x44b/0x770
>  __sys_sendto+0x259/0x270
>  __x64_sys_sendto+0x80/0xa0
>  do_syscall_64+0x69/0xf4
>  entry_SYSCALL_64_after_hwframe+0x49/0xb3
>=20
> Signed-off-by: Qian Cai <cai@lca.pw>

Self-NAK. I forgot to unlock. Will send a v2.

> ---
> net/ipv4/fib_frontend.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
> index 577db1d50a24..5e441282d647 100644
> --- a/net/ipv4/fib_frontend.c
> +++ b/net/ipv4/fib_frontend.c
> @@ -987,6 +987,8 @@ static int inet_dump_fib(struct sk_buff *skb, =
struct netlink_callback *cb)
> 	if (filter.flags & RTM_F_PREFIX)
> 		return skb->len;
>=20
> +	rcu_read_lock();
> +
> 	if (filter.table_id) {
> 		tb =3D fib_get_table(net, filter.table_id);
> 		if (!tb) {
> @@ -1004,8 +1006,6 @@ static int inet_dump_fib(struct sk_buff *skb, =
struct netlink_callback *cb)
> 	s_h =3D cb->args[0];
> 	s_e =3D cb->args[1];
>=20
> -	rcu_read_lock();
> -
> 	for (h =3D s_h; h < FIB_TABLE_HASHSZ; h++, s_e =3D 0) {
> 		e =3D 0;
> 		head =3D &net->ipv4.fib_table_hash[h];
> --=20
> 2.21.0 (Apple Git-122.2)
>=20

