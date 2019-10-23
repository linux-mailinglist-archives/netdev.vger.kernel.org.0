Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8716E2262
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 20:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732726AbfJWSSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 14:18:54 -0400
Received: from mga03.intel.com ([134.134.136.65]:14439 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727309AbfJWSSy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 14:18:54 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 11:18:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,221,1569308400"; 
   d="scan'208";a="228220226"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 23 Oct 2019 11:18:51 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iNLDf-000HJl-3p; Thu, 24 Oct 2019 02:18:51 +0800
Date:   Thu, 24 Oct 2019 02:18:49 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     kbuild-all@lists.01.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "epomozov@marvell.com" <epomozov@marvell.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>
Subject: Re: [PATCH v3 net-next 04/12] net: aquantia: add PTP rings
 infrastructure
Message-ID: <201910240114.dBccbC6D%lkp@intel.com>
References: <855844d84a191bc00b9fb847d665f6e16ab131f5.1571737612.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <855844d84a191bc00b9fb847d665f6e16ab131f5.1571737612.git.igor.russkikh@aquantia.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Igor,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Igor-Russkikh/net-aquantia-PTP-support-for-AQC-devices/20191023-194531
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 88652bf8ce4b91c49769a2a49c17dc44b85b4fa2
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/aquantia/atlantic/aq_ptp.c:258:34: sparse: sparse: Using plain integer as NULL pointer

vim +258 drivers/net/ethernet/aquantia/atlantic/aq_ptp.c

   253	
   254	int aq_ptp_ring_alloc(struct aq_nic_s *aq_nic)
   255	{
   256		struct aq_ptp_s *aq_ptp = aq_nic->aq_ptp;
   257		unsigned int tx_ring_idx, rx_ring_idx;
 > 258		struct aq_ring_s *hwts = 0;
   259		u32 tx_tc_mode, rx_tc_mode;
   260		struct aq_ring_s *ring;
   261		int err;
   262	
   263		if (!aq_ptp)
   264			return 0;
   265	
   266		/* Index must to be 8 (8 TCs) or 16 (4 TCs).
   267		 * It depends from Traffic Class mode.
   268		 */
   269		aq_nic->aq_hw_ops->hw_tx_tc_mode_get(aq_nic->aq_hw, &tx_tc_mode);
   270		if (tx_tc_mode == 0)
   271			tx_ring_idx = PTP_8TC_RING_IDX;
   272		else
   273			tx_ring_idx = PTP_4TC_RING_IDX;
   274	
   275		ring = aq_ring_tx_alloc(&aq_ptp->ptp_tx, aq_nic,
   276					tx_ring_idx, &aq_nic->aq_nic_cfg);
   277		if (!ring) {
   278			err = -ENOMEM;
   279			goto err_exit;
   280		}
   281	
   282		aq_nic->aq_hw_ops->hw_rx_tc_mode_get(aq_nic->aq_hw, &rx_tc_mode);
   283		if (rx_tc_mode == 0)
   284			rx_ring_idx = PTP_8TC_RING_IDX;
   285		else
   286			rx_ring_idx = PTP_4TC_RING_IDX;
   287	
   288		ring = aq_ring_rx_alloc(&aq_ptp->ptp_rx, aq_nic,
   289					rx_ring_idx, &aq_nic->aq_nic_cfg);
   290		if (!ring) {
   291			err = -ENOMEM;
   292			goto err_exit_ptp_tx;
   293		}
   294	
   295		hwts = aq_ring_hwts_rx_alloc(&aq_ptp->hwts_rx, aq_nic, PTP_HWST_RING_IDX,
   296					     aq_nic->aq_nic_cfg.rxds,
   297					     aq_nic->aq_nic_cfg.aq_hw_caps->rxd_size);
   298		if (!hwts) {
   299			err = -ENOMEM;
   300			goto err_exit_ptp_rx;
   301		}
   302	
   303		err = aq_ptp_skb_ring_init(&aq_ptp->skb_ring, aq_nic->aq_nic_cfg.rxds);
   304		if (err != 0) {
   305			err = -ENOMEM;
   306			goto err_exit_hwts_rx;
   307		}
   308	
   309		return 0;
   310	
   311	err_exit_hwts_rx:
   312		aq_ring_free(&aq_ptp->hwts_rx);
   313	err_exit_ptp_rx:
   314		aq_ring_free(&aq_ptp->ptp_rx);
   315	err_exit_ptp_tx:
   316		aq_ring_free(&aq_ptp->ptp_tx);
   317	err_exit:
   318		return err;
   319	}
   320	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
