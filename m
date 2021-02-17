Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBFB31DED1
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 19:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbhBQSIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 13:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234761AbhBQSIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 13:08:44 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981F7C0613D6
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 10:08:04 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id t25so8994998pga.2
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 10:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6OppbIT1M1gvXOWsdS8QHmLhNPa/v+vgtcvDuscwBAU=;
        b=UqtIF1fr5ZmskUEOK8hSkSQ8fRyP/pvxLOfAusV3ShQaA0M/mSrmMhf03LQ6TAxvLq
         WdudHxyU5d44PHDb0t/Zwjf+Zii8Gr5DMZb4h80GWVKsO/CrCVuuCK0Z0U1on5YtHyNM
         lDcCcvXS6RfSdWmhZrANEfSQ0jVBbvsxLS0nt5gwCz4HHBi3XMlZmQRtU5WKoW0nPqpa
         8CylD5V5Cr5aH8aRGiwtIhHH6BXwcsSuOAW1kuxgT/aScDCNpcjZW5cAyLbYt/sMsMyZ
         3hsZTj1S3Dji9Ej70ztpEtoyx7UE740q/PmfZpiBJiM1egjuukUxbqPZPwf9RimJejnu
         niYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6OppbIT1M1gvXOWsdS8QHmLhNPa/v+vgtcvDuscwBAU=;
        b=C8gEEmxnues5Nek+JiZMFu3RJf3CH3joZ+l86VmuQvRZ0d/sISGJi9nVVblzuwt7BK
         KgiZw8yVkrMjm6QwmKoUVENwfou1AKZQwp+pVz02oDtaLuhR2DShjlyegQwYj7RyVQvL
         ErcX6xEIFbMEFkUWSrYtQym1pChu125YvEt+ahUstTe5CBKTz/OApivx57WOThmrwlUt
         KJY9yDRpjSQ8/4Rg0KLhjQDQDbWE4z0Dxi4YVo3tZJPGclryImkmSHRB9nAPzB9Fvu3Z
         ryDkqWajDrjg8gmj2hzK8YS+s1CZCnvLgIH/sXMP6pKdVKk6L6xkmw8M87CyWzDuM8kC
         wP0Q==
X-Gm-Message-State: AOAM53293Ifiz8Ov20eG1EQlEj96KEZ2twu5+NVefE+rf6OSgijWIIpy
        52bmyy6aNafpXgYbDuOgk4Q=
X-Google-Smtp-Source: ABdhPJwPH0jjNOVx6BoIrg3vvVurrhycb+v2NB2NtP5Ivk9BTPDKdHQIjOBE5vVoLK00rMx8OdJ05w==
X-Received: by 2002:a05:6a00:2286:b029:1ae:6c7f:31ce with SMTP id f6-20020a056a002286b02901ae6c7f31cemr507610pfe.6.1613585284239;
        Wed, 17 Feb 2021 10:08:04 -0800 (PST)
Received: from localhost.localdomain (h134-215-166-75.lapior.broadband.dynamic.tds.net. [134.215.166.75])
        by smtp.gmail.com with ESMTPSA id m23sm3181293pgv.14.2021.02.17.10.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 10:08:03 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH V3 net-next 2/5] ICMPV6: add support for RFC 8335 PROBE
Date:   Wed, 17 Feb 2021 10:08:03 -0800
Message-Id: <8eb733939ea7b22513ba6682571d1a44f651cf55.1613583620.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1613583620.git.andreas.a.roeseler@gmail.com>
References: <cover.1613583620.git.andreas.a.roeseler@gmail.com>
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

