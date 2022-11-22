Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701FD633587
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 07:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbiKVGzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 01:55:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbiKVGzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 01:55:17 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE0E21269;
        Mon, 21 Nov 2022 22:55:16 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id x21so16880343ljg.10;
        Mon, 21 Nov 2022 22:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k92tQx0fKvMHg8ehwzrCax9mbJ5igeyBODg7YXcY9LY=;
        b=MCJzztH1tGB9H8F2GdjiLIHJhDpNwjfLQ2xfN/Thx41yzYyieGXV24yZPyhb2klKnu
         Bh3OXUBzl9pBN1ONCYOAvqzyPJeeqpNYFyrt6QZIxpDpevhSOSdol3Sf2cN2r957kjGq
         a0BMJ+EHaGjkG1uboL0+mdGo38BeyIeoTXg4gFfpu9kNZudYfHDqx/pLPvXySD3W8vZT
         jnB+M7P6PySzVAaWDsqBr8tq36zkFXekm+N5oBvKPZWZ0G2QNzVH2u2Ou6Cy4pmlUIU8
         6bNVaLG/VNclIH+rC3oorw7tPf1i/pOcnE9xg41NBKs4iPnWJkHXlcspQrK55OwkI9HP
         RsHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k92tQx0fKvMHg8ehwzrCax9mbJ5igeyBODg7YXcY9LY=;
        b=HnwS95yBzVXToNAfSenT+LLAJO+S/SI4FHyzB6ZYcjJIOAWItXtuwCWBBzPbY9f7U5
         bJb6PTEZYLzMFKkqmHI7ChRVtz4nN4dNnYKxYhB7ihkay/WJiiJrBzleU2x+zQQKv6bt
         i+pDwygj7SsuqmKnwScRwOxGvhUMUpW8s5otZg16zz6jxien7O/qaV4Al9kKYm6x5+HE
         8M2PpCPVuPfzkwlLpVcYcDN9J8xt5lauiK9DZqLqGfZsiEy2xFtpkxqNj0+qIfy8LUhc
         Hcyn/I/wHLfX+9cWLTJ5WTFYQq37Sohl26iQBZztQp+bvDviJtHwtC2lmc/9Q7nUowDe
         Ym9Q==
X-Gm-Message-State: ANoB5plHhNfOXLo5cdHmPD2Qzf7hwY6Js1CdbRyjKpp+CsMCGUo5uFSH
        RvxIpehinNWQ7I2CBgYAJOk=
X-Google-Smtp-Source: AA0mqf6qHmQ0prd/luuvk1GCvOoem5e38+FoV0+YK3zXpsgjInhLjVtBUX2+C4i0tcPGQULi/+/ErA==
X-Received: by 2002:a2e:bd05:0:b0:277:6ad:b2fa with SMTP id n5-20020a2ebd05000000b0027706adb2famr2484099ljq.24.1669100114212;
        Mon, 21 Nov 2022 22:55:14 -0800 (PST)
Received: from mkor.rasu.local ([212.22.67.162])
        by smtp.gmail.com with ESMTPSA id x10-20020a19f60a000000b00494935ddb88sm2355803lfe.240.2022.11.21.22.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 22:55:13 -0800 (PST)
From:   Maxim Korotkov <korotkov.maxim.s@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Maxim Korotkov <korotkov.maxim.s@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Tom Rix <trix@redhat.com>, Marco Bonelli <marco@mebeim.net>,
        Edward Cree <ecree@solarflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: [PATCH v2] ethtool: avoiding integer overflow in ethtool_phys_id()
Date:   Tue, 22 Nov 2022 09:54:23 +0300
Message-Id: <20221122065423.19458-1-korotkov.maxim.s@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The value of an arithmetic expression "n * id.data" is subject
to possible overflow due to a failure to cast operands to a larger data
type before performing arithmetic. Used macro for multiplication instead
operator for avoiding overflow.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
---
 net/ethtool/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 6a7308de192d..f845e8be4d7c 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2007,7 +2007,8 @@ static int ethtool_phys_id(struct net_device *dev, void __user *useraddr)
 	} else {
 		/* Driver expects to be called at twice the frequency in rc */
 		int n = rc * 2, interval = HZ / n;
-		u64 count = n * id.data, i = 0;
+		u64 count = mul_u32_u32(n,id.data);
+		u64 i = 0;
 
 		do {
 			rtnl_lock();
-- 
2.17.1

