Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988C4321AFE
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 16:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhBVPOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 10:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbhBVPNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 10:13:50 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1FCC061793;
        Mon, 22 Feb 2021 07:12:47 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id v1so19442055wrd.6;
        Mon, 22 Feb 2021 07:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pdGuMOt4W9f6d632mZ/3+qcmk+vyhqvdNPaPLq7IjEM=;
        b=k6YPsBKxhiIVQgrR1NdSYHdWn4S97ym5N5LCHyB5TOSQxclZfqhb+K112mwVOvPdbc
         YsUsd4glncxcxs/mU+68rO2yBsai6OJMWHsI7TDIBaGyHKBwGGMOcRdSxtby0dHsakBU
         xudObvNr9cstN2fAOzMrQywEDT+qKOMFCrVBy1Yvo5/K3pN1wuEhu5nMw7+Vn4P+oyzq
         kPMccoOCphrMrfGWAsxbhPcYfTeCYThv/ZThSHcajVGLTJ648gdvc90RDNiEvAwmz1CF
         EodIi/cqA2HJ68SYPUU3JACVRe/vGDjIvh4jIeA6QGbl9MIa6ktk+C1cJU8HA7lmYQtu
         aDrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pdGuMOt4W9f6d632mZ/3+qcmk+vyhqvdNPaPLq7IjEM=;
        b=fgqmJuN4KsslMmdXYjIp12sX91+G/WcEZOYfWSP/w8IjHsPOG5/ukFFlAs6XFVu7ov
         iRaJNknjoqN9Odp4MmR3eTJNBSOWwM6IVUnpOjgRZWzL5MflhmAT50pQ9GoCWsev+BgQ
         8RcdjfPN6rOGT0hSmXtCdIlsk4fZmk0hyj8fVa8VSwiCGc7pNQSSnTXx10WkQi0rdUdh
         lRK6V8YchkCSzINycTvTgRiSSwFmpBiA9gNTdTF0fCk55LWa9tG5aafdKyHX+ofRArJj
         jxvK+b+DDbJTrqsyo2FCcW5rZsKaCiValUMIiG9wcNOjSgJrRLsgF6WZqndAThmbTa+u
         G9lg==
X-Gm-Message-State: AOAM5331oP5EgE+g0QyYZ9rsU2JkiylNPXK+MPzvhq/J83qCBeZCpkZV
        hBz4Gy4SB0bN/0/sLlivlD1rkBr3yATt1i6RVik=
X-Google-Smtp-Source: ABdhPJxrpzigvnHf99oo4cOIbGkxhLJ4N3VZOzCxRfNHMT7x79PfV4RdRx6LhrL4FqA9HYIKUqBMqg==
X-Received: by 2002:adf:ff88:: with SMTP id j8mr15600241wrr.62.1614006765655;
        Mon, 22 Feb 2021 07:12:45 -0800 (PST)
Received: from debby (176-141-241-253.abo.bbox.fr. [176.141.241.253])
        by smtp.gmail.com with ESMTPSA id m17sm24783472wmq.5.2021.02.22.07.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 07:12:45 -0800 (PST)
From:   Romain Perier <romain.perier@gmail.com>
To:     Kees Cook <keescook@chromium.org>,
        kernel-hardening@lists.openwall.com, Jiri Pirko <jiri@nvidia.com>
Cc:     Romain Perier <romain.perier@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/20] devlink: Manual replacement of the deprecated strlcpy() with return values
Date:   Mon, 22 Feb 2021 16:12:14 +0100
Message-Id: <20210222151231.22572-4-romain.perier@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210222151231.22572-1-romain.perier@gmail.com>
References: <20210222151231.22572-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The strlcpy() reads the entire source buffer first, it is dangerous if
the source buffer lenght is unbounded or possibility non NULL-terminated.
It can lead to linear read overflows, crashes, etc...

As recommended in the deprecated interfaces [1], it should be replaced
by strscpy.

This commit replaces all calls to strlcpy that handle the return values
by the corresponding strscpy calls with new handling of the return
values (as it is quite different between the two functions).

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 net/core/devlink.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 737b61c2976e..7eb445460c92 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9461,10 +9461,10 @@ EXPORT_SYMBOL_GPL(devlink_port_param_value_changed);
 void devlink_param_value_str_fill(union devlink_param_value *dst_val,
 				  const char *src)
 {
-	size_t len;
+	ssize_t len;
 
-	len = strlcpy(dst_val->vstr, src, __DEVLINK_PARAM_MAX_STRING_VALUE);
-	WARN_ON(len >= __DEVLINK_PARAM_MAX_STRING_VALUE);
+	len = strscpy(dst_val->vstr, src, __DEVLINK_PARAM_MAX_STRING_VALUE);
+	WARN_ON(len == -E2BIG);
 }
 EXPORT_SYMBOL_GPL(devlink_param_value_str_fill);
 

