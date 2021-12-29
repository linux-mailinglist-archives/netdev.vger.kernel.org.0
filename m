Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95F9481611
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 19:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbhL2Sli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 13:41:38 -0500
Received: from mga17.intel.com ([192.55.52.151]:17139 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229472AbhL2Slh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 13:41:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640803297; x=1672339297;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Ln1J0eVnrIjIcZ7Vz7886luhsj792Fs9jJ30n/kZ4LQ=;
  b=nqC8SwdVPLg/1fgzTk7n/MeASrlgxzMPv2/G3fcOv4jme5SywtqcKGBT
   1KeTgDvDOjbXUPo4cd3UAN/xltm1rqXNr0pIF/DF5ot+xae/PhkzuasRc
   UhlA1tH5X+IxcakCZclJ0Jn3YK7DoCbbOQzMq3woDX02t+Mg47EN/fMSY
   ohBZwgb1jWsIXUtz/iEXUUJv/ClchwhYlcPbFnWFcu9KkY0axS098tCKR
   xBw0DCoCLh4vyg25fbnQjxtbxj8TAKFbIrlR2tZPVmaKQZTwp7cVhRx7e
   0bhjc3/pPaJNEiGwMKYCxC/9O/I3+Y4PprB/QIb/NOCiEoHW2oyb0prgR
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10212"; a="222226249"
X-IronPort-AV: E=Sophos;i="5.88,246,1635231600"; 
   d="scan'208";a="222226249"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2021 10:41:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,246,1635231600"; 
   d="scan'208";a="524881566"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 29 Dec 2021 10:41:37 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        kernel.hbk@gmail.com, richardcochran@gmail.com
Subject: [PATCH net-next 0/4][pull request] 1GbE Intel Wired LAN Driver Updates 2021-12-29
Date:   Wed, 29 Dec 2021 10:40:49 -0800
Message-Id: <20211229184053.632634-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ruud Bos says:

The igb driver provides support for PEROUT and EXTTS pin functions that
allow adapter external use of timing signals. At Hottinger Bruel & Kjaer we
are using the PEROUT function to feed a PTP corrected 1pps signal into an
FPGA as cross system synchronized time source.

Support for the PEROUT and EXTTS SDP functions is currently limited to
i210/i211 based adapters. This patch series enables these functions also
for 82580/i354/i350 based ones. Because the time registers of these
adapters do not have the nice split in second rollovers as the i210 has,
the implementation is slightly more complex compared to the i210
implementation.

The PEROUT function has been successfully tested on an i350 based ethernet
adapter. Using the following user space code excerpt, the driver outputs a
PTP corrected 1pps signal on the SDP0 pin of an i350:

    struct ptp_pin_desc desc;
    memset(&desc, 0, sizeof(desc));
    desc.index = 0;
    desc.func = PTP_PF_PEROUT;
    desc.chan = 0;
    if (ioctl(fd, PTP_PIN_SETFUNC, &desc) == 0) {
        struct timespec ts;
        if (clock_gettime(clkid, &ts) == 0) {
            struct ptp_perout_request rq;
            memset(&rq, 0, sizeof(rq));
            rq.index = 0;
            rq.start.sec = ts.tv_sec + 1;
            rq.start.nsec = 500000000;
            rq.period.sec  = 1;
            rq.period.nsec = 0;
            if (ioctl(fd, PTP_PEROUT_REQUEST, &rq) == 0) {
                /* 1pps signal is now available on SDP0 */
            }
        }
    }

The added EXTTS function has not been tested. However, looking at the data
sheets, the layout of the registers involved match the i210 exactly except
for the time registers mentioned before. Hence the almost identical
implementation.

Acked-by: Richard Cochran <richardcochran@gmail.com>
---
Note: I made changes to fix RCT and checkpatch messages regarding
unnecessary parenthesis.

The following are changes since commit 9ed319e411915e882bb4ed99be3ae78667a70022:
  of: net: support NVMEM cells with MAC in text format
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Ruud Bos (4):
  igb: move SDP config initialization to separate function
  igb: move PEROUT and EXTTS isr logic to separate functions
  igb: support PEROUT on 82580/i354/i350
  igb: support EXTTS on 82580/i354/i350

 drivers/net/ethernet/intel/igb/igb_main.c | 148 +++++++++++++----
 drivers/net/ethernet/intel/igb/igb_ptp.c  | 188 ++++++++++++++++++++--
 2 files changed, 291 insertions(+), 45 deletions(-)

-- 
2.31.1

