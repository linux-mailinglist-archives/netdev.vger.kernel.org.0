Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7822C4DA5ED
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 00:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352465AbiCOXEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 19:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349790AbiCOXEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 19:04:32 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6C9D46
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 16:03:17 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id gb39so747286ejc.1
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 16:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7ST4w1DO01CoQvt7GoVodJB0r1mNIlwit3wD8LprJ1Q=;
        b=FpxcS4GetcGNPAQ6QmlPvUVf5A5RNAdYudmhpzLBtkXiGPzqfslmW+PkthP1Q8ue8J
         tJ1XzjNL65U6guYjKmg2amMxb9V9KZCqaadSDPvvQIkc63DjzSsVohXCJzdSKBridCv+
         6gZi3p0ugibQPLQ1jtFD7dTB02SiO6A/eO86y/WXLtse8WmtJJDBLYcVP8/3pH3OfcsI
         vTQKCtjDZRhRCLTVMrh+dMK9Y0NErw/M91/oMhwgao1bhLw/74bW8NeN/jciX0pFml7B
         2c0pbWh88OmsvS3/aJDHuPhhunLLEPBCpLaUmqFOaWty1gZBSh4jc2OwHabK8isGSQR0
         QYww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7ST4w1DO01CoQvt7GoVodJB0r1mNIlwit3wD8LprJ1Q=;
        b=FmQ2u7YwOitD5WyZCGvX2gZaqhbgo4aEMi1E/TL6MnfOp8umyeZ9BcDml1un9nYv61
         qyXS0e4QfzlZyPCo/Hn8mulmtFS4Ow5uV3U+tNZRfjMgD/uIQPrUo62gXxlVozVxmbIV
         JlgZ1qpvXECJFag0bjxqr1dwWhYZQlK8ruwutV3lsLo4P09/fqojPvLbxU99lvjRmJWk
         9PJU+61luiFD5lB6CjW8+Vy4B466RE0ip63xhfwAyxd2jO7FmMYu9wKo3ejZ7hGkpL+F
         YVT6OIAzhwfdP2Y10TDYpt/9fgg4pJA3YHUNsOtcBVCSPx/FGeQVXOFXu90RSeuonQXp
         haAA==
X-Gm-Message-State: AOAM532oXm5lnDmY5/YI3akeHFUtry84321QbKoeMPwNXzzO+b8xhsVz
        r4Q/PNGMWfeKeyrb8Wmr/Pz8oajlJkvEQQ==
X-Google-Smtp-Source: ABdhPJwb95tiXsmkVTHC6WpE/+TNif5lPTqiDleQ8atoTVat89mSvJNw15C7vMkh5zzJPzTUW8Ad5Q==
X-Received: by 2002:a17:906:6a2a:b0:6cf:d228:790c with SMTP id qw42-20020a1709066a2a00b006cfd228790cmr25529946ejc.75.1647385396467;
        Tue, 15 Mar 2022 16:03:16 -0700 (PDT)
Received: from nlaptop.localdomain (ptr-dtfv0poj8u7zblqwbt6.18120a2.ip6.access.telenet.be. [2a02:1811:cc83:eef0:f2b6:6987:9238:41ca])
        by smtp.gmail.com with ESMTPSA id a21-20020a170906275500b006d10c07fabesm134014ejd.201.2022.03.15.16.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 16:03:16 -0700 (PDT)
From:   Niels Dossche <dossche.niels@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Niels Dossche <dossche.niels@gmail.com>
Subject: [PATCH] ipv6: acquire write lock for addr_list in dev_forward_change
Date:   Wed, 16 Mar 2022 00:02:23 +0100
Message-Id: <20220315230222.49793-1-dossche.niels@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No path towards dev_forward_change (common ancestor of paths is in
addrconf_fixup_forwarding) acquires idev->lock for idev->addr_list.
Since addrconf_{join,leave}_anycast acquire a write lock on addr_list in
__ipv6_dev_ac_inc and __ipv6_dev_ac_dec, temporarily unlock when calling
addrconf_{join,leave}_anycast analogous to how it's done in
addrconf_ifdown.

Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
---
 net/ipv6/addrconf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f908e2fd30b2..4055ded4b7bf 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -818,14 +818,18 @@ static void dev_forward_change(struct inet6_dev *idev)
 		}
 	}
 
+	write_lock_bh(&idev->lock);
 	list_for_each_entry(ifa, &idev->addr_list, if_list) {
 		if (ifa->flags&IFA_F_TENTATIVE)
 			continue;
+		write_unlock_bh(&idev->lock);
 		if (idev->cnf.forwarding)
 			addrconf_join_anycast(ifa);
 		else
 			addrconf_leave_anycast(ifa);
+		write_lock_bh(&idev->lock);
 	}
+	write_unlock_bh(&idev->lock);
 	inet6_netconf_notify_devconf(dev_net(dev), RTM_NEWNETCONF,
 				     NETCONFA_FORWARDING,
 				     dev->ifindex, &idev->cnf);
-- 
2.35.1

