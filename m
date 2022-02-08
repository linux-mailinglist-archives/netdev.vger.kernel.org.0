Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4AF04ADB1F
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 15:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351049AbiBHO1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 09:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbiBHO1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 09:27:00 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD71BC03FECE;
        Tue,  8 Feb 2022 06:26:59 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id t4-20020a17090a510400b001b8c4a6cd5dso2944130pjh.5;
        Tue, 08 Feb 2022 06:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i7CZiGzaoM7MiROudJbuMXrNK/FlD/qiY6ZK8KOg4qE=;
        b=cXT1xaU/DTIMYTuPqjNzKGrQu15z+a5PiDD0FpGPJ0oc9Im0+gQDUrxeFG7TLrMEH4
         /rRL7PUDpI/UiDAVJ2ZvYLvJOvUYI6Suoj6xf8A1xO41hFPEdY05IvcbKMD2f8U7RPsd
         eI+C4uKHgnl6CwvEsMV8Va9HCbdDKr4InI2Szpu0bD6pblCqjQQV6WgwTwb/38VQ4SEn
         t8TaqmNSQvozWsjnh5yVrnnMe8bpMEds72wEekbN1sVstIubHxIikS/Zw+xL6g/B5V+r
         BbmCmdwctC1qqKgt3I5Tm3dece8BY3NIxLrujnsntwPkOxKjFtxZV36zEODB8YudsbDO
         6aNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i7CZiGzaoM7MiROudJbuMXrNK/FlD/qiY6ZK8KOg4qE=;
        b=SR5RN+7vFW6o2S/i90i/DL/XHcP/EGAM8NmB6EjJvgZPzvUw2EuTHbZ+0ZyhvAzeND
         2ok7FHzjyjPWj+zsP6wbBvtrTgSkLrmQIhih4D5YTS5LLmybRICDDYQ9khjNwNO5ru31
         iuqHK9hOUdmDTrQE23Rs0eymVEMCkuu+PuljQLTa96POHdjb08hV2Zv8xalXiIEYmeld
         c5txRexv7DAeiX1XII/p6fVg7XTak0FQlgHUq9N/8QOKNWM7b243vE1vNUT2n5oIqXre
         PI/fNO5cxe067sMhUHPsddJ5R4X5dq3KJVvSTPNuQrTVhQbF2fFjsmKUslyGajFKDUVd
         YY4Q==
X-Gm-Message-State: AOAM532bLOs66moFIbRpoolz6cS5xJyxrn79cl4M0WCUYD4eEa1IG0K4
        A04oruv/bJPssup0KbDbbMQ=
X-Google-Smtp-Source: ABdhPJyLhzpQHUL4Vduk10Hi9sFVjTBsjeep62O0QRwUZhfmGgeXVWg7nzc77QevfV5HTjRZeCBOhA==
X-Received: by 2002:a17:902:7c0b:: with SMTP id x11mr4845906pll.138.1644330419247;
        Tue, 08 Feb 2022 06:26:59 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:f:aca8:99fd:8b7b:976])
        by smtp.gmail.com with ESMTPSA id h6sm16054101pfc.35.2022.02.08.06.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 06:26:58 -0800 (PST)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
        kuba@kernel.org, michael.h.kelley@microsoft.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH V2] Netvsc: Call hv_unmap_memory() in the netvsc_device_remove()
Date:   Tue,  8 Feb 2022 09:26:52 -0500
Message-Id: <20220208142652.186260-1-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

netvsc_device_remove() calls vunmap() inside which should not be
called in the interrupt context. Current code calls hv_unmap_memory()
in the free_netvsc_device() which is rcu callback and maybe called
in the interrupt context. This will trigger BUG_ON(in_interrupt())
in the vunmap(). Fix it via moving hv_unmap_memory() to netvsc_device_
remove().

Fixes: 846da38de0e8 ("net: netvsc: Add Isolation VM support for netvsc driver")
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v1:
	* Call hv_unmap_memory() before free_netvsc_device() in the
	  netvsc_device_remove().
---
 drivers/net/hyperv/netvsc.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index afa81a9480cc..e675d1016c3c 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -154,19 +154,15 @@ static void free_netvsc_device(struct rcu_head *head)
 
 	kfree(nvdev->extension);
 
-	if (nvdev->recv_original_buf) {
-		hv_unmap_memory(nvdev->recv_buf);
+	if (nvdev->recv_original_buf)
 		vfree(nvdev->recv_original_buf);
-	} else {
+	else
 		vfree(nvdev->recv_buf);
-	}
 
-	if (nvdev->send_original_buf) {
-		hv_unmap_memory(nvdev->send_buf);
+	if (nvdev->send_original_buf)
 		vfree(nvdev->send_original_buf);
-	} else {
+	else
 		vfree(nvdev->send_buf);
-	}
 
 	bitmap_free(nvdev->send_section_map);
 
@@ -765,6 +761,12 @@ void netvsc_device_remove(struct hv_device *device)
 		netvsc_teardown_send_gpadl(device, net_device, ndev);
 	}
 
+	if (net_device->recv_original_buf)
+		hv_unmap_memory(net_device->recv_buf);
+
+	if (net_device->send_original_buf)
+		hv_unmap_memory(net_device->send_buf);
+
 	/* Release all resources */
 	free_netvsc_device_rcu(net_device);
 }
@@ -1821,6 +1823,12 @@ struct netvsc_device *netvsc_device_add(struct hv_device *device,
 	netif_napi_del(&net_device->chan_table[0].napi);
 
 cleanup2:
+	if (net_device->recv_original_buf)
+		hv_unmap_memory(net_device->recv_buf);
+
+	if (net_device->send_original_buf)
+		hv_unmap_memory(net_device->send_buf);
+
 	free_netvsc_device(&net_device->rcu);
 
 	return ERR_PTR(ret);
-- 
2.25.1

