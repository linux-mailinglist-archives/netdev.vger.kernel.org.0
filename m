Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11875F0814
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 22:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729937AbfKEVR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 16:17:27 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42868 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729656AbfKEVR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 16:17:27 -0500
Received: by mail-lj1-f193.google.com with SMTP id n5so12549734ljc.9
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 13:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dfJZYQDN356gAC3vS5Gc/eKxSf6vQIBkPy62iKe5Kgg=;
        b=s6k6a+wGp/2mx1uK38oBZ/+jC4tfm8itS8bqFeRxOVirGdP58MSaYRBXzUYZ4V/+L2
         COP/NRag+vqtq4Qf51PsURkmvEgsNp+c0CHJVzabvYc38PkIpeSPGo9hb5GOMcESf+HG
         jRn581sFBenrVWeOqhU9W2Ch1hUvNMvVDDXnMuDp5gUAMfRKEK/7yY1EKJFhHqWm60p+
         0+S/0sba4G327Pfl6ti3o9OjCvtMZYikc43kuOrncy+TPWpK5KWTRO+15OAmQRXIXuCA
         ogELnd7RTGhEAw60KJn0MBxH4nnA2BGIxyH/fe/xiOOEM7PuQa7BaZvdzZCshQgB3trW
         EZQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dfJZYQDN356gAC3vS5Gc/eKxSf6vQIBkPy62iKe5Kgg=;
        b=k3Q/IaQRkoBKwG3VGDMHnPHKHA4Z81YKo1J2tWMXJ/4d79X7s+Z9N/YtVVXl/OLH2Y
         AJLqh4qdaDi/vAlVhlhiSxAum4/agqDj53tClMO861abhJVNDtBUvb2d8FPDHbvKI1ez
         j1f+/Y85+Bt5HYtW3ZSS+HX7nYdWAqCqtjMlJsjtK6szK1IrKRfzZOtsMoQX8u7b5ke+
         E+MKRXw8U2Ub4VvfMsKwlZV0D38nKMEUGyndXs+WpTiZK3sRr+I93yYoN7e6DFQCpkAD
         kfTPL1znt+PbNxj1KtE9nECiFs3XUpDzpb9yVUtzvmzuQ+HKPs5GKC+G8Bi+HCxqffrn
         CDIQ==
X-Gm-Message-State: APjAAAUcB29fruUx5G7lmcRKdxrmOXNOiLlqjoiRDGNNuLmPCZWwaTMa
        wJgtrPcbUCrehBzRzb3eGoBHEw==
X-Google-Smtp-Source: APXvYqxMlAtTmPqzAdjRV49H2CJe19EAZH91Gd8azKQvuz3IynQZt9/hSJbOTwizcl/qot8NUE+mug==
X-Received: by 2002:a2e:9a0c:: with SMTP id o12mr12744125lji.141.1572988645433;
        Tue, 05 Nov 2019 13:17:25 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 81sm9861270lje.70.2019.11.05.13.17.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 13:17:24 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     dsahern@gmail.com
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, jiri@resnulli.us,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH iproute2-next 2/3] devlink: catch missing strings in dl_args_required
Date:   Tue,  5 Nov 2019 13:17:06 -0800
Message-Id: <20191105211707.10300-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191105211707.10300-1-jakub.kicinski@netronome.com>
References: <20191105211707.10300-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently if dl_args_required doesn't contain a string
for a given option the fact that the option is missing
is silently ignored.

Add a catch-all case and print a generic error.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 devlink/devlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 682f832a064c..e05a2336787a 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -1157,6 +1157,10 @@ static int dl_args_finding_required_validate(uint64_t o_required,
 			return -EINVAL;
 		}
 	}
+	if (o_required & ~o_found) {
+		pr_err("BUG: unknown argument required but not found\n");
+		return -EINVAL;
+	}
 	return 0;
 }
 
-- 
2.23.0

