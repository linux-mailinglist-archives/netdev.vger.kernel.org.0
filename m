Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21A24FF53C
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235058AbiDMKy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235019AbiDMKyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:54:47 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5E4593B8
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:52:26 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id s18so3204369ejr.0
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uUhhwavoelOAutf6ZINYv5+4TG3VETWVUGFixQHcuak=;
        b=rLSJSouYiv7OkG/FyDtfvfS0x+gh2sGEdXXD3TxkUkcmfLkc4s3DwFs9WTIygFn5Fj
         9dSFB3Q1LOeTUmj52Pu5jrZS6Lqgao9V4kPo8O8KEc2Q/Kez1XjZZY4DPSluEyfFd4Ww
         EydDZh+HT81QxaYKcL6dvGh6SYfTkUwGZ+P7sw8+uGAjks7+/cXXSX2OzW4UjCXD4jly
         fx8cx49P+Jph5i4PQluNOpPv8OtonmhYKrDY9BeqB4i4IEa6rZhhDcdKDVufnhylZZ9E
         aPGeIj0Il1AgFqn+S7NrqP+SoGJSPoPoJSTOaVbWq47E7ub44xVG+fFXXW8ChJPQthi6
         CPQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uUhhwavoelOAutf6ZINYv5+4TG3VETWVUGFixQHcuak=;
        b=t1mVYYCz+9kcXmTzhOFeIAdrUm46aWlyshqER2/0TxWxiiDedl9+yilesJY3S7lPP8
         /4hMlSfgBWFEjFACFz0ZwuBPfqkfH4Mr7WmIMnv3/+vhL7WP8tDEaetdLSlereB+7Ab3
         84SpTTUTOiSkf+myXZ/f3ZEOGaD7KCQglBcjrJdV/fzWCwOzkby0wE6H95Vdq7sd6B0W
         7srUgrQgAHQ7TOprTbrl4u3OHf+xxU19k32yelpEYtgMZTpB/5yVZ68oQ8nVAwBjOWro
         w2O6QecSi7bgSeSeVuBofTfpS+ovIujKRFc7nPVP4u8tTN5u/ZXdii5OQ1MO70vHYadS
         gx3w==
X-Gm-Message-State: AOAM533WxqQsTCmMGmxxrUowSci/I9OxF6rVRqDf1SjsTVFEr+0ZQtgv
        8hj5Xly7NCsrS6qAFSwAHV0E8i9ky8PGn6O9
X-Google-Smtp-Source: ABdhPJwRtQi8x5hLJqvnOxjlqt8uUG4sb0nQ06Dq5kORtMji7kyjiZDwAaGxEDr/C2WKg/zOzLnO8A==
X-Received: by 2002:a17:907:1690:b0:6db:325:3088 with SMTP id hc16-20020a170907169000b006db03253088mr39050134ejc.718.1649847145173;
        Wed, 13 Apr 2022 03:52:25 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id v8-20020a1709063bc800b006e898cfd926sm2960952ejf.134.2022.04.13.03.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 03:52:24 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v4 04/12] net: netlink: add NLM_F_BULK delete request modifier
Date:   Wed, 13 Apr 2022 13:51:54 +0300
Message-Id: <20220413105202.2616106-5-razor@blackwall.org>
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

Add a new delete request modifier called NLM_F_BULK which, when
supported, would cause the request to delete multiple objects. The flag
is a convenient way to signal that a multiple delete operation is
requested which can be gradually added to different delete requests. In
order to make sure older kernels will error out if the operation is not
supported instead of doing something unintended we have to break a
required condition when implementing support for this flag, f.e. for
neighbors we will omit the mandatory mac address attribute.
Initially it will be used to add flush with filtering support for bridge
fdbs, but it also opens the door to add similar support to others.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 include/uapi/linux/netlink.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index 4c0cde075c27..855dffb4c1c3 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -72,6 +72,7 @@ struct nlmsghdr {
 
 /* Modifiers to DELETE request */
 #define NLM_F_NONREC	0x100	/* Do not delete recursively	*/
+#define NLM_F_BULK	0x200	/* Delete multiple objects	*/
 
 /* Flags for ACK message */
 #define NLM_F_CAPPED	0x100	/* request was capped */
-- 
2.35.1

