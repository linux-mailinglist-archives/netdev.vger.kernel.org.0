Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0216B228D8B
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 03:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731595AbgGVB1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 21:27:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727953AbgGVB1Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 21:27:25 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 778CB206F5;
        Wed, 22 Jul 2020 01:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595381244;
        bh=Y2FzO6aj9jA/LhJ9UgZUS/x9jrhjcynfaaP92O4pl3c=;
        h=From:To:Cc:Subject:Date:From;
        b=2rO3RATVNaY5/Rs5ylrab/so+rFusIXKd1Sz8IIqWOuVL2vL2Z3ZCeyePSutihPEz
         mFKiTfT3Tj/LyFPTqU36j7ttpYDhysXfMcVOelWMHiBbEmfcYhmHTwqt+jOuNexkor
         y+gIAxtYoHU2LPFks0t0xBnu8ZcnOaBO5L2hbQYs=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v1 0/7] udp_tunnel: convert Intel drivers with shared tables
Date:   Tue, 21 Jul 2020 18:27:09 -0700
Message-Id: <20200722012716.2814777-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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
complex drivers, and I don't have HW to test so please
review..

Jakub Kicinski (7):
  udp_tunnel: add the ability to share port tables
  netdevsim: add warnings on unexpected UDP tunnel port errors
  netdevsim: shared UDP tunnel port table support
  selftests: net: add a test for shared UDP tunnel info tables
  i40e: convert to new udp_tunnel infrastructure
  ice: remove unused args from ice_get_open_tunnel_port()
  ice: convert to new udp_tunnel infrastructure

 drivers/net/ethernet/intel/i40e/i40e.h        |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 264 ++++--------------
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c |   6 +-
 drivers/net/ethernet/intel/ice/ice_fdir.c     |   2 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 231 +++++++--------
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |  11 +-
 .../net/ethernet/intel/ice/ice_flex_type.h    |   5 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  97 ++-----
 drivers/net/ethernet/intel/ice/ice_type.h     |   3 +
 drivers/net/netdevsim/netdevsim.h             |   7 +-
 drivers/net/netdevsim/udp_tunnels.c           |  30 +-
 include/net/udp_tunnel.h                      |  24 ++
 net/ipv4/udp_tunnel_nic.c                     |  96 ++++++-
 .../drivers/net/netdevsim/udp_tunnel_nic.sh   | 109 ++++++++
 14 files changed, 440 insertions(+), 451 deletions(-)

-- 
2.26.2

