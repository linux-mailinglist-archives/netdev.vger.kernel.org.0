Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1AD122AE4B
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgGWLtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:49:12 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56091 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727828AbgGWLtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 07:49:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595504949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kMLp2I5AZsxuR1NLK4/4GFJLvuNxJmG+poCU1eMdup4=;
        b=KfkMCCiE5lzU3ySdXIiapMwwzhugwbcluJc6nKcXXKxzyf40ULDK6BoUzm8g0ZZTLTCAAI
        UkKpt4xzjfeOgEfhmXPs1fjiVhzujri6dg2tq8T+V5mM68W8AmXH3L1R3AadZAm5pJgGuP
        hI0v1brAJQibFcJnVF//DcK/ziBeyRY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-zTuSXR6pO2-EVAOEXrMJjw-1; Thu, 23 Jul 2020 07:49:05 -0400
X-MC-Unique: zTuSXR6pO2-EVAOEXrMJjw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC39F80183C;
        Thu, 23 Jul 2020 11:49:03 +0000 (UTC)
Received: from [10.36.112.205] (ovpn-112-205.ams2.redhat.com [10.36.112.205])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B78B819C4F;
        Thu, 23 Jul 2020 11:49:01 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Hillf Danton" <hdanton@sina.com>
Cc:     syzbot <syzbot+2c4ff3614695f75ce26c@syzkaller.appspotmail.com>,
        davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Paolo Abeni" <pabeni@redhat.com>, pshelar@ovn.org,
        syzkaller-bugs@googlegroups.com,
        "Markus Elfring" <Markus.Elfring@web.de>
Subject: Re: INFO: task hung in ovs_exit_net
Date:   Thu, 23 Jul 2020 13:48:59 +0200
Message-ID: <35ADBFE5-87FF-4E9E-A8FD-BB586E9F663F@redhat.com>
In-Reply-To: <20200723110655.12856-1-hdanton@sina.com>
References: <20200723110655.12856-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23 Jul 2020, at 13:06, Hillf Danton wrote:

> Wed, 22 Jul 2020 23:27:19 -0700
>> syzbot found the following issue on:
  <SNIP>
>
> Fixes: eac87c413bf9 ("net: openvswitch: reorder masks array based on 
> usage")
> by moving cancel_delayed_work_sync() in to the rcu cb, therefore out 
> of ovs
> lock. To facilitate that, add a flag in datapath to inform the kworker 
> that
> there is no more work needed.

I was thinking of re-working the patch and move the handling to the 
“struct ovs_net” instead of the datapath. This way the rebalance 
worker can rebalance all datapaths in the netns. Than I can move 
cancel_delayed_work_sync() from __dp_destroy()
to ovs_exit_net(), i.e. outside the ovs lock scope.

However, your fix would be way less intrusive. Are you planning on 
sending it as a patch? If so, maybe add a comment around the called_rcu 
variable to be more clear where it’s used for, or maybe rename it to 
something like called_destory_rcu?

If you think my approach would be better let me know, and I work on a 
patch.

Feedback anyone?

> --- a/net/openvswitch/datapath.h
> +++ b/net/openvswitch/datapath.h
> @@ -82,6 +82,7 @@ struct datapath {
>
>  	u32 max_headroom;
>
> +	int called_rcu;
>  	/* Switch meters. */
>  	struct dp_meter_table meter_tbl;
>
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -161,6 +161,7 @@ static void destroy_dp_rcu(struct rcu_he
>  {
>  	struct datapath *dp = container_of(rcu, struct datapath, rcu);
>
> +	cancel_delayed_work_sync(&dp->masks_rebalance);
>  	ovs_flow_tbl_destroy(&dp->table);
>  	free_percpu(dp->stats_percpu);
>  	kfree(dp->ports);
> @@ -1760,11 +1761,9 @@ static void __dp_destroy(struct datapath
>  	 */
>  	ovs_dp_detach_port(ovs_vport_ovsl(dp, OVSP_LOCAL));
>
> +	dp->called_rcu = true;
>  	/* RCU destroy the flow table */
>  	call_rcu(&dp->rcu, destroy_dp_rcu);
> -
> -	/* Cancel remaining work. */
> -	cancel_delayed_work_sync(&dp->masks_rebalance);
>  }
>
>  static int ovs_dp_cmd_del(struct sk_buff *skb, struct genl_info 
> *info)
> @@ -2356,6 +2355,8 @@ static void ovs_dp_masks_rebalance(struc
>  	ovs_flow_masks_rebalance(&dp->table);
>  	ovs_unlock();
>
> +	if (dp->called_rcu)
> +		return;
>  	schedule_delayed_work(&dp->masks_rebalance,
>  			      msecs_to_jiffies(DP_MASKS_REBALANCE_INTERVAL));
>  }

