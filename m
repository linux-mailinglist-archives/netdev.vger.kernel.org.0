Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764D83AF861
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbhFUWXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbhFUWXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 18:23:31 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACA9C061760
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:21:14 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id t19-20020a17090ae513b029016f66a73701so410958pjy.3
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k4IdIX/nvtQeyieT57jvq6pJDqXEf5OX6FjN268bVeg=;
        b=nkVTSIbARbqWX9bwAlW18qOcFR8S/hkqL5a1OVaKjTFtwfRmIlcf1FB8IBt7484nNv
         B/iwvYo5pXp4OAPYa9GF5uI+2nWwc25NjLHtB0z99es5AL03f+esGPsU08SB4Cb9Y+1W
         vtykXOIbgR7n7kvpkf3/Wv4O7FOsStJDEaoIc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k4IdIX/nvtQeyieT57jvq6pJDqXEf5OX6FjN268bVeg=;
        b=TNLz7ELQ6MC+tOREjCU29hzx/5JM4rdZEP1KlIMdPVfa9B7HAYKyzMZeyg1dLeMi+W
         IauwjeewDFx1RYunxuAkA9uVAAbJR68he84qyNNbBXT0gu7vtCSSfajd0DLF+J843rri
         H8yRVlOmXE4bZvXV6JRDO8YqwBK8rnxdlgg32nPAg//CA204obCWcveLmEp6GAp26dmD
         Q/p1dGqRr7n2AapzrgcaxJNk8p5a97iAqn+DQ7NoxNvHGNaA9QPYJYJUIBZMAmAIY43L
         POeGmEk9ZZ97ORbMbg3Rpfg9EAPQBsBz2tvsEraWT3n7GJT+7q+BY0e2D8OApVQASLLf
         +/pQ==
X-Gm-Message-State: AOAM531wAlBUCEfHB52q5nb8ZXqh7vf6o4qOLAWmpleePBhZEm6xboWv
        I9QzbRm/Twsu7U8VkjzczZ38Lw==
X-Google-Smtp-Source: ABdhPJy0UEQTxmiMj8p2NA6jXxmy5M54nD943ClM6WPkwJ+CKmoQhJbhjtM8O2hcOqIBwKLJXKwQiw==
X-Received: by 2002:a17:90a:dac1:: with SMTP id g1mr427917pjx.199.1624314074326;
        Mon, 21 Jun 2021 15:21:14 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 73sm4536385pfy.83.2021.06.21.15.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 15:21:13 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "K. Y. Srinivasan" <kys@microsoft.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] hv_netvsc: Avoid field-overflowing memcpy()
Date:   Mon, 21 Jun 2021 15:21:12 -0700
Message-Id: <20210621222112.1749650-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=52ca9d3ef6fdb378f4fb4390eb0f8bf4545fb2f0; i=KB/gBOM4hXq43bzNgE68y/CtxkQywhn1/IWky57D5OI=; m=5mFF/t04SK2neGS9/cim9EhIl8hHaSNFLWMm4iAy2p8=; p=viZ5h7L2XoQprZaaybqKRBXaA6Do0vJQSm4gKjZyktE=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmDRENcACgkQiXL039xtwCYneg/+O3l CHaMID0zQGdHzOpjdP/XRCBkbVhaJywyHQ8z6b7qmEv3f20zSEpANEIFxybZanrdt/CdTEEfq3rfp MnxIdOpQzllckLVio4CTSZVeSkhV5fW6cGgy6cGBfmmwo5L7lZPsQT99c7qkBCTuz/yX8s+yrRj5J JPoUt6IMHmYzT8V9qhdFBrY4Mj1yOWqTjTf5vrKQXkzRVEAIrAnmw6vQQqaNOQj8casITz+Bas2r9 1BnbHRha8kDtuvxErUrhSvElGt1QJBLTEbNJFaseHV1+hk/wYjf+IEDa7cTWDJv/MEzw14vLQ5lJ7 TpdODkKAEPK+ifpliTgNz5o0Z3WZvDkiS4mSCPmLfBxnZ4F2ckzR42tFpFT/6XUNWaba/O3Rdf96d YUzWdRdWnqrxJrZGAu1dgk/U76yd2ydcikd/yky9RmLEFMvosTJ2UUh344i3i6Jo3KrpJjLgYEmll N0SJ5HiAxLF8j052YiXUO/MNSDP8XVIScErnxTg/ah6x7Yq8PD5SPxkt1pGjJtC1MkMIcIw+XKK4H Prj0rfPvjCUvMXkjq82cEBgAMFwaMqO2wu0jaXbv6fZ+Ynxo3TZoYw53z2Eam0ohGAsszkNbZUdi6 4MvZ8f4iLqqz3cs5bnyFAomq2bEcQ2qM9HAd8Hk8LHIXIiQPe56MYO+diaNYmMDg=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Add flexible array to represent start of buf_info, improving readability
and avoid future warning where memcpy() thinks it is writing past the
end of the structure.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/hyperv/hyperv_net.h   | 1 +
 drivers/net/hyperv/rndis_filter.c | 6 ++----
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index b11aa68b44ec..bc48855dff10 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -1170,6 +1170,7 @@ struct rndis_set_request {
 	u32 info_buflen;
 	u32 info_buf_offset;
 	u32 dev_vc_handle;
+	u8  info_buf[];
 };
 
 /* Response to NdisSetRequest */
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 983bf362466a..f6c9c2a670f9 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1051,10 +1051,8 @@ static int rndis_filter_set_packet_filter(struct rndis_device *dev,
 	set = &request->request_msg.msg.set_req;
 	set->oid = RNDIS_OID_GEN_CURRENT_PACKET_FILTER;
 	set->info_buflen = sizeof(u32);
-	set->info_buf_offset = sizeof(struct rndis_set_request);
-
-	memcpy((void *)(unsigned long)set + sizeof(struct rndis_set_request),
-	       &new_filter, sizeof(u32));
+	set->info_buf_offset = offsetof(typeof(*set), info_buf);
+	memcpy(set->info_buf, &new_filter, sizeof(u32));
 
 	ret = rndis_filter_send_request(dev, request);
 	if (ret == 0) {
-- 
2.30.2

