Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA4D6664EE
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 21:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbjAKUnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 15:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjAKUnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 15:43:20 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CA0193F5
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 12:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673469799; x=1705005799;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EtjizMr5E4iDgC9Ead7gPLuADL1iqk77QOs9ivFTdEw=;
  b=fIch0umLbea/jCtFf1ufLCPK3Fg+fUxYnhpPwkrzRqZBSB2hKZjMBemT
   mRlFp24+o00dB12Kb19MKlPZnmgH/YtwIE1IYpKPn9OkehZO6KdsBRfuB
   hSNQoBVv7/KYdXw2HHaVYHJg09Lpa4oILmdA6L8nVMTepZRpPUa7u1pFt
   vH4DSs0kuchkogtZuFDOauekdzi3RA6w350xt4MgdrEs72++Vrj44OB4n
   WFxrrxxiD/O3tzUUHa8htMez+/dY0VgcpLzADCX+foid1sB7SyfnJjsV3
   AsGJXfvzMgf9nFj7JCYAMiWCpXCOcIm4waiXL/OS0xiy2ZkX2HVvFsICP
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="323593504"
X-IronPort-AV: E=Sophos;i="5.96,317,1665471600"; 
   d="scan'208";a="323593504"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 12:43:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="726056879"
X-IronPort-AV: E=Sophos;i="5.96,317,1665471600"; 
   d="scan'208";a="726056879"
Received: from msu-dell.jf.intel.com ([10.166.233.5])
  by fmsmga004.fm.intel.com with ESMTP; 11 Jan 2023 12:43:18 -0800
From:   Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, mkubecek@suse.cz, andrew@lunn.ch,
        sridhar.samudrala@intel.com, anthony.l.nguyen@intel.com
Subject: [PATCH ethtool-next v6 0/2] add netlink support for rss get
Date:   Wed, 11 Jan 2023 12:36:42 -0800
Message-Id: <20230111203644.1176186-1-sudheer.mogilappagari@intel.com>
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
    "rss-hash-key": [ 190,195,19,166,..],
    "rss-hash-function": "toeplitz"
    } ]

Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
---
v5:
- Fixed use of same socket for fetching rings info and RSS info
- Added checks to test if a field exists before accessing reply message
- Refactor print functions and avoid use of ethtool_rxfh structure

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
 common.c               |  36 +++++++
 common.h               |   6 +-
 ethtool.c              |  44 ++------
 netlink/desc-ethtool.c |  11 ++
 netlink/extapi.h       |   2 +
 netlink/rss.c          | 231 +++++++++++++++++++++++++++++++++++++++++
 7 files changed, 295 insertions(+), 37 deletions(-)
 create mode 100644 netlink/rss.c

-- 
2.31.1

