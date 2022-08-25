Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237125A0765
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 04:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbiHYCla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 22:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbiHYCl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 22:41:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18345857F6
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 19:41:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BC3C616F8
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 02:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6994CC433C1;
        Thu, 25 Aug 2022 02:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661395286;
        bh=m0PYepxO4mI/1k/mhzXbOqYHLk9WFg7R2ANetzqHrZQ=;
        h=From:To:Cc:Subject:Date:From;
        b=f7CXBFZfmsFA8Ejndfshh4l4vNF7VfM8sZPnnw/rf/zE5g9Jk9x7IB2+szGmZd/3X
         k1PqHDyMotWbWC8tf6dyxn7xUJKVWPanfafeIVIT8OTOGQhlRHqlOOIabvss3PRdb6
         e2+LCvyAdzS6iysauy973jNjy810BkJ8+FB5a/hyC2CwYVzT/E4NvBJcj6Av4rb0S9
         2SP9BwT6/pD6/lNpaEN30ffUn494GCYVJ8Eo+KVup56SRpafYnF9Q6N1iupxVKRT/M
         7pxUzIr+kMVHDq4IIOEDlfkIG+qlVhmZQGy7hlo4OGi9Ky1/5O007Tr2p5TZQg6wgU
         mKByHk724rYzg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        mkubecek@suse.cz, johannes@sipsolutions.net,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/6] netlink: support reporting missing attributes
Date:   Wed, 24 Aug 2022 19:41:16 -0700
Message-Id: <20220825024122.1998968-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for reporting missing attributes
in a structured way. We can't point at things which don't
exist so we point at the containing nest or preceding
fixed header and report which attr type we expected to see.

Example of (YAML-based) user space reporting ethtool header
missing:

 Kernel error: missing attribute: .header

I was tempted to integrate the check with the policy
but it seems tricky without doing a full scan, and there
may be a ton of attrs in the policy. So leaving that
for later.

v2:
 - add patch 1
 - remove the nest attr if the attr is missing in the root

Jakub Kicinski (6):
  netlink: factor out extack composition
  netlink: add support for ext_ack missing attributes
  netlink: add helpers for extack attr presence checking
  devlink: use missing attribute ext_ack
  ethtool: strset: report missing ETHTOOL_A_STRINGSET_ID via ext_ack
  ethtool: report missing header via ext_ack in the default handler

 Documentation/userspace-api/netlink/intro.rst |  7 +-
 include/linux/netlink.h                       | 24 +++++
 include/net/genetlink.h                       |  7 ++
 include/uapi/linux/netlink.h                  |  6 ++
 net/core/devlink.c                            | 41 ++++----
 net/ethtool/netlink.c                         |  3 +
 net/ethtool/strset.c                          |  2 +-
 net/netlink/af_netlink.c                      | 97 +++++++++++++------
 8 files changed, 133 insertions(+), 54 deletions(-)

-- 
2.37.2

