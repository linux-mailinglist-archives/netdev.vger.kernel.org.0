Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA66630E743
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 00:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbhBCXZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 18:25:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbhBCXZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 18:25:17 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208B5C0613ED
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 15:24:37 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id y142so864881pfb.3
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 15:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6OppbIT1M1gvXOWsdS8QHmLhNPa/v+vgtcvDuscwBAU=;
        b=MgIpxys16D2vZPui2hhxB+aIYYG86L+CQuBg5f0LIRkcsNCHlO+DoUyHvab0DCUUi3
         0FhiDJri1OfeqyWau6C6J/NPTWgjQwjuG+L2N/T5ThR4WjTUNSvRTcA3HJ+IDH7ZTsJb
         QOCq8RzlOvIvQ3rf1IB+5o36aA9ZbpqhJC+bPkF4gZ0pYXZnk7oHTJUNp8wRAWH/kYvc
         utulpOPU+SczBpGxZTmHOGWMUp6KqWKml/VmkK+bcL32qT/XEBJYT0MBgUuHctq88H52
         ea9d6W4A1UoaRlvAVyghVzUjg5n79TWBz9BUn800SQgeAZaI8E5l8VKBUfYukq4qKhr7
         QItQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6OppbIT1M1gvXOWsdS8QHmLhNPa/v+vgtcvDuscwBAU=;
        b=d2wGXANHEwWQQ3yDKI7EBYg6RBYF1XxFoBNeiNFe5KflChem4Te3bkglTJz6e7Ix3h
         ZRNcEFUmDv06d3CgZ46/acEA7Jnr0w8wyz9WIPYURlfV6U5e2o+Uy049Aegn9j+V2X5c
         yCStDtkYu1D6ZTVGRpM2+Ukyv5vEkFq9zQbGv6O55GTlr/PpDGRHBbQOzMaHNXk9In8G
         dSiWSZMFoUBmwcebNK5jbdP+WemLxaH0tL65g/IRZWNjx61+iyRG81HyhkoIBZTgoq90
         vDMzvrT0R0YnQ051RezZSJ8BYWPlxoe7shwqwVdzw6hzG+n7ldAp/W7YQetIiIBn4nRE
         M0Aw==
X-Gm-Message-State: AOAM530tR14WHvvOG95Txu6+/yOuO6BL6rCOh6Cb42PZ8er43sGkrnR/
        3gOLuIweR9E2SuFJs2vch9g=
X-Google-Smtp-Source: ABdhPJwp9iG+8PEPYSZfvM7MBOIDbAcvABg8yz6Qd8zON0xtzf6hGe3fJQC/BVuQbY8YBkgi9jfSSQ==
X-Received: by 2002:aa7:8b0f:0:b029:1c0:e782:ba29 with SMTP id f15-20020aa78b0f0000b02901c0e782ba29mr5189137pfd.37.1612394676770;
        Wed, 03 Feb 2021 15:24:36 -0800 (PST)
Received: from localhost.localdomain (h134-215-163-197.lapior.broadband.dynamic.tds.net. [134.215.163.197])
        by smtp.gmail.com with ESMTPSA id j123sm3562726pfg.36.2021.02.03.15.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 15:24:36 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH V2 net-next 2/5] ICMPV6: add support for RFC 8335 PROBE
Date:   Wed,  3 Feb 2021 15:24:35 -0800
Message-Id: <4ba5f0996433e2f509db6360bbf9c86e1a25beff.1612393368.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1612393368.git.andreas.a.roeseler@gmail.com>
References: <cover.1612393368.git.andreas.a.roeseler@gmail.com>
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

