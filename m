Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A07614FC374
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 19:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348893AbiDKRc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 13:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348955AbiDKRcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 13:32:17 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFB22E6B3
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 10:29:59 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id c64so7192582edf.11
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 10:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G4Lf3IeHTYSBP2jBlrEzBtLYrCtWftbohLvXAydSyEo=;
        b=S5NtrlUiP9am+mfWWs0tdCtoJF8LvNMfNHuBR0cH25+Xpn3ZnLgDT87648YbKHJ1/i
         0w0gru0NSrKVP38xmgX+es38tXRq1lmxRK/A7qXb9LaBBrcmt0gakCd3bfwwL1CvUUWT
         abEqtMI0job1tDc+M8I/C3ZpW8mK5ejPKawnfxxQEZwg1lmITGg16vsJGeF3JRx8W6fX
         PjQCCBVPSeTF8tmwS2uhHXNRfPOSAjlJI8F9Lh2YeKfwvFOlro59hJSoikLGiHJqaPA+
         HXfFFQPlSRLnHhEXB0856jTQwYzGKOBnCGyPGG/PLJkO9BzzsEd79CvZGhROfPjo6LIR
         Z4lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G4Lf3IeHTYSBP2jBlrEzBtLYrCtWftbohLvXAydSyEo=;
        b=gcXJubIP2GDu+pqKozcEy4sqhSAsIGh8J1ELwjmXUuQ3jut11dp0Xj8TnLxiPEdUeP
         iYduibHfnL2ILMGnBlJvFLYg5EI3A3Ra//AUN0z5ddI0LoNPq1xW3eWPMwchJjNp9ETc
         ZSibsYPl4DvpbR+mnXcDBK0zM3gcRrL7kFrAW/Tk+2JWr1jeJNkhqPwQkEuj71BjDByH
         Msyvzp9hFx3XqJTM01F5lEvqFcX7JjFOPN8effPVBG/5U47XC6Iu5zOTJozNr7K9oJOA
         wGLSvKd6otG634IC9LvpbeQWk7NY/Wha1GOUs2kjnL17UFbUNtxq4dnhWfrU1TqxtAFv
         GqLA==
X-Gm-Message-State: AOAM532bKwGoEXJE4fPVd3joxTkEsSunxIbWZdWO0q84qJcpnRlSCDb9
        JaKQXZIxQ4r4aXf/+3lqt8k864dBH4GcNwm6
X-Google-Smtp-Source: ABdhPJyqbmLSnA/vica9jN3RGzm1kJTGmzUhb2chcIrxH4cfEsWv5+bKSxCLe1vGXHL//QtYy97QRw==
X-Received: by 2002:a05:6402:51c6:b0:41d:196a:27a9 with SMTP id r6-20020a05640251c600b0041d196a27a9mr19718535edd.55.1649698197555;
        Mon, 11 Apr 2022 10:29:57 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id u6-20020a17090626c600b006e74ef7f092sm10325084ejc.176.2022.04.11.10.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 10:29:57 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, idosch@idosch.org, kuba@kernel.org,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v2 1/8] net: rtnetlink: add RTM_FLUSHNEIGH
Date:   Mon, 11 Apr 2022 20:29:27 +0300
Message-Id: <20220411172934.1813604-2-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411172934.1813604-1-razor@blackwall.org>
References: <20220411172934.1813604-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new rtnetlink type used to flush neigh objects. It will be
initially used to add flush with filtering support for bridge fdbs, but
it also opens the door to add similar support to others (e.g. vxlan).

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 include/uapi/linux/rtnetlink.h | 3 +++
 security/selinux/nlmsgtab.c    | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 83849a37db5b..06001cfd404b 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -194,6 +194,9 @@ enum {
 	RTM_GETTUNNEL,
 #define RTM_GETTUNNEL	RTM_GETTUNNEL
 
+	RTM_FLUSHNEIGH = 124,
+#define RTM_FLUSHNEIGH	RTM_FLUSHNEIGH
+
 	__RTM_MAX,
 #define RTM_MAX		(((__RTM_MAX + 3) & ~3) - 1)
 };
diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
index d8ceee9e0d6f..ff53aea8790f 100644
--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -95,6 +95,7 @@ static const struct nlmsg_perm nlmsg_route_perms[] =
 	{ RTM_NEWTUNNEL,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_DELTUNNEL,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_GETTUNNEL,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
+	{ RTM_FLUSHNEIGH,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 };
 
 static const struct nlmsg_perm nlmsg_tcpdiag_perms[] =
@@ -180,7 +181,7 @@ int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm)
 		 * structures at the top of this file with the new mappings
 		 * before updating the BUILD_BUG_ON() macro!
 		 */
-		BUILD_BUG_ON(RTM_MAX != (RTM_NEWTUNNEL + 3));
+		BUILD_BUG_ON(RTM_MAX != (RTM_FLUSHNEIGH + 3));
 		err = nlmsg_perm(nlmsg_type, perm, nlmsg_route_perms,
 				 sizeof(nlmsg_route_perms));
 		break;
-- 
2.35.1

