Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 549696A1A50
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 11:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjBXKaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 05:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbjBXKaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 05:30:11 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9572A35256;
        Fri, 24 Feb 2023 02:29:49 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id 130so4812297pgg.3;
        Fri, 24 Feb 2023 02:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677234539;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U3NcJ5Mt2cgzkRxYS86zUoSp3TVBMfDr+z01Tq5U/yI=;
        b=Xyx1/Zr4PfXGhUX2zcoJv2rzEvCNS6t/0nlsxJEp5tHzmewgvIQfVnzhX1JjNlrmAq
         CD7C1P43MhE5SHbNvaqf49yYM2ylIvQmHnSEZqPlQm4ZdpG43ofnQZfEIE+FsC4KwWmm
         SRy0KaQLhOAR72g8fnfYI/J19pQFC7+7i2YuZonwMKfu9N0oaSoDJu8QLxbuQQCHUXCk
         av9WRcR0BTBFlY6r/Jen6diN6Ze9sPMv4qmj/ieTc80wOXhdGUEKI/au1v3I1FClYNz6
         DqL22Bvw1RZFSTpQlUaOB86NWieHTUEQJhzwYkYSYLyJD/A3YxkVLVCp3c7TLc/2+cNI
         P5CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677234539;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U3NcJ5Mt2cgzkRxYS86zUoSp3TVBMfDr+z01Tq5U/yI=;
        b=L3+Sw8Q3CdMBX7g1vFfZDOaTO3gw23naideKd7bkAclDqjE6jy3dLCisbJGa7G3mLC
         l6L6yYrzysePneMawpcB8T4XQ2GkenLHlVl0b4lGDZpPqVkwdxGUht8eBXQOKK/t9x8k
         oPi9VArgxqYLtq7ITv8L0hSLpsH9EeyQQmvyafieHjirZsIh9vJFqDt5R2JakG6+fFMC
         oEol7WZVJ/wROJQB95hdAkSdPTNHl311KjZZ6amYbOdAehGiAuyNr/HaTcWSWJoBMb5v
         sQrnfp/dARObYWOdJZMLawfVAaLZey51ztvq45x54BRYToQ+G8p3844EsZhSAfM17RCS
         uBnA==
X-Gm-Message-State: AO0yUKW1omI2P1hmxB6QsT/IvXV9J+Y9nxGghZRDlGhMJSAsgRCTDbEN
        WpKOf8ExbGGIicBetOIvz/g=
X-Google-Smtp-Source: AK7set81e9zNL+wgZAHpGhIG/9HaIV5A3qX2rx+LdlpMyl6e4oTIDLaCZjb5jT1ANBONskAP0RgyzQ==
X-Received: by 2002:a05:6a00:23c3:b0:5a8:c179:7b02 with SMTP id g3-20020a056a0023c300b005a8c1797b02mr15302936pfc.1.1677234538733;
        Fri, 24 Feb 2023 02:28:58 -0800 (PST)
Received: from hbh25y.. ([129.227.150.140])
        by smtp.gmail.com with ESMTPSA id g4-20020a62e304000000b005cdbd9c8825sm6618848pfh.195.2023.02.24.02.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 02:28:58 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     borisp@nvidia.com, john.fastabend@gmail.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        ilyal@mellanox.com, aviadye@mellanox.com, sd@queasysnail.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH v2] net: tls: fix possible info leak in tls_set_device_offload()
Date:   Fri, 24 Feb 2023 18:28:39 +0800
Message-Id: <20230224102839.26538-1-hbh25y@gmail.com>
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

After tls_set_device_offload() fails, we enter tls_set_sw_offload(). But
tls_set_sw_offload can't set cctx->iv and cctx->rec_seq to NULL if it fails
before kmalloc cctx->iv. It is better to Set them to NULL to avoid any
potential info leak.

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---

	v2: change commit log. The original issue will be fixed in another patch.

 net/tls/tls_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 6c593788dc25..a63f6f727f58 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1241,8 +1241,10 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	kfree(start_marker_record);
 free_rec_seq:
 	kfree(ctx->tx.rec_seq);
+	ctx->tx.rec_seq = NULL;
 free_iv:
 	kfree(ctx->tx.iv);
+	ctx->tx.iv = NULL;
 release_netdev:
 	dev_put(netdev);
 	return rc;
-- 
2.34.1

