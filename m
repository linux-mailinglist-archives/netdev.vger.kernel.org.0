Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A065216C0
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 15:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241915AbiEJNSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 09:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242409AbiEJNQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 09:16:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4688D3E0ED;
        Tue, 10 May 2022 06:12:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C08ADB81D7A;
        Tue, 10 May 2022 13:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0436FC385C6;
        Tue, 10 May 2022 13:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652188362;
        bh=gVkm7tsqFMVgekRVZK+ehAPvWhA03bllpuQravLJWO0=;
        h=From:To:Cc:Subject:Date:From;
        b=as4bZ6juQ9EqGMeC+SVU6tACeaIb6OeDI5Z4HEsjZxCUfmc9qVS8/zN7LUQm3QX2Z
         9XxnVxQG2zuu8q1c7RkndUwlgCApKjJQCJTqaV/zB59fl42/NqiVvNUiyI4WOsDYKi
         PdrIm/fPMYuPAtHiN5F0lWnk3Hvy5MM7ruledTeA9dZLIB0Qeh2eCpRHg64I3jE3hi
         ov8YcD1i2Pt8W/O/xacD3jrpaNT689RafmY3ugGhZJndLVEldf6aTMukWH///dK0I0
         hiB9oLCoLnoDxx9mB0K0GxLzWjip9m+VkLiFf9KD0PAk+KDh2SfSLeC2VQ3eJ9Rrqa
         zEmWTivv+hKFQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     alex.williamson@redhat.com
Cc:     jgg@nvidia.com, saeedm@nvidia.com,
        Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, maorg@nvidia.com,
        cohuck@redhat.com, Leon Romanovsky <leonro@nvidia.com>
Subject: [GIT PULL] Please pull mlx5 vfio changes 
Date:   Tue, 10 May 2022 16:12:36 +0300
Message-Id: <20220510131236.1039430-1-leon@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 2984287c4c19949d7eb451dcad0bd5c54a2a376f:

  net/mlx5: Remove not-implemented IPsec capabilities (2022-04-09 08:25:07 +0300)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/ tags/mlx5-lm-parallel

for you to fetch changes up to 4d67783344e8380ec3c0810e4f67c003646ccd7e:

  vfio/mlx5: Run the SAVE state command in an async mode (2022-05-10 15:46:42 +0300)

----------------------------------------------------------------
Improve mlx5 live migration driver

From Yishai:

This series improves mlx5 live migration driver in few aspects as of
below.

Refactor to enable running migration commands in parallel over the PF
command interface.

To achieve that we exposed from mlx5_core an API to let the VF be
notified before that the PF command interface goes down/up. (e.g. PF
reload upon health recovery).

Once having the above functionality in place mlx5 vfio doesn't need any
more to obtain the global PF lock upon using the command interface but
can rely on the above mechanism to be in sync with the PF.

This can enable parallel VFs migration over the PF command interface
from kernel driver point of view.

In addition,
Moved to use the PF async command mode for the SAVE state command.
This enables returning earlier to user space upon issuing successfully
the command and improve latency by let things run in parallel.

Alex, as this series touches mlx5_core we may need to send this in a
pull request format to VFIO to avoid conflicts before acceptance.

Link: https://lore.kernel.org/all/20220510090206.90374-1-yishaih@nvidia.com
Signed-of-by: Leon Romanovsky <leonro@nvidia.com>

----------------------------------------------------------------
Yishai Hadas (4):
      net/mlx5: Expose mlx5_sriov_blocking_notifier_register / unregister APIs
      vfio/mlx5: Manage the VF attach/detach callback from the PF
      vfio/mlx5: Refactor to enable VFs migration in parallel
      vfio/mlx5: Run the SAVE state command in an async mode

 drivers/net/ethernet/mellanox/mlx5/core/sriov.c |  65 ++++++-
 drivers/vfio/pci/mlx5/cmd.c                     | 236 ++++++++++++++++++------
 drivers/vfio/pci/mlx5/cmd.h                     |  52 +++++-
 drivers/vfio/pci/mlx5/main.c                    | 122 +++++-------
 include/linux/mlx5/driver.h                     |  12 ++
 5 files changed, 351 insertions(+), 136 deletions(-)
