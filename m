Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1441559F2CD
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 06:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233426AbiHXEul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 00:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbiHXEub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 00:50:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE88B7C18C
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 21:50:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33586B80E62
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 04:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25FBC433B5;
        Wed, 24 Aug 2022 04:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661316628;
        bh=eEo9CIqhN35Xi8xj8S1HIA9Rp6HB+DV8YylK9UCyrMA=;
        h=From:To:Cc:Subject:Date:From;
        b=oL3JVV31ITGZkPEAgNFFrU5/sQQh9fQqo33WDqYHhaS3rlX05PqV23n2Agf1F30yx
         sTYnselxIwiZlXGKE67nH8QQ/KC+i2i6XpuDAenWANIJYjiVhUYLIHDGT8+fhTEwGu
         Wi78Wj2jGBtfP9BagPB0pCa21WqiN9x55MZPAF6KjqGzPJ77YIjW/hGOZWGj7Z00Rr
         A4b4/RWA5zOaYG/ngVSlGGaxVPyexUFGyt/xA7yTTb3QTfOzB4Q4tU6K28u6oFQUzN
         +POuI8sQkLfUT817wq7thknxHDUcDLppNuzpif4rQaIyl5f47BgKKPUqSm5wPAdbIN
         +YhLfzye0EIrw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        mkubecek@suse.cz, johannes@sipsolutions.net,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/6] netlink: support reporting missing attributes
Date:   Tue, 23 Aug 2022 21:50:18 -0700
Message-Id: <20220824045024.1107161-1-kuba@kernel.org>
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

Jakub Kicinski (6):
  netlink: add support for ext_ack missing attributes
  netlink: add helper for extack attr presence checking
  genetlink: add helper for checking required attrs and use it in
    devlink
  devlink: use missing attribute ext_ack
  ethtool: strset: report missing ETHTOOL_A_STRINGSET_ID via ext_ack
  ethtool: report missing header via ext_ack in the default handler

 Documentation/userspace-api/netlink/intro.rst |  7 +++-
 include/linux/netlink.h                       | 24 +++++++++++
 include/net/genetlink.h                       | 14 +++++++
 include/uapi/linux/netlink.h                  |  4 ++
 net/core/devlink.c                            | 41 +++++++++----------
 net/ethtool/netlink.c                         |  3 ++
 net/ethtool/strset.c                          |  2 +-
 net/netlink/af_netlink.c                      | 12 ++++++
 net/netlink/genetlink.c                       |  2 +-
 9 files changed, 84 insertions(+), 25 deletions(-)

-- 
2.37.2

