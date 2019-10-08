Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBBBCF29E
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 08:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730110AbfJHGRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 02:17:00 -0400
Received: from mga04.intel.com ([192.55.52.120]:63837 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729928AbfJHGQ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 02:16:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 23:16:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="187206755"
Received: from arch-p28.jf.intel.com ([10.166.187.31])
  by orsmga008.jf.intel.com with ESMTP; 07 Oct 2019 23:16:55 -0700
From:   Sridhar Samudrala <sridhar.samudrala@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        sridhar.samudrala@intel.com, intel-wired-lan@lists.osuosl.org,
        maciej.fijalkowski@intel.com, tom.herbert@intel.com
Subject: [PATCH bpf-next 3/4] libbpf: handle AF_XDP sockets created with XDP_DIRECT bind flag.
Date:   Mon,  7 Oct 2019 23:16:54 -0700
Message-Id: <1570515415-45593-4-git-send-email-sridhar.samudrala@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1570515415-45593-1-git-send-email-sridhar.samudrala@intel.com>
References: <1570515415-45593-1-git-send-email-sridhar.samudrala@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't allow an AF_XDP socket trying to bind with XDP_DIRECT bind
flag when a normal XDP program is already attached to the device,

Don't attach the default XDP program when AF_XDP socket is created
with XDP_DIRECT bind flag.

Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
---
 tools/lib/bpf/xsk.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index d5f4900e5c54..953b479040cd 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -454,6 +454,9 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
 		return err;
 
 	if (!prog_id) {
+		if (xsk->config.bind_flags & XDP_DIRECT)
+			return 0;
+
 		err = xsk_create_bpf_maps(xsk);
 		if (err)
 			return err;
@@ -464,6 +467,9 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
 			return err;
 		}
 	} else {
+		if (xsk->config.bind_flags & XDP_DIRECT)
+			return -EEXIST;
+
 		xsk->prog_fd = bpf_prog_get_fd_by_id(prog_id);
 		err = xsk_lookup_bpf_maps(xsk);
 		if (err) {
-- 
2.14.5

