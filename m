Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD635281F29
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 01:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbgJBXim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 19:38:42 -0400
Received: from mga14.intel.com ([192.55.52.115]:55989 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbgJBXil (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 19:38:41 -0400
IronPort-SDR: zpKPhej9czxbSGTmAMBWrX4mOpiyRa6WBr5ESzYlWal5PG7ffsAh6piDsiSemSpetlo5jE2gmj
 i1hr0YIwws/A==
X-IronPort-AV: E=McAfee;i="6000,8403,9762"; a="162344906"
X-IronPort-AV: E=Sophos;i="5.77,329,1596524400"; 
   d="scan'208";a="162344906"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2020 16:38:38 -0700
IronPort-SDR: OzVipUOPDCapYC7pMNVpzQKeP1yscvtlf/i6vz1olK+uL3jssXH7Cy4wx4Y0sfeTLJ33113Lfi
 VGqyBULYF51Q==
X-IronPort-AV: E=Sophos;i="5.77,329,1596524400"; 
   d="scan'208";a="340167818"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.4])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2020 16:38:38 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC net-next] ptp: add clock_index as a device attribute
Date:   Fri,  2 Oct 2020 16:37:43 -0700
Message-Id: <20201002233743.1688517-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.497.g54e85e7af1ac
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PTP clock associated with a networking device is reported by the
ETHTOOL_GET_TS_INFO ioctl, by using the ptp->index clock index variable.

In order to associate this clock index with the proper device,
userspace applications make the assumption that /dev/ptpX has a clock
index of X. If this assumption is wrong, such as if user space renames
a device, then there isn't a mechanism to associate the clock index with
the device.

Add a new device attribute to the device sysfs folder, clock_index,
which will report the exact clock index of the device. This enables
userspace applications to determine the clock_index of the PTP devices
in a more robust way.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/ptp/ptp_sysfs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index be076a91e20e..8ba9556c939a 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -17,6 +17,14 @@ static ssize_t clock_name_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(clock_name);
 
+static ssize_t clock_index_show(struct device *dev,
+				struct device_attribute *attr, char *page)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+	return snprintf(page, PAGE_SIZE-1, "%d\n", ptp->index);
+}
+static DEVICE_ATTR_RO(clock_index);
+
 #define PTP_SHOW_INT(name, var)						\
 static ssize_t var##_show(struct device *dev,				\
 			   struct device_attribute *attr, char *page)	\
@@ -150,6 +158,7 @@ static DEVICE_ATTR(pps_enable, 0220, NULL, pps_enable_store);
 
 static struct attribute *ptp_attrs[] = {
 	&dev_attr_clock_name.attr,
+	&dev_attr_clock_index.attr,
 
 	&dev_attr_max_adjustment.attr,
 	&dev_attr_n_alarms.attr,

base-commit: 0c2a01dc27f68024108b7303002678bd72446a4e
-- 
2.28.0.497.g54e85e7af1ac

