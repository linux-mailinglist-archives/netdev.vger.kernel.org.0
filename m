Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7710B64F6BA
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 02:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiLQBUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 20:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLQBUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 20:20:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928B36809D
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 17:20:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 040B8621F6
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 01:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21800C433D2;
        Sat, 17 Dec 2022 01:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671240009;
        bh=FpvNeKaqog8I9K7JKd14R8emGGNtptAsI93PTWptGHQ=;
        h=From:To:Cc:Subject:Date:From;
        b=C0Yy2NPzRoEF8KU8KY2oMZrgVzKrABGAWdyjiG4Bw2lGGQSy7DrbuoB15WDxbfUrF
         8GjBn7GkW+WRdyDfLgWG5zf4/AJmVULaNnFFFOWEnpFoMojJ7uXqvTE9LjZ6S9QgCu
         lHCeVMTKZG8dm8yK+EQqpgoM/XhQWv7pUl0C+IhNMHmtsDrzfwn6GNn0Z8Kp0QRBjM
         HDaxHXTP8+3Ldh6duVP1uv4denPUqhoEWCZqaOThvdHQSStHdQ15cOqiFsokuU6fze
         apkEODWpByWB/x25MARzVx0DYs7KB9a36PGYEgDd1gbR8V18ocWgXvscITwni+ekJF
         3AbU1OV8laxKw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     jiri@resnulli.us, jacob.e.keller@intel.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 00/10] devlink: remove the wait-for-references on unregister
Date:   Fri, 16 Dec 2022 17:19:43 -0800
Message-Id: <20221217011953.152487-1-kuba@kernel.org>
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

This set is on top of the previous RFC.

Move the registration and unregistration of the devlink instances
under their instance locks. Don't perform the netdev-style wait
for all references when unregistering the instance.

Jakub Kicinski (10):
  devlink: bump the instance index directly when iterating
  devlink: update the code in netns move to latest helpers
  devlink: protect devlink->dev by the instance lock
  devlink: always check if the devlink instance is registered
  devlink: remove the registration guarantee of references
  devlink: don't require setting features before registration
  netdevsim: rename a label
  netdevsim: move devlink registration under the instance lock
  devlink: allow registering parameters after the instance
  netdevsim: register devlink instance before sub-objects

 drivers/net/netdevsim/dev.c |  15 +++--
 include/net/devlink.h       |   3 +
 net/devlink/basic.c         |  64 ++++++++++++------
 net/devlink/core.c          | 127 +++++++++++++++++-------------------
 net/devlink/devl_internal.h |  20 ++----
 net/devlink/netlink.c       |  19 ++++--
 6 files changed, 136 insertions(+), 112 deletions(-)

-- 
2.38.1

