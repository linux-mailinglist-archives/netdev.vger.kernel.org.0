Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4C3731300
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfEaQuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:50:03 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35147 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfEaQuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 12:50:03 -0400
Received: by mail-pg1-f194.google.com with SMTP id t1so829922pgc.2
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 09:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HzedBuG3ixQbGHcMrcC/7vEC3Tt14CDLtTMgPmW4+aY=;
        b=JqLNyMOBfXNUlz+CdgDYi7wevt/96lC8CNOma67I77zy2qH7Q5TvTXND2+MG7C4V+w
         0W8zoBhQV3uBm7iRMsZ0MPxu+TVGLw8LCMgtD2A7bDb/zk3NTa52roQNGIMe1vwJYzjT
         PHPLT9dvlyjBRPhbqY0ZkkUEl+NWbM1rpO8RHWQbUg1mNoMvEiMqmhzy+5Ro+PTRDnlR
         B3aY0zfiQI+KXftSE6CTSMOLMlX0Ow6lDI1pgEjRs20SEvxNReH3rgnSBNDUCO4zw9Hi
         6I6bSGfbuTK3ivr8b5j+O0ICoeKU+rXAuyv1RqpuBpflmb1DPd0UVsYviTEeSN+0LurC
         HaHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HzedBuG3ixQbGHcMrcC/7vEC3Tt14CDLtTMgPmW4+aY=;
        b=suCEAw1K28ol1vF5C0zUtebAt5YujJkoypVD/Wd5NCeHn28FfJxxdUYwc4qHW/P4QT
         GPOQ4JlI9rL2pSBE6Ee/3YkT7jHGq8DCnYXfFd9ncuDrHMNdvd3Tg+ZPyDM/VFEdPJot
         ZPrvN4pevfx2ntGu1pp6MCKc0r+yQKYIh4ucbJAs7+xMKt9p7H2s6rUw/iBjRYLtMZwW
         DO937GqsRZVYHpR0sB80dm2T19JFFhgItfwQvfqa0RKxl1PdfbmSGU2wqMDOwje7rCds
         IHq7Mje7woqypXMNwQYSWfWuKRFJ1zTKiDF/W6i4x/krDxzoLcJuzp0FEZwcYpJ6LwgL
         nF/g==
X-Gm-Message-State: APjAAAX5fKP8Nl9ERqXX2/hMGFhnVCQ0xVWQAec5zdgCQv7iArX1ACEe
        UMzbAQOuz81R9rs+046LQfpJH8lxnfA=
X-Google-Smtp-Source: APXvYqyktH9q2FdBRv2CelSH7Y1+umVpQKZFtb2mfpow/uXS8vSoE3JEz/yrW4DmIYSbr83fEIPakA==
X-Received: by 2002:a63:7009:: with SMTP id l9mr1198942pgc.228.1559321402577;
        Fri, 31 May 2019 09:50:02 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-249-119.hsd1.ca.comcast.net. [73.223.249.119])
        by smtp.gmail.com with ESMTPSA id e66sm8696835pfe.50.2019.05.31.09.50.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 31 May 2019 09:50:02 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org, dlebrun@google.com,
        ahabdels.dev@gmail.com
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [RFC PATCH 1/6] seg6: Fix TLV definitions
Date:   Fri, 31 May 2019 09:48:35 -0700
Message-Id: <1559321320-9444-2-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559321320-9444-1-git-send-email-tom@quantonium.net>
References: <1559321320-9444-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The definitions of TLVs in uapi/linux/seg6.h are incorrect and
incomplete. Fix this.

TLV constants are defined for PAD1, PADN, and HMAC (the three defined in
draft-ietf-6man-segment-routing-header-19). The other TLV are unused and
and are marked as obsoleted.

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 include/uapi/linux/seg6.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/seg6.h b/include/uapi/linux/seg6.h
index 286e8d6..9117113 100644
--- a/include/uapi/linux/seg6.h
+++ b/include/uapi/linux/seg6.h
@@ -38,10 +38,13 @@ struct ipv6_sr_hdr {
 #define SR6_FLAG1_ALERT		(1 << 4)
 #define SR6_FLAG1_HMAC		(1 << 3)
 
-#define SR6_TLV_INGRESS		1
-#define SR6_TLV_EGRESS		2
-#define SR6_TLV_OPAQUE		3
-#define SR6_TLV_PADDING		4
+
+#define SR6_TLV_INGRESS		1	/* obsoleted */
+#define SR6_TLV_EGRESS		2	/* obsoleted */
+#define SR6_TLV_OPAQUE		3	/* obsoleted */
+
+#define SR6_TLV_PAD1		0
+#define SR6_TLV_PADDING		1
 #define SR6_TLV_HMAC		5
 
 #define sr_has_hmac(srh) ((srh)->flags & SR6_FLAG1_HMAC)
-- 
2.7.4

