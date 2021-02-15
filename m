Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4424331BEC3
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 17:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbhBOQRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 11:17:48 -0500
Received: from mga06.intel.com ([134.134.136.31]:36008 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232528AbhBOP6c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 10:58:32 -0500
IronPort-SDR: caZ85ASrofYgF81HEI+Vplfykc+MtWSBtZBUSuGsB1q3pTqxYr0KIWKv2OXrM/4CUfHkV+IIlF
 HX5M9/BnDjMQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="244189540"
X-IronPort-AV: E=Sophos;i="5.81,181,1610438400"; 
   d="scan'208";a="244189540"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 07:56:40 -0800
IronPort-SDR: HBCudpXa5BnVTHiL71rtWFrl9xJNVJZ2FQy/NFTtDY+ggRMDGN3WHBVdbq91HsAzU7HV4STST+
 fPpHjcZt5/aA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,181,1610438400"; 
   d="scan'208";a="383413536"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga008.fm.intel.com with ESMTP; 15 Feb 2021 07:56:38 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     andrii@kernel.org, toke@redhat.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, ciara.loftus@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 2/3] libbpf: clear map_info before each bpf_obj_get_info_by_fd
Date:   Mon, 15 Feb 2021 16:46:37 +0100
Message-Id: <20210215154638.4627-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xsk_lookup_bpf_maps, based on prog_fd, looks whether current prog has a
reference to XSKMAP. BPF prog can include insns that work on various BPF
maps and this is covered by iterating through map_ids.

The bpf_map_info that is passed to bpf_obj_get_info_by_fd for filling
needs to be cleared at each iteration, so that it doesn't any outdated
fields and that is currently missing in the function of interest.

To fix that, zero-init map_info via memset before each
bpf_obj_get_info_by_fd call.

Also, since the area of this code is touched, in general strcmp is
considered harmful, so let's convert it to strncmp and provide the
length of the array name that we're looking for.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/lib/bpf/xsk.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 5911868efa43..fb259c0bba93 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -616,6 +616,7 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
 	__u32 i, *map_ids, num_maps, prog_len = sizeof(struct bpf_prog_info);
 	__u32 map_len = sizeof(struct bpf_map_info);
 	struct bpf_prog_info prog_info = {};
+	const char *map_name = "xsks_map";
 	struct xsk_ctx *ctx = xsk->ctx;
 	struct bpf_map_info map_info;
 	int fd, err;
@@ -645,13 +646,14 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
 		if (fd < 0)
 			continue;
 
+		memset(&map_info, 0, map_len);
 		err = bpf_obj_get_info_by_fd(fd, &map_info, &map_len);
 		if (err) {
 			close(fd);
 			continue;
 		}
 
-		if (!strcmp(map_info.name, "xsks_map")) {
+		if (!strncmp(map_info.name, map_name, strlen(map_name))) {
 			ctx->xsks_map_fd = fd;
 			continue;
 		}
-- 
2.20.1

