Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9DA444F5B
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 07:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbhKDGyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 02:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhKDGyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 02:54:18 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D6DC061714;
        Wed,  3 Nov 2021 23:51:41 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id s24so5757005plp.0;
        Wed, 03 Nov 2021 23:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3h+irhGayDiswcx7a1bXBLxDjkUlVsPyCqdz/tgrKlI=;
        b=AQCOglP/FxgO9OL2dOh5ti8PZVoG0NtH+eGDizLJAmEOZyG0rGPNyKVALrL2NZQlN9
         aPwtan6ahyG1uMYuUhgxngw1Y0kZBNsKrTU/UogAR1LiZM6jTGjV4k0tzykF73j6JUDH
         YGqlgEo/40sBhV/PI48HjHa3DoiPliUwuDnqghXozVSQ1Da+Spn3s4dayZxQC9jnhTVB
         MZB4qOEkKjTBDM3qntK0Ss/A4sqCtziVNw6m2tzTjqiUErTMH8q6bCieJCfF0TJy+zu1
         S6nX9XKjNEGS49gqt/XxKftkIlMHXx5jyuU7aWdbKvKuDr33aPMLDCef4eXXLwYrUSd6
         tPEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3h+irhGayDiswcx7a1bXBLxDjkUlVsPyCqdz/tgrKlI=;
        b=LuAq2H+ssbKunjMK5bGVOz6e18dqKrgpfdOqNoX6qDNdX7+zBWgZGlznTMx3Zkb8ss
         beNbdv1zVHQS1+R4whz2/to4HvCNy+TLpKG9tV5Dcju5LGbbjJXLTvun0GgFRQBMTru2
         Dao+2Qt6qflU3LdShvUcYevniZLNjzox0FhBN3875XjhQ0KIBa96icNq8xO9HABA69Nl
         Ud0gdTikhWpXizEj6+w8rtnLr1Kq6v9OtYDO1HqOc4EuR5/JvdVkpPKEGZs7osog/3fD
         aO54wU4ezpfD4ZTr/phsE/T8Gk9+1N11REbTVD5Mgpz7U9wxdjnt4n3qR3O/SAc6ZaM8
         uvww==
X-Gm-Message-State: AOAM531oha2tOE6GgTZdlRTpz+pE3J0rmpBlwIRn7F3nYRB21nG9eaWq
        wfQyPyoOrm1tUMucpm9nIbo=
X-Google-Smtp-Source: ABdhPJxHmbUVPftUW7Kpr//QrcR95MmE/TdmYbfckjm6fjP1lQc1O7BJqzYRup4KY7CEplMwMwMSmA==
X-Received: by 2002:a17:902:9348:b0:141:5862:28b4 with SMTP id g8-20020a170902934800b00141586228b4mr42856976plp.17.1636008700796;
        Wed, 03 Nov 2021 23:51:40 -0700 (PDT)
Received: from debian11-dev-61.localdomain (192.243.120.180.16clouds.com. [192.243.120.180])
        by smtp.gmail.com with ESMTPSA id v14sm4927823pfu.171.2021.11.03.23.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 23:51:40 -0700 (PDT)
From:   davidcomponentone@gmail.com
X-Google-Original-From: yang.guang5@zte.com.cn
To:     steffen.klassert@secunet.com
Cc:     davidcomponentone@gmail.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] xfrm: use swap() to make code cleaner
Date:   Thu,  4 Nov 2021 14:51:28 +0800
Message-Id: <20211104065129.1817139-1-yang.guang5@zte.com.cn>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Guang <yang.guang5@zte.com.cn>

Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
opencoding it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
---
 net/ipv6/ah6.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index 828e62514260..b5995c1f4d7a 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -175,7 +175,6 @@ static void ipv6_rearrange_destopt(struct ipv6hdr *iph, struct ipv6_opt_hdr *des
 			 * See 11.3.2 of RFC 3775 for details.
 			 */
 			if (opt[off] == IPV6_TLV_HAO) {
-				struct in6_addr final_addr;
 				struct ipv6_destopt_hao *hao;
 
 				hao = (struct ipv6_destopt_hao *)&opt[off];
@@ -184,9 +183,7 @@ static void ipv6_rearrange_destopt(struct ipv6hdr *iph, struct ipv6_opt_hdr *des
 							     hao->length);
 					goto bad;
 				}
-				final_addr = hao->addr;
-				hao->addr = iph->saddr;
-				iph->saddr = final_addr;
+				swap(hao->addr, iph->saddr);
 			}
 			break;
 		}
-- 
2.30.2

