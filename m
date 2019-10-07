Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04C58CEBE2
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 20:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbfJGSaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 14:30:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58430 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729458AbfJGSaa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 14:30:30 -0400
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 10A5A50F64
        for <netdev@vger.kernel.org>; Mon,  7 Oct 2019 18:30:30 +0000 (UTC)
Received: by mail-qt1-f197.google.com with SMTP id t25so6824544qtq.9
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 11:30:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Veqvl+qM0CfutM3PPjJjEy4hKVrp4NP3ezEQkZHIQPg=;
        b=rMzMaHZF5A0Z+ztBZ5h6mtSB3Lduapq9rrhPX0epAU+/QO86C4J6KwizNEv2X4huFL
         3/js6Czrwfp0EdVkv/385z9PKI+VpzY/yNpxweg8vGzNkLev9Rv5R/736JZ4ItKdn4p3
         Bq9iP5yvIF0ZS5A2/aSvsBCgN1IZQ2Vewx32XdgrdZ+4+t4ICok83SnoZhFDdOZeQbGi
         cjzajiTsocUsvRHc6VYfYEbbS/uJsNITZf4xWYXPpeIAnlgjPvRUWsQxiitTBfSvaFAr
         MbwiEOBvzgcMFTPk1xSP2IDQ11VgROCpDeMEofROLySEgX/HgEgMWw8T0Eh7wbmcaDa6
         yBag==
X-Gm-Message-State: APjAAAWEVP9yaV3QapspNIzcCoy+P8mFH5UvGQQodtx9Hx9IS9Kest6r
        y2Q3rrjL3t4Gpscx1PBR1louy0cBnWxymJxSzcENjNcLxa+Bh1sLKpnSIlOarChLKj69/t5XGdf
        wObR2Wk+tWIgzFgoO
X-Received: by 2002:a37:8f86:: with SMTP id r128mr14609054qkd.392.1570473029367;
        Mon, 07 Oct 2019 11:30:29 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx5hMQXVRiXUEyBzpDI1RwgrB4b7tr07l8zU3XqKSSML03JT2g+x+mug176n0y6vIeLAWA/TQ==
X-Received: by 2002:a37:8f86:: with SMTP id r128mr14609014qkd.392.1570473029025;
        Mon, 07 Oct 2019 11:30:29 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id s50sm9515361qth.92.2019.10.07.11.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 11:30:28 -0700 (PDT)
Date:   Mon, 7 Oct 2019 14:30:23 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH] vhost/test: stop device before reset
Message-ID: <20191007183019.12522-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When device stop was moved out of reset, test device wasn't updated to
stop before reset, this resulted in a use after free.  Fix by invoking
stop appropriately.

Fixes: b211616d7125 ("vhost: move -net specific code out")
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 04edd8db62fc..e3a8e9db22cd 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -170,6 +170,7 @@ static int vhost_test_release(struct inode *inode, struct file *f)
 
 	vhost_test_stop(n, &private);
 	vhost_test_flush(n);
+	vhost_dev_stop(&n->dev);
 	vhost_dev_cleanup(&n->dev);
 	/* We do an extra flush before freeing memory,
 	 * since jobs can re-queue themselves. */
@@ -246,6 +247,7 @@ static long vhost_test_reset_owner(struct vhost_test *n)
 	}
 	vhost_test_stop(n, &priv);
 	vhost_test_flush(n);
+	vhost_dev_stop(&n->dev);
 	vhost_dev_reset_owner(&n->dev, umem);
 done:
 	mutex_unlock(&n->dev.mutex);
-- 
MST
