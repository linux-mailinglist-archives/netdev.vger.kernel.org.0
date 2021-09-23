Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0801D416292
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 18:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242358AbhIWQCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 12:02:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242216AbhIWQCb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 12:02:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3FA96103C;
        Thu, 23 Sep 2021 16:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632412855;
        bh=t2uQw4IUnSroL2qa7OtzzDzhuyfqKYu6om0RRvVYBng=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R7HsrqsZfQ8inJ8dYCEd4xFUBnAFopyFkc8aV0NoUyP0gyqd8MPPRp9uG1cEQKWUc
         Wi3f7+DjKyZ/o8kZ09fqunINOXw/jVAdFgOTr2NOJIFTG4qDV1SQ4CyyuaJQd+c8p0
         hLUquuq5ic0ns9yTn5mhaed99ARFjeb5BV+0f9cNqMbsjPti5rCavaiWHKdLdwBeO2
         72pW2DCXV8CIHPweocK4S6JODrjy0KCLiVbJpG64MH3y8BwRvMHH/1tUMr62dbbn0X
         js7UgzijNtR0qvjwIyrxf+b0zQgvBa4f5sjNngrLZrKz5sZYc82LK6klZA5vSkMz++
         SSMQW/eFe3ZnQ==
Date:   Thu, 23 Sep 2021 09:00:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:TC subsystem" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: prevent user from passing illegal stab size
Message-ID: <20210923090054.3556deb0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <da8bd5e9-0476-d75b-4669-0a21637663b2@linux.alibaba.com>
References: <da8bd5e9-0476-d75b-4669-0a21637663b2@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Sep 2021 17:08:13 +0800 =E7=8E=8B=E8=B4=87 wrote:
> We observed below report when playing with netlink sock:
>=20
>   UBSAN: shift-out-of-bounds in net/sched/sch_api.c:580:10
>   shift exponent 249 is too large for 32-bit type
>   CPU: 0 PID: 685 Comm: a.out Not tainted
>   Call Trace:
>    dump_stack_lvl+0x8d/0xcf
>    ubsan_epilogue+0xa/0x4e
>    __ubsan_handle_shift_out_of_bounds+0x161/0x182
>    __qdisc_calculate_pkt_len+0xf0/0x190
>    __dev_queue_xmit+0x2ed/0x15b0
>=20
> it seems like kernel won't check the stab size_log passing from
> user, and will use the insane value later to calculate pkt_len.
>=20
> This patch just add a check on the size_log to avoid insane
> calculation.
>=20
> Reported-by: Abaci <abaci@linux.alibaba.com>
> Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
> ---
>  include/uapi/linux/pkt_sched.h | 1 +
>  net/sched/sch_api.c            | 3 +++
>  2 files changed, 4 insertions(+)
>=20
> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sche=
d.h
> index ec88590..fa194a0 100644
> --- a/include/uapi/linux/pkt_sched.h
> +++ b/include/uapi/linux/pkt_sched.h
> @@ -98,6 +98,7 @@ struct tc_ratespec {
>  };
>=20
>  #define TC_RTAB_SIZE	1024
> +#define TC_LOG_MAX	30

Adding a uAPI define is not necessary.

>  struct tc_sizespec {
>  	unsigned char	cell_log;
> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> index 5e90e9b..1b6b8f8 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -513,6 +513,9 @@ static struct qdisc_size_table *qdisc_get_stab(struct=
 nlattr *opt,
>  		return stab;
>  	}
>=20
> +	if (s->size_log > TC_LOG_MAX)
> +		return ERR_PTR(-EINVAL);

Looks sane, please add an extack message.

Why not cover cell_log as well while at it?=20

>  	stab =3D kmalloc(sizeof(*stab) + tsize * sizeof(u16), GFP_KERNEL);
>  	if (!stab)
>  		return ERR_PTR(-ENOMEM);

