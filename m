Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384FD2A708D
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 23:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732139AbgKDWeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 17:34:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbgKDWeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 17:34:05 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6109AC0613CF
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 14:34:05 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id f21so11652plr.5
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 14:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RzMJ5I54EBNjTKdQhYz0zoJbUVPD0Jjli8LFYU8UorI=;
        b=HecjOmllXgSCtf/4tjaZiOrCgJv4u+6yIkO5iXYKZyvaCdQIgnlAyz54K790Slx4Sw
         m0Udv99gljJuDLU6LvMXhc3k/rb5XNWCImvIgvZq8G+I+istGsfbbpx1gSSCNUCVagdj
         Fotoi+wqRRNKFW6EIz6cQ4Yhb9Ahg7Tng9DCZmAc2LeDmJepfeB3l5kstH40xB9NfwqE
         Sw6FGYab3qrzJ4Z5k5mjiSroOLXSEcXc5iNyzHorA+YOxKpMc2Wq3dq9YIvJ7xwyi45y
         DK7vxiH5tLkYfnAwEPm5Q6ve12TfSZCd+Gks3Sgto7ovz1jPOcnHv9pflLuD264fK22c
         gxbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RzMJ5I54EBNjTKdQhYz0zoJbUVPD0Jjli8LFYU8UorI=;
        b=YfNN024ea0gYUNti3W4Ube0qZAday2mWVKP/27SNdLmvmWxK6Tj0RyXbb8tsT8K7iE
         gGl6fBZaTJaQ00yqbslIxUkU3UYlxqqJnjiCsKIrczWjQbpottJxCjK1H8zCQcE32IFg
         jGeOLLDjyJVZWSvEF/DhV6UnTWC3Q+30QzhKhaQrHmafMG4HonrKhZ/hoA6R7YMoJRbl
         HQDb+uNr2LoJMAOxRyMNx4uT0bKco/DjSVxWH+mKJoGZzQxLgJfmnzjtUd7DqnjGa0tw
         b+7237Ci6XyJtDufcP/+NXAjokH7xQr46ZHrnTI+ypedh8txvt8effSP+iy9on5/6s6q
         ajIg==
X-Gm-Message-State: AOAM532U/KRE+y+kVKS8BfcYGq7c/133mrDnTbGgumKgV48g9Up6EnuF
        hODA4WiadwgW6FoxeR+wmBx+Yur3NqYYlQ==
X-Google-Smtp-Source: ABdhPJwle21v3ebYBwObKUHEa+HJ6uA57+j+aQ3wGOPqepv9kmJz5xs5wm7bOgk45FACXdHmW5FqAQ==
X-Received: by 2002:a17:902:7004:b029:d6:489b:6657 with SMTP id y4-20020a1709027004b02900d6489b6657mr17560plk.20.1604529244707;
        Wed, 04 Nov 2020 14:34:04 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id z10sm3284559pff.218.2020.11.04.14.34.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2020 14:34:04 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/6] ionic: check for link after netdev registration
Date:   Wed,  4 Nov 2020 14:33:50 -0800
Message-Id: <20201104223354.63856-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201104223354.63856-1-snelson@pensando.io>
References: <20201104223354.63856-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Request a link check as soon as the netdev is registered rather
than waiting for the watchdog to go off in order to get the
interface operational a little more quickly.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 5457fb5d69ed..519d544821af 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2959,6 +2959,8 @@ int ionic_lif_register(struct ionic_lif *lif)
 		dev_err(lif->ionic->dev, "Cannot register net device, aborting\n");
 		return err;
 	}
+
+	ionic_link_status_check_request(lif, true);
 	lif->registered = true;
 	ionic_lif_set_netdev_info(lif);
 
-- 
2.17.1

