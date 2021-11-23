Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D6845A910
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239635AbhKWQqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:46:07 -0500
Received: from mga18.intel.com ([134.134.136.126]:26963 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239064AbhKWQp2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:45:28 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="221937576"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="221937576"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 08:42:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="538313128"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 23 Nov 2021 08:42:10 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANGf4X4016784;
        Tue, 23 Nov 2021 16:42:07 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v2 net-next 26/26] Documentation: reflect generic XDP statistics
Date:   Tue, 23 Nov 2021 17:39:55 +0100
Message-Id: <20211123163955.154512-27-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123163955.154512-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a couple of hints on how to retrieve and implement generic XDP
statistics for drivers/interfaces. Mention that it's unwanted to
include related XDP counters in driver-defined Ethtool stats.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 Documentation/networking/statistics.rst | 33 +++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/Documentation/networking/statistics.rst b/Documentation/networking/statistics.rst
index c9aeb70dafa2..ec5d14f279e1 100644
--- a/Documentation/networking/statistics.rst
+++ b/Documentation/networking/statistics.rst
@@ -41,6 +41,29 @@ If `-s` is specified once the detailed errors won't be shown.
 
 `ip` supports JSON formatting via the `-j` option.
 
+For some interfaces, standard XDP statistics are available.
+It can be accessed the same ways, e.g. `ip`::
+
+  $ ip link xdpstats dev enp178s0
+  16: enp178s0:
+  xdp-channel0-rx_xdp_packets: 0
+  xdp-channel0-rx_xdp_bytes: 1
+  xdp-channel0-rx_xdp_errors: 2
+  xdp-channel0-rx_xdp_aborted: 3
+  xdp-channel0-rx_xdp_drop: 4
+  xdp-channel0-rx_xdp_invalid: 5
+  xdp-channel0-rx_xdp_pass: 6
+  xdp-channel0-rx_xdp_redirect: 7
+  xdp-channel0-rx_xdp_redirect_errors: 8
+  xdp-channel0-rx_xdp_tx: 9
+  xdp-channel0-rx_xdp_tx_errors: 10
+  xdp-channel0-tx_xdp_xmit_packets: 11
+  xdp-channel0-tx_xdp_xmit_bytes: 12
+  xdp-channel0-tx_xdp_xmit_errors: 13
+  xdp-channel0-tx_xdp_xmit_full: 14
+
+Those are usually per-channel. JSON is also supported via the `-j` opt.
+
 Protocol-specific statistics
 ----------------------------
 
@@ -147,6 +170,8 @@ Statistics are reported both in the responses to link information
 requests (`RTM_GETLINK`) and statistic requests (`RTM_GETSTATS`,
 when `IFLA_STATS_LINK_64` bit is set in the `.filter_mask` of the request).
 
+`IFLA_STATS_LINK_XDP_XSTATS` bit is used to retrieve standard XDP statstics.
+
 ethtool
 -------
 
@@ -206,6 +231,14 @@ Retrieving ethtool statistics is a multi-syscall process, drivers are advised
 to keep the number of statistics constant to avoid race conditions with
 user space trying to read them.
 
+It is up to the developers whether to implement XDP statistics or not due to
+possible performance hits. If so, it is encouraged to export it using generic
+XDP statistics infrastructure, not driver-defined Ethtool stats.
+It can be achieve by implementing `.ndo_get_xdp_stats` and, optionally but
+preferred, `.ndo_get_xdp_stats_nch`. There are several common helper structures
+and functions in `include/net/xdp.h` to make this simpler and keep the code
+compact.
+
 Statistics must persist across routine operations like bringing the interface
 down and up.
 
-- 
2.33.1

