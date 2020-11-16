Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C922B548B
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 23:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730643AbgKPWqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 17:46:39 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:62088 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730566AbgKPWqj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 17:46:39 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605566798; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=iQ+2cr97ThrSA88BQaBRRuQ/qmltdrjpMFmedsejmHY=; b=Q/mKbh/sN9lZFv+XgqGInrHZiOWLsZbuXGELHoh/AxUQcNFa/715a3riknJFrwtJA98yoDe4
 Syx20ZFJbiE3ijoIIQwwXwMdPKg9rJ6ajzHySDF6MFvxBp+W1eP7O/gO6E9SbJMGnnpHdoxw
 xP4nvjHxWu0WTKUK/eZT0DXxGPA=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n10.prod.us-east-1.postgun.com with SMTP id
 5fb30147c3c3b09004bd476d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 16 Nov 2020 22:46:31
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C8D9AC433ED; Mon, 16 Nov 2020 22:46:30 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 765EEC433ED;
        Mon, 16 Nov 2020 22:46:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 765EEC433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
From:   Hemant Kumar <hemantk@codeaurora.org>
To:     manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org,
        skhan@linuxfoundation.org, Hemant Kumar <hemantk@codeaurora.org>
Subject: [PATCH v12 0/5] userspace MHI client interface driver
Date:   Mon, 16 Nov 2020 14:46:17 -0800
Message-Id: <1605566782-38013-1-git-send-email-hemantk@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for UCI driver. UCI driver enables userspace
clients to communicate to external MHI devices like modem and WLAN. UCI driver
probe creates standard character device file nodes for userspace clients to
perform open, read, write, poll and release file operations. These file
operations call MHI core layer APIs to perform data transfer using MHI bus
to communicate with MHI device. It also adds a loopback test application to
verify the UCI LOOPBACK channel. Patch is tested using arm64 based platform.

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

Hemant Kumar (5):
  bus: mhi: core: Add helper API to return number of free TREs
  bus: mhi: core: Move MHI_MAX_MTU to external header file
  docs: Add documentation for userspace client interface
  bus: mhi: Add userspace client interface driver
  selftest: mhi: Add support to test MHI LOOPBACK channel

 Documentation/mhi/index.rst                        |   1 +
 Documentation/mhi/uci.rst                          | 109 +++
 drivers/bus/mhi/Kconfig                            |  13 +
 drivers/bus/mhi/Makefile                           |   3 +
 drivers/bus/mhi/core/internal.h                    |   1 -
 drivers/bus/mhi/core/main.c                        |  12 +
 drivers/bus/mhi/uci.c                              | 667 +++++++++++++++++
 include/linux/mhi.h                                |  12 +
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/drivers/.gitignore         |   1 +
 tools/testing/selftests/drivers/mhi/Makefile       |   8 +
 tools/testing/selftests/drivers/mhi/config         |   2 +
 .../testing/selftests/drivers/mhi/loopback_test.c  | 789 +++++++++++++++++++++
 13 files changed, 1618 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/mhi/uci.rst
 create mode 100644 drivers/bus/mhi/uci.c
 create mode 100644 tools/testing/selftests/drivers/mhi/Makefile
 create mode 100644 tools/testing/selftests/drivers/mhi/config
 create mode 100644 tools/testing/selftests/drivers/mhi/loopback_test.c

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

