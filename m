Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87FA962C96B
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbiKPUBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235013AbiKPUBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:01:36 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5CB63CC0;
        Wed, 16 Nov 2022 12:01:33 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id i12so12663079qvs.2;
        Wed, 16 Nov 2022 12:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aOiKBaDvQLb2jhb8/1noUpn7T84J17mtkV+rkYECE5w=;
        b=LjJpGAcdrmYcw46SC4AiN878gUOQ1HZeSN6KlEZ8xdc/D2XcFX3AP5heWmlkCROICK
         8AC1p81IOF6nLPNYD38KyjlGfZaWXwTjbEnOHqNsouxnadJpLJo3blDo4RhxoULlPwV3
         F2DdInjX+sglfxnNcXxKiexjDvMKImfk7TtqmTfip5xP1kuC4O6tTmJ+6wD2RT+M902u
         JI1KLYSWT/46tW42R6Z2W2Qw1BkLTgdytu8QMT/oM0oVmRBbisBuYn/ougnsZXDP+7mL
         9rSRRkhQo7umK1Uq0o2RK3D6i/V3fDV+OK9u5Ag0IhiBY5hMvUGyfyk/Uok0JJEA5i6m
         vbMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aOiKBaDvQLb2jhb8/1noUpn7T84J17mtkV+rkYECE5w=;
        b=qMGXz7Py2SePyoKmLZNsJlqqgsIYfSWSTtVmkuc0VCgTHUEbDg+5qEbByPO6Th4ZBa
         bgvYYp9WYYaSxZEOQKNfkJrkPz1XCJZ1DuLZptMVj73R5wzG/edAmqWwQ5/3AIhsaKpj
         4SdxeRzHMp6YwnRvVCyOYWd5ETDIpOU0KsBA688Z/NfgRt0/r1IQ8QMFSNU1P9+RIgvq
         gvpnverXq+Ism2DkRn8VgoMRiHQo0FnVUkEKfIEb14kXr87YH4rtiYx4GhuMUXsycIqt
         REpO9bFciAXvQLvmdmBPaURz9KDCfZaOKPGgSwXuGoFpWbBvQ4RJggjtf8ISgsAdZV5K
         x5uw==
X-Gm-Message-State: ANoB5pm1VMZpj8eQE4n4jCWFsNecIIE7NsK2xzrQ68nS/2Z2FF0Eb4SI
        MWIHkzliZ9U4aaam9mOYlrVhxemeEkmKhw==
X-Google-Smtp-Source: AA0mqf433HccYRNhVdnl42CcseaSd/JYL1WIU4zvLyg94nzU1X14BMjU55uTDCqXb9XsFUOSjVY1wQ==
X-Received: by 2002:a05:6214:3185:b0:4c6:5682:8878 with SMTP id lb5-20020a056214318500b004c656828878mr8982965qvb.5.1668628893079;
        Wed, 16 Nov 2022 12:01:33 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id d7-20020a05620a240700b006fba44843a5sm2900411qkn.52.2022.11.16.12.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 12:01:32 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Ahern <dsahern@gmail.com>,
        Carlo Carraro <colrack@gmail.com>
Subject: [PATCHv2 net-next 4/7] sctp: add skb_sdif in struct sctp_af
Date:   Wed, 16 Nov 2022 15:01:19 -0500
Message-Id: <219e9965f3f8d3f41a8c448a3d0ef19b8dc2bc57.1668628394.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1668628394.git.lucien.xin@gmail.com>
References: <cover.1668628394.git.lucien.xin@gmail.com>
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

Add skb_sdif function in struct sctp_af to get the enslaved device
for both ipv4 and ipv6 when adding SCTP VRF support in sctp_rcv in
the next patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h | 1 +
 net/sctp/ipv6.c            | 8 +++++++-
 net/sctp/protocol.c        | 6 ++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 350f250b0dc7..7b4884c63b26 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -477,6 +477,7 @@ struct sctp_af {
 	int		(*available)	(union sctp_addr *,
 					 struct sctp_sock *);
 	int		(*skb_iif)	(const struct sk_buff *sk);
+	int		(*skb_sdif)(const struct sk_buff *sk);
 	int		(*is_ce)	(const struct sk_buff *sk);
 	void		(*seq_dump_addr)(struct seq_file *seq,
 					 union sctp_addr *addr);
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index e6274cdbdf6c..097bd60ce964 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -842,7 +842,12 @@ static int sctp_v6_addr_to_user(struct sctp_sock *sp, union sctp_addr *addr)
 /* Where did this skb come from?  */
 static int sctp_v6_skb_iif(const struct sk_buff *skb)
 {
-	return IP6CB(skb)->iif;
+	return inet6_iif(skb);
+}
+
+static int sctp_v6_skb_sdif(const struct sk_buff *skb)
+{
+	return inet6_sdif(skb);
 }
 
 /* Was this packet marked by Explicit Congestion Notification? */
@@ -1142,6 +1147,7 @@ static struct sctp_af sctp_af_inet6 = {
 	.is_any		   = sctp_v6_is_any,
 	.available	   = sctp_v6_available,
 	.skb_iif	   = sctp_v6_skb_iif,
+	.skb_sdif	   = sctp_v6_skb_sdif,
 	.is_ce		   = sctp_v6_is_ce,
 	.seq_dump_addr	   = sctp_v6_seq_dump_addr,
 	.ecn_capable	   = sctp_v6_ecn_capable,
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index dbfe7d1000c2..a18cf0471a8d 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -567,6 +567,11 @@ static int sctp_v4_skb_iif(const struct sk_buff *skb)
 	return inet_iif(skb);
 }
 
+static int sctp_v4_skb_sdif(const struct sk_buff *skb)
+{
+	return inet_sdif(skb);
+}
+
 /* Was this packet marked by Explicit Congestion Notification? */
 static int sctp_v4_is_ce(const struct sk_buff *skb)
 {
@@ -1185,6 +1190,7 @@ static struct sctp_af sctp_af_inet = {
 	.available	   = sctp_v4_available,
 	.scope		   = sctp_v4_scope,
 	.skb_iif	   = sctp_v4_skb_iif,
+	.skb_sdif	   = sctp_v4_skb_sdif,
 	.is_ce		   = sctp_v4_is_ce,
 	.seq_dump_addr	   = sctp_v4_seq_dump_addr,
 	.ecn_capable	   = sctp_v4_ecn_capable,
-- 
2.31.1

