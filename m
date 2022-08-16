Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7D4595C30
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 14:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234999AbiHPMq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 08:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbiHPMpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 08:45:42 -0400
Received: from mail-m11877.qiye.163.com (mail-m11877.qiye.163.com [115.236.118.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEE05FF47;
        Tue, 16 Aug 2022 05:44:36 -0700 (PDT)
Received: from [0.0.0.0] (unknown [IPV6:240e:3b7:3274:d420:f016:f71e:22e3:3c38])
        by mail-m11877.qiye.163.com (Hmail) with ESMTPA id 14B7A400636;
        Tue, 16 Aug 2022 20:44:33 +0800 (CST)
Message-ID: <74f0969a-7b15-0ceb-4ae8-08c242cd1f83@sangfor.com.cn>
Date:   Tue, 16 Aug 2022 20:44:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [net v2 1/1] ice: Fix crash by keep old cfg when update TCs more
 than queues
Content-Language: en-US
To:     Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, keescook@chromium.org,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20220815011844.22193-1-dinghui@sangfor.com.cn>
 <dd4f9e5d-d8d7-3069-21ee-7897b3d10d3d@intel.com>
From:   Ding Hui <dinghui@sangfor.com.cn>
In-Reply-To: <dd4f9e5d-d8d7-3069-21ee-7897b3d10d3d@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCTU1DVktITUlNQ0xJH0JDSFUTARMWGhIXJBQOD1
        lXWRgSC1lBWUlPSx5BSBlMQUhJTE9BH09JS0EdS0pNQR1MSh5BSUkeSEFIGEhDWVdZFhoPEhUdFF
        lBWU9LSFVKSktISkNVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Kz46NAw5LT0wARxONEMLMxkO
        DCgwCgxVSlVKTU1LTU5IQ0xPSEpOVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlJT0seQUgZTEFISUxPQR9PSUtBHUtKTUEdTEoeQUlJHkhBSBhIQ1lXWQgBWUFKS0xKTDcG
X-HM-Tid: 0a82a6af2ac42eb3kusn14b7a400636
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/8/16 17:13, Anatolii Gerasymenko wrote:
> On 15.08.2022 03:18, Ding Hui wrote:
>> There are problems if allocated queues less than Traffic Classes.
>>
>> Commit a632b2a4c920 ("ice: ethtool: Prohibit improper channel config
>> for DCB") already disallow setting less queues than TCs.
>>
>> Another case is if we first set less queues, and later update more TCs
>> config due to LLDP, ice_vsi_cfg_tc() will failed but left dirty
>> num_txq/rxq and tc_cfg in vsi, that will cause invalid porinter access.
> 
> Nice catch. Looks good to me.

Thanks, I'll send v3 later, could I add Acked-by: tag too?

>   
>> [   95.968089] ice 0000:3b:00.1: More TCs defined than queues/rings allocated.
>> [   95.968092] ice 0000:3b:00.1: Trying to use more Rx queues (8), than were allocated (1)!
>> [   95.968093] ice 0000:3b:00.1: Failed to config TC for VSI index: 0
>> [   95.969621] general protection fault: 0000 [#1] SMP NOPTI
>> [   95.969705] CPU: 1 PID: 58405 Comm: lldpad Kdump: loaded Tainted: G     U  W  O     --------- -t - 4.18.0 #1
>> [   95.969867] Hardware name: O.E.M/BC11SPSCB10, BIOS 8.23 12/30/2021
>> [   95.969992] RIP: 0010:devm_kmalloc+0xa/0x60
>> [   95.970052] Code: 5c ff ff ff 31 c0 5b 5d 41 5c c3 b8 f4 ff ff ff eb f4 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 89 d1 <8b> 97 60 02 00 00 48 8d 7e 18 48 39 f7 72 3f 55 89 ce 53 48 8b 4c
>> [   95.970344] RSP: 0018:ffffc9003f553888 EFLAGS: 00010206
>> [   95.970425] RAX: dead000000000200 RBX: ffffea003c425b00 RCX: 00000000006080c0
>> [   95.970536] RDX: 00000000006080c0 RSI: 0000000000000200 RDI: dead000000000200
>> [   95.970648] RBP: dead000000000200 R08: 00000000000463c0 R09: ffff888ffa900000
>> [   95.970760] R10: 0000000000000000 R11: 0000000000000002 R12: ffff888ff6b40100
>> [   95.970870] R13: ffff888ff6a55018 R14: 0000000000000000 R15: ffff888ff6a55460
>> [   95.970981] FS:  00007f51b7d24700(0000) GS:ffff88903ee80000(0000) knlGS:0000000000000000
>> [   95.971108] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   95.971197] CR2: 00007fac5410d710 CR3: 0000000f2c1de002 CR4: 00000000007606e0
>> [   95.971309] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [   95.971419] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> [   95.971530] PKRU: 55555554
>> [   95.971573] Call Trace:
>> [   95.971622]  ice_setup_rx_ring+0x39/0x110 [ice]
>> [   95.971695]  ice_vsi_setup_rx_rings+0x54/0x90 [ice]
>> [   95.971774]  ice_vsi_open+0x25/0x120 [ice]
>> [   95.971843]  ice_open_internal+0xb8/0x1f0 [ice]
>> [   95.971919]  ice_ena_vsi+0x4f/0xd0 [ice]
>> [   95.971987]  ice_dcb_ena_dis_vsi.constprop.5+0x29/0x90 [ice]
>> [   95.972082]  ice_pf_dcb_cfg+0x29a/0x380 [ice]
>> [   95.972154]  ice_dcbnl_setets+0x174/0x1b0 [ice]
>> [   95.972220]  dcbnl_ieee_set+0x89/0x230
>> [   95.972279]  ? dcbnl_ieee_del+0x150/0x150
>> [   95.972341]  dcb_doit+0x124/0x1b0
>> [   95.972392]  rtnetlink_rcv_msg+0x243/0x2f0
>> [   95.972457]  ? dcb_doit+0x14d/0x1b0
>> [   95.972510]  ? __kmalloc_node_track_caller+0x1d3/0x280
>> [   95.972591]  ? rtnl_calcit.isra.31+0x100/0x100
>> [   95.972661]  netlink_rcv_skb+0xcf/0xf0
>> [   95.972720]  netlink_unicast+0x16d/0x220
>> [   95.972781]  netlink_sendmsg+0x2ba/0x3a0
>> [   95.975891]  sock_sendmsg+0x4c/0x50
>> [   95.979032]  ___sys_sendmsg+0x2e4/0x300
>> [   95.982147]  ? kmem_cache_alloc+0x13e/0x190
>> [   95.985242]  ? __wake_up_common_lock+0x79/0x90
>> [   95.988338]  ? __check_object_size+0xac/0x1b0
>> [   95.991440]  ? _copy_to_user+0x22/0x30
>> [   95.994539]  ? move_addr_to_user+0xbb/0xd0
>> [   95.997619]  ? __sys_sendmsg+0x53/0x80
>> [   96.000664]  __sys_sendmsg+0x53/0x80
>> [   96.003747]  do_syscall_64+0x5b/0x1d0
>> [   96.006862]  entry_SYSCALL_64_after_hwframe+0x65/0xca
>>
>> Only update num_txq/rxq when passed check, and restore tc_cfg if setup
>> queue map failed.
>>
>> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> 
> Please, also add Fixes tag.
> 
>> ---
>>   drivers/net/ethernet/intel/ice/ice_lib.c | 42 +++++++++++++++---------
>>   1 file changed, 26 insertions(+), 16 deletions(-)
>>
>> ---
>> v1:
>> https://patchwork.kernel.org/project/netdevbpf/patch/20220812123933.5481-1-dinghui@sangfor.com.cn/
>>
>> v2:
>>    rewrite subject
>>    rebase to net
>>
>> diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
>> index a830f7f9aed0..6e64cca30351 100644
>> --- a/drivers/net/ethernet/intel/ice/ice_lib.c
>> +++ b/drivers/net/ethernet/intel/ice/ice_lib.c
>> @@ -914,7 +914,7 @@ static void ice_set_dflt_vsi_ctx(struct ice_hw *hw, struct ice_vsi_ctx *ctxt)
>>    */
>>   static int ice_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
>>   {
>> -	u16 offset = 0, qmap = 0, tx_count = 0, pow = 0;
>> +	u16 offset = 0, qmap = 0, tx_count = 0, rx_count = 0, pow = 0;
>>   	u16 num_txq_per_tc, num_rxq_per_tc;
>>   	u16 qcount_tx = vsi->alloc_txq;
>>   	u16 qcount_rx = vsi->alloc_rxq;
>> @@ -981,23 +981,25 @@ static int ice_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
>>   	 * at least 1)
>>   	 */
>>   	if (offset)
>> -		vsi->num_rxq = offset;
>> +		rx_count = offset;
>>   	else
>> -		vsi->num_rxq = num_rxq_per_tc;
>> +		rx_count = num_rxq_per_tc;
>>   
>> -	if (vsi->num_rxq > vsi->alloc_rxq) {
>> +	if (rx_count > vsi->alloc_rxq) {
>>   		dev_err(ice_pf_to_dev(vsi->back), "Trying to use more Rx queues (%u), than were allocated (%u)!\n",
>> -			vsi->num_rxq, vsi->alloc_rxq);
>> +			rx_count, vsi->alloc_rxq);
>>   		return -EINVAL;
>>   	}
>>   
>> -	vsi->num_txq = tx_count;
>> -	if (vsi->num_txq > vsi->alloc_txq) {
>> +	if (tx_count > vsi->alloc_txq) {
>>   		dev_err(ice_pf_to_dev(vsi->back), "Trying to use more Tx queues (%u), than were allocated (%u)!\n",
>> -			vsi->num_txq, vsi->alloc_txq);
>> +			tx_count, vsi->alloc_txq);
>>   		return -EINVAL;
>>   	}
>>   
>> +	vsi->num_txq = tx_count;
>> +	vsi->num_rxq = rx_count;
>> +
>>   	if (vsi->type == ICE_VSI_VF && vsi->num_txq != vsi->num_rxq) {
>>   		dev_dbg(ice_pf_to_dev(vsi->back), "VF VSI should have same number of Tx and Rx queues. Hence making them equal\n");
>>   		/* since there is a chance that num_rxq could have been changed
>> @@ -3492,6 +3494,7 @@ ice_vsi_setup_q_map_mqprio(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt,
>>   	int tc0_qcount = vsi->mqprio_qopt.qopt.count[0];
>>   	u8 netdev_tc = 0;
>>   	int i;
>> +	u16 new_txq, new_rxq;
> 
> Please follow the Reverse Christmas Tree (RCT) convention.
> 
>>   	vsi->tc_cfg.ena_tc = ena_tc ? ena_tc : 1;
>>   
>> @@ -3530,21 +3533,24 @@ ice_vsi_setup_q_map_mqprio(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt,
>>   		}
>>   	}
>>   
>> -	/* Set actual Tx/Rx queue pairs */
>> -	vsi->num_txq = offset + qcount_tx;
>> -	if (vsi->num_txq > vsi->alloc_txq) {
>> +	new_txq = offset + qcount_tx;
>> +	if (new_txq > vsi->alloc_txq) {
>>   		dev_err(ice_pf_to_dev(vsi->back), "Trying to use more Tx queues (%u), than were allocated (%u)!\n",
>> -			vsi->num_txq, vsi->alloc_txq);
>> +			new_txq, vsi->alloc_txq);
>>   		return -EINVAL;
>>   	}
>>   
>> -	vsi->num_rxq = offset + qcount_rx;
>> -	if (vsi->num_rxq > vsi->alloc_rxq) {
>> +	new_rxq = offset + qcount_rx;
>> +	if (new_rxq > vsi->alloc_rxq) {
>>   		dev_err(ice_pf_to_dev(vsi->back), "Trying to use more Rx queues (%u), than were allocated (%u)!\n",
>> -			vsi->num_rxq, vsi->alloc_rxq);
>> +			new_rxq, vsi->alloc_rxq);
>>   		return -EINVAL;
>>   	}
>>   
>> +	/* Set actual Tx/Rx queue pairs */
>> +	vsi->num_txq = new_txq;
>> +	vsi->num_rxq = new_rxq;
>> +
>>   	/* Setup queue TC[0].qmap for given VSI context */
>>   	ctxt->info.tc_mapping[0] = cpu_to_le16(qmap);
>>   	ctxt->info.q_mapping[0] = cpu_to_le16(vsi->rxq_map[0]);
>> @@ -3580,6 +3586,7 @@ int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc)
>>   	struct device *dev;
>>   	int i, ret = 0;
>>   	u8 num_tc = 0;
>> +	struct ice_tc_cfg old_tc_cfg;
> 
> RCT here also.
>    
>>   	dev = ice_pf_to_dev(pf);
>>   	if (vsi->tc_cfg.ena_tc == ena_tc &&
>> @@ -3600,6 +3607,7 @@ int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc)
>>   			max_txqs[i] = vsi->num_txq;
>>   	}
>>   
>> +	memcpy(&old_tc_cfg, &vsi->tc_cfg, sizeof(old_tc_cfg));
>>   	vsi->tc_cfg.ena_tc = ena_tc;
>>   	vsi->tc_cfg.numtc = num_tc;
>>   
>> @@ -3616,8 +3624,10 @@ int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc)
>>   	else
>>   		ret = ice_vsi_setup_q_map(vsi, ctx);
>>   
>> -	if (ret)
>> +	if (ret) {
>> +		memcpy(&vsi->tc_cfg, &old_tc_cfg, sizeof(vsi->tc_cfg));
>>   		goto out;
>> +	}
>>   
>>   	/* must to indicate which section of VSI context are being modified */
>>   	ctx->info.valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_RXQ_MAP_VALID);


-- 
Thanks,
- Ding Hui
