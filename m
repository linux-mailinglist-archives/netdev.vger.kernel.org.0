Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC17D653A0B
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 01:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbiLVAR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 19:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234763AbiLVARr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 19:17:47 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29751A062
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 16:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671668265; x=1703204265;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ColUiWyjDeRbGXK6Lc3R59xYKeILVxg5xEy46g5hmAI=;
  b=mXfN/AErYO768PkwQwr3Zfn+bxPW4S5SRwgDpC1XunCdAHuqAe9MPsCk
   Lq+katb/YAvklbJzIQA8C7XnoSG+GobvwAD420a2PMG6Ffz7TGcSbVkFL
   dUNkrePvCPfln7jaP3CcT/gIe3Dk3nU7l7W2WHNX+N7Kla6SnYBLvTOWE
   hvah5kGyOzxaqv6DRqwaQCbqi6sW6sdPlqKTQxy8SpqtQZQMl4fYvmJvh
   UWCOdXe6x5eAv3Ikam//4GfwDjwPfZB0PVc5ONrQE6SiIAE20n9e+obHl
   j8Kg/wl9qZcHIoUNMemHp7QvUE46p9kkM/qbH7gmhvqDCwivYXv3gN5V7
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10568"; a="318701441"
X-IronPort-AV: E=Sophos;i="5.96,263,1665471600"; 
   d="scan'208";a="318701441"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 16:17:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10568"; a="720117627"
X-IronPort-AV: E=Sophos;i="5.96,263,1665471600"; 
   d="scan'208";a="720117627"
Received: from msu-dell.jf.intel.com ([10.166.233.5])
  by fmsmga004.fm.intel.com with ESMTP; 21 Dec 2022 16:17:42 -0800
From:   Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, mkubecek@suse.cz, andrew@lunn.ch, corbet@lwn.net,
        sridhar.samudrala@intel.com, anthony.l.nguyen@intel.com
Subject: [PATCH ethtool-next v2 0/2] add netlink support for rss get
Date:   Wed, 21 Dec 2022 16:13:41 -0800
Message-Id: <20221222001343.1220090-1-sudheer.mogilappagari@intel.com>
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
    8:      0     0     0     0     0     0     0     0
   16:      1     1     1     1     1     1     1     1
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

Output with --json option
$ethtool --json -x eno2
[ {
    "ifname": "eno2",
    "RSS indirection table": [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2
    ...skip similar lines...
    7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7 ],
    "RSS hash Key": "be:c3:13:a6:59:9a:c3:c5:d8:60:75:2b:4c:
    b2:12:cc:5c:4e:34:8a:f9:ab:16:c7:19:5d:ab:1d:b5:c1:c7:57:
    c7:a2:e1:2b:e3:ea:02:60:88:8e:96:ef:2d:64:d2:de:2c:16:72:b6",
    "RSS hash function": {
            "toeplitz": "on",
            "xor": "off",
            "crc32": "off"
        }
    } ]

Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
---
v2:
-Added json support
---
Sudheer Mogilappagari (2):
  Move code that print rss info into common file
  netlink: add netlink handler for get rss (-x)

 Makefile.am            |   2 +-
 common.c               |  43 +++++++
 common.h               |   7 ++
 ethtool.c              |  46 +------
 netlink/desc-ethtool.c |  11 ++
 netlink/extapi.h       |   2 +
 netlink/rss.c          | 272 +++++++++++++++++++++++++++++++++++++++++
 7 files changed, 342 insertions(+), 41 deletions(-)
 create mode 100644 netlink/rss.c

-- 
2.31.1

