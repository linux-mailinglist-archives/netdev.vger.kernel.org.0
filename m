Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B12E65CC4D
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 05:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238242AbjADEQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 23:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbjADEQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 23:16:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD336167F8
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 20:16:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48EDB60B7F
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 04:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ECBAC433D2;
        Wed,  4 Jan 2023 04:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672805803;
        bh=vw7Kz/Vc482PL0C+rArhGDkhpyPXG+Gik68omp7J3UI=;
        h=From:To:Cc:Subject:Date:From;
        b=ZG3ZcUT4v3IGcDFFJNm9iUjdNapD+yBjmZXg8CDpsJfywFW5nBbDDQ/yN2xXw7at3
         ZEV1xc+BQNlNL1mjr1ru9sLReQAzU/rMZpcOXt4Uo7Yz+1PSl8vdinr0bV5H5q5btP
         7lqeCqnq9mmGOzrF7N8iHJ8xHgvouoR0wT/u5lJq6h5TG0OFA6YdKDroz9vcFcI0Nw
         rzq7H3kPWWnuROC8H6eooqKbdYQDBouaLSHBXHwIzMaPw+bxRgtD/zoCVzUTmToO+e
         VfMMLFXbPZ6PTNzp8lhs40W0CEIChATpCnhqVg0y7QyjLnH7bKjkR5iZapc942Tz04
         93hU0odx9xAkw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/14] devlink: code split and structured instance walk
Date:   Tue,  3 Jan 2023 20:16:22 -0800
Message-Id: <20230104041636.226398-1-kuba@kernel.org>
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

RFC: https://lore.kernel.org/all/20221215020155.1619839-1-kuba@kernel.org/

v1:
 - re-route the locking fix via net
 - rename basic.c -> leftover.c

Jakub Kicinski (14):
  devlink: move code to a dedicated directory
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
 net/devlink/devl_internal.h                |  205 +++
 net/{core/devlink.c => devlink/leftover.c} | 1460 +++++---------------
 net/devlink/netlink.c                      |  241 ++++
 net/netfilter/nf_conntrack_netlink.c       |    2 +-
 9 files changed, 1157 insertions(+), 1105 deletions(-)
 create mode 100644 net/devlink/Makefile
 create mode 100644 net/devlink/core.c
 create mode 100644 net/devlink/devl_internal.h
 rename net/{core/devlink.c => devlink/leftover.c} (90%)
 create mode 100644 net/devlink/netlink.c

-- 
2.38.1

