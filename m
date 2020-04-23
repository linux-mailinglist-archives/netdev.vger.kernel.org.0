Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D761B62D9
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 19:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730126AbgDWR7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 13:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729991AbgDWR7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 13:59:22 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278ECC09B043
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 10:59:21 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id q31so3315183qvf.11
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 10:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LHAoQYubidZTzuuO7yQAbFsrUp5zL/XObwidfX7j8rQ=;
        b=HPYwppnUNVY4dXEMK2vLImj6W6HQc+h5xxRFs2NEPTCaGBXGaZFw+HTSzIPqre3KN2
         0VHipinsI32clRijMTxVkl6C26FescLmVHAOE/UClTt/IfUKhOef4nwUxNhQDivxRqBa
         h489JPLx/ZP5XCvHbQeErr3G4FPk9hIvRTk25aVBrfX1MPu54XKNKY8ijZ9e5xhRoE+E
         oqI4MC8IY2xixe+dEcadzGUKYrk3unVOR9RdzWUgMJafAqD6YBhyDbj7xvgjf/ueNWEZ
         sPmw4083OcviEsz/iAL0dWKTm3gtNJLI/9J6O/HLuTVENYLrXlnsl8nbaTLOk0SVjX+U
         2jpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LHAoQYubidZTzuuO7yQAbFsrUp5zL/XObwidfX7j8rQ=;
        b=AFODvJREVIcXE9IXqwF8xgt6SirqF648Dfikw8eVCPVcJrVX+DxAUJ71rGfuwOAO9O
         aMJQiCEZGzTm+fDxc0EnlWQGr0o4N2o7hc4atELmDbyEocgLaUlSc3Nwa4Q1g2Szd47H
         a3cBg4l4+UHuUpgMdgYJ5wIHeEul37OHsy8D/O3jtZcUNMqnkm3gpG7L+fzO0eF8lUAl
         LhLPmZVLJyYiJGeuM+DTqk9TZKm3AYP6sOd5seTlpgIJlekyj7I+g2x8hOImDX5OvkzB
         kE0PGSKGTtAlNOzIMZJFNvqfoRbeAPUFe5DZnyWRsbzrWbf2RjCT2lPWWSTnFjj5BPV/
         NvLA==
X-Gm-Message-State: AGi0PuadiYL8ZlSifv2W0r7r2lDBCNfvV2bEmMGI2W7mXeOyiMJwNE3k
        3MtpX727ahYgd2ux8iOE7+ZcPw==
X-Google-Smtp-Source: APiQypLBPillB356oN3plUFNezz4hLkk4ZeKk+VkDsBhPhbtoKf5IdvX+Tm1JzfIj06AdBbCtoglUQ==
X-Received: by 2002:a0c:e105:: with SMTP id w5mr5490441qvk.118.1587664760279;
        Thu, 23 Apr 2020 10:59:20 -0700 (PDT)
Received: from mojaone.lan (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.gmail.com with ESMTPSA id 205sm2003040qkj.1.2020.04.23.10.59.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 10:59:19 -0700 (PDT)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
X-Google-Original-From: Jamal Hadi Salim <jhs@emojatatu.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, aclaudi@redhat.com,
        daniel@iogearbox.net, asmadeus@codewreck.org,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH iproute2 v3 2/2] bpf: Fix mem leak and extraneous free() in error path
Date:   Thu, 23 Apr 2020 13:58:57 -0400
Message-Id: <20200423175857.20180-3-jhs@emojatatu.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200423175857.20180-1-jhs@emojatatu.com>
References: <20200423175857.20180-1-jhs@emojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jamal Hadi Salim <jhs@mojatatu.com>

Fixes: c0325b06382 ("bpf: replace snprintf with asprintf when dealing with long buffers")
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 lib/bpf.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/bpf.c b/lib/bpf.c
index 73f3a590..b05c8568 100644
--- a/lib/bpf.c
+++ b/lib/bpf.c
@@ -1519,13 +1519,15 @@ static int bpf_make_custom_path(const struct bpf_elf_ctx *ctx,
 	ret = asprintf(&rem, "%s/", todo);
 	if (ret < 0) {
 		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
-		goto out;
+		return ret;
 	}
 
 	sub = strtok(rem, "/");
 	while (sub) {
-		if (strlen(tmp) + strlen(sub) + 2 > PATH_MAX)
-			return -EINVAL;
+		if (strlen(tmp) + strlen(sub) + 2 > PATH_MAX) {
+			errno = EINVAL;
+			goto out;
+		}
 
 		strcat(tmp, sub);
 		strcat(tmp, "/");
-- 
2.20.1

