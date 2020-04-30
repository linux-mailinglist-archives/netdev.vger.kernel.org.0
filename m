Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B218B1C0970
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 23:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgD3Vd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 17:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728073AbgD3Vdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 17:33:55 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5427EC035495
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 14:33:55 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id fu13so1463019pjb.5
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 14:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dJ9+kFqXFrpdHLiWYSazGnkujgJqbuT3m3Zj97VRUVY=;
        b=lHasLmoeLvkHx7CiJ9oAKZGkLl+hD4x1wEibnsmOz+TWF8x4Y+jjWfErFW9BIgW2ss
         boi2MzyTR2WnotFhhuZmMLcgWp8j0fQIxxbnWtkr0IR1ziBE4hJ5IiQ2fyxgCqzLQ5IR
         lQxlrQenZLxNduU8wSJJYFZFjlkvyiKuawSpxeBvUcM8YLpbyy7n3hLkHmIts6wr4KGY
         Hj+JsoIkylNaa4IrhMM5caxMmfKcj9Z8l9vYL17lHHfgAbyc/O7LG2tAvfy5HnIcqHAR
         7X5k3sxGkYPF8GQnDLWS8qsRCdYCpfNVicyMwb8mQ9vtWE5EZ3bZSGQb99pUXSFr4Wj5
         1neQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dJ9+kFqXFrpdHLiWYSazGnkujgJqbuT3m3Zj97VRUVY=;
        b=lAkbDXASTsYpeKm0jSOsyptLAcWF7AxieITKEalMFFrflpNURSZRrGs9ll4KyQ2Gdw
         krhINWKrAG8pqYkcAFmHPoOHh5EFr8giFX7D0F5SB2lqqLlrmMimJ3d5WWIwQLX3TV68
         Tr09JrHth+gIfDBAAND+fG+EumKeBu1u0mQE06tWjFO7uKvhhMOAviJPPh9QHap4NAgr
         mCrLgWRb17U5Z7bKaGQIrBvWB0QyjaCtBYea9wh39MHgE4d6qJ/UAUb3dSdfrrEI7O6B
         UOyETzWS0Q5nZlTzxSgiPfMNw6HE4mF81r8ljp93nkgs/TdnLcFCLUfQRv57F5DddPdt
         tVsg==
X-Gm-Message-State: AGi0PuaQhCbXtsdCnO6LLy75Mh1VAg3SgQF5FMWUrJTXn2mSGsh7Lhqv
        GZMkvyx+VxxztJrXo4BJKyKXZ66+XO8=
X-Google-Smtp-Source: APiQypKbH9V0AxUAfT1PTnjLlO/IYx/aODwXc3dIcwrMT7xzw7goFl0558/K2oPgKM+epwUmXAw8ew==
X-Received: by 2002:a17:90b:3017:: with SMTP id hg23mr1003201pjb.150.1588282434587;
        Thu, 30 Apr 2020 14:33:54 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id f9sm579086pgj.2.2020.04.30.14.33.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Apr 2020 14:33:53 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net 3/3] ionic: add device reset to fw upgrade down
Date:   Thu, 30 Apr 2020 14:33:43 -0700
Message-Id: <20200430213343.44124-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430213343.44124-1-snelson@pensando.io>
References: <20200430213343.44124-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Doing a device reset addresses an obscure FW timing issue in
the FW upgrade process.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 6fcfb634d809..d5293bfded29 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2101,6 +2101,7 @@ static void ionic_lif_handle_fw_down(struct ionic_lif *lif)
 		ionic_txrx_free(lif);
 	}
 	ionic_lifs_deinit(ionic);
+	ionic_reset(ionic);
 	ionic_qcqs_free(lif);
 
 	dev_info(ionic->dev, "FW Down: LIFs stopped\n");
-- 
2.17.1

