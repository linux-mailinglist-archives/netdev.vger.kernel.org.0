Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52D605D2B4
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 17:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbfGBPXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 11:23:04 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36822 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbfGBPXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 11:23:04 -0400
Received: by mail-pf1-f193.google.com with SMTP id r7so8413749pfl.3
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 08:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0MmGjm5aumHgJf27PbMfUiuiPOO/2bFmzO1fqEnb01c=;
        b=VJ0eKcaydfHmRk91mx1FclRPUU73P/ojbpeAVz8OXOWiivp90t41ZKw1tG9anVx3Nh
         nsrXrZC77oJpd6jFq9fIq53Y8wt8aCXQ/X+1InhaMn9exsMqHNc4ik7xn+ckiOGtXIMg
         KYemVQPBgmzqjjC0vDGDknuZkCgh3nWv+j1A+dr9SIaUnm3Y+a/Ro7UV/i9ioDi4weD9
         Xg120qey8n0eLsAQdvfnigFjKZfcAdY8jXK7eHgMka4RxbGemz47mrlYBjKF7OhbZurQ
         G4+dfCZCu96hcI5If1wZfhcNLipM6vcz1FWi4F6DqJ1iTua+olkywPIEvgJcnV7dIlV5
         kucg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0MmGjm5aumHgJf27PbMfUiuiPOO/2bFmzO1fqEnb01c=;
        b=sEe7bZBbNTUPMYxvU5ktcbrK8XhzSHfiGSNdHTiZJasBbGfPVWXdhcNHteMfnujjD7
         iNqD2kihVwi9qDD5QQnQ3cd2BnaLNR9/RMqgsbb27yM8eUQToLOHFjg1b9JQsLzb0tFh
         gejf9MwLmVcf7JbqFUlk8PNnxHjqzCI5aMgts0hNK7D7L7rSXujqPmxNO9mUeTh0bhGX
         KnVQus+dllXKR2wFWlHE8FJoK46ZJ4nC9JMV2qk46vwMFgzeVZxSdP1Apv+UBWATDdfG
         w5AI6dnfDmH7XadyUZI7mkpZb98Yju/RvuLS5uMeYtyEsbjPk+AWsW8YE3uyaTByHsYq
         HKag==
X-Gm-Message-State: APjAAAWrL3HLVLDl88jknHvNq/gHz7Ex9aaxT6r2pdAQh2zA8Gl2GHS/
        AMOaiBF+QQYpkJc0EAMbN0A=
X-Google-Smtp-Source: APXvYqy2WYsnA8Uf1zXzmprJT/J6XXBJBGBdbI2FQcj/AY436m4ECgTwnL15vNsytDkrHrTsxEwaPg==
X-Received: by 2002:a17:90a:35e5:: with SMTP id r92mr6344233pjb.34.1562080983611;
        Tue, 02 Jul 2019 08:23:03 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id g18sm5245136pgm.9.2019.07.02.08.23.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 08:23:03 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, pablo@netfilter.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 3/6] gtp: remove duplicate code in gtp_dellink()
Date:   Wed,  3 Jul 2019 00:22:56 +0900
Message-Id: <20190702152256.22884-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gtp_encap_disable() in gtp_dellink() is unnecessary because it will be
called by unregister_netdevice().
unregister_netdevice() internally calls gtp_dev_uninit() by ->ndo_uninit().
And gtp_dev_uninit() calls gtp_encap_disable().

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/gtp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 5101f8c3c99c..92ef777a757f 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -694,7 +694,6 @@ static void gtp_dellink(struct net_device *dev, struct list_head *head)
 {
 	struct gtp_dev *gtp = netdev_priv(dev);
 
-	gtp_encap_disable(gtp);
 	gtp_hashtable_free(gtp);
 	list_del_rcu(&gtp->list);
 	unregister_netdevice_queue(dev, head);
-- 
2.17.1

