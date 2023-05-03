Return-Path: <netdev+bounces-116-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ED4B6F5316
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 10:25:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B22E31C20CEF
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 08:25:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF1A87485;
	Wed,  3 May 2023 08:25:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C963D74
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 08:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA87C433D2;
	Wed,  3 May 2023 08:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683102302;
	bh=kwzoBQZbVOKI8X38a9WPQVh/mLTbCm/vUGPzuw89sg0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PT0whP1E+mgi59P5RFe0ZUWHc1CN40uMogfW95xuo2vJWngdL38JbJ3/FSx4Uo8+R
	 O9tl6YfOp+XpDJooRySMyGn4bLyGkcCZSFYAJddQXGzNeSlHiQpZowOZPAktBt0GFI
	 NIwTsWL5sC7hch0UywWB/N/HlyFY9HcYgNKof1wXernyPTyQisdcIPllny0Sf5SMBj
	 VX/qD1dswQB/7oTICH5np6AdOCFVOPIlGZ6v3JxOM9STzFlp/QyG+Vc/P/nUlMGfnQ
	 EthWt9TEs16Bxgve8hjKDk897H4eizujxgBssRNUZ84RNncTTg7U9HSyARna8zQPie
	 3yQ9jZtzDSk5w==
Date: Wed, 3 May 2023 11:24:58 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Ding Hui <dinghui@sangfor.com.cn>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
	jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
	keescook@chromium.org, grzegorzx.szczurek@intel.com,
	mateusz.palczewski@intel.com, mitch.a.williams@intel.com,
	gregory.v.rose@intel.com, jeffrey.t.kirsher@intel.com,
	michal.kubiak@intel.com, simon.horman@corigine.com,
	madhu.chittim@intel.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	pengdonglin@sangfor.com.cn, huangcun@sangfor.com.cn
Subject: Re: [PATCH net v4 2/2] iavf: Fix out-of-bounds when setting channels
 on remove
Message-ID: <20230503082458.GH525452@unreal>
References: <20230503031541.27855-1-dinghui@sangfor.com.cn>
 <20230503031541.27855-3-dinghui@sangfor.com.cn>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230503031541.27855-3-dinghui@sangfor.com.cn>

On Wed, May 03, 2023 at 11:15:41AM +0800, Ding Hui wrote:
> If we set channels greater when iavf_remove, the waiting reset done
> will be timeout, then returned with error but changed num_active_queues
> directly, that will lead to OOB like the following logs. Because the
> num_active_queues is greater than tx/rx_rings[] allocated actually.
> 
> Reproducer:
> 
>   [root@host ~]# cat repro.sh
>   #!/bin/bash
> 
>   pf_dbsf="0000:41:00.0"
>   vf0_dbsf="0000:41:02.0"
>   g_pids=()
> 
>   function do_set_numvf()
>   {
>       echo 2 >/sys/bus/pci/devices/${pf_dbsf}/sriov_numvfs
>       sleep $((RANDOM%3+1))
>       echo 0 >/sys/bus/pci/devices/${pf_dbsf}/sriov_numvfs
>       sleep $((RANDOM%3+1))
>   }
> 
>   function do_set_channel()
>   {
>       local nic=$(ls -1 --indicator-style=none /sys/bus/pci/devices/${vf0_dbsf}/net/)
>       [ -z "$nic" ] && { sleep $((RANDOM%3)) ; return 1; }
>       ifconfig $nic 192.168.18.5 netmask 255.255.255.0
>       ifconfig $nic up
>       ethtool -L $nic combined 1
>       ethtool -L $nic combined 4
>       sleep $((RANDOM%3))
>   }
> 
>   function on_exit()
>   {
>       local pid
>       for pid in "${g_pids[@]}"; do
>           kill -0 "$pid" &>/dev/null && kill "$pid" &>/dev/null
>       done
>       g_pids=()
>   }
> 
>   trap "on_exit; exit" EXIT
> 
>   while :; do do_set_numvf ; done &
>   g_pids+=($!)
>   while :; do do_set_channel ; done &
>   g_pids+=($!)
> 
>   wait
> 
> Result:
> 
> [ 3506.152887] iavf 0000:41:02.0: Removing device
> [ 3510.400799] ==================================================================
> [ 3510.400820] BUG: KASAN: slab-out-of-bounds in iavf_free_all_tx_resources+0x156/0x160 [iavf]
> [ 3510.400823] Read of size 8 at addr ffff88b6f9311008 by task repro.sh/55536
> [ 3510.400823]
> [ 3510.400830] CPU: 101 PID: 55536 Comm: repro.sh Kdump: loaded Tainted: G           O     --------- -t - 4.18.0 #1
> [ 3510.400832] Hardware name: Powerleader PR2008AL/H12DSi-N6, BIOS 2.0 04/09/2021
> [ 3510.400835] Call Trace:
> [ 3510.400851]  dump_stack+0x71/0xab
> [ 3510.400860]  print_address_description+0x6b/0x290
> [ 3510.400865]  ? iavf_free_all_tx_resources+0x156/0x160 [iavf]
> [ 3510.400868]  kasan_report+0x14a/0x2b0
> [ 3510.400873]  iavf_free_all_tx_resources+0x156/0x160 [iavf]
> [ 3510.400880]  iavf_remove+0x2b6/0xc70 [iavf]
> [ 3510.400884]  ? iavf_free_all_rx_resources+0x160/0x160 [iavf]
> [ 3510.400891]  ? wait_woken+0x1d0/0x1d0
> [ 3510.400895]  ? notifier_call_chain+0xc1/0x130
> [ 3510.400903]  pci_device_remove+0xa8/0x1f0
> [ 3510.400910]  device_release_driver_internal+0x1c6/0x460
> [ 3510.400916]  pci_stop_bus_device+0x101/0x150
> [ 3510.400919]  pci_stop_and_remove_bus_device+0xe/0x20
> [ 3510.400924]  pci_iov_remove_virtfn+0x187/0x420
> [ 3510.400927]  ? pci_iov_add_virtfn+0xe10/0xe10
> [ 3510.400929]  ? pci_get_subsys+0x90/0x90
> [ 3510.400932]  sriov_disable+0xed/0x3e0
> [ 3510.400936]  ? bus_find_device+0x12d/0x1a0
> [ 3510.400953]  i40e_free_vfs+0x754/0x1210 [i40e]
> [ 3510.400966]  ? i40e_reset_all_vfs+0x880/0x880 [i40e]
> [ 3510.400968]  ? pci_get_device+0x7c/0x90
> [ 3510.400970]  ? pci_get_subsys+0x90/0x90
> [ 3510.400982]  ? pci_vfs_assigned.part.7+0x144/0x210
> [ 3510.400987]  ? __mutex_lock_slowpath+0x10/0x10
> [ 3510.400996]  i40e_pci_sriov_configure+0x1fa/0x2e0 [i40e]
> [ 3510.401001]  sriov_numvfs_store+0x214/0x290
> [ 3510.401005]  ? sriov_totalvfs_show+0x30/0x30
> [ 3510.401007]  ? __mutex_lock_slowpath+0x10/0x10
> [ 3510.401011]  ? __check_object_size+0x15a/0x350
> [ 3510.401018]  kernfs_fop_write+0x280/0x3f0
> [ 3510.401022]  vfs_write+0x145/0x440
> [ 3510.401025]  ksys_write+0xab/0x160
> [ 3510.401028]  ? __ia32_sys_read+0xb0/0xb0
> [ 3510.401031]  ? fput_many+0x1a/0x120
> [ 3510.401032]  ? filp_close+0xf0/0x130
> [ 3510.401038]  do_syscall_64+0xa0/0x370
> [ 3510.401041]  ? page_fault+0x8/0x30
> [ 3510.401043]  entry_SYSCALL_64_after_hwframe+0x65/0xca
> [ 3510.401073] RIP: 0033:0x7f3a9bb842c0
> [ 3510.401079] Code: 73 01 c3 48 8b 0d d8 cb 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 89 24 2d 00 00 75 10 b8 01 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 fe dd 01 00 48 89 04 24
> [ 3510.401080] RSP: 002b:00007ffc05f1fe18 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> [ 3510.401083] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f3a9bb842c0
> [ 3510.401085] RDX: 0000000000000002 RSI: 0000000002327408 RDI: 0000000000000001
> [ 3510.401086] RBP: 0000000002327408 R08: 00007f3a9be53780 R09: 00007f3a9c8a4700
> [ 3510.401086] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000002
> [ 3510.401087] R13: 0000000000000001 R14: 00007f3a9be52620 R15: 0000000000000001
> [ 3510.401090]
> [ 3510.401093] Allocated by task 76795:
> [ 3510.401098]  kasan_kmalloc+0xa6/0xd0
> [ 3510.401099]  __kmalloc+0xfb/0x200
> [ 3510.401104]  iavf_init_interrupt_scheme+0x26f/0x1310 [iavf]
> [ 3510.401108]  iavf_watchdog_task+0x1d58/0x4050 [iavf]
> [ 3510.401114]  process_one_work+0x56a/0x11f0
> [ 3510.401115]  worker_thread+0x8f/0xf40
> [ 3510.401117]  kthread+0x2a0/0x390
> [ 3510.401119]  ret_from_fork+0x1f/0x40
> [ 3510.401122]  0xffffffffffffffff
> [ 3510.401123]
> 
> If we detected removing is in processing, we can avoid unnecessary
> waiting and return error faster.
> 
> On the other hand in timeout handling, we should keep the original
> num_active_queues and reset num_req_queues to 0.
> 
> Fixes: 4e5e6b5d9d13 ("iavf: Fix return of set the new channel count")
> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> Cc: Donglin Peng <pengdonglin@sangfor.com.cn>
> Cc: Huang Cun <huangcun@sangfor.com.cn>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
> ---
> v3 to v4:
>   - nothing changed
> 
> v2 to v3:
>   - fix review tag
> 
> v1 to v2:
>   - add reproduction script
> 
> ---
>  drivers/net/ethernet/intel/iavf/iavf_ethtool.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> index 6f171d1d85b7..d8a3c0cfedd0 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> @@ -1857,13 +1857,15 @@ static int iavf_set_channels(struct net_device *netdev,
>  	/* wait for the reset is done */
>  	for (i = 0; i < IAVF_RESET_WAIT_COMPLETE_COUNT; i++) {
>  		msleep(IAVF_RESET_WAIT_MS);
> +		if (test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))
> +			return -EOPNOTSUPP;

This makes no sense without locking as change to __IAVF_IN_REMOVE_TASK
can happen any time.

Thanks

>  		if (adapter->flags & IAVF_FLAG_RESET_PENDING)
>  			continue;
>  		break;
>  	}
>  	if (i == IAVF_RESET_WAIT_COMPLETE_COUNT) {
>  		adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
> -		adapter->num_active_queues = num_req;
> +		adapter->num_req_queues = 0;
>  		return -EOPNOTSUPP;
>  	}
>  
> -- 
> 2.17.1
> 
> 

