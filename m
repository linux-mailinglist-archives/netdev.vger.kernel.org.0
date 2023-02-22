Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C53BD69EEB8
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 07:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjBVGZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 01:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjBVGZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 01:25:13 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6EE305DD;
        Tue, 21 Feb 2023 22:25:11 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id fb30so3798047pfb.13;
        Tue, 21 Feb 2023 22:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677047111;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZUkSCOgP1pQ/sRF4XzTkmdJMDTT5vWZNyAKvDSz1t10=;
        b=hLI46EWN7KGmRixgMRTVId+u3y/Tel42OaC4VAX16Yr/6z8v/9KQiZ5DXIwO19ylqr
         RUpmopnsLWU/Kn4LbS7yORtlIDxa1n79idbyK5bm6owFKRKpRPfrsbX3qdqBOAcR/c1C
         c1oFcu0dZKqt5a0Cj8nXBohaYRX01PI3Gmgyop8hexoSuxvELZlKGPUT5wGUeX5fZ7zt
         699gGqLylIOqzaMpxpBFSbAR4+P3zEbxiUcCPk6PLGnetRInkpZXjXyxI0yWJFeEcfj9
         kpIN12YyXUpvhUAejx05i4zmerxx4UhxbrAzP+Uxrzx44Zx1W1YqZVPYyXkqVqJ90QfC
         Cpfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677047111;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZUkSCOgP1pQ/sRF4XzTkmdJMDTT5vWZNyAKvDSz1t10=;
        b=U0Mrh+GiAsAR5v/TMHyA9HseSM1z4LmahtJPGuVjZJgoeTjI+kqNC8RRw8CQf6d9TD
         zQ1xvPp5cjx99oOHqtMCZvUfIv0bNgho56QGO8TLg89BUG+8cLRH5peWbA1HgvB1yPF2
         Uevj52QL3lhwcLy5KfW1SEJAMPtTYATdUDnJPztVSvKinBYY1NizWiiQ1IGtkDClPjny
         MzQL22uTOhraZGq4Phryeo3XtYE6uwM9lgXSQ5Kw2ndb+I0TYKn38urqeoRJyS+gbEf/
         WMqvixv+aJ3/wST5l0Z39fcxCWL2HzHou+86fxXIn6tOuDmcCO+SYvTwcm3K9vORzD02
         F+EA==
X-Gm-Message-State: AO0yUKW2kq2441sdJF0ajb0AW62gY8u9Y1UjZw7NiEfE4xsUfJL2PPX3
        Sk65GK4GoXUSSa8SjlsuhwU=
X-Google-Smtp-Source: AK7set84Y8A/lfsQN2SKJ4qey11jx5G1ybF0RVr3OjO0JbqTciiwRKmVtz7WDmfQlgj8zJGSkXaO9A==
X-Received: by 2002:a05:6a00:23c3:b0:5a8:c179:7b02 with SMTP id g3-20020a056a0023c300b005a8c1797b02mr7736218pfc.1.1677047110766;
        Tue, 21 Feb 2023 22:25:10 -0800 (PST)
Received: from hbh25y.. ([129.227.150.140])
        by smtp.gmail.com with ESMTPSA id x16-20020aa793b0000000b005a8de0f4c76sm5654758pff.17.2023.02.21.22.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 22:25:10 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, gerrit@erg.abdn.ac.uk, ian.mcdonald@jandi.co.nz
Cc:     dccp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH v2] net: dccp: delete redundant ackvec record in dccp_insert_options()
Date:   Wed, 22 Feb 2023 14:24:57 +0800
Message-Id: <20230222062457.630849-1-hbh25y@gmail.com>
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

	v2: add a new function to delete the redundant ackvec record

 net/dccp/ackvec.c  | 17 +++++++++++++++++
 net/dccp/ackvec.h  |  1 +
 net/dccp/options.c |  8 ++++++--
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/net/dccp/ackvec.c b/net/dccp/ackvec.c
index c4bbac99740d..59b7209c6194 100644
--- a/net/dccp/ackvec.c
+++ b/net/dccp/ackvec.c
@@ -273,6 +273,23 @@ void dccp_ackvec_input(struct dccp_ackvec *av, struct sk_buff *skb)
 	}
 }
 
+/**
+ * dccp_ackvec_delete  -  delete an Ack Vector record
+ * @av: Ack Vector records to delete
+ * @ackno: Ack Vector which needs to be deleted
+ */
+void dccp_ackvec_delete(struct dccp_ackvec *av, const u64 ackno)
+{
+	struct dccp_ackvec_record *avr;
+
+	avr = dccp_ackvec_lookup(&av->av_records, ackno);
+	if (!avr)
+		return;
+
+	list_del(&avr->avr_node);
+	kmem_cache_free(dccp_ackvec_record_slab, avr);
+}
+
 /**
  * dccp_ackvec_clear_state  -  Perform house-keeping / garbage-collection
  * @av: Ack Vector record to clean
diff --git a/net/dccp/ackvec.h b/net/dccp/ackvec.h
index d2c4220fb377..73636971448e 100644
--- a/net/dccp/ackvec.h
+++ b/net/dccp/ackvec.h
@@ -106,6 +106,7 @@ struct dccp_ackvec *dccp_ackvec_alloc(const gfp_t priority);
 void dccp_ackvec_free(struct dccp_ackvec *av);
 
 void dccp_ackvec_input(struct dccp_ackvec *av, struct sk_buff *skb);
+void dccp_ackvec_delete(struct dccp_ackvec *av, const u64 ackno);
 int dccp_ackvec_update_records(struct dccp_ackvec *av, u64 seq, u8 sum);
 void dccp_ackvec_clear_state(struct dccp_ackvec *av, const u64 ackno);
 u16 dccp_ackvec_buflen(const struct dccp_ackvec *av);
diff --git a/net/dccp/options.c b/net/dccp/options.c
index d24cad05001e..88c966111662 100644
--- a/net/dccp/options.c
+++ b/net/dccp/options.c
@@ -549,6 +549,7 @@ static void dccp_insert_option_padding(struct sk_buff *skb)
 int dccp_insert_options(struct sock *sk, struct sk_buff *skb)
 {
 	struct dccp_sock *dp = dccp_sk(sk);
+	struct dccp_ackvec *av = dp->dccps_hc_rx_ackvec;
 
 	DCCP_SKB_CB(skb)->dccpd_opt_len = 0;
 
@@ -577,16 +578,19 @@ int dccp_insert_options(struct sock *sk, struct sk_buff *skb)
 
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
+delete_ackvec:
+	dccp_ackvec_delete(av, DCCP_SKB_CB(skb)->dccpd_seq);
+	return -1;
 }
 
 int dccp_insert_options_rsk(struct dccp_request_sock *dreq, struct sk_buff *skb)
-- 
2.34.1

