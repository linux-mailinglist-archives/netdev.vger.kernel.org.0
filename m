Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC204300A28
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 18:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729546AbhAVR1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 12:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729251AbhAVPsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 10:48:51 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB85C061356;
        Fri, 22 Jan 2021 07:47:42 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id b26so8119468lff.9;
        Fri, 22 Jan 2021 07:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0kqZW1nBtOtWqAlYCZDluyRBJN4NJNIsym7whQUc+x0=;
        b=kECSjdtfM3Dy4LH4y2a1JtFnPtu2G1UbOJQNe9CcEK3HurNIYFTqnnkJzlUFdBfayQ
         lnRYP5PN1X+wJfp8vmAG4C9Zm/Cqpmd/TqZw804JnuXvhTK9/LWHNvYImRt5RQ4GEWB3
         sBUEko270upAXZB1b3NyY9YUnxBap9TvRO8DXSWQuwESbXr4XK6C7DZGAZBiuqefQKIY
         RAtpmrvzh6BoZysvWX8sGmYr7Mg08BggmFb866YZmTp8+yw0OF1cZHZH53LwwHT5Xwqy
         cfaiCvvY6w30cWfRo6mNxBRs9S4KObmLJueB7RXQZJ35iCeyLdaKdTtqV43qQMbx0Ziq
         iYcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0kqZW1nBtOtWqAlYCZDluyRBJN4NJNIsym7whQUc+x0=;
        b=XSS/FzfHDLuypAEG8497+i7Q9+ka7Zoe2kIeBL7Tbmxb1DlpCAzqSOcpNVP3lXZ9Lm
         +AwRDBdlC7RTpaXDuIDPGP+J8KX54uYNxCLPd0onpVGFxtJl8m467uj3Fcn8gzsQ3SPq
         cWpnBCPtZXK8oHmDot60Lb4m9rzAERySA9TWBPdiIt0cmusJKWIguOE7N+P1y7z8bRKI
         OH3uhcJ1ZNfEq758A7+KGjgElPHy4N6I0310++uScPe8IvC6kVOvI5Q7xtEgmmWOiK6E
         7qR2XIxDCX7h8QkLXa80yFMSV2Gm6KOcRSAKvh7NbveF9lVR4871t5ksjFMyw8t9H84y
         ZGQw==
X-Gm-Message-State: AOAM531iH7JIn5c2sRqKQCsTDOtPNSoVjn8RWUkhOAwmlr63F47Cvxw/
        ApB+3gs35dWKAfjgtvIQCeM=
X-Google-Smtp-Source: ABdhPJyfWM7PoI2RHhEZYYHJgkpW3T/0x9IDPm9+SVENAIy/FpQf6xDhBnw4Y8N4xUtzX7HXtDXgHA==
X-Received: by 2002:a05:6512:909:: with SMTP id e9mr370121lft.359.1611330461355;
        Fri, 22 Jan 2021 07:47:41 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id w17sm928589lft.52.2021.01.22.07.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 07:47:40 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Subject: [PATCH bpf-next 08/12] selftests/bpf: change type from void * to struct generic_data *
Date:   Fri, 22 Jan 2021 16:47:21 +0100
Message-Id: <20210122154725.22140-9-bjorn.topel@gmail.com>
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

Instead of casting from void *, let us use the actual type in
gen_udp_hdr().

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index c2cfc0b6d19e..993ce9b7aa76 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -246,13 +246,13 @@ static void gen_ip_hdr(struct ifobject *ifobject, struct iphdr *ip_hdr)
 	ip_hdr->check = 0;
 }
 
-static void gen_udp_hdr(void *data, struct ifobject *ifobject, struct udphdr *udp_hdr)
+static void gen_udp_hdr(struct generic_data *data, struct ifobject *ifobject,
+			struct udphdr *udp_hdr)
 {
 	udp_hdr->source = htons(ifobject->src_port);
 	udp_hdr->dest = htons(ifobject->dst_port);
 	udp_hdr->len = htons(UDP_PKT_SIZE);
-	memset32_htonl(pkt_data + PKT_HDR_SIZE,
-		       htonl(((struct generic_data *)data)->seqnum), UDP_PKT_DATA_SIZE);
+	memset32_htonl(pkt_data + PKT_HDR_SIZE, htonl(data->seqnum), UDP_PKT_DATA_SIZE);
 }
 
 static void gen_udp_csum(struct udphdr *udp_hdr, struct iphdr *ip_hdr)
@@ -841,7 +841,7 @@ static void *worker_testapp_validate(void *arg)
 				data->seqnum = -1;
 			else
 				data->seqnum = i;
-			gen_udp_hdr((void *)data, ifobject, udp_hdr);
+			gen_udp_hdr(data, ifobject, udp_hdr);
 			gen_ip_hdr(ifobject, ip_hdr);
 			gen_udp_csum(udp_hdr, ip_hdr);
 			gen_eth_hdr(ifobject, eth_hdr);
-- 
2.27.0

