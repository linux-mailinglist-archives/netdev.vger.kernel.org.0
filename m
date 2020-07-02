Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7588B212336
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 14:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbgGBMUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 08:20:19 -0400
Received: from mga12.intel.com ([192.55.52.136]:6897 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728921AbgGBMUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 08:20:17 -0400
IronPort-SDR: xtOkRQasXUGkBOYeRY9lm13dDVu13pD3Mk6K0YTHRWTIkAB+r2io25NbHRrDgx7DNFFoGtbJur
 5Q6eIInuMWIQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="126486174"
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="126486174"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 05:20:17 -0700
IronPort-SDR: 42O+LHzk2ACppVGu7nE6BVAPwrjiev36xpHwFn7e3KqP/SEYvf9c4uFHa7Oh6h1xdP9NMxcdNx
 GlM9efUiNMeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="425933488"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.39.242])
  by orsmga004.jf.intel.com with ESMTP; 02 Jul 2020 05:20:14 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        cristian.dumitrescu@intel.com
Subject: [PATCH bpf-next 14/14] xsk: documentation for XDP_SHARED_UMEM between queues and netdevs
Date:   Thu,  2 Jul 2020 14:19:13 +0200
Message-Id: <1593692353-15102-15-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
References: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for the XDP_SHARED_UMEM feature when a UMEM is
shared between different queues and/or netdevs.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 Documentation/networking/af_xdp.rst | 68 +++++++++++++++++++++++++++++++------
 1 file changed, 58 insertions(+), 10 deletions(-)

diff --git a/Documentation/networking/af_xdp.rst b/Documentation/networking/af_xdp.rst
index 5bc55a4..2ccc564 100644
--- a/Documentation/networking/af_xdp.rst
+++ b/Documentation/networking/af_xdp.rst
@@ -258,14 +258,21 @@ socket into zero-copy mode or fail.
 XDP_SHARED_UMEM bind flag
 -------------------------
 
-This flag enables you to bind multiple sockets to the same UMEM, but
-only if they share the same queue id. In this mode, each socket has
-their own RX and TX rings, but the UMEM (tied to the fist socket
-created) only has a single FILL ring and a single COMPLETION
-ring. To use this mode, create the first socket and bind it in the normal
-way. Create a second socket and create an RX and a TX ring, or at
-least one of them, but no FILL or COMPLETION rings as the ones from
-the first socket will be used. In the bind call, set he
+This flag enables you to bind multiple sockets to the same UMEM. It
+works on the same queue id, between queue ids and between
+netdevs/devices. In this mode, each socket has their own RX and TX
+rings as usual, but you are going to have one or more FILL and
+COMPLETION ring pairs. You have to create one of these pairs per
+unique netdev and queue id tuple that you bind to.
+
+Starting with the case were we would like to share a UMEM between
+sockets bound to the same netdev and queue id. The UMEM (tied to the
+fist socket created) will only have a single FILL ring and a single
+COMPLETION ring as there is only on unique netdev,queue_id tuple that
+we have bound to. To use this mode, create the first socket and bind
+it in the normal way. Create a second socket and create an RX and a TX
+ring, or at least one of them, but no FILL or COMPLETION rings as the
+ones from the first socket will be used. In the bind call, set he
 XDP_SHARED_UMEM option and provide the initial socket's fd in the
 sxdp_shared_umem_fd field. You can attach an arbitrary number of extra
 sockets this way.
@@ -305,11 +312,41 @@ concurrently. There are no synchronization primitives in the
 libbpf code that protects multiple users at this point in time.
 
 Libbpf uses this mode if you create more than one socket tied to the
-same umem. However, note that you need to supply the
+same UMEM. However, note that you need to supply the
 XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD libbpf_flag with the
 xsk_socket__create calls and load your own XDP program as there is no
 built in one in libbpf that will route the traffic for you.
 
+The second case is when you share a UMEM between sockets that are
+bound to different queue ids and/or netdevs. In this case you have to
+create one FILL ring and one COMPLETION ring for each unique
+netdev,queue_id pair. Let us say you want to create two sockets bound
+to two different queue ids on the same netdev. Create the first socket
+and bind it in the normal way. Create a second socket and create an RX
+and a TX ring, or at least one of them, and then one FILL and
+COMPLETION ring for this socket. Then in the bind call, set he
+XDP_SHARED_UMEM option and provide the initial socket's fd in the
+sxdp_shared_umem_fd field as you registered the UMEM on that
+socket. These two sockets will now share one and the same UMEM.
+
+There is no need to supply an XDP program like the one in the previous
+case where sockets were bound to the same queue id and
+device. Instead, use the NIC's packet steering capabilities to steer
+the packets to the right queue. In the previous example, there is only
+one queue shared among sockets, so the NIC cannot do this steering. It
+can only steer between queues.
+
+In libbpf, you need to use the xsk_socket__create_shared() API as it
+takes a reference to a FILL ring and a COMPLETION ring that will be
+created for you and bound to the shared UMEM. You can use this
+function for all the sockets you create, or you can use it for the
+second and following ones and use xsk_socket__create() for the first
+one. Both methods yield the same result.
+
+Note that a UMEM can be shared between sockets on the same queue id
+and device, as well as between queues on the same device and between
+devices at the same time.
+
 XDP_USE_NEED_WAKEUP bind flag
 -----------------------------
 
@@ -364,7 +401,7 @@ resources by only setting up one of them. Both the FILL ring and the
 COMPLETION ring are mandatory as you need to have a UMEM tied to your
 socket. But if the XDP_SHARED_UMEM flag is used, any socket after the
 first one does not have a UMEM and should in that case not have any
-FILL or COMPLETION rings created as the ones from the shared umem will
+FILL or COMPLETION rings created as the ones from the shared UMEM will
 be used. Note, that the rings are single-producer single-consumer, so
 do not try to access them from multiple processes at the same
 time. See the XDP_SHARED_UMEM section.
@@ -567,6 +604,17 @@ A: The short answer is no, that is not supported at the moment. The
    switch, or other distribution mechanism, in your NIC to direct
    traffic to the correct queue id and socket.
 
+Q: My packets are sometimes corrupted. What is wrong?
+
+A: Care has to be taken not to feed the same buffer in the UMEM into
+   more than one ring at the same time. If you for example feed the
+   same buffer into the FILL ring and the TX ring at the same time, the
+   NIC might receive data into the buffer at the same time it is
+   sending it. This will cause some packets to become corrupted. Same
+   thing goes for feeding the same buffer into the FILL rings
+   belonging to different queue ids or netdevs bound with the
+   XDP_SHARED_UMEM flag.
+
 Credits
 =======
 
-- 
2.7.4

