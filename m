Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94BE57A62F
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 20:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239900AbiGSSK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 14:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239924AbiGSSKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 14:10:48 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8829A54656
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 11:10:31 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id h14so885158ilq.12
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 11:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KhaRQXijU7X7QmaQEbJg0rB5xqhYmbZCHiU1aLyghl0=;
        b=cT/qMGKV+2myXeCJjPngGGYo3SfWAsIwPQiV98pzR666eLHS2DZ1mIOf/LqGePwL9u
         f0Jw/BuoJ6IHMNucTxjuXvy/hK4RiHqRBZsLDyijKnahK+zA+/drlkyy3YHg+jhP6Z0N
         Jzx9xWY/AIfpjGmqaDRosNihj5xylH1VulSciNlJ03QpLd0DonYFFKbnsgDnJmW79Dm7
         0iol8fJxSaqIzTx/lk4iXcCm1kF4Iy4FPud87c60LEyl6k91fHVLUrHla4KPAc3cPLvh
         Pd1PWLcDYONQDLvdRnAPEhYTZBi/NYZ45BGETu3MQrpwcvavFL9xno15lPJycmJCjSty
         JEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KhaRQXijU7X7QmaQEbJg0rB5xqhYmbZCHiU1aLyghl0=;
        b=UEoeLq+P+27Tlw4tZF9kZgu/15L2EtLIfKw9dZmJ1WGCR+MTZYbcJjiWC+gVj/5Psm
         bzGHHBI3hBGJAUm/GupbN8M0RYiHC9WVaNS4eU8Wlj8wKljY1rqg3BADWdQ/CUdqLQOe
         c5NeivrB4Q9+n5G2sbj6kS83VB3gqz9yKA8Lt010/sWR5qnCu15Edpt0ajCAO31my15h
         NbXzIcYCS/ektG14h5AUEx7r+K5IGahtPdUi+SqyC0JnG/mHJX6lgI+G2MQhM5LTDcnv
         h8AeN+A+S4hatEM/ScNBUdBHscy3EHEOVAX4PmK5mL4k+MoHwfiuoIUbX/WyoDjLiHQ2
         Sc0g==
X-Gm-Message-State: AJIora9iOu30Yn4LkZP+zkllN6DI20UL65bxp+O1erYoE4u+08GRn+1u
        uNGnOCCsRPZ+cdpMsTY7juVNKA==
X-Google-Smtp-Source: AGRyM1vYRI0fYrM4kBMueIGB2JLVtJZhd6JKwFFAqUc9U/AgZgLvNp8rhQeoRIsu6T+MJGc9oI7i5Q==
X-Received: by 2002:a05:6e02:c86:b0:2dc:e139:444a with SMTP id b6-20020a056e020c8600b002dce139444amr6984067ile.96.1658254231231;
        Tue, 19 Jul 2022 11:10:31 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f6-20020a056e020b4600b002dae42fa5f2sm6089552ilu.56.2022.07.19.11.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 11:10:30 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 5/5] net: ipa: fix an outdated comment
Date:   Tue, 19 Jul 2022 13:10:20 -0500
Message-Id: <20220719181020.372697-6-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220719181020.372697-1-elder@linaro.org>
References: <20220719181020.372697-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 8797972afff3d ("net: ipa: remove command info pool"),
we don't allocate "command info" entries for command channel
transactions.  Fix a comment that seems to suggest we still do.
(Even before that commit, the comment was out of place.)

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi_trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 55987e35af2dd..18e7e8c405bea 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -362,7 +362,7 @@ struct gsi_trans *gsi_channel_trans_alloc(struct gsi *gsi, u32 channel_id,
 	trans->rsvd_count = tre_count;
 	init_completion(&trans->completion);
 
-	/* Allocate the scatterlist and (if requested) info entries. */
+	/* Allocate the scatterlist */
 	trans->sgl = gsi_trans_pool_alloc(&trans_info->sg_pool, tre_count);
 	sg_init_marker(trans->sgl, tre_count);
 
-- 
2.34.1

