Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3788969DCC9
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 10:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbjBUJWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 04:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233293AbjBUJWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 04:22:24 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269F6244BE;
        Tue, 21 Feb 2023 01:22:19 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id p6so2063743pga.0;
        Tue, 21 Feb 2023 01:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/EZWnYloDEoaRjV5o/SIy5u/G2zUnoLIr0TqDfT5RpQ=;
        b=Xky1+2wQA6KguiQ8P+DYx0pRguZw34/LiAMMWbHyyHMhijzxuvuAt6p2cQYIfBJRGG
         C9v3dRenEZmhmvrllDxMl0TjZq7s2Z33T+b8NLFsQGSvnp5PmJvJM9pTzYr7ckH4cUJw
         Pf+t6FsdLOi43jmQ/CqQjpsc4UPfMF7dMVb2668NQC72nTZ2/jhMNE38HDsKDtK6lX+L
         8hIL4nb2MlNDqN3W5fju80jqUnRogl702pfQdo7DNBZIMLMffIpBofwtKyNsyvcdKVcL
         V6xeF4f9K0bmEfdjIIlJSN52UEo5Q6wOuCdQ2MNALbnq2rUxsuPinTh2GfjOLD/MXLYA
         CYJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/EZWnYloDEoaRjV5o/SIy5u/G2zUnoLIr0TqDfT5RpQ=;
        b=0XwoW6j0M8O0kK8l637sy9Sef4s81lgkMsG4jVCCUZ5DliMBwP03gX/jLtfrB1VbZL
         mikWK/SU2pQctPG72q/C9ba1xE+IaEBk/kqFk8vNldie8kS05u1Mu+wuv0N9qhLlxTGo
         neWwltY+es6rBVI+c6732CcgSwPTjLjiYk0n+0q5wqyOvgg68aNFawcL4DHFjTWS8Q/G
         G4gXd9N1J7PJz0A27b+gfQyolj5kyTXI5LX5z7AS5toLYuEWD/uvVFcuXvd8SootC4u2
         aiPU5+Sm+ngOzfK5UeMsIT2e919AxqbEp7MckdiN2m8oVKEy68dclbEQehzYfThzCd7e
         29cA==
X-Gm-Message-State: AO0yUKXBz9gle4w+7GEjBrXCWkNxxJdfjAQOpVYW0DhDiTL9Q+1h/STL
        +e81BHEYDOEvXchNpwcN/LI=
X-Google-Smtp-Source: AK7set9cP8GvUo69qyyw/g8sVHn8jKd/r1RXBIAtu8FyjXYOxxxDneoD53Tdr5lGXeTmFwGoKJr+qQ==
X-Received: by 2002:a05:6a00:1804:b0:5b2:5466:34e1 with SMTP id y4-20020a056a00180400b005b2546634e1mr3783781pfa.3.1676971338564;
        Tue, 21 Feb 2023 01:22:18 -0800 (PST)
Received: from hbh25y.. ([129.227.150.140])
        by smtp.gmail.com with ESMTPSA id x15-20020a62fb0f000000b0058bf2ae9694sm9013971pfm.156.2023.02.21.01.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 01:22:18 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ian.mcdonald@jandi.co.nz, gerrit@erg.abdn.ac.uk
Cc:     dccp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] net: dccp: delete redundant ackvec record in dccp_insert_options()
Date:   Tue, 21 Feb 2023 17:22:06 +0800
Message-Id: <20230221092206.39741-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A useless record can be insert into av_records when dccp_insert_options()
fails after dccp_insert_option_ackvec(). Repeated triggering may cause
av_records to have a lot of useless record with the same avr_ack_seqno.

Fixes: 8b7b6c75c638 ("dccp: Integrate feature-negotiation insertion code")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 net/dccp/options.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/dccp/options.c b/net/dccp/options.c
index d24cad05001e..8aa4abeb15ea 100644
--- a/net/dccp/options.c
+++ b/net/dccp/options.c
@@ -549,6 +549,8 @@ static void dccp_insert_option_padding(struct sk_buff *skb)
 int dccp_insert_options(struct sock *sk, struct sk_buff *skb)
 {
 	struct dccp_sock *dp = dccp_sk(sk);
+	struct dccp_ackvec *av = dp->dccps_hc_rx_ackvec;
+	struct dccp_ackvec_record *avr;
 
 	DCCP_SKB_CB(skb)->dccpd_opt_len = 0;
 
@@ -577,16 +579,22 @@ int dccp_insert_options(struct sock *sk, struct sk_buff *skb)
 
 	if (dp->dccps_hc_rx_insert_options) {
 		if (ccid_hc_rx_insert_options(dp->dccps_hc_rx_ccid, sk, skb))
-			return -1;
+			goto delete_ackvec;
 		dp->dccps_hc_rx_insert_options = 0;
 	}
 
 	if (dp->dccps_timestamp_echo != 0 &&
 	    dccp_insert_option_timestamp_echo(dp, NULL, skb))
-		return -1;
+		goto delete_ackvec;
 
 	dccp_insert_option_padding(skb);
 	return 0;
+
+delete_ackvec:
+	avr = dccp_ackvec_lookup(&av->av_records, DCCP_SKB_CB(skb)->dccpd_seq);
+	list_del(&avr->avr_node);
+	kmem_cache_free(dccp_ackvec_record_slab, avr);
+	return -1;
 }
 
 int dccp_insert_options_rsk(struct dccp_request_sock *dreq, struct sk_buff *skb)
-- 
2.34.1

