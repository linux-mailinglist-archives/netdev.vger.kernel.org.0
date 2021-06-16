Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9C93AA4BB
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbhFPTzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232978AbhFPTzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 15:55:42 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CA0C061760
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 12:53:36 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id x10so1679394plg.3
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 12:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VGS4DzWR8/G2dPikMD/719Suy2uxIyHybaCloDjZXNM=;
        b=FY2zPuUxgGyti3J3Cjg8d9LP42JfHxCr85FlG5pk2oECa6W+6WTvoKYEMRZ39wgEWR
         tCa1C3ThsNgFTb7bHC6zOJrtCRNoUTVopx84rlUnPDCKeLzWKAeDxXNEpHxa3JlsmFy9
         P+e/UmyfAKEp3tPObxtTSMBuRStnOvCbwkEP0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VGS4DzWR8/G2dPikMD/719Suy2uxIyHybaCloDjZXNM=;
        b=K5rwaRkCfYf2LeB/RzlXJ6kBjvA6LBpRIVXBIc/w/IogbY2Q/bsC2mDkW18VHSu1nX
         xd/QB9GlOYRmaEkRVDsIyH/UnHFZdSMRySnkXVSY/DeJHhkW531P/a3Z0kk2iU5iqk+5
         NwwDvnBUvW3h0jpWL0uBVmOnyS0EpAu1liRP6vo4zmtFbOutvZfgdyAZ3lf+u5Enjzhm
         YAaDSJhY6yYEAb2DjVrWToyggmlxBzUtz4kf+MtIXylcnq+ZflTmaRn+2qGfoPM3S3ba
         o6zJ11URDk0BPYEwn0UoJeZnbE66KHyqkjxjKKOh0Nc5abSQythL+lLCAotQl8ApSPwn
         sYnw==
X-Gm-Message-State: AOAM530ZERmH4ba4wOoswiObBKBEjBLX5rvvoZp+w4HYQQRKXNtFE0yg
        B87Spvpz3ID9VYPs1HlezCcnAA==
X-Google-Smtp-Source: ABdhPJy+by1ofBJSIyv5K8zGIpLui6xamup+J+dw2gDc7SAji+TsxylmDIAVWnfE1HkTnxyUQy25ww==
X-Received: by 2002:a17:90a:2ac7:: with SMTP id i7mr1555152pjg.139.1623873216022;
        Wed, 16 Jun 2021 12:53:36 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e6sm6322325pjl.3.2021.06.16.12.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 12:53:35 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     netdev@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Andrew Lunn <andrew@lunn.ch>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michael Walle <michael@walle.cc>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] sh_eth: Avoid memcpy() over-reading of ETH_SS_STATS
Date:   Wed, 16 Jun 2021 12:53:33 -0700
Message-Id: <20210616195333.1231715-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=94b952556ff3e4a0b78f53f634316c190806865b; i=fo3kines9vFWo/lbOt9RxqMMwqaQ4LUWnKe29pSLIO0=; m=CF57NG64wUjRAJMr07rJpYR31VG7hNQuEGsWk+kxwfo=; p=UD+V99vZhCuYKzsPC7EN++Bmc+jlsHFMHh9vpLTU4Z0=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmDKVr0ACgkQiXL039xtwCa4PQ//e8z 6HxLhqSxcJTAD3VsDmYS1m+HPV/hnp/XmeHbH7f9S2pjzHNDG8HovNOzLkVkzcLSynVHxGwK41WhB /wH2Zzkjsp414jtWi2O//hUaH8quqdyHcKX/yE0J1qAbuDgAeUsttpUTHj2hCvJ33EYfmYP4r9ib+ idqCAcvFfR+1mNU5xtALNMwASrxxSjd8/QbcW7MYXqHJzOTrWbmrpVVaVPRSTma+UMEpiDtmUJj0e h2XDdDxItwlTVTOb5V1eFf5aV26GX/eSagIyx3zMTbqbYleEmFaU1NFWtDz3RkEDddKKCXPe5+LVv wL0tEOtFlc/Mju76htEQ26EIMXLumy8b3ZeQbrmfr6isJ1X4SaxZ+uXmGA4rDAzWbGUFm1hnw3Ks6 MgF4AyQsuifkvhc050730qySeGLCW6vsL9n3GA+3lqxCEhZckYcgYdXpXRH7wKUsY4nZqAK0OtfFj 8ry+10kUIeybmEAwQCS3OT06Kp/YveXMPJZDBDPdKSKUoJlWH6ljlPeLEer02JaCXCWWhgFH4trNm iDnddfmjBuj/dp86l/fUBvFvdYEpf16Axih3YQr6/wtpKte7jjvhIycAZZ243YRJqgZvYYANELvsi FeC8tTs2g1obVAxSjnYl1Wplgw90EqQ+1/gIZuEtmRvfOUO0qaziQddLUXy8eLtg=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally reading across neighboring array fields.

The memcpy() is copying the entire structure, not just the first array.
Adjust the source argument so the compiler can do appropriate bounds
checking.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/renesas/sh_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 177523be4fb6..840478692a37 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2287,7 +2287,7 @@ static void sh_eth_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 {
 	switch (stringset) {
 	case ETH_SS_STATS:
-		memcpy(data, *sh_eth_gstrings_stats,
+		memcpy(data, sh_eth_gstrings_stats,
 		       sizeof(sh_eth_gstrings_stats));
 		break;
 	}
-- 
2.25.1

