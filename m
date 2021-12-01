Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C39464737
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 07:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236179AbhLAGh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 01:37:27 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:45710 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230303AbhLAGh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 01:37:26 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UyzaKDW_1638340444;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UyzaKDW_1638340444)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 01 Dec 2021 14:34:04 +0800
Date:   Wed, 1 Dec 2021 14:34:03 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Dust Li <dust.li@linux.alibaba.com>
Cc:     Karsten Graul <kgraul@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Wen Gu <guwen@linux.alibaba.com>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v3] net/smc: fix wrong list_del in
 smc_lgr_cleanup_early
Message-ID: <YacXW60POz1SKyDq@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211201030230.8896-1-dust.li@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211201030230.8896-1-dust.li@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 11:02:30AM +0800, Dust Li wrote:
> smc_lgr_cleanup_early() meant to delete the link
> group from the link group list, but it deleted
> the list head by mistake.
> 
> This may cause memory corruption since we didn't
> remove the real link group from the list and later
> memseted the link group structure.
> We got a list corruption panic when testing:
> 
> [  231.277259] list_del corruption. prev->next should be ffff8881398a8000, but was 0000000000000000
> [  231.278222] ------------[ cut here ]------------
> [  231.278726] kernel BUG at lib/list_debug.c:53!
> [  231.279326] invalid opcode: 0000 [#1] SMP NOPTI
> [  231.279803] CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.10.46+ #435
> [  231.280466] Hardware name: Alibaba Cloud ECS, BIOS 8c24b4c 04/01/2014
> [  231.281248] Workqueue: events smc_link_down_work
> [  231.281732] RIP: 0010:__list_del_entry_valid+0x70/0x90
> [  231.282258] Code: 4c 60 82 e8 7d cc 6a 00 0f 0b 48 89 fe 48 c7 c7 88 4c
> 60 82 e8 6c cc 6a 00 0f 0b 48 89 fe 48 c7 c7 c0 4c 60 82 e8 5b cc 6a 00 <0f>
> 0b 48 89 fe 48 c7 c7 00 4d 60 82 e8 4a cc 6a 00 0f 0b cc cc cc
> [  231.284146] RSP: 0018:ffffc90000033d58 EFLAGS: 00010292
> [  231.284685] RAX: 0000000000000054 RBX: ffff8881398a8000 RCX: 0000000000000000
> [  231.285415] RDX: 0000000000000001 RSI: ffff88813bc18040 RDI: ffff88813bc18040
> [  231.286141] RBP: ffffffff8305ad40 R08: 0000000000000003 R09: 0000000000000001
> [  231.286873] R10: ffffffff82803da0 R11: ffffc90000033b90 R12: 0000000000000001
> [  231.287606] R13: 0000000000000000 R14: ffff8881398a8000 R15: 0000000000000003
> [  231.288337] FS:  0000000000000000(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
> [  231.289160] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  231.289754] CR2: 0000000000e72058 CR3: 000000010fa96006 CR4: 00000000003706f0
> [  231.290485] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  231.291211] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  231.291940] Call Trace:
> [  231.292211]  smc_lgr_terminate_sched+0x53/0xa0
> [  231.292677]  smc_switch_conns+0x75/0x6b0
> [  231.293085]  ? update_load_avg+0x1a6/0x590
> [  231.293517]  ? ttwu_do_wakeup+0x17/0x150
> [  231.293907]  ? update_load_avg+0x1a6/0x590
> [  231.294317]  ? newidle_balance+0xca/0x3d0
> [  231.294716]  smcr_link_down+0x50/0x1a0
> [  231.295090]  ? __wake_up_common_lock+0x77/0x90
> [  231.295534]  smc_link_down_work+0x46/0x60
> [  231.295933]  process_one_work+0x18b/0x350
> 
> Fixes: a0a62ee15a829 ("net/smc: separate locks for SMCD and SMCR link group lists")
> Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
> Acked-by: Karsten Graul <kgraul@linux.ibm.com>

This patch looks good to me, thank you.

Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>

> ---
> v2: Remove unused lgr_list
> v2->v3: Fix uninitialized lgr_lock, thanks Jakub Kicinski !
> ---
>  net/smc/smc_core.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index bb52c8b5f148..387d28b2f8dd 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -625,18 +625,17 @@ int smcd_nl_get_lgr(struct sk_buff *skb, struct netlink_callback *cb)
>  void smc_lgr_cleanup_early(struct smc_connection *conn)
>  {
>  	struct smc_link_group *lgr = conn->lgr;
> -	struct list_head *lgr_list;
>  	spinlock_t *lgr_lock;
>  
>  	if (!lgr)
>  		return;
>  
>  	smc_conn_free(conn);
> -	lgr_list = smc_lgr_list_head(lgr, &lgr_lock);
> +	smc_lgr_list_head(lgr, &lgr_lock);
>  	spin_lock_bh(lgr_lock);
>  	/* do not use this link group for new connections */
> -	if (!list_empty(lgr_list))
> -		list_del_init(lgr_list);
> +	if (!list_empty(&lgr->list))
> +		list_del_init(&lgr->list);
>  	spin_unlock_bh(lgr_lock);
>  	__smc_lgr_terminate(lgr, true);
>  }
> -- 
> 2.19.1.3.ge56e4f7
