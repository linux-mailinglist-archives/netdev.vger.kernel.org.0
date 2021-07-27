Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02AA83D7C71
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 19:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhG0Rnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 13:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbhG0Rnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 13:43:50 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C048C0613C1
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 10:43:50 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ds11-20020a17090b08cbb0290172f971883bso5441728pjb.1
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 10:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YBXOFCandu4G2SsFlAyt4sp3V7jHiFKqfq70fofyWQg=;
        b=jNmAMOYx1e934PjRgCKPwgp9PWrQwjSF0kH0yV/I6xkia1ginC1XEoT+Hdj01QtWaE
         xXNnEbJKfSmob2Hn0/goB6NPLEGjXgbGa0kw/Bz1CVsimgLi3lsxz3ga0rqdDy+o4TSu
         DNdfOFKiOuX4Jwbx0HkHJuA2+hsrslSkMGWyTrbaNcQwtcul+OL87X5OpNBLqDClkdZ3
         mUz7nJNA/VVBATrxZq0hAYyUuqr/2nAaftq+4pwc+AGsL6Iozwcy//nHHbgV1X94BMwX
         DJBwc4leHEXjk9NaIqjs7vHhFw1TIvlXvWRRrL5l2PBReGgGf03C9O8/YMB3sywC0DvO
         vyxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YBXOFCandu4G2SsFlAyt4sp3V7jHiFKqfq70fofyWQg=;
        b=VNg5C14PyADX6M3L6cKjr9uFxIW/vXq9MoGAw+nxycwk4v5kl6xojSr0ioHSksi+MJ
         RMzMgYn6eVnIwjKgubDVZ8c92axd6djEw25gnGJQN9KNbAi25FOTs9BO/+tRMMk+jZN1
         LI0klYPSCprUNA6rzoGh08duUvedIrykvnV8Wl4uzQtaZsPOSE9H5pAs26znapVRyUFW
         J27sNMNwtq2yG9QDdvMfBHCv253sIdz8Crf4NhGQwNbbHHzpq1E/rf0IAuuJGEh0x3Mm
         5cC/9yd7BGkPc6fDjmyOEsI+MZKOY7dPhVq3k/UepVVSmJBr1azOGGCN5xqvyvXC0qPO
         8meg==
X-Gm-Message-State: AOAM531/PWjm9q3L1GkyEYjBb+g3IUaighnECJx6hrH5Ee0FL9eTNcHY
        LgZFRWfiIG6aD2rRxZHGIiJjUA==
X-Google-Smtp-Source: ABdhPJy2UlLFZEAkumhAtHYZJySWyCWcFxYXkOh6J4l2UgYSXF500NYBLmax2v/UWODcLtv6pTNomA==
X-Received: by 2002:a17:90b:1897:: with SMTP id mn23mr5213209pjb.97.1627407829935;
        Tue, 27 Jul 2021 10:43:49 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t9sm4671944pgc.81.2021.07.27.10.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 10:43:49 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 06/10] ionic: increment num-vfs before configure
Date:   Tue, 27 Jul 2021 10:43:30 -0700
Message-Id: <20210727174334.67931-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727174334.67931-1-snelson@pensando.io>
References: <20210727174334.67931-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the new VF to our internal count before we start configuring it.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 505f605fa40b..7e296fa71b36 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -165,10 +165,10 @@ static int ionic_vf_alloc(struct ionic *ionic, int num_vfs)
 			goto out;
 		}
 
+		ionic->num_vfs++;
 		/* ignore failures from older FW, we just won't get stats */
 		(void)ionic_set_vf_config(ionic, i, IONIC_VF_ATTR_STATSADDR,
 					  (u8 *)&v->stats_pa);
-		ionic->num_vfs++;
 	}
 
 out:
-- 
2.17.1

