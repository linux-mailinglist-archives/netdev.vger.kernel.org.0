Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3B61CE9E2
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 03:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgELA76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 20:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728437AbgELA74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 20:59:56 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8094CC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 17:59:56 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id f6so5368027pgm.1
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 17:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xdZRv9LB2CV+2dshgj06JPKqSDMOsKj5tKDhOQ7wqcM=;
        b=XkITL9XTVJQK/XhckivJ3VU5YQWQnzgzvHk30YFH76AFFSdTf0fI53OiAzmniPpEDG
         heqLurLth/LAsziUq+hDSvL9K33dhW//A3GsNraWiVQPHJ5+qDOleAUe9OXKLLEEE5x1
         YWpYWU4WjmIwb/7v5z4WNQed8XR8mTu+lXqt2/lGoDCyFTWVy0EvKzxC54sqQqAMIBIx
         P3ACDv0Hh9C105xDVzAkTHglnmolRoEgZGx/xxb8SaOVKP96P9d/6lfKHH6MnpP3p2TZ
         k+qILcA1yyvtaMTuR/92KzR+KNUCtGkMDqRiGzMb1G1ATjnhC9eaR2lQkEPWBnNk2fMC
         sGsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xdZRv9LB2CV+2dshgj06JPKqSDMOsKj5tKDhOQ7wqcM=;
        b=Li0RHSQxwjiegRH2Eo19yTgxc43ad6BBAjD628iFbul2ijNw4WW7IZku2+TIBZ74l1
         sQJ82D3H/zc0eOYVx3N6Q1//Vdkxbfk/XBbO/hXb1j6f6dhQh2/b14CY/YA5K3KMACNh
         0DXpW5NeBrqgmxFcMSCI9U5k6psEY2QuPdMC2yeXcA7cwxpSOzqgI9n2yriA8+ERiI+v
         2TPswPoWJDbRengf6EJxGFljEY8zhECjD8C+MKbsSBrkZN5/aZgAhhfdeM3KCzwxUe9b
         eL0iE46XZnsNpmINxnxlCPmYh7k8sTBl3KfRaeKw4Tm99b9iPOdl4g6c6kJqaCJ1vvCh
         D3pQ==
X-Gm-Message-State: AGi0PubH06OH0U7gjAU7V68amtb20Hg932Vulq0MxOwCjrL3tQcZmP5S
        ownQhRSx5/hxIxLX/HscuriJ5qrVLL4=
X-Google-Smtp-Source: APiQypL1yEtEqPsv76HVuheUCD+rDQp7+8KZ5rPyuMvaLqmaakolZ7Zsmkut1iZMhy/FdtHShoSK7g==
X-Received: by 2002:aa7:9251:: with SMTP id 17mr17534567pfp.315.1589245195784;
        Mon, 11 May 2020 17:59:55 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h17sm10171477pfk.13.2020.05.11.17.59.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 17:59:55 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 06/10] ionic: reset device at probe
Date:   Mon, 11 May 2020 17:59:32 -0700
Message-Id: <20200512005936.14490-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200512005936.14490-1-snelson@pensando.io>
References: <20200512005936.14490-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once we're talking to the device, tell it to reset to
be sure we've got a fresh, clean environment.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index c3f0f84164d3..92110abcff96 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -415,6 +415,7 @@ int ionic_setup(struct ionic *ionic)
 	err = ionic_dev_setup(ionic);
 	if (err)
 		return err;
+	ionic_reset(ionic);
 
 	return 0;
 }
-- 
2.17.1

