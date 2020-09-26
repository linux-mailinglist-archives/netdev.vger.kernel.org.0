Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5031F2795B7
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 02:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbgIZA44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 20:56:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726316AbgIZA44 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 20:56:56 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F34D20809;
        Sat, 26 Sep 2020 00:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601081815;
        bh=amLa4k0PPAkQKg9ijKa8+pv8GQn7HB7WjSCLSH+TdGg=;
        h=From:To:Cc:Subject:Date:From;
        b=Mr1dazX9E8DR91wwwdQVleiXspDniwL2fnshWXkxzha4tHdV6NMuQZ9dnc5uRFjjH
         gz5j0K6/rf8zeAdDG9/Z8jObVMRfFqW4Fpx2xE4vq1NDsyAidPMDrzi1aL2ETgqxg2
         yxLPTN5UKwfCZtc3pTsz0Pc/XNtuZeBdAUs8RrFE=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 00/10] udp_tunnel: convert Intel drivers with shared tables
Date:   Fri, 25 Sep 2020 17:56:39 -0700
Message-Id: <20200926005649.3285089-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set converts Intel drivers which have the ability to spawn
multiple netdevs, but have only one UDP tunnel port table.

Appropriate support is added to the core infra in patch 1,
followed by netdevsim support and a selftest.

The table sharing works by core attaching the same table
structure to all devices sharing the table. This means the
reference count has to accommodate potentially large values.

Once core is ready i40e and ice are converted. These are
complex drivers, but we got a tested-by from Aaron, so we
should be good :)

Compared to v1 I've made sure the selftest is executable.

Other than that patches 8 and 9 are actually from the Mellanox
conversion series were kept out to avoid Mellanox vs Intel
conflicts.

Last patch is new, some docs to let users knows ethtool
can now display UDP tunnel info.

Jakub Kicinski (10):
  udp_tunnel: add the ability to share port tables
  netdevsim: add warnings on unexpected UDP tunnel port errors
  netdevsim: shared UDP tunnel port table support
  selftests: net: add a test for shared UDP tunnel info tables
  i40e: convert to new udp_tunnel infrastructure
  ice: remove unused args from ice_get_open_tunnel_port()
  ice: convert to new udp_tunnel infrastructure
  netdevsim: support the static IANA VXLAN port flag
  selftests: net: add a test for static UDP tunnel ports
  docs: vxlan: add info about device features

 Documentation/networking/vxlan.rst            |  28 ++
 drivers/net/ethernet/intel/i40e/i40e.h        |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 264 ++++--------------
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c |   6 +-
 drivers/net/ethernet/intel/ice/ice_fdir.c     |   2 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 231 +++++++--------
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |  11 +-
 .../net/ethernet/intel/ice/ice_flex_type.h    |   5 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  97 ++-----
 drivers/net/ethernet/intel/ice/ice_type.h     |   3 +
 drivers/net/netdevsim/netdevsim.h             |   8 +-
 drivers/net/netdevsim/udp_tunnels.c           |  34 ++-
 include/net/udp_tunnel.h                      |  24 ++
 net/ipv4/udp_tunnel_nic.c                     |  96 ++++++-
 .../drivers/net/netdevsim/udp_tunnel_nic.sh   | 167 +++++++++++
 15 files changed, 531 insertions(+), 451 deletions(-)
 mode change 100644 => 100755 tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh

-- 
2.26.2

