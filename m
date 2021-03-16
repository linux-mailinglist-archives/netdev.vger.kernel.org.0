Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D5533DC54
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 19:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239847AbhCPSOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 14:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239916AbhCPSN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 14:13:27 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507F6C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 11:13:27 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id c10so73670458ejx.9
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 11:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tfnqgA69l95OzR61vRkmYo53EzSzWKDDyx/WHMJRznw=;
        b=NoRVZW7KIFYdWE8s1sVCdoH6NkkGhHvcsP5sAE4TKx7E91NfTTPf0zY1LxKmQld4NJ
         iUUGfCj1byTQdlJbLM/s+kFBg0oLO1P4IQvTo3habTyh0puc9HqAe5FviGNK2xfEGo+G
         wv0xbetFPQEa6yi7cA9wM33xODAvwy1MTt0kLPLW4LKbde3NcfSpX/NAjoebzq0hQ11h
         kiL0GN9FeRXQ34/zz0yZrqU3Q9OrWkKva2xBhpusB9xxori/iOHSevdOLqmy3wYwDXTR
         64IW8k//CI568pF3iSWxKfPi5I6hh3oRoAc20KNAhDYyjqoMu0sgQmXNFmKLVeFpJ6Gt
         GB1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tfnqgA69l95OzR61vRkmYo53EzSzWKDDyx/WHMJRznw=;
        b=dvzrWWfCs3tV3uQ2tCskEnFEFDnczNjdle1weNNHmZOeEKHjPJjnqePs6DCPjXlfy0
         NlwUCmqt7t9EkcmoyqwJnEM1EfRlKCiiZjoDjbcEsijNIa4JHl1Gzv2CwnYZSgc4L6sK
         q8N9pkSROOqwnTbuK3NNe7SBbW4R0kn/doG8E9gdq7eRgkDheAh9MgebsAuukcnx6tiV
         tX9UlaPBcWKAp/8SRiHWXeM9iO5oE8v/3SyQTekvjNYT/8kXsiKuQiHtDvmoH2fjRHUX
         6PyigOOv2geCwXDvI1+LuuBt7YZwfXTsXQsLCVmMj8eND0OiEGpCFlf1GRY/kRrZtTKZ
         mQew==
X-Gm-Message-State: AOAM53158nNVkJl5L7S9e4mWCjl0UxqUrDlX83pgPfYKQEmhrcYJ5Bk9
        RL5jsmKyBZHJw4opHVeLMorlEA==
X-Google-Smtp-Source: ABdhPJwpBa1ffNqwiW75ZAi2ZguFivAQg5XpUcy8jPT/9K1Qv0v+ztxYx8AYLTf3yYGyske3++CCnw==
X-Received: by 2002:a17:906:eda3:: with SMTP id sa3mr31233962ejb.147.1615918406013;
        Tue, 16 Mar 2021 11:13:26 -0700 (PDT)
Received: from madeliefje.horms.nl ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id e26sm11537778edj.29.2021.03.16.11.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 11:13:25 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net 3/3] nfp: flower: fix pre_tun mask id allocation
Date:   Tue, 16 Mar 2021 19:13:10 +0100
Message-Id: <20210316181310.12199-4-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210316181310.12199-1-simon.horman@netronome.com>
References: <20210316181310.12199-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

pre_tun_rule flows does not follow the usual add-flow path, instead
they are used to update the pre_tun table on the firmware. This means
that if the mask-id gets allocated here the firmware will never see the
"NFP_FL_META_FLAG_MANAGE_MASK" flag for the specific mask id, which
triggers the allocation on the firmware side. This leads to the firmware
mask being corrupted and causing all sorts of strange behaviour.

Fixes: f12725d98cbe ("nfp: flower: offload pre-tunnel rules")
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 .../ethernet/netronome/nfp/flower/metadata.c  | 24 +++++++++++++------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/metadata.c b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
index 5defd31d481c..aa06fcb38f8b 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/metadata.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
@@ -327,8 +327,14 @@ int nfp_compile_flow_metadata(struct nfp_app *app,
 		goto err_free_ctx_entry;
 	}
 
+	/* Do net allocate a mask-id for pre_tun_rules. These flows are used to
+	 * configure the pre_tun table and are never actually send to the
+	 * firmware as an add-flow message. This causes the mask-id allocation
+	 * on the firmware to get out of sync if allocated here.
+	 */
 	new_mask_id = 0;
-	if (!nfp_check_mask_add(app, nfp_flow->mask_data,
+	if (!nfp_flow->pre_tun_rule.dev &&
+	    !nfp_check_mask_add(app, nfp_flow->mask_data,
 				nfp_flow->meta.mask_len,
 				&nfp_flow->meta.flags, &new_mask_id)) {
 		NL_SET_ERR_MSG_MOD(extack, "invalid entry: cannot allocate a new mask id");
@@ -359,7 +365,8 @@ int nfp_compile_flow_metadata(struct nfp_app *app,
 			goto err_remove_mask;
 		}
 
-		if (!nfp_check_mask_remove(app, nfp_flow->mask_data,
+		if (!nfp_flow->pre_tun_rule.dev &&
+		    !nfp_check_mask_remove(app, nfp_flow->mask_data,
 					   nfp_flow->meta.mask_len,
 					   NULL, &new_mask_id)) {
 			NL_SET_ERR_MSG_MOD(extack, "invalid entry: cannot release mask id");
@@ -374,8 +381,10 @@ int nfp_compile_flow_metadata(struct nfp_app *app,
 	return 0;
 
 err_remove_mask:
-	nfp_check_mask_remove(app, nfp_flow->mask_data, nfp_flow->meta.mask_len,
-			      NULL, &new_mask_id);
+	if (!nfp_flow->pre_tun_rule.dev)
+		nfp_check_mask_remove(app, nfp_flow->mask_data,
+				      nfp_flow->meta.mask_len,
+				      NULL, &new_mask_id);
 err_remove_rhash:
 	WARN_ON_ONCE(rhashtable_remove_fast(&priv->stats_ctx_table,
 					    &ctx_entry->ht_node,
@@ -406,9 +415,10 @@ int nfp_modify_flow_metadata(struct nfp_app *app,
 
 	__nfp_modify_flow_metadata(priv, nfp_flow);
 
-	nfp_check_mask_remove(app, nfp_flow->mask_data,
-			      nfp_flow->meta.mask_len, &nfp_flow->meta.flags,
-			      &new_mask_id);
+	if (!nfp_flow->pre_tun_rule.dev)
+		nfp_check_mask_remove(app, nfp_flow->mask_data,
+				      nfp_flow->meta.mask_len, &nfp_flow->meta.flags,
+				      &new_mask_id);
 
 	/* Update flow payload with mask ids. */
 	nfp_flow->unmasked_data[NFP_FL_MASK_ID_LOCATION] = new_mask_id;
-- 
2.20.1

