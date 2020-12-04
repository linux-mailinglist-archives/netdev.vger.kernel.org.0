Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E58F2CE662
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 04:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbgLDDR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 22:17:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727664AbgLDDR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 22:17:28 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519E9C061A52
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 19:16:42 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id bj5so2341998plb.4
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 19:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6OppbIT1M1gvXOWsdS8QHmLhNPa/v+vgtcvDuscwBAU=;
        b=KSwdiRVUIqIAfWXb5NPKic4L2Xpn1VZAGol5E52YzNw88Q0CLElUTgvd0SuVCX1752
         NBjRQFtthgbKNUxClysdjlyNzKktR1UJg95JUuJBU6PWyFPzF99AAmdE7bYixq3jPFxF
         adt/JqBNEciFderfyXAWvuGG+9E0CUU80qCvmAnY5HoBFYiNJNysqsOJI0ZvKiswImH2
         6t3VKuGypN+EBgC3lPMAbUXkL1AT3K2b6jdSpTC70NPxfrq+OzbvpUcEMRxVCnkEsYcu
         63x3N48Koaa2lIwcPR3h9aW5R5h19Pm5DYNjnNfPSnLJvymlgA6TogyYVpqNjaCjpBi3
         iE2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6OppbIT1M1gvXOWsdS8QHmLhNPa/v+vgtcvDuscwBAU=;
        b=cRP2qgO52kJ2Y3unHfTLxVpZlrTIZqbzTGzWwxHIC9Fs3QkPnkO0zKa+JFOShW0zpN
         Os4IBGuTh94o+KmUhkAIiJqYHhsmZ0Dh0Eu0CwVgeE0PmEkISaxwxT5ochGaDezhZ/Ye
         Y80Z+RhVYSt52PoFTq22lhQ7jGzpuSUmuQSVcLR0wEi1O62s+pSo4uG/JbNjHFbeYcSi
         BAZKafC4YCyc1zCYChv+XrZKvLqq8sqyHU1zZpUs3yL43FnYfUEyzeC+ZoYxSJzwztdt
         XJRZNSGe4MMVs8Ap8QOwS9l8ofqBe7db4VIEgzRLnSREvRHOJs6NHRC7ySr6EwUbHrQH
         /dXA==
X-Gm-Message-State: AOAM531x6itCeoKcmw0kmN3/vYJuK1aVyGXfMF7M/q1Yng/dDPreNH0U
        ETgrO/Pl09G+Qq6xXWwtsCs=
X-Google-Smtp-Source: ABdhPJydM7pOfV1lov7nOfFs1SMbGTng5M6BsHCM5heeQ4/qQe0QSL0ufRP1CHOmN43KzcCcUATEcw==
X-Received: by 2002:a17:90a:de0c:: with SMTP id m12mr2128560pjv.224.1607051801939;
        Thu, 03 Dec 2020 19:16:41 -0800 (PST)
Received: from clinic20-Precision-T3610.hsd1.ca.comcast.net ([2601:648:8400:9ef4:bf20:728e:4c43:a644])
        by smtp.gmail.com with ESMTPSA id k8sm3151896pfh.6.2020.12.03.19.16.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 19:16:41 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 2/6] ICMPv6: support for RFC 8335
Date:   Thu,  3 Dec 2020 19:16:40 -0800
Message-Id: <d66173f58fb82aee60100b715ec37e8984abe880.1607050389.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1607050388.git.andreas.a.roeseler@gmail.com>
References: <cover.1607050388.git.andreas.a.roeseler@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add definitions for the ICMPV6 type of Extended Echo Request and
Extended Echo Reply, as defined in sections 2 and 3 of RFC 8335.

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
 include/uapi/linux/icmpv6.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/linux/icmpv6.h b/include/uapi/linux/icmpv6.h
index 0564fd7ccde4..b2a9017ddb2d 100644
--- a/include/uapi/linux/icmpv6.h
+++ b/include/uapi/linux/icmpv6.h
@@ -140,6 +140,12 @@ struct icmp6hdr {
 #define ICMPV6_UNK_OPTION		2
 #define ICMPV6_HDR_INCOMP		3
 
+/*
+ *	Codes for EXT_ECHO (PROBE)
+ */
+#define ICMPV6_EXT_ECHO_REQUEST		160
+#define ICMPV6_EXT_ECHO_REPLY		161
+
 /*
  *	constants for (set|get)sockopt
  */
-- 
2.25.1

