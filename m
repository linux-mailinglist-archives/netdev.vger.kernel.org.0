Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8374B616FD7
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 22:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiKBVds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 17:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiKBVdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 17:33:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3A7C4D
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 14:33:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D7DD61C3F
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 21:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F5AC433C1;
        Wed,  2 Nov 2022 21:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667424825;
        bh=FqYHztiGZQCauRqR8qo71czSsJf7f6lstt9FTrfbwEY=;
        h=From:To:Cc:Subject:Date:From;
        b=hp2+wMthKRd2BAx31CgqVJtc8DlIXOBNZQhQ8iNJzhaRGstcgP6LmURAlO9ZxZ2vq
         FGnKaPTRS2YiYVdx/P7pOURgQ9p5NQ06HFmK06Q1BflH8ZBthFn9Xj7TJuRWFErjgf
         0x8h8YEdqxdPTybPloB/6JHCAB7vAfs2X523UA+fYfdW0EKkOrTrCnb2VGT/dFe4Uk
         mvXXRLp5ffK1LczJy9ZHij2Ux8B/bAW+FDqZYiDcavUUonkKl0oDHFXjchAvOdkder
         FZT7WGxiavveQ5oHcyt72OD8HF2AvMnENpUmuMlAVsunQUX9pLpTTGbqiFmXOH4yKn
         NwaEYpAdc7GjQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 00/13] genetlink: support per op type policies
Date:   Wed,  2 Nov 2022 14:33:25 -0700
Message-Id: <20221102213338.194672-1-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While writing new genetlink families I was increasingly annoyed by the fact
that we don't support different policies for do and dump callbacks.
This makes it hard to do proper input validation for dumps which usually
have a lot more narrow range of accepted attributes.

There is also a minor inconvenience of not supporting different per_doit
and post_doit callbacks per op.

This series addresses those problems by introducing another op format.

v2:
 - wait for net changes to propagate
 - restore the missing comment in patch 1
 - drop extra space in patch 3
 - improve commit message in patch 4
v1: https://lore.kernel.org/all/20221018230728.1039524-1-kuba@kernel.org/

Jakub Kicinski (13):
  genetlink: refactor the cmd <> policy mapping dump
  genetlink: move the private fields in struct genl_family
  genetlink: introduce split op representation
  genetlink: load policy based on validation flags
  genetlink: check for callback type at op load time
  genetlink: add policies for both doit and dumpit in
    ctrl_dumppolicy_start()
  genetlink: support split policies in ctrl_dumppolicy_put_op()
  genetlink: inline genl_get_cmd()
  genetlink: add iterator for walking family ops
  genetlink: use iterator in the op to policy map dumping
  genetlink: inline old iteration helpers
  genetlink: allow families to use split ops directly
  genetlink: convert control family to split ops

 include/net/genetlink.h   |  76 +++++-
 net/batman-adv/netlink.c  |   6 +-
 net/core/devlink.c        |   4 +-
 net/core/drop_monitor.c   |   4 +-
 net/ieee802154/nl802154.c |   6 +-
 net/netlink/genetlink.c   | 473 ++++++++++++++++++++++++++++----------
 net/wireless/nl80211.c    |   6 +-
 7 files changed, 433 insertions(+), 142 deletions(-)

-- 
2.38.1

