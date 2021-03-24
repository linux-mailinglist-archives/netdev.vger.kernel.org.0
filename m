Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDA3347B02
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 15:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236336AbhCXOpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 10:45:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:2051 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236258AbhCXOoz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 10:44:55 -0400
IronPort-SDR: tCdBMkvqOrZGMPu/mlmnhgFqm7kL8eg55XvPVQvpGWMe1eSSwlYa00fRECJzXXl9tyUfjUvFV6
 n/MR7LDVVc2Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9933"; a="177834548"
X-IronPort-AV: E=Sophos;i="5.81,274,1610438400"; 
   d="scan'208";a="177834548"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 07:44:55 -0700
IronPort-SDR: oMW/C52YfnDFEg7f7ctONnN+d7aydsjOGW3s19sA8woRjlhhTvyHoiw3pkzDzKOUVC60D1Dhc8
 /lVkn/rqTyxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,274,1610438400"; 
   d="scan'208";a="608127970"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga005.fm.intel.com with ESMTP; 24 Mar 2021 07:44:53 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf 1/3] libbpf: ensure umem pointer is non-NULL before dereferencing
Date:   Wed, 24 Mar 2021 14:13:35 +0000
Message-Id: <20210324141337.29269-2-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324141337.29269-1-ciara.loftus@intel.com>
References: <20210324141337.29269-1-ciara.loftus@intel.com>
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

