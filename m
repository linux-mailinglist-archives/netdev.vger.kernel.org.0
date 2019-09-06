Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2620AC000
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 20:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405098AbfIFS7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 14:59:49 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33900 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729790AbfIFS7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 14:59:49 -0400
Received: by mail-io1-f67.google.com with SMTP id s21so15125627ioa.1;
        Fri, 06 Sep 2019 11:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YKi9Xw+EV9A2FTj25alWizqVFGtKwY37/WCHnxg2PZM=;
        b=WRysIEUMhxrnvPNiSrDsKrOZCtWm57CZSeIixk89PQAFz4+SZHR3XMafqQF1gYxDpo
         CO6OaN3axNWR0crwK8ydEVkpnhEXiDMAr/xA3et9AMsA+xyi5fsU7j4rMQLJm47AK928
         ABFu9Gew/6NWvlI3IRqQtETgM2ZjInseLnrDP9z5ZrnOPoph5jStyr+Uo1qM2gj0HR6T
         x7akv9aPiZbALPfhlhj1KBj3mF0yYs/kCOeYinQhGXsyQGe4BcsrEWUZriXJ6LhijAOz
         sWl/4CYlaX+eQkopyhaR+yHK6K3kRrJy/jnSCy5L9CcY8aPwmDiqqFv/sXMImk96FKyJ
         FXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YKi9Xw+EV9A2FTj25alWizqVFGtKwY37/WCHnxg2PZM=;
        b=toJ8drTeoRoM28E0FVFOY2Y9BxWm9WEtHYd2m7lsFnLZ2tdWW6AAZX+qRUIvYtTNjR
         l2a4l+YCTFeT9bzrNMx4Cp1dKpwql3a0s+DO7CJb6iiIelhFZpU2OexzxbQYzotTV+P4
         CLxDgFh59gHhcztceh4Fy8wGNwsbUlMAg/4mbqxPEGAc9Zbxeyy2IaQaqQcxhMBcC6ET
         pSf/fjOSV6m2jYJyNuGCONqSKf9pGjqPW/N1gJaCQ2Vdi/B/LCS3WY3Lfxx1Y7Uba7um
         2aPXFnW1lnvywatgmLtMH9NKovlSai7l76JyK3gRn9JclbvImS36bbcxg74WsB5SqEE5
         CfEw==
X-Gm-Message-State: APjAAAUVQ+l6BamxYe9eS3CO7Jx2sVj1o98wA33B97N9bmxP0ixCJSlp
        HgNopC65gYfD2wW9OBi/dUo=
X-Google-Smtp-Source: APXvYqygBEtn3Havv+tF5BFuAgiIwaFq7kREukTlMCZWkrBwZYQn6LhP85Bn/TsAAFX4MS7n7ciCFg==
X-Received: by 2002:a5d:96c5:: with SMTP id r5mr11638165iol.274.1567796388418;
        Fri, 06 Sep 2019 11:59:48 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id h70sm10842093iof.48.2019.09.06.11.59.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 11:59:47 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ath9k: release allocated buffer if timed out
Date:   Fri,  6 Sep 2019 13:59:30 -0500
Message-Id: <20190906185931.19288-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ath9k_wmi_cmd, the allocated network buffer needs to be released
if timeout happens. Otherwise memory will be leaked.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/wireless/ath/ath9k/wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index d1f6710ca63b..cdc146091194 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -336,6 +336,7 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 		ath_dbg(common, WMI, "Timeout waiting for WMI command: %s\n",
 			wmi_cmd_to_name(cmd_id));
 		mutex_unlock(&wmi->op_mutex);
+		kfree_skb(skb);
 		return -ETIMEDOUT;
 	}
 
-- 
2.17.1

