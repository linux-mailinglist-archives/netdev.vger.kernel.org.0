Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F8A509680
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 07:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384263AbiDUFQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 01:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384239AbiDUFPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 01:15:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F42511C1D;
        Wed, 20 Apr 2022 22:13:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05953B82292;
        Thu, 21 Apr 2022 05:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D10C385A8;
        Thu, 21 Apr 2022 05:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650517983;
        bh=GupdIMNN8SYFZI4KlSZ7kY7p05ocOXjm9u2M3VgtpNk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pmO1t3Y26l2zGHCmrr9omOPZ9YP1yKDrCvSEacuTjalYae8IZnjzMG1nT03t+XGZ+
         vAHJlhL8haEYUHdvQd+p+Afov6w3VdOm4aqKkzYHmund8ANOjufTiVDlYcpBY3ytnb
         IISPRN4SqSlWndU7TmzBap17cJYS7z+l7mEzuz7oam5sBh4Jelm7McE9RUSLGP7g6/
         I7HQa4xKGr8uHV1BShg2t3A+IirGriwW5df1tMNbqFVmyIxA1osrvVl08azjNCiWTX
         8mNn4ie67tRDzrGjiB0CvPtoXhlIPrIreCk5V23l/X+GAuzUDmsK/OHm1HO5/BuzMu
         yWRtG19v9v4tw==
Date:   Thu, 21 Apr 2022 08:12:58 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org, poros@redhat.com, mschmidt@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] ice: Fix race during aux device (un)plugging
Message-ID: <YmDn2ptpRHasOQag@unreal>
References: <20220420150300.1062689-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420150300.1062689-1-ivecera@redhat.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 05:02:59PM +0200, Ivan Vecera wrote:
> Function ice_plug_aux_dev() assigns pf->adev field too early prior
> aux device initialization and on other side ice_unplug_aux_dev()
> starts aux device deinit and at the end assigns NULL to pf->adev.
> This is wrong because pf->adev should always be non-NULL only when
> aux device is fully initialized and ready. This wrong order causes
> a crash when ice_send_event_to_aux() call occurs because that function
> depends on non-NULL value of pf->adev and does not assume that
> aux device is half-initialized or half-destroyed.
> After order correction the race window is tiny but it is still there,
> as Leon mentioned and manipulation with pf->adev needs to be protected
> by mutex.
> 
> Fix (un-)plugging functions so pf->adev field is set after aux device
> init and prior aux device destroy and protect pf->adev assignment by
> new mutex. This mutex is also held during ice_send_event_to_aux()
> call to ensure that aux device is valid during that call. Device
> lock used ice_send_event_to_aux() to avoid its concurrent run can
> be removed as this is secured by that mutex.
> 
> Reproducer:
> cycle=1
> while :;do
>         echo "#### Cycle: $cycle"
> 
>         ip link set ens7f0 mtu 9000
>         ip link add bond0 type bond mode 1 miimon 100
>         ip link set bond0 up
>         ifenslave bond0 ens7f0
>         ip link set bond0 mtu 9000
>         ethtool -L ens7f0 combined 1
>         ip link del bond0
>         ip link set ens7f0 mtu 1500
>         sleep 1
> 
>         let cycle++
> done
> 
> In short when the device is added/removed to/from bond the aux device
> is unplugged/plugged. When MTU of the device is changed an event is
> sent to aux device asynchronously. This can race with (un)plugging
> operation and because pf->adev is set too early (plug) or too late
> (unplug) the function ice_send_event_to_aux() can touch uninitialized
> or destroyed fields. In the case of crash below pf->adev->dev.mutex.
> 
> Crash:
> [   53.372066] bond0: (slave ens7f0): making interface the new active one
> [   53.378622] bond0: (slave ens7f0): Enslaving as an active interface with an u
> p link
> [   53.386294] IPv6: ADDRCONF(NETDEV_CHANGE): bond0: link becomes ready
> [   53.549104] bond0: (slave ens7f1): Enslaving as a backup interface with an up
>  link
> [   54.118906] ice 0000:ca:00.0 ens7f0: Number of in use tx queues changed inval
> idating tc mappings. Priority traffic classification disabled!
> [   54.233374] ice 0000:ca:00.1 ens7f1: Number of in use tx queues changed inval
> idating tc mappings. Priority traffic classification disabled!
> [   54.248204] bond0: (slave ens7f0): Releasing backup interface
> [   54.253955] bond0: (slave ens7f1): making interface the new active one
> [   54.274875] bond0: (slave ens7f1): Releasing backup interface
> [   54.289153] bond0 (unregistering): Released all slaves
> [   55.383179] MII link monitoring set to 100 ms
> [   55.398696] bond0: (slave ens7f0): making interface the new active one
> [   55.405241] BUG: kernel NULL pointer dereference, address: 0000000000000080
> [   55.405289] bond0: (slave ens7f0): Enslaving as an active interface with an u
> p link
> [   55.412198] #PF: supervisor write access in kernel mode
> [   55.412200] #PF: error_code(0x0002) - not-present page
> [   55.412201] PGD 25d2ad067 P4D 0
> [   55.412204] Oops: 0002 [#1] PREEMPT SMP NOPTI
> [   55.412207] CPU: 0 PID: 403 Comm: kworker/0:2 Kdump: loaded Tainted: G S
>            5.17.0-13579-g57f2d6540f03 #1
> [   55.429094] bond0: (slave ens7f1): Enslaving as a backup interface with an up
>  link
> [   55.430224] Hardware name: Dell Inc. PowerEdge R750/06V45N, BIOS 1.4.4 10/07/
> 2021
> [   55.430226] Workqueue: ice ice_service_task [ice]
> [   55.468169] RIP: 0010:mutex_unlock+0x10/0x20
> [   55.472439] Code: 0f b1 13 74 96 eb e0 4c 89 ee eb d8 e8 79 54 ff ff 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 65 48 8b 04 25 40 ef 01 00 31 d2 <f0> 48 0f b1 17 75 01 c3 e9 e3 fe ff ff 0f 1f 00 0f 1f 44 00 00 48
> [   55.491186] RSP: 0018:ff4454230d7d7e28 EFLAGS: 00010246
> [   55.496413] RAX: ff1a79b208b08000 RBX: ff1a79b2182e8880 RCX: 0000000000000001
> [   55.503545] RDX: 0000000000000000 RSI: ff4454230d7d7db0 RDI: 0000000000000080
> [   55.510678] RBP: ff1a79d1c7e48b68 R08: ff4454230d7d7db0 R09: 0000000000000041
> [   55.517812] R10: 00000000000000a5 R11: 00000000000006e6 R12: ff1a79d1c7e48bc0
> [   55.524945] R13: 0000000000000000 R14: ff1a79d0ffc305c0 R15: 0000000000000000
> [   55.532076] FS:  0000000000000000(0000) GS:ff1a79d0ffc00000(0000) knlGS:0000000000000000
> [   55.540163] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   55.545908] CR2: 0000000000000080 CR3: 00000003487ae003 CR4: 0000000000771ef0
> [   55.553041] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   55.560173] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   55.567305] PKRU: 55555554
> [   55.570018] Call Trace:
> [   55.572474]  <TASK>
> [   55.574579]  ice_service_task+0xaab/0xef0 [ice]
> [   55.579130]  process_one_work+0x1c5/0x390
> [   55.583141]  ? process_one_work+0x390/0x390
> [   55.587326]  worker_thread+0x30/0x360
> [   55.590994]  ? process_one_work+0x390/0x390
> [   55.595180]  kthread+0xe6/0x110
> [   55.598325]  ? kthread_complete_and_exit+0x20/0x20
> [   55.603116]  ret_from_fork+0x1f/0x30
> [   55.606698]  </TASK>
> 
> Fixes: f9f5301e7e2d ("ice: Register auxiliary device to provide RDMA")
> Cc: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
>  drivers/net/ethernet/intel/ice/ice.h      |  1 +
>  drivers/net/ethernet/intel/ice/ice_idc.c  | 33 ++++++++++++++---------
>  drivers/net/ethernet/intel/ice/ice_main.c |  2 ++
>  3 files changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
> index 8ed3c9ab7ff7..a895e3a8e988 100644
> --- a/drivers/net/ethernet/intel/ice/ice.h
> +++ b/drivers/net/ethernet/intel/ice/ice.h
> @@ -540,6 +540,7 @@ struct ice_pf {
>  	struct mutex avail_q_mutex;	/* protects access to avail_[rx|tx]qs */
>  	struct mutex sw_mutex;		/* lock for protecting VSI alloc flow */
>  	struct mutex tc_mutex;		/* lock to protect TC changes */
> +	struct mutex adev_mutex;	/* lock to protect aux device access */
>  	u32 msg_enable;
>  	struct ice_ptp ptp;
>  	struct tty_driver *ice_gnss_tty_driver;
> diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
> index 25a436d342c2..aef07accd63b 100644
> --- a/drivers/net/ethernet/intel/ice/ice_idc.c
> +++ b/drivers/net/ethernet/intel/ice/ice_idc.c
> @@ -10,13 +10,15 @@
>   * ice_get_auxiliary_drv - retrieve iidc_auxiliary_drv struct
>   * @pf: pointer to PF struct
>   *
> - * This function has to be called with a device_lock on the
> - * pf->adev.dev to avoid race conditions.
> + * This function has to be called with pf->adev_mutex held
> + * to avoid race conditions.
>   */
>  static struct iidc_auxiliary_drv *ice_get_auxiliary_drv(struct ice_pf *pf)
>  {
>  	struct auxiliary_device *adev;
>  
> +	BUG_ON(!mutex_is_locked(&pf->adev_mutex));

Please don't add BUG_ON() in driver code.

I think that you are looking for lockdep_assert_held(&pf->adev_mutex).

Thanks
