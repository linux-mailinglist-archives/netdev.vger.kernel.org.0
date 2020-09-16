Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D42D26BD43
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbgIPGf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:35:56 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:50311 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726132AbgIPGfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 02:35:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 74B79837;
        Wed, 16 Sep 2020 02:35:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 16 Sep 2020 02:35:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=4zss/0yGPLXTrAaz+
        jLGfDZIrN8J2D7ucdbcYqtk9mY=; b=SOcbUqTzbpFl78/CzpZu9GUODaNeaTW4+
        pBcKVfGXxD+dbwP+l8feGlaGpRk6xGlO7E9F1dVoKh94UOV8Xp9r6LLYZp30k6Kc
        YQLcy0qFpw/u6GC58j9ohd4LAlNif3vYKtv9ZtVKub8lGInK2EWMMULnno2J9Im3
        8eCTPQgYeZoOfd+uGCiU3zvQDU+6EzBEcxb+j/Qsr07hXfdMGu8ntvs7lWwW6efc
        EIV7ydAh8Oh0zxeJUDVClJvRcvIgtsdESlfGcXq5gG2h1McslJAieQjqN4GgTfOj
        gBo0+Fyvan26roZbhkJmh98YmMvHwb84xZ8sx4IMNKT1HJMF/pAmg==
X-ME-Sender: <xms:R7JhX6hOYWchJwYg_IUKg74XqX86OaQZySY9QXa0rw4Wn-mfENYLZQ>
    <xme:R7JhX7CJ7-u7lknU14nnODHvCatpaKLKCb3hkcslcwMhLJEEFXuk_zfbEpNv0Pj24
    _40YKe66vIWuu0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrfeeirdekvdenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:R7JhXyEYUjB80eeSlxFNUVahzSVE-cc2WAK7NtNtevjJHZG7PqIgIQ>
    <xmx:R7JhXzRY8XWxvduDo66s7tQWk_jUOTnVPOkc1HmexENwguOMNTY8lw>
    <xmx:R7JhX3wKNbEUpbgDdFVjDRkx_5FApTEjZhRgYYdrm8ovvXUkUmRw8g>
    <xmx:SLJhX3_mnF3zBMRc1MJLVHrVgFiRP-Q9GpZIW4QTVtQNraQzrGcj0Q>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id D77A83064682;
        Wed, 16 Sep 2020 02:35:49 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/15] mlxsw: Refactor headroom management
Date:   Wed, 16 Sep 2020 09:35:13 +0300
Message-Id: <20200916063528.116624-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Petr says:

On Spectrum, port buffers, also called port headroom, is where packets are
stored while they are parsed and the forwarding decision is being made. For
lossless traffic flows, in case shared buffer admission is not allowed,
headroom is also where to put the extra traffic received before the sent
PAUSE takes effect. Another aspect of the port headroom is the so called
internal buffer, which is used for egress mirroring.

Linux supports two DCB interfaces related to the headroom: dcbnl_setbuffer
for configuration, and dcbnl_getbuffer for inspection. In order to make it
possible to implement these interfaces, it is first necessary to clean up
headroom handling, which is currently strewn in several places in the
driver.

The end goal is an architecture whereby it is possible to take a copy of
the current configuration, adjust parameters, and then hand the proposed
configuration over to the system to implement it. When everything works,
the proposed configuration is accepted and saved. First, this centralizes
the reconfiguration handling to one function, which takes care of
coordinating buffer size changes and priority map changes to avoid
introducing drops. Second, the fact that the configuration is all in one
place makes it easy to keep a backup and handle error path rollbacks, which
were previously hard to understand.

Patch #1 introduces struct mlxsw_sp_hdroom, which will keep port headroom
configuration.

Patch #2 unifies handling of delay provision between PFC and PAUSE. From
now on, delay is to be measured in bytes of extra space, and will not
include MTU. PFC handler sets the delay directly from the parameter it gets
through the DCB interface. For PAUSE, MLXSW_SP_PAUSE_DELAY is converted to
have the same meaning.

In patches #3-#5, MTU, lossiness and priorities are gradually moved over to
struct mlxsw_sp_hdroom.

In patches #6-#11, handling of buffer resizing and priority maps is moved
from spectrum.c and spectrum_dcb.c to spectrum_buffers.c. The API is
gradually adapted so that struct mlxsw_sp_hdroom becomes the main interface
through which the various clients express how the headroom should be
configured.

Patch #12 is a small cleanup that the previous transformation made
possible.

In patch #13, the port init code becomes a boring client of the headroom
code, instead of rolling its own thing.

Patches #14 and #15 move handling of internal mirroring buffer to the new
headroom code as well. Previously, this code was in the SPAN module. This
patchset converts the SPAN module to another boring client of the headroom
code.

Petr Machata (15):
  mlxsw: spectrum_buffers: Add struct mlxsw_sp_hdroom
  mlxsw: spectrum: Unify delay handling between PFC and pause
  mlxsw: spectrum: Track MTU in struct mlxsw_sp_hdroom
  mlxsw: spectrum: Track priorities in struct mlxsw_sp_hdroom
  mlxsw: spectrum: Track lossiness in struct mlxsw_sp_hdroom
  mlxsw: spectrum: Track buffer sizes in struct mlxsw_sp_hdroom
  mlxsw: spectrum: Split headroom autoresize out of buffer configuration
  mlxsw: spectrum_dcb: Convert ETS handler fully to
    mlxsw_sp_hdroom_configure()
  mlxsw: spectrum_dcb: Convert mlxsw_sp_port_pg_prio_map() to hdroom
    code
  mlxsw: spectrum: Move here the three-step headroom configuration from
    DCB
  mlxsw: spectrum_buffers: Move here the new headroom code
  mlxsw: spectrum_buffers: Inline mlxsw_sp_sb_max_headroom_cells()
  mlxsw: spectrum_buffers: Convert mlxsw_sp_port_headroom_init()
  mlxsw: spectrum_buffers: Introduce shared buffer ops
  mlxsw: spectrum_buffers: Manage internal buffer in the hdroom code

 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 136 +------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  71 +++-
 .../mellanox/mlxsw/spectrum_buffers.c         | 361 ++++++++++++++++--
 .../ethernet/mellanox/mlxsw/spectrum_dcb.c    | 104 ++---
 .../mellanox/mlxsw/spectrum_ethtool.c         |  27 +-
 .../ethernet/mellanox/mlxsw/spectrum_span.c   |  65 +---
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |   1 -
 7 files changed, 470 insertions(+), 295 deletions(-)

-- 
2.26.2

