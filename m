Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B1D1C0369
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgD3RBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:01:47 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60207 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726394AbgD3RBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 13:01:47 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 575655C010E;
        Thu, 30 Apr 2020 13:01:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 30 Apr 2020 13:01:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=YYQbcqYyuk2nv/foc
        WXz2F+Yv9PPH/LAddJisdCV/SQ=; b=MUVy1Rwgb6ioR9XBpRQ4Jckiz2dSAXUQh
        QX+mA0Lf33f6z7hlefU6Kxoujnz6O3rcOW+0WAvzaOhfYJEfXYUQgtAAdE/BFXEZ
        i+OBxdQs82Q+TipLXCCtkljh4g1Q/saTaw1EyaiOPPyDG66PKMUE74q2g52PMb5U
        0AiQSeH+FSp0/lcRI4XOzekr468Kx+HGWAK2YRBYlmZRnBZeUz8aJX/2KNuhBT1/
        J3cwfVtZ5j9gVBnXTIyJ87i4OpHYsg8on0U+yrrxXUZ+W/mvaf6n72K1fBD71cXL
        CLoq3xVAWjHli0DyLJmf8oR6Sw919v6vtU2bnkirrZEj/t+/UxjcQ==
X-ME-Sender: <xms:eQSrXtBUo4BG2lk2qmBNsdxR4BDX1Jems8QEr6jeghI9iv1y9RXeVQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrieehgddutdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeejledrudektddrheegrdduudeinecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:eQSrXhpsQ10QHfKzGR-drZ-xBy0UCcl2_ZqQetcz6fKCAo9EC1eqAw>
    <xmx:eQSrXviH7uTjv-hFyrjqwy8YDVSZ6IhBXEx1NkMg0LOYkL_hSGcdrA>
    <xmx:eQSrXu4xf__o_Igmi07m2kBOlao1lSAMnNyILR9W5kiBz4mDGSCgwg>
    <xmx:egSrXhK1o5_ZMRSETSjTs5eK-iZFeuoROL06Y6B-DDaBERimUWklNw>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6D91B3065F42;
        Thu, 30 Apr 2020 13:01:44 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/9] mlxsw: Prepare SPAN API for upcoming changes
Date:   Thu, 30 Apr 2020 20:01:07 +0300
Message-Id: <20200430170116.4081677-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Switched port analyzer (SPAN) is used for packet mirroring. Over mlxsw
this is achieved by attaching tc-mirred action to either matchall or
flower classifier.

The current API used to configure SPAN consists of two functions:
mlxsw_sp_span_mirror_add() and mlxsw_sp_span_mirror_del().

These two functions pack a lot of different operations:

* SPAN agent configuration: Determining the egress port and optional
  headers that need to encapsulate the mirrored packet (when mirroring
  to a gretap, for example)

* Egress mirror buffer configuration: Allocating / freeing a buffer when
  port is analyzed (inspected) at egress

* SPAN agent binding: Binding the SPAN agent to a trigger, if any. The
  current triggers are incoming / outgoing packet and they are only used
  for matchall-based mirroring

This non-modular design makes it difficult to extend the API for future
changes, such as new mirror targets (CPU) and new global triggers (early
dropped packets, for example).

Therefore, this patch set gradually adds APIs for above mentioned
operations and then converts the two existing users to use it instead of
the old API. No functional changes intended. Tested with existing
mirroring selftests.

Patch set overview:

Patches #1-#5 gradually add the new API
Patches #6-#8 convert existing users to use the new API
Patch #9 removes the old API

Ido Schimmel (9):
  mlxsw: spectrum_span: Add APIs to get / put a SPAN agent
  mlxsw: spectrum_span: Add APIs to get / put an analyzed port
  mlxsw: spectrum_span: Rename function
  mlxsw: spectrum_span: Wrap buffer change in a function
  mlxsw: spectrum_span: Add APIs to bind / unbind a SPAN agent
  mlxsw: spectrum: Convert matchall-based mirroring to new SPAN API
  mlxsw: spectrum_acl: Convert flower-based mirroring to new SPAN API
  mlxsw: spectrum_span: Use new analyzed ports list during speed / MTU
    change
  mlxsw: spectrum_span: Remove old SPAN API

 .../mlxsw/spectrum_acl_flex_actions.c         |  31 +-
 .../mellanox/mlxsw/spectrum_matchall.c        |  52 +-
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 563 ++++++++++++------
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |  47 +-
 4 files changed, 449 insertions(+), 244 deletions(-)

-- 
2.24.1

