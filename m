Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20A8E89028
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 09:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfHKHgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 03:36:45 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:43855 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725821AbfHKHgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 03:36:45 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5019F1942;
        Sun, 11 Aug 2019 03:36:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 11 Aug 2019 03:36:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=0DDFD1tzWtQHFOZzG
        iKJnwmYq17I9yiZi9RhucjSB7Y=; b=UDPo2S21tf2licRT2Ey0Ka6vof7R5OuwN
        jsMMB5sNSkWUwJGJiTs7uXWxL0VpJF7Amcp3qr3ZSmVR/bXd8c0vRD1Er3uHkdZH
        biXvzTQR69usif8fVf7ZLlWpq+ipHMysogGyiqQYNKvRJrMLmhTBJkkYaeSNuknM
        bjkLPPs/M02ovx/h2FHPVjDyB5wfH3RF1Q0MQ6sinRKTYO/+/PNs1bgKduqRdQvd
        PSeiH0tfzJ+KVUarf80OYsMV32DWaiRPZtBzdpuwvuePhsCiDvV+FdCgzCTN5YDF
        aPsP6Trtx2s2QqGKdQ/tkANtQwOg6a5pL1TqxywsPhTOXrHn8fzdg==
X-ME-Sender: <xms:i8VPXRrcrX7vYkW_ybKUIdfzaDaWCZu5Qox2qdChP5uKRJBnrgfw-g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvuddgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuffhomhgrihhnpehgihhthhhusgdrtghomhdpohiilhgrsghsrdhorh
    hgnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhho
    mhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:i8VPXSkY6StNtvomi6FUhSS1oRBu1i29TSsnD6rHClKccxqSJbhKZw>
    <xmx:i8VPXaSSaiUunyQ_qMpjACEn2DDtKcnHzGtx94UmC3XAdsbSiIZszw>
    <xmx:i8VPXQY4M3Zix1rdZULnAY3H1SRe2pu3Lpiqufq5goDl6dM0uWl9kQ>
    <xmx:jMVPXdEg5SDI5jdGoPQR9hrStfhLsNJVoRrV0UGgCUU54xxPgM3bDw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1156480061;
        Sun, 11 Aug 2019 03:36:40 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 00/10] drop_monitor: Capture dropped packets and metadata
Date:   Sun, 11 Aug 2019 10:35:45 +0300
Message-Id: <20190811073555.27068-1-idosch@idosch.org>
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

A follow-up patchset will integrate drop monitor with devlink and allow
the latter to call into drop monitor to report hardware drops. In the
future, XDP drops can be added as well, thereby making drop monitor the
go-to netlink channel for diagnosing all packet drops.

Example usage with patched dropwatch [1] can be found here [2]. Example
dissection of drop monitor netlink events with patched wireshark [3] can
be found here [4]. I will submit both changes upstream after the kernel
changes are accepted. Another change worth making is adding a dropmon
pseudo interface to libpcap, similar to the nflog interface [5]. This
will allow users to specifically listen on dropmon traffic instead of
capturing all netlink packets via the nlmon netdev.

Patches #1-#5 prepare the code towards the actual changes in later
patches.

Patch #6 adds another mode of operation to drop monitor in which the
dropped packet itself is notified to user space along with metadata.

Patch #7 allows users to truncate reported packets to a specific length,
in case only the headers are of interest. The original length of the
packet is added as metadata to the netlink notification.

Patch #8 allows user to query the current configuration of drop monitor
(e.g., alert mode, truncation length).

Patches #9-#10 allow users to tune the length of the per-CPU skb drop
list according to their needs.

Changes since v1 [6]:
* Add skb protocol as metadata. This allows user space to correctly
  dissect the packet instead of blindly assuming it is an Ethernet
  packet

Changes since RFC [7]:
* Limit the length of the per-CPU skb drop list and make it configurable
* Do not use the hysteresis timer in packet alert mode
* Introduce alert mode operations in a separate patch and only then
  introduce the new alert mode
* Use 'skb->skb_iif' instead of 'skb->dev' because the latter is inside
  a union with 'dev_scratch' and therefore not guaranteed to point to a
  valid netdev
* Return '-EBUSY' instead of '-EOPNOTSUPP' when trying to configure drop
  monitor while it is monitoring
* Did not change schedule_work() in favor of schedule_work_on() as I did
  not observe a change in number of tail drops

[1] https://github.com/idosch/dropwatch/tree/packet-mode
[2] https://gist.github.com/idosch/3d524b887e16bc11b4b19e25c23dcc23#file-gistfile1-txt
[3] https://github.com/idosch/wireshark/tree/drop-monitor-v2
[4] https://gist.github.com/idosch/3d524b887e16bc11b4b19e25c23dcc23#file-gistfile2-txt
[5] https://github.com/the-tcpdump-group/libpcap/blob/master/pcap-netfilter-linux.c
[6] https://patchwork.ozlabs.org/cover/1143443/
[7] https://patchwork.ozlabs.org/cover/1135226/

Ido Schimmel (10):
  drop_monitor: Split tracing enable / disable to different functions
  drop_monitor: Initialize timer and work item upon tracing enable
  drop_monitor: Reset per-CPU data before starting to trace
  drop_monitor: Require CAP_NET_ADMIN for drop monitor configuration
  drop_monitor: Add alert mode operations
  drop_monitor: Add packet alert mode
  drop_monitor: Allow truncation of dropped packets
  drop_monitor: Add a command to query current configuration
  drop_monitor: Make drop queue length configurable
  drop_monitor: Expose tail drop counter

 include/uapi/linux/net_dropmon.h |  51 +++
 net/core/drop_monitor.c          | 599 +++++++++++++++++++++++++++++--
 2 files changed, 613 insertions(+), 37 deletions(-)

-- 
2.21.0

