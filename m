Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6406769FC49
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 20:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbjBVTgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 14:36:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjBVTgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 14:36:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7B22F79F
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 11:36:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B146861534
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 19:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25877C433D2;
        Wed, 22 Feb 2023 19:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677094563;
        bh=zh0SgDH7wpH3IuvD1ecsTMS+KhQXoqYNV6zJO3A/9sE=;
        h=From:To:Cc:Subject:Date:From;
        b=Mvb412nXIhK0H9k9Fdd72dsHYnnCIiljftmudh5WgfgmTfWc7Yp5vumfZAakUBHrC
         //MMkJ4YXG4LFANXmfdcALGtjYywUi5IsVFyYmaksA94ZwI9Q2mZM6+7QKeoK1OCU4
         z1chS3eTkLqk0turPgGQ2h85cxIUITW4S037+W+7QcJs/Gyex4tSjnJVQmueBytmSi
         /GCxdQVtINEmHCAp9b4A3IZ4vuJND4uRa0/3bW+KCm6rGfVKn1vYmxaWg4rXEJMJqN
         OushdQ42HyUbW6eEsap/gqZzj4qiOZdhhhNJl+lJKDaM5a3Xbr3WAtM/QndYqOLTPR
         7BGr3TQ1J01YQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 0/4] mlx5 technical debt of hairpin params
Date:   Wed, 22 Feb 2023 11:35:44 -0800
Message-Id: <20230222193548.502031-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Jakub,

As previously discussed, this series provides the switch from debugfs to devlink
params for hairpin.

Per the discussion in [1], move the hairpin queues control (number and size)
from debugfs to devlink.

Expose two devlink params:
    - hairpin_num_queues: control the number of hairpin queues
    - hairpin_queue_size: control the size (in packets) of the hairpin queues

[1] https://lore.kernel.org/all/20230111194608.7f15b9a1@kernel.org/

Disclaimer: I personally don't prefer devlink over debugfs, but since this is
something that you requested, I'm submitting this series.

Sorry for the late submission, I know we are on merge window, and in case you
don't plan to submit further pull requests to liuns, then maybe it's a good
idea to take only the first patch (revert debugfs) and push it through your
next net PR.

Thanks,
Saeed.

Gal Pressman (4):
  net/mlx5e: Remove hairpin write debugfs files
  net/mlx5: Move needed PTYS functions to core layer
  net/mlx5e: Add devlink hairpin queues parameters
  net/mlx5e: Add more information to hairpin table dump

 .../ethernet/mellanox/mlx5/devlink.rst        |  35 ++++
 Documentation/networking/devlink/mlx5.rst     |  12 ++
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  66 ++++++++
 .../net/ethernet/mellanox/mlx5/core/devlink.h |   2 +
 .../ethernet/mellanox/mlx5/core/en/params.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/port.c | 157 +-----------------
 .../net/ethernet/mellanox/mlx5/core/en/port.h |  14 --
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  12 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 117 +++----------
 .../net/ethernet/mellanox/mlx5/core/esw/qos.c |   2 +-
 .../net/ethernet/mellanox/mlx5/core/port.c    | 151 +++++++++++++++++
 include/linux/mlx5/port.h                     |  16 ++
 12 files changed, 318 insertions(+), 268 deletions(-)

-- 
2.39.1

