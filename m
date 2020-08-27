Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380AB254C90
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 20:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgH0SHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 14:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbgH0SHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 14:07:49 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9951FC061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 11:07:49 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id 2so3035633pjx.5
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 11:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=b95V2uQSQxoMk2ke897SOwfl3yK+HzDEOhz3RteTQpg=;
        b=0GN3e3QIeP6cGDCj24EVpa+9zz/arrG0TbcwsdVjV00if+L5GM3hKk/GgY16b0IIF0
         WVs28n/B7tCD3LaeqWreiDrNqVOGEbsEHbzXFOu+OuRjAvLP9kaT1Y34Tu1WERzHLi2p
         R9hgmD8LNFYJRrNYx4Rzvy+A6LSs+0EoXIdgXeDLmmJYSz1gQs3o2tspm3HqicmQT/Tn
         kjnz8z9edUNRpCSrjPkyETSSZOp1cZgsjftMIKw0WuLbIXw2dQ2tP8tnSWIlw5IYlDTN
         taR/v5cx0jiN2ADGWEOl0loXooQtFBFqqA9YIz51c+gW/n7SSBBMW0Z8gkSU6vfn0OcJ
         WdPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=b95V2uQSQxoMk2ke897SOwfl3yK+HzDEOhz3RteTQpg=;
        b=AYq1SiH2OD5ivK7vhCDTtyNGOxqXaZemtT++KtYtQqM8vUsGwRcQVeaFA7SR23aZwG
         P0a9aJdtcX7u6AFtxUScDvgexEqKGWspFa3cCJkMo8tX4bWrk9tuRYDaOxYTdm9QmprC
         Jeo5/e/W/HEjJRH6TmxzbvcFfaXJu3NbY4D4HO2Y+dkGvAwTuSCQuTUT0PqMQwiq8Zf6
         et3DNcAYSjCntLkVXC99IXcBehiS5/ekPoS3/8b1oYPxTV6ypYuwLWWlCgO3EWDKKzrk
         0Yld23giHCuQL1aXwKy56GVnymz+XymcGYIMoJo1aLhNRIw1fde5q+96uBoDEicRxzYD
         ai0A==
X-Gm-Message-State: AOAM533v85eklOJfsZouqakot4Q2al1JKU5QwC7EEKq/H+5pgecXGIzu
        mjjSDhOHBbD2ZlrmdBxyluIdjFXSZiC0GA==
X-Google-Smtp-Source: ABdhPJxHO8P3UmIDqm8n5YAsfTzo8SmlcYaECOGlhBwlJ5Llc34G6aXU0K1PaZ1W56RG7Lt6gtAtLw==
X-Received: by 2002:a17:90b:1b45:: with SMTP id nv5mr64469pjb.35.1598551668809;
        Thu, 27 Aug 2020 11:07:48 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n1sm3480249pfu.2.2020.08.27.11.07.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 11:07:48 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 01/12] ionic: set MTU floor at ETH_MIN_MTU
Date:   Thu, 27 Aug 2020 11:07:24 -0700
Message-Id: <20200827180735.38166-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827180735.38166-1-snelson@pensando.io>
References: <20200827180735.38166-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The NIC might tell us its minimum MTU, but let's be sure not
to use something smaller than ETH_MIN_MTU.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 26988ad7ec97..235215c28f29 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2079,7 +2079,8 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 	lif->identity = lid;
 	lif->lif_type = IONIC_LIF_TYPE_CLASSIC;
 	ionic_lif_identify(ionic, lif->lif_type, lif->identity);
-	lif->netdev->min_mtu = le32_to_cpu(lif->identity->eth.min_frame_size);
+	lif->netdev->min_mtu = max_t(unsigned int, ETH_MIN_MTU,
+				     le32_to_cpu(lif->identity->eth.min_frame_size));
 	lif->netdev->max_mtu =
 		le32_to_cpu(lif->identity->eth.max_frame_size) - ETH_HLEN - VLAN_HLEN;
 
-- 
2.17.1

