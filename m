Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2001057D095
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 18:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbiGUQB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 12:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiGUQB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 12:01:57 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3413187371;
        Thu, 21 Jul 2022 09:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658419316; x=1689955316;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iqgoGFw1imn9cCwvxZvbEsMxjla5mJR4iunaXS/Iqmo=;
  b=kTEVl1h/+MBzz07GcI7Ugh6pxvttheM9q/mH5mXXYrlgURuilvjDysl/
   ELG2HYanZsReuuNXVE5ajV7jZRmpTxjNPMYaS6le/DpQw/cUw5XfLu6r8
   A39WCVQ9thYMpguuKLCfUuQVCPpwOebbmyADYRJ+FR0J0kvUWxiDGfb0w
   Qay4eFvNtQAitQdhKX9pySsm2X/XRLwTdeeSGOtqyv6s+gG+h/aYZXKfT
   21mq9IeX7XBOeXjdGssru9oQu6Lrp470PwNkT9xH3mHmjWEjBs+1tp4AG
   ULz43uMtXaMEdylIuFnUkAgBccn+a7Cx4gUAQ2AdyApWm+l3gKwMnonXu
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="312804421"
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="312804421"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 09:01:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="925701204"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 21 Jul 2022 09:01:40 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26LG1crY003918;
        Thu, 21 Jul 2022 17:01:38 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/4] netlink: add 'bitmap' attribute type and API
Date:   Thu, 21 Jul 2022 17:59:46 +0200
Message-Id: <20220721155950.747251-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new type of Netlink attribute -- bitmap.

Lots of different bitfields in the kernel grow through time,
sometimes significantly. They can consume a u8 at fist, then require
16 bits, 32... To support such bitfields without rewriting code each
time, kernel have bitmaps. For now, that is purely in-kernel type
and API, and to communicate with userspace, they need to be
converted to some primitive at first (e.g. __u32 etc.), dealing with
that sometimes bitfields will run out of the size set for the
corresponding Netlink attribute. Those can be netdev features,
linkmodes and so on.
Internally, in-kernel bitmaps are represented as arrays of unsigned
longs. This provides optimal performance and memory usage; however,
bitness dependent types can't be used to communicate between kernel
and userspace -- for example, userapp can be 32-bit on a 64-bit
system. So, to provide reliable communication data type, 64-bit
arrays are now used. Netlink core takes care of converting them
from/to unsigned longs when sending or receiving Netlink messages;
although, on LE and 64-bit systems conversion is a no-op. They also
can have explicit byteorder -- core code also handles this (both
kernel and userspace must know in advance the byteorder of a
particular attribute), as well as cases when the userspace and the
kernel assume different number of bits (-> different number of u64s)
for an attribute.

Basic consumer functions/macros are:
* nla_put_bitmap and nla_get_bitmap families -- to easily put a
  bitmap to an skb or get it from a received message (only pointer
  to an unsigned long bitmap and the number of bits in it are
  needed), with optional explicit byteorder;
* nla_total_size_bitmap() -- to provide estimate size in bytes to
  Netlink needed to store a bitmap;
* {,__}NLA_POLICY_BITMAP() -- to declare a Netlink policy for a
  bitmap attribute.

Netlink policy for a bitmap can have an optional bitmap mask of bits
supported by the code -- for example, to filter out obsolete bits
removed some time ago. Without it, Netlink will make sure no bits
past the passed number are set. Both variants can be requested from
the userspace and the kernel will put a mask into a new policy
attribute (%NL_POLICY_TYPE_ATTR_BITMAP_MASK).
BTW, Ethtool bitsets provide similar functionality, but it operates
with u32s (u64 is more convenient and optimal on most platforms) and
Netlink bitmaps is a generic interface providing policies and data
verification (Ethtool bitsets are declared simply as %NLA_BINARY),
generic getters/setters etc.

An example of using this API can be found in my IP tunnel tree[0]
(planned for submission later), the actual average number of locs
to start both sending and receiving bitmaps in one subsys is ~10[1].
And it looks like that some of the already existing APIs could be
later converted to Netlink bitmaps or expanded as well.

[0] https://github.com/alobakin/linux/commits/ip_tunnel
[1] https://github.com/alobakin/linux/commit/26d2f2cf13fd

Alexander Lobakin (4):
  bitmap: add converting from/to 64-bit arrays of explicit byteorder
  bitmap: add a couple more helpers to work with arrays of u64s
  lib/test_bitmap: cover explicitly byteordered arr64s
  netlink: add 'bitmap' attribute type (%NL_ATTR_TYPE_BITMAP /
    %NLA_BITMAP)

 include/linux/bitmap.h       |  80 ++++++++++++++++--
 include/net/netlink.h        | 159 ++++++++++++++++++++++++++++++++++-
 include/uapi/linux/netlink.h |   5 ++
 lib/bitmap.c                 | 143 +++++++++++++++++++++++++++----
 lib/nlattr.c                 |  43 +++++++++-
 lib/test_bitmap.c            |  22 +++--
 net/netlink/policy.c         |  44 ++++++++++
 7 files changed, 461 insertions(+), 35 deletions(-)


base-commit: 3a2ba42cbd0b669ce3837ba400905f93dd06c79f
---
Targeted for net-next, but uses base-commit from the bitmap tree
(a merge will be needed) and the API is for kernel-wide/generic
usage rather than networking-specific.
-- 
2.36.1

