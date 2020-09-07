Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0820D25FC97
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 17:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730105AbgIGPDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 11:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729883AbgIGPCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 11:02:53 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33494C061756;
        Mon,  7 Sep 2020 08:02:52 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id u13so8170143pgh.1;
        Mon, 07 Sep 2020 08:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3ET3VUNIOlD5dN8TA+dzQwxSZyn/UWc2tEMM7JHIWn4=;
        b=ugCGWKI8KcUw37WDjOkTmiW1cE2+Nu8BVZbaQAAXCpUK/0tNLUpnwilxEffBgafPkB
         Y1w98ZQRVEybcL4511troDu4fdkHm6KRoZawr00TnpJUbJiBF28syEbxcIkDLXnEBx9F
         8oEN6MOvjbFX1fdFeCLxGHHQ5kHf+E6Ijyfszvsz3H4RDzmPYUSCZYyTRQmIWqivg95K
         0Pt84dQeoG3v2Lapvmoe9g+bEjzl54FEbnCZ40DaBiAblPkZAandPSeOXt6yygZVm5P9
         pIXr8o7PBcaSNWLCwODthzq2RjII1qI5gKtWqQb41UH/GkwxeMp2hLCHZC1UxX24vsfM
         7lRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3ET3VUNIOlD5dN8TA+dzQwxSZyn/UWc2tEMM7JHIWn4=;
        b=IhHvXtmpozlTUrIb9wRNkQIlXn/KDJ21YbsCeYoIorZRQN3L10tW9y3tk0p3oJ+k0S
         ofcqRNZ4YmoyjUhbWLaJOJvArlYpu8NJWayEs39Z/HYhX02sqr9xi5iyevWoAU1PeljR
         BIeJebTBZ6bCtMpseMr6tXudA0wMYrkA5cEKIVYFA1TlrtR1wduNElD9KdLR8uSUdkHn
         hC134Kkx95OjumOnN8YzxpaLf6gYm4DZM4U+dRTfLoj/DWicmDdGRH2lOZGVmAm/U+kV
         74omwtU13ew8KXruy4iQcHivTNdR4JuvvJh6V4upT1zMVdzjvwvPKUS63M2duByRanpE
         nDuA==
X-Gm-Message-State: AOAM5323SS/xPJUapAtm0J+4+7z0YKtFxZw675iHICRXI0oHEIIm7Zym
        Ts9dbYAL/ien+roWLC34OYc=
X-Google-Smtp-Source: ABdhPJwvkKI4BSH81v4OuYGJ2RIP0+vpnR/vq1Qx6riZRduGeh8A/zN7Ss0WYYc0Smvx6A1oehQJ3g==
X-Received: by 2002:a62:e404:: with SMTP id r4mr20475633pfh.213.1599490971823;
        Mon, 07 Sep 2020 08:02:51 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id g129sm15436022pfb.33.2020.09.07.08.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 08:02:51 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next 4/4] ixgbe, xsk: use XSK_NAPI_WEIGHT as NAPI poll budget
Date:   Mon,  7 Sep 2020 17:02:17 +0200
Message-Id: <20200907150217.30888-5-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907150217.30888-1-bjorn.topel@gmail.com>
References: <20200907150217.30888-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Start using XSK_NAPI_WEIGHT as NAPI poll budget for the AF_XDP Rx
zero-copy path.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 3771857cf887..f32c1ba0d237 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -239,7 +239,7 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 	bool failure = false;
 	struct sk_buff *skb;
 
-	while (likely(total_rx_packets < budget)) {
+	while (likely(total_rx_packets < XSK_NAPI_WEIGHT)) {
 		union ixgbe_adv_rx_desc *rx_desc;
 		struct ixgbe_rx_buffer *bi;
 		unsigned int size;
-- 
2.25.1

