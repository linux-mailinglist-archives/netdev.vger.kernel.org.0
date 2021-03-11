Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9632B3369BC
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 02:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhCKBfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 20:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbhCKBfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 20:35:21 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A952AC061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 17:35:21 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id s7so19098326qkg.4
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 17:35:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=9h5JIDXWaMuHtL046jz2eeifrcDZUcEjclder2vbKCw=;
        b=bJqzqKWhqoWa6NNvwAfcvTw7nHfiu76+um6FzbiGsTQnOy7tZ550I813A8ukq69atc
         2u0+3tbja3zfK0gXm9iuOYure2m1l0TIe26JJ5S2Dx1MjCUBbv9xDBGD2l5v8dmN6AD0
         6WEmTK2584gnERQ0h88hIjTT3sLjES9tfE4yxjBueKJuIs+dLNa4/m862ESEr+hK4B91
         fZ6J2mMYJtM1MhsY9O/BHc+4rAKrpAhb+JOTo7K9QJm7+Oh/hRDT6rbm2ZOtxDN9O+m1
         FQpxoox4ifXk1+dyyT0rboyrMDr8F2AXpHEsXH/Js9TIdef0CYbvDqa+A1PXg7hCFgAG
         QTbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=9h5JIDXWaMuHtL046jz2eeifrcDZUcEjclder2vbKCw=;
        b=CNDVVzJD2MSMtCXZk15e7ccOKvDUa1SqWDCjMIaiStLD3ujc8YgLk+kh2Xu5mVb2bz
         GOlbZKXOb9bP4zdzJ8q/vSI2NphexlgLWOZ76JYS+ZIcg9SKQ6+D878WMwqI2q/No0Mr
         sOmRZRh/LAfOqDDS9ZrPtuCyODJyqS9lS5LccFCrfD4Pt7kEUg8JHlzYVMel927FaV61
         2DOLWSEkAOyFIOHs33u4HYwep5B2enx3fRAaNB9roN/Q3eR1uGubdeMmVevHho5NWiAE
         U3uxMhERQiM7GwGbRPMQFTSW4etPr/fPg0wUUAeH7ggIZl1fpgskuck5UaHNKLH28OsT
         x6Mg==
X-Gm-Message-State: AOAM5338WogZ5gcjmGcSVtpsUIrivd0v9hyQMSrt49rGW8FevoPR7Kjr
        tksv88FPx3zpB1LM6FBiOI4=
X-Google-Smtp-Source: ABdhPJxcQI0alljtDMFhQQkSUfxARtssUyRqWAPlDHYhJM3hrVLJop7YeewZjLrwQstRQqCwWJ61Og==
X-Received: by 2002:a05:620a:4445:: with SMTP id w5mr5532438qkp.330.1615426520877;
        Wed, 10 Mar 2021 17:35:20 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id p90sm749923qtd.66.2021.03.10.17.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 17:35:20 -0800 (PST)
Subject: [RFC PATCH 01/10] ethtool: Add common function for filling out
 strings
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        simon.horman@netronome.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        drivers@pensando.io, snelson@pensando.io, netanel@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com, saeedb@amazon.com,
        GR-Linux-NIC-Dev@marvell.com, skalluru@marvell.com,
        rmody@marvell.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, mst@redhat.com,
        jasowang@redhat.com, pv-drivers@vmware.com, doshir@vmware.com,
        alexanderduyck@fb.com
Date:   Wed, 10 Mar 2021 17:35:17 -0800
Message-ID: <161542651749.13546.3959589547085613076.stgit@localhost.localdomain>
In-Reply-To: <161542634192.13546.4185974647834631704.stgit@localhost.localdomain>
References: <161542634192.13546.4185974647834631704.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

Add a function to handle the common pattern of printing a string into the
ethtool strings interface and incrementing the string pointer by the
ETH_GSTRING_LEN. Most of the drivers end up doing this and several have
implemented their own versions of this function so it would make sense to
consolidate on one implementation.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 include/linux/ethtool.h |    9 +++++++++
 net/ethtool/ioctl.c     |   12 ++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index ec4cd3921c67..0493f13b2b20 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -571,4 +571,13 @@ struct ethtool_phy_ops {
  */
 void ethtool_set_ethtool_phy_ops(const struct ethtool_phy_ops *ops);
 
+/**
+ * ethtool_gsprintf - Write formatted string to ethtool string data
+ * @data: Pointer to start of string to update
+ * @fmt: Format of string to write
+ *
+ * Write formatted string to data. Update data to point at start of
+ * next string.
+ */
+extern __printf(2, 3) void ethtool_gsprintf(u8 **data, const char *fmt, ...);
 #endif /* _LINUX_ETHTOOL_H */
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 24783b71c584..44ac73780b6e 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1844,6 +1844,18 @@ static int ethtool_get_strings(struct net_device *dev, void __user *useraddr)
 	return ret;
 }
 
+__printf(2, 3) void ethtool_gsprintf(u8 **data, const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	vsnprintf(*data, ETH_GSTRING_LEN, fmt, args);
+	va_end(args);
+
+	*data += ETH_GSTRING_LEN;
+}
+EXPORT_SYMBOL(ethtool_gsprintf);
+
 static int ethtool_phys_id(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_value id;


