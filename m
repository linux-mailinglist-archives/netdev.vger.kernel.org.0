Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9C865651A
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 22:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbiLZVRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 16:17:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiLZVRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 16:17:05 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD5F102B
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 13:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672089422; x=1703625422;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qHZflGGd/XIiqZaj0s9amWFmY6LSEofX0Db5wJ3+wYU=;
  b=XpbQRH/6S9a1aOW/5BAzLD6aIilc7Nt1TS5r8CZfoP1wliAnRRgAYQX7
   ZhzSSk/LR2qUUAl6GQBAFDUAVgoNwOE5kxAuUTWPpurZ+nr61/vmWJcHz
   CS4oj1egrBbbRRlF0c9eoyEnbxOIrwG9D22R8s1/rH+Erh5s96vwDs5mC
   8c1sHSwXoNwZfqyGPajKwDj/GKYF/4wcednjjAQ8h+hiz/Ro2NMGcnPzJ
   DDoduhnAuCAQ4AATLLnyXFcc+EPt5YdoxAJr0ciShZxGnFuYvv8gvsm70
   /NzshJujLeTFW2AQ1/qAsnRMUD3VKTg4TbBmy/ayn6/7Ii9djmeXYtJoP
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10572"; a="300969804"
X-IronPort-AV: E=Sophos;i="5.96,276,1665471600"; 
   d="scan'208";a="300969804"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Dec 2022 13:17:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10572"; a="683432750"
X-IronPort-AV: E=Sophos;i="5.96,276,1665471600"; 
   d="scan'208";a="683432750"
Received: from msu-dell.jf.intel.com ([10.166.233.5])
  by orsmga008.jf.intel.com with ESMTP; 26 Dec 2022 13:17:02 -0800
From:   Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, mkubecek@suse.cz, andrew@lunn.ch,
        sridhar.samudrala@intel.com, anthony.l.nguyen@intel.com
Subject: [PATCH ethtool-next v3 0/2] add netlink support for rss get
Date:   Mon, 26 Dec 2022 13:12:24 -0800
Message-Id: <20221226211226.2084364-1-sudheer.mogilappagari@intel.com>
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
            "toeplitz": "on",
            "xor": "off",
            "crc32": "off"
        }
    } ]

Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
---
v3:
-Made hash key as an array of ints.
-Skip json field when not supported.
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

