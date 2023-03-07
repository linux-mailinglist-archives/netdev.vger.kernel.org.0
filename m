Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072526AE3C9
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjCGPDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:03:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjCGPDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:03:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC557F018;
        Tue,  7 Mar 2023 06:54:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B04A66137B;
        Tue,  7 Mar 2023 14:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BB3C433D2;
        Tue,  7 Mar 2023 14:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678200865;
        bh=Q6sMvWfanLjsj3MsW3n6C9waf2QnfrdIvx9x5kj820c=;
        h=From:To:Cc:Subject:Date:From;
        b=pj0Eof2NYyZxloRdV7Iw6Zg2iaZzPFEklsVu1VI20QJBkM0ZjXyTlFzX4pYagk1A6
         d+KaWnDXvahYTdf3TnKcWrr/IDy3UcS+s5WQcE5/40cOvuVNV885JUGA6eDgKlZNAV
         nknEwidVM5My42xpOLHSL6nAFaPWZLbDrfLLqyjtReOGe/yXkpk91XcqJn/5vX8KzA
         Cx6oj9qrsdRD0SOTdORo7XRXA7uqKCMVgyM9yl+dVAfKG2hAdmfToyJvN3tL9HL20S
         uxcfkug+clSN6f70y4vdx59XvDFay8e1tLZh5Uzrhs1AVuaUPOMEr7hGHRnS1V+W25
         OZ0174X0shA+w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, tariqt@nvidia.com, leon@kernel.org,
        shayagr@amazon.com, akiyano@amazon.com, darinzon@amazon.com,
        sgoutham@marvell.com, lorenzo.bianconi@redhat.com, toke@redhat.com,
        teknoraver@meta.com
Subject: [PATCH net-next 0/8] update xdp_features flag according to NIC re-configuration
Date:   Tue,  7 Mar 2023 15:53:57 +0100
Message-Id: <cover.1678200041.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Take into account possible NIC configuration changes (e.g. LRO or tx/rx queues
reconfiguration) setting device xdp_features flag.
Introduce xdp_set_features_flag utility routine.

Lorenzo Bianconi (7):
  tools: ynl: fix render-max for flags definition
  tools: ynl: fix get_mask utility routine
  xdp: add xdp_set_features_flag utility routine
  net: thunderx: take into account xdp_features setting tx/rx queues
  net: ena: take into account xdp_features setting tx/rx queues
  veth: take into account device reconfiguration for xdp_features flag
  net/mlx5e: take into account device reconfiguration for xdp_features
    flag

Matteo Croce (1):
  mvpp2: take care of xdp_features when reconfiguring queues

 Documentation/netlink/specs/netdev.yaml       |  1 +
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 15 +++++--
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  6 ++-
 .../ethernet/cavium/thunder/nicvf_ethtool.c   | 17 ++++---
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  4 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 15 +++++--
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 10 ++++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 45 ++++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  3 ++
 drivers/net/veth.c                            | 42 +++++++++++++++--
 include/net/xdp.h                             | 11 +++++
 include/uapi/linux/netdev.h                   |  2 +
 net/core/xdp.c                                | 26 ++++++++---
 tools/include/uapi/linux/netdev.h             |  2 +
 tools/net/ynl/ynl-gen-c.py                    | 17 ++++---
 16 files changed, 176 insertions(+), 41 deletions(-)

-- 
2.39.2

