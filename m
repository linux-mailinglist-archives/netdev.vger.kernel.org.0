Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F372337282
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 13:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbhCKMZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 07:25:14 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58977 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232709AbhCKMZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 07:25:06 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 7D2B45C008B;
        Thu, 11 Mar 2021 07:25:05 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 11 Mar 2021 07:25:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=uyoOmZcEbjVxODH+1
        WEQaBWpXhhNJG/3Bk2DulHQ/9w=; b=XuhwzMiboxkvIVetCfN0t/tKdlphR6DFO
        VODRPHKwm+uDkVh21pMzhtgsndx8KEZgFO1uvDK69TycFHoNjyyA4HQXMCvS3Clr
        PzNPNGf2pHY2PuwwiT9l5wwTxTzeraaW23ntK0Q0jvogcy/aiCtjRWQpUmFujoXI
        j3uKQazD2i8LxfPv5HxKqUg9sam/LsTf35AL294nLUqYyu5851xtiq02d++G1jIq
        5wvp+ijSJd9s07PbbfoFpf/xtr1rOdjYOos7kznyxLFj9teZ4tZnNjj4jhOKmPu0
        b33WB4bqFqQD3f3/x8U0KKqq4A4iFAjePYpc4csPs4dIUClAngSWQ==
X-ME-Sender: <xms:IQxKYE9E-ut7ydnjrdr7GKsknApo86wFnuXe8I78rY6TaVLi9zMMew>
    <xme:IQxKYMsruBWe_Q6Kpe8HJRttdkz5EMYC70TIjpEk9MTVvn1Cx3OTWWsfHyZRZVeWj
    EoDWEpDpimR2bk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehfedrgeegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:IQxKYKBfRxe31DICgFgry2ez4FWvR3-E5Rl2ZErfzMrYth6Zt3jzqQ>
    <xmx:IQxKYEfjsDWOFk-O4r3sjIAy2-WPKI8UVWQW9AAIa0CAH4J2asMmjA>
    <xmx:IQxKYJNTOhxoie-sCdrYA4VjL9gIkmrJk4fj5rFeuaYXN9LF_D6W_w>
    <xmx:IQxKYCYgd_sWvbzd7oNIHfD0gRn-5zN4HREZTWBmsrM_STu_wZSLIg>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 893E21080057;
        Thu, 11 Mar 2021 07:25:03 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/6] mlxsw: Implement sampling using mirroring
Date:   Thu, 11 Mar 2021 14:24:10 +0200
Message-Id: <20210311122416.2620300-1-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

So far, sampling was implemented using a dedicated sampling mechanism
that is available on all Spectrum ASICs. Spectrum-2 and later ASICs
support sampling by mirroring packets to the CPU port with probability.
This method has a couple of advantages compared to the legacy method:

* Extra metadata per-packet: Egress port, egress traffic class, traffic
  class occupancy and end-to-end latency
* Ability to sample packets on egress / per-flow as opposed to only
  ingress

This series should not result in any user-visible changes and its aim is
to convert Spectrum-2 and later ASICs to perform sampling by mirroring
to the CPU port with probability. Future submissions will expose the
additional metadata and enable sampling using more triggers (e.g.,
egress).

Series overview:

Patches #1-#3 extend the SPAN (mirroring) module to accept new
parameters required for sampling. See individual commit messages for
detailed explanation.

Patch #4-#5 split sampling support between Spectrum-1 and later ASIC while
still using the legacy method for all ASIC generations.

Patch #6 converts Spectrum-2 and later ASICs to perform sampling by
mirroring to the CPU port with probability.

Ido Schimmel (6):
  mlxsw: spectrum_span: Add SPAN session identifier support
  mlxsw: reg: Extend mirroring registers with probability rate field
  mlxsw: spectrum_span: Add SPAN probability rate support
  mlxsw: spectrum_matchall: Split sampling support between ASICs
  mlxsw: spectrum_trap: Split sampling traps between ASICs
  mlxsw: spectrum_matchall: Implement sampling using mirroring

 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 17 +++-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  3 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    | 12 +++
 .../mellanox/mlxsw/spectrum_matchall.c        | 86 ++++++++++++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  |  5 +-
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 21 ++++-
 .../ethernet/mellanox/mlxsw/spectrum_span.h   | 16 ++++
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 43 +++++++---
 8 files changed, 181 insertions(+), 22 deletions(-)

-- 
2.29.2

