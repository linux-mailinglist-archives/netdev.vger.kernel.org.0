Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 198228C9B1
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfHNCu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:50:57 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:50387 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbfHNCu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 22:50:57 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 5D465415FF;
        Wed, 14 Aug 2019 10:50:48 +0800 (CST)
Subject: Re: [PATCH net-next v7 5/6] flow_offload: support get multi-subsystem
 block
To:     Vlad Buslov <vladbu@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>, Jiri Pirko <jiri@resnulli.us>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1565140434-8109-1-git-send-email-wenxu@ucloud.cn>
 <1565140434-8109-6-git-send-email-wenxu@ucloud.cn>
 <vbfimr2o4ly.fsf@mellanox.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <f28ddefe-a7d8-e5ad-e03e-08cfee4db147@ucloud.cn>
Date:   Wed, 14 Aug 2019 10:50:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <vbfimr2o4ly.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSEtJS0tLS09OTExNSExZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NU06Lyo5Tjg3LToKDTwhMTgt
        IyMaFCJVSlVKTk1OTE5KS09CSktPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBTElOTTcG
X-HM-Tid: 0a6c8e08fb032086kuqy5d465415ff
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/12/2019 10:11 PM, Vlad Buslov wrote:
>
>> +static void flow_block_ing_cmd(struct net_device *dev,
>> +			       flow_indr_block_bind_cb_t *cb,
>> +			       void *cb_priv,
>> +			       enum flow_block_command command)
>> +{
>> +	struct flow_indr_block_ing_entry *entry;
>> +
>> +	rcu_read_lock();
>> +	list_for_each_entry_rcu(entry, &block_ing_cb_list, list) {
>> +		entry->cb(dev, cb, cb_priv, command);
>> +	}
>> +	rcu_read_unlock();
>> +}
> Hi,
>
> I'm getting following incorrect rcu usage warnings with this patch
> caused by rcu_read_lock in flow_block_ing_cmd:
>
> [  401.510948] =============================
> [  401.510952] WARNING: suspicious RCU usage
> [  401.510993] 5.3.0-rc3+ #589 Not tainted
> [  401.510996] -----------------------------
> [  401.511001] include/linux/rcupdate.h:265 Illegal context switch in RCU read-side critical section!
> [  401.511004]
>                other info that might help us debug this:
>
> [  401.511008]
>                rcu_scheduler_active = 2, debug_locks = 1
> [  401.511012] 7 locks held by test-ecmp-add-v/7576:
> [  401.511015]  #0: 00000000081d71a5 (sb_writers#4){.+.+}, at: vfs_write+0x166/0x1d0
> [  401.511037]  #1: 000000002bd338c3 (&of->mutex){+.+.}, at: kernfs_fop_write+0xef/0x1b0
> [  401.511051]  #2: 00000000c921c634 (kn->count#317){.+.+}, at: kernfs_fop_write+0xf7/0x1b0
> [  401.511062]  #3: 00000000a19cdd56 (&dev->mutex){....}, at: sriov_numvfs_store+0x6b/0x130
> [  401.511079]  #4: 000000005425fa52 (pernet_ops_rwsem){++++}, at: unregister_netdevice_notifier+0x30/0x140
> [  401.511092]  #5: 00000000c5822793 (rtnl_mutex){+.+.}, at: unregister_netdevice_notifier+0x35/0x140
> [  401.511101]  #6: 00000000c2f3507e (rcu_read_lock){....}, at: flow_block_ing_cmd+0x5/0x130
> [  401.511115]
>                stack backtrace:
> [  401.511121] CPU: 21 PID: 7576 Comm: test-ecmp-add-v Not tainted 5.3.0-rc3+ #589
> [  401.511124] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0b 03/30/2017
> [  401.511127] Call Trace:
> [  401.511138]  dump_stack+0x85/0xc0
> [  401.511146]  ___might_sleep+0x100/0x180
> [  401.511154]  __mutex_lock+0x5b/0x960
> [  401.511162]  ? find_held_lock+0x2b/0x80
> [  401.511173]  ? __tcf_get_next_chain+0x1d/0xb0
> [  401.511179]  ? mark_held_locks+0x49/0x70
> [  401.511194]  ? __tcf_get_next_chain+0x1d/0xb0
> [  401.511198]  __tcf_get_next_chain+0x1d/0xb0
> [  401.511251]  ? uplink_rep_async_event+0x70/0x70 [mlx5_core]
> [  401.511261]  tcf_block_playback_offloads+0x39/0x160
> [  401.511276]  tcf_block_setup+0x1b0/0x240
> [  401.511312]  ? mlx5e_rep_indr_setup_tc_cb+0xca/0x290 [mlx5_core]
> [  401.511347]  ? mlx5e_rep_indr_tc_block_unbind+0x50/0x50 [mlx5_core]
> [  401.511359]  tc_indr_block_get_and_ing_cmd+0x11b/0x1e0
> [  401.511404]  ? mlx5e_rep_indr_tc_block_unbind+0x50/0x50 [mlx5_core]
> [  401.511414]  flow_block_ing_cmd+0x7e/0x130
> [  401.511453]  ? mlx5e_rep_indr_tc_block_unbind+0x50/0x50 [mlx5_core]
> [  401.511462]  __flow_indr_block_cb_unregister+0x7f/0xf0
> [  401.511502]  mlx5e_nic_rep_netdevice_event+0x75/0xb0 [mlx5_core]
> [  401.511513]  unregister_netdevice_notifier+0xe9/0x140
> [  401.511554]  mlx5e_cleanup_rep_tx+0x6f/0xe0 [mlx5_core]
> [  401.511597]  mlx5e_detach_netdev+0x4b/0x60 [mlx5_core]
> [  401.511637]  mlx5e_vport_rep_unload+0x71/0xc0 [mlx5_core]
> [  401.511679]  esw_offloads_disable+0x5b/0x90 [mlx5_core]
> [  401.511724]  mlx5_eswitch_disable.cold+0xdf/0x176 [mlx5_core]
> [  401.511759]  mlx5_device_disable_sriov+0xab/0xb0 [mlx5_core]
> [  401.511794]  mlx5_core_sriov_configure+0xaf/0xd0 [mlx5_core]
> [  401.511805]  sriov_numvfs_store+0xf8/0x130
> [  401.511817]  kernfs_fop_write+0x122/0x1b0
> [  401.511826]  vfs_write+0xdb/0x1d0
> [  401.511835]  ksys_write+0x65/0xe0
> [  401.511847]  do_syscall_64+0x5c/0xb0
> [  401.511857]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [  401.511862] RIP: 0033:0x7fad892d30f8
> [  401.511868] Code: 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 25 96 0d 00 8b 00 85 c0 75 17 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 60 c3 0f 1f 80 00 00 00 00 48 83
>  ec 28 48 89
> [  401.511871] RSP: 002b:00007ffca2a9fad8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> [  401.511875] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fad892d30f8
> [  401.511878] RDX: 0000000000000002 RSI: 000055afeb072a90 RDI: 0000000000000001
> [  401.511881] RBP: 000055afeb072a90 R08: 00000000ffffffff R09: 000000000000000a
> [  401.511884] R10: 000055afeb058710 R11: 0000000000000246 R12: 0000000000000002
> [  401.511887] R13: 00007fad893a8780 R14: 0000000000000002 R15: 00007fad893a3740
>
> I don't think it is correct approach to try to call these callbacks with
> rcu protection because:
>
> - Cls API uses sleeping locks that cannot be used in rcu read section
>   (hence the included trace).
>
> - It assumes that all implementation of classifier ops reoffload() don't
>   sleep.
>
> - And that all driver offload callbacks (both block and classifier
>   setup) don't sleep, which is not the case.
>
> I don't see any straightforward way to fix this, besides using some
> other locking mechanism to protect block_ing_cb_list.
>
> Regards,
> Vlad

Maybe get the  mutex flow_indr_block_ing_cb_lock for both lookup, add, delete? 

the callbacks_lists. the add and delete is work only on modules init case. So the

lookup is also not frequently(ony [un]register) and can protect with the locks.

