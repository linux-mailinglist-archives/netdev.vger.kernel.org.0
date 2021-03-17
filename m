Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41EFD33E2B3
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhCQAbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbhCQAav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 20:30:51 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8041BC06175F
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 17:30:40 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id b130so37241620qkc.10
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 17:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=zA5IcSkZdzMYjmL0nkp46xqZGTradm6C/26ke9+ROTc=;
        b=TpLoEjdNa97hWFKfqofPTdN001mZvlLvJEb9AGWHDzNqKHRH5Asbyb1wnUMS0Qh/QD
         rShQiIiMBtMHkHMhvQ8KLkIRZ525HAx/fO6TOLi9y4g6F00DnZM12OpmUtuzP57sx6RO
         r7gV0iiDbE6R4m7h6AeWl8ch2ovMZWV1RttwghvVz153EZ541qxskwZ5oZKF8dB8exuA
         uTpjRdSOfqYx4SJ14UnX6z1+smrmiKC/Aq87unUek6xQvrdTbncG6Z92V1LaDYMxao9i
         awTRXg2wUxMJUz08CQmK6tcf0wl2yQCqUlgKOja23nqLIqW5nClAhb54xxQjrUqcEysj
         FX4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=zA5IcSkZdzMYjmL0nkp46xqZGTradm6C/26ke9+ROTc=;
        b=uByLaUpcO43VdE3zkz3wDRZEf6m9l3dGkuMb8bx3coy0V9YB2/Y0C/3DQdCOs8EhxP
         APUAipZLkaoILzZxEwfl/uSL7oBqk5wnfd6gbDkbie3wl75Y5I03EU3gSnXKy78J0Lzn
         IczRdr0VzNVzGUcwUrB3ahRWuVU2GOLt72sFllh9SCxkhsfOkgIThi9vUzsPvIokbUgm
         X45+SQHo5rEXGWyxOL6+W85J3KTuSkE7KuCQgdESpkFQszol1Mc4j4i4wferlC7WAll9
         hiA3/0LN/weZp0gsQG7nYugEZ389+pPFylvMBAxGOo3Quu4xvOm+onnTmreeMVKNVmLx
         9zLQ==
X-Gm-Message-State: AOAM532dWJi4psIlwmtavCyUP7NbHyTDLOL6o2qOmyGnrX5MCeoOt7jM
        yPzPDg+SLqe5+mMxyBP01oM=
X-Google-Smtp-Source: ABdhPJytZ3Tsacfz9IW64ZwGkAjrYyUIBGH0J6VR40u4Q/xcv0EwU/SgPRPEyBAZtDewReiQjYKqiw==
X-Received: by 2002:a05:620a:214a:: with SMTP id m10mr1973501qkm.372.1615941039723;
        Tue, 16 Mar 2021 17:30:39 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id f27sm15805825qkh.118.2021.03.16.17.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 17:30:39 -0700 (PDT)
Subject: [net-next PATCH v2 01/10] ethtool: Add common function for filling
 out strings
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
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
        alexanderduyck@fb.com, Kernel-team@fb.com
Date:   Tue, 16 Mar 2021 17:30:36 -0700
Message-ID: <161594103620.5644.13159023537924919629.stgit@localhost.localdomain>
In-Reply-To: <161594093708.5644.11391417312031401152.stgit@localhost.localdomain>
References: <161594093708.5644.11391417312031401152.stgit@localhost.localdomain>
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
index ec4cd3921c67..3583f7fc075c 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -571,4 +571,13 @@ struct ethtool_phy_ops {
  */
 void ethtool_set_ethtool_phy_ops(const struct ethtool_phy_ops *ops);
 
+/**
+ * ethtool_sprintf - Write formatted string to ethtool string data
+ * @data: Pointer to start of string to update
+ * @fmt: Format of string to write
+ *
+ * Write formatted string to data. Update data to point at start of
+ * next string.
+ */
+extern __printf(2, 3) void ethtool_sprintf(u8 **data, const char *fmt, ...);
 #endif /* _LINUX_ETHTOOL_H */
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 24783b71c584..0788cc3b3114 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1844,6 +1844,18 @@ static int ethtool_get_strings(struct net_device *dev, void __user *useraddr)
 	return ret;
 }
 
+__printf(2, 3) void ethtool_sprintf(u8 **data, const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	vsnprintf(*data, ETH_GSTRING_LEN, fmt, args);
+	va_end(args);
+
+	*data += ETH_GSTRING_LEN;
+}
+EXPORT_SYMBOL(ethtool_sprintf);
+
 static int ethtool_phys_id(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_value id;


