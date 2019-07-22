Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62795708A9
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 20:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbfGVSd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 14:33:26 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:37563 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726770AbfGVSdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 14:33:25 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id D9E5320EF;
        Mon, 22 Jul 2019 14:33:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 22 Jul 2019 14:33:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=gmXcVynBkBHEmlw3y
        3oxGrZ9PYCsMHGzmBEWqhQN5HY=; b=J1NOVJuklECbdmp9JTETFepgfiVkcSKco
        vtZacp4w52zpghyMMVPIVj923Py9f6PLzxmrMGjWPDqF+hVW14uD0PvMyooQKGNZ
        s6/Z7iU7XQpMVoMNNvjuYIWz7WiUOd0Vm8DQafxr1myKqiUbldmNVUwP7cpzunwc
        V0+AFXG3ap3zoes+9OB3yhq0ResHqqELslU37r3KZ6WAfw16PZ7wq/L09iEp7R00
        e8gd5c7dxRA8+Bv25Dbw3DSC5qGpAsnVJ6EjBMa/2QId8cB3JVDbEsfw/nNJSGn8
        pnRCK3xftpsYUJeAJLqQ+nooHTK9D4OBV0/pws4lD2pdV7mQ4ziTA==
X-ME-Sender: <xms:bwE2XWleqyLYjLu71gzP4wCdwdGG9nshJTnezECKhpUXMFflI1ddAg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeeggdduvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuffhomhgrihhnpehgihhthhhusgdrtghomhenucfkphepudelfedrge
    ejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihgu
    ohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:bwE2XT4YUBVzevQSz5StyiXUx3YGRLDkXLEmnn62LHeD0WJgCH_hSg>
    <xmx:bwE2XX5nk6b4O0pe9-i9Da0Dfj7RyyjwY1O2-PxW1FB9aIlChbubpw>
    <xmx:bwE2XSvcjDeCeMDjz4_fUE71sTkUpJfMFXNv7JuYJmH9KXMuKnBAcg>
    <xmx:cQE2XWdddLW-aTFXOX6uDnenIro7F_H3mmB2sSr4sT_EPKkrdq4RaA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 11E5F80060;
        Mon, 22 Jul 2019 14:33:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        jakub.kicinski@netronome.com, toke@redhat.com, andy@greyhouse.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 00/12] drop_monitor: Capture dropped packets and metadata
Date:   Mon, 22 Jul 2019 21:31:22 +0300
Message-Id: <20190722183134.14516-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

So far drop monitor supported only one mode of operation in which a
summary of recent packet drops is periodically sent to user space as a
netlink event. The event only includes the drop location (program
counter) and number of drops in the last interval.

While this mode of operation allows one to understand if the system is
dropping packets, it is not sufficient if a more detailed analysis is
required. Both the packet itself and related metadata are missing.

This patchset extends drop monitor with another mode of operation where
the packet - potentially truncated - and metadata (e.g., drop location,
timestamp, netdev) are sent to user space as a netlink event. Thanks to
the extensible nature of netlink, more metadata can be added in the
future.

To avoid performing expensive operations in the context in which
kfree_skb() is called, the dropped skbs are cloned and queued on per-CPU
skb drop list. The list is then processed in process context (using a
workqueue), where the netlink messages are allocated, prepared and
finally sent to user space.

As a follow-up, I plan to integrate drop monitor with devlink and allow
the latter to call into drop monitor to report hardware drops. In the
future, XDP drops can be added as well, thereby making drop monitor the
go-to netlink channel for diagnosing all packet drops.

Example usage with patched dropwatch [1] can be found here [2]. Example
dissection of drop monitor netlink events with patched wireshark [3] can
be found here [4]. I will submit both changes upstream after the kernel
changes are accepted.

Patches #1-#6 are just cleanups with no functional changes intended.

Patches #7-#8 perform small refactoring before the actual changes are
introduced in the last four patches.

[1] https://github.com/idosch/dropwatch/tree/packet-mode
[2] https://gist.github.com/idosch/7391b77da0b16182406189561fdfa1ef#file-gistfile1-txt
[3] https://github.com/idosch/wireshark/tree/drop-monitor
[4] https://gist.github.com/idosch/7391b77da0b16182406189561fdfa1ef#file-gistfile2-txt

Ido Schimmel (12):
  drop_monitor: Use correct error code
  drop_monitor: Rename and document scope of mutex
  drop_monitor: Document scope of spinlock
  drop_monitor: Avoid multiple blank lines
  drop_monitor: Add extack support
  drop_monitor: Use pre_doit / post_doit hooks
  drop_monitor: Split tracing enable / disable to different functions
  drop_monitor: Initialize timer and work item upon tracing enable
  drop_monitor: Require CAP_NET_ADMIN for drop monitor configuration
  drop_monitor: Add packet alert mode
  drop_monitor: Allow truncation of dropped packets
  drop_monitor: Add a command to query current configuration

 include/uapi/linux/net_dropmon.h |  33 +++
 net/core/drop_monitor.c          | 492 ++++++++++++++++++++++++++++---
 2 files changed, 478 insertions(+), 47 deletions(-)

-- 
2.21.0

