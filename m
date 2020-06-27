Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDD420C446
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 23:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgF0VTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 17:19:17 -0400
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:16519
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725907AbgF0VTP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 17:19:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5M3MqWPaVshtimu/tpWBTBZXY0msiajtHC+6sd18hV7o0ukyy1254hPRbw/jQOvO4h5CYB0l4VV3CCAXc+YVGlYH6c5A8+di3rmKuUUiia0U1iHSYDT30gdjYUAct7aBKhdC3cJl4lcLMDYwh/lqFhOorsGGNvvEfPVhWhkDHgbDhFwrXgGBWNgNZJpw+AsucPFS7wcGyQYVOROoVx5Wi7teKi51kCB4VYngWy/iWC4jbAT9xobwOllLszuARtbBNfJPM1+TnaW9gEWYbNDRZNB3//6aHXfGsEJUHjgrjaYFEOn5LLp2am7hrKliyK9347rJ7Pi8jEiFZuWVSBPmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KjNF7d3IGvPIO3Lv5TevLrSR3LFU2Nv3PxhrFnhhtpE=;
 b=Eo0faQXa4OAcl7mXwFUKdMMIHamh9XXAdWIoetumkrkFckfEILeM+CbJvbqJXOgZPXn4pcxH7dR9SaHA6uuuHrmW9kdtzEjSNYhI0jDEpnMrb3n0O8KMakU+i6Cg5Zm4vP4w305GOtSnGtswJo8gkNV54vxRELf11YTdbBad+m4mNUk9277zFyXVSvq08PcSJjakUVkMYXXHv+ZShIepVl7WPRY5B+JJum8PCdxl+FAjqX1xMBrJ82hRoeEn3ijT7TmYRyDMj2C/4aW2Ly7Xm2HIz8WguRuZzGMQdhMGn5QR1+9uf5kjCdcUMtcDpNM6XI84zqJbhZr+aY6pl2d/pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KjNF7d3IGvPIO3Lv5TevLrSR3LFU2Nv3PxhrFnhhtpE=;
 b=q9oc/CrkVxPpeR1yZYyjWHQhqCsFSVBBC7G0jpJ9c4x6n25HnNrB4+268YXb16YmadFYwet3A34f+K1hQopWO7DvaMXz9b/K28I0OZe6QWZm4lw4AEOuNBYhY+gv1cvHyd7eVtwzsFMA3opOU7uJPY8/VpkSbTHsaapU8bxqlK0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5134.eurprd05.prod.outlook.com (2603:10a6:803:ad::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Sat, 27 Jun
 2020 21:18:58 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.026; Sat, 27 Jun 2020
 21:18:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Boris Pismenny <borisp@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/15] net/tls: Add asynchronous resync
Date:   Sat, 27 Jun 2020 14:17:22 -0700
Message-Id: <20200627211727.259569-11-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200627211727.259569-1-saeedm@mellanox.com>
References: <20200627211727.259569-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0017.namprd03.prod.outlook.com (2603:10b6:a03:1e0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Sat, 27 Jun 2020 21:18:56 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2bccb625-540d-4575-7107-08d81adfb473
X-MS-TrafficTypeDiagnostic: VI1PR05MB5134:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5134D17C16EE79E3C43C20F2BE900@VI1PR05MB5134.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0447DB1C71
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A+Tex+iunAlxbLa7PlmrpmwyhOAUJO0+96n2DtMOTAysJkWdM6ycMd/X2vnf20jVP6H9Bex2cwDCDcRf/SUiSAB1uK3tgeqpqFNBVBnnBepSeOXevgZnl4nhWxlrYHOGj2pXZNYF/2a8pXqSXa5hdnGNf4BJ4sepaDQICVMfQMPCA1zylOkjubdLf4Q0WGrVP7WNBYKHSz9hfsYtxUy28ylm11h841LDeFmiNQCyzaUL9sESWnoEdWE+SzC+IjpJ4Rn2kseStB6K0Da2Uo3rfQYiTbFmGa9TgNosP5PelXHoB1xavndQRwXYmKkM1IPD3slCcn9AocchXI6WkNJGi3LQ0Mzr1t9pj63MXiA/uDcJo+4KbbX7XN7yg/qwfXwf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(39850400004)(346002)(396003)(66476007)(107886003)(54906003)(478600001)(4326008)(316002)(6512007)(16526019)(6506007)(2616005)(1076003)(6486002)(956004)(6666004)(66556008)(8936002)(52116002)(86362001)(36756003)(5660300002)(66946007)(26005)(8676002)(83380400001)(2906002)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vpIQhb70R2VxX7pPzTW6gfPwxjX9QPtPIr0rafkgjngZhHrXYhexHuS/ZO25vr00hLEJbPtK8GjpZAJbWdH3UESKsG/a0On5fY2qphN63HYIqfvd47BWSIvxO/N6m22vlwhylHFiifMehQXaJKhVq08x8NUgw3Gn9R3PYs8Ci9jPvNpUVxRKg4VL4GFY9pUI98KM0bUDXFpy8d2NoXuO2X5J76W5PlP+e9++0uh0cZHhfI5vFTOfNpBF9zPmftGyYG4dhti16KMhcF2UcjLHgSl2rd87ZJXTeZREShmDjzioktePZKlsLwZJFqlddk4enG1N4zrHMA8FGReyHxzXDp2KcF1YhuLDEd61QUiaPgaKhI0i4f3YL05GByijybDpo3xZCcUmYvw0CDz6zWF3rS1fQzPGw+HDzZ08f+DwY8/wXwvmQcvFT/6QQ9Q2jQcmuRAfanm1OuAmkSNXHSaIiq+6u61B3bqdzEOvXAyjvzg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bccb625-540d-4575-7107-08d81adfb473
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2020 21:18:58.2727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UgDBfutQRxIupL5DQyvjoOm5GVjGrYHOwcwLU3tRN+GVJXahOrtPZZykUcAgqIBJVc7bqsNA9/JPu4/bNDy3Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5134
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Pismenny <borisp@mellanox.com>

This patch adds support for asynchronous resynchronization in tls_device.
Async resync follows two distinct stages:

1. The NIC driver indicates that it would like to resync on some TLS
record within the received packet (P), but the driver does not
know (yet) which of the TLS records within the packet.
At this stage, the NIC driver will query the device to find the exact
TCP sequence for resync (tcpsn), however, the driver does not wait
for the device to provide the response.

2. Eventually, the device responds, and the driver provides the tcpsn
within the resync packet to KTLS. Now, KTLS can check the tcpsn against
any processed TLS records within packet P, and also against any record
that is processed in the future within packet P.

The asynchronous resync path simplifies the device driver, as it can
save bits on the packet completion (32-bit TCP sequence), and pass this
information on an asynchronous command instead.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/net/tls.h    | 38 ++++++++++++++++++++++++++++++++-
 net/tls/tls_device.c | 51 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+), 1 deletion(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index ca5f7f437289..c875c0a445a6 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -291,11 +291,19 @@ struct tlsdev_ops {
 enum tls_offload_sync_type {
 	TLS_OFFLOAD_SYNC_TYPE_DRIVER_REQ = 0,
 	TLS_OFFLOAD_SYNC_TYPE_CORE_NEXT_HINT = 1,
+	TLS_OFFLOAD_SYNC_TYPE_DRIVER_REQ_ASYNC = 2,
 };
 
 #define TLS_DEVICE_RESYNC_NH_START_IVAL		2
 #define TLS_DEVICE_RESYNC_NH_MAX_IVAL		128
 
+#define TLS_DEVICE_RESYNC_ASYNC_LOGMAX		13
+struct tls_offload_resync_async {
+	atomic64_t req;
+	u32 loglen;
+	u32 log[TLS_DEVICE_RESYNC_ASYNC_LOGMAX];
+};
+
 struct tls_offload_context_rx {
 	/* sw must be the first member of tls_offload_context_rx */
 	struct tls_sw_context_rx sw;
@@ -314,6 +322,10 @@ struct tls_offload_context_rx {
 			u32 decrypted_failed;
 			u32 decrypted_tgt;
 		} resync_nh;
+		/* TLS_OFFLOAD_SYNC_TYPE_DRIVER_REQ_ASYNC */
+		struct {
+			struct tls_offload_resync_async *resync_async;
+		};
 	};
 	u8 driver_state[] __aligned(8);
 	/* The TLS layer reserves room for driver specific state
@@ -606,13 +618,37 @@ tls_driver_ctx(const struct sock *sk, enum tls_offload_ctx_dir direction)
 }
 #endif
 
+#define RESYNC_REQ BIT(0)
+#define RESYNC_REQ_ASYNC BIT(1)
 /* The TLS context is valid until sk_destruct is called */
 static inline void tls_offload_rx_resync_request(struct sock *sk, __be32 seq)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_offload_context_rx *rx_ctx = tls_offload_ctx_rx(tls_ctx);
 
-	atomic64_set(&rx_ctx->resync_req, ((u64)ntohl(seq) << 32) | 1);
+	atomic64_set(&rx_ctx->resync_req, ((u64)ntohl(seq) << 32) | RESYNC_REQ);
+}
+
+/* Log all TLS record header TCP sequences in [seq, seq+len] */
+static inline void
+tls_offload_rx_resync_async_request_start(struct sock *sk, __be32 seq, u16 len)
+{
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
+	struct tls_offload_context_rx *rx_ctx = tls_offload_ctx_rx(tls_ctx);
+
+	atomic64_set(&rx_ctx->resync_async->req, ((u64)ntohl(seq) << 32) |
+		     (len << 16) | RESYNC_REQ | RESYNC_REQ_ASYNC);
+	rx_ctx->resync_async->loglen = 0;
+}
+
+static inline void
+tls_offload_rx_resync_async_request_end(struct sock *sk, __be32 seq)
+{
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
+	struct tls_offload_context_rx *rx_ctx = tls_offload_ctx_rx(tls_ctx);
+
+	atomic64_set(&rx_ctx->resync_async->req,
+		     ((u64)ntohl(seq) << 32) | RESYNC_REQ);
 }
 
 static inline void
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index a562ebaaa33c..18fa6067bb7f 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -690,6 +690,47 @@ static void tls_device_resync_rx(struct tls_context *tls_ctx,
 	TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSRXDEVICERESYNC);
 }
 
+static bool
+tls_device_rx_resync_async(struct tls_offload_resync_async *resync_async,
+			   s64 resync_req, u32 *seq)
+{
+	u32 is_async = resync_req & RESYNC_REQ_ASYNC;
+	u32 req_seq = resync_req >> 32;
+	u32 req_end = req_seq + ((resync_req >> 16) & 0xffff);
+
+	if (is_async) {
+		/* asynchronous stage: log all headers seq such that
+		 * req_seq <= seq <= end_seq, and wait for real resync request
+		 */
+		if (between(*seq, req_seq, req_end) &&
+		    resync_async->loglen < TLS_DEVICE_RESYNC_ASYNC_LOGMAX)
+			resync_async->log[resync_async->loglen++] = *seq;
+
+		return false;
+	}
+
+	/* synchronous stage: check against the logged entries and
+	 * proceed to check the next entries if no match was found
+	 */
+	while (resync_async->loglen) {
+		if (req_seq == resync_async->log[resync_async->loglen - 1] &&
+		    atomic64_try_cmpxchg(&resync_async->req,
+					 &resync_req, 0)) {
+			resync_async->loglen = 0;
+			*seq = req_seq;
+			return true;
+		}
+		resync_async->loglen--;
+	}
+
+	if (req_seq == *seq &&
+	    atomic64_try_cmpxchg(&resync_async->req,
+				 &resync_req, 0))
+		return true;
+
+	return false;
+}
+
 void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
@@ -736,6 +777,16 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
 		seq += rcd_len;
 		tls_bigint_increment(rcd_sn, prot->rec_seq_size);
 		break;
+	case TLS_OFFLOAD_SYNC_TYPE_DRIVER_REQ_ASYNC:
+		resync_req = atomic64_read(&rx_ctx->resync_async->req);
+		is_req_pending = resync_req;
+		if (likely(!is_req_pending))
+			return;
+
+		if (!tls_device_rx_resync_async(rx_ctx->resync_async,
+						resync_req, &seq))
+			return;
+		break;
 	}
 
 	tls_device_resync_rx(tls_ctx, sk, seq, rcd_sn);
-- 
2.26.2

