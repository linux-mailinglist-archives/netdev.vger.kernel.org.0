Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B54832D32E
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 13:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240859AbhCDMdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 07:33:25 -0500
Received: from mga12.intel.com ([192.55.52.136]:64925 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240790AbhCDMdR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 07:33:17 -0500
IronPort-SDR: v5rkH88SEXvPBlgm7FZvrUbXfWx+wb4bWZZQ9hGgkhCfN0F6Wy3GIjaH2oHw/SVymTkG+Pv/O+
 6y/lY1/EPG6A==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="166662647"
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="166662647"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 04:31:32 -0800
IronPort-SDR: WVxsua+vzA1ipbqiaRRk6YFiLfvoi2lSCGml4HxF5zPGG+EqgWLYJtWjTZqocAPgEFK1pxpS/l
 S9jJKSjHi4+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="435785755"
Received: from black.fi.intel.com ([10.237.72.28])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Mar 2021 04:31:29 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 8418444E; Thu,  4 Mar 2021 14:31:26 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 09/18] thunderbolt: Add tb_property_copy_dir()
Date:   Thu,  4 Mar 2021 15:31:16 +0300
Message-Id: <20210304123125.43630-10-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
References: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function takes a deep copy of the properties. We need this in order
to support more dynamic properties per XDomain connection as required by
the USB4 inter-domain service spec.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/thunderbolt/property.c | 71 ++++++++++++++++++++++++++++++++++
 include/linux/thunderbolt.h    |  1 +
 2 files changed, 72 insertions(+)

diff --git a/drivers/thunderbolt/property.c b/drivers/thunderbolt/property.c
index d5b0cdb8f0b1..dc555cda98e6 100644
--- a/drivers/thunderbolt/property.c
+++ b/drivers/thunderbolt/property.c
@@ -501,6 +501,77 @@ ssize_t tb_property_format_dir(const struct tb_property_dir *dir, u32 *block,
 	return ret < 0 ? ret : 0;
 }
 
+/**
+ * tb_property_copy_dir() - Take a deep copy of directory
+ * @dir: Directory to copy
+ *
+ * This function takes a deep copy of @dir and returns back the copy. In
+ * case of error returns %NULL. The resulting directory needs to be
+ * released by calling tb_property_free_dir().
+ */
+struct tb_property_dir *tb_property_copy_dir(const struct tb_property_dir *dir)
+{
+	struct tb_property *property, *p = NULL;
+	struct tb_property_dir *d;
+
+	if (!dir)
+		return NULL;
+
+	d = tb_property_create_dir(dir->uuid);
+	if (!d)
+		return NULL;
+
+	list_for_each_entry(property, &dir->properties, list) {
+		struct tb_property *p;
+
+		p = tb_property_alloc(property->key, property->type);
+		if (!p)
+			goto err_free;
+
+		p->length = property->length;
+
+		switch (property->type) {
+		case TB_PROPERTY_TYPE_DIRECTORY:
+			p->value.dir = tb_property_copy_dir(property->value.dir);
+			if (!p->value.dir)
+				goto err_free;
+			break;
+
+		case TB_PROPERTY_TYPE_DATA:
+			p->value.data = kmemdup(property->value.data,
+						property->length * 4,
+						GFP_KERNEL);
+			if (!p->value.data)
+				goto err_free;
+			break;
+
+		case TB_PROPERTY_TYPE_TEXT:
+			p->value.text = kzalloc(p->length * 4, GFP_KERNEL);
+			if (!p->value.text)
+				goto err_free;
+			strcpy(p->value.text, property->value.text);
+			break;
+
+		case TB_PROPERTY_TYPE_VALUE:
+			p->value.immediate = property->value.immediate;
+			break;
+
+		default:
+			break;
+		}
+
+		list_add_tail(&p->list, &d->properties);
+	}
+
+	return d;
+
+err_free:
+	kfree(p);
+	tb_property_free_dir(d);
+
+	return NULL;
+}
+
 /**
  * tb_property_add_immediate() - Add immediate property to directory
  * @parent: Directory to add the property
diff --git a/include/linux/thunderbolt.h b/include/linux/thunderbolt.h
index 7ec977161f5c..003a9ad29168 100644
--- a/include/linux/thunderbolt.h
+++ b/include/linux/thunderbolt.h
@@ -146,6 +146,7 @@ struct tb_property_dir *tb_property_parse_dir(const u32 *block,
 					      size_t block_len);
 ssize_t tb_property_format_dir(const struct tb_property_dir *dir, u32 *block,
 			       size_t block_len);
+struct tb_property_dir *tb_property_copy_dir(const struct tb_property_dir *dir);
 struct tb_property_dir *tb_property_create_dir(const uuid_t *uuid);
 void tb_property_free_dir(struct tb_property_dir *dir);
 int tb_property_add_immediate(struct tb_property_dir *parent, const char *key,
-- 
2.30.1

