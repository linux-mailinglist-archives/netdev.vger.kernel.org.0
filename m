Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC5D1076D7
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 18:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfKVR52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 12:57:28 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:33486 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726046AbfKVR52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 12:57:28 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id ACD9E300063;
        Fri, 22 Nov 2019 17:57:26 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 22 Nov
 2019 17:57:21 +0000
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 2/4] sfc: suppress MCDI errors from ARFS
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <dahern@digitalocean.com>
References: <a41f9c29-db34-a2e4-1abd-bfe1a33b442e@solarflare.com>
Message-ID: <d3aeb469-cd78-c6a4-2804-3624fe9f876c@solarflare.com>
Date:   Fri, 22 Nov 2019 17:57:19 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <a41f9c29-db34-a2e4-1abd-bfe1a33b442e@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25058.003
X-TM-AS-Result: No-7.210700-8.000000-10
X-TMASE-MatchedRID: gEyyiKDfwQ/4BlFc4KMn3NB/IoRhBzVHaV/UQ+pZUx8INpIFnbd6moc7
        TsYJVs+AJdiDCepPDnX3zUUW+ZW64QhV0mWPUAieKrDHzH6zmUURMzHw4jihudEsTITobgNEndH
        SeYfTAvXaFcUQka95YJnx1D8CeR1zColcGcxhU/oWqJ/PBjhtWpYaT3cL9WdK8Q0z/q2IZxMtOT
        e0r57npm1Jb53Ovda/+ApxoIR2xwyh9oPbMj7PPPCoOvLLtsMhP6Tki+9nU38HZBaLwEXlKGlF7
        OhYLlctSIsmrX0f88Hl0ByOo0JQfUOEIlpfwCcSD3uYMxd01bc2sHuPFnfszvnqcdWkRgUeokWZ
        uZ853DcfTtGxjsf95ppuv+bpe/FPAqsA4DtLDcy1GgeTcvlUnJyqUJ2uHKFAYpaRze8Sn/WM9W6
        vGyHQ784uXWEI31o5tWAS6GGXjgjGNdEc1k/1sxz2MDiYujy5BnIRIVcCWN8FPRmzk/yBqaPFjJ
        EFr+olA9Mriq0CDAg9wJeM2pSaRSAHAopEd76vcs1V07mMzaI2Rj5CzlrafLnLwKfDZuSay0RLg
        EUW1XQSbOWrlI5o6A==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.210700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25058.003
X-MDID: 1574445447-3ePi8DouCkVY
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In high connection count usage, the NIC's filter table may be filled with
 sufficiently many ARFS filters that further insertions fail.  As this
 does not represent a correctness issue, do not log the resulting MCDI
 errors.  Add a debug-level message under the (by default disabled)
 rx_status category instead; and take the opportunity to do a little extra
 expiry work.

Since there are now multiple workitems able to call __efx_filter_rfs_expire
 on a given channel, it is possible for them to race and thus pass quotas
 which, combined, exceed rfs_filter_count.  Thus, don't WARN_ON if we loop
 all the way around the table with quota left over.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c |  8 ++++++--
 drivers/net/ethernet/sfc/rx.c   | 28 ++++++++++++++++++++++++----
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index ad68eb0cb8fd..4d9bbccc6f89 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -4202,11 +4202,15 @@ static int efx_ef10_filter_push(struct efx_nic *efx,
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_FILTER_OP_EXT_IN_LEN);
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_FILTER_OP_EXT_OUT_LEN);
+	size_t outlen;
 	int rc;
 
 	efx_ef10_filter_push_prep(efx, spec, inbuf, *handle, ctx, replacing);
-	rc = efx_mcdi_rpc(efx, MC_CMD_FILTER_OP, inbuf, sizeof(inbuf),
-			  outbuf, sizeof(outbuf), NULL);
+	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_FILTER_OP, inbuf, sizeof(inbuf),
+				outbuf, sizeof(outbuf), &outlen);
+	if (rc && spec->priority != EFX_FILTER_PRI_HINT)
+		efx_mcdi_display_error(efx, MC_CMD_FILTER_OP, sizeof(inbuf),
+				       outbuf, outlen, rc);
 	if (rc == 0)
 		*handle = MCDI_QWORD(outbuf, FILTER_OP_OUT_HANDLE);
 	if (rc == -ENOSPC)
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index bbf2393f7599..252a5f10596d 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -1032,6 +1032,26 @@ static void efx_filter_rfs_work(struct work_struct *data)
 				   req->spec.rem_host, ntohs(req->spec.rem_port),
 				   req->spec.loc_host, ntohs(req->spec.loc_port),
 				   req->rxq_index, req->flow_id, rc, arfs_id);
+	} else {
+		if (req->spec.ether_type == htons(ETH_P_IP))
+			netif_dbg(efx, rx_status, efx->net_dev,
+				  "failed to steer %s %pI4:%u:%pI4:%u to queue %u [flow %u rc %d id %u]\n",
+				  (req->spec.ip_proto == IPPROTO_TCP) ? "TCP" : "UDP",
+				  req->spec.rem_host, ntohs(req->spec.rem_port),
+				  req->spec.loc_host, ntohs(req->spec.loc_port),
+				  req->rxq_index, req->flow_id, rc, arfs_id);
+		else
+			netif_dbg(efx, rx_status, efx->net_dev,
+				  "failed to steer %s [%pI6]:%u:[%pI6]:%u to queue %u [flow %u rc %d id %u]\n",
+				  (req->spec.ip_proto == IPPROTO_TCP) ? "TCP" : "UDP",
+				  req->spec.rem_host, ntohs(req->spec.rem_port),
+				  req->spec.loc_host, ntohs(req->spec.loc_port),
+				  req->rxq_index, req->flow_id, rc, arfs_id);
+		/* We're overloading the NIC's filter tables, so let's do a
+		 * chunk of extra expiry work.
+		 */
+		__efx_filter_rfs_expire(channel, min(channel->rfs_filter_count,
+						     100u));
 	}
 
 	/* Release references */
@@ -1170,11 +1190,11 @@ bool __efx_filter_rfs_expire(struct efx_channel *channel, unsigned int quota)
 		if (++index == size)
 			index = 0;
 		/* If we were called with a quota that exceeds the total number
-		 * of filters in the table (which should never happen), ensure
-		 * that we don't loop forever - stop when we've examined every
-		 * row of the table.
+		 * of filters in the table (which shouldn't happen, but could
+		 * if two callers race), ensure that we don't loop forever -
+		 * stop when we've examined every row of the table.
 		 */
-		if (WARN_ON(index == start && quota))
+		if (index == start)
 			break;
 	}
 

