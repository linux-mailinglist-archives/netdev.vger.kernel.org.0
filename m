Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05B9603663
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 01:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiJRXHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 19:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiJRXHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 19:07:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DCD2A711
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 16:07:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FD98B8207D
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AFFC433D7;
        Tue, 18 Oct 2022 23:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666134453;
        bh=z13ZWeVVEDh+ESE0EyBSSI42dlr12SzQwCPJZZ8xQCY=;
        h=From:To:Cc:Subject:Date:From;
        b=p1SeGd7C8vKPc9mwji3C+MmWvkhCFhzjyyLS+Dw3JFU+n+09XDX1Jf2NlwEq+7xaG
         /c9lz9dbfR+jxO7JG4o1g+bfKPghthtr9lJ1XnC1YkwcJhjt/IOKEop2TEboGXOU/J
         ZX9K0JO/iKlJoFNHcHB8CrUa7FvyUWkEUu044w5aWZUkE4wNYCP+a6ZjW07OfH77vQ
         9kKuB8mKcLD0zb2fKC3EUn3s7Rxk30Ts0YMZg2QWaGlR1f4/NgP9DThMPQMcLwPyCv
         rPhQcTu8QCT377bPNjqCzVO7z5d+om0Gm53PsRJ3c3ncYKt1AKclIlYkTqh7uh9sQA
         zpzbqxMfNHD9Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/13] genetlink: support per op type policies
Date:   Tue, 18 Oct 2022 16:07:15 -0700
Message-Id: <20221018230728.1039524-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

 include/net/genetlink.h   |  76 ++++++-
 net/batman-adv/netlink.c  |   6 +-
 net/core/devlink.c        |   4 +-
 net/core/drop_monitor.c   |   4 +-
 net/ieee802154/nl802154.c |   6 +-
 net/netlink/genetlink.c   | 461 ++++++++++++++++++++++++++++----------
 net/wireless/nl80211.c    |   6 +-
 7 files changed, 426 insertions(+), 137 deletions(-)

-- 
2.37.3

