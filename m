Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF7822FEEA
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 03:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgG1BcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 21:32:18 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8832 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726196AbgG1BcR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 21:32:17 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CA36E1FD25BA70411706;
        Tue, 28 Jul 2020 09:32:13 +0800 (CST)
Received: from kernelci-master.huawei.com (10.175.101.6) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Tue, 28 Jul 2020 09:32:03 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Hulk Robot <hulkci@huawei.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
Subject: [PATCH net-next] ice: mark PM functions as __maybe_unused
Date:   Tue, 28 Jul 2020 09:41:53 +0800
Message-ID: <20200728014153.44834-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In certain configurations without power management support, the
following warnings happen:

drivers/net/ethernet/intel/ice/ice_main.c:4214:12: warning:
 'ice_resume' defined but not used [-Wunused-function]
 4214 | static int ice_resume(struct device *dev)
      |            ^~~~~~~~~~
drivers/net/ethernet/intel/ice/ice_main.c:4150:12: warning:
 'ice_suspend' defined but not used [-Wunused-function]
 4150 | static int ice_suspend(struct device *dev)
      |            ^~~~~~~~~~~

Mark these functions as __maybe_unused to make it clear to the
compiler that this is going to happen based on the configuration,
which is the standard for these types of functions.

Fixes: 769c500dcc1e ("ice: Add advanced power mgmt for WoL")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d6981ba34b27..6edf018c4940 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4147,7 +4147,7 @@ static int ice_reinit_interrupt_scheme(struct ice_pf *pf)
  * Power Management callback to quiesce the device and prepare
  * for D3 transition.
  */
-static int ice_suspend(struct device *dev)
+static int __maybe_unused ice_suspend(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct ice_pf *pf;
@@ -4211,7 +4211,7 @@ static int ice_suspend(struct device *dev)
  * ice_resume - PM callback for waking up from D3
  * @dev: generic device information structure
  */
-static int ice_resume(struct device *dev)
+static int __maybe_unused ice_resume(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	enum ice_reset_req reset_type;

