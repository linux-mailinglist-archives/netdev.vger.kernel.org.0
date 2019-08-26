Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 053239CB87
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 10:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730566AbfHZIaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 04:30:22 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45390 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729328AbfHZIaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 04:30:22 -0400
Received: by mail-pg1-f193.google.com with SMTP id o13so10149138pgp.12;
        Mon, 26 Aug 2019 01:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=Wv0SbmEqu0ERmsot+Qz6plHNjuHXkz/E55TB4uv/+6E=;
        b=YWcN7tW5VoCAg68TgApH62m7hfhHNDq2nO5rJn9DePo7oiOWaBqy34CljA/UrKVz+G
         9/4xDXRyP2ooTvOTOskpjxiX+bQuryO0T8VXE06e/NlMuR2RKoX4Sg0T5ZVd9Yv5ldZZ
         j51Xahkko0R9JE8xQA3zcj1deuhZjWOTWErm39WgffH7Wk6JVuuIejMtsfveQ3lnc5Hp
         wGZhQuRR6pQx5VyToi/QUDkWoINy5r0OXtgv1WkQTSndjog0QkYP5dl8EED6y/y/M81n
         UFY5P3jSIFOesEkTNaKDXILh1A4uZUuFlrd4oCMkdDI8bA0Erj0meQyrDAElxanleo5x
         rGmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=Wv0SbmEqu0ERmsot+Qz6plHNjuHXkz/E55TB4uv/+6E=;
        b=Ac0HkgRE1YaKodSyTzhcv9KZviI8D0Uo+f5VLjHa5QoSptwF0r7yKMhFHMRjxNsy6a
         6O2+ZyWpPVTAkwZJ0cjLi5LzAmmqgELsDF5TPuhIbbF0ahi4Yy5HE0lND/5ypOCEOpzW
         rKWhTKPgpoy1o1K76IaRJ658dKpnal1neBXRK77fZDuNFExGgiUwODogQO+cU1pOcaG/
         ujFTNqpdLOjRc/39Z3pwinh/NszxGvk6uYm7/RG+gwDqLj28IoD3/8XN+q6e+nsy8iqN
         IvD0tv/0ZgKZFwNkzfGyS4v/OXWqAMFkfZjsyzLwlaICa7A4Ew+BgmfnnU85e0XG5lI8
         biEA==
X-Gm-Message-State: APjAAAXsKFYfrLOHao2Mgsg8IAk3jbTh5ZjppVbaGg0qoz9q86+hEhl4
        cIKQwPl3JfiTUVFF0j8scNIDgYzxRAg=
X-Google-Smtp-Source: APXvYqwxa8IqnsAQBNnY/ZNdV3YvTJUJ7rNueeDndl/NHODLmw7CyhrXMLh3B9DIXM7viknwXIw+dw==
X-Received: by 2002:a17:90a:17c4:: with SMTP id q62mr18254026pja.135.1566808221231;
        Mon, 26 Aug 2019 01:30:21 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 21sm3837849pfb.96.2019.08.26.01.30.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 01:30:20 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 1/3] sctp: make ecn flag per netns and endpoint
Date:   Mon, 26 Aug 2019 16:30:02 +0800
Message-Id: <fc26e1e3bd1579a944320dc54d5cdbdec46ac61d.1566807985.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1566807985.git.lucien.xin@gmail.com>
References: <cover.1566807985.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1566807985.git.lucien.xin@gmail.com>
References: <cover.1566807985.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add ecn flag for both netns_sctp and sctp_endpoint,
net->sctp.ecn_enable is set 1 by default, and ep->ecn_enable will
be initialized with net->sctp.ecn_enable.

asoc->peer.ecn_capable will be set during negotiation only when
ep->ecn_enable is set on both sides.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netns/sctp.h   |  3 +++
 include/net/sctp/structs.h |  3 ++-
 net/sctp/endpointola.c     |  1 +
 net/sctp/protocol.c        |  3 +++
 net/sctp/sm_make_chunk.c   | 16 ++++++++++++----
 5 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/include/net/netns/sctp.h b/include/net/netns/sctp.h
index 0db7fb3..bdc0f27 100644
--- a/include/net/netns/sctp.h
+++ b/include/net/netns/sctp.h
@@ -128,6 +128,9 @@ struct netns_sctp {
 	/* Flag to indicate if stream interleave is enabled */
 	int intl_enable;
 
+	/* Flag to indicate if ecn is enabled */
+	int ecn_enable;
+
 	/*
 	 * Policy to control SCTP IPv4 address scoping
 	 * 0   - Disable IPv4 address scoping
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index daac1ef..503fbc3 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1322,7 +1322,8 @@ struct sctp_endpoint {
 	/* SCTP-AUTH: endpoint shared keys */
 	struct list_head endpoint_shared_keys;
 	__u16 active_key_id;
-	__u8  auth_enable:1,
+	__u8  ecn_enable:1,
+	      auth_enable:1,
 	      intl_enable:1,
 	      prsctp_enable:1,
 	      asconf_enable:1,
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index 75a407d..ea53049 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -106,6 +106,7 @@ static struct sctp_endpoint *sctp_endpoint_init(struct sctp_endpoint *ep,
 	 */
 	ep->prsctp_enable = net->sctp.prsctp_enable;
 	ep->reconf_enable = net->sctp.reconf_enable;
+	ep->ecn_enable = net->sctp.ecn_enable;
 
 	/* Remember who we are attached to.  */
 	ep->base.sk = sk;
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 2d47adc..b48ffe8 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1254,6 +1254,9 @@ static int __net_init sctp_defaults_init(struct net *net)
 	/* Disable AUTH by default. */
 	net->sctp.auth_enable = 0;
 
+	/* Enable ECN by default. */
+	net->sctp.ecn_enable = 1;
+
 	/* Set SCOPE policy to enabled */
 	net->sctp.scope_policy = SCTP_SCOPE_POLICY_ENABLE;
 
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 338278f..e41ed2e 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -244,7 +244,9 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 
 	chunksize = sizeof(init) + addrs_len;
 	chunksize += SCTP_PAD4(SCTP_SAT_LEN(num_types));
-	chunksize += sizeof(ecap_param);
+
+	if (asoc->ep->ecn_enable)
+		chunksize += sizeof(ecap_param);
 
 	if (asoc->ep->prsctp_enable)
 		chunksize += sizeof(prsctp_param);
@@ -335,7 +337,8 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 	sctp_addto_chunk(retval, sizeof(sat), &sat);
 	sctp_addto_chunk(retval, num_types * sizeof(__u16), &types);
 
-	sctp_addto_chunk(retval, sizeof(ecap_param), &ecap_param);
+	if (asoc->ep->ecn_enable)
+		sctp_addto_chunk(retval, sizeof(ecap_param), &ecap_param);
 
 	/* Add the supported extensions parameter.  Be nice and add this
 	 * fist before addiding the parameters for the extensions themselves
@@ -2597,8 +2600,13 @@ static int sctp_process_param(struct sctp_association *asoc,
 		break;
 
 	case SCTP_PARAM_ECN_CAPABLE:
-		asoc->peer.ecn_capable = 1;
-		break;
+		if (asoc->ep->ecn_enable) {
+			asoc->peer.ecn_capable = 1;
+			break;
+		}
+		/* Fall Through */
+		goto fall_through;
+
 
 	case SCTP_PARAM_ADAPTATION_LAYER_IND:
 		asoc->peer.adaptation_ind = ntohl(param.aind->adaptation_ind);
-- 
2.1.0

