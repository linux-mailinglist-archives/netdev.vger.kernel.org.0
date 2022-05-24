Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2A45533294
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 22:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241683AbiEXUrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 16:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238414AbiEXUrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 16:47:46 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047C9737A0
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 13:47:45 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id x143so17441089pfc.11
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 13:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3uRtfrODZaP6cR0RkQJZ2+zsYii1OwcOLnuKabGpEK8=;
        b=T5b5Xt9YaoxgVs4sV5AT0c/hlVtaFZxKefza3PoOUmHqZGiuEVXrmgipbywdk0MUHv
         LbZp53m4VRovrykWpWKYmL9BXOcQcpPZA4yDAC7jlOBrVu8qPWjzrtyG6soLeWcGb2xe
         njsftnjDBPYSxiLtaUKBxgn/7Nj/DEF3jdTA35hYa2v32+lALhxanhYg10oaanHqAU91
         YlUx7iVa9M7JLF5z/JY7Tsuyn8T7My41ilTf3t6j8p4cRJ/xefmDHyRGgeswxSr/9Eef
         M4QVseQ8pftKqFsh4YfF14layFOZRoYWN/Y8vuEn8Zw3muUO5KqAZbQhByGQqabHdLXW
         5U0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3uRtfrODZaP6cR0RkQJZ2+zsYii1OwcOLnuKabGpEK8=;
        b=j6pOrfaGVuzWhsYFyJQowFGHgxKang+0+u2ftZZfwxNad7+KzAp2oTwB9qsPyIOqlJ
         XqL47uitKHjXs4R8JCH7LgmH/Igu+stYuXugu/ythszWn6C0eFJM3WK/6RavdS6/uk1F
         cossiV34vpVEHxaUZ4NkfvycKJWtp2NgGZeGqFvPjoUyCbR5aGGm+13x0Vt7dylIWcnr
         hisWXQDAbRqOQSjEP5CkhBo9gXBxCcC75Eh933GhpDNlFrs0WzOKYUNNtf4y51PnhugM
         aWCbfTLqRBV+Byyay8P73eTYMesnqEk231AGgR3wIcSS5fK471jae/CTbkvMhnB3Ixkk
         8esQ==
X-Gm-Message-State: AOAM533NS5xvLqEbhxHAZt6g2XAJTD3RKowA4XBEGZKZU+khzp3od6Hv
        XMKiA1bYSyXu7zYxIJhRIoipWKrV1hCXgg==
X-Google-Smtp-Source: ABdhPJwwpVXtrpCz9jVGk8iP4WrNBX+WMLN52wp4D2psv/hI+w3spN+5vdPNbAvKQkjySp4B6lh9jg==
X-Received: by 2002:a05:6a00:1145:b0:4f6:3ebc:a79b with SMTP id b5-20020a056a00114500b004f63ebca79bmr30284723pfm.41.1653425264154;
        Tue, 24 May 2022 13:47:44 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id r8-20020a17090a690800b001dfffd861cbsm216333pjj.21.2022.05.24.13.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 13:47:43 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC] xfrm: convert alg_key to flexible array member
Date:   Tue, 24 May 2022 13:47:40 -0700
Message-Id: <20220524204741.980721-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Iproute2 build generates a warning when built with gcc-12.
This is because the alg_key in xfrm.h API has zero size
array element instead of flexible array.

    CC       xfrm_state.o
In function ‘xfrm_algo_parse’,
    inlined from ‘xfrm_state_modify.constprop’ at xfrm_state.c:573:5:
xfrm_state.c:162:32: warning: writing 1 byte into a region of size 0 [-Wstringop-overflow=]
  162 |                         buf[j] = val;
      |                         ~~~~~~~^~~~~

This patch convert the alg_key into flexible array member.
There are other zero size arrays here that should be converted as
well.

This patch is RFC only since it is only compile tested and
passes trivial iproute2 tests.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 include/uapi/linux/xfrm.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index 65e13a099b1a..3ed61df9cc91 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -102,21 +102,21 @@ struct xfrm_replay_state_esn {
 struct xfrm_algo {
 	char		alg_name[64];
 	unsigned int	alg_key_len;    /* in bits */
-	char		alg_key[0];
+	char		alg_key[];
 };
 
 struct xfrm_algo_auth {
 	char		alg_name[64];
 	unsigned int	alg_key_len;    /* in bits */
 	unsigned int	alg_trunc_len;  /* in bits */
-	char		alg_key[0];
+	char		alg_key[];
 };
 
 struct xfrm_algo_aead {
 	char		alg_name[64];
 	unsigned int	alg_key_len;	/* in bits */
 	unsigned int	alg_icv_len;	/* in bits */
-	char		alg_key[0];
+	char		alg_key[];
 };
 
 struct xfrm_stats {
-- 
2.35.1

