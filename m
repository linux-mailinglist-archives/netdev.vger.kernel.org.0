Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042C465FB77
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 07:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbjAFGeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 01:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbjAFGeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 01:34:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178206E0C4
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 22:34:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9FA061D23
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 06:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF70C433EF;
        Fri,  6 Jan 2023 06:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672986847;
        bh=wfJ60GeMs5NHhZLdLjBJXhc/d59VR31VTPPa6ALzJ+U=;
        h=From:To:Cc:Subject:Date:From;
        b=iFtJ+Y07etVqsO7qH3Bz3990oHF9+AnBK0x4HtMU9UBQzjPDgRr1yovdkrCN/VD40
         GXFq4cHgnEXVmxtMMHYFEaxUNPp2rvGSsAN5MZkb1SynwWS7ch8lincSUTRQzwlAWO
         yJgMKeegsRk8wboA6zs9zV0MIleZr3YVH/5kdQ37AcTuZmlEjWShKckUVOTDrR0pUU
         4OP7ojXn4F0VyA2/pz6ZmQ/XsBlDhKSOfwkFo8LJvZbLRq8iGT8HOaVAaXJcWzBm77
         lCy+2inmI65h/XNKhP2GcWri3D3koIg1dtANYUnlrSeGBunm1a1D678ZlMiAyoOF9S
         jy/m+Dx7Ho9vQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/9] devlink: remove the wait-for-references on unregister
Date:   Thu,  5 Jan 2023 22:33:53 -0800
Message-Id: <20230106063402.485336-1-kuba@kernel.org>
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

Move the registration and unregistration of the devlink instances
under their instance locks. Don't perform the netdev-style wait
for all references when unregistering the instance.

Instead the devlink instance refcount will only ensure that
the memory of the instance is not freed. All places which acquire
access to devlink instances via a reference must check that the
instance is still registered under the instance lock.

This fixes the problem of the netdev code accessing devlink
instances before they are registered.

RFC: https://lore.kernel.org/all/20221217011953.152487-1-kuba@kernel.org/
 - rewrite the cover letter
 - rewrite the commit message for patch 1
 - un-export and rename devl_is_alive
 - squash the netdevsim patches

Jakub Kicinski (9):
  devlink: bump the instance index directly when iterating
  devlink: update the code in netns move to latest helpers
  devlink: protect devlink->dev by the instance lock
  devlink: always check if the devlink instance is registered
  devlink: remove the registration guarantee of references
  devlink: don't require setting features before registration
  devlink: allow registering parameters after the instance
  netdevsim: rename a label
  netdevsim: move devlink registration under the instance lock

 drivers/net/netdevsim/dev.c |  15 +++--
 include/net/devlink.h       |   2 +
 net/devlink/core.c          | 121 ++++++++++++++++--------------------
 net/devlink/devl_internal.h |  28 ++++-----
 net/devlink/leftover.c      |  64 ++++++++++++-------
 net/devlink/netlink.c       |  19 ++++--
 6 files changed, 137 insertions(+), 112 deletions(-)

-- 
2.38.1

