Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D01450CE5
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 18:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238085AbhKORqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 12:46:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238258AbhKORnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 12:43:03 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034CDC028BBD
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:23:10 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 200so15176417pga.1
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DyXVNJlVuq3Z5LDQbPWDrM25p7VK8nkRPcOPCG+xJaE=;
        b=AxFPcB8E2p+Ym87XmXYGqRypjR3V8eYHYZV3XZ8wNNVayPlAV6JlW7X729BYPcM+61
         wlZOCjRAVlL9aaRSXoax5O9sw2cDyDPC5kttSbFKqqfyMCrblxIT9QY5IooPpEjfI9x9
         0tEwdw+gBwE+kvKRapNSTx/ddqVck+Zn+1xUX2uSsxFsVPDnBg2+LqCBXoK6VEX8hAvG
         pouygaMIrJmJmuIyvBCA316n+SEmDeIIhymvPXMB3eesLjrjxGAa0KFUMkb8+tzj7bqo
         kkxPrGFsucuMKMIy0No9vbQidaX/0c5CG5qpRn7ehNtQA0FBEToLGU+AGi9m17EG14v8
         d7Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DyXVNJlVuq3Z5LDQbPWDrM25p7VK8nkRPcOPCG+xJaE=;
        b=npSpIGSO7pJXJbeBnGFWtQGlQOEyCtA5R6mjnJhj5zuU00iGsz+pW9mFK4SA+msAqx
         IrRWhO2pNWZShZnjK71T7GJukn6Nqd5HZt02p0c5Lk+C653TVwZEt2I1HaONNPi9Q2ZV
         IwZE+NZ8u22oH9HMpM922rP999JD/Oqlqd1r3DPiXwEoo9mUM9d1P1icQNX6TbKDQ7Au
         MFw6wEssF6EZBELQ2yrLh97nOyPrvIF/5CITiJY7dHBF3FDXZPMZheM3tcotg+YjKXcX
         VtLYwXLB0HLrSRcy7Y41Xv1+GmsIOOsdONCvBHASbNSowPkL1YgC0OZ13yNeAPTN7pEi
         tAiQ==
X-Gm-Message-State: AOAM531N2EeIdMgQ57/sjZ6ULcsREfm3kwCI6Jy+g/w265SdV7e3HjnQ
        MFMEFAOg1/bHAjZIAtU0WeQ=
X-Google-Smtp-Source: ABdhPJz+FuZY8ehrCzACKP8vNZpTbCZTDemuI/2ZOk70nzeGGiN4B393pdgH+24FVCBiRBCcZRYB+Q==
X-Received: by 2002:a62:4e0a:0:b0:4a0:4127:174b with SMTP id c10-20020a624e0a000000b004a04127174bmr33747158pfb.41.1636996989568;
        Mon, 15 Nov 2021 09:23:09 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id a12sm18740840pjq.16.2021.11.15.09.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 09:23:09 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/3] net: use .data.once section in netdev_level_once()
Date:   Mon, 15 Nov 2021 09:23:02 -0800
Message-Id: <20211115172303.3732746-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115172303.3732746-1-eric.dumazet@gmail.com>
References: <20211115172303.3732746-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Same rationale than prior patch : using the dedicated
section avoid holes and pack all these bool values.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3ec42495a43a56dbd51fecd166d572a9e586e3e4..e6beb603537572aae64e33ea2c739741b4f97ce5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5291,7 +5291,7 @@ void netdev_info(const struct net_device *dev, const char *format, ...);
 
 #define netdev_level_once(level, dev, fmt, ...)			\
 do {								\
-	static bool __print_once __read_mostly;			\
+	static bool __section(".data.once") __print_once;	\
 								\
 	if (!__print_once) {					\
 		__print_once = true;				\
-- 
2.34.0.rc1.387.gb447b232ab-goog

