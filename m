Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE6E16AC6D
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 17:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgBXQ6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 11:58:48 -0500
Received: from gateway22.websitewelcome.com ([192.185.46.225]:30925 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727108AbgBXQ6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 11:58:48 -0500
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id ADD34142E
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 10:34:05 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 6GgHj4aoREfyq6GgHjAzDx; Mon, 24 Feb 2020 10:34:05 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oRyPAqEfBDa/tLG88bXJE7FMTqiLhKmjjZXGqSidZ4s=; b=yu3S1FSyyGJd97k4HHw4zuyghZ
        l7HwR2O63VREJfdgc2hqfXsyUjAGpGYt1OM1GCJ/jCIu2xJRI/RxACdTY8O9L0NdO44b0HuARmDPe
        yU3YY3Y1cj8/EXtnc4l/BWEsBr7/pjOsBK0KvArh1R8H3sOpDXlkLAC5EUfEmhKmC4TkxvNL13S20
        GtaNQNY48+frLA2qiH8QjVPn+wG7xnrF8rzZ2lA0s/cM85t9h4AYMOLJhNi+0k49ruWL5RNHUpfQr
        VnsptMp4TZYmUZVXYVD125rCAZM10B1ylTP0iQ0/LNqXr5qbz7BUKInH5TlZnYB3uo6VxMvXOimXx
        OY3Lx83g==;
Received: from [200.68.140.135] (port=6208 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j6GgF-002qzP-Vr; Mon, 24 Feb 2020 10:34:04 -0600
Date:   Mon, 24 Feb 2020 10:36:52 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        oss-drivers@netronome.com, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] netronome: Replace zero-length array with
 flexible-array member
Message-ID: <20200224163652.GA31089@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 200.68.140.135
X-Source-L: No
X-Exim-ID: 1j6GgF-002qzP-Vr
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.68.140.135]:6208
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 58
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/ethernet/netronome/nfp/bpf/fw.h            | 6 +++---
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h       | 4 ++--
 drivers/net/ethernet/netronome/nfp/nfp_main.h          | 2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_debugdump.c | 8 ++++----
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.h      | 2 +-
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h   | 2 +-
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/bpf/fw.h b/drivers/net/ethernet/netronome/nfp/bpf/fw.h
index a83a0ad5e27d..4268a7e0f344 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/fw.h
+++ b/drivers/net/ethernet/netronome/nfp/bpf/fw.h
@@ -104,14 +104,14 @@ struct cmsg_req_map_op {
 	__be32 tid;
 	__be32 count;
 	__be32 flags;
-	u8 data[0];
+	u8 data[];
 };
 
 struct cmsg_reply_map_op {
 	struct cmsg_reply_map_simple reply_hdr;
 	__be32 count;
 	__be32 resv;
-	u8 data[0];
+	u8 data[];
 };
 
 struct cmsg_bpf_event {
@@ -120,6 +120,6 @@ struct cmsg_bpf_event {
 	__be64 map_ptr;
 	__be32 data_size;
 	__be32 pkt_size;
-	u8 data[0];
+	u8 data[];
 };
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
index 9b50d76bbc09..bf516285510f 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
@@ -587,7 +587,7 @@ struct nfp_flower_cmsg_mac_repr {
 		u8 info;
 		u8 nbi_port;
 		u8 phys_port;
-	} ports[0];
+	} ports[];
 };
 
 #define NFP_FLOWER_CMSG_MAC_REPR_NBI		GENMASK(1, 0)
@@ -619,7 +619,7 @@ struct nfp_flower_cmsg_merge_hint {
 	struct {
 		__be32 host_ctx;
 		__be64 host_cookie;
-	} __packed flow[0];
+	} __packed flow[];
 };
 
 enum nfp_flower_cmsg_port_type {
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.h b/drivers/net/ethernet/netronome/nfp/nfp_main.h
index 5d5812fd9317..fa6b13a05941 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.h
@@ -42,7 +42,7 @@ struct nfp_shared_buf;
  */
 struct nfp_dumpspec {
 	u32 size;
-	u8 data[0];
+	u8 data[];
 };
 
 /**
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_debugdump.c b/drivers/net/ethernet/netronome/nfp/nfp_net_debugdump.c
index 769ceef09756..a614df095b08 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_debugdump.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_debugdump.c
@@ -36,7 +36,7 @@ enum nfp_dumpspec_type {
 struct nfp_dump_tl {
 	__be32 type;
 	__be32 length;	/* chunk length to follow, aligned to 8 bytes */
-	char data[0];
+	char data[];
 };
 
 /* NFP CPP parameters */
@@ -62,7 +62,7 @@ struct nfp_dumpspec_csr {
 
 struct nfp_dumpspec_rtsym {
 	struct nfp_dump_tl tl;
-	char rtsym[0];
+	char rtsym[];
 };
 
 /* header for register dumpable */
@@ -79,7 +79,7 @@ struct nfp_dump_rtsym {
 	struct nfp_dump_common_cpp cpp;
 	__be32 error;		/* error code encountered while reading */
 	u8 padded_name_length;	/* pad so data starts at 8 byte boundary */
-	char rtsym[0];
+	char rtsym[];
 	/* after padded_name_length, there is dump_length data */
 };
 
@@ -92,7 +92,7 @@ struct nfp_dump_error {
 	struct nfp_dump_tl tl;
 	__be32 error;
 	char padding[4];
-	char spec[0];
+	char spec[];
 };
 
 /* to track state through debug size calculation TLV traversal */
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.h b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.h
index e0f13dfe1f39..48a74accbbd3 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.h
@@ -18,7 +18,7 @@ struct nfp_port;
  */
 struct nfp_reprs {
 	unsigned int num_reprs;
-	struct net_device __rcu *reprs[0];
+	struct net_device __rcu *reprs[];
 };
 
 /**
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
index 1531c1870020..f5360bae6f75 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
@@ -183,7 +183,7 @@ struct nfp_eth_table {
 		bool is_split;
 
 		unsigned int fec_modes_supported;
-	} ports[0];
+	} ports[];
 };
 
 struct nfp_eth_table *nfp_eth_read_ports(struct nfp_cpp *cpp);
-- 
2.25.0

