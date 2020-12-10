Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC03C2D5493
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 08:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732716AbgLJHWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 02:22:30 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:10327 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgLJHWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 02:22:23 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607584924; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=9jF6Ky27mG/ZFRxAf3fE6Be/EzogbS81pUYleUQsYXM=; b=BXZNwZSEzOEB8+bSK5lOKwQgsYp9KafuOj+PmzMNloXEJnKWDmyxgCmlqqVh7G1qRQYLoGQw
 mxVq0zO/bPa+tNDpjJzbablJXenmDWawpmzjzDVm+mSuubIf9LYcAg+QzBFs8TtSYh9WDDBZ
 eQMBdiWG1AQgQYvXPqtlwEanZ84=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5fd1cc8089cdd9db90d82610 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 10 Dec 2020 07:21:36
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B321DC43463; Thu, 10 Dec 2020 07:21:35 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 762A7C433C6;
        Thu, 10 Dec 2020 07:21:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 762A7C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
From:   Hemant Kumar <hemantk@codeaurora.org>
To:     manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org,
        Hemant Kumar <hemantk@codeaurora.org>
Subject: [PATCH v16 0/4] userspace MHI client interface driver
Date:   Wed,  9 Dec 2020 23:21:21 -0800
Message-Id: <1607584885-23824-1-git-send-email-hemantk@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for UCI driver. UCI driver enables userspace
clients to communicate to external MHI devices like modem. UCI driver probe
creates standard character device file nodes for userspace clients to
perform open, read, write, poll and release file operations. These file
operations call MHI core layer APIs to perform data transfer using MHI bus
to communicate with MHI device. Patch is tested using arm64 and x86 based
platform.

v16:
- Removed reference of WLAN as an external MHI device in documentation and
  cover letter.

v15:
- Updated documentation related to poll and release operations.

V14:
- Fixed device file node format to /dev/<mhi_dev_name> instead of
  /dev/mhi_<mhi_dev_name> because "mhi" is already part of mhi device name.
  For example old format: /dev/mhi_mhi0_QMI new format: /dev/mhi0_QMI.
- Updated MHI documentation to reflect index mhi controller name in
  QMI usage example.

V13:
- Removed LOOPBACK channel from mhi_device_id table from this patch series.
  Pushing a new patch series to add support for LOOPBACK channel and the user
  space test application. Also removed the description from kernel documentation.
- Added QMI channel to mhi_device_id table. QMI channel has existing libqmi
  support from user space.
- Updated kernel Documentation for QMI channel and provided external reference
  for libqmi.
- Updated device file node name by appending mhi device name only, which already
  includes mhi controller device name.

V12:
- Added loopback test driver under selftest/drivers/mhi. Updated kernel
  documentation for the usage of the loopback test application.
- Addressed review comments for renaming variable names, updated inline
  comments and removed two redundant dev_dbg.

V11:
- Fixed review comments for UCI documentation by expanding TLAs and rewording
  some sentences.

V10:
- Replaced mutex_lock with mutex_lock_interruptible in read() and write() file
  ops call back.

V9:
- Renamed dl_lock to dl_pending _lock and pending list to dl_pending for
  clarity.
- Used read lock to protect cur_buf.
- Change transfer status check logic and only consider 0 and -EOVERFLOW as
  only success.
- Added __int to module init function.
- Print channel name instead of minor number upon successful probe.

V8:
- Fixed kernel test robot compilation error by changing %lu to %zu for
  size_t.
- Replaced uci with UCI in Kconfig, commit text, and comments in driver
  code.
- Fixed minor style related comments.

V7:
- Decoupled uci device and uci channel objects. uci device is
  associated with device file node. uci channel is associated
  with MHI channels. uci device refers to uci channel to perform
  MHI channel operations for device file operations like read()
  and write(). uci device increments its reference count for
  every open(). uci device calls mhi_uci_dev_start_chan() to start
  the MHI channel. uci channel object is tracking number of times
  MHI channel is referred. This allows to keep the MHI channel in
  start state until last release() is called. After that uci channel
  reference count goes to 0 and uci channel clean up is performed
  which stops the MHI channel. After the last call to release() if
  driver is removed uci reference count becomes 0 and uci object is
  cleaned up.
- Use separate uci channel read and write lock to fine grain locking
  between reader and writer.
- Use uci device lock to synchronize open, release and driver remove.
- Optimize for downlink only or uplink only UCI device.

V6:
- Moved uci.c to mhi directory.
- Updated Kconfig to add module information.
- Updated Makefile to rename uci object file name as mhi_uci
- Removed kref for open count

V5:
- Removed mhi_uci_drv structure.
- Used idr instead of creating global list of uci devices.
- Used kref instead of local ref counting for uci device and
  open count.
- Removed unlikely macro.

V4:
- Fix locking to protect proper struct members.
- Updated documentation describing uci client driver use cases.
- Fixed uci ref counting in mhi_uci_open for error case.
- Addressed style related review comments.

V3: Added documentation for MHI UCI driver.

V2:
- Added mutex lock to prevent multiple readers to access same
- mhi buffer which can result into use after free.

Hemant Kumar (4):
  bus: mhi: core: Add helper API to return number of free TREs
  bus: mhi: core: Move MHI_MAX_MTU to external header file
  docs: Add documentation for userspace client interface
  bus: mhi: Add userspace client interface driver

 Documentation/mhi/index.rst     |   1 +
 Documentation/mhi/uci.rst       |  95 ++++++
 drivers/bus/mhi/Kconfig         |  13 +
 drivers/bus/mhi/Makefile        |   3 +
 drivers/bus/mhi/core/internal.h |   1 -
 drivers/bus/mhi/core/main.c     |  12 +
 drivers/bus/mhi/uci.c           | 664 ++++++++++++++++++++++++++++++++++++++++
 include/linux/mhi.h             |  12 +
 8 files changed, 800 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/mhi/uci.rst
 create mode 100644 drivers/bus/mhi/uci.c

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

