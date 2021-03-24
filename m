Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A903348042
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 19:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237498AbhCXSS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 14:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237430AbhCXSR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 14:17:56 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D30EC061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 11:17:56 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id h6-20020a0568300346b02901b71a850ab4so23928153ote.6
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 11:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Lio5CHdjePdGCdvRLilg1iaYE0Vy2lHPlsFlnZ4SNRQ=;
        b=SPAlecpI+cV6d+tuXtjpbrSrLILyPD42CX8AEAk8IlCHJKJGmH8Fz6YoE1gjyDCLKn
         KUnDFWBYi69g90Q21qwvZ/I0HYN5a4uJFQ7KK860Sw1quoneqlRbg88yQhyolJ2ULRqM
         yQ64hdYHxObkcoXXGFfi4NaV+Xj+NvBI9UNXCLnoT5FZOn2QTfTArX/aRyzy1NLHzkQ2
         yylnCHQk4PoPSEPQQEaB4PFYg6FaLrnYKHCMYoqaHn+QojgiKlu1iPBvMsLTRA9Ks+F8
         lBvX+9wcasTKj7JzNd3dJA7L3pGoXgIJX3QXXV9LJxkYWvxuwwp1UUADomY1ouDQTxrF
         4dqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Lio5CHdjePdGCdvRLilg1iaYE0Vy2lHPlsFlnZ4SNRQ=;
        b=oruiZZ2j4IlfdDkVp3Et5ONklCUedPQKeq+U+1khOKzZ9fFya5jeak2EMXPla/TYl+
         Mh3I2KOj6JzssmWxiXPuXqb60qaJz8k0rrt+dLdJpSKGsbRXcHVUX8aGlgrZL4oeEDIY
         L7qQACzwgdjak2mgI8w5ESXMgXuOGlQ7BTAenps0XkJWq8fAlMkunil6Qx6tTWOVPqL+
         NrPKwNki2xzdAhBcBwatm88C8s/4T6PcvNGOMueIxfTLQYQNZLocPk0QNYcT9YuTG6yf
         1tWZ2O9aYrIxihyoLqdFdeU0xzfueeUZ2v9CgFDrJtccr0sDLOKojGxuyOhNHZHuZYMw
         7/vg==
X-Gm-Message-State: AOAM531aKkUqR2lll8K4fWebHMlfn7xD4v/FTYjANKN56m/dsCzUt78V
        FW54i8b5G7ddUp1XkXnVX+voXeryI3M=
X-Google-Smtp-Source: ABdhPJxsPdjMZq6YVfoQJS/Sg1AE+16rDRycTX9Dr5PIRzmxWdPdFLPpTsq+tnSfS2ucnpjXXuWV7Q==
X-Received: by 2002:a9d:4048:: with SMTP id o8mr4177639oti.152.1616609875891;
        Wed, 24 Mar 2021 11:17:55 -0700 (PDT)
Received: from clinic20-Precision-T3610.hsd1.ut.comcast.net ([2601:681:8800:baf9:abb9:79f4:f528:e200])
        by smtp.googlemail.com with ESMTPSA id z8sm694590otp.14.2021.03.24.11.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 11:17:55 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH net-next V5 2/6] ICMPV6: add support for RFC 8335 PROBE
Date:   Wed, 24 Mar 2021 11:17:53 -0700
Message-Id: <e54a9a5b10b84c9c9ad988bf2ca02bbc60236c3c.1616608328.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1616608328.git.andreas.a.roeseler@gmail.com>
References: <cover.1616608328.git.andreas.a.roeseler@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add definitions for the ICMPV6 type of Extended Echo Request and
Extended Echo Reply, as defined by sections 2 and 3 of RFC 8335.

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
 include/uapi/linux/icmpv6.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/icmpv6.h b/include/uapi/linux/icmpv6.h
index 0564fd7ccde4..ecaece3af38d 100644
--- a/include/uapi/linux/icmpv6.h
+++ b/include/uapi/linux/icmpv6.h
@@ -140,6 +140,9 @@ struct icmp6hdr {
 #define ICMPV6_UNK_OPTION		2
 #define ICMPV6_HDR_INCOMP		3
 
+/* Codes for EXT_ECHO (PROBE) */
+#define ICMPV6_EXT_ECHO_REQUEST		160
+#define ICMPV6_EXT_ECHO_REPLY		161
 /*
  *	constants for (set|get)sockopt
  */
-- 
2.17.1

