Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE3C65E457
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbjAEEFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjAEEFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:05:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289993725C
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 20:05:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C07C961372
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 04:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B85C433D2;
        Thu,  5 Jan 2023 04:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672891538;
        bh=yfzxJtGT1caDiujV5LDpzbbW98WbN9bIbAKiSFnSvYo=;
        h=From:To:Cc:Subject:Date:From;
        b=T4zbFjfU9M5BiH8y8QNSz/+v1ixTrIOuEeJLAM+ruSiH9GJ6uxDVmHmP9BV0/lBp7
         6N6akAatm4Gp9trPYkDhcDosJA3mPNhq7R79Kal2ao3wLS1olY8eJ0KbN6QDyJXcHs
         iteqP/Na2pHLZSxGzLCjtfMPWRMprNXEArBOWOo1vtCQqg6etcVm0WPVt0nRHQDa2W
         MsMWcy6/4qfVR3T/Qc8+LSwGd2LeSl0mx66OZ/0//y0lGW83kbpjdASSwoZTCnVGrv
         jNaATtx+nIjv28FFghfvoEiunaFhh30R0xCus+gdjb7BKXoRPZqpuChv8AxCLU5pgY
         w13PbZlz0i6Ag==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 00/15]  devlink: code split and structured instance walk
Date:   Wed,  4 Jan 2023 20:05:16 -0800
Message-Id: <20230105040531.353563-1-kuba@kernel.org>
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

Split devlink.c into a handful of files, trying to keep the "core"
code away from all the command-specific implementations.
The core code has been quite scattered until now. Going forward we can
consider using a source file per-subobject, I think that it's quite
beneficial to newcomers (based on relative ease with which folks
contribute to ethtool vs devlink). But this series doesn't split
everything out, yet - partially due to backporting concerns,
but mostly due to lack of time. Bulk of the netlink command
handling is left in a leftover.c file.

Introduce a context structure for dumps, and use it to store
the devlink instance ID of the last dumped devlink instance.
This means we don't have to restart the walk from 0 each time.

Finally - introduce a "structured walk". A centralized dump handler
in devlink/netlink.c which walks the devlink instances, deals with
refcounting/locking, simplifying the per-object implementations quite
a bit. Inspired by the ethtool code.

v2:
 - various renames
 - split patch 2

v1: https://lore.kernel.org/all/20230104041636.226398-1-kuba@kernel.org/
 - re-route the locking fix via net
 - rename basic.c -> leftover.c

RFC: https://lore.kernel.org/all/20221215020155.1619839-1-kuba@kernel.org/

Jakub Kicinski (15):
  devlink: move code to a dedicated directory
  devlink: rename devlink_netdevice_event ->
    devlink_port_netdevice_event
  devlink: split out core code
  devlink: split out netlink code
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

 include/linux/netlink.h                    |    4 +
 net/Makefile                               |    1 +
 net/core/Makefile                          |    1 -
 net/devlink/Makefile                       |    3 +
 net/devlink/core.c                         |  345 +++++
 net/devlink/devl_internal.h                |  207 +++
 net/{core/devlink.c => devlink/leftover.c} | 1460 +++++---------------
 net/devlink/netlink.c                      |  242 ++++
 net/netfilter/nf_conntrack_netlink.c       |    2 +-
 9 files changed, 1160 insertions(+), 1105 deletions(-)
 create mode 100644 net/devlink/Makefile
 create mode 100644 net/devlink/core.c
 create mode 100644 net/devlink/devl_internal.h
 rename net/{core/devlink.c => devlink/leftover.c} (90%)
 create mode 100644 net/devlink/netlink.c

-- 
2.38.1

