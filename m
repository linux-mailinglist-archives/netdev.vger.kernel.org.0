Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1C3377F8B
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 11:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhEJJkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 05:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbhEJJk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 05:40:28 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2F4C061574
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 02:39:23 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id y124-20020a1c32820000b029010c93864955so10752679wmy.5
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 02:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6+LTRB3VeUFqK10wpr4zxmf6+vUY37t/15OeIVQYx0c=;
        b=TzJR5KOFFl9YqEnH/MEwkVADy+gytZMw3a1UlDM1riIoHbLyRlQGfuK1g4Cz3NZWXx
         zOYeMiyNPxlBVQ9nLQsdtG6ePRAQ0cxBa+l+Pot50fyOrxnJhzlKZSCaGR6fZtcNUPQR
         0zAwye4vRwnTq0xPeGJq/koVWlk2PEB9PiKS0NlMrJH3PEm/fX0zL6QK6j22D7v3Y/E/
         ZNmdbpWbpUNSNR4qIBkeE6B2W/FSIC/D55YP/j2jqqpT00neN7Fl9LUjKeG6oraBsGxB
         Qn61siwM9Fuu1+Z+77tI1x+n+yUgWKsNcIS8+ywH6Zw6P2YfkqSTTJ2Rt8eukxFcAI+k
         JV8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6+LTRB3VeUFqK10wpr4zxmf6+vUY37t/15OeIVQYx0c=;
        b=lWGRO3cjnRjwXK6tMGOBp+ndDatlAzSGx7ScC01Qo4ceKQ5skayJnZFYyAxBcm5vM0
         V/h2f3t7gN+41dde/LYyJZbe7bXMHaMmxqPk5s7rPcVqTv40sEv5rexvw336cV8KMSvo
         y3b/6ui+4BR4GpmO7nysdUuKHbuAW4SXt+G4q8UWRc/M5Ih3DIWwPgONKHAib/JApI7k
         uMtJ3LPNSmCPrZveJxpPeMkbf5WlenfRI2GXMf6O6svlmgTwBusCK44EI0CBL3VDMCJ9
         ETLpQ3RwbJnrSVppVQSW5OtRnAP3pU1g4PLuyElD3p1OkJlvKKaQwAcd0+lWBl6+t1Dh
         TQ7Q==
X-Gm-Message-State: AOAM531HzobdlH4hzrxm3ax3VAxUY2B/yMmWmAaTVNc0tma63WC6x6/2
        QY02YGBeS6/pESwxgt1aFc8=
X-Google-Smtp-Source: ABdhPJw4IDSVTCDH95Xq0Ef9vi4FdUcD02zRAsTdyPWRHyY6/xpHdSOZoI9y9/QzBQosRl5dYlOWsg==
X-Received: by 2002:a1c:f705:: with SMTP id v5mr34937718wmh.69.1620639562547;
        Mon, 10 May 2021 02:39:22 -0700 (PDT)
Received: from localhost.localdomain (h-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id i2sm25892933wro.0.2021.05.10.02.39.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 May 2021 02:39:22 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     netdev@vger.kernel.org, brouer@redhat.com
Subject: [PATCH intel-net v2 5/6] ixgbevf: add correct exception tracing for XDP
Date:   Mon, 10 May 2021 11:38:53 +0200
Message-Id: <20210510093854.31652-6-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210510093854.31652-1-magnus.karlsson@gmail.com>
References: <20210510093854.31652-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add missing exception tracing to XDP when a number of different
errors can occur. The support was only partial. Several errors
where not logged which would confuse the user quite a lot not
knowing where and why the packets disappeared.

Fixes: 21092e9ce8b1 ("ixgbevf: Add support for XDP_TX action")
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index ba2ed8a43d2d..0e733cc15c58 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -1067,11 +1067,14 @@ static struct sk_buff *ixgbevf_run_xdp(struct ixgbevf_adapter *adapter,
 	case XDP_TX:
 		xdp_ring = adapter->xdp_ring[rx_ring->queue_index];
 		result = ixgbevf_xmit_xdp_ring(xdp_ring, xdp);
+		if (result == IXGBEVF_XDP_CONSUMED)
+			goto out_failure;
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
 	case XDP_ABORTED:
+out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		fallthrough; /* handle aborts by dropping packet */
 	case XDP_DROP:
-- 
2.29.0

