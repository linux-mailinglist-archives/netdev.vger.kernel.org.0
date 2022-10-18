Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B523602DC3
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiJROCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiJROCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:02:34 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CD9CF845;
        Tue, 18 Oct 2022 07:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666101753; x=1697637753;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qhBJb5AwanzkbExo0wi1KFE2t5S/3G4iTEnZOg5Vhh4=;
  b=GjdKa5q/2f3QNUpOJeNg4auP2nRPbdnXbqACw7r0ilhPrDZRFNEPuppZ
   SpFOj2Cads1y6hzxiplnd3l67IaoMre0w+sGjiZTaWnnQo7wHepvdXbVY
   rv7KfKu31Icz59819kucuN+klBStyLoBNbwtB0VuOjWU61GQadt9Ee3rm
   9PYTRx0mHQ5anwbRRgv4i4bEABBiD1qOaq6ayZHpk873ZwjqPT55VJqgy
   1yzz1PFA0XWa8U/2EDPTK+OIxB7jriOTgdFlm0PRR4DSKpgTyOlsbL/yr
   BmquaNFQeDTy0mzYWFJrwVuS3K6M5jG+NufZa8CuEz2Omk3bKy40bknIi
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="286502851"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="286502851"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 07:02:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="697510384"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="697510384"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 18 Oct 2022 07:02:31 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 29IE2TUK011675;
        Tue, 18 Oct 2022 15:02:30 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 0/6] netlink: add universal 'bigint' attribute type
Date:   Tue, 18 Oct 2022 16:00:21 +0200
Message-Id: <20221018140027.48086-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new type of Netlink attribute -- big integer.

Basically bigints are just arrays of u32s, but can carry anything,
with 1 bit precision. Using variable-length arrays of a fixed type
gives the following:

* versatility: one type can carry scalars from u8 to u64, bitmaps,
  binary data etc.;
* scalability: the same Netlink attribute can be changed to a wider
  (or shorter) data type with no compatibility issues, same for
  growing bitmaps;
* optimization: 4-byte units don't require wasting slots for empty
  padding attributes (they always have natural alignment in Netlink
  messages).

The only downside is that get/put functions sometimes are not just
direct assignment inlines due to the internal representation using
bitmaps (longs) and the bitmap API. The first patch in the series
partially addresses that.

Basic consumer functions/macros are:
* nla_put_bigint() and nla_get_bigint() -- to easily put a bigint to
  an skb or get it from a received message (only pointer to an
  unsigned long array and the number of bits in it are needed);
* nla_put_bigint_{u,be,le,net}{8,16,32,64}() -- alternatives to the
  already existing family to send/receive scalars using the new type
  (instead of distinct attr types);
* nla_total_size_bigint*() -- to provide estimate size in bytes to
  Netlink needed to store a bigint/type;
* NLA_POLICY_BIGINT*() -- to declare a Netlink policy for a bigint
  attribute.

There are also *_bitmap() aliases for the *_bigint() helpers which
have no differences and designed to distinguish bigints from bitmaps
in the call sites (for readability).

Netlink policy for a bigint can have an optional bitmap mask of bits
supported by the code -- for example, to filter out obsolete bits
removed some time ago or limit value to n bits (e.g. 53 instead of
64). Without it, Netlink will just make sure no bits past the passed
number are set. Both variants can be requested from the userspace
and the kernel will put a mask into a new policy attribute
(%NL_POLICY_TYPE_ATTR_BIGINT_MASK).
Unlike BITFIELD32 or Ethtool bitsets, bigints don't implement
"selectors" as a basic feature, but it's pretty easy to emulate it
with just sending both selector and value in one data chunk (as these
bigints are dynamically-sized) and masking unused gaps between them
with the bitmap mask policy feature.

An example of using this API can be found in my IP tunnel tree[0]
(to be submitted after that one hits the repo), the actual average
number of locs to start both sending and receiving bitmaps in one
subsys is ~10. And it looks like that some of the already existing
APIs could be later converted to Netlink bigints or expanded as
well.

And here's sample userspace output for failed in-kernel validation --
IP tunnel flags attribute was declared as 17-bit bitmap/bigint, but
the modified userspace passed data with the 20th bit set:

$ ip/ip r add 14.0.1.8 encap ip id 30001 dst 10.0.18.210 dev vxlan1
Policy: type: BIGINT, mask: 0x0003ffff
Error: Attribute failed policy validation.

From v1[1]:
 - use u32-array representation instead of u64-array to conserve
   attributes (no need to have "padding" dummy attrs) and some bytes
   (4-byte step instead of 8-byte) (Jakub);
 - try to resolve arr32 <-> bitmap conversions on 64-bit LEs to
   inline code at compile-time to reduce get/set overhead (me);
 - drop Endianness shenanigans: it makes no sense to encode bitmaps/
   arrays to a specific Endian (Jakub);
 - rename it from 'bitmap' to 'bigint' to increase usecase coverage
   (Jakub);
 - introduce helpers to send scalars (u8-u64) via the API to make it
   universal / more useful (Jakub);
 - change kfree() to bitmap_free() when freeing allocated bitmaps
   (Andy);
 - make BYTES_TO_BITS() treewide-available and use it (Andy);
 - make bitmap_validate_arr32() return `bool`: there were only two
   return values possible (Andy);
 - drop redundant `!!len` check before memchr_inv() call: the
   function does that itself (Andy);
 - expand the #if 0 presence explanation (Andy);
 - add runtime tests for the new arr32 functions: 5 test cases that
   cover all condition branches (Andy);
 - run make includecheck, ensure including <linux/bitmap.h> to
   <net/netlink.h> doesn't introduce compile time regressions,
   mention that in the commitmsg (Andy);
 - drop more redundant `if (len)` condition checks before string
   operations (Andy);
 - make bitmap_arr32_compat() and bitmap_{from,to}_arr32() a bit
   more readable (Andy);
 - don't use `min_t(typeof())`, specify types explicitly (Andy);
 - don't initialize the bitmap two times in a row in
   __netlink_policy_dump_write_attr_bigint() and use more simple
   bitmap_fill(): nla_put_bigint() will then clear the tail
   properly itself (Andy).

The series is also available on my open GitHub: [2]

[0] https://github.com/alobakin/linux/commits/ip_tunnel
[1] https://lore.kernel.org/all/20220721155950.747251-1-alexandr.lobakin@intel.com
[2] https://github.com/alobakin/linux/commits/netlink_bitmap

Alexander Lobakin (6):
  bitmap: try to optimize arr32 <-> bitmap on 64-bit LEs
  bitmap: add a couple more helpers to work with arrays of u32s
  lib/test_bitmap: verify intermediate arr32 when converting <-> bitmap
  lib/test_bitmap: test the newly added arr32 functions
  bitops: make BYTES_TO_BITS() treewide-available
  netlink: add universal 'bigint' attribute type

 include/linux/bitmap.h         |  71 ++++++++---
 include/linux/bitops.h         |   1 +
 include/net/netlink.h          | 208 ++++++++++++++++++++++++++++++++-
 include/uapi/linux/netlink.h   |   6 +
 kernel/trace/trace_probe.c     |   2 -
 lib/bitmap.c                   |  52 ++++++++-
 lib/nlattr.c                   |  42 ++++++-
 lib/test_bitmap.c              |  47 ++++++++
 net/netlink/policy.c           |  40 +++++++
 tools/include/linux/bitops.h   |   1 +
 tools/perf/util/probe-finder.c |   2 -
 11 files changed, 445 insertions(+), 27 deletions(-)


base-commit: f00909e2e6fe4ac6b2420e3863a0c533fe4f15e0
-- 
2.37.3

