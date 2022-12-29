Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1464D658848
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 02:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbiL2BRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 20:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiL2BRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 20:17:37 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEB213F4C
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 17:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672276656; x=1703812656;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5YMy1HGe5ZjVCWfGXV8/0sG3CW8zneMGSQbe9ghGrlQ=;
  b=m88tJ5gtwn3chnZFvQ6f3of/NsrLnhqcb3dQlIVUYZvwfUSjTEtU3lXN
   zlxJO7swl1TJkHD3MZVzi3uywgh/e9ouLhYmyEIc/zLmCpmBpswVGniFL
   JHY76sa1S1Lc9Mf5YkUGmLBXg7NIR/dEnYuqRt58EZvZsYM2mK2EooERp
   fciVx/amQcRP/M//DxWgHhBmfCCiXrGMA/a5myO3zQFLQrJ8VAqeyS2mq
   uiOA0yWlclERc1wTMR56pIPBmkycFUe/TYQgs+gHHSKktlBHjf94Hl7CS
   Um3xOQWBlaXf0u8HSONPOk1XflGOSJmvwIcPwilQxb/sDyjX8wjHBFSx5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10574"; a="301326139"
X-IronPort-AV: E=Sophos;i="5.96,282,1665471600"; 
   d="scan'208";a="301326139"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2022 17:17:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10574"; a="653468114"
X-IronPort-AV: E=Sophos;i="5.96,282,1665471600"; 
   d="scan'208";a="653468114"
Received: from msu-dell.jf.intel.com ([10.166.233.5])
  by orsmga002.jf.intel.com with ESMTP; 28 Dec 2022 17:17:35 -0800
From:   Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, mkubecek@suse.cz, andrew@lunn.ch,
        sridhar.samudrala@intel.com, anthony.l.nguyen@intel.com
Subject: [PATCH ethtool-next v4 0/2] add netlink support for rss get
Date:   Wed, 28 Dec 2022 17:12:41 -0800
Message-Id: <20221229011243.1527945-1-sudheer.mogilappagari@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches add netlink based handler to fetch RSS information
using "ethtool -x <eth> [context %d]" command.

Output without --json option
$ethtool -x eno2
RX flow hash indirection table for eno2 with 8 RX ring(s):
    0:      0     0     0     0     0     0     0     0
    8:      1     1     1     1     1     1     1     1
   ...skip similar lines...
  120:      7     7     7     7     7     7     7     7
RSS hash key:
be:c3:13:a6:59:9a:c3:c5:d8:60:75:2b:4c:b2:12:cc:5c:4e:34:
8a:f9:ab:16:c7:19:5d:ab:1d:b5:c1:c7:57:c7:a2:e1:2b:e3:ea:
02:60:88:8e:96:ef:2d:64:d2:de:2c:16:72:b6
RSS hash function:
    toeplitz: on
    xor: off
    crc32: off

Sample output with json option:
$ethtool --json -x eno2
[ {
    "ifname": "eno2",
    "rss-indirection-table": [ 0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,
    ...skip similar lines...
    7,7,7,7,7,7,7,7 ],
    "rss-hash-key": [ 190,195,19,166,..]
    "rss-hash-function": {
            "toeplitz": true,
            "xor": false,
            "crc32": false
        }
    } ]

Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
---

v4: 
-Fixed hash function values in example output of commit message.

v3:
-Made hash key as an array of ints.
-Skip json field when not supported.
-Made hash function values as true/false instead of on/off
-Formatted key strings as per review comments. 

v2:
-Added json support
---
Sudheer Mogilappagari (2):
  Move code that print rss info into common file
  netlink: add netlink handler for get rss (-x)

 Makefile.am            |   2 +-
 common.c               |  43 ++++++++
 common.h               |   7 ++
 ethtool.c              |  46 +-------
 netlink/desc-ethtool.c |  11 ++
 netlink/extapi.h       |   2 +
 netlink/rss.c          | 241 +++++++++++++++++++++++++++++++++++++++++
 7 files changed, 311 insertions(+), 41 deletions(-)
 create mode 100644 netlink/rss.c

-- 
2.31.1

