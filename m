Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD37A3C336A
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 09:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbhGJHGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 03:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbhGJHGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 03:06:13 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E258AC0613E5;
        Sat, 10 Jul 2021 00:03:27 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id v14so28217866lfb.4;
        Sat, 10 Jul 2021 00:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RoAygn85CqSsjA+ZP3tE/tDUqjjTDbTT9PVg83fTW1Q=;
        b=Qk0M31hpLFQuZ101Z7OCsnl/DFh07uLcSdbJyOMSFQuqHdob7iXbLGmemYWt/lfub5
         EP9sj0t53DYqp1W5+g37adrSfcG0qcwDYdrZHBcy3apVTnmM+Jz2MXLU3kxuPXKa1Y9w
         PNTI0y3bknbuJH8YyX67X7z1T+1R7LZjx61tEPvtHNiljlrvAug2dyit7wb48X73zFgP
         IGdWrEDfByHJ33MLetB6+mIA+CFRvqqqcAMd6Z+esO5ilKyk88pt6gpf3zEWP8I3smlz
         G/ZGtaJs/Pm/Lf2WCtTokYQyQXDw4cWPNx5RWeekJY/pBozggYukO9jOaOzEQ4Pa3Ias
         x0+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RoAygn85CqSsjA+ZP3tE/tDUqjjTDbTT9PVg83fTW1Q=;
        b=ML/wi8iJ2lFOvtBjpmHrM/fopaaWBPF7HdM8CgDAMl1UxTDZ5FqbqZHlt7MsVm+ue3
         +aFvLqLS9B7wfDARtmf+RuQiKywzTRtdIa1OawcofdVNchWBnrYyTkIfQn1+TL9YsqyM
         LV+35Ref5aHaIEfKYo+wkrmoBs0luNPS7nRKoU6WeKSIyipanFd21RNiXCS/nQ3/bKjN
         iBjPx0UXWq0jmtN5d/YOgqte5O8O+GRcIMCgZ4eOiaWISbpQ9CZsUu1bKsc0aMhICVej
         Pu2FbzW4+woYN+HrAK8/j82I+m6Fl+c4LEQpvW/natIlLTpdf3tz4nDjWhtHrA4IW2dq
         +pZQ==
X-Gm-Message-State: AOAM5304sbVui5huUBjN+/0muMVVEamcDTH9euw67lmTJm0IGcTJpBNx
        tS4TH6Ww/0bcdRSoGBpt4FU=
X-Google-Smtp-Source: ABdhPJzu16VvgFv4ofhB8NgsK1+b27btX0redgywactLG0cYGLYM5EsK6UcWcvU+fcDRCFQs/oyaVA==
X-Received: by 2002:a05:6512:4007:: with SMTP id br7mr23604831lfb.271.1625900606277;
        Sat, 10 Jul 2021 00:03:26 -0700 (PDT)
Received: from localhost.localdomain ([94.103.225.155])
        by smtp.gmail.com with ESMTPSA id a1sm616309lff.232.2021.07.10.00.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 00:03:25 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     paul@paul-moore.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH 2/2] net: cipso: fix memory leak in cipso_v4_doi_free
Date:   Sat, 10 Jul 2021 10:03:23 +0300
Message-Id: <cec894625531da243df3a9f05466b83e107e50d7.1625900431.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1625900431.git.paskripkin@gmail.com>
References: <cover.1625900431.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When doi_def->type == CIPSO_V4_MAP_TRANS doi_def->map.std should
be freed to avoid memory leak.

Fail log:

BUG: memory leak
unreferenced object 0xffff88801b936d00 (size 64):
comm "a.out", pid 8478, jiffies 4295042353 (age 15.260s)
hex dump (first 32 bytes):
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00 00 00 00 15 b8 12 26 00 00 00 00 00 00 00 00  .......&........
backtrace:
netlbl_cipsov4_add (net/netlabel/netlabel_cipso_v4.c:145 net/netlabel/netlabel_cipso_v4.c:416)
genl_family_rcv_msg_doit (net/netlink/genetlink.c:741)
genl_rcv_msg (net/netlink/genetlink.c:783 net/netlink/genetlink.c:800)
netlink_rcv_skb (net/netlink/af_netlink.c:2505)
genl_rcv (net/netlink/genetlink.c:813)

Fixes: b1edeb102397 ("netlabel: Replace protocol/NetLabel linking with refrerence
counts")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/ipv4/cipso_ipv4.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index bfaf327e9d12..e0480c6cebaa 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -472,6 +472,7 @@ void cipso_v4_doi_free(struct cipso_v4_doi *doi_def)
 		kfree(doi_def->map.std->lvl.local);
 		kfree(doi_def->map.std->cat.cipso);
 		kfree(doi_def->map.std->cat.local);
+		kfree(doi_def->map.std);
 		break;
 	}
 	kfree(doi_def);
-- 
2.32.0

