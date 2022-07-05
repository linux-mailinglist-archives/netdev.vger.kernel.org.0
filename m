Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A1D567AFD
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 01:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbiGEX7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 19:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiGEX7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 19:59:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1743183AD;
        Tue,  5 Jul 2022 16:59:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D650B81A4F;
        Tue,  5 Jul 2022 23:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD73DC341CD;
        Tue,  5 Jul 2022 23:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657065576;
        bh=T8CPdmfQFImHqQc0VcaR4PstQbD65qWeUNTUxE0QT+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u0dLXhZukrUUJRQdnaCinCLSqRgsKhX/z7XHX5a9UAQBjq1NzevWsm/xYSpLu1+YQ
         E5nFopsD2sXZODTxTA7kSXVfOc92JKpL2sAJqp1w/f3F4ImnMS8hYDlRmfFmC7kFaN
         oIscWJVOY1iiHK97mc/lhCi74snpu5PFv87cDnksvoLE84LfoXhex2ZNQM3buaEd6Y
         1cNlDhZlDT8H3HTdpWlCHpKIc0OCPw8ydCKNUytnZcetvLTqq+Y6QmCEBfRWv7T74G
         xH05N30igPuzBNHqk5te9RHQkQy63hllhAw17+hMjXvuf298/7BqAQCFQtZVx79Uxc
         c7f30/GVuoi9g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        john.fastabend@gmail.com, borisp@nvidia.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        maximmi@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/5] tls: rx: add sockopt for enabling optimistic decrypt with TLS 1.3
Date:   Tue,  5 Jul 2022 16:59:24 -0700
Message-Id: <20220705235926.1035407-4-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220705235926.1035407-1-kuba@kernel.org>
References: <20220705235926.1035407-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since optimisitic decrypt may add extra load in case of retries
require socket owner to explicitly opt-in.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/tls.rst | 18 ++++++++
 include/linux/sockptr.h          |  8 ++++
 include/net/tls.h                |  3 ++
 include/uapi/linux/snmp.h        |  1 +
 include/uapi/linux/tls.h         |  2 +
 net/tls/tls_main.c               | 75 ++++++++++++++++++++++++++++++++
 net/tls/tls_proc.c               |  1 +
 net/tls/tls_sw.c                 | 21 ++++++---
 8 files changed, 122 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/tls.rst b/Documentation/networking/tls.rst
index be8e10c14b05..7a6643836e42 100644
--- a/Documentation/networking/tls.rst
+++ b/Documentation/networking/tls.rst
@@ -239,6 +239,19 @@ for the original TCP transmission and TCP retransmissions. To the receiver
 this will look like TLS records had been tampered with and will result
 in record authentication failures.
 
+TLS_RX_EXPECT_NO_PAD
+~~~~~~~~~~~~~~~~~~~~
+
+TLS 1.3 only. Expect the sender to not pad records. This allows the data
+to be decrypted directly into user space buffers with TLS 1.3.
+
+This optimization is safe to enable only if the remote end is trusted,
+otherwise it is an attack vector to doubling the TLS processing cost.
+
+If the record decrypted turns out to had been padded or is not a data
+record it will be decrypted again into a kernel buffer without zero copy.
+Such events are counted in the ``TlsDecryptRetry`` statistic.
+
 Statistics
 ==========
 
@@ -264,3 +277,8 @@ TLS implementation exposes the following per-namespace statistics
 
 - ``TlsDeviceRxResync`` -
   number of RX resyncs sent to NICs handling cryptography
+
+- ``TlsDecryptRetry`` -
+  number of RX records which had to be re-decrypted due to
+  ``TLS_RX_EXPECT_NO_PAD`` mis-prediction. Note that this counter will
+  also increment for non-data records.
diff --git a/include/linux/sockptr.h b/include/linux/sockptr.h
index ea193414298b..d45902fb4cad 100644
--- a/include/linux/sockptr.h
+++ b/include/linux/sockptr.h
@@ -102,4 +102,12 @@ static inline long strncpy_from_sockptr(char *dst, sockptr_t src, size_t count)
 	return strncpy_from_user(dst, src.user, count);
 }
 
+static inline int check_zeroed_sockptr(sockptr_t src, size_t offset,
+				       size_t size)
+{
+	if (!sockptr_is_kernel(src))
+		return check_zeroed_user(src.user + offset, size);
+	return memchr_inv(src.kernel + offset, 0, size) == NULL;
+}
+
 #endif /* _LINUX_SOCKPTR_H */
diff --git a/include/net/tls.h b/include/net/tls.h
index 8017f1703447..4fc16ca5f469 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -149,6 +149,7 @@ struct tls_sw_context_rx {
 
 	struct sk_buff *recv_pkt;
 	u8 async_capable:1;
+	u8 zc_capable:1;
 	atomic_t decrypt_pending;
 	/* protect crypto_wait with decrypt_pending*/
 	spinlock_t decrypt_compl_lock;
@@ -239,6 +240,7 @@ struct tls_context {
 	u8 tx_conf:3;
 	u8 rx_conf:3;
 	u8 zerocopy_sendfile:1;
+	u8 rx_no_pad:1;
 
 	int (*push_pending_record)(struct sock *sk, int flags);
 	void (*sk_write_space)(struct sock *sk);
@@ -358,6 +360,7 @@ int tls_sk_attach(struct sock *sk, int optname, char __user *optval,
 void tls_err_abort(struct sock *sk, int err);
 
 int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx);
+void tls_update_rx_zc_capable(struct tls_context *tls_ctx);
 void tls_sw_strparser_arm(struct sock *sk, struct tls_context *ctx);
 void tls_sw_strparser_done(struct tls_context *tls_ctx);
 int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 904909d020e2..1c9152add663 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -344,6 +344,7 @@ enum
 	LINUX_MIB_TLSRXDEVICE,			/* TlsRxDevice */
 	LINUX_MIB_TLSDECRYPTERROR,		/* TlsDecryptError */
 	LINUX_MIB_TLSRXDEVICERESYNC,		/* TlsRxDeviceResync */
+	LINUX_MIN_TLSDECRYPTRETRY,		/* TlsDecryptRetry */
 	__LINUX_MIB_TLSMAX
 };
 
diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
index bb8f80812b0b..f1157d8f4acd 100644
--- a/include/uapi/linux/tls.h
+++ b/include/uapi/linux/tls.h
@@ -40,6 +40,7 @@
 #define TLS_TX			1	/* Set transmit parameters */
 #define TLS_RX			2	/* Set receive parameters */
 #define TLS_TX_ZEROCOPY_RO	3	/* TX zerocopy (only sendfile now) */
+#define TLS_RX_EXPECT_NO_PAD	4	/* Attempt opportunistic zero-copy */
 
 /* Supported versions */
 #define TLS_VERSION_MINOR(ver)	((ver) & 0xFF)
@@ -162,6 +163,7 @@ enum {
 	TLS_INFO_TXCONF,
 	TLS_INFO_RXCONF,
 	TLS_INFO_ZC_RO_TX,
+	TLS_INFO_RX_NO_PAD,
 	__TLS_INFO_MAX,
 };
 #define TLS_INFO_MAX (__TLS_INFO_MAX - 1)
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 2ffede463e4a..1b3efc96db0b 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -533,6 +533,37 @@ static int do_tls_getsockopt_tx_zc(struct sock *sk, char __user *optval,
 	return 0;
 }
 
+static int do_tls_getsockopt_no_pad(struct sock *sk, char __user *optval,
+				    int __user *optlen)
+{
+	struct tls_context *ctx = tls_get_ctx(sk);
+	unsigned int value;
+	int err, len;
+
+	if (ctx->prot_info.version != TLS_1_3_VERSION)
+		return -EINVAL;
+
+	if (get_user(len, optlen))
+		return -EFAULT;
+	if (len < sizeof(value))
+		return -EINVAL;
+
+	lock_sock(sk);
+	err = -EINVAL;
+	if (ctx->rx_conf == TLS_SW || ctx->rx_conf == TLS_HW)
+		value = ctx->rx_no_pad;
+	release_sock(sk);
+	if (err)
+		return err;
+
+	if (put_user(sizeof(value), optlen))
+		return -EFAULT;
+	if (copy_to_user(optval, &value, sizeof(value)))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int do_tls_getsockopt(struct sock *sk, int optname,
 			     char __user *optval, int __user *optlen)
 {
@@ -547,6 +578,9 @@ static int do_tls_getsockopt(struct sock *sk, int optname,
 	case TLS_TX_ZEROCOPY_RO:
 		rc = do_tls_getsockopt_tx_zc(sk, optval, optlen);
 		break;
+	case TLS_RX_EXPECT_NO_PAD:
+		rc = do_tls_getsockopt_no_pad(sk, optval, optlen);
+		break;
 	default:
 		rc = -ENOPROTOOPT;
 		break;
@@ -718,6 +752,38 @@ static int do_tls_setsockopt_tx_zc(struct sock *sk, sockptr_t optval,
 	return 0;
 }
 
+static int do_tls_setsockopt_no_pad(struct sock *sk, sockptr_t optval,
+				    unsigned int optlen)
+{
+	struct tls_context *ctx = tls_get_ctx(sk);
+	u32 val;
+	int rc;
+
+	if (ctx->prot_info.version != TLS_1_3_VERSION ||
+	    sockptr_is_null(optval) || optlen < sizeof(val))
+		return -EINVAL;
+
+	rc = copy_from_sockptr(&val, optval, sizeof(val));
+	if (rc)
+		return -EFAULT;
+	if (val > 1)
+		return -EINVAL;
+	rc = check_zeroed_sockptr(optval, sizeof(val), optlen - sizeof(val));
+	if (rc < 1)
+		return rc == 0 ? -EINVAL : rc;
+
+	lock_sock(sk);
+	rc = -EINVAL;
+	if (ctx->rx_conf == TLS_SW || ctx->rx_conf == TLS_HW) {
+		ctx->rx_no_pad = val;
+		tls_update_rx_zc_capable(ctx);
+		rc = 0;
+	}
+	release_sock(sk);
+
+	return rc;
+}
+
 static int do_tls_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 			     unsigned int optlen)
 {
@@ -736,6 +802,9 @@ static int do_tls_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 		rc = do_tls_setsockopt_tx_zc(sk, optval, optlen);
 		release_sock(sk);
 		break;
+	case TLS_RX_EXPECT_NO_PAD:
+		rc = do_tls_setsockopt_no_pad(sk, optval, optlen);
+		break;
 	default:
 		rc = -ENOPROTOOPT;
 		break;
@@ -976,6 +1045,11 @@ static int tls_get_info(const struct sock *sk, struct sk_buff *skb)
 		if (err)
 			goto nla_failure;
 	}
+	if (ctx->rx_no_pad) {
+		err = nla_put_flag(skb, TLS_INFO_RX_NO_PAD);
+		if (err)
+			goto nla_failure;
+	}
 
 	rcu_read_unlock();
 	nla_nest_end(skb, start);
@@ -997,6 +1071,7 @@ static size_t tls_get_info_size(const struct sock *sk)
 		nla_total_size(sizeof(u16)) +	/* TLS_INFO_RXCONF */
 		nla_total_size(sizeof(u16)) +	/* TLS_INFO_TXCONF */
 		nla_total_size(0) +		/* TLS_INFO_ZC_RO_TX */
+		nla_total_size(0) +		/* TLS_INFO_RX_NO_PAD */
 		0;
 
 	return size;
diff --git a/net/tls/tls_proc.c b/net/tls/tls_proc.c
index feeceb0e4cb4..0c200000cc45 100644
--- a/net/tls/tls_proc.c
+++ b/net/tls/tls_proc.c
@@ -18,6 +18,7 @@ static const struct snmp_mib tls_mib_list[] = {
 	SNMP_MIB_ITEM("TlsRxDevice", LINUX_MIB_TLSRXDEVICE),
 	SNMP_MIB_ITEM("TlsDecryptError", LINUX_MIB_TLSDECRYPTERROR),
 	SNMP_MIB_ITEM("TlsRxDeviceResync", LINUX_MIB_TLSRXDEVICERESYNC),
+	SNMP_MIB_ITEM("TlsDecryptRetry", LINUX_MIN_TLSDECRYPTRETRY),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 2bac57684429..7592b6519953 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1601,6 +1601,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 	if (unlikely(darg->zc && prot->version == TLS_1_3_VERSION &&
 		     darg->tail != TLS_RECORD_TYPE_DATA)) {
 		darg->zc = false;
+		TLS_INC_STATS(sock_net(sk), LINUX_MIN_TLSDECRYPTRETRY);
 		return decrypt_skb_update(sk, skb, dest, darg);
 	}
 
@@ -1787,7 +1788,7 @@ int tls_sw_recvmsg(struct sock *sk,
 	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 
 	zc_capable = !bpf_strp_enabled && !is_kvec && !is_peek &&
-		     prot->version != TLS_1_3_VERSION;
+		ctx->zc_capable;
 	decrypted = 0;
 	while (len && (decrypted + copied < target || ctx->recv_pkt)) {
 		struct tls_decrypt_arg darg = {};
@@ -2269,6 +2270,14 @@ void tls_sw_strparser_arm(struct sock *sk, struct tls_context *tls_ctx)
 	strp_check_rcv(&rx_ctx->strp);
 }
 
+void tls_update_rx_zc_capable(struct tls_context *tls_ctx)
+{
+	struct tls_sw_context_rx *rx_ctx = tls_sw_ctx_rx(tls_ctx);
+
+	rx_ctx->zc_capable = tls_ctx->rx_no_pad ||
+		tls_ctx->prot_info.version != TLS_1_3_VERSION;
+}
+
 int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
@@ -2504,12 +2513,10 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 	if (sw_ctx_rx) {
 		tfm = crypto_aead_tfm(sw_ctx_rx->aead_recv);
 
-		if (crypto_info->version == TLS_1_3_VERSION)
-			sw_ctx_rx->async_capable = 0;
-		else
-			sw_ctx_rx->async_capable =
-				!!(tfm->__crt_alg->cra_flags &
-				   CRYPTO_ALG_ASYNC);
+		tls_update_rx_zc_capable(ctx);
+		sw_ctx_rx->async_capable =
+			crypto_info->version != TLS_1_3_VERSION &&
+			!!(tfm->__crt_alg->cra_flags & CRYPTO_ALG_ASYNC);
 
 		/* Set up strparser */
 		memset(&cb, 0, sizeof(cb));
-- 
2.36.1

