Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE4F18C54E
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 03:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgCTCcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 22:32:10 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41297 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgCTCcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 22:32:06 -0400
Received: by mail-pl1-f196.google.com with SMTP id t16so1875512plr.8
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 19:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VOeHVAGcH+jvqxZz+niCt9Fl35GWfxvR8XgYIp7jtxQ=;
        b=wPob5nXZj+Whq4OHS/W9bMfawTpuIxiSqMalcVk/Bu0KCirkdgGmRb5prxEjb5sY9M
         zKVYDvbsCuAAH8uuP1ZezulmEwdOy0Ef0mliHqMuIAo9ZG1DkUt6LD2vBP/1twKqeD5A
         aqcoRzHRMFYBE0asPMTmOF4ZfG5zvT+7VNRw6i6rGqapi4y3GLaEBl3/ZtcTWr4lkrIo
         d8Kw53Pw7D9X0f/izOkaB9MSTUE7iMCnrSnLN5sRJlEDIR/I+1IPU8ow+0/t7VZzHk0N
         T8zKuMDFMgn/d2bWBx1BRA2ZaLew3clSYMa2B5Cv/mBonyasG+AAR94T7N510Rz+ndeO
         G/vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VOeHVAGcH+jvqxZz+niCt9Fl35GWfxvR8XgYIp7jtxQ=;
        b=rzFH3Y5azWKY4zvVuBqZ0DJXQJWhl+dr4Iip+VUXvnRtC8KMYcB7I2KR+bS5kZxYdo
         tikt+ueAzcy+6Hc4F8UnJ+FiDhqzVT4aOV7SO99YScSO3E4QGCQFPrBc6ElrsXqfkCBt
         ae8BXhVgTgEJA+0q3MIhkmXmQtkzVDOEcpaQF8ceVVSzOMejIYUcx508y4aCZbJZoJ9n
         1WIRPldFTKfWqCIbtUlZ3TXf0zkVRZ5yn5jLDmhkIR9SvLq+6BbbKsRPbx2UeNYdC9yt
         UeduJDTYvikT4vPkxqWiVTxWSMsbfGc4V0fPsbzkw1IMu/reJ4/TMLub2iSLtd2phjjp
         xMxQ==
X-Gm-Message-State: ANhLgQ1YdoX7JN8QaZJLTRXtrJXJ3OrcJM9329YMf2MAxbR4SjKQx1CN
        TEgZ+3mC/CufUTdhmQc59PAT5jNZYxw=
X-Google-Smtp-Source: ADFU+vtNTdnivp1lMI0y3Xthlvziy1uDXb5uW2erZfiq1CkQOqwPPutxwjE0MMJHlVcAL8/zzHuE0w==
X-Received: by 2002:a17:902:5a85:: with SMTP id r5mr6418342pli.182.1584671524073;
        Thu, 19 Mar 2020 19:32:04 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id i124sm3606485pfg.14.2020.03.19.19.32.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Mar 2020 19:32:03 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 4/6] ionic: ignore eexist on rx filter add
Date:   Thu, 19 Mar 2020 19:31:51 -0700
Message-Id: <20200320023153.48655-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320023153.48655-1-snelson@pensando.io>
References: <20200320023153.48655-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't worry if the rx filter add firmware request fails on
EEXIST, at least we know the filter is there.  Same for
the delete request, at least we know it isn't there.

Fixes: 2a654540be10 ("ionic: Add Rx filter and rx_mode ndo support")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index c62d3d01d5aa..ea44f510cb76 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -832,7 +832,7 @@ static int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
 
 	memcpy(ctx.cmd.rx_filter_add.mac.addr, addr, ETH_ALEN);
 	err = ionic_adminq_post_wait(lif, &ctx);
-	if (err)
+	if (err && err != -EEXIST)
 		return err;
 
 	return ionic_rx_filter_save(lif, 0, IONIC_RXQ_INDEX_ANY, 0, &ctx);
@@ -862,7 +862,7 @@ static int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr)
 	spin_unlock_bh(&lif->rx_filters.lock);
 
 	err = ionic_adminq_post_wait(lif, &ctx);
-	if (err)
+	if (err && err != -EEXIST)
 		return err;
 
 	netdev_dbg(lif->netdev, "rx_filter del ADDR %pM (id %d)\n", addr,
-- 
2.17.1

