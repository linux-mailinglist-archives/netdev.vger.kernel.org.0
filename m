Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158D6266262
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 17:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgIKPpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 11:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgIKPnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:43:39 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DCEC06134B;
        Fri, 11 Sep 2020 07:18:12 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id g4so10167195edk.0;
        Fri, 11 Sep 2020 07:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Y6nSNj00j90TgjvRnkc+InI/a7CFYGYzQ75YXhZJXxU=;
        b=c5xqTemviU3gKg9j+DUEX+mY71ZNYbjKmeQ5vscVlvaFSWmD6fCvE0SM6LAQo0XTIt
         Lx3xwWuI7aAKuDnJ2TckQY4DqHdIpfZKInFDnKKxH8dPU8lyyvfd0/+T/lGVhMbmrcLd
         TujlkJnS3Yo7dWNWdRAix6mDCD7FNwDNoDzXjVuLGuj3AfZQ58c40L6C7zkQG2wVX78u
         DPgqZkJ9CNLAoIiA0NPdQukKpzRy++oowfDvKPWwiNkfRgYWo7j8CuouXISSRV4YdvdG
         WkKUDWIIGJgDG9USHh+vNrO1J2d43qBlxOgp/s5ba09YtAWMbb/ha3D+r5ZSXC1FjUNm
         4uMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Y6nSNj00j90TgjvRnkc+InI/a7CFYGYzQ75YXhZJXxU=;
        b=MlxRkt1y06XezsoAr8QAnqrn4+tpfqRLVmreaSSkCXT0/ad6lSjvcqu66v8jgNLdfS
         3WRwP3uXmNbBvtZUKkYUSnLpjq7jTjVlLkCsGT3rgCMBmU2tK2LvaZHSihjvtV/WaNZV
         gn2mw8hQVh4wYWW7HHTKk5260qyUfJbENw0j5AZMHg21JgBWM6Kz3TS6Zogua/yrjE5r
         02v8xJQKcV3z2eqoTVFyH2/jorvMCiMVbQXlId3gNvLT0addktEr0jj6+qbSa9moasXu
         DH/kn5vT/3YAhZEwN2x82cbK8h+gWcD0H/mHVxKWILLwQrfoosy5dwkfYQT1qUuIw7kZ
         EI7w==
X-Gm-Message-State: AOAM532wnlXYCc1Fag5ES4FZ87xsJz2tNuOMPK8YUDdt6vGLEUR6K3d+
        jJeKWBku0Gyqp/oOtUH2yDkdjEvNGot+iw==
X-Google-Smtp-Source: ABdhPJzjCmZLQ0J9GrJCMYDaj8Gd2SRJ2HQMB0rcW//JL3LJ60QoL8xE7XGiWQhh1JLMQx6YDUN+BQ==
X-Received: by 2002:a50:f1d1:: with SMTP id y17mr2136764edl.231.1599833891611;
        Fri, 11 Sep 2020 07:18:11 -0700 (PDT)
Received: from aherlnxbspsrv01.lgs-net.com ([193.8.40.126])
        by smtp.gmail.com with ESMTPSA id q11sm1679069eds.16.2020.09.11.07.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 07:18:10 -0700 (PDT)
From:   Olympia Giannou <ogiannou@gmail.com>
X-Google-Original-From: Olympia Giannou <olympia.giannou@leica-geosystems.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Olympia Giannou <olympia.giannou@leica-geosystems.com>
Subject: [PATCH] rndis_host: increase sleep time in the query-response loop
Date:   Fri, 11 Sep 2020 14:17:24 +0000
Message-Id: <20200911141725.5960-1-olympia.giannou@leica-geosystems.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some WinCE devices face connectivity issues via the NDIS interface. They
fail to register, resulting in -110 timeout errors and failures during the
probe procedure.

In this kind of WinCE devices, the Windows-side ndis driver needs quite
more time to be loaded and configured, so that the linux rndis host queries
to them fail to be responded correctly on time.

More specifically, when INIT is called on the WinCE side - no other
requests can be served by the Client and this results in a failed QUERY
afterwards.

The increase of the waiting time on the side of the linux rndis host in
the command-response loop leaves the INIT process to complete and respond
to a QUERY, which comes afterwards. The WinCE devices with this special
"feature" in their ndis driver are satisfied by this fix.

Signed-off-by: Olympia Giannou <olympia.giannou@leica-geosystems.com>
---
 drivers/net/usb/rndis_host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index bd9c07888ebb..6fa7a009a24a 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -201,7 +201,7 @@ int rndis_command(struct usbnet *dev, struct rndis_msg_hdr *buf, int buflen)
 			dev_dbg(&info->control->dev,
 				"rndis response error, code %d\n", retval);
 		}
-		msleep(20);
+		msleep(40);
 	}
 	dev_dbg(&info->control->dev, "rndis response timeout\n");
 	return -ETIMEDOUT;
-- 
2.17.1

