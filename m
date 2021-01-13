Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D461A2F4B17
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbhAMMNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 07:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbhAMMNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 07:13:48 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75CAC0617A6
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 04:12:35 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id m4so1856924wrx.9
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 04:12:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mL7WDxG4zT3nUU/BtKIjBqyFzFB6+PWnuRMCcmIHzHo=;
        b=tYLc5qNKyPjPaGbRpdHn9CyjwLY7CxkVsGbVgDrtxGLp/04s0PkKG6skFkHR6Wpjle
         qCvmkwzVyku3kz8M9+D9TsOGQmZ2HClSRvT+I8H6Gfqr93QCJlTWt44Xzx3t+hzqFsrY
         ZL3DHNKxooQ+PtjZNF6nKvdCPT3zN9/oySCjATKW9K8vHOMy/o3Ajk9YE9E76h1/doiR
         4zLvWXL41Vrw1svq6Wbs0h81fShKATKrGr53pINlbClvoXM3XhOrt42XZOEH2uA+0hqG
         ZCV3GU4cMqPj3hmeabbiw9GeDdHgrl3UZ3BZW2aFiQb+2G6T0ahfRp+oVS77WrZ3ED47
         mtNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mL7WDxG4zT3nUU/BtKIjBqyFzFB6+PWnuRMCcmIHzHo=;
        b=rG8LDkkG81jO/LCLhoEPt9GeAe4HvqVjLubJRZVtaxvL8dnOG53TUGIRSapVqk70ol
         RVDItEmIpZnztObGeuumRBRhpFseBIrxMlYRyFt6Y7ZljfJ2avPUuNrD10QisXe38PP1
         srTPv/nInBXBSvbRGRBOs/oPiaoMmpLLs8ZxiipN9u3ljWtkCD90htrcLEP3Kauut9lg
         bxlSRo7E3kH3Mwr420t5vuGtO6i0bTFn+x3KlgUVyZZFlN8SWVCcxWn1WPMMY1U1BQ3f
         ZY4UUdPeqO+VyVeTH1qLrLMs6ONJkBR8bwFCksQy9dolg9uqs6OB6iOe1yLM3kDOmdZ3
         g0iQ==
X-Gm-Message-State: AOAM530ywXHwAyWTejmKvYtWT3Pck0nNfwA5QIG99lQ6JkLYUdTzO6jK
        t48SYEm/WiZkqtzD0X4G/VtxU8hH39q+Gg4H
X-Google-Smtp-Source: ABdhPJyl0nDoTqAb6of+h6YpdDlX77U1GV0qnv5smkHQKpDnqO3qW6HvkkMogTAmA7YbwSiWg/zwrw==
X-Received: by 2002:adf:9dc4:: with SMTP id q4mr2278353wre.367.1610539954316;
        Wed, 13 Jan 2021 04:12:34 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id s3sm2567308wmc.44.2021.01.13.04.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 04:12:33 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jacob.e.keller@intel.com,
        roopa@nvidia.com, mlxsw@nvidia.com
Subject: [patch net-next RFC 09/10] netdevsim: implement line card activation
Date:   Wed, 13 Jan 2021 13:12:21 +0100
Message-Id: <20210113121222.733517-10-jiri@resnulli.us>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210113121222.733517-1-jiri@resnulli.us>
References: <20210113121222.733517-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

On real HW, the activation typically happens upon line card insertion.
Emulate such event using write to debugfs file "active".

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/netdevsim/dev.c | 81 +++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 9e9a2a75ddf8..81d68269e121 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -64,6 +64,30 @@ nsim_dev_port_index(struct nsim_dev_linecard *nsim_dev_linecard,
 	       port_index;
 }
 
+static int
+nsim_dev_linecard_activate(struct nsim_dev_linecard *nsim_dev_linecard)
+{
+	struct nsim_dev_port *nsim_dev_port;
+
+	list_for_each_entry(nsim_dev_port, &nsim_dev_linecard->port_list,
+			    list_lc)
+		netif_carrier_on(nsim_dev_port->ns->netdev);
+
+	devlink_linecard_activate(nsim_dev_linecard->devlink_linecard);
+	return 0;
+}
+
+static void
+nsim_dev_linecard_deactivate(struct nsim_dev_linecard *nsim_dev_linecard)
+{
+	struct nsim_dev_port *nsim_dev_port;
+
+	list_for_each_entry(nsim_dev_port, &nsim_dev_linecard->port_list,
+			    list_lc)
+		netif_carrier_off(nsim_dev_port->ns->netdev);
+	devlink_linecard_deactivate(nsim_dev_linecard->devlink_linecard);
+}
+
 static struct dentry *nsim_dev_ddir;
 
 #define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
@@ -299,6 +323,61 @@ static void nsim_dev_port_debugfs_exit(struct nsim_dev_port *nsim_dev_port)
 	debugfs_remove_recursive(nsim_dev_port->ddir);
 }
 
+static ssize_t nsim_dev_linecard_active_read(struct file *file,
+					     char __user *data,
+					     size_t count, loff_t *ppos)
+{
+	struct nsim_dev_linecard *nsim_dev_linecard = file->private_data;
+	char buf[3];
+
+	if (!nsim_dev_linecard->provisioned)
+		return -EOPNOTSUPP;
+
+	if (devlink_linecard_is_active(nsim_dev_linecard->devlink_linecard))
+		buf[0] = 'Y';
+	else
+		buf[0] = 'N';
+	buf[1] = '\n';
+	buf[2] = 0x00;
+	return simple_read_from_buffer(data, count, ppos, buf, strlen(buf));
+}
+
+static ssize_t nsim_dev_linecard_active_write(struct file *file,
+					      const char __user *data,
+					      size_t count, loff_t *ppos)
+{
+	struct nsim_dev_linecard *nsim_dev_linecard = file->private_data;
+	bool active;
+	bool bv;
+	int err;
+	int r;
+
+	if (!nsim_dev_linecard->provisioned)
+		return -EOPNOTSUPP;
+
+	active = devlink_linecard_is_active(nsim_dev_linecard->devlink_linecard);
+
+	r = kstrtobool_from_user(data, count, &bv);
+	if (!r && active != bv) {
+		if (bv) {
+			err = nsim_dev_linecard_activate(nsim_dev_linecard);
+			if (err)
+				return err;
+		} else {
+			nsim_dev_linecard_deactivate(nsim_dev_linecard);
+		}
+	}
+	return count;
+}
+
+static const struct file_operations nsim_dev_linecard_active_fops = {
+	.open = simple_open,
+	.read = nsim_dev_linecard_active_read,
+	.write = nsim_dev_linecard_active_write,
+	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
+};
+
 static ssize_t nsim_dev_linecard_type_read(struct file *file, char __user *data,
 					   size_t count, loff_t *ppos)
 {
@@ -334,6 +413,8 @@ nsim_dev_linecard_debugfs_init(struct nsim_dev *nsim_dev,
 	sprintf(dev_link_name, "../../../" DRV_NAME "%u",
 		nsim_dev->nsim_bus_dev->dev.id);
 	debugfs_create_symlink("dev", nsim_dev_linecard->ddir, dev_link_name);
+	debugfs_create_file("active", 0600, nsim_dev_linecard->ddir,
+			    nsim_dev_linecard, &nsim_dev_linecard_active_fops);
 	debugfs_create_file("type", 0400, nsim_dev_linecard->ddir,
 			    nsim_dev_linecard, &nsim_dev_linecard_type_fops);
 
-- 
2.26.2

