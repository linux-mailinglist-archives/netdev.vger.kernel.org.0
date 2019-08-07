Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12CAF84984
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 12:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbfHGKbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 06:31:39 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:34471 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726564AbfHGKbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 06:31:39 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id D2BD212FE;
        Wed,  7 Aug 2019 06:31:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 07 Aug 2019 06:31:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=624m75J42PaR9MI1k
        IYMldtqz2ct/x4zo/oUsNfHaJM=; b=fFVSbvTOKi0V6npTmmAyFe3Uzcm10G8gl
        VEErAj7vmIpwpQi6QozDoshYLbAZD3BGE04T5SOSXb0sJ01H+KSi4p/3uXO+1fT7
        c0u07+WlGQTNfMQlZoJQ6OFA7lgVqqOvH1jQWZCDmc2Gl0f1ctpIgnoVEeL7gqN9
        hicRpBFmGIjP8foOHxgETCUkT5YC5yFqAR3uTuMcFjLl1zInmgSaOc53rViF8w8m
        kFcLt752WMsNhkMyybFK0v16Mq7yn7BRBmrS/EpYnbRKez8ek9fYJnEzJC72EbIl
        JHh+FbG19Rhy7zx8wUv8FFDTyIZigXa/txp36QKhW83rcaMbRC2tQ==
X-ME-Sender: <xms:iKhKXYgrx9TVeaKI8EF-WwhCHdmb595FmiMus8AuzwIvECc6Psp8WA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudduvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuffhomhgrihhnpehgihhthhhusgdrtghomhdpohiilhgrsghsrdhorh
    hgnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhho
    mhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:iKhKXQG0sinpLvfAdCBpAMpfdtfrghyRZsQvZY-zdaby-dTIKiG3aw>
    <xmx:iKhKXWRISLGO_3JEuJWv16sYp5Op4a9Qq8ECq18PJ6HnFoCvKsv2Eg>
    <xmx:iKhKXVzI6VU_QJRHoR0GCvam0QPpof7qcGfofc29aYQe1qtaRaiUpA>
    <xmx:iahKXeqHcenN6jczV7KlymC-gAO6GJIA23cKUijy_I7YfJuds4AVwg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id BA2B6380090;
        Wed,  7 Aug 2019 06:31:33 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 00/10] drop_monitor: Capture dropped packets and metadata
Date:   Wed,  7 Aug 2019 13:30:49 +0300
Message-Id: <20190807103059.15270-1-idosch@idosch.org>
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

Changes since RFC [6]:
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
[2] https://gist.github.com/idosch/166b64384577174230fd2523866f6b1c#file-gistfile1-txt
[3] https://github.com/idosch/wireshark/tree/drop-monitor-v1
[4] https://gist.github.com/idosch/166b64384577174230fd2523866f6b1c#file-gistfile2-txt
[5] https://github.com/the-tcpdump-group/libpcap/blob/master/pcap-netfilter-linux.c
[6] https://patchwork.ozlabs.org/cover/1135226/

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

 include/uapi/linux/net_dropmon.h |  50 +++
 net/core/drop_monitor.c          | 594 +++++++++++++++++++++++++++++--
 2 files changed, 607 insertions(+), 37 deletions(-)

-- 
2.21.0

