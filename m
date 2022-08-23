Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DFD59E50C
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 16:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242267AbiHWOTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 10:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242102AbiHWOSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 10:18:54 -0400
X-Greylist: delayed 530 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 23 Aug 2022 04:32:42 PDT
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.187.6.220])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 4F66727C609;
        Tue, 23 Aug 2022 04:32:41 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [218.12.19.15])
        by mail-app2 (Coremail) with SMTP id by_KCgDnqrA5uARjm7mFAw--.5982S3;
        Tue, 23 Aug 2022 19:21:42 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        briannorris@chromium.org
Cc:     johannes@sipsolutions.net, rafael@kernel.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH v8 1/2] devcoredump: add new APIs to support migration of users from old device coredump related APIs
Date:   Tue, 23 Aug 2022 19:21:26 +0800
Message-Id: <9e5b72d4fee30704fbd067342ee69b769931318b.1661252818.git.duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1661252818.git.duoming@zju.edu.cn>
References: <cover.1661252818.git.duoming@zju.edu.cn>
In-Reply-To: <cover.1661252818.git.duoming@zju.edu.cn>
References: <cover.1661252818.git.duoming@zju.edu.cn>
X-CM-TRANSID: by_KCgDnqrA5uARjm7mFAw--.5982S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Xr48KF13XFWxJF4rKw1ftFb_yoW3CF1fpF
        W8Gay5KrWUGrnrWr93Zr47WFy5Gws7Cas3X34Sk347Kan3AwnxKFWDZFyay34Dt3s5AFy8
        GF98Aa4SkryvyF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBE14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
        x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
        A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
        0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
        IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
        Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
        xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
        6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2
        Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
        Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
        IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU4T5dUUUUU
        =
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgULAVZdtbI0NQAUsU
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dev_coredumpv(), dev_coredumpm() and dev_coredumpsg() could not
be used in atomic context, because they call kvasprintf_const() and
kstrdup() with GFP_KERNEL parameter. The process is shown below:

dev_coredumpv(.., gfp_t gfp)
  dev_coredumpm(.., gfp_t gfp)
    dev_set_name
      kobject_set_name_vargs
        kvasprintf_const(GFP_KERNEL, ...); //may sleep
          kstrdup(s, GFP_KERNEL); //may sleep

This patch adds new APIs that remove gfp_t parameter of dev_coredumpv(),
dev_coredumpm() and dev_coredumpsg() in order to show they could not be
used in atomic context.

These new APIs will ultimately replace the dev_coredumpv(), dev_coredumpm()
and dev_coredumpsg() when there are no users of the old APIs.

Fixes: 833c95456a70 ("device coredump: add new device coredump class")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
Changes in v8:
  - add new APIs to prepare migration of users from old device coredump related APIs.

 drivers/base/devcoredump.c  | 116 ++++++++++++++++++++++++++++++++++++
 include/linux/devcoredump.h |  34 +++++++++++
 2 files changed, 150 insertions(+)

diff --git a/drivers/base/devcoredump.c b/drivers/base/devcoredump.c
index f4d794d6bb8..728457b12ce 100644
--- a/drivers/base/devcoredump.c
+++ b/drivers/base/devcoredump.c
@@ -185,6 +185,21 @@ void dev_coredumpv(struct device *dev, void *data, size_t datalen,
 }
 EXPORT_SYMBOL_GPL(dev_coredumpv);
 
+/**
+ * dev_core_dumpv - create device coredump with vmalloc data
+ * @dev: the struct device for the crashed device
+ * @data: vmalloc data containing the device coredump
+ * @datalen: length of the data
+ *
+ * This function takes ownership of the vmalloc'ed data and will free
+ * it when it is no longer used. See dev_core_dumpm() for more information.
+ */
+void dev_core_dumpv(struct device *dev, void *data, size_t datalen)
+{
+	dev_core_dumpm(dev, NULL, data, datalen, devcd_readv, devcd_freev);
+}
+EXPORT_SYMBOL_GPL(dev_core_dumpv);
+
 static int devcd_match_failing(struct device *dev, const void *failing)
 {
 	struct devcd_entry *devcd = dev_to_devcd(dev);
@@ -312,6 +327,87 @@ void dev_coredumpm(struct device *dev, struct module *owner,
 }
 EXPORT_SYMBOL_GPL(dev_coredumpm);
 
+/**
+ * dev_core_dumpm - create device coredump with read/free methods
+ * @dev: the struct device for the crashed device
+ * @owner: the module that contains the read/free functions, use %THIS_MODULE
+ * @data: data cookie for the @read/@free functions
+ * @datalen: length of the data
+ * @read: function to read from the given buffer
+ * @free: function to free the given buffer
+ *
+ * Creates a new device coredump for the given device. If a previous one hasn't
+ * been read yet, the new coredump is discarded. The data lifetime is determined
+ * by the device coredump framework and when it is no longer needed the @free
+ * function will be called to free the data.
+ */
+void dev_core_dumpm(struct device *dev, struct module *owner,
+		    void *data, size_t datalen,
+		    ssize_t (*read)(char *buffer, loff_t offset, size_t count,
+				    void *data, size_t datalen),
+		    void (*free)(void *data))
+{
+	static atomic_t devcd_count = ATOMIC_INIT(0);
+	struct devcd_entry *devcd;
+	struct device *existing;
+
+	if (devcd_disabled)
+		goto free;
+
+	existing = class_find_device(&devcd_class, NULL, dev,
+				     devcd_match_failing);
+	if (existing) {
+		put_device(existing);
+		goto free;
+	}
+
+	if (!try_module_get(owner))
+		goto free;
+
+	devcd = kzalloc(sizeof(*devcd), GFP_KERNEL);
+	if (!devcd)
+		goto put_module;
+
+	devcd->owner = owner;
+	devcd->data = data;
+	devcd->datalen = datalen;
+	devcd->read = read;
+	devcd->free = free;
+	devcd->failing_dev = get_device(dev);
+
+	device_initialize(&devcd->devcd_dev);
+
+	dev_set_name(&devcd->devcd_dev, "devcd%d",
+		     atomic_inc_return(&devcd_count));
+	devcd->devcd_dev.class = &devcd_class;
+
+	if (device_add(&devcd->devcd_dev))
+		goto put_device;
+
+	/*
+	 * These should normally not fail, but there is no problem
+	 * continuing without the links, so just warn instead of
+	 * failing.
+	 */
+	if (sysfs_create_link(&devcd->devcd_dev.kobj, &dev->kobj,
+			      "failing_device") ||
+	    sysfs_create_link(&dev->kobj, &devcd->devcd_dev.kobj,
+			      "devcoredump"))
+		dev_warn(dev, "devcoredump create_link failed\n");
+
+	INIT_DELAYED_WORK(&devcd->del_wk, devcd_del);
+	schedule_delayed_work(&devcd->del_wk, DEVCD_TIMEOUT);
+
+	return;
+ put_device:
+	put_device(&devcd->devcd_dev);
+ put_module:
+	module_put(owner);
+ free:
+	free(data);
+}
+EXPORT_SYMBOL_GPL(dev_core_dumpm);
+
 /**
  * dev_coredumpsg - create device coredump that uses scatterlist as data
  * parameter
@@ -333,6 +429,26 @@ void dev_coredumpsg(struct device *dev, struct scatterlist *table,
 }
 EXPORT_SYMBOL_GPL(dev_coredumpsg);
 
+/**
+ * dev_core_dumpsg - create device coredump that uses scatterlist as data
+ * parameter
+ * @dev: the struct device for the crashed device
+ * @table: the dump data
+ * @datalen: length of the data
+ *
+ * Creates a new device coredump for the given device. If a previous one hasn't
+ * been read yet, the new coredump is discarded. The data lifetime is determined
+ * by the device coredump framework and when it is no longer needed
+ * it will free the data.
+ */
+void dev_core_dumpsg(struct device *dev, struct scatterlist *table,
+		     size_t datalen)
+{
+	dev_core_dumpm(dev, NULL, table, datalen, devcd_read_from_sgtable,
+		       devcd_free_sgtable);
+}
+EXPORT_SYMBOL_GPL(dev_core_dumpsg);
+
 static int __init devcoredump_init(void)
 {
 	return class_register(&devcd_class);
diff --git a/include/linux/devcoredump.h b/include/linux/devcoredump.h
index c008169ed2c..113fe63800a 100644
--- a/include/linux/devcoredump.h
+++ b/include/linux/devcoredump.h
@@ -55,14 +55,26 @@ static inline void _devcd_free_sgtable(struct scatterlist *table)
 void dev_coredumpv(struct device *dev, void *data, size_t datalen,
 		   gfp_t gfp);
 
+void dev_core_dumpv(struct device *dev, void *data, size_t datalen);
+
 void dev_coredumpm(struct device *dev, struct module *owner,
 		   void *data, size_t datalen, gfp_t gfp,
 		   ssize_t (*read)(char *buffer, loff_t offset, size_t count,
 				   void *data, size_t datalen),
 		   void (*free)(void *data));
 
+void dev_core_dumpm(struct device *dev, struct module *owner,
+		    void *data, size_t datalen,
+		    ssize_t (*read)(char *buffer, loff_t offset, size_t count,
+				    void *data, size_t datalen),
+		    void (*free)(void *data));
+
 void dev_coredumpsg(struct device *dev, struct scatterlist *table,
 		    size_t datalen, gfp_t gfp);
+
+void dev_core_dumpsg(struct device *dev, struct scatterlist *table,
+		     size_t datalen);
+
 #else
 static inline void dev_coredumpv(struct device *dev, void *data,
 				 size_t datalen, gfp_t gfp)
@@ -70,6 +82,12 @@ static inline void dev_coredumpv(struct device *dev, void *data,
 	vfree(data);
 }
 
+static inline void dev_core_dumpv(struct device *dev, void *data,
+				  size_t datalen)
+{
+	vfree(data);
+}
+
 static inline void
 dev_coredumpm(struct device *dev, struct module *owner,
 	      void *data, size_t datalen, gfp_t gfp,
@@ -80,11 +98,27 @@ dev_coredumpm(struct device *dev, struct module *owner,
 	free(data);
 }
 
+static inline void
+dev_core_dumpm(struct device *dev, struct module *owner,
+	       void *data, size_t datalen,
+	       ssize_t (*read)(char *buffer, loff_t offset, size_t count,
+			       void *data, size_t datalen),
+	       void (*free)(void *data))
+{
+	free(data);
+}
+
 static inline void dev_coredumpsg(struct device *dev, struct scatterlist *table,
 				  size_t datalen, gfp_t gfp)
 {
 	_devcd_free_sgtable(table);
 }
+
+static inline void dev_core_dumpsg(struct device *dev, struct scatterlist *table,
+				   size_t datalen)
+{
+	_devcd_free_sgtable(table);
+}
 #endif /* CONFIG_DEV_COREDUMP */
 
 #endif /* __DEVCOREDUMP_H */
-- 
2.17.1

