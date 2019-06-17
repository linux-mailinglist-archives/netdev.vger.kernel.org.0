Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C253747844
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 04:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfFQCyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 22:54:31 -0400
Received: from mail5.windriver.com ([192.103.53.11]:40708 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727441AbfFQCya (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Jun 2019 22:54:30 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id x5H2qO12026851
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Sun, 16 Jun 2019 19:52:39 -0700
Received: from [128.224.155.90] (128.224.155.90) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.50) with Microsoft SMTP Server (TLS) id 14.3.439.0; Sun, 16 Jun
 2019 19:52:30 -0700
Subject: Re: [PATCH net] tipc: purge deferredq list for each grp member in
 tipc_group_delete
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, Jon Maloy <jon.maloy@ericsson.com>,
        <tipc-discussion@lists.sourceforge.net>,
        <syzkaller-bugs@googlegroups.com>
References: <14ff2b79da7b9098fbff2919f0bc5a1afa33fe32.1560677047.git.lucien.xin@gmail.com>
From:   Ying Xue <ying.xue@windriver.com>
Message-ID: <1f6b032c-9f63-6c70-b71b-5afae0093179@windriver.com>
Date:   Mon, 17 Jun 2019 10:42:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <14ff2b79da7b9098fbff2919f0bc5a1afa33fe32.1560677047.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.155.90]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/16/19 5:24 PM, Xin Long wrote:
> Syzbot reported a memleak caused by grp members' deferredq list not
> purged when the grp is be deleted.
> 
> The issue occurs when more(msg_grp_bc_seqno(hdr), m->bc_rcv_nxt) in
> tipc_group_filter_msg() and the skb will stay in deferredq.
> 
> So fix it by calling __skb_queue_purge for each member's deferredq
> in tipc_group_delete() when a tipc sk leaves the grp.
> 
> Fixes: b87a5ea31c93 ("tipc: guarantee group unicast doesn't bypass group broadcast")
> Reported-by: syzbot+78fbe679c8ca8d264a8d@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Ying Xue <ying.xue@windriver.com>

> ---
>  net/tipc/group.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/tipc/group.c b/net/tipc/group.c
> index 992be61..5f98d38 100644
> --- a/net/tipc/group.c
> +++ b/net/tipc/group.c
> @@ -218,6 +218,7 @@ void tipc_group_delete(struct net *net, struct tipc_group *grp)
>  
>  	rbtree_postorder_for_each_entry_safe(m, tmp, tree, tree_node) {
>  		tipc_group_proto_xmit(grp, m, GRP_LEAVE_MSG, &xmitq);
> +		__skb_queue_purge(&m->deferredq);
>  		list_del(&m->list);
>  		kfree(m);
>  	}
> 
