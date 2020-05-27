Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B191E3A4B
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 09:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbgE0HY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 03:24:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34411 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728303AbgE0HY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 03:24:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590564297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KbHQIkha6he1i8s7Bqlbe3Vce46Z0RHd422TpiUER5I=;
        b=MOI9kmRzbXY4KoJqwvrial27b6i6m1K3XRwZ+m5YpiBM1pINNnEkMeqw4E5hsBnGqCHRdF
        2iGWGZ6MGHHHNOTrjaBTud+Cawp+hYv2h7QD03cB+N8PahzWdHRfKqFzOQtIwOPrtIRQZj
        KRBFu59p+PU5USWQPhCmjfIW2l2CQ8E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-V1S55TvmM1CD_86dYdWP1w-1; Wed, 27 May 2020 03:24:55 -0400
X-MC-Unique: V1S55TvmM1CD_86dYdWP1w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17BC018FE860;
        Wed, 27 May 2020 07:24:54 +0000 (UTC)
Received: from ceranb (unknown [10.40.195.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 128A41A7EE;
        Wed, 27 May 2020 07:24:51 +0000 (UTC)
Date:   Wed, 27 May 2020 09:24:51 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [PATCH net] net/sched: fix infinite loop in sch_fq_pie
Message-ID: <20200527092451.5ae03435@ceranb>
In-Reply-To: <416eb03a8ca70b5dfb5e882e2752b7fc13c42f92.1590537338.git.dcaratti@redhat.com>
References: <416eb03a8ca70b5dfb5e882e2752b7fc13c42f92.1590537338.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 May 2020 02:04:26 +0200
Davide Caratti <dcaratti@redhat.com> wrote:

> this command hangs forever:
> 
>  # tc qdisc add dev eth0 root fq_pie flows 65536
> 
>  watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [tc:1028]
>  [...]
>  CPU: 1 PID: 1028 Comm: tc Not tainted 5.7.0-rc6+ #167
>  RIP: 0010:fq_pie_init+0x60e/0x8b7 [sch_fq_pie]
>  Code: 4c 89 65 50 48 89 f8 48 c1 e8 03 42 80 3c 30 00 0f 85 2a 02 00 00 48 8d 7d 10 4c 89 65 58 48 89 f8 48 c1 e8 03 42 80 3c 30 00 <0f> 85 a7 01 00 00 48 8d 7d 18 48 c7 45 10 46 c3 23 00 48 89 f8 48
>  RSP: 0018:ffff888138d67468 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
>  RAX: 1ffff9200018d2b2 RBX: ffff888139c1c400 RCX: ffffffffffffffff
>  RDX: 000000000000c5e8 RSI: ffffc900000e5000 RDI: ffffc90000c69590
>  RBP: ffffc90000c69580 R08: fffffbfff79a9699 R09: fffffbfff79a9699
>  R10: 0000000000000700 R11: fffffbfff79a9698 R12: ffffc90000c695d0
>  R13: 0000000000000000 R14: dffffc0000000000 R15: 000000002347c5e8
>  FS:  00007f01e1850e40(0000) GS:ffff88814c880000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 000000000067c340 CR3: 000000013864c000 CR4: 0000000000340ee0
>  Call Trace:
>   qdisc_create+0x3fd/0xeb0
>   tc_modify_qdisc+0x3be/0x14a0
>   rtnetlink_rcv_msg+0x5f3/0x920
>   netlink_rcv_skb+0x121/0x350
>   netlink_unicast+0x439/0x630
>   netlink_sendmsg+0x714/0xbf0
>   sock_sendmsg+0xe2/0x110
>   ____sys_sendmsg+0x5b4/0x890
>   ___sys_sendmsg+0xe9/0x160
>   __sys_sendmsg+0xd3/0x170
>   do_syscall_64+0x9a/0x370
>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> we can't accept 65536 as a valid number for 'nflows', because the loop on
> 'idx' in fq_pie_init() will never end. The extack message is correct, but
> it doesn't say that 0 is not a valid number for 'flows': while at it, fix
> this also. Add a tdc selftest to check correct validation of 'flows'.
> 
> CC: Ivan Vecera <ivecera@redhat.com>
> Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  net/sched/sch_fq_pie.c                        |  4 ++--
>  .../tc-testing/tc-tests/qdiscs/fq_pie.json    | 21 +++++++++++++++++++
>  2 files changed, 23 insertions(+), 2 deletions(-)
>  create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_pie.json
> 
> diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
> index a9da8776bf5b..fb760cee824e 100644
> --- a/net/sched/sch_fq_pie.c
> +++ b/net/sched/sch_fq_pie.c
> @@ -297,9 +297,9 @@ static int fq_pie_change(struct Qdisc *sch, struct nlattr *opt,
>  			goto flow_error;
>  		}
>  		q->flows_cnt = nla_get_u32(tb[TCA_FQ_PIE_FLOWS]);
> -		if (!q->flows_cnt || q->flows_cnt > 65536) {
> +		if (!q->flows_cnt || q->flows_cnt >= 65536) {
>  			NL_SET_ERR_MSG_MOD(extack,
> -					   "Number of flows must be < 65536");
> +					   "Number of flows must range in [1..65535]");
>  			goto flow_error;
>  		}
>  	}
> diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_pie.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_pie.json
> new file mode 100644
> index 000000000000..1cda2e11b3ad
> --- /dev/null
> +++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_pie.json
> @@ -0,0 +1,21 @@
> +[
> +    {
> +        "id": "83be",
> +        "name": "Create FQ-PIE with invalid number of flows",
> +        "category": [
> +            "qdisc",
> +            "fq_pie"
> +        ],
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY root fq_pie flows 65536",
> +        "expExitCode": "2",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc",
> +        "matchCount": "0",
> +        "teardown": [
> +            "$IP link del dev $DUMMY"
> +        ]
> +    }
> +]

Good catch, Davide.

Reviewed-by: Ivan Vecera <ivecera@redhat.com>

