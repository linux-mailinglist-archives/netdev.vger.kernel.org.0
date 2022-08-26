Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 098295A1F48
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 05:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244045AbiHZDJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 23:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235364AbiHZDJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 23:09:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558F0CD527
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 20:09:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E47C6B8092A
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 03:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31209C433C1;
        Fri, 26 Aug 2022 03:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661483378;
        bh=4s5h1GjnYf7w8CFXXoxQZd5irFoGeo1CYRtBqNwuCH0=;
        h=From:To:Cc:Subject:Date:From;
        b=NII1xtehbZ82iE9zJpJFvOKkWMEczOr2picglrVFywd8xfLuLn0T59RUW/IrgQU31
         dIbexXmHUUJWPbgvim4spsJ99s1Y0hSKggT/B4lIvxfsz0FRmHsnRKzBJ4PCroaLwk
         3jaPBSG0APz4u/+C3nEhXzdvXZKwm2wTygHxrM1lywTNWcCny6YemT046AkUA7/rpd
         jG0gy74yqjsAKrSR57dfnvwyp68ZJQtdkFJZr8TteTNiyX0eegs6KcXmOHubmH3oQU
         RNx7MDeit7dVJbrOLDvn6nJTzJc/CpZq1Wbgtz2phWuxBPW9/2vlixtUHmhTLz0gk3
         UbwyFqwnXJiPg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        mkubecek@suse.cz, johannes@sipsolutions.net, idosch@idosch.org,
        dsahern@gmail.com, stephen@networkplumber.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 0/6] netlink: support reporting missing attributes
Date:   Thu, 25 Aug 2022 20:09:29 -0700
Message-Id: <20220826030935.2165661-1-kuba@kernel.org>
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
in a structured way. We communicate the type of the missing
attribute and if it was missing inside a nest the offset
of that nest.

Example of (YAML-based) user space reporting ethtool header
missing:

 Kernel error: missing attribute: .header

I was tempted to integrate the check with the policy
but it seems tricky without doing a full scan, and there
may be a ton of attrs in the policy. So leaving that
for later.

v3:
 - update cover letter
 - minor (non-functional) adjustments to patches 1, 2, 6
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

