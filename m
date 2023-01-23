Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32485678985
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 22:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbjAWV1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 16:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbjAWV1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 16:27:04 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFDB2CC46
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 13:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674509223; x=1706045223;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ECQH3g34TwAe/T1/Wu0GOoa7bjWBQFRgmgtnJFM3nIU=;
  b=ZYnYKBz3xMiJudnUFDruEQq1jl7nx6OeRM42bWFUPAQ32gN6mW3dYvWR
   VzNbSSUYGGFPDKRvCIHw5JHPBNrkHG2TgG94r5DEWXM+ggCmuxz4c6mUo
   FDk4zkdDTP6+FamPZqUudzpWOJrELyWPXMmPgeJ0v5dO57DOMFavNrroS
   AGeHl9/RhBZh2AvuOZ2X6tqxUrSueuIft/LXskCuiXKObq5W5t9ABZ126
   A7tdbgTT0rvSzFUje4XGpJuFlRUbhWrTMFgSLn/YhQyPOocKqcijmr3Qc
   0qvFdxCqle6pV+f8JSb2Qz2zhTjvpM2xaQMgE84yWQ/zH8nUZb3f/4agI
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="328241878"
X-IronPort-AV: E=Sophos;i="5.97,240,1669104000"; 
   d="scan'208";a="328241878"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2023 13:27:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="655173675"
X-IronPort-AV: E=Sophos;i="5.97,240,1669104000"; 
   d="scan'208";a="655173675"
Received: from msu-dell.jf.intel.com ([10.166.233.5])
  by orsmga007.jf.intel.com with ESMTP; 23 Jan 2023 13:27:02 -0800
From:   Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, mkubecek@suse.cz, sridhar.samudrala@intel.com,
        anthony.l.nguyen@intel.com
Subject: [RESEND PATCH ethtool-next v6 0/2] add netlink support for rss get
Date:   Mon, 23 Jan 2023 13:24:59 -0800
Message-Id: <20230123212501.1471308-1-sudheer.mogilappagari@intel.com>
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
v6:
- Added break after printing hash function in json output
- Coding style fixes
- Add v6 changelog in cover-letter and resend

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

