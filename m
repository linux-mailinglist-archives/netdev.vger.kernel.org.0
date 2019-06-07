Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F047394DE
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732295AbfFGSzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:55:48 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45896 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732083AbfFGSzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 14:55:47 -0400
Received: by mail-pg1-f196.google.com with SMTP id w34so1601178pga.12
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 11:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OqkWOX4LCkr1GiS0NEd3XdV9+Bg2GAYGC3wHGsctfs4=;
        b=xj1NfLfNCqFw8lMJ0emIJHmAGRCpVI6zLPvM9a+6T8mAlwgCOq9k4tqDoIRyP3kG1u
         d47J2KUBy2RIAC3KKPWIixxmn1oKR194cLWjYF0TVXq7oEJ1fd3NYoyMgDwochEvYOqL
         uy8gUn7r5Cf8broR5IyPZteKi4Ie0+eDGMkZOZz5Jg10+eedL0quMLk89NdgokmQluHa
         gSkeNgMEgfBFFtxUgLyGzWP1MDF7Id5O51xndCEkn9aeY9u9GsZDgLZSY+794JvoFJKD
         5lotDawgarKJ0J3MjImDodblKsVAB7aWAydS/TZMUGOX4NGz/2iDCzJG8ftIHn77A46R
         KexA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OqkWOX4LCkr1GiS0NEd3XdV9+Bg2GAYGC3wHGsctfs4=;
        b=n5zHMmPPUE+3YY57i13+wKXxye2egP/U7WnSvL0jFZWojVyQ9xUJ6HECDMFUOsrEre
         LRI5dS3vWaMI9QjQYQpuWg+bywYYAuAbJfyzhUXDYTPbNBnvvLL6wU2G0/uG0d/U3Lns
         Lp+UgVB3foSv448tYACWMAs6W3dH7fIQFfXl7x0sCcS+tfJ0sGsSFCSDjmjCLjZOGYw7
         Lm84kciqATaeGVaPl5K+2xsDdK0Lx46ULGcHIPm2tzCqmfdP9bjDTKubbJ7Q8Tw6s4zY
         2j+H8DIYFCQEXSfZM+DP0LKhLgwaeKEiQPD+gceffPu0x5Re7rMoXgnm9dnfPuNKL8D2
         neZw==
X-Gm-Message-State: APjAAAWQlNHmx1xWfCxXn4zhvYNdLoKAUsdXb1HXq4fSGsvWl21PfNW4
        zn0Br5j9FfSeBpH2X2O19riwlqHaff8=
X-Google-Smtp-Source: APXvYqycYTNh4Gh72Di6zzikLCIN1e/x/k0zEuxo62TetlfeHHssOExhZlaNAP0EUJESQ4hh2TsSsw==
X-Received: by 2002:a63:e250:: with SMTP id y16mr4311934pgj.392.1559933746947;
        Fri, 07 Jun 2019 11:55:46 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-249-119.hsd1.ca.comcast.net. [73.223.249.119])
        by smtp.gmail.com with ESMTPSA id i25sm3181933pfr.73.2019.06.07.11.55.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 07 Jun 2019 11:55:46 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org, dlebrun@google.com
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [RFC v2 PATCH 1/5] seg6: Fix TLV definitions
Date:   Fri,  7 Jun 2019 11:55:04 -0700
Message-Id: <1559933708-13947-2-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559933708-13947-1-git-send-email-tom@quantonium.net>
References: <1559933708-13947-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The definitions of TLVs in uapi/linux/seg6.h are out of date and
incomplete. Fix this.

TLV constants are defined for PAD1, PADN, and HMAC (the three defined in
draft-ietf-6man-segment-routing-header-19). The other TLV are unused and
and are marked as obsoleted.

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 include/uapi/linux/seg6.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/seg6.h b/include/uapi/linux/seg6.h
index 286e8d6..3a7d324 100644
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
+#define SR6_TLV_PADN		1
 #define SR6_TLV_HMAC		5
 
 #define sr_has_hmac(srh) ((srh)->flags & SR6_FLAG1_HMAC)
-- 
2.7.4

