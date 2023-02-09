Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A1D690D67
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 16:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbjBIPo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 10:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbjBIPoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 10:44:05 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22A53E082
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 07:43:42 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id sa10so7543590ejc.9
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 07:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Php+pwcOHz0uoBaLh2xP3WNJg/chh4cP4sGUxovIVz4=;
        b=kKy/Vf9H0PEKCnG2pk5ryKxY1Bv4aqnm5fupHxc5soxgtA3NrOZDtzeIt6zMs2o+J5
         Jib77Sg+Hym1Tshwqiec/NgHv+HiJ1Jbx3h8YUANg9BdStfa8idhQoFNxKmk5ZUq9qTX
         1gjiGuJUKDxs7XZWjIJKv78sTh0aornpsygusNS91d0zKpSO6NneAgxJIFpX8vVF6YGj
         g0r1wB+Qiv1ca/P0P5hiifhuOCRmK9p1CFCZuCgNK3BZ0ZW62FEPkDiULR3BTy3ycq7x
         eMgj0Gic2pbzhA7qgjgz6sN/T9yymq75ZlVPecTv1RU+UJ7CPoET69RGay58t7zWalA+
         4pKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Php+pwcOHz0uoBaLh2xP3WNJg/chh4cP4sGUxovIVz4=;
        b=ztS/1ys3b+9FLXQM9Tj9+6bMKz8pJo1yKUB3QDegEP/BUpdCxssSnSTQKKG15nNH3l
         3Pq0dzIgAQTs9i4U8kPauVZ3LisjxORQB/PgEvlDsK5assSxtzglfYKODj5C8LQyr/Ky
         RXNyf1XH2wGjo6QU1XHnKfqgsSxuUPDmQzfec2eBMrti0HKlyzhdNc4f4EIacBTmAl+7
         VBPf1+k6sDyLF3rKyTkQ5yZTNkzgf8iyh3SQRwuTgurZDvk/4JGr8yq2AkijHNa75gSR
         43NJI9lRhY0soaIcEIVBN2AY7+cl81ZMC0iO5b9qChSW9Qt8GAkf0qsVqeP0uev9gm7J
         o++A==
X-Gm-Message-State: AO0yUKXdr4y4ohCNHtONW0r28jnIfSsHKL0ZJ4RQ9iBexP1mgM9AjjGM
        xV5I4fyCcJ488EHaqWhXWjok2Lnr/acDNCkLRSI=
X-Google-Smtp-Source: AK7set+F9RfLfdG9KxrqCWdEG+SOYw3OQPbcLMeP5SW40B4bMcgmWkDQigGcllcT+2NquUuls0tNYg==
X-Received: by 2002:a17:906:5207:b0:88e:682e:3a9e with SMTP id g7-20020a170906520700b0088e682e3a9emr11927664ejm.61.1675957400820;
        Thu, 09 Feb 2023 07:43:20 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id x27-20020a170906135b00b007ae32daf4b9sm1010499ejb.106.2023.02.09.07.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 07:43:20 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, gal@nvidia.com, kim.phillips@amd.com,
        moshe@nvidia.com
Subject: [patch net-next 4/7] devlink: use xa_for_each_start() helper in devlink_nl_cmd_port_get_dump_one()
Date:   Thu,  9 Feb 2023 16:43:05 +0100
Message-Id: <20230209154308.2984602-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209154308.2984602-1-jiri@resnulli.us>
References: <20230209154308.2984602-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

As xarray has an iterator helper that allows to start from specified
index, use this directly and avoid repeated iteration from 0.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/devlink/leftover.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 1db45aeff764..bbace07ff063 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -1111,24 +1111,18 @@ devlink_nl_cmd_port_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink_port *devlink_port;
 	unsigned long port_index;
-	int idx = 0;
 	int err = 0;
 
-	xa_for_each(&devlink->ports, port_index, devlink_port) {
-		if (idx < state->idx) {
-			idx++;
-			continue;
-		}
+	xa_for_each_start(&devlink->ports, port_index, devlink_port, state->idx) {
 		err = devlink_nl_port_fill(msg, devlink_port,
 					   DEVLINK_CMD_NEW,
 					   NETLINK_CB(cb->skb).portid,
 					   cb->nlh->nlmsg_seq,
 					   NLM_F_MULTI, cb->extack);
 		if (err) {
-			state->idx = idx;
+			state->idx = port_index;
 			break;
 		}
-		idx++;
 	}
 
 	return err;
-- 
2.39.0

