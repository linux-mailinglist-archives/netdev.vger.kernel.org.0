Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0903A43CD66
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238120AbhJ0PWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:22:46 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43115 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238106AbhJ0PWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 11:22:44 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 661B05C01B2;
        Wed, 27 Oct 2021 11:20:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 27 Oct 2021 11:20:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=nUL8Wzf14VyBS9AC1
        oW3yc8ME0oGcxc6LdIFDzMRUZA=; b=HUsbW+K3Z6tz+yhTMJBi37t8Zm+khlDyl
        YJB97Ui3wUPRgphTExcRrLDiXNZh/ECqRsabxgagu9uJDESxKi3Si9EvB7wCKRt3
        FgB9uhvMfJz6Sv/2DDYAqQK5ZCQwxkgt3WGyz4z0Uk4+GTYEeUIUOAI8bwY8H+nm
        mzFDwpSr3Spt3HZ02+tbMrXmmxHS+1pH0Yzygzl/vzl6McOnPXo0IFb4ZE3qlfTw
        1i29Vl+5hqe6uy/IpcGMcB82Ok1eCZOnh6r5ghFyDXeahPkX8dSNSNhq5uxN+xQF
        lcRwjF+fHpeLw3tOzZ/gWLm6Bs/xCSU/DrGDAqOPciqPGKiMWwi5g==
X-ME-Sender: <xms:MW55YTQ4krWbWLZlw4cK9d0rzlDF417i4fV4ZQk9zVXk8Uo6IHtaig>
    <xme:MW55YUzCpt0Lw7Tx4k1mv6njz3TKi73vIPS9U6fNmWQ1bOSGWIMS07_zs5aaS21_G
    PFPbvLAOkM8t-Y>
X-ME-Received: <xmr:MW55YY1aATAVylMZy8FjwWiVNWZr_yZrUfmWQORGBJOT2U0huFx_9BBBndcFnEWb19bs2BEnFaimsxFgtlsuuFtMyEPGIPy4PXJSyi6mnDtUtA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdegtddgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:MW55YTCozax4l9FzYVLDsDJnYk3mafeR9YSwwrkQ7s1JpX3Uyw0wJg>
    <xmx:MW55YciAL0EZzrVNZigwKJHeAt0arUB4caX_PIh1hq24h4_4-XWnAA>
    <xmx:MW55YXohNBhsxZUTwv24KU6leOFhgPloQ8nLKONY9a88OAPcZQADdA>
    <xmx:Mm55YUdUr8hTNH8xvHTRNH4R4n57nudotVOlMLNA3p5ohSi9N4OKeA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 11:20:15 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/3] mlxsw: Offload root TBF as port shaper
Date:   Wed, 27 Oct 2021 18:19:58 +0300
Message-Id: <20211027152001.1320496-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Petr says:

Egress configuration in an mlxsw deployment would generally have an ETS
qdisc at root, with a number of bands and a priority dispatch between them.
Some of those bands could then have a RED and/or TBF qdiscs attached.

When TBF is used like this, mlxsw configures shaper on a subgroup, which is
the pair of traffic classes (UC + BUM) corresponding to the band where TBF
is installed. This way it is possible to limit traffic on several bands
(subgroups) independently by configuring several TBF qdiscs, each on a
different band.

It is however not possible to limit traffic flowing through the port as
such. The ASIC supports this through port shapers (as opposed to the
abovementioned subgroup shapers). An obvious way to express this as a user
would be to configure a root TBF qdisc, and then add the whole ETS
hierarchy as its child.

TBF (and RED) can currently be used as a root qdisc. This usage has always
been accepted as a special case, when only one subgroup is configured, and
that is the subgroup that root TBF and RED configure. However it was never
possible to install ETS under that TBF.

In this patchset, this limitation is relaxed. TBF qdisc in root position is
now always offloaded as a port shaper. Such TBF qdisc does not limit
offload of further children. It is thus possible to configure the usual
priority classification through ETS, with RED and/or TBF on individual
bands, all that below a port-level TBF. For example:

    (1) # tc qdisc replace dev swp1 root handle 1: tbf rate 800mbit burst 16kb limit 1M
    (2) # tc qdisc replace dev swp1 parent 1:1 handle 11: ets strict 8 priomap 7 6 5 4 3 2 1 0
    (3) # tc qdisc replace dev swp1 parent 11:1 handle 111: tbf rate 600mbit burst 16kb limit 1M
    (4) # tc qdisc replace dev swp1 parent 11:2 handle 112: tbf rate 600mbit burst 16kb limit 1M

Here, (1) configures a 800-Mbps port shaper, (2) adds an ETS element with 8
strictly-prioritized bands, and (3) and (4) configure two more shapers,
each 600 Mbps, one under 11:1 (band 0, TCs 7 and 15), one under 11:2 (band
1, TCs 6 and 14). This way, traffic on bands 0 and 1 are each independently
capped at 600 Mbps, and at the same time, traffic through the port as a
whole is capped at 800 Mbps.

In patch #1, TBF is permitted as root qdisc, under which the usual qdisc
tree can be installed.

In patch #2, the qdisc offloadability selftest is extended to cover the
root TBF as well.

Patch #3 then tests that the offloaded TBF shapes as expected.

Petr Machata (3):
  mlxsw: spectrum_qdisc: Offload root TBF as port shaper
  selftests: mlxsw: Test offloadability of root TBF
  selftests: mlxsw: Test port shaper

 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 55 +++++++++++++------
 .../drivers/net/mlxsw/sch_offload.sh          | 14 +++++
 .../net/forwarding/sch_tbf_etsprio.sh         | 28 ++++++++++
 3 files changed, 79 insertions(+), 18 deletions(-)

-- 
2.31.1

