Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7002AF14E
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 13:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgKKM4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 07:56:25 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:35097 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725909AbgKKM4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 07:56:25 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 11 Nov 2020 14:56:22 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0ABCuMri021784;
        Wed, 11 Nov 2020 14:56:22 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: [PATCH net] net/tls: Fix wrong record sn in async mode of device resync
Date:   Wed, 11 Nov 2020 14:55:56 +0200
Message-Id: <20201111125556.7414-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In async_resync mode, we log the TCP seq of records until the async request
is completed.  Later, in case one of the logged seqs matches the resync
request, we return it, together with its record serial number.  Before this
fix, we mistakenly returned the serial number of the current record
instead.

Fixes: ed9b7646b06a ("net/tls: Add asynchronous resync")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Boris Pismenny <borisp@nvidia.com>
---
 include/net/tls.h    | 19 ++++++++++++++++++-
 net/tls/tls_device.c | 35 +++++++++++++++++++++++++----------
 2 files changed, 43 insertions(+), 11 deletions(-)

Hi,

Please queue to -stable >= v5.9.

Thanks,
Tariq

diff --git a/include/net/tls.h b/include/net/tls.h
index baf1e99d8193..92515d1ad370 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -300,7 +300,8 @@ enum tls_offload_sync_type {
 #define TLS_DEVICE_RESYNC_ASYNC_LOGMAX		13
 struct tls_offload_resync_async {
 	atomic64_t req;
-	u32 loglen;
+	u16 loglen;
+	u16 rcd_delta;
 	u32 log[TLS_DEVICE_RESYNC_ASYNC_LOGMAX];
 };
 
@@ -471,6 +472,21 @@ static inline bool tls_bigint_increment(unsigned char *seq, int len)
 	return (i == -1);
 }
 
+static inline bool tls_bigint_subtract(unsigned char *seq, int len, u16 n)
+{
+	u64 rcd_sn;
+	__be64 *p;
+
+	if (WARN_ON_ONCE(len != 8))
+		return true;
+
+	p = (__be64 *)seq;
+	rcd_sn = be64_to_cpu(*p);
+	*p = cpu_to_be64(rcd_sn - n);
+
+	return false;
+}
+
 static inline struct tls_context *tls_get_ctx(const struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
@@ -639,6 +655,7 @@ tls_offload_rx_resync_async_request_start(struct sock *sk, __be32 seq, u16 len)
 	atomic64_set(&rx_ctx->resync_async->req, ((u64)ntohl(seq) << 32) |
 		     ((u64)len << 16) | RESYNC_REQ | RESYNC_REQ_ASYNC);
 	rx_ctx->resync_async->loglen = 0;
+	rx_ctx->resync_async->rcd_delta = 0;
 }
 
 static inline void
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index cec86229a6a0..9f9c2f777cdf 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -694,36 +694,49 @@ static void tls_device_resync_rx(struct tls_context *tls_ctx,
 
 static bool
 tls_device_rx_resync_async(struct tls_offload_resync_async *resync_async,
-			   s64 resync_req, u32 *seq)
+			   s64 resync_req, u32 *seq, u16 *rcd_delta)
 {
 	u32 is_async = resync_req & RESYNC_REQ_ASYNC;
 	u32 req_seq = resync_req >> 32;
 	u32 req_end = req_seq + ((resync_req >> 16) & 0xffff);
+	u16 i;
+
+	*rcd_delta = 0;
 
 	if (is_async) {
+		/* shouldn't get to wraparound, too long in async stage, something bad happened */
+		if (WARN_ON_ONCE(resync_async->rcd_delta == USHRT_MAX))
+			return false;
+
 		/* asynchronous stage: log all headers seq such that
 		 * req_seq <= seq <= end_seq, and wait for real resync request
 		 */
-		if (between(*seq, req_seq, req_end) &&
+		if (before(*seq, req_seq))
+			return false;
+		if (!after(*seq, req_end) &&
 		    resync_async->loglen < TLS_DEVICE_RESYNC_ASYNC_LOGMAX)
 			resync_async->log[resync_async->loglen++] = *seq;
 
+		resync_async->rcd_delta++;
+
 		return false;
 	}
 
 	/* synchronous stage: check against the logged entries and
 	 * proceed to check the next entries if no match was found
 	 */
-	while (resync_async->loglen) {
-		if (req_seq == resync_async->log[resync_async->loglen - 1] &&
-		    atomic64_try_cmpxchg(&resync_async->req,
-					 &resync_req, 0)) {
-			resync_async->loglen = 0;
+	for (i = 0; i < resync_async->loglen; i++)
+		if (req_seq == resync_async->log[i] &&
+		    atomic64_try_cmpxchg(&resync_async->req, &resync_req, 0)) {
+			*rcd_delta = resync_async->rcd_delta - i;
 			*seq = req_seq;
+			resync_async->loglen = 0;
+			resync_async->rcd_delta = 0;
 			return true;
 		}
-		resync_async->loglen--;
-	}
+
+	resync_async->loglen = 0;
+	resync_async->rcd_delta = 0;
 
 	if (req_seq == *seq &&
 	    atomic64_try_cmpxchg(&resync_async->req,
@@ -741,6 +754,7 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
 	u32 sock_data, is_req_pending;
 	struct tls_prot_info *prot;
 	s64 resync_req;
+	u16 rcd_delta;
 	u32 req_seq;
 
 	if (tls_ctx->rx_conf != TLS_HW)
@@ -786,8 +800,9 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
 			return;
 
 		if (!tls_device_rx_resync_async(rx_ctx->resync_async,
-						resync_req, &seq))
+						resync_req, &seq, &rcd_delta))
 			return;
+		tls_bigint_subtract(rcd_sn, prot->rec_seq_size, rcd_delta);
 		break;
 	}
 
-- 
2.21.0

