Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C077844BA80
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 03:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhKJC6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 21:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhKJC6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 21:58:16 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33892C061764;
        Tue,  9 Nov 2021 18:55:29 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id z6so1300906pfe.7;
        Tue, 09 Nov 2021 18:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a7KM3VdqqYUTvF2GuAQhRgwx4oYUc4pUUt/dSikZNWo=;
        b=cqbp972q7dfi6PTX9FNUZ3ROPcyqQMZ6hDX7ADQpR+yr916BjZcE5/ZCm3ulfI26z6
         fEGk7xVsZ1b4f6Q8Yit13Es11mhYFs0tvRDnvzyFZ/M3y0urHIShAB9pHzwZeiRqczjJ
         EYHMUDsFL00YovWsQ0dy/qUUvvF2ofjLjcBt2JXfAQDj+gemMlP8ZxC3jpkjHQMtMUyK
         vn/iW/ZuHKS/D/ZvRJd/mm5XYl3gwmTCeycvpxdBhHts3XhLIdYawtz/Up3t7PlsG8AN
         dPsruCk9/5ryQwwKgMmX+VLKm2QIYq9Oen8KWV7tqIBpMn6qoPtcYt6XpUNoNRaY76yl
         ar1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a7KM3VdqqYUTvF2GuAQhRgwx4oYUc4pUUt/dSikZNWo=;
        b=iL1EwDC8hLbqImTAQeXJwbv46nTJ0fUFEHAAUTwdm8bcCnTUhXLhu+oKYnp71KkmCu
         ZQkXXKfGOHHyC7DQlvdifbkn4vhmbjvQirM69sFOzfju/Bx2s59j00BDZaNaUgYi7Fzx
         iog+TTIk3S6635SW60Aei76Y30doiIjET4kfuE2eJonB3sG38XBFnB0+xHb3YWq756vX
         nDk1R2g/hlrYk5Tdx0muQ7mESWl7fUB4S9iXKY61Dp3X8ErjlYvtSoF44VwkOKDIrnVW
         W8W2rG9wFcpcopCLf2x+hn+ZINbDsA2NkpE3FOIMf88jThqjkhfDPSmxAZLBdrWf/Ayt
         9HCA==
X-Gm-Message-State: AOAM530aZYotYhE4LK+xUzaGz1DX0CZKy7uWPRunTRSwswwqMoNSLnkr
        o4HV8Sq/KanJ0Cx8ceCNyTw=
X-Google-Smtp-Source: ABdhPJzKfppYX25/SMmLpJRF4q3ykdDPG33CzXpvAEexTvAHH84l9h7tQ59wwQ8fVqJj05XQatSwTQ==
X-Received: by 2002:a63:710:: with SMTP id 16mr9839983pgh.324.1636512928629;
        Tue, 09 Nov 2021 18:55:28 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id il13sm542531pjb.52.2021.11.09.18.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 18:55:28 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: yao.jing2@zte.com.cn
To:     pablo@netfilter.org
Cc:     cgel.zte@gmail.com, coreteam@netfilter.org, davem@davemloft.net,
        fw@strlen.de, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yao.jing2@zte.com.cn,
        zealci@zte.com.cn
Subject: [PATCH v2] scsi: snic: Replace snprintf in show functions with  sysfs_emit
Date:   Wed, 10 Nov 2021 02:55:23 +0000
Message-Id: <20211110025523.136272-1-yao.jing2@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <YYkHdbjKFTiSlfNj@salvia>
References: <YYkHdbjKFTiSlfNj@salvia>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jing Yao <yao.jing2@zte.com.cn>

coccicheck complains about the use of snprintf() in sysfs show
functions:
WARNING use scnprintf or sprintf

Use sysfs_emit instead of scnprintf, snprintf or sprintf makes more
sense.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jing Yao <yao.jing2@zte.com.cn>
---

Changes since v1:
 - Revise to meet the format "80 columns".
 - Revise to maintain parenthesis alignment.

 drivers/scsi/snic/snic_attrs.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/snic/snic_attrs.c b/drivers/scsi/snic/snic_attrs.c
index dc03ce1ec909..de1fee9246dc 100644
--- a/drivers/scsi/snic/snic_attrs.c
+++ b/drivers/scsi/snic/snic_attrs.c
@@ -27,7 +27,7 @@ snic_show_sym_name(struct device *dev,
 {
 	struct snic *snic = shost_priv(class_to_shost(dev));
 
-	return snprintf(buf, PAGE_SIZE, "%s\n", snic->name);
+	return sysfs_emit(buf, "%s\n", snic->name);
 }
 
 static ssize_t
@@ -37,8 +37,7 @@ snic_show_state(struct device *dev,
 {
 	struct snic *snic = shost_priv(class_to_shost(dev));
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",
-			snic_state_str[snic_get_state(snic)]);
+	return sysfs_emit(buf, "%s\n", snic_state_str[snic_get_state(snic)]);
 }
 
 static ssize_t
@@ -46,7 +45,7 @@ snic_show_drv_version(struct device *dev,
 		      struct device_attribute *attr,
 		      char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%s\n", SNIC_DRV_VERSION);
+	return sysfs_emit(buf, "%s\n", SNIC_DRV_VERSION);
 }
 
 static ssize_t
@@ -59,8 +58,7 @@ snic_show_link_state(struct device *dev,
 	if (snic->config.xpt_type == SNIC_DAS)
 		snic->link_status = svnic_dev_link_status(snic->vdev);
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",
-			(snic->link_status) ? "Link Up" : "Link Down");
+	return sysfs_emit(buf, "Link %s\n", snic->link_status ? "Up" : "Down");
 }
 
 static DEVICE_ATTR(snic_sym_name, S_IRUGO, snic_show_sym_name, NULL);
-- 
2.25.1

