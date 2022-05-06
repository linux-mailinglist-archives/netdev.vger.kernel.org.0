Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1E051DFE4
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 22:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392475AbiEFUFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 16:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377267AbiEFUFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 16:05:49 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5567B5F8D7
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 13:02:05 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id y3so16318706ejo.12
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 13:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qCsNwD6N23cm0Ctz+SSIq1fYoVaai4S5HfuNlZ+jRow=;
        b=F0BU5UrNmhWK/luvKeJ1wxsC1L+7xYqXb334tJNv7CeMnkG2ukxseOm+l/lX0Ib3pZ
         2Wu3IQjdvfxZMmiLjFegTnVE6Bgr0FAgt0QnHS4sUWsqk7k73ErCAltWJFpnuSB1IfDQ
         OM86E/8dTAWznqM/0+nabhQrPiBMc+Gmjn2vvdscxVUb5H5SVLxpSHWUR2FFMXcti7qf
         2/ngqSrB6VL/qR6Ex/n3E8NH1KzB2We7O5uUw9hydElHdEUi6d1EWIVaOnWhiel8FT+g
         BzOmfUt9KigLoJYAtT5MxP9f+A41eze5nS9N5pQMTTeoXgoQTwRL8sRjxu1op2buN4Vc
         qG+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qCsNwD6N23cm0Ctz+SSIq1fYoVaai4S5HfuNlZ+jRow=;
        b=KUsKRMa7N3CzWaE5vl50D8PzRraDF5vM7SnV1HlT+Ts3nNF9uEnSplL1EF/i89LeCr
         pW8OycsgsU5YaPY0Sa2or2lg++INlVPcwKDq6iyza/fLwuaKC/27VvLrOjxbyuoSkXuo
         OLWC6NqthDcsDLioqLw6RY9NiUQVF2UvyzseXEsEUuvv+r9F/AGL8pRUO8LKkHLiCxrC
         cjvprptJpRlvZFEoLAHetQ6irE8K3oGMv+y7C77R1yK39jMCxxnrufyMwld7ZZNb3p4H
         eGtVs5VcJGe2x+1Xho0qtSnmMgLav6BRBUIP1Edv/+OT/uzJnhiGUd+LH81brTCuoqAw
         03fg==
X-Gm-Message-State: AOAM530YoVFKFSGDWJgbfUikUL5rcdHAhT6HArdi+iIP7koz4WDDkK/3
        eJRvidTfZW9lVM1gnSmOVE/StA==
X-Google-Smtp-Source: ABdhPJxQ/d3Sv9gi2O4ujiX7gArSmh8SNgGGt9acEP1EpuqHK/8LXXnU/cAx/OnoC1NU6nLSqIrKLA==
X-Received: by 2002:a17:907:3f95:b0:6f4:f45a:9f66 with SMTP id hr21-20020a1709073f9500b006f4f45a9f66mr4397567ejc.544.1651867323816;
        Fri, 06 May 2022 13:02:03 -0700 (PDT)
Received: from hornet.engleder.at ([2001:871:23a:237:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id w5-20020a056402268500b0042617ba6389sm2719887edd.19.2022.05.06.13.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 13:02:03 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, vinicius.gomes@intel.com,
        yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     mlichvar@redhat.com, willemb@google.com, kafai@fb.com,
        jonathan.lemon@gmail.com, netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v4 2/6] ptp: Request cycles for TX timestamp
Date:   Fri,  6 May 2022 22:01:38 +0200
Message-Id: <20220506200142.3329-3-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220506200142.3329-1-gerhard@engleder-embedded.com>
References: <20220506200142.3329-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The free running cycle counter of physical clocks called cycles shall be
used for hardware timestamps to enable synchronisation.

Introduce new flag SKBTX_HW_TSTAMP_USE_CYCLES, which signals driver to
provide a TX timestamp based on cycles if cycles are supported.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 include/linux/skbuff.h |  7 ++++++-
 net/socket.c           | 11 ++++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5c2599e3fe7d..4d49503bdc4d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -615,6 +615,9 @@ enum {
 	/* device driver is going to provide hardware time stamp */
 	SKBTX_IN_PROGRESS = 1 << 2,
 
+	/* generate hardware time stamp based on cycles if supported */
+	SKBTX_HW_TSTAMP_USE_CYCLES = 1 << 3,
+
 	/* generate wifi status information (where possible) */
 	SKBTX_WIFI_STATUS = 1 << 4,
 
@@ -624,7 +627,9 @@ enum {
 
 #define SKBTX_ANY_SW_TSTAMP	(SKBTX_SW_TSTAMP    | \
 				 SKBTX_SCHED_TSTAMP)
-#define SKBTX_ANY_TSTAMP	(SKBTX_HW_TSTAMP | SKBTX_ANY_SW_TSTAMP)
+#define SKBTX_ANY_TSTAMP	(SKBTX_HW_TSTAMP | \
+				 SKBTX_HW_TSTAMP_USE_CYCLES | \
+				 SKBTX_ANY_SW_TSTAMP)
 
 /* Definitions for flags in struct skb_shared_info */
 enum {
diff --git a/net/socket.c b/net/socket.c
index f0c39c874665..5c1c5e6100e1 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -683,9 +683,18 @@ void __sock_tx_timestamp(__u16 tsflags, __u8 *tx_flags)
 {
 	u8 flags = *tx_flags;
 
-	if (tsflags & SOF_TIMESTAMPING_TX_HARDWARE)
+	if (tsflags & SOF_TIMESTAMPING_TX_HARDWARE) {
 		flags |= SKBTX_HW_TSTAMP;
 
+		/* PTP hardware clocks can provide a free running cycle counter
+		 * as a time base for virtual clocks. Tell driver to use the
+		 * free running cycle counter for timestamp if socket is bound
+		 * to virtual clock.
+		 */
+		if (tsflags & SOF_TIMESTAMPING_BIND_PHC)
+			flags |= SKBTX_HW_TSTAMP_USE_CYCLES;
+	}
+
 	if (tsflags & SOF_TIMESTAMPING_TX_SOFTWARE)
 		flags |= SKBTX_SW_TSTAMP;
 
-- 
2.20.1

