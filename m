Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45148F361B
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 18:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389839AbfKGRsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 12:48:01 -0500
Received: from mga03.intel.com ([134.134.136.65]:33466 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389795AbfKGRr6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 12:47:58 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Nov 2019 09:47:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,278,1569308400"; 
   d="scan'208";a="353858419"
Received: from unknown (HELO VM.jf.intel.com) ([10.78.3.78])
  by orsmga004.jf.intel.com with ESMTP; 07 Nov 2019 09:47:55 -0800
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, u9012063@gmail.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH bpf-next 5/5] xsk: extend documentation for Rx|Tx-only sockets and shared umems
Date:   Thu,  7 Nov 2019 18:47:40 +0100
Message-Id: <1573148860-30254-6-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
References: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add more documentation about the new Rx-only and Tx-only sockets in
libbpf and also how libbpf can now support shared umems. Also found
two pieces that could be improved in the text, that got fixed in this
commit.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 Documentation/networking/af_xdp.rst | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/af_xdp.rst b/Documentation/networking/af_xdp.rst
index 7a4caaa..5bc55a4 100644
--- a/Documentation/networking/af_xdp.rst
+++ b/Documentation/networking/af_xdp.rst
@@ -295,7 +295,7 @@ round-robin example of distributing packets is shown below:
    {
 	rr = (rr + 1) & (MAX_SOCKS - 1);
 
-	return bpf_redirect_map(&xsks_map, rr, 0);
+	return bpf_redirect_map(&xsks_map, rr, XDP_DROP);
    }
 
 Note, that since there is only a single set of FILL and COMPLETION
@@ -304,6 +304,12 @@ to make sure that multiple processes or threads do not use these rings
 concurrently. There are no synchronization primitives in the
 libbpf code that protects multiple users at this point in time.
 
+Libbpf uses this mode if you create more than one socket tied to the
+same umem. However, note that you need to supply the
+XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD libbpf_flag with the
+xsk_socket__create calls and load your own XDP program as there is no
+built in one in libbpf that will route the traffic for you.
+
 XDP_USE_NEED_WAKEUP bind flag
 -----------------------------
 
@@ -355,10 +361,22 @@ to set the size of at least one of the RX and TX rings. If you set
 both, you will be able to both receive and send traffic from your
 application, but if you only want to do one of them, you can save
 resources by only setting up one of them. Both the FILL ring and the
-COMPLETION ring are mandatory if you have a UMEM tied to your socket,
-which is the normal case. But if the XDP_SHARED_UMEM flag is used, any
-socket after the first one does not have a UMEM and should in that
-case not have any FILL or COMPLETION rings created.
+COMPLETION ring are mandatory as you need to have a UMEM tied to your
+socket. But if the XDP_SHARED_UMEM flag is used, any socket after the
+first one does not have a UMEM and should in that case not have any
+FILL or COMPLETION rings created as the ones from the shared umem will
+be used. Note, that the rings are single-producer single-consumer, so
+do not try to access them from multiple processes at the same
+time. See the XDP_SHARED_UMEM section.
+
+In libbpf, you can create Rx-only and Tx-only sockets by supplying
+NULL to the rx and tx arguments, respectively, to the
+xsk_socket__create function.
+
+If you create a Tx-only socket, we recommend that you do not put any
+packets on the fill ring. If you do this, drivers might think you are
+going to receive something when you in fact will not, and this can
+negatively impact performance.
 
 XDP_UMEM_REG setsockopt
 -----------------------
-- 
2.7.4

