Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76332255173
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 01:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgH0XAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 19:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727845AbgH0XAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 19:00:40 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11066C061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 16:00:40 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id z18so3423079pjr.2
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 16:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=b95V2uQSQxoMk2ke897SOwfl3yK+HzDEOhz3RteTQpg=;
        b=JskjMS8rFcOcwF4wRa5aZ+v8jVK/44L3AXLuo3exk63wbbXNw+VjCpoaG87rtoKEME
         ko7+8z7771rJHYi+lQ3ryMZqgk3UBctU50sZgsoxhV97vk+ixeNWVG6ksMeFGyZeSRef
         WLYi5+gnX+7TDFOqPqchK0IYeIp2J07qHnikKh6KDVKggSRq/F5kZNct7OpiA86mbnqJ
         t+9uqdNdHiw8jVf01kT0cIj2J05wNAjdrukLFecVz54RKsbaC/zRtEvK9nWR6DOr1211
         y05nFE/JmykSaw8lwUXwMPo1vmn7NfFs8GSiyxgp/yMMtF9jzGlSzhaHWaRE1vCaatd7
         Lgog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=b95V2uQSQxoMk2ke897SOwfl3yK+HzDEOhz3RteTQpg=;
        b=Kbw930Ka0SH1h451MqcdJokhwBWnhYs0yoaba7qyGNJL3viVL1Z+NUfvMM9L5ut+jn
         gKtj0oapFdY/QgBFVDqUl3s2t+lVE5PNXLItOKXdyuoucPOcJXxvSNfqTO+yCIwu0J8F
         mdxkI+2G9TW6y9xiQoLwZMkswAZIEjvqq5bJUvDgb6pKezbbHQHPN63dt4yUWoPJZgwQ
         Ntd7sChApui8Az3zfAiIRFoC4Bz9I1/cZkEmpd5lz3QZnvWnTMErlOY9vn9/8pdunTlk
         mvtM74jT0RO7OteiEJF5VZXSNjQU/P8O2/NgUFB+iUsQgRp6ba1q0Wt0O5fw1xtZTW6l
         ctCA==
X-Gm-Message-State: AOAM5303FYVmjfQgyZM7sANejxA2aQJTCCPuvPxRsMaKhBYhikGRp4Wk
        lkt9LlOCRDspz4VlvLPWPPEvwqPPyTMEmg==
X-Google-Smtp-Source: ABdhPJyzDjRCnWhD7WwD0vdZZfrbZp7rY3v5Cf3Z18beWxA0ZowP3uP3wrExfwAdcSUVrfy5FwEDFA==
X-Received: by 2002:a17:90a:2bce:: with SMTP id n14mr987994pje.20.1598569238840;
        Thu, 27 Aug 2020 16:00:38 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n22sm3137534pjq.25.2020.08.27.16.00.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 16:00:38 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 01/12] ionic: set MTU floor at ETH_MIN_MTU
Date:   Thu, 27 Aug 2020 16:00:19 -0700
Message-Id: <20200827230030.43343-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827230030.43343-1-snelson@pensando.io>
References: <20200827230030.43343-1-snelson@pensando.io>
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

