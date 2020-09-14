Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43F92685FC
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgINHcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgINHbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:31:46 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC10C06174A;
        Mon, 14 Sep 2020 00:31:46 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id s14so831585pju.1;
        Mon, 14 Sep 2020 00:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=otmLPGw1Sp2M+tYoijrVhQVfizYDf0d88yKEsD5YvR8=;
        b=vOez9tpWBd7BsqyZI9fqFgdoWpoWFJYFRehPaWpHXeOlN+Cs/58Jop0XdOEPKKSFDZ
         Qm/M12lkve0L1QKsozomktRpeGUW2rP8hs2+pFh5UbMlF7vs2AhetNVS4Hjd+JpiIefJ
         edbOdo8Pb04gWefw7Nw0w8sr7fuwkJbRuiyXlBFY9qJQNxyMrbzubtw6YJaI3JeR7fZX
         XjLJJYhpbBo2kjzCdpxY4k4YdVpy8gs1tRGzfAdZYFxXdgnvxNa8oBVbLY707BMRYf7k
         uAIgJ9LCPDvLjz6Bk3wzy+V76aonA48V89EKPmhl6fiecKYyxm0d9j9GzjC68ajSSJQd
         Uc2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=otmLPGw1Sp2M+tYoijrVhQVfizYDf0d88yKEsD5YvR8=;
        b=cG0FB95YqN8tu4JsMwoI+jx7RTn1Aa62Zo9joKdVNy4UMI7Pe+S2QjXa03AJclNJhq
         uZ14ZazCcra9FQ8xmm2c8EHjtugLFNDKpe0cQpgdGsJ3q8VjHfA11IB+AAKgv/oqNQgJ
         8qDFLidOLtG9WHGvUgrTTREAE1obOyPyp92OEmJ2VCfZJwQMoiuTN1tZsMwfI27A8tWZ
         KRGV1QqvMFchOhvnDUhkjz1pTm5x8jW7h63Uvm03Q4pJEi8KQLRAoRMaCoT2F6B0CJeb
         1VUOtKdV8RqALKY7kXlGd15vxmpnprvU+j1PPN7Rs75n5z8nUWIypCpUJCvCy6mOOmQL
         XeFQ==
X-Gm-Message-State: AOAM533GhDBMWfeB185gZjiyXTvk9RolbA+vRfKgFlUyp5uEzwJ4K7Cv
        tEv90nsc2I2W+JhuSU6E4T832b6D2+Seyg==
X-Google-Smtp-Source: ABdhPJxWhHA2jm5Cs7lHsXstYe6OOIWBdmtfMeMVuJMmy4KXP5l0ub2bzRf3/oBS3LeA7iwlwY67Tg==
X-Received: by 2002:a17:90a:d18b:: with SMTP id fu11mr12439499pjb.203.1600068705972;
        Mon, 14 Sep 2020 00:31:45 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id o1sm9128626pfg.83.2020.09.14.00.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:31:45 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-ppp@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [RESEND net-next v2 01/12] net: mvpp2: Prepare to use the new tasklet API
Date:   Mon, 14 Sep 2020 13:01:20 +0530
Message-Id: <20200914073131.803374-2-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914073131.803374-1-allen.lkml@gmail.com>
References: <20200914073131.803374-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

The future tasklet API will no longer allow to pass an arbitrary
"unsigned long" data parameter. The tasklet data structure will need to
be embedded into a data structure that will be retrieved from the tasklet
handler. Currently, there are no ways to retrieve the "struct mvpp2_port
*" from a given "struct mvpp2_port_pcpu *". This commit adds a new field
to get the address of the main port for each pcpu context.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 1 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 32753cc771bf..198860a4527d 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -861,6 +861,7 @@ struct mvpp2_port_pcpu {
 	struct hrtimer tx_done_timer;
 	struct net_device *dev;
 	bool timer_scheduled;
+	struct mvpp2_port *port;
 };
 
 struct mvpp2_queue_vector {
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 6e140d1b8967..e8e68e8acdb3 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6025,6 +6025,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 		err = -ENOMEM;
 		goto err_free_txq_pcpu;
 	}
+	port->pcpu->port = port;
 
 	if (!port->has_tx_irqs) {
 		for (thread = 0; thread < priv->nthreads; thread++) {
-- 
2.25.1

