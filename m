Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2951269850B
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 20:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjBOTyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 14:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjBOTyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 14:54:12 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0E23D0B2
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 11:54:01 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id d16so7554995ioz.12
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 11:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D8WaJHG8pg5Qs9g9gKSYjrTuSZa/InnmtxH9TDUOPTk=;
        b=y2yaCElX6ANentqtZ6BaCFm1nQBBaYcVK7z+bHjeq7P0qxn1E5MOkjP+BLwGo4y2Hv
         +x/XbhdlOguwIaTnsT98eR1sL6ueUU4ynEe4EtbJNx8+AUOgAWQE8+MT/gF/4LS/vzsB
         Z9StwzmM/41Bj7rbeD5LpQKxczXVlZBGYFtEzU6KFKwQ89BvLBgws9WXx4SHNL71EvQk
         TuWoPhOud1DtqyA09TLzc95VRPW4apMQsu6Sz2hoSB2kOuhyxk5yWprt4bMkCg1I+hIm
         KDcAsrrZzIbYi5D/esYRUK8wjKYb3fJJYhkBkia3S9Nb0EsiAMq9b2s+WwNFneY/2Szy
         G0sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D8WaJHG8pg5Qs9g9gKSYjrTuSZa/InnmtxH9TDUOPTk=;
        b=4XdRmzv7TPHOpnIMaDabZJU5Pnq+Jx0BBNVqarWGTCIfGF4KyfPay/YXx2w9QIwb2P
         TwC3wsaOUEtVb5gl+Wrfv1iQIrAKfZTn3Iq2JJz2h2uw9DqAVLPZi4DrIDgC3Iv5z57f
         5ixOIdXOEpcioFGuq1SAUyTNMI1RW0meXeBCcbTI9WwvVxrEfNrEtZKNCR2vgxcji77e
         dFGSFmZfcOt9l3armOEbHlEkPmCCwBPShvvmAZVV7EC0/3AK51/Q+8CcEFtHJYtyOHSr
         MzN/XHxibpsZUPrhXQyMFuKP/PI+CcGCXGNce0hpkbHwdlg/9pIdA8SYnOfXQMM6ajkC
         ooww==
X-Gm-Message-State: AO0yUKWRhK5edrfIH8tgSaEuZR/xwH7GxLd2FfJKBH9rWrFMSPamFpv1
        3TqD1cX3Ylf1Oik5OUqeIQP3PQ==
X-Google-Smtp-Source: AK7set+/Hmqn5IJOBfTQqxe0TxAh/USS9I6icHCHBiBmd6VefnfOf/GSPnKf1SUoek9fT0eRTsNQJg==
X-Received: by 2002:a6b:e31a:0:b0:741:8544:7cb1 with SMTP id u26-20020a6be31a000000b0074185447cb1mr1691015ioc.14.1676490841066;
        Wed, 15 Feb 2023 11:54:01 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id n10-20020a5ed90a000000b0073a312aaae5sm6291847iop.36.2023.02.15.11.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 11:54:00 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/6] net: ipa: avoid setting an undefined field
Date:   Wed, 15 Feb 2023 13:53:50 -0600
Message-Id: <20230215195352.755744-5-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230215195352.755744-1-elder@linaro.org>
References: <20230215195352.755744-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GSI channel protocol field in the CH_C_CNTXT_0 GSI register is
widened starting IPA v5.0, making the CHTYPE_PROTOCOL_MSB field
added in IPA v4.5 unnecessary.  Update the code to reflect this.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c     | 2 +-
 drivers/net/ipa/gsi_reg.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 0e6f679f71a8c..88279956194a9 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -185,7 +185,7 @@ static u32 ch_c_cntxt_0_type_encode(enum ipa_version version,
 	u32 val;
 
 	val = reg_encode(reg, CHTYPE_PROTOCOL, type);
-	if (version < IPA_VERSION_4_5)
+	if (version < IPA_VERSION_4_5 || version >= IPA_VERSION_5_0)
 		return val;
 
 	type >>= hweight32(reg_fmask(reg, CHTYPE_PROTOCOL));
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index a0b7ff0dcdfda..52520cd44c3e1 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -101,7 +101,7 @@ enum gsi_reg_ch_c_cntxt_0_field_id {
 	CHTYPE_DIR,
 	CH_EE,
 	CHID,
-	CHTYPE_PROTOCOL_MSB,				/* IPA v4.9+ */
+	CHTYPE_PROTOCOL_MSB,				/* IPA v4.5-4.11 */
 	ERINDEX,
 	CHSTATE,
 	ELEMENT_SIZE,
-- 
2.34.1

