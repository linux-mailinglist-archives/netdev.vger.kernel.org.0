Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661FA506022
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 01:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234663AbiDRXUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 19:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234591AbiDRXUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 19:20:42 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D28823BC8
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 16:18:01 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id s4so12365753qkh.0
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 16:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uzTGDQP0f95uJjkIzcCv5mUHYF5rmou/7UB+HwmJESo=;
        b=LnzjpeDIks5TxNNm0jxFG63+BZztr6COd+ExcQMvzsOqsM2haLamtMZKk1rooCKegZ
         w8gBU/C1SS8idFiRcEUjcNBkHGFgTft3LgIZVsVd9IbJQSPzZGwR2f603crEAbL8kW/J
         8b25ke05TK3yGUKeqeKEO2VSaHD7XesZa1wMI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uzTGDQP0f95uJjkIzcCv5mUHYF5rmou/7UB+HwmJESo=;
        b=09UK7E45rpOx1SgC9OsLe2ApN17FAgiCiumMsWU6ZIoNZalg6b4rMNnWyOkEjOkOfF
         /U7FNVhL9iNa9m7c9hfEQXeZ6vXj9CVm0qRoHYATc3UnFXi2TmRNu7mSd5D15yoc2+c2
         JSeXl1oMmqrQedobqPgic2aU9JwFE5gk/NJfbSa6VQm/8sg0iu4BSGSBo/fj3RMeC2JQ
         g9n/oI+YQRPjm8Ga/O6WdTwQ687iIHHCBhLd0XZSEY/5dCSGdVYr0v7ITGlchflAlOEr
         k9hMjOOzgDpd7IyUIE3UQeyy26dB2m2VWtU7Jbh7SIqfI/iU1VFMzM2ZzjOUs6kQ9tZ1
         OU2g==
X-Gm-Message-State: AOAM530sdirwaQWuxqnx6iyt4rGTasVeMNi+my4u9sTvwfrfOfWIz6Bu
        MYbSoUP8yNjNX08bRABUAI7Ikw==
X-Google-Smtp-Source: ABdhPJxsj1wrb92DBhSr8MmPgWD1TRSXaztHAb6okgzlnASHT8TV/adbzOw2yNkVM0aCjPWfsKYqqg==
X-Received: by 2002:a05:620a:1724:b0:69e:883a:85b6 with SMTP id az36-20020a05620a172400b0069e883a85b6mr6297843qkb.247.1650323880498;
        Mon, 18 Apr 2022 16:18:00 -0700 (PDT)
Received: from grundler-glapstation.lan ([70.134.62.80])
        by smtp.gmail.com with ESMTPSA id a1-20020a05622a02c100b002f17cba4930sm8214048qtx.85.2022.04.18.16.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 16:18:00 -0700 (PDT)
From:   Grant Grundler <grundler@chromium.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Aashay Shringarpure <aashay@google.com>,
        Yi Chou <yich@google.com>,
        Shervin Oloumi <enlightened@google.com>,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCH 1/5] net: atlantic: limit buff_ring index value
Date:   Mon, 18 Apr 2022 16:17:42 -0700
Message-Id: <20220418231746.2464800-2-grundler@chromium.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220418231746.2464800-1-grundler@chromium.org>
References: <20220418231746.2464800-1-grundler@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

buff->next is pulled from data DMA'd by the NIC and later used
to index into the buff_ring[] array. Verify the index is within
the size of the array.

Reported-by: Aashay Shringarpure <aashay@google.com>
Reported-by: Yi Chou <yich@google.com>
Reported-by: Shervin Oloumi <enlightened@google.com>
Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index d875ce3ec759..e72b9d86f6ad 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -981,7 +981,9 @@ int hw_atl_b0_hw_ring_rx_receive(struct aq_hw_s *self, struct aq_ring_s *ring)
 
 			if (buff->is_lro) {
 				/* LRO */
-				buff->next = rxd_wb->next_desc_ptr;
+				buff->next =
+					(rxd_wb->next_desc_ptr < ring->size) ?
+					rxd_wb->next_desc_ptr : 0U;
 				++ring->stats.rx.lro_packets;
 			} else {
 				/* jumbo */
-- 
2.36.0.rc0.470.gd361397f0d-goog

