Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6BC51864
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732087AbfFXQV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:21:59 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45886 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732075AbfFXQVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:21:54 -0400
Received: by mail-pl1-f193.google.com with SMTP id bi6so7172648plb.12;
        Mon, 24 Jun 2019 09:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0ZDk/tvhLrL6R7/cBntiQRLrBOZFWTr1y6joixwoFOI=;
        b=IHTozgUNB1rwXN9rFfkcIkcSWGg/0Np+iLWfVIo+Lh81iKUOH4Oq9iposX+6vQnK9y
         Lhc/nmCYeWJeHC/iwrmdPGIlvBpHrJbj7Ow9fR7GgnipFH8iyI9gbDu3xXKoSUvq6Op5
         R7U8Q4ydGuQJBIwidQgsWygrcBcASX/TRllP49GQ3D2c232fuxxfvDwIta1ncysRuvae
         +crVDCoC1X8rH5dNJ+0jqkw6Ek77JW58xt+chY5FpfnJVTttaN3OfEPZwcCxsjQvZ5PE
         ccjFud/deekm/Ej8IwxQ5NoUUyKUfWhInhzQ4gObMlA5ynIgZR8KNNYrALdE86RFQ83S
         gRnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0ZDk/tvhLrL6R7/cBntiQRLrBOZFWTr1y6joixwoFOI=;
        b=Ith3xx3WgB+bqHvuu3D5AiAvcyKH8DLIotUUvrUhkn60ERSVqVGiEQupGvQ9cq7v+0
         tGoyvbKGAI3qU0rlmJptjeTy227y6XHNO62EJTscVziIAC0vcBvtUE73D/GKka6404nF
         MlGumWn8Fy7kuXnY/XlrKW134Qc/mBqvjIzmHN8BkTKv0yDm0lXF/eaEeuaE7v85xG2m
         smk2e1fiOMxO+Stkks2WRtgyYgbHtNra7uqasAVIIb3XY4/ysLP4E+Kd0IgR2xQVq7HH
         BMnwkgZe/ctrdRiVHjeQnkFTbiJqOQCUaurRJnfP3yQowXuY5b/60hIl6GaaVW7yJKun
         KTKg==
X-Gm-Message-State: APjAAAVLXgWcmMoS8yfCjEA/YqcnJ0bgEGtzLI4qHx+th+0FaWovQO/H
        JfzSMlt0y5p2A/XTeW9NYU0BtAAH
X-Google-Smtp-Source: APXvYqwoOHT/YbFl6Mw+iG5StGd3mLxGaRvPU/hx6chWU/O2FpZsj1esmU3cHKVqwSw3AqNuBfSamQ==
X-Received: by 2002:a17:902:968c:: with SMTP id n12mr56321402plp.59.1561393313656;
        Mon, 24 Jun 2019 09:21:53 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 22sm17480608pfu.179.2019.06.24.09.21.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 09:21:53 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs@googlegroups.com
Subject: [PATCH net] sctp: change to hold sk after auth shkey is created successfully
Date:   Tue, 25 Jun 2019 00:21:45 +0800
Message-Id: <14de0d292dc2fe01ecadaba00feb925b337b558f.1561393305.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now in sctp_endpoint_init(), it holds the sk then creates auth
shkey. But when the creation fails, it doesn't release the sk,
which causes a sk defcnf leak,

Here to fix it by only holding the sk when auth shkey is created
successfully.

Fixes: a29a5bd4f5c3 ("[SCTP]: Implement SCTP-AUTH initializations.")
Reported-by: syzbot+afabda3890cc2f765041@syzkaller.appspotmail.com
Reported-by: syzbot+276ca1c77a19977c0130@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/endpointola.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index e358437..69cebb2 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -118,10 +118,6 @@ static struct sctp_endpoint *sctp_endpoint_init(struct sctp_endpoint *ep,
 	/* Initialize the bind addr area */
 	sctp_bind_addr_init(&ep->base.bind_addr, 0);
 
-	/* Remember who we are attached to.  */
-	ep->base.sk = sk;
-	sock_hold(ep->base.sk);
-
 	/* Create the lists of associations.  */
 	INIT_LIST_HEAD(&ep->asocs);
 
@@ -154,6 +150,10 @@ static struct sctp_endpoint *sctp_endpoint_init(struct sctp_endpoint *ep,
 	ep->prsctp_enable = net->sctp.prsctp_enable;
 	ep->reconf_enable = net->sctp.reconf_enable;
 
+	/* Remember who we are attached to.  */
+	ep->base.sk = sk;
+	sock_hold(ep->base.sk);
+
 	return ep;
 
 nomem_shkey:
-- 
2.1.0

