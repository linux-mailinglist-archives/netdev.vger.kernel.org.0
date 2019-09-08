Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0883AD145
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 01:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731487AbfIHXyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 19:54:50 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41083 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731203AbfIHXyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 19:54:50 -0400
Received: by mail-qk1-f194.google.com with SMTP id o11so11351553qkg.8
        for <netdev@vger.kernel.org>; Sun, 08 Sep 2019 16:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=fjcQhatvyXTn9t7YNbj1PFZa2LN3Vi00JoNGnJm4fmQ=;
        b=qiQvwWat8U+bosvR5DRzZ4bxBPfr+sUhVKcUUbNMMrC6dLX5XaT2+IY7jB/N99FUkz
         CFntSQvmgPZR6t6Di71OWN+MptPjeKVrRJmcDo1PRPfGnX7mvMSKC23a26uYLl/KOnWS
         8MUPjyNvtKKQXRfcDtSWpVQWfH/LgO4n+NR83mgm5EKUF5fKWzfWfsCGsmEcTXD4yFs3
         sZsO+5y5qCCMw9dx2JeWHrY3LsbZ5W9dIWMiRGeG5zCy1aypDlgYPsT6RSxDK1Qc0tih
         yv7JWjVLC9ExUgvYHoYb1lXP8LqL8fwrypNly4+ILDNhbdSo7l2qMV+aq+h/zGWpt6wg
         XcvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fjcQhatvyXTn9t7YNbj1PFZa2LN3Vi00JoNGnJm4fmQ=;
        b=Rz6EaKXwU5NUtAZ/fIJ0P6A2MbHTn6/24dZssYzi6ZwUY8BLgCJN6J0kUPnqa6N1+H
         jIpLUOvdmXoRIiGzto+Uou0Ee4yxZ73+LozL+wJrhIVLJthw6eYDPYI9cqMPsAcJ8sTY
         Vo1OY+3rw7f4llq4m12ovgQGFZxYTy1QoStmhPpP96cDazSAvgWfSKxOl8NVkkOL6Rpd
         XCWjRI+FUQ9YDJtOoeKJaxz7Zq1+CylO3XbpjgJfUuG6eSdm5sx//vaF93BrF+E1hrLI
         UEFj3OTRU1bhCYoxbiP174loulUdZbknqThZhcTKmKGY+f6vTdkNelPP6okzumsqJ48h
         qa0g==
X-Gm-Message-State: APjAAAWFfGy3zu9C6X/bDV6GUPRhandhHxKm5B2fS9vrTNJV/J22U9Qk
        9Hy00lJEj7DV25/JZoyBz1Pq+Q==
X-Google-Smtp-Source: APXvYqwQ47WJxt0TRayCPHbCLPUYgahXo2ZN+7mYBb/HaN/6mCnHlTmmh/lQf9QhMUM5zFwkanhbcA==
X-Received: by 2002:a37:a4d:: with SMTP id 74mr20254742qkk.90.1567986889116;
        Sun, 08 Sep 2019 16:54:49 -0700 (PDT)
Received: from penelope.pa.netronome.com (195-23-252-147.net.novis.pt. [195.23.252.147])
        by smtp.gmail.com with ESMTPSA id p27sm5464406qkm.92.2019.09.08.16.54.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 16:54:47 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next v2 00/11] nfp: implement firmware loading policy
Date:   Mon,  9 Sep 2019 00:54:16 +0100
Message-Id: <20190908235427.9757-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dirk says:

This series adds configuration capabilities to the firmware loading policy of
the NFP driver.

NFP firmware loading is controlled via three HWinfo keys which can be set per
device: 'abi_drv_reset', 'abi_drv_load_ifc' and 'app_fw_from_flash'.
Refer to patch #11 for more detail on how these control the firmware loading.

In order to configure the full extend of FW loading policy, a new devlink
parameter has been introduced, 'reset_dev_on_drv_probe', which controls if the
driver should reset the device when it's probed. This, in conjunction with the
existing 'fw_load_policy' (extended to include a 'disk' option) provides the
means to tweak the NFP HWinfo keys as required by users.

Patches 1 and 2 adds the devlink modifications and patches 3 through 9 adds the
support into the NFP driver. Furthermore, the last 2 patches are documentation
only.

v2:
  Renamed all 'reset_dev_on_drv_probe' defines the same as the devlink parameter
  name (Jiri)

Dirk van der Merwe (11):
  devlink: extend 'fw_load_policy' values
  devlink: add 'reset_dev_on_drv_probe' param
  nfp: nsp: add support for fw_loaded command
  nfp: nsp: add support for optional hwinfo lookup
  nfp: nsp: add support for hwinfo set operation
  nfp: honor FW reset and loading policies
  nfp: add devlink param infrastructure
  nfp: devlink: add 'fw_load_policy' support
  nfp: devlink: add 'reset_dev_on_drv_probe' support
  kdoc: fix nfp_fw_load documentation
  Documentation: nfp: add nfp driver specific notes

 .../networking/device_drivers/netronome/nfp.rst    | 133 +++++++++++
 Documentation/networking/devlink-params-nfp.txt    |   5 +
 Documentation/networking/devlink-params.txt        |  16 ++
 drivers/net/ethernet/netronome/nfp/Makefile        |   1 +
 drivers/net/ethernet/netronome/nfp/devlink_param.c | 254 +++++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/nfp_main.c      | 142 +++++++++---
 drivers/net/ethernet/netronome/nfp/nfp_main.h      |   5 +
 drivers/net/ethernet/netronome/nfp/nfp_net_main.c  |   7 +
 .../net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c   |  77 ++++++-
 .../net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h   |  29 +++
 include/net/devlink.h                              |   5 +
 include/uapi/linux/devlink.h                       |   8 +
 net/core/devlink.c                                 |   5 +
 13 files changed, 657 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/netronome/nfp.rst
 create mode 100644 Documentation/networking/devlink-params-nfp.txt
 create mode 100644 drivers/net/ethernet/netronome/nfp/devlink_param.c

-- 
2.11.0

