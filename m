Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E82164D527
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 03:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiLOCCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 21:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiLOCCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 21:02:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D0D2ED5E
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 18:02:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26A2A61CDA
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 02:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9DDC433EF;
        Thu, 15 Dec 2022 02:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671069722;
        bh=S1TROJUUPDyB6I7DpmmSa/Bc9dhNdXZYJ5jksEywfWQ=;
        h=From:To:Cc:Subject:Date:From;
        b=siHDlDsodBUXuEtOF/VdC47mE1Ga0t1k1d9blcmaqxiRZqvl8fcbZ00TJtFNuTb0S
         QU80lplao3HsZZwr1vPU5VX8L1boq8mq0Puvvl2U7PyAW0pyOIPvQ0dy98knoJxEPY
         k3K+Fc6INvo9SGu8VQHEqaYibMI1xoegW+cVYOgROhAcfyAPS/aflaVPF8HiagB+lR
         7hlgpRaifNXMr5r3PEfkt+gEi72ZvISCMbDZo4NwSrIiUXbuU4NYLytaJAnV0cSBJ8
         FLl2DNh5vGHAX6jbpha6QpqISY8LcqDNWfSFCjobsVIH1woA/IlUifkOzsloYX6BfV
         x4gcqbK1V7zMA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, jacob.e.keller@intel.com, leon@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 00/15] devlink: code split and structured instance walk
Date:   Wed, 14 Dec 2022 18:01:40 -0800
Message-Id: <20221215020155.1619839-1-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

I started working on the refcounting / registration changes
and (as is usual in our profession) I quickly veered off into
refactoring / paying technical debt. I hope this is not too
controversial.

===

Split devlink.c into a handful of files, trying to keep the "core"
code away from all the command-specific implementations.
The core code has been quite scattered before. Going forward we can
consider using a source file per-subobject, I think that it's quite
beneficial to newcomers (based on relative ease with which folks
contribute to ethtool vs devlink). But this series doesn't split
everything out, yet - partially due to backporting concerns,
but mostly due to lack of time. 

Introduce a context structure for dumps, and use it to store
the devlink instance ID of the last dumped devlink instance.
This means we don't have to restart the walk from 0 each time.

Finally - introduce a "structured walk". A centralized dump handler
in devlink/netlink.c which walks the devlink instances, deals with
refcounting/locking, simplifying the per-object implementations quite
a bit.

Jakub Kicinski (15):
  devlink: move code to a dedicated directory
  devlink: split out core code
  devlink: split out netlink code
  devlink: protect devlink dump by the instance lock
  netlink: add macro for checking dump ctx size
  devlink: use an explicit structure for dump context
  devlink: remove start variables from dumps
  devlink: drop the filter argument from devlinks_xa_find_get
  devlink: health: combine loops in dump
  devlink: restart dump based on devlink instance ids (simple)
  devlink: restart dump based on devlink instance ids (nested)
  devlink: restart dump based on devlink instance ids (function)
  devlink: uniformly take the devlink instance lock in the dump loop
  devlink: add by-instance dump infra
  devlink: convert remaining dumps to the by-instance scheme

 include/linux/netlink.h                 |    4 +
 net/Makefile                            |    1 +
 net/core/Makefile                       |    1 -
 net/devlink/Makefile                    |    3 +
 net/{core/devlink.c => devlink/basic.c} | 1457 ++++++-----------------
 net/devlink/core.c                      |  345 ++++++
 net/devlink/devl_internal.h             |  205 ++++
 net/devlink/netlink.c                   |  241 ++++
 net/netfilter/nf_conntrack_netlink.c    |    2 +-
 9 files changed, 1157 insertions(+), 1102 deletions(-)
 create mode 100644 net/devlink/Makefile
 rename net/{core/devlink.c => devlink/basic.c} (90%)
 create mode 100644 net/devlink/core.c
 create mode 100644 net/devlink/devl_internal.h
 create mode 100644 net/devlink/netlink.c

-- 
2.38.1

