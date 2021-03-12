Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB3133956C
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbhCLRsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbhCLRsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 12:48:09 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2C1C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 09:48:09 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id v14so9413804pgq.2
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 09:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=zA5IcSkZdzMYjmL0nkp46xqZGTradm6C/26ke9+ROTc=;
        b=sHhS37enCbITr4e13a5bzfD+2ocyg9Up+N/NVLnfP1Obl37WQI1UH+shBGFKz5RBTK
         3NvOMWt2FMp2/mHWSUKRPjnESFYNE7lTnC2K/JCq4hpbpmtiZ+fS/1/0yla+/ZkNL6u9
         NfudCjGTTcaiOubbSpuaZ/XKEoRsl3yFRLLybzig4X2LWsGJlVAnKCJ9Nyt9lWySZJWO
         Jg+2YXRuoSKoYAFzD7it2NNzl3rQvGtneuUy5FAAjckiqVy6miduKsbsByaZ2CYdcO3K
         AVTgJ7PqzXPHFmwPCtfskwcjUVt4M4uLmhObCRFCMeiD7CpWByizg+dSP5L+cYJzaC9z
         af1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=zA5IcSkZdzMYjmL0nkp46xqZGTradm6C/26ke9+ROTc=;
        b=L8XpQLTju8EGewt/QPX++d+2U2blNfvsLtr17JnNdDWTWRsUfL+RfoJ3U3GeeXc1N1
         JCm6wdbGUo9QiYPUlfq1fur297tzUgM7wioEdR5JUc2KuF704yBfGbGadXKtaHO85hmZ
         Vm92yfqHisB991X30+m1RgOnuA2ElYE97j8R0UuZW/5oX0bcFGGtwvAr1Wh+ee4BmnVT
         XOVuQKqEYAmLkBYtN/7wQyLCfDwKgitjueF9ob7v2ul6Cy5OmZMoKZiGpUCkzJTZCzX2
         5CKhTobVq9deKVVlAkZtqUKG85FIS7P0LYy/bWVsDCSJqbeefCmzyzw9w7iqhqBwZR2m
         8SzA==
X-Gm-Message-State: AOAM533Xecmx2f4/7XcX5nPuRUR4GlwTbVyRQzPt4qbXSIGfP1GxHCV+
        c/QZfpwSVuxvlQJWYA8mJ88=
X-Google-Smtp-Source: ABdhPJwG00D+jLFgJ/qEsdt25hfUTRxllK43dnkAbmuzldqRaPLWMPHP7vsWVnv+BKJE2DS0gH06Rw==
X-Received: by 2002:aa7:956d:0:b029:1f1:5ba6:2a58 with SMTP id x13-20020aa7956d0000b02901f15ba62a58mr13757554pfq.63.1615571289046;
        Fri, 12 Mar 2021 09:48:09 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id r4sm2673156pjl.15.2021.03.12.09.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 09:48:08 -0800 (PST)
Subject: [net-next PATCH 01/10] ethtool: Add common function for filling out
 strings
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
Date:   Fri, 12 Mar 2021 09:48:07 -0800
Message-ID: <161557128762.10304.11532669891222264511.stgit@localhost.localdomain>
In-Reply-To: <161557111604.10304.1798900949114188676.stgit@localhost.localdomain>
References: <161557111604.10304.1798900949114188676.stgit@localhost.localdomain>
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


