Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821F44A3588
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 10:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346916AbiA3Jyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 04:54:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239760AbiA3Jyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 04:54:35 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F94C061714
        for <netdev@vger.kernel.org>; Sun, 30 Jan 2022 01:54:34 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id s5so33142650ejx.2
        for <netdev@vger.kernel.org>; Sun, 30 Jan 2022 01:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AXuHh5mvikZ2IoYxmlaXcYDwSTq++907A6QuZqZZ17Y=;
        b=cgpzsZhi1sz6Ic7UnmC3m/2jN9/3ZvMuz4hnCV3NgmmRctRUnFxLazRavBRyiV13f6
         PlzwAJCEYRGAhFM44Um6W4iMbz80Bv+Z0guXRnmsdDS9LyBMs9JcaS6rnpGmTsdNQUEV
         hlsHFN10vheceIoL8eV3Htr7zi/BnOWDt8LDDLU0jHA1hhxaMrMR+Bek/lsYpElGEDh1
         2y+dKPrC/Jurtk7rH173GHce62tGlzAS+7KSdyu9rCQ18IKzZ8+uBjb+ZSjlmz6L+H8i
         dVos4u2bLrSm3WeN6qv7NjeVlBgIhKKqYXzCpv5l8Bfz7zgTVfWCDY+X1DIg9bg+PaR9
         XYog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AXuHh5mvikZ2IoYxmlaXcYDwSTq++907A6QuZqZZ17Y=;
        b=zFef50PydXn0Gh2ndHV4zhfzT5VnFxFIAj8XMa+BdaJYCio6sctRAz+RGWgahGN1zU
         ufm6HpYH1pkCv2XSANKXy4Y3hWVAuPvxLH9HNfd9rqZqHglUGaESL9NOd7gmHah6TWzb
         lWvU5juTb1dsnsXFF4ZGBxtTxgx2TMW7aiqCTiprr5Sz7xrw9655SGhIvJ3Ln09XIpH/
         hNU8Gf9hE7gdC26opyToEJrmlCbOAAulm9f78ITCJ0btXx5rtJ4pKdaCxCGW2ocuzSl3
         0ufdEv3k/KcxQaqXf0NsI3THODcerCUvw8AGAdD0CO3WhwyyMpEfNk7cha1BqeR5pZjo
         5wIQ==
X-Gm-Message-State: AOAM5303uI2loiy3TDZTscX4ZyF+kZ4NRjQ/aP+Bjk0roBRfbUyAywwX
        pu1GzuBGl8U323oJTcfgWm0EXQ==
X-Google-Smtp-Source: ABdhPJwpWqHeDkZwVFdKUqzKn3LJSy3ihdbp/FnLpkPBXLYixVBr9wye3UCwbz7tIl3XZjNXEEahYQ==
X-Received: by 2002:a17:906:974c:: with SMTP id o12mr4949615ejy.340.1643536473382;
        Sun, 30 Jan 2022 01:54:33 -0800 (PST)
Received: from hornet.engleder.at ([2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id q5sm4408319ejc.115.2022.01.30.01.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 01:54:33 -0800 (PST)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next] selftests/net: timestamping: Fix bind_phc check
Date:   Sun, 30 Jan 2022 10:54:22 +0100
Message-Id: <20220130095422.7432-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gerhard Engleder <gerhard@engleder-embedded.com>

timestamping checks socket options during initialisation. For the field
bind_phc of the socket option SO_TIMESTAMPING it expects the value -1 if
PHC is not bound. Actually the value of bind_phc is 0 if PHC is not
bound. This results in the following output:

SIOCSHWTSTAMP: tx_type 0 requested, got 0; rx_filter 0 requested, got 0
SO_TIMESTAMP 0
SO_TIMESTAMPNS 0
SO_TIMESTAMPING flags 0, bind phc 0
   not expected, flags 0, bind phc -1

This is fixed by setting default value and expected value of bind_phc to
0.

Fixes: 2214d7032479 ("selftests/net: timestamping: support binding PHC")
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 tools/testing/selftests/net/timestamping.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/timestamping.c b/tools/testing/selftests/net/timestamping.c
index aee631c5284e..044bc0e9ed81 100644
--- a/tools/testing/selftests/net/timestamping.c
+++ b/tools/testing/selftests/net/timestamping.c
@@ -325,8 +325,8 @@ int main(int argc, char **argv)
 	struct ifreq device;
 	struct ifreq hwtstamp;
 	struct hwtstamp_config hwconfig, hwconfig_requested;
-	struct so_timestamping so_timestamping_get = { 0, -1 };
-	struct so_timestamping so_timestamping = { 0, -1 };
+	struct so_timestamping so_timestamping_get = { 0, 0 };
+	struct so_timestamping so_timestamping = { 0, 0 };
 	struct sockaddr_in addr;
 	struct ip_mreq imr;
 	struct in_addr iaddr;
-- 
2.20.1

