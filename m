Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCBC63D520
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 13:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbiK3MAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 07:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiK3MAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 07:00:24 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2126F0EB;
        Wed, 30 Nov 2022 04:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669809623; x=1701345623;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NngERSQQm2PI/lvOc14nEOde3ssUcI30Njv4YH5aweI=;
  b=OvOLCsIfE6sWdTa35r9DAMMbjzxlNr4GxkpIgH6Zxl1PQxYZJhDOPVCx
   Lq9ZbdU2qlXkrXEVeZc/5IKAAn8J7Km3LLk6FPjLjz7tmLzUZA4m3n0Vu
   IfDW4NHdG/AEJcSiMZCaiGngLIWKBAuw6lyaYcFgNZB/kCKTzrTBpdhd2
   5j4vOfqZIjZvO8HVhKmWdWc9uXMRMUNkYDO9gsvCXHYb/Sj2Zsy4Kkvzf
   t/92Jb1ByYer1Xxd0xs7lxPRYXehH2l8VjSDZZy868SHsY36Z44OVlgKA
   qQFBRGH8tmjXg68OnNZL1UIKUo8E8a4JrMywmsv1uG9zPHoMPbpLSnZM+
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="302981105"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="302981105"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 04:00:22 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="621858800"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="621858800"
Received: from unknown (HELO ocsbesrhlrepo01.amr.corp.intel.com) ([10.237.94.20])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 04:00:16 -0800
From:   Radoslaw Tyl <radoslawx.tyl@intel.com>
To:     yangyicong@huawei.com
Cc:     anthony.l.nguyen@intel.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, netdev@vger.kernel.org,
        yangyicong@hisilicon.com, zhoulei154@h-partners.com
Subject: [ISSUE] Cannot enable VF after remove/rescan
Date:   Wed, 30 Nov 2022 13:00:03 +0100
Message-Id: <20221130120003.88695-1-radoslawx.tyl@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <9f37e68c-e960-5188-f52a-4761866c37ad@huawei.com>
References: <9f37e68c-e960-5188-f52a-4761866c37ad@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yicong,

VF offset depends on set of ARIHeirarchy(+/-) in the PCI config.
After Power cycle this bit is set to (+). When we force the port removal

    # echo 1 > /sys/bus/pci/devices/0000\:04\:00.0/remove

and port rescan

    # echo 1 > /sys/bus/pci/rescan

this cause that the ARIHierarchy is set to (-) and the offet is set to 384.
Look into the "Intel® 82599 10 GbE Controller Datasheet",
chapter 7.10.2.6.1.1 ARI Mode. In mode non-ARI "1" is added to the bus and
that cause you've got an error.

During boot sequence when all physical function (PF) are initialized,
pci driver in first attempt set ARI on the first encountered PF and ignore
other. When we remove that first encountered PF which has ARI enabled
in initializaion stage, performing rescan causes that the pci driver only
take into account existing earlier PF. In result pci driver doesn't set ARI
on any of them and the offset is set to 384.


    static int sriov_init(struct pci_dev *dev, int pos)
    {
        ctrl = 0;
        list_for_each_entry(pdev, &dev->bus->devices, bus_list)
            if (pdev->is_physfn)      <------
                goto found;
        pdev = NULL;
        if (pci_ari_enabled(dev->bus))
            ctrl |= PCI_SRIOV_CTRL_ARI;
    
    found:
    
    ...


It is not the problem related to the device driver, but with pci driver,
as a workaround you may use one of these options:

1. remove all PF belonging to bus, before attempt to rescan.
2. disable ARI in grub add "noari" to the kernel parameters.
   # noari           do not use PCIe ARI.


--
BR,
Radek
