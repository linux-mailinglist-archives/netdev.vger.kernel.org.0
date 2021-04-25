Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919AC36A896
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 19:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbhDYRmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 13:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbhDYRmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 13:42:08 -0400
X-Greylist: delayed 515 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 25 Apr 2021 10:41:27 PDT
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2a00:c38:11e:ffff::a032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A8EC061574;
        Sun, 25 Apr 2021 10:41:27 -0700 (PDT)
From:   Richard Sailer <richard_siegfried@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1619371954;
        bh=ox3efJnaRB77OtV0du9g3CiLZNhgcvK0gzuL7ANDrFY=;
        h=From:To:Cc:Subject:Date:From;
        b=0FtGQW68JkaIC4bzT41tBGuR29dttkbpUxS29ODAzKqNG9+7Us+iQAwm3FmjmxUhA
         BLXkb+KF5lCIr6aSMFbI5sTmwDgniUhU+Fau+3390ty4R+vRdabCFa1j0D4vsriHgy
         27h4SX3da/CFMEc3VjMS0Lz5tx//ILHQBQ8RtFDh2bKyVwINkc3GnCaXSGeUBWWKRx
         oACWQEQAqK3CAfEqpsLwWACSPCA/3YNABq/eAnRFU+XSXcCXZhQpTs4phGjEJ3j5/P
         ZhQFhDeAuwbjMh+gm8IOavvuUNkmUURfTdpGoNJ/vk3Au4vp68bWtaFK0kyJEi60eg
         x4hFPbXtrZuNQ==
To:     gerrit@erg.abdn.ac.uk, davem@davemloft.net, dccp@vger.kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] dccp: add getsockopt option for CCID2: DCCP_SOCKOPT_CCID_TX_INFO
Date:   Sun, 25 Apr 2021 19:32:19 +0200
Message-Id: <20210425173219.175324-1-richard_siegfried@systemli.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CCID 3 already has the getsockopt() option DCCP_SOCKOPT_CCID_TX_INFO,
this commit also adds it for CCID2. It returns tx and congestion control
information in struct ccid_tx_info.

This also adds doc in Documentation/networking/dccp.rst and defines
the struct in include/uapi/linux/dccp.h to make it accessible to userspace.
---
 Documentation/networking/dccp.rst | 22 +++++++++++----------
 include/uapi/linux/dccp.h         | 16 ++++++++++++++++
 net/dccp/ccids/ccid2.c            | 32 +++++++++++++++++++++++++++++++
 3 files changed, 60 insertions(+), 10 deletions(-)

diff --git a/Documentation/networking/dccp.rst b/Documentation/networking/dccp.rst
index 91e5c33ba3ff..8f2852817773 100644
--- a/Documentation/networking/dccp.rst
+++ b/Documentation/networking/dccp.rst
@@ -126,16 +126,18 @@ DCCP_SOCKOPT_RECV_CSCOV is for the receiver and has a different meaning: it
 	restrictive this setting (see [RFC 4340, sec. 9.2.1]). Partial coverage
 	settings are inherited to the child socket after accept().
 
-The following two options apply to CCID 3 exclusively and are getsockopt()-only.
-In either case, a TFRC info struct (defined in <linux/tfrc.h>) is returned.
-
-DCCP_SOCKOPT_CCID_RX_INFO
-	Returns a ``struct tfrc_rx_info`` in optval; the buffer for optval and
-	optlen must be set to at least sizeof(struct tfrc_rx_info).
-
-DCCP_SOCKOPT_CCID_TX_INFO
-	Returns a ``struct tfrc_tx_info`` in optval; the buffer for optval and
-	optlen must be set to at least sizeof(struct tfrc_tx_info).
+DCCP_SOCKOPT_CCID_RX_INFO (CCID3 only, getsockopt() only)
+	Returns a ``struct tfrc_rx_info`` (defined in <linux/tfrc.h>) in optval;
+	the buffer for optval and optlen must be at least sizeof(struct tfrc_rx_info).
+
+DCCP_SOCKOPT_CCID_TX_INFO (getsockopt() only)
+	CCID 3:
+	Returns a ``struct tfrc_tx_info`` (defined in <linux/tfrc.h>) in optval;
+	the buffer for optval and optlen must be at least sizeof(struct tfrc_tx_info).
+
+	CCID 2:
+	Returns a ``struct ccid2_tx_info`` (defined in <uapi/linux/dccp.h>) in optval;
+	the buffer for optval and optlen must be at least sizeof(struct ccid2_tx_info).
 
 On unidirectional connections it is useful to close the unused half-connection
 via shutdown (SHUT_WR or SHUT_RD): this will reduce per-packet processing costs.
diff --git a/include/uapi/linux/dccp.h b/include/uapi/linux/dccp.h
index 6e1978dbcf7c..5d5290b8788a 100644
--- a/include/uapi/linux/dccp.h
+++ b/include/uapi/linux/dccp.h
@@ -47,6 +47,22 @@ struct dccp_hdr {
 	__be16	dccph_seq;
 };
 
+/**  struct ccid2_tx_info (Congestion Control Infos)
+ *
+ * @tx_cwnd:                 max number of packets the path can handle
+ * @tx_srtt:                 smoothed RTT estimate, scaled by 2^3
+ * @tx_pipe:                 estimate of "in flight" packets
+ * @buffer_fill              number of bytes in send buffer
+ * @cur_mss                  current MSS (in bytes) (pMTU - header_sizes)
+ */
+struct ccid2_tx_info {
+	__u32	tx_cwnd;
+	__u32	tx_srtt;
+	__u32	tx_pipe;
+	int	buffer_fill;
+	__u32	cur_mss;
+};
+
 /**
  * struct dccp_hdr_ext - the low bits of a 48 bit seq packet
  *
diff --git a/net/dccp/ccids/ccid2.c b/net/dccp/ccids/ccid2.c
index 4d9823d6dced..3f40265552c5 100644
--- a/net/dccp/ccids/ccid2.c
+++ b/net/dccp/ccids/ccid2.c
@@ -22,6 +22,37 @@ static bool ccid2_debug;
 #define ccid2_pr_debug(format, a...)
 #endif
 
+int ccid2_hc_tx_getsockopt(struct sock *sk, const int optname, int len,
+                           u32 __user *optval, int __user *optlen)
+{
+	const struct ccid2_hc_tx_sock *hc = ccid2_hc_tx_sk(sk);
+	struct dccp_sock *dp = dccp_sk(sk);
+	struct ccid2_tx_info ccid2_info;
+	const void *val;
+
+	switch (optname) {
+	case DCCP_SOCKOPT_CCID_TX_INFO:
+		if (len < sizeof(ccid2_info))
+			return -EINVAL;
+		memset(&ccid2_info, 0, sizeof(ccid2_info));
+		ccid2_info.tx_cwnd	   = hc->tx_cwnd;
+		ccid2_info.tx_srtt         = hc->tx_srtt;
+		ccid2_info.tx_pipe         = hc->tx_pipe;
+		ccid2_info.buffer_fill     = sk_wmem_alloc_get(sk);
+		ccid2_info.cur_mss         = dp->dccps_mss_cache;
+		len = sizeof(ccid2_info);
+		val = &ccid2_info;
+		break;
+	default:
+		return -ENOPROTOOPT;
+	}
+
+	if (put_user(len, optlen) || copy_to_user(optval, val, len))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int ccid2_hc_tx_alloc_seq(struct ccid2_hc_tx_sock *hc)
 {
 	struct ccid2_seq *seqp;
@@ -785,6 +816,7 @@ struct ccid_operations ccid2_ops = {
 	.ccid_hc_tx_packet_recv	  = ccid2_hc_tx_packet_recv,
 	.ccid_hc_rx_obj_size	  = sizeof(struct ccid2_hc_rx_sock),
 	.ccid_hc_rx_packet_recv	  = ccid2_hc_rx_packet_recv,
+	.ccid_hc_tx_getsockopt    = ccid2_hc_tx_getsockopt,
 };
 
 #ifdef CONFIG_IP_DCCP_CCID2_DEBUG
-- 
2.30.2

