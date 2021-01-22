Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745643009C4
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 18:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbhAVR3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 12:29:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729283AbhAVPt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 10:49:26 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F1AC06121C;
        Fri, 22 Jan 2021 07:47:45 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id b26so8119685lff.9;
        Fri, 22 Jan 2021 07:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UNnUlBe99LdDA4M1w7ZyuRqsbUedR9JBc0FKV+8YSIA=;
        b=nQnkW7SX3zSxlVPRi+TOB0BjJAOJOtyNtW7KZpQbeM7zzU7BIZTuvr+UaewQbtBSJc
         SxZGE0ms8uNbidwrc4nn6GlSlcx4UqAY2DIacctD0RWDIOXXAjsZH44cg3e60iBHgtB4
         x9y3Yi9PemysBc9WVz344hwjg1zXEeALaJOVV7wk46TDAz9N+7yIiJ+f0M07CmfPzIxl
         CAHHtiRgXYkyW7t6MmaDo43Ua04mNjx9tNCUUBEcVFrNrSMPVFehy5WVWbOy/dZnOvjN
         K5vJVdWhASxRU7N5bM6eFnXEZUpl9fiDT2SqN6ak8WECxCXLUwM6IaFjMcdVZHh9RsuM
         bZSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UNnUlBe99LdDA4M1w7ZyuRqsbUedR9JBc0FKV+8YSIA=;
        b=N7NzM4oguoA2V2Ee38zp4/ITyJhh5l/cmMcFnBQTWURmrmhJleJyOgV5U8FWC3LalX
         QOqfCq2e7hUV4xzKQZ1qLXKLqPg803yXTYBh2V9k00gqq/BP4WwJzHx1QVBBPJnoPdeP
         1U1nONvJngLPnnREqxHAvwe3BkqQW/uh+U0NdzUeJ8euyWF3xDnlM90+Xm5SYlVq/k06
         1sRIbz2b9NAgWBy5toIQzYbZ+MjkyW8WMnyY3n0Mz6I0YPQUH6M+dYkIkrciMpxTOqgL
         6B76VLlsYgEO3Sq0xcAuvA61rLUJzbxpleJLYkeY5QLcHpnGAt+Gh618933kvEOo6sB8
         Dibg==
X-Gm-Message-State: AOAM533bADX+1Sqe+2f37KkkPVO9/N/Xb6iBlp7XT6zBI8frpXqllpfH
        Ethj8mIvZ8EHEOZf4m1DDrI=
X-Google-Smtp-Source: ABdhPJz/48D0xBVgV0J3bWPZAg+5dn+jEzdcUFXrW1ytaOxObNtGn3s7HeQcRsWgZ+b5Ec/EJJpc7w==
X-Received: by 2002:a19:4f4f:: with SMTP id a15mr851516lfk.309.1611330464338;
        Fri, 22 Jan 2021 07:47:44 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id w17sm928589lft.52.2021.01.22.07.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 07:47:43 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Subject: [PATCH bpf-next 10/12] selftests/bpf: avoid heap allocation
Date:   Fri, 22 Jan 2021 16:47:23 +0100
Message-Id: <20210122154725.22140-11-bjorn.topel@gmail.com>
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

The data variable is only used locally. Instead of using the heap,
stick to using the stack.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 34bdcae9b908..2da59b142c03 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -807,10 +807,10 @@ static void *worker_testapp_validate(void *arg)
 {
 	struct udphdr *udp_hdr =
 	    (struct udphdr *)(pkt_data + sizeof(struct ethhdr) + sizeof(struct iphdr));
-	struct generic_data *data = (struct generic_data *)malloc(sizeof(struct generic_data));
 	struct iphdr *ip_hdr = (struct iphdr *)(pkt_data + sizeof(struct ethhdr));
 	struct ethhdr *eth_hdr = (struct ethhdr *)pkt_data;
 	struct ifobject *ifobject = (struct ifobject *)arg;
+	struct generic_data data;
 	void *bufs = NULL;
 
 	pthread_attr_setstacksize(&attr, THREAD_STACK);
@@ -840,17 +840,16 @@ static void *worker_testapp_validate(void *arg)
 		for (int i = 0; i < num_frames; i++) {
 			/*send EOT frame */
 			if (i == (num_frames - 1))
-				data->seqnum = -1;
+				data.seqnum = -1;
 			else
-				data->seqnum = i;
-			gen_udp_hdr(data, ifobject, udp_hdr);
+				data.seqnum = i;
+			gen_udp_hdr(&data, ifobject, udp_hdr);
 			gen_ip_hdr(ifobject, ip_hdr);
 			gen_udp_csum(udp_hdr, ip_hdr);
 			gen_eth_hdr(ifobject, eth_hdr);
 			gen_eth_frame(ifobject->umem, i * XSK_UMEM__DEFAULT_FRAME_SIZE);
 		}
 
-		free(data);
 		ksft_print_msg("Sending %d packets on interface %s\n",
 			       (opt_pkt_count - 1), ifobject->ifname);
 		tx_only_all(ifobject);
-- 
2.27.0

