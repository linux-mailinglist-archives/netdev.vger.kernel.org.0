Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E85F27D57E
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 20:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgI2SKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 14:10:10 -0400
Received: from mga06.intel.com ([134.134.136.31]:49451 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727360AbgI2SKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 14:10:10 -0400
IronPort-SDR: lr0o4d1Z/0P9TM0qBnPFxWc4NrPFpyyM+yDjfvP9rhHd65sjoFYMHxpXKSyfMLSE/rJjMBSnJX
 53mZT0HDAhxw==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="223851803"
X-IronPort-AV: E=Sophos;i="5.77,319,1596524400"; 
   d="scan'208";a="223851803"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 11:09:56 -0700
IronPort-SDR: yvFyyWIcESrWYQWgRnG9JAki1C34R/RBx+nDpW9Nz+KpO7AX5RdoveC9tYuhHcfc4BSY63iJ5+
 UWaJC60t7X2g==
X-IronPort-AV: E=Sophos;i="5.77,319,1596524400"; 
   d="scan'208";a="513978315"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.4])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 11:09:56 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next] devlink: include <linux/const.h> for _BITUL
Date:   Tue, 29 Sep 2020 11:08:59 -0700
Message-Id: <20200929180859.3477990-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.497.g54e85e7af1ac
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 5d5b4128c4ca ("devlink: introduce flash update overwrite mask")
added a usage of _BITUL to the UAPI <linux/devlink.h> header, but failed
to include the header file where it was defined. It happens that this
does not break any existing kernel include chains because it gets
included through other sources. However, when including the UAPI headers
in a userspace application (such as devlink in iproute2), _BITUL is not
defined.

Fixes: 5d5b4128c4ca ("devlink: introduce flash update overwrite mask")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---

I believe this is the appropriate fix for the issue Dave reported at [1], vs
working around it by including uapi/linux/const.h in the devlink.c file in
iproute2.

[1] https://lore.kernel.org/netdev/198b8a34-49de-88e8-629c-408e592f42a6@gmail.com/

 include/uapi/linux/devlink.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 7b0face1bad5..ba467dc07852 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -13,6 +13,8 @@
 #ifndef _UAPI_LINUX_DEVLINK_H_
 #define _UAPI_LINUX_DEVLINK_H_
 
+#include <linux/const.h>
+
 #define DEVLINK_GENL_NAME "devlink"
 #define DEVLINK_GENL_VERSION 0x1
 #define DEVLINK_GENL_MCGRP_CONFIG_NAME "config"

base-commit: 280095713ce244e8dbdfb059cdca695baa72230a
-- 
2.28.0.497.g54e85e7af1ac

