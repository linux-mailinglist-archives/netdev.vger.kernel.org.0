Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA73434A60
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 13:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbhJTLpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 07:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbhJTLpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 07:45:12 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9696C06161C;
        Wed, 20 Oct 2021 04:42:57 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id o24so10883576wms.0;
        Wed, 20 Oct 2021 04:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BVbj6TaOsr4rxLwKq9bcR93AYWU6cVnnmfHGXV7O8mI=;
        b=BwdErdW5t6kkTAQm130ei717SRvHJSElJkgMdzaQnRGItGJDI8nH6szPgz7Lh4H8wf
         +i1v9401CrCC0cPyyz6B463pEmerv70tsBCNmGjHbTWNqu5HXTjHcYv9NOshz1HXHaBC
         tVaJcjs8e7iVqbtTQfKbcAbjfvc3Z+xvWsbuBhkfMKtggNileTc4+r5Pcnb8QPH8Xwbk
         CLqA434oABkpTLtCzGQ9PtY58poKpIDs/oo2/kq+lVXBSuijVrBIGuiUtbOLHgwqT2PH
         6zOKIw1w2KYR8+2TtwxRsyfCuzb7phnhWeFH0bVJZ3EzPnTmue/oILgV8qL+qT31CPfQ
         A8tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BVbj6TaOsr4rxLwKq9bcR93AYWU6cVnnmfHGXV7O8mI=;
        b=uopOEF50bEj+0PUaVjkPP/auCCcbKrZ+5FIGz5MUoaSCk7emmyD+WaLMP/JmafQF/w
         4mOk6zgLW95Eyffhxx9AxOPiL9u96sFAJ/nQccPql3voT6yGo3RuojNMCygF5rJUco/w
         X+2JUh3wcS2E/A1ZVLCqPuT10y/h7+wvK4VoNXYNPPZijoA9OKVf0KgDQ3XAsFCy8Oa/
         sagMJ3nvfjFG+lAX11g2hRv8WnloyWTO1y7vwzdvkwP4+k+rlFf1OLjw7r4//xdTb32w
         Kgzewx9DsNeIETor8Rovenf0DVOJtn36nyypiu69eN4+84v1nYnsJR/WKBRtReP1+L6B
         1fzg==
X-Gm-Message-State: AOAM530DuCh7se0tkb6opPph82yax+cwU/2axYOyauxLnverstgk7U2U
        SF7aE8vgURfOUBTmnb+GG17UU35kJ0wkuA==
X-Google-Smtp-Source: ABdhPJyTv34ggSvPyNAGR++FJKvpkbgn8ai/AC3byvunIQ1sN/AHmLtjc7lrHvzpnvA3U0bwXcz2AA==
X-Received: by 2002:a1c:f213:: with SMTP id s19mr12944016wmc.169.1634730176247;
        Wed, 20 Oct 2021 04:42:56 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 186sm4988989wmc.20.2021.10.20.04.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 04:42:56 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        michael.tuexen@lurchi.franken.de
Subject: [PATCH net 4/7] sctp: fix the processing for COOKIE_ECHO chunk
Date:   Wed, 20 Oct 2021 07:42:44 -0400
Message-Id: <98522f9dfeafa25682b9ce55a93e1503287b2868.1634730082.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1634730082.git.lucien.xin@gmail.com>
References: <cover.1634730082.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. In closed state: in sctp_sf_do_5_1D_ce():

  When asoc is NULL, making packet for abort will use chunk's vtag
  in sctp_ootb_pkt_new(). But when asoc exists, vtag from the chunk
  should be verified before using peer.i.init_tag to make packet
  for abort in sctp_ootb_pkt_new(), and just discard it if vtag is
  not correct.

2. In the other states: in sctp_sf_do_5_2_4_dupcook():

  asoc always exists, but duplicate cookie_echo's vtag will be
  handled by sctp_tietags_compare() and then take actions, so before
  that we only verify the vtag for the abort sent for invalid chunk
  length.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statefuns.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 672e5308839b..96a069d725e9 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -710,6 +710,9 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 	struct sock *sk;
 	int error = 0;
 
+	if (asoc && !sctp_vtag_verify(chunk, asoc))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* If the packet is an OOTB packet which is temporarily on the
 	 * control endpoint, respond with an ABORT.
 	 */
@@ -724,7 +727,8 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 	 * in sctp_unpack_cookie().
 	 */
 	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_chunkhdr)))
-		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
+						  commands);
 
 	/* If the endpoint is not listening or if the number of associations
 	 * on the TCP-style socket exceed the max backlog, respond with an
@@ -2204,9 +2208,11 @@ enum sctp_disposition sctp_sf_do_5_2_4_dupcook(
 	 * enough for the chunk header.  Cookie length verification is
 	 * done later.
 	 */
-	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_chunkhdr)))
-		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
-						  commands);
+	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_chunkhdr))) {
+		if (!sctp_vtag_verify(chunk, asoc))
+			asoc = NULL;
+		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg, commands);
+	}
 
 	/* "Decode" the chunk.  We have no optional parameters so we
 	 * are in good shape.
-- 
2.27.0

