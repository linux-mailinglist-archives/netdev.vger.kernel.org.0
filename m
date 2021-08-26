Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830B23F83A5
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 10:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240315AbhHZIUd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 26 Aug 2021 04:20:33 -0400
Received: from mga14.intel.com ([192.55.52.115]:17128 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232992AbhHZIUd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 04:20:33 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10087"; a="217416281"
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="217416281"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2021 01:19:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="494972528"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga008.fm.intel.com with ESMTP; 26 Aug 2021 01:19:44 -0700
Date:   Thu, 26 Aug 2021 10:03:49 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     PJ Waskiewicz <pwaskiewicz@jumptrading.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        PJ Waskiewicz <pjwaskiewicz@gmail.com>
Subject: Re: [PATCH 1/1] i40e: Avoid double IRQ free on error path in probe()
Message-ID: <20210826080349.GA32032@ranger.igk.intel.com>
References: <20210825192321.32784-1-pwaskiewicz@jumptrading.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20210825192321.32784-1-pwaskiewicz@jumptrading.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 02:23:21PM -0500, PJ Waskiewicz wrote:
> This fixes an error path condition when probe() fails due to the
> default VSI not being available or online yet in the firmware. If
> that happens, the previous teardown path would clear the interrupt
> scheme, which also freed the IRQs with the OS. Then the error path
> for the switch setup (pre-VSI) would attempt to free the OS IRQs
> as well.

Nice to hear from you PJ.
Looks like a 'net' candidate, so we need a Fixes: tag.

Also, you probably should send it to iwl with cc to netdev and Tony will
pick and combine it into his pull request.

Patch LGTM.
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> 
> [   14.597121] i40e 0000:31:00.0: setup of MAIN VSI failed
> [   14.712167] i40e 0000:31:00.0: setup_pf_switch failed: -11
> [   14.755318] ------------[ cut here ]------------
> [   14.766261] Trying to free already-free IRQ 266
> [   14.777224] WARNING: CPU: 0 PID: 5 at kernel/irq/manage.c:1731 __free_irq+0x9a/0x300
> [   14.791341] Modules linked in: XXXXXX
> [   14.825361] CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted <kernel omitted>
> [   14.840630] Hardware name: XXXXXX
> [   14.854924] Workqueue: events work_for_cpu_fn
> [   14.866482] RIP: 0010:__free_irq+0x9a/0x300
> [   14.877638] Code: 08 75 0e e9 3c 02 00 00 4c 39 6b 08 74 59 48 89 da 48 8b 5a 18 48 85 db 75 ee 8b 74 24 04 48 c7 c7 58 a0 aa b4 e8 3f 2e f9 ff <0f> 0b 4c 89 f6 48 89 ef e8 f9 69 7b 00 49 8b 47 40 48 8b 80 80 00
> [   14.910571] RSP: 0000:ff6a6ad7401dfb60 EFLAGS: 00010086
> [   14.923265] RAX: 0000000000000000 RBX: ff3c97328eb56000 RCX: 0000000000000006
> [   14.937853] RDX: 0000000000000007 RSI: 0000000000000092 RDI: ff3c97333ee16a00
> [   14.952290] RBP: ff3c9731cff4caa4 R08: 00000000000006b8 R09: 0000000000aaaaaa
> [   14.966781] R10: 0000000000000000 R11: ff6a6ad768aff020 R12: ff3c9731cff4cb80
> [   14.981436] R13: ff3c97328eb56000 R14: 0000000000000246 R15: ff3c9731cff4ca00
> [   14.996041] FS:  0000000000000000(0000) GS:ff3c97333ee00000(0000) knlGS:0000000000000000
> [   15.011511] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   15.024493] CR2: 00007fb6ac002000 CR3: 00000004f8c0a001 CR4: 0000000000761ef0
> [   15.039373] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   15.054426] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   15.068781] PKRU: 55555554
> [   15.078902] Call Trace:
> [   15.088421]  ? synchronize_irq+0x3a/0xa0
> [   15.099556]  free_irq+0x2e/0x60
> [   15.109863]  i40e_clear_interrupt_scheme+0x53/0x190 [i40e]
> [   15.122718]  i40e_probe.part.108+0x134b/0x1a40 [i40e]
> [   15.135343]  ? kmem_cache_alloc+0x158/0x1c0
> [   15.146688]  ? acpi_ut_update_ref_count.part.1+0x8e/0x345
> [   15.159217]  ? acpi_ut_update_object_reference+0x15e/0x1e2
> [   15.171879]  ? strstr+0x21/0x70
> [   15.181802]  ? irq_get_irq_data+0xa/0x20
> [   15.193198]  ? mp_check_pin_attr+0x13/0xc0
> [   15.203909]  ? irq_get_irq_data+0xa/0x20
> [   15.214310]  ? mp_map_pin_to_irq+0xd3/0x2f0
> [   15.225206]  ? acpi_register_gsi_ioapic+0x93/0x170
> [   15.236351]  ? pci_conf1_read+0xa4/0x100
> [   15.246586]  ? pci_bus_read_config_word+0x49/0x70
> [   15.257608]  ? do_pci_enable_device+0xcc/0x100
> [   15.268337]  local_pci_probe+0x41/0x90
> [   15.279016]  work_for_cpu_fn+0x16/0x20
> [   15.289545]  process_one_work+0x1a7/0x360
> [   15.300214]  worker_thread+0x1cf/0x390
> [   15.309980]  ? create_worker+0x1a0/0x1a0
> [   15.319854]  kthread+0x112/0x130
> [   15.328806]  ? kthread_flush_work_fn+0x10/0x10
> [   15.338739]  ret_from_fork+0x1f/0x40
> [   15.347622] ---[ end trace 5220551832349274 ]---
> 
> Break apart the clear and reset schemes so that clear no longer
> calls i40_reset_interrupt_capability(), allowing that to be called
> across error paths in probe().
> 
> Signed-off-by: PJ Waskiewicz <pwaskiewicz@jumptrading.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> index 2f20980dd9a5..4d60da44f832 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -4865,7 +4865,8 @@ static void i40e_reset_interrupt_capability(struct i40e_pf *pf)
>   * @pf: board private structure
>   *
>   * We go through and clear interrupt specific resources and reset the structure
> - * to pre-load conditions
> + * to pre-load conditions.  OS interrupt teardown must be done separately due
> + * to VSI vs. PF instantiation, and different teardown path requirements.

Small nit: no need for a dot in 'vs.' ?

>   **/
>  static void i40e_clear_interrupt_scheme(struct i40e_pf *pf)
>  {
> @@ -4880,7 +4881,6 @@ static void i40e_clear_interrupt_scheme(struct i40e_pf *pf)
>         for (i = 0; i < pf->num_alloc_vsi; i++)
>                 if (pf->vsi[i])
>                         i40e_vsi_free_q_vectors(pf->vsi[i]);
> -       i40e_reset_interrupt_capability(pf);
>  }
> 
>  /**
> @@ -10526,6 +10526,7 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
>                          */
>                         free_irq(pf->pdev->irq, pf);
>                         i40e_clear_interrupt_scheme(pf);
> +                       i40e_reset_interrupt_capability(pf);
>                         if (i40e_restore_interrupt_scheme(pf))
>                                 goto end_unlock;
>                 }
> @@ -15928,6 +15929,7 @@ static void i40e_remove(struct pci_dev *pdev)
>         /* Clear all dynamic memory lists of rings, q_vectors, and VSIs */
>         rtnl_lock();
>         i40e_clear_interrupt_scheme(pf);
> +       i40e_reset_interrupt_capability(pf);
>         for (i = 0; i < pf->num_alloc_vsi; i++) {
>                 if (pf->vsi[i]) {
>                         if (!test_bit(__I40E_RECOVERY_MODE, pf->state))
> @@ -16150,6 +16152,7 @@ static void i40e_shutdown(struct pci_dev *pdev)
>          */
>         rtnl_lock();
>         i40e_clear_interrupt_scheme(pf);
> +       i40e_reset_interrupt_capability(pf);
>         rtnl_unlock();
> 
>         if (system_state == SYSTEM_POWER_OFF) {
> @@ -16202,6 +16205,7 @@ static int __maybe_unused i40e_suspend(struct device *dev)
>          * to CPU0.
>          */
>         i40e_clear_interrupt_scheme(pf);
> +       i40e_reset_interrupt_capability(pf);
> 
>         rtnl_unlock();
> 
> --
> 2.27.0
> 
> 

And probably talk to your IT dep to get rid of the footer :P

> ________________________________
> 
> Note: This email is for the confidential use of the named addressee(s) only and may contain proprietary, confidential, or privileged information and/or personal data. If you are not the intended recipient, you are hereby notified that any review, dissemination, or copying of this email is strictly prohibited, and requested to notify the sender immediately and destroy this email and any attachments. Email transmission cannot be guaranteed to be secure or error-free. The Company, therefore, does not make any guarantees as to the completeness or accuracy of this email or any attachments. This email is for informational purposes only and does not constitute a recommendation, offer, request, or solicitation of any kind to buy, sell, subscribe, redeem, or perform any type of transaction of a financial product. Personal data, as defined by applicable data protection and privacy laws, contained in this email may be processed by the Company, and any of its affiliated or related companies, for legal, compliance, and/or business-related purposes. You may have rights regarding your personal data; for information on exercising these rights or the Company’s treatment of personal data, please email datarequests@jumptrading.com.
