Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A78D3A6715
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbhFNMxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:53:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233770AbhFNMxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 08:53:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCD7B613E9;
        Mon, 14 Jun 2021 12:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623675074;
        bh=4vTxFn/Yu97k12Mq5hCxd9c4FBn5ZgFNpfRixHf1T3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQ7wKQ5O953AuNE8oa2MovOgZJOC6WK6+uH02T+jNuQ45Ns0e21BCpcgXQYEppAqf
         BiqIYCOGunELGIPUCXYjaK/C56gTZJ515Zn2iCyd1EOdGmIG/3SnvVLPcHZskKUeve
         OjkWg2PZm/4n+UdGgOLgPgXejNjjRgdo8eReP727cjyUrOt+F0wod/hsRhzCeAcaRu
         YeqNVbMs9bj4V90vC519CnfRohpXyvaHvdaKj61p5lTjN+6ebbtCi1XxlPwZcH4A5R
         kFij+IIvXQF7uIExD+nDu866gal8+Ozw6ISnTFN4EIkstQh5ORpYswR0GzO2IsNIy7
         PyzpV0qfDlsMA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Subject: [PATCH v9 bpf-next 09/14] bpf: introduce bpf_xdp_get_buff_len helper
Date:   Mon, 14 Jun 2021 14:49:47 +0200
Message-Id: <bd4414300772e8801864bca3cd07e401138df1d9.1623674025.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623674025.git.lorenzo@kernel.org>
References: <cover.1623674025.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce bpf_xdp_get_buff_len helper in order to return the xdp buffer
total size (linear and paged area)

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/uapi/linux/bpf.h       |  7 +++++++
 net/core/filter.c              | 23 +++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  7 +++++++
 3 files changed, 37 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 2c1ba70abbf1..0116c0c569fe 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4778,6 +4778,12 @@ union bpf_attr {
  * 		Execute close syscall for given FD.
  * 	Return
  * 		A syscall result.
+ *
+ * int bpf_xdp_get_buff_len(struct xdp_buff *xdp_md)
+ *	Description
+ *		Get the total size of a given xdp buff (linear and paged area)
+ *	Return
+ *		The total size of a given xdp buffer.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -4949,6 +4955,7 @@ union bpf_attr {
 	FN(sys_bpf),			\
 	FN(btf_find_by_name_kind),	\
 	FN(sys_close),			\
+	FN(xdp_get_buff_len),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 05f574a3d690..b0855f2d4726 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3918,6 +3918,27 @@ static int bpf_xdp_mb_adjust_tail(struct xdp_buff *xdp, int offset)
 	return 0;
 }
 
+BPF_CALL_1(bpf_xdp_get_buff_len, struct  xdp_buff*, xdp)
+{
+	int data_len = 0;
+
+	if (unlikely(xdp_buff_is_mb(xdp))) {
+		struct skb_shared_info *sinfo;
+
+		sinfo = xdp_get_shared_info_from_buff(xdp);
+		data_len = sinfo->data_len;
+	}
+
+	return (xdp->data_end - xdp->data) + data_len;
+}
+
+const struct bpf_func_proto bpf_xdp_get_buff_len_proto = {
+	.func		= bpf_xdp_get_buff_len,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+};
+
 BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
 {
 	void *data_hard_end = xdp_data_hard_end(xdp); /* use xdp->frame_sz */
@@ -7454,6 +7475,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_redirect_map_proto;
 	case BPF_FUNC_xdp_adjust_tail:
 		return &bpf_xdp_adjust_tail_proto;
+	case BPF_FUNC_xdp_get_buff_len:
+		return &bpf_xdp_get_buff_len_proto;
 	case BPF_FUNC_fib_lookup:
 		return &bpf_xdp_fib_lookup_proto;
 	case BPF_FUNC_check_mtu:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 2c1ba70abbf1..0116c0c569fe 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4778,6 +4778,12 @@ union bpf_attr {
  * 		Execute close syscall for given FD.
  * 	Return
  * 		A syscall result.
+ *
+ * int bpf_xdp_get_buff_len(struct xdp_buff *xdp_md)
+ *	Description
+ *		Get the total size of a given xdp buff (linear and paged area)
+ *	Return
+ *		The total size of a given xdp buffer.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -4949,6 +4955,7 @@ union bpf_attr {
 	FN(sys_bpf),			\
 	FN(btf_find_by_name_kind),	\
 	FN(sys_close),			\
+	FN(xdp_get_buff_len),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.31.1

