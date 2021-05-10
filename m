Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A701E377F8C
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 11:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhEJJkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 05:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbhEJJka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 05:40:30 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E390BC061763
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 02:39:24 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id n2so15931044wrm.0
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 02:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HZeUvAh+ikwDmY/Rpx/0dfPv/y2blsSGC/hug1HK8f4=;
        b=g+hWkqeGFjepemAxYPKAzvNKEJDCNCvG6+KeEY70i3mWYBFfhAUc9hFQ4FoFGuKkEc
         Nz+DIBzk2ttzCcpY+9TECzAZiuOJwnxcfC5lyaUoa6EEyZlrrdH3+y8inZ1LsZASZUxg
         bUatE/X7murdSa3ED9EuWTREHTvKhDL4kpnRCdinw63fDyFiSdnam478ebOOEE7mouw6
         3LvZnwSQDoVJLwk38iN0iTgBhuHAAga+KMsLjFJAj9j3k3QwBUOsZK/U7eeu8tFP3JP0
         eVWgukKJM0lQZqKScTzvIlCFUr13EPDD7JSbyvq1kR2Kj9x1pnRzqqvHg6lKOKzi9TR1
         HcAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HZeUvAh+ikwDmY/Rpx/0dfPv/y2blsSGC/hug1HK8f4=;
        b=UdggLPALjh6+LP7BA3TS0yjgUz6G4gKLpW6q5VOEl+nhF+t9mLtzgaYyEwERrNNWMC
         hgK/n5VuffLAZlvmYq2W2toSShelo/f2mkSBVg9/AhFL68SyqpLmTl9InK56EesmWMJQ
         W7fDMoKJtXhCBFAh67V+XG/CwBKnvuyFS3FMqVlmFiSMhe8iCB1qQGJ9nhUto71gNa7r
         3jZi6hWDV4wSi6629gn3hczHUjCl/P8fztqK+CigDPuwAiAcW23v6C8lpOY93qFSzL5k
         VinoVhe/6lEa6+OLr90bNgXERe4xR311bnwrAVJa3mfIbCVQKwVY4xLLvoBu4NMoi2An
         TJKQ==
X-Gm-Message-State: AOAM532IHT9eI/bdOSwG/Bg0B3mJGMX4zZrFIrhC2+rmPEvOUI6xfdBU
        WHaHLdMMxzd0QHu7e+Mdjm/Kht3Ve6iN9A==
X-Google-Smtp-Source: ABdhPJzfXM86VStYs4heIkT5ntqyyXLWNiqOsHG8TvgoNymz6mpUuml5xVSJJcN4Yt4d7S+LJ4At/g==
X-Received: by 2002:a5d:608a:: with SMTP id w10mr29751980wrt.342.1620639563688;
        Mon, 10 May 2021 02:39:23 -0700 (PDT)
Received: from localhost.localdomain (h-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id i2sm25892933wro.0.2021.05.10.02.39.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 May 2021 02:39:23 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     netdev@vger.kernel.org, brouer@redhat.com
Subject: [PATCH intel-net v2 6/6] igc: add correct exception tracing for XDP
Date:   Mon, 10 May 2021 11:38:54 +0200
Message-Id: <20210510093854.31652-7-magnus.karlsson@gmail.com>
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

Fixes: 73f1071c1d29 ("igc: Add support for XDP_TX action")
Fixes: 4ff320361092 ("igc: Add support for XDP_REDIRECT action")
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 069471b7ffb0..f1adf154ec4a 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2047,20 +2047,19 @@ static struct sk_buff *igc_xdp_run_prog(struct igc_adapter *adapter,
 		break;
 	case XDP_TX:
 		if (igc_xdp_xmit_back(adapter, xdp) < 0)
-			res = IGC_XDP_CONSUMED;
-		else
-			res = IGC_XDP_TX;
+			goto out_failure;
+		res = IGC_XDP_TX;
 		break;
 	case XDP_REDIRECT:
 		if (xdp_do_redirect(adapter->netdev, xdp, prog) < 0)
-			res = IGC_XDP_CONSUMED;
-		else
-			res = IGC_XDP_REDIRECT;
+			goto out_failure;
+		res = IGC_XDP_REDIRECT;
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
 	case XDP_ABORTED:
+out_failure:
 		trace_xdp_exception(adapter->netdev, prog, act);
 		fallthrough;
 	case XDP_DROP:
-- 
2.29.0

