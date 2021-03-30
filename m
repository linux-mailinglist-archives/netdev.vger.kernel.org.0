Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AD334E71B
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 14:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbhC3MGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 08:06:19 -0400
Received: from mga12.intel.com ([192.55.52.136]:33814 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232078AbhC3MFz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 08:05:55 -0400
IronPort-SDR: my+MdOAo5gbg3tzf5urjy+XSnjyDOvpv2p9MHKuII8ameYqruYVio8AnJlbA/EjVVFgqw2wP8y
 ogOjb+/RStGA==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="171158226"
X-IronPort-AV: E=Sophos;i="5.81,290,1610438400"; 
   d="scan'208";a="171158226"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 05:05:55 -0700
IronPort-SDR: jktq7JLI7ZkexLMRvPWZopSGIT3hGju5DthL9BQGcp+qan5ty7kqpQIQl2A6hdc11BnKsOo1/d
 KO0aRyJOJrvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,290,1610438400"; 
   d="scan'208";a="418145843"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by orsmga008.jf.intel.com with ESMTP; 30 Mar 2021 05:05:52 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        alexei.starovoitov@gmail.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH v3 bpf 1/3] libbpf: ensure umem pointer is non-NULL before dereferencing
Date:   Tue, 30 Mar 2021 11:34:17 +0000
Message-Id: <20210330113419.4616-2-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210330113419.4616-1-ciara.loftus@intel.com>
References: <20210330113419.4616-1-ciara.loftus@intel.com>
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

