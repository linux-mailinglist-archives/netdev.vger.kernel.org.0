Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B25ABF59
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 20:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404365AbfIFS0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 14:26:40 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44441 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387867AbfIFS0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 14:26:40 -0400
Received: by mail-io1-f67.google.com with SMTP id j4so14822503iog.11;
        Fri, 06 Sep 2019 11:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=gqjhFMqBHYTMYA8w0s5ZLzKd6qpTZg4d3i7M4D5urh0=;
        b=CEe96F+1yQvNbURCDAnhJvs39LkJkPviZYmdQ+OFZ1xeISvB9cs4WbbOQ9A/Uyk33B
         ZlPg3I4p0D+bmM+i2zZhqlhN29bsAyLiPC9iCf7RD1IIAIEMx8Eje6b/qql1EqL8t5it
         EF8FmAofsMNwLad94hPxhBlPj0Z7JE9xkXu7YvQvTyZ66Bet7W6yGvZY8S40zxQJu+WS
         8HJUJL55y3eGFSzYWa3m9ejQfF/yzb0YveKCp2r02RtaJQsWaoGlQg5ZOoXifynKdwLE
         BPw9dZir/IOWHPPPtZWpm+IhxhZyvD8XI47ZUtTM5sgBzJfWutvOyACraR6xwgNsg3kd
         nR9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gqjhFMqBHYTMYA8w0s5ZLzKd6qpTZg4d3i7M4D5urh0=;
        b=J61IBB8R+BzJWJa7p9Oh9znqjYQH1QYimPWifKAnpFidQBIj60dRfdDyZbCxu9o84j
         NCRsXqC9FTOXfUWrqNC1hcBeal0HortF6cjGRHKTiYHuu0x0PDSNx3+WZiRWK/FCzgmf
         my34nyHMPFRyOjVlvvSb2xRjNZbWPRUnyJ5GLlVjg8B8KI3c9XHERc7p4CykhTUubAWc
         F/ijlP/+o1tPLrWTsgsFTrLbf81ELCd127dlPxo51HlmPim4c2qKzH6AYg8aZ8+vDzPd
         QNLSOLcPeq5nVErs989VEqWL3OHiTEQeWSN9PlDp9OsvKsY4RS2dYckSTkvIPgdNzvuy
         2ubg==
X-Gm-Message-State: APjAAAXFGRDmbAb+pwyknIUKt8IxyLFZj6VhM6bJgOWEUm20XqA48reU
        cW8tPuci6Ee6n60a5g4vdEE=
X-Google-Smtp-Source: APXvYqyln8Dh0gQ2LxFfbLK5zio/VSuKm1sUheXfi+Dxqbj4+/h/Fhjuq4QfGrSzxfTFwu9fp69uuQ==
X-Received: by 2002:a02:8644:: with SMTP id e62mr12053795jai.115.1567794399251;
        Fri, 06 Sep 2019 11:26:39 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id r138sm9166626iod.59.2019.09.06.11.26.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 11:26:38 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ath9k_htc: release allocated buffer if timed out
Date:   Fri,  6 Sep 2019 13:26:03 -0500
Message-Id: <20190906182604.9282-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In htc_config_pipe_credits, htc_setup_complete, and htc_connect_service
if time out happens, the allocated buffer needs to be released.
Otherwise there will be memory leak.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_hst.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 1bf63a4efb4c..d091c8ebdcf0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -170,6 +170,7 @@ static int htc_config_pipe_credits(struct htc_target *target)
 	time_left = wait_for_completion_timeout(&target->cmd_wait, HZ);
 	if (!time_left) {
 		dev_err(target->dev, "HTC credit config timeout\n");
+		kfree_skb(skb);
 		return -ETIMEDOUT;
 	}
 
@@ -205,6 +206,7 @@ static int htc_setup_complete(struct htc_target *target)
 	time_left = wait_for_completion_timeout(&target->cmd_wait, HZ);
 	if (!time_left) {
 		dev_err(target->dev, "HTC start timeout\n");
+		kfree_skb(skb);
 		return -ETIMEDOUT;
 	}
 
@@ -277,6 +279,7 @@ int htc_connect_service(struct htc_target *target,
 	if (!time_left) {
 		dev_err(target->dev, "Service connection timeout for: %d\n",
 			service_connreq->service_id);
+		kfree_skb(skb);
 		return -ETIMEDOUT;
 	}
 
-- 
2.17.1

