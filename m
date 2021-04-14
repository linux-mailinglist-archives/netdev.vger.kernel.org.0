Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B4A35FE66
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235104AbhDNX0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:26:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233136AbhDNX0O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 19:26:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C552D611CC;
        Wed, 14 Apr 2021 23:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618442752;
        bh=UB5lJqYBjcAO0lhX1Vf6KM5LXpiGETEX6dIqfFJgY+w=;
        h=From:To:Cc:Subject:Date:From;
        b=m2pgN8YX0VcU21qFnUjfdyvfRL3ILxLycIEdWbNPW/5WFGVv1IEHTSPrm9ErrhOt4
         COGJ3C0DlxJfrLzA+9+iD0YInewJqSJT/6DGVY0trc77Z+n7+63h4cE8Y/QSRS+vZ2
         S4IAxiDktEalK1g3Dy2gjTAWTq54sbwuY1TINj3dn91VGu0HUz8C74omN/ZB19ppPw
         vMGIpvTZLY5AKV6meRUVGKbBbcpTG9SGlpOl3LF8tgWoTaMRT2fpcB+flxoLamsItM
         Y9Hl9gFMOnyOSZTy1u5+mWzrtn9YPU+lILzGFpoLNDajyr9tmuLXAcz1VPDttts+il
         AF/ILhjX3ex0Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        "Cc : Steffen Klassert" <steffen.klassert@secunet.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net 0/3] Fix ipsec offlaods with vxlan tunnel
Date:   Wed, 14 Apr 2021 16:25:37 -0700
Message-Id: <20210414232540.138232-1-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

This small series fixes ipsec TX offloads with vxlan overlay on top of
the offloaded ipsec packet, the driver (mlx5) was lacking such information
and the skb->encapsulation bit wasn't enough as indication to reach the
vxlan inner headers, as a solution we mark the tunnel in the offloaded
context of ipsec.

For more information please see commit messages.

Thanks,
Saeed.

---

Huy Nguyen (3):
  net/mlx5: Optimize mlx5e_feature_checks for non IPsec packet
  net/xfrm: Add inner_ipproto into sec_path
  net/mlx5: Fix checksum issue of VXLAN and IPsec crypto offload

 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c  | 65 ++++++++++++++-----
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  | 34 ++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  8 ++-
 include/net/xfrm.h                            |  1 +
 net/xfrm/xfrm_output.c                        | 36 +++++++++-
 5 files changed, 118 insertions(+), 26 deletions(-)

-- 
2.30.2

