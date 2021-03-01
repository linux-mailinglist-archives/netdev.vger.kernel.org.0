Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E22328B38
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 19:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238787AbhCASbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 13:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239889AbhCAS1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 13:27:16 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF48FC061356;
        Mon,  1 Mar 2021 10:25:54 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id do6so30071599ejc.3;
        Mon, 01 Mar 2021 10:25:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nXDchZASkXBC96smjDkqNNKMZvkZns+OV+17KBYTZfE=;
        b=QBU1vh6RkWIWqFG/GoCkva6S/QrYcQqUyrLQ6NQ5u9hXacKYyOATCPPFkLdqx32n83
         DTm6WThrhSIAYx5Hu3sfWUcCf4LGv8sEWEcaRXYC6Cel/CLHVGCHyciICxEp+rY0ZSNZ
         3Ys4FrdwdHE75FV+nx9IlIzcasnaUslE2s7l5qcrE05rAFNYkylRAFg/QP+t/NyyqN0X
         1IzDd9jxIz3FX4nZKJpUNthCPD0ZIq7aeVUFCOPCG8KW+yPZ2Pe4+QLGNnS/Ayuumkvo
         5y9vCW+ZK/+ePN86/a4HmdNy1X7qqMWbRb9VoQHaFfTbuSarkEKKxTNGJ9c/mJHBrprb
         LZ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nXDchZASkXBC96smjDkqNNKMZvkZns+OV+17KBYTZfE=;
        b=IP3hyEDbo2VrSovlzWya8rd3C1jF4JCIuRpLwzrj0T0c9Y8xYoA7Wv+Zfnng3UgV+H
         Z9jU4NS5WmVMtCc925jMjRGkYLOzuqhbr3I4R5TcozToVcvF44A5Tf16b7hzOc78bJlR
         T1l5Sl3fkO2kh3loPSsW9X5glHqKgTGBSyZKW7auXxeKlORfxyPS8FZQWWCLrxFNITOK
         YjPTQY2iAxT5GEA2SWz+p1NY3smZg+PGLd8Zniltzhc0PZ+RWH1l/Ru77M7epQQz10b5
         SWVkf5ajB1HNf5B71dVf0DBvglZtZm6g0D1ixx5eOqKlCHkYkqEJwWPUDJ75+djvYZ+f
         4FSA==
X-Gm-Message-State: AOAM531YcAGehw1b65X2KlPQMt5Xca/ifPwnAtvIFIDf6cJdI6bukggl
        0j8kThaxryjG/EmSdPSP0hYKv3sXY5A79XUH
X-Google-Smtp-Source: ABdhPJyT11MAFr+atRctrxGDFhZPppeu96ABNsRDpWeDqUQzcnwVPv6g0wxUzzzML4XzNd4YRIlM+w==
X-Received: by 2002:a17:906:2804:: with SMTP id r4mr17127766ejc.521.1614623153232;
        Mon, 01 Mar 2021 10:25:53 -0800 (PST)
Received: from anparri.mshome.net (host-79-55-37-174.retail.telecomitalia.it. [79.55.37.174])
        by smtp.gmail.com with ESMTPSA id x25sm16009245edv.65.2021.03.01.10.25.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 10:25:53 -0800 (PST)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-hyperv@vger.kernel.org,
        decui@microsoft.com, mikelley@microsoft.com,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
Subject: [PATCH net] hv_netvsc: Fix validation in netvsc_linkstatus_callback()
Date:   Mon,  1 Mar 2021 19:25:30 +0100
Message-Id: <20210301182530.194775-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Contrary to the RNDIS protocol specification, certain (pre-Fe)
implementations of Hyper-V's vSwitch did not account for the status
buffer field in the length of an RNDIS packet; the bug was fixed in
newer implementations.  Validate the status buffer fields using the
length of the 'vmtransfer_page' packet (all implementations), that
is known/validated to be less than or equal to the receive section
size and not smaller than the length of the RNDIS message.

Reported-by: Dexuan Cui <decui@microsoft.com>
Suggested-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Fixes: 505e3f00c3f36 ("hv_netvsc: Add (more) validation for untrusted Hyper-V values")
---
 drivers/net/hyperv/hyperv_net.h   |  2 +-
 drivers/net/hyperv/netvsc_drv.c   | 13 +++++++++----
 drivers/net/hyperv/rndis_filter.c |  2 +-
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index e1a497d3c9ba4..59ac04a610adb 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -229,7 +229,7 @@ int netvsc_send(struct net_device *net,
 		bool xdp_tx);
 void netvsc_linkstatus_callback(struct net_device *net,
 				struct rndis_message *resp,
-				void *data);
+				void *data, u32 data_buflen);
 int netvsc_recv_callback(struct net_device *net,
 			 struct netvsc_device *nvdev,
 			 struct netvsc_channel *nvchan);
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 8176fa0c8b168..15f262b70489e 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -744,7 +744,7 @@ static netdev_tx_t netvsc_start_xmit(struct sk_buff *skb,
  */
 void netvsc_linkstatus_callback(struct net_device *net,
 				struct rndis_message *resp,
-				void *data)
+				void *data, u32 data_buflen)
 {
 	struct rndis_indicate_status *indicate = &resp->msg.indicate_status;
 	struct net_device_context *ndev_ctx = netdev_priv(net);
@@ -765,11 +765,16 @@ void netvsc_linkstatus_callback(struct net_device *net,
 	if (indicate->status == RNDIS_STATUS_LINK_SPEED_CHANGE) {
 		u32 speed;
 
-		/* Validate status_buf_offset */
+		/* Validate status_buf_offset and status_buflen.
+		 *
+		 * Certain (pre-Fe) implementations of Hyper-V's vSwitch didn't account
+		 * for the status buffer field in resp->msg_len; perform the validation
+		 * using data_buflen (>= resp->msg_len).
+		 */
 		if (indicate->status_buflen < sizeof(speed) ||
 		    indicate->status_buf_offset < sizeof(*indicate) ||
-		    resp->msg_len - RNDIS_HEADER_SIZE < indicate->status_buf_offset ||
-		    resp->msg_len - RNDIS_HEADER_SIZE - indicate->status_buf_offset
+		    data_buflen - RNDIS_HEADER_SIZE < indicate->status_buf_offset ||
+		    data_buflen - RNDIS_HEADER_SIZE - indicate->status_buf_offset
 				< indicate->status_buflen) {
 			netdev_err(net, "invalid rndis_indicate_status packet\n");
 			return;
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 123cc9d25f5ed..c0e89e107d575 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -620,7 +620,7 @@ int rndis_filter_receive(struct net_device *ndev,
 
 	case RNDIS_MSG_INDICATE:
 		/* notification msgs */
-		netvsc_linkstatus_callback(ndev, rndis_msg, data);
+		netvsc_linkstatus_callback(ndev, rndis_msg, data, buflen);
 		break;
 	default:
 		netdev_err(ndev,
-- 
2.25.1

