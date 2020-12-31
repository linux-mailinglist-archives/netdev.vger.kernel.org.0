Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B872E8185
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 18:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgLaRoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 12:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbgLaRoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Dec 2020 12:44:21 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF856C061575;
        Thu, 31 Dec 2020 09:43:40 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id d2so11530668pfq.5;
        Thu, 31 Dec 2020 09:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ia8tv0h5ZzJ5gNszPbUc817/+eyTpNW6AgHWJu4KE0Y=;
        b=vh4Al7TqcE4Rzb9O5aoDb84kXwnxrrNb53k3LgYmbhsbaxGJNktNhFbYmODUnEMEBy
         DIujNqCXaIKxUgK8Vsa+803NJa5flHuEYx/GXMqG+wwCbanP7BdLiGkgZwi7C+M+/0Ay
         PTVPl1/NoS7SHHXjXrijudUoGg5AtpFBvJ0BoyMKzDbI3zSqmNySh7O3CK9XPg0ohcdM
         aEiArn6py+h/xLadFZ6BfAyGS7c89rLZIYhyejflPTNAUr3KQySVnAumumIbuGXrRGCL
         9aF+EKtzpmiK2boJEjGSCRJR0fIV4x9vdOH+44PjRZkgdUtfVMukTfhQXbFH6WcxhBAW
         xY2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ia8tv0h5ZzJ5gNszPbUc817/+eyTpNW6AgHWJu4KE0Y=;
        b=gFrlqbKPMewcreGtAY+Pg8iXUDX9S4cTsLrH2qxN7VOEDYjHsYq790/pDk7scrOJEx
         HzBIUf7Z2MCss4xgDPC8ES151l/Vyce6E8/4XILxqw8kUWobWMXdbfxjcVTFkrJp8ylj
         BvRqwIfiEWbETYMvyj+rtTaBAcRhXW4wUx1PdyyonSrkj8wIcq8bN+K6FjFD/A6+Lms9
         oroAlOtgcQ5HFTISr9M9g5Ng69Qi4RkNhPpcg3u1x/Z8fGuwUC5BHFh2PAxMWRH3LcVI
         NaaDBuFN6Que5Wnw5pT50m7sQGZV1WXHgAc5zquNw+1KEaAfMTH/R3CUoGDQXnVcVbQF
         y+cQ==
X-Gm-Message-State: AOAM533zcW50h0zF1Mu9J7syUZnrwzxIz7/WjRZxhmZAvbPccTSF0eQB
        /Sq2Y4lm8CBfmTeRsF3DWkE=
X-Google-Smtp-Source: ABdhPJxc4m1rVR8jrWsmrLinroPxtv1Qn1p+s+3fhOdID3bMcksOCjbUKOdEx3Aqjya/pwnGcOvBbw==
X-Received: by 2002:a63:2352:: with SMTP id u18mr17934963pgm.385.1609436620358;
        Thu, 31 Dec 2020 09:43:40 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:8bca:1c1d:98:f137])
        by smtp.gmail.com with ESMTPSA id x15sm45384045pfn.118.2020.12.31.09.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Dec 2020 09:43:39 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net] net: lapb: Decrease the refcount of "struct lapb_cb" in lapb_device_event
Date:   Thu, 31 Dec 2020 09:43:31 -0800
Message-Id: <20201231174331.64539-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In lapb_device_event, lapb_devtostruct is called to get a reference to
an object of "struct lapb_cb". lapb_devtostruct increases the refcount
of the object and returns a pointer to it. However, we didn't decrease
the refcount after we finished using the pointer. This patch fixes this
problem.

Fixes: a4989fa91110 ("net/lapb: support netdev events")
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 net/lapb/lapb_iface.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/lapb/lapb_iface.c b/net/lapb/lapb_iface.c
index 213ea7abc9ab..40961889e9c0 100644
--- a/net/lapb/lapb_iface.c
+++ b/net/lapb/lapb_iface.c
@@ -489,6 +489,7 @@ static int lapb_device_event(struct notifier_block *this, unsigned long event,
 		break;
 	}
 
+	lapb_put(lapb);
 	return NOTIFY_DONE;
 }
 
-- 
2.27.0

