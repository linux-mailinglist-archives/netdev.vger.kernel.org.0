Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B06050A881
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 20:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391596AbiDUS43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 14:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbiDUS42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 14:56:28 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B5A4C414
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 11:53:38 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id f5so3630364ilj.13
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 11:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bbyMWcmSGXgNIxqKnDx18acQ+HwDjhU9tvhj4WCYFZ8=;
        b=LUJpE0LvS6NNvu6GsYe9z/rRdBpPH8XLbYGjHkLYeg2Zpqz/kjcA498RzQKi/uVosJ
         5suup8I/gHaT8iKnfb4/d4w7FmcAesDQGDOxtKYgEvCcIo8y9yRyDjU0eVofhKAWwYZH
         XxNDj4T1CMx6r2GT163PhVC4aOt0zwT+ls3q/5KklxvsU7FOr771cIy3jkMAs9JQLWj4
         sSZHV8cC+28IEOFfYGqTyv4xbvQ7qdx9opWJz1kQCYTcGELulvcJQF3IV+Tyxx4k2vAm
         M4hoQAq+DejCcERjZ1+1v71n/K5unHy5K2sIn7SeUqybnNmnqSFsAh0jJY4gqbrfzD+0
         X1rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bbyMWcmSGXgNIxqKnDx18acQ+HwDjhU9tvhj4WCYFZ8=;
        b=dZ2/Togti6K9RxX6CQNTiqYhxxJnNEbFD/b4SqyiN4fdiim7zOzvJee3cXjZ9C7IKF
         Wcrl4TKhppY1dv0mxojd7vzldHcjKmW9346XvIRxFeSG2zh27V89B1TTi6BJvJqv1wZ0
         h/w1ugZijkd30mjBR++K/1NqVNXYAAkVAuzh+qbCv9NZ/QwJVl5CWHR8dzMiSrb0h15C
         xog7ncCDA795OonFP0tQdYgxK9UIqjN0e7RfKkuL75C65e47+8UP1yM7yc+/MApMx2q3
         rWGr54cdsPoFelzxIaVj0YerGO1ZALarHVE5jBH6vqbxjEkSGvp+RSnlY+7vUtZIyf+j
         0yiA==
X-Gm-Message-State: AOAM533AL2y53MhkIvFoQh5fTU/e/P1XiT3Rn+8y0UCqqA5uaK6xyjAh
        bFPEqrtIiOihXHelTPIVj0BfYQ==
X-Google-Smtp-Source: ABdhPJx4apFQHHAkJrvtgtLFm2zkEs6gniOhYfLa58nYwuzqg/vyWzgeBhEQ6U1F5u4P8TAk/HlbJw==
X-Received: by 2002:a05:6e02:20c4:b0:2cc:4490:cb85 with SMTP id 4-20020a056e0220c400b002cc4490cb85mr452906ilq.73.1650567217715;
        Thu, 21 Apr 2022 11:53:37 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id k11-20020a926f0b000000b002c2756f7e90sm12253320ilc.17.2022.04.21.11.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 11:53:36 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, avuyyuru@codeaurora.org,
        jponduru@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: ipa: compute proper aggregation limit
Date:   Thu, 21 Apr 2022 13:53:33 -0500
Message-Id: <20220421185333.1371632-1-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
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

The aggregation byte limit for an endpoint is currently computed
based on the endpoint's receive buffer size.

However, some bytes at the front of each receive buffer are reserved
on the assumption that--as with SKBs--it might be useful to insert
data (such as headers) before what lands in the buffer.

The aggregation byte limit currently doesn't take into account that
reserved space, and as a result, aggregation could require space
past that which is available in the buffer.

Fix this by reducing the size used to compute the aggregation byte
limit by the NET_SKB_PAD offset reserved for each receive buffer.

Signed-off-by: Alex Elder <elder@linaro.org>
---
Note:  This is a bug, but it won't apply cleanly to older kernels,
       so I will be posting back-ports separately.

 drivers/net/ipa/ipa_endpoint.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 888e94278a84f..e133eb2bebcfb 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -130,9 +130,10 @@ static bool ipa_endpoint_data_valid_one(struct ipa *ipa, u32 count,
 		 */
 		if (data->endpoint.config.aggregation) {
 			limit += SZ_1K * aggr_byte_limit_max(ipa->version);
-			if (buffer_size > limit) {
+			if (buffer_size - NET_SKB_PAD > limit) {
 				dev_err(dev, "RX buffer size too large for aggregated RX endpoint %u (%u > %u)\n",
-					data->endpoint_id, buffer_size, limit);
+					data->endpoint_id,
+					buffer_size - NET_SKB_PAD, limit);
 
 				return false;
 			}
@@ -739,6 +740,7 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 	if (endpoint->data->aggregation) {
 		if (!endpoint->toward_ipa) {
 			const struct ipa_endpoint_rx_data *rx_data;
+			u32 buffer_size;
 			bool close_eof;
 			u32 limit;
 
@@ -746,7 +748,8 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 			val |= u32_encode_bits(IPA_ENABLE_AGGR, AGGR_EN_FMASK);
 			val |= u32_encode_bits(IPA_GENERIC, AGGR_TYPE_FMASK);
 
-			limit = ipa_aggr_size_kb(rx_data->buffer_size);
+			buffer_size = rx_data->buffer_size;
+			limit = ipa_aggr_size_kb(buffer_size - NET_SKB_PAD);
 			val |= aggr_byte_limit_encoded(version, limit);
 
 			limit = IPA_AGGR_TIME_LIMIT;
-- 
2.32.0

