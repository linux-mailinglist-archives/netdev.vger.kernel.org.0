Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C37A11AA40
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 12:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbfLKLzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 06:55:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:16098 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbfLKLzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 06:55:04 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 03:55:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="gz'50?scan'50,208,50";a="210741184"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 11 Dec 2019 03:55:02 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1if0a5-00045o-TQ; Wed, 11 Dec 2019 19:55:01 +0800
Date:   Wed, 11 Dec 2019 19:54:29 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Manish Chopra <manishc@marvell.com>
Cc:     kbuild-all@lists.01.org, davem@davemloft.net,
        netdev@vger.kernel.org, aelior@marvell.com, skalluru@marvell.com
Subject: Re: [PATCH net 1/2] bnx2x: Do not handle requests from VFs after
 parity
Message-ID: <201912111929.X7jXNHRQ%lkp@intel.com>
References: <20191210215623.23950-2-manishc@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7jc6se4wnoi7pe3p"
Content-Disposition: inline
In-Reply-To: <20191210215623.23950-2-manishc@marvell.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7jc6se4wnoi7pe3p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Manish,

I love your patch! Yet something to improve:

[auto build test ERROR on net/master]
[cannot apply to net-next/master sparc-next/master v5.5-rc1 next-20191210]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Manish-Chopra/bnx2x-bug-fixes/20191211-112633
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 24dee0c7478d1a1e00abdf5625b7f921467325dc
config: powerpc-defconfig (attached as .config)
compiler: powerpc64-linux-gcc (GCC) 7.5.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=7.5.0 make.cross ARCH=powerpc 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c: In function 'bnx2x_parity_recover':
>> drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:9983:30: error: 'struct bnx2x' has no member named 'requested_nr_virtfn'
     for (vf_idx = 0; vf_idx < bp->requested_nr_virtfn; vf_idx++) {
                                 ^~
>> drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:9984:28: error: implicit declaration of function 'BP_VF'; did you mean 'BP_VN'? [-Werror=implicit-function-declaration]
      struct bnx2x_virtf *vf = BP_VF(bp, vf_idx);
                               ^~~~~
                               BP_VN
>> drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:9984:28: warning: initialization makes pointer from integer without a cast [-Wint-conversion]
>> drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:9987:6: error: dereferencing pointer to incomplete type 'struct bnx2x_virtf'
       vf->state = VF_LOST;
         ^~
>> drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:9987:16: error: 'VF_LOST' undeclared (first use in this function); did you mean 'AF_ROSE'?
       vf->state = VF_LOST;
                   ^~~~~~~
                   AF_ROSE
   drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:9987:16: note: each undeclared identifier is reported only once for each function it appears in
   cc1: some warnings being treated as errors

vim +9983 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c

  9971	
  9972	/*
  9973	 * Assumption: runs under rtnl lock. This together with the fact
  9974	 * that it's called only from bnx2x_sp_rtnl() ensure that it
  9975	 * will never be called when netif_running(bp->dev) is false.
  9976	 */
  9977	static void bnx2x_parity_recover(struct bnx2x *bp)
  9978	{
  9979		u32 error_recovered, error_unrecovered;
  9980		bool is_parity, global = false;
  9981		int vf_idx;
  9982	
> 9983		for (vf_idx = 0; vf_idx < bp->requested_nr_virtfn; vf_idx++) {
> 9984			struct bnx2x_virtf *vf = BP_VF(bp, vf_idx);
  9985	
  9986			if (vf)
> 9987				vf->state = VF_LOST;
  9988		}
  9989	
  9990		DP(NETIF_MSG_HW, "Handling parity\n");
  9991		while (1) {
  9992			switch (bp->recovery_state) {
  9993			case BNX2X_RECOVERY_INIT:
  9994				DP(NETIF_MSG_HW, "State is BNX2X_RECOVERY_INIT\n");
  9995				is_parity = bnx2x_chk_parity_attn(bp, &global, false);
  9996				WARN_ON(!is_parity);
  9997	
  9998				/* Try to get a LEADER_LOCK HW lock */
  9999				if (bnx2x_trylock_leader_lock(bp)) {
 10000					bnx2x_set_reset_in_progress(bp);
 10001					/*
 10002					 * Check if there is a global attention and if
 10003					 * there was a global attention, set the global
 10004					 * reset bit.
 10005					 */
 10006	
 10007					if (global)
 10008						bnx2x_set_reset_global(bp);
 10009	
 10010					bp->is_leader = 1;
 10011				}
 10012	
 10013				/* Stop the driver */
 10014				/* If interface has been removed - break */
 10015				if (bnx2x_nic_unload(bp, UNLOAD_RECOVERY, false))
 10016					return;
 10017	
 10018				bp->recovery_state = BNX2X_RECOVERY_WAIT;
 10019	
 10020				/* Ensure "is_leader", MCP command sequence and
 10021				 * "recovery_state" update values are seen on other
 10022				 * CPUs.
 10023				 */
 10024				smp_mb();
 10025				break;
 10026	
 10027			case BNX2X_RECOVERY_WAIT:
 10028				DP(NETIF_MSG_HW, "State is BNX2X_RECOVERY_WAIT\n");
 10029				if (bp->is_leader) {
 10030					int other_engine = BP_PATH(bp) ? 0 : 1;
 10031					bool other_load_status =
 10032						bnx2x_get_load_status(bp, other_engine);
 10033					bool load_status =
 10034						bnx2x_get_load_status(bp, BP_PATH(bp));
 10035					global = bnx2x_reset_is_global(bp);
 10036	
 10037					/*
 10038					 * In case of a parity in a global block, let
 10039					 * the first leader that performs a
 10040					 * leader_reset() reset the global blocks in
 10041					 * order to clear global attentions. Otherwise
 10042					 * the gates will remain closed for that
 10043					 * engine.
 10044					 */
 10045					if (load_status ||
 10046					    (global && other_load_status)) {
 10047						/* Wait until all other functions get
 10048						 * down.
 10049						 */
 10050						schedule_delayed_work(&bp->sp_rtnl_task,
 10051									HZ/10);
 10052						return;
 10053					} else {
 10054						/* If all other functions got down -
 10055						 * try to bring the chip back to
 10056						 * normal. In any case it's an exit
 10057						 * point for a leader.
 10058						 */
 10059						if (bnx2x_leader_reset(bp)) {
 10060							bnx2x_recovery_failed(bp);
 10061							return;
 10062						}
 10063	
 10064						/* If we are here, means that the
 10065						 * leader has succeeded and doesn't
 10066						 * want to be a leader any more. Try
 10067						 * to continue as a none-leader.
 10068						 */
 10069						break;
 10070					}
 10071				} else { /* non-leader */
 10072					if (!bnx2x_reset_is_done(bp, BP_PATH(bp))) {
 10073						/* Try to get a LEADER_LOCK HW lock as
 10074						 * long as a former leader may have
 10075						 * been unloaded by the user or
 10076						 * released a leadership by another
 10077						 * reason.
 10078						 */
 10079						if (bnx2x_trylock_leader_lock(bp)) {
 10080							/* I'm a leader now! Restart a
 10081							 * switch case.
 10082							 */
 10083							bp->is_leader = 1;
 10084							break;
 10085						}
 10086	
 10087						schedule_delayed_work(&bp->sp_rtnl_task,
 10088									HZ/10);
 10089						return;
 10090	
 10091					} else {
 10092						/*
 10093						 * If there was a global attention, wait
 10094						 * for it to be cleared.
 10095						 */
 10096						if (bnx2x_reset_is_global(bp)) {
 10097							schedule_delayed_work(
 10098								&bp->sp_rtnl_task,
 10099								HZ/10);
 10100							return;
 10101						}
 10102	
 10103						error_recovered =
 10104						  bp->eth_stats.recoverable_error;
 10105						error_unrecovered =
 10106						  bp->eth_stats.unrecoverable_error;
 10107						bp->recovery_state =
 10108							BNX2X_RECOVERY_NIC_LOADING;
 10109						if (bnx2x_nic_load(bp, LOAD_NORMAL)) {
 10110							error_unrecovered++;
 10111							netdev_err(bp->dev,
 10112								   "Recovery failed. Power cycle needed\n");
 10113							/* Disconnect this device */
 10114							netif_device_detach(bp->dev);
 10115							/* Shut down the power */
 10116							bnx2x_set_power_state(
 10117								bp, PCI_D3hot);
 10118							smp_mb();
 10119						} else {
 10120							bp->recovery_state =
 10121								BNX2X_RECOVERY_DONE;
 10122							error_recovered++;
 10123							smp_mb();
 10124						}
 10125						bp->eth_stats.recoverable_error =
 10126							error_recovered;
 10127						bp->eth_stats.unrecoverable_error =
 10128							error_unrecovered;
 10129	
 10130						return;
 10131					}
 10132				}
 10133			default:
 10134				return;
 10135			}
 10136		}
 10137	}
 10138	

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation

--7jc6se4wnoi7pe3p
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
JGvzf/h5EXUCowEA

--7jc6se4wnoi7pe3p--
