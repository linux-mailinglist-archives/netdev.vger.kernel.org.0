Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D34E34AACD
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 16:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhCZPC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 11:02:29 -0400
Received: from mga14.intel.com ([192.55.52.115]:38766 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230192AbhCZPBp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 11:01:45 -0400
IronPort-SDR: SAN3X41/RxT88hM2qIQWiIzYTjArsc5NSbQRJsYOmWN7gd6UIRBcU5znEoczDa0172887SxUEr
 HNYcK6zVqruw==
X-IronPort-AV: E=McAfee;i="6000,8403,9935"; a="190602895"
X-IronPort-AV: E=Sophos;i="5.81,280,1610438400"; 
   d="scan'208";a="190602895"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 08:01:18 -0700
IronPort-SDR: VGt0BjCiYwk6pIxPjrEw0FXRD1tD+0FbT2hQcSvdMUe9CdC6XE3EGN/1RnE0jrLLWi6YKgQlEg
 OElvMW30+BEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,280,1610438400"; 
   d="scan'208";a="382668283"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga007.fm.intel.com with ESMTP; 26 Mar 2021 08:01:16 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        magnus.karlsson@gmail.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH v2 bpf 1/3] libbpf: ensure umem pointer is non-NULL before dereferencing
Date:   Fri, 26 Mar 2021 14:29:44 +0000
Message-Id: <20210326142946.5263-2-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210326142946.5263-1-ciara.loftus@intel.com>
References: <20210326142946.5263-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Calls to xsk_socket__create dereference the umem to access the
fill_save and comp_save pointers. Make sure the umem is non-NULL
before doing this.

Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 tools/lib/bpf/xsk.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 526fc35c0b23..443b0cfb45e8 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -1019,6 +1019,9 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 		       struct xsk_ring_cons *rx, struct xsk_ring_prod *tx,
 		       const struct xsk_socket_config *usr_config)
 {
+	if (!umem)
+		return -EFAULT;
+
 	return xsk_socket__create_shared(xsk_ptr, ifname, queue_id, umem,
 					 rx, tx, umem->fill_save,
 					 umem->comp_save, usr_config);
-- 
2.17.1

