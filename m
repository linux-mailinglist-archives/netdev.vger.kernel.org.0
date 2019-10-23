Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6278AE11E8
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 08:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733173AbfJWGFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 02:05:38 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59963 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731531AbfJWGFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 02:05:37 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 80FC822050;
        Wed, 23 Oct 2019 02:05:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 23 Oct 2019 02:05:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=5Slqa9CyiOp1VQj7n
        R3k9rxP5Smyx5fW0cy4NzbPWR8=; b=C0SnqW5qVQJnWXLXnzb+IsvxBYN9jSjz1
        2fKK1A5JojZbsRqLp8dfflA+FpI4GggpJY0+LplGZ2RjWaxTha/qQvNat6EFwzti
        TpJ3yOJnaV5S4KjMu0exE76cwiJjHG0tWhIBlycE2dyeaxUJWaY9UKkGDBwG+zBZ
        8srMLEE07E3KCCP8rgf/CodUNgsL30QmECYWlH8s9YkshY0MavHoF5TnvL9vRQNT
        3pKBsuyLDG8tz8dsOzOJby+x9J2OC8afb/7Ch6lQO8Hk7uIGEtlIQ28wdDwI7hUO
        wSD+ic7K+iQywIvLPveK/jbhW7T0GQ7bFMYaqYYPw0aSfEcuj65bw==
X-ME-Sender: <xms:sO2vXeqeo35SavV5MMqqXLlFGlhIVuNe_PuNzqwWStGavHdiqvPTBA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrkeekgddutddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:sO2vXa1THlGB1l94ah0KA6qDrDKdR8tKN783rnxnHAZKJG-KhDZb-w>
    <xmx:sO2vXeHuMthiATZqjw6sQP9_04Ba5Aat6k8BO-WGZcI8c_XAxD3hEA>
    <xmx:sO2vXWVoNz5njrhf94BZmvSf7k2L_J0YWD-jhW_jFB3f8zZtVLfWsw>
    <xmx:sO2vXek9H__sCpyM62ug6esii9NRcK7fZ5Dw5Htf9IFdn1G36j6GaA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id C0E668005B;
        Wed, 23 Oct 2019 02:05:34 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        jiri@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/2] mlxsw: Update main pool computation and pool size limits
Date:   Wed, 23 Oct 2019 09:04:58 +0300
Message-Id: <20191023060500.19709-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Petr says:

In Spectrum ASICs, the shared buffer is an area of memory where packets are
kept until they can be transmitted. There are two resources associated with
shared buffer size: cap_total_buffer_size and cap_guaranteed_shared_buffer.
So far, mlxsw has been using the former as a limit when validating shared
buffer pool size configuration. However, the total size also includes
headrooms and reserved space, which really cannot be used for shared buffer
pools. Patch #1 mends this and has mlxsw use the guaranteed size.

To configure default pool sizes, mlxsw has historically hard-coded one or
two smallish pools, and one "main" pool that took most of the shared buffer
(that would be pool 0 on ingress and pool 4 on egress). During the
development of Spectrum-2, it became clear that the shared buffer size
keeps shrinking as bugs are identified and worked around. In order to
prevent having to tweak the size of pools 0 and 4 to catch up with updates
to values reported by the FW, patch #2 changes the way these pools are set.
Instead of hard-coding a fixed value, the main pool now takes whatever is
left from the guaranteed size after the smaller pool(s) are taken into
account.

Petr Machata (2):
  mlxsw: spectrum: Use guaranteed buffer size as pool size limit
  mlxsw: spectrum_buffers: Calculate the size of the main pool

 .../net/ethernet/mellanox/mlxsw/resources.h   |  4 +-
 .../mellanox/mlxsw/spectrum_buffers.c         | 53 +++++++++++++------
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  |  3 +-
 3 files changed, 42 insertions(+), 18 deletions(-)

-- 
2.21.0

