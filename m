Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B59A46BBD5F
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 20:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbjCOTgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 15:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232779AbjCOTgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 15:36:04 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA83C88EC3
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 12:36:02 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id t13so10495202qvn.2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 12:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678908962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/MbviwZ9aPtBhKMJt0xAhfvjag7IUKbs0D6Z8ztPm0A=;
        b=goxfksMxxS0wvDg+0DKlxwLsgC8+1ARldTlIMUZ3/VcwtI2pL+kTB5l8e0gWnpM5AW
         DPCBxTky9Z9T5eSmYXjJHrAKyNQfS+LBkQvB1YveytnHQVOo7MKpzc68FS+BXulqZyIb
         u87hjFLACYpc8uHi0yZrRmcKyaSym3KwSrPEurB+NOmWIRheUAzVsVNLCf6AjDHVph/4
         0ENFkUQHBAvUjlZw2MfmKEoROg1g1VToUXjwTnFfoLlOxcTlzV1+ch/fWn3b81PEWldb
         VT5SFH3RdL2rBiZN+WnjkyeFuPIqB98Vg5TceuoInMmA9oOmh5GWiCkFY2ENMW/1VR9f
         NLZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678908962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/MbviwZ9aPtBhKMJt0xAhfvjag7IUKbs0D6Z8ztPm0A=;
        b=JHbRKWksQwfC8yH+JpDR93Tqo8O1JIjHNykT7bqIby/ZOwAY3O4ZeHTZzPVntWqPRu
         CywFY8/LaYwJR/PU7E59f56Eyg6tcORRcxHkvdCE1MjTv2boxhMkqmYcWWgR1AXCJuo3
         qktkqkmCVMVUtwBLjNw578d1DIO3NOMy+SzVeIOzgw5RMZkQFUVetCX/BWP4kjUI8R3w
         9x3frp7FHWzY1TknotPTWnHV7hLxNU5bURu3QGXBOwymo6wrpr6qakAtOhaP8qPYMlpq
         RVU9cI5TwmOlnxdqlJNU4bq/NVFSGlZx533RJ9VkePEzGr5oyzwjHZziEk8P2UaqlU3u
         +ocA==
X-Gm-Message-State: AO0yUKWUD6CwL4v+OHYagKig0YCoyTDWWlAw2B/dVETO1YKrf9uHuBDQ
        2QuThrPvNhvK6TzkWEBvXISzCA==
X-Google-Smtp-Source: AK7set81DVTf/PeXHcxLJh3Oq4FOb+aFal75uj2MhDq+DgdAsLus6txbZxC8Fsfyff4rSNeJdAa77A==
X-Received: by 2002:a05:6214:29c3:b0:56f:52ba:ccf7 with SMTP id gh3-20020a05621429c300b0056f52baccf7mr28984724qvb.14.1678908961862;
        Wed, 15 Mar 2023 12:36:01 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id q9-20020a05620a024900b0071eddd3bebbsm4369462qkn.81.2023.03.15.12.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 12:36:01 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v2 3/4] net: ipa: kill FILT_ROUT_CACHE_CFG IPA register
Date:   Wed, 15 Mar 2023 14:35:51 -0500
Message-Id: <20230315193552.1646892-4-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230315193552.1646892-1-elder@linaro.org>
References: <20230315193552.1646892-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent commit defined a few IPA registers used for IPA v5.0+.
One of those was a mistake.  Although the filter and router caches
get *flushed* using a single register, they use distinct registers
(ENDP_FILTER_CACHE_CFG and ENDP_ROUTER_CACHE_CFG) for configuration.

And although there *exists* a FILT_ROUT_CACHE_CFG register, it is
not needed in upstream code.  So get rid of definitions related to
FILT_ROUT_CACHE_CFG, because they are not needed.

Fixes: de101ca79f97 ("net: ipa: define IPA v5.0+ registers")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_reg.c | 4 ++--
 drivers/net/ipa/ipa_reg.h | 9 ---------
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ipa/ipa_reg.c b/drivers/net/ipa/ipa_reg.c
index 735fa65916097..463a31dfa9f47 100644
--- a/drivers/net/ipa/ipa_reg.c
+++ b/drivers/net/ipa/ipa_reg.c
@@ -39,7 +39,8 @@ static bool ipa_reg_id_valid(struct ipa *ipa, enum ipa_reg_id reg_id)
 		return version <= IPA_VERSION_3_1;
 
 	case ENDP_FILTER_ROUTER_HSH_CFG:
-		return version != IPA_VERSION_4_2;
+		return version < IPA_VERSION_5_0 &&
+			version != IPA_VERSION_4_2;
 
 	case IRQ_SUSPEND_EN:
 	case IRQ_SUSPEND_CLR:
@@ -52,7 +53,6 @@ static bool ipa_reg_id_valid(struct ipa *ipa, enum ipa_reg_id reg_id)
 	case QSB_MAX_WRITES:
 	case QSB_MAX_READS:
 	case FILT_ROUT_HASH_EN:
-	case FILT_ROUT_CACHE_CFG:
 	case FILT_ROUT_HASH_FLUSH:
 	case FILT_ROUT_CACHE_FLUSH:
 	case STATE_AGGR_ACTIVE:
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 28aa1351dd488..ff2be8be0f683 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -61,7 +61,6 @@ enum ipa_reg_id {
 	QSB_MAX_WRITES,
 	QSB_MAX_READS,
 	FILT_ROUT_HASH_EN,				/* Not IPA v5.0+ */
-	FILT_ROUT_CACHE_CFG,				/* IPA v5.0+ */
 	FILT_ROUT_HASH_FLUSH,				/* Not IPA v5.0+ */
 	FILT_ROUT_CACHE_FLUSH,				/* IPA v5.0+ */
 	STATE_AGGR_ACTIVE,
@@ -206,14 +205,6 @@ enum ipa_reg_qsb_max_reads_field_id {
 	GEN_QMB_1_MAX_READS_BEATS,			/* IPA v4.0+ */
 };
 
-/* FILT_ROUT_CACHE_CFG register */
-enum ipa_reg_filt_rout_cache_cfg_field_id {
-	ROUTER_CACHE_EN,
-	FILTER_CACHE_EN,
-	LOW_PRI_HASH_HIT_DISABLE,
-	LRU_EVICTION_THRESHOLD,
-};
-
 /* FILT_ROUT_HASH_EN and FILT_ROUT_HASH_FLUSH registers */
 enum ipa_reg_filt_rout_hash_field_id {
 	IPV6_ROUTER_HASH,
-- 
2.34.1

