Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D01A3009C0
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 18:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbhAVR2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 12:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729038AbhAVPtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 10:49:03 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA09C06121D;
        Fri, 22 Jan 2021 07:47:47 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id n11so7028386lji.5;
        Fri, 22 Jan 2021 07:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9lypuuFapCkdEuGmqYnc3gh+0SvDvs04apzCvLnPK8w=;
        b=vAj681rSrtdPDrq2yBjvzEPUOgg2fDUR6XMyOpXO+7qSgD+Lq5yKYteP4AgWedEZG0
         T8xjCXrYzI+S6BWHy9r0ObbuwlUrdiDFjXDGSmA9aMQJ1RlzqKMQ96djB+sFu2tPEyn5
         b8Qh6EP1FX31rX+/hALxZHl6Hty/z8gbLYJpr6VSCxwkyVZBXAdPQOATOCtdr/Eunz8n
         MXfedswejUqhfzcl7/hjoSPlDowBy9B+Wli3fNeCO50WoSdai7CyZKZ5OMg23k+fIQEV
         9+aNeSf5V7VSHfypmbipaAMSRAIJZdx+KIJfjH9RmdPer/iOW/qBtixb3sepFflZa/zl
         M1Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9lypuuFapCkdEuGmqYnc3gh+0SvDvs04apzCvLnPK8w=;
        b=b+bh0Hk0DQ+IcmWIcJvtJ8xu2BDpopmY2tNv8fHU7JE4cz8CvqWvB/NtbaoPvcKGPq
         H4qVz42KMFA4Sxn9O4tjwVuvPJSAbvUaaKZfygp9j16cdXgyvD+k3O51a0t92mly1sOv
         UmLq5BOXt2h/AxbaU1z1TJE6cnMZNY6ndVs3xLqUDHFJybGSRTxvs3FQ4pH7Masnmzpw
         fDECnPvqn4SgzFOTuTokH8fZX3/GTezn8iAremR3lzb+9ELo6OVdEfhBrXKCo3x2L0su
         FRh5ebm9h/TWcG9D98a610mgZgIUf7r0wBBwlKR4pfXTW8F5FO9fJYh1N8kQn7gPuao0
         nrIw==
X-Gm-Message-State: AOAM533nVgdNFoXFQLe7ZVFAo5jXkQZXlu723RUZMfrODDh77ieagDDy
        NEae+F08qmNWIHKPEFtPMWo=
X-Google-Smtp-Source: ABdhPJzFf9bpEciMgCRoP5fkXkb6O/kWNbxwfLJI03mUyHkpf+bw6zQaTEVP0gWYGXySbuieLBC2sw==
X-Received: by 2002:a05:651c:1395:: with SMTP id k21mr1762545ljb.225.1611330465960;
        Fri, 22 Jan 2021 07:47:45 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id w17sm928589lft.52.2021.01.22.07.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 07:47:45 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Subject: [PATCH bpf-next 11/12] selftests/bpf: consistent malloc/calloc usage
Date:   Fri, 22 Jan 2021 16:47:24 +0100
Message-Id: <20210122154725.22140-12-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210122154725.22140-1-bjorn.topel@gmail.com>
References: <20210122154725.22140-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Use calloc instead of malloc where it makes sense, and avoid C++-style
void *-cast.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 2da59b142c03..a64e2a929e70 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -411,7 +411,7 @@ static int validate_interfaces(void)
 		if (strcmp(ifdict[i]->nsname, "")) {
 			struct targs *targs;
 
-			targs = (struct targs *)malloc(sizeof(struct targs));
+			targs = malloc(sizeof(*targs));
 			if (!targs)
 				exit_with_error(errno);
 
@@ -578,7 +578,7 @@ static void rx_pkt(struct xsk_socket_info *xsk, struct pollfd *fds)
 		if (!pkt_node_rx)
 			exit_with_error(errno);
 
-		pkt_node_rx->pkt_frame = (char *)malloc(PKT_SIZE);
+		pkt_node_rx->pkt_frame = malloc(PKT_SIZE);
 		if (!pkt_node_rx->pkt_frame)
 			exit_with_error(errno);
 
@@ -739,8 +739,8 @@ static void worker_pkt_validate(void)
 		if (iphdr->version == IP_PKT_VER && iphdr->tos == IP_PKT_TOS) {
 			payloadseqnum = *((uint32_t *)(pkt_node_rx_q->pkt_frame + PKT_HDR_SIZE));
 			if (debug_pkt_dump && payloadseqnum != EOT) {
-				pkt_obj = (struct pkt_frame *)malloc(sizeof(struct pkt_frame));
-				pkt_obj->payload = (char *)malloc(PKT_SIZE);
+				pkt_obj = malloc(sizeof(*pkt_obj));
+				pkt_obj->payload = malloc(PKT_SIZE);
 				memcpy(pkt_obj->payload, pkt_node_rx_q->pkt_frame, PKT_SIZE);
 				pkt_buf[payloadseqnum] = pkt_obj;
 			}
@@ -865,7 +865,7 @@ static void *worker_testapp_validate(void *arg)
 
 		TAILQ_INIT(&head);
 		if (debug_pkt_dump) {
-			pkt_buf = malloc(sizeof(struct pkt_frame **) * num_frames);
+			pkt_buf = calloc(num_frames, sizeof(*pkt_buf));
 			if (!pkt_buf)
 				exit_with_error(errno);
 		}
@@ -1017,7 +1017,7 @@ int main(int argc, char **argv)
 	u16 UDP_DST_PORT = 2020;
 	u16 UDP_SRC_PORT = 2121;
 
-	ifaceconfig = (struct ifaceconfigobj *)malloc(sizeof(struct ifaceconfigobj));
+	ifaceconfig = malloc(sizeof(struct ifaceconfigobj));
 	memcpy(ifaceconfig->dst_mac, MAC1, ETH_ALEN);
 	memcpy(ifaceconfig->src_mac, MAC2, ETH_ALEN);
 	inet_aton(IP1, &ifaceconfig->dst_ip);
@@ -1026,7 +1026,7 @@ int main(int argc, char **argv)
 	ifaceconfig->src_port = UDP_SRC_PORT;
 
 	for (int i = 0; i < MAX_INTERFACES; i++) {
-		ifdict[i] = (struct ifobject *)malloc(sizeof(struct ifobject));
+		ifdict[i] = malloc(sizeof(struct ifobject));
 		if (!ifdict[i])
 			exit_with_error(errno);
 
-- 
2.27.0

