Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB1F123836
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbfLQVDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:03:33 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34872 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbfLQVDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:03:33 -0500
Received: by mail-wm1-f65.google.com with SMTP id p17so4730364wmb.0;
        Tue, 17 Dec 2019 13:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EKxVNnjdcW7UqI1MnLHXmGc5PlnuEhB2TmXteUbCxgg=;
        b=MintjkZCoOxXDI0mGNQAdwBfJv9iqgmx55CfHoaCIQtJXFeK234R6HUHkkV0Bo8qzy
         eDz8cPGNc8ic9PQfRFE0gj7TSOAxfdCPn9XUX+uQA6+k0tO0m5PwoNBjVgQEA6JZK0zW
         OrcKasR5i9sBs0Na2zm7/gqTBI1K+Mp4g9KWbXTvN9MK5ObIVGvApy42K+Rwx5GIimP2
         Aoh5dehLEqOFNJusdiNEXvrm3xmdbXHjQoEfYwY7XpBeDfJ2Ea0953pnP2AePUBw1sjs
         ulfMqarNBdgL8xTlAweCyu+m7y40J6lp45523aMNKNLbH9SOPPeY/XZd9Jodme1lPR2Y
         R+kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EKxVNnjdcW7UqI1MnLHXmGc5PlnuEhB2TmXteUbCxgg=;
        b=s6+olEvymldMuBe1q+90V6DMfpv3Y6B0vVvnWRi+BepKEMW+jqKmRbnpedmR2EaJBS
         QMpgBwIzl01i8pWTVK7CU7HVq8wTR4rPeMiue6WH5KynJHmfahIuwuI61cE6V2OgmoeO
         KnL9Fo4K3VzHMJaE7u8IhOruIjPf3iV0QIJl356lN+fTLX7ZGVew3GRAB8BuDFB02bVe
         rzSl7fgzcYSLS5S0szYOnxR3TOb4mR3VyIrNiqDK90yQqlfEN1gAWSufEUQttwKFUEV9
         FnS8DMv62syKc5pdwjkeW0vmUxNw41BkRT0fQkNQSYubhi60uOXaaMqeSevQRKIcxpO7
         lIeg==
X-Gm-Message-State: APjAAAVtntoMuydmYwW6xq6A3bJFJXsRWCBxj+jNUiKGplPG3SPnqT/8
        Z4xv2P7bHdhVRg4IPRfqyFY=
X-Google-Smtp-Source: APXvYqxuuRtB5b7Haj82wQnvqoMmLrAwjbw31GxEqNwQjrkFp/Jcsq7AShDUpTeK0l3PgOiWlsi7qg==
X-Received: by 2002:a1c:9a52:: with SMTP id c79mr7645826wme.127.1576616611180;
        Tue, 17 Dec 2019 13:03:31 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i5sm37856wml.31.2019.12.17.13.03.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 13:03:30 -0800 (PST)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next 7/8] net: bcmgenet: Be drop monitor friendly while re-allocating headroom
Date:   Tue, 17 Dec 2019 13:02:28 -0800
Message-Id: <1576616549-39097-8-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576616549-39097-1-git-send-email-opendmb@gmail.com>
References: <1576616549-39097-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During bcmgenet_put_tx_csum() make sure we differentiate a SKB
headroom re-allocation failure from the normal swap and replace
path.

Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index b751fa76d0b0..0280e76bb60f 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1499,11 +1499,12 @@ static struct sk_buff *bcmgenet_put_tx_csum(struct net_device *dev,
 		 * enough headroom for us to insert 64B status block.
 		 */
 		new_skb = skb_realloc_headroom(skb, sizeof(*status));
-		dev_kfree_skb(skb);
 		if (!new_skb) {
+			dev_kfree_skb_any(skb);
 			dev->stats.tx_dropped++;
 			return NULL;
 		}
+		dev_consume_skb_any(skb);
 		skb = new_skb;
 	}
 
-- 
2.7.4

