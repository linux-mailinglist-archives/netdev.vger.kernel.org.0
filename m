Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A01F4FF539
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235021AbiDMKys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234173AbiDMKyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:54:45 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9452593AA
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:52:24 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id u15so3061850ejf.11
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BbnHd4o5vqqdVnPqrILq5Jq5sTNcgygmX2gIAOpm4mw=;
        b=q3Rk/2KB7HFk7J7NZDNTLPkXze8TdzSBWoDcZfcs8MVwnGlLHHKepzt+ioTyPh9U5K
         e6UiYrM/hkvDQyjqwUoqegngxb7Sp1GMfJ9L6kNFzRamoetEIZ57i41+2CWhdx/omzrr
         5JoZzAzynleDl1MKk9KGO/pFfGIExlENek3seJD6BwB35giZPiEfvRkQcfkPKm/4SKfC
         c8Fb4fah5m4Y1idIi7UShlRDBgRCH89U6XkycmNr9cPt1RbiMJlW1QU3a57+IjoZn+pf
         +9ibxwmRLBKEMd8N94SyTsia7FOX5Cel1IiDLhw0fq6ks3pq7n1aeyPSh5Xa10rPchk0
         OrxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BbnHd4o5vqqdVnPqrILq5Jq5sTNcgygmX2gIAOpm4mw=;
        b=NZn9Cvm4ViRVf8AoCyMITepjbsColn+TwBtMtWw2I0P7CEaiERZLU4Szq/f9yAMkgk
         I+jeSiBy47tdvJWkTltklJsKpeuisxaitHkw8hARofjb1TTfFtHvV5mTLGozBnaeZKwz
         AesVpPADduOvesvuUjoXAHAT3tbL9FQTqsGGnDEPQ6wRyVCpM8lESsY8tK0ny9dYT0Im
         ljnx4VYSZFVIH4lLWBIcFhB8Ei9YH0vf5PLqj1irzJsJWTVsbL5u447dkmF1ThBVtKmz
         XOkkfyziOIx+Xfp2Nh1ApynXKkOv3vOvcKMFAENEfWXiGxUwEbIDOC+8UF9WsCg4Zosk
         ab4w==
X-Gm-Message-State: AOAM531lLEciat4ZxLJpO9jTKfojaw9ED7phkX6ryFq77NcNP5pGPKL4
        0WS8F+aWo6dZwsUPt2CY+ryV7sSzdJQJ8smM
X-Google-Smtp-Source: ABdhPJxAvtCcmeSBhisp1pbrVEqL//uk/agEXWAWo/IQOQjQ1T+jZW3uMWT3L9D0+ZjwXmfhmZ152A==
X-Received: by 2002:a17:907:7b92:b0:6db:71f1:fc20 with SMTP id ne18-20020a1709077b9200b006db71f1fc20mr37128934ejc.343.1649847143262;
        Wed, 13 Apr 2022 03:52:23 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id v8-20020a1709063bc800b006e898cfd926sm2960952ejf.134.2022.04.13.03.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 03:52:22 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v4 02/12] net: rtnetlink: add helper to extract msg type's kind
Date:   Wed, 13 Apr 2022 13:51:52 +0300
Message-Id: <20220413105202.2616106-3-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413105202.2616106-1-razor@blackwall.org>
References: <20220413105202.2616106-1-razor@blackwall.org>
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

Add a helper which extracts the msg type's kind using the kind mask (0x3).

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
v4: new patch

 include/net/rtnetlink.h | 6 ++++++
 net/core/rtnetlink.c    | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index 78712b51f3da..c51c5ff7f7e2 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -19,6 +19,12 @@ enum rtnl_kinds {
 	RTNL_KIND_GET,
 	RTNL_KIND_SET
 };
+#define RTNL_KIND_MASK 0x3
+
+static inline enum rtnl_kinds rtnl_msgtype_kind(int msgtype)
+{
+	return msgtype & RTNL_KIND_MASK;
+}
 
 void rtnl_register(int protocol, int msgtype,
 		   rtnl_doit_func, rtnl_dumpit_func, unsigned int flags);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 2c36c9dc9b62..beda4a7da062 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5947,7 +5947,7 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return 0;
 
 	family = ((struct rtgenmsg *)nlmsg_data(nlh))->rtgen_family;
-	kind = type&3;
+	kind = rtnl_msgtype_kind(type);
 
 	if (kind != RTNL_KIND_GET && !netlink_net_capable(skb, CAP_NET_ADMIN))
 		return -EPERM;
-- 
2.35.1

