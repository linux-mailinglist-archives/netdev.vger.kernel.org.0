Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6365B5450D0
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 17:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241703AbiFIP2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 11:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344552AbiFIP2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 11:28:21 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EA34D692
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 08:28:20 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id n10so48220718ejk.5
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 08:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=MmQPCLxoccQNbCuN2SbiZusrore0Dxz2IwOtJ9sHNVk=;
        b=Z3jwWchsE55ubQCcFr2lgQTqIzoMhobTmBJBlv1REdGu0GdbD+1kr0/53z/oWG7ATC
         6Ibt/KgGecQv4TX8Rd8qiN6n5TYkxkc/816N7O445nbh4nJ+s7QUuqYmwnBcYvrsVizJ
         mzYDqJSzpeAzl7IxOnpD36ONfIdkCjuRFTTb7HGcTIHtuFsl8f7epIvfnX+yZVAyhEW7
         uCmBy14+Bhp0mrrHmu2iB7aVaTggBInvQBd0zTXb1KxGnCG8Wc28gzZclzZRqUzeXJZR
         qJcf/4cEdL+l9vdfcalAd9V2os0Lcni/7A4jIe/Shwhn4vVInc5xdQYTyn4mXJh1URxZ
         CY6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=MmQPCLxoccQNbCuN2SbiZusrore0Dxz2IwOtJ9sHNVk=;
        b=D1Y8Lf9a+Y398PSSggcIQ7YyMwlwBRAsP9cnOax6Z9NTkb6AL3BVPW3scTd6PozoRV
         yrrTROnprXRLHmARMv233OzfvmLWwyK8xLfaAgIYR8clH3xGb90Bw66tETWow6OQt3aL
         DvXKow6tHKRGxRbtoREizFReePdnW4n4sTTlP8L0BxPVKhakZtDz4Z7CdHodgfSt1upQ
         fnEWoekdSZXFiDgYSzH5OQ8wsi5Y+86dudAzq/8fZDCaSeJhbntfGVmiU9B/lAkOuXMJ
         Z5L0Tc9xrKtVl3ufmFWk2tL/QEPP6qDhm+MgGxqIhxRW6EJhM8WQWxyGoa0rBJvh4qPK
         L60Q==
X-Gm-Message-State: AOAM5320T/C34lRyj5+LmEAnylDXd49yP/y4oUDxdeXeX0KdLcx44vN+
        LHGEjrtp3oCT0LtILJDWQ7Xohp9vYKr0LA==
X-Google-Smtp-Source: ABdhPJwR2V44GG+9YW41E8KP4wJwlwzGVlLT+JKLAul+DmTi3I9Lzy9IJ385PvXVXPZcEzp45pDMcg==
X-Received: by 2002:a17:907:2095:b0:711:fbbe:e307 with SMTP id pv21-20020a170907209500b00711fbbee307mr4327740ejb.274.1654788499092;
        Thu, 09 Jun 2022 08:28:19 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id o2-20020aa7dd42000000b0042dc460bda6sm14501806edw.18.2022.06.09.08.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 08:28:18 -0700 (PDT)
Date:   Thu, 9 Jun 2022 17:26:10 +0200
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH] net: error on unsupported IP setsockopts in IPv6
Message-ID: <20220609152525.GA6504@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IP_TTL and IP_TOS sockopts are unsupported for IPv6 sockets,
this bug was reported previously to the kernel bugzilla [1].
Make the IP_TTL and IP_TOS sockopts return an error for AF_INET6 sockets.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=212585

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
---
 net/ipv6/ipv6_sockglue.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 222f6bf220ba..2cdaa8f3a8f2 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -1012,8 +1012,16 @@ int ipv6_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
 {
 	int err;
 
-	if (level == SOL_IP && sk->sk_type != SOCK_RAW)
-		return udp_prot.setsockopt(sk, level, optname, optval, optlen);
+	if (level == SOL_IP && sk->sk_type != SOCK_RAW) {
+		switch (optname) {
+		/* Some IP opts are not supported for IPv6 sockets */
+		case IP_TTL:
+		case IP_TOS:
+			return -ENOPROTOOPT;
+		default:
+			return udp_prot.setsockopt(sk, level, optname, optval, optlen);
+		}
+	}
 
 	if (level != SOL_IPV6)
 		return -ENOPROTOOPT;
-- 
2.36.1

