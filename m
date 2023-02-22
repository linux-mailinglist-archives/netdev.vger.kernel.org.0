Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E795D69FF2F
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 00:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbjBVXDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 18:03:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbjBVXCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 18:02:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B42A48E2F
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 15:02:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCADA615AC
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 23:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D1DC433D2;
        Wed, 22 Feb 2023 23:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677106930;
        bh=HJd4hOP3RXVSVlsTfPQU9fXtpRErO53cWCSOg17orXU=;
        h=From:To:Cc:Subject:Date:From;
        b=bnUyQnYyWgaJScewvgZJVfx8J+hmFWdKgOl9D2BgvZD9XR9GX1qwquBF56+lutWJN
         E3udpheK2bzW3y1BxUXgfgYHG+V1Uy8yyA2qIEIYJXG6zIVhZeI/UotCVNEoqzpfCc
         Bq/17WJY3RPKu/jd24Sehg1CIuUdHS7X5urtTLfQ+ceb83FdDmKNxrNw1NftT+eIcl
         6g5ghXhnN2Nv5cs9Hjg1R58SAysII9ukloxIvvBMKSaOBWauo1tQ66rm8+Z1JrbbhU
         8rIjiCsghvgumf69LDtFm3XEIsvAVGXz35pj9zeeDVVPvjrR1/YZ/hUu8CbJ9x872a
         NunYAPskr4JKw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V2 0/4] mlx5 technical debt of hairpin params
Date:   Wed, 22 Feb 2023 15:01:58 -0800
Message-Id: <20230222230202.523667-1-saeed@kernel.org>
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

v1->v2:
 - Remove gerrit change-id tags

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

