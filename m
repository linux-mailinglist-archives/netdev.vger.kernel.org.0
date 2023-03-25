Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59E66C8CC5
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 09:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbjCYIp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 04:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232109AbjCYIpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 04:45:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F650136C8;
        Sat, 25 Mar 2023 01:45:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8737260B36;
        Sat, 25 Mar 2023 08:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2ABC433EF;
        Sat, 25 Mar 2023 08:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679733948;
        bh=ddRQKzKXVAQC16CYajgA36u+mWU6j63cgTD9Dxolkms=;
        h=From:To:Cc:Subject:Date:From;
        b=2KjxkXMufWqlDvhQ7gNrJKaRN8VoNXY7bLKuoffEZFoo5XjWi0bgg22gSyOPH6csf
         hqKj/VRwdCfLW1ESeRc2dWvtol0qGr/WcVWEiaWIpDfaGfPBR8deGpZCaLwVPUt9bj
         d9vPuwYg4FSBlcuaEmm3CqdwLCwJfARvJ7djsMJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russ Weight <russell.h.weight@intel.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-cifs@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Subject: [PATCH] driver core: class: mark the struct class for sysfs callbacks as constant
Date:   Sat, 25 Mar 2023 09:45:37 +0100
Message-Id: <20230325084537.3622280-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=16632; i=gregkh@linuxfoundation.org; h=from:subject; bh=ddRQKzKXVAQC16CYajgA36u+mWU6j63cgTD9Dxolkms=; b=owGbwMvMwCRo6H6F97bub03G02pJDClyWzbunJ7Ke+i3RKrJpdIglZ9XdJYv2HR1TvbDqftTX JovZVrs7YhlYRBkYpAVU2T5so3n6P6KQ4pehranYeawMoEMYeDiFICJpOoxLJh1ct3kN+y/Dzz/ ZZHXtyjA0qrCjp9hQcfu0IsFO9aEnDx12CRwz+p3522KnQE=
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct class should never be modified in a sysfs callback as there is
nothing in the structure to modify, and frankly, the structure is almost
never used in a sysfs callback, so mark it as constant to allow struct
class to be moved to read-only memory.

While we are touching all class sysfs callbacks also mark the attribute
as constant as it can not be modified.  The bonding code still uses this
structure so it can not be removed from the function callbacks.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Russ Weight <russell.h.weight@intel.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steve French <sfrench@samba.org>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: linux-cifs@vger.kernel.org
Cc: linux-gpio@vger.kernel.org
Cc: linux-mtd@lists.infradead.org
Cc: linux-rdma@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/dlpar.c    |  4 ++--
 arch/powerpc/platforms/pseries/mobility.c |  4 ++--
 drivers/base/class.c                      |  4 ++--
 drivers/base/devcoredump.c                |  4 ++--
 drivers/base/firmware_loader/sysfs.c      |  4 ++--
 drivers/block/pktcdvd.c                   |  6 +++---
 drivers/block/zram/zram_drv.c             | 11 +++++------
 drivers/gpio/gpiolib-sysfs.c              |  8 ++++----
 drivers/infiniband/core/user_mad.c        |  4 ++--
 drivers/mtd/ubi/build.c                   |  2 +-
 drivers/net/bonding/bond_sysfs.c          | 18 +++++++++---------
 drivers/s390/crypto/zcrypt_api.c          |  8 ++++----
 fs/ksmbd/server.c                         | 10 +++++-----
 include/linux/device/class.h              |  9 +++++----
 14 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
index 75ffdbcd2865..719c97a155ed 100644
--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -512,7 +512,7 @@ static int dlpar_parse_id_type(char **cmd, struct pseries_hp_errorlog *hp_elog)
 	return 0;
 }
 
-static ssize_t dlpar_store(struct class *class, struct class_attribute *attr,
+static ssize_t dlpar_store(const struct class *class, const struct class_attribute *attr,
 			   const char *buf, size_t count)
 {
 	struct pseries_hp_errorlog hp_elog;
@@ -551,7 +551,7 @@ static ssize_t dlpar_store(struct class *class, struct class_attribute *attr,
 	return rc ? rc : count;
 }
 
-static ssize_t dlpar_show(struct class *class, struct class_attribute *attr,
+static ssize_t dlpar_show(const struct class *class, const struct class_attribute *attr,
 			  char *buf)
 {
 	return sprintf(buf, "%s\n", "memory,cpu");
diff --git a/arch/powerpc/platforms/pseries/mobility.c b/arch/powerpc/platforms/pseries/mobility.c
index 643d309d1bd0..6b25642adfa0 100644
--- a/arch/powerpc/platforms/pseries/mobility.c
+++ b/arch/powerpc/platforms/pseries/mobility.c
@@ -787,8 +787,8 @@ int rtas_syscall_dispatch_ibm_suspend_me(u64 handle)
 	return pseries_migrate_partition(handle);
 }
 
-static ssize_t migration_store(struct class *class,
-			       struct class_attribute *attr, const char *buf,
+static ssize_t migration_store(const struct class *class,
+			       const struct class_attribute *attr, const char *buf,
 			       size_t count)
 {
 	u64 streamid;
diff --git a/drivers/base/class.c b/drivers/base/class.c
index 41a6a10da8dd..ecbf8b5b0dff 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -483,8 +483,8 @@ void class_interface_unregister(struct class_interface *class_intf)
 }
 EXPORT_SYMBOL_GPL(class_interface_unregister);
 
-ssize_t show_class_attr_string(struct class *class,
-			       struct class_attribute *attr, char *buf)
+ssize_t show_class_attr_string(const struct class *class,
+			       const struct class_attribute *attr, char *buf)
 {
 	struct class_attribute_string *cs;
 
diff --git a/drivers/base/devcoredump.c b/drivers/base/devcoredump.c
index 59aaf2e1375a..91536ee05f14 100644
--- a/drivers/base/devcoredump.c
+++ b/drivers/base/devcoredump.c
@@ -167,7 +167,7 @@ static int devcd_free(struct device *dev, void *data)
 	return 0;
 }
 
-static ssize_t disabled_show(struct class *class, struct class_attribute *attr,
+static ssize_t disabled_show(const struct class *class, const struct class_attribute *attr,
 			     char *buf)
 {
 	return sysfs_emit(buf, "%d\n", devcd_disabled);
@@ -197,7 +197,7 @@ static ssize_t disabled_show(struct class *class, struct class_attribute *attr,
  * so, above situation would not occur.
  */
 
-static ssize_t disabled_store(struct class *class, struct class_attribute *attr,
+static ssize_t disabled_store(const struct class *class, const struct class_attribute *attr,
 			      const char *buf, size_t count)
 {
 	long tmp = simple_strtol(buf, NULL, 10);
diff --git a/drivers/base/firmware_loader/sysfs.c b/drivers/base/firmware_loader/sysfs.c
index 56911d75b90a..c9c93b47d9a5 100644
--- a/drivers/base/firmware_loader/sysfs.c
+++ b/drivers/base/firmware_loader/sysfs.c
@@ -25,7 +25,7 @@ void __fw_load_abort(struct fw_priv *fw_priv)
 }
 
 #ifdef CONFIG_FW_LOADER_USER_HELPER
-static ssize_t timeout_show(struct class *class, struct class_attribute *attr,
+static ssize_t timeout_show(const struct class *class, const struct class_attribute *attr,
 			    char *buf)
 {
 	return sysfs_emit(buf, "%d\n", __firmware_loading_timeout());
@@ -44,7 +44,7 @@ static ssize_t timeout_show(struct class *class, struct class_attribute *attr,
  *
  *	Note: zero means 'wait forever'.
  **/
-static ssize_t timeout_store(struct class *class, struct class_attribute *attr,
+static ssize_t timeout_store(const struct class *class, const struct class_attribute *attr,
 			     const char *buf, size_t count)
 {
 	int tmp_loading_timeout = simple_strtol(buf, NULL, 10);
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 642e3377441a..ba9bbdef9ef5 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -343,7 +343,7 @@ static void class_pktcdvd_release(struct class *cls)
 	kfree(cls);
 }
 
-static ssize_t device_map_show(struct class *c, struct class_attribute *attr,
+static ssize_t device_map_show(const struct class *c, const struct class_attribute *attr,
 			       char *data)
 {
 	int n = 0;
@@ -364,7 +364,7 @@ static ssize_t device_map_show(struct class *c, struct class_attribute *attr,
 }
 static CLASS_ATTR_RO(device_map);
 
-static ssize_t add_store(struct class *c, struct class_attribute *attr,
+static ssize_t add_store(const struct class *c, const struct class_attribute *attr,
 			 const char *buf, size_t count)
 {
 	unsigned int major, minor;
@@ -385,7 +385,7 @@ static ssize_t add_store(struct class *c, struct class_attribute *attr,
 }
 static CLASS_ATTR_WO(add);
 
-static ssize_t remove_store(struct class *c, struct class_attribute *attr,
+static ssize_t remove_store(const struct class *c, const struct class_attribute *attr,
 			    const char *buf, size_t count)
 {
 	unsigned int major, minor;
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index b7bb52f8dfbd..3feadfb96114 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2424,8 +2424,8 @@ static int zram_remove(struct zram *zram)
  * creates a new un-initialized zram device and returns back this device's
  * device_id (or an error code if it fails to create a new device).
  */
-static ssize_t hot_add_show(struct class *class,
-			struct class_attribute *attr,
+static ssize_t hot_add_show(const struct class *class,
+			const struct class_attribute *attr,
 			char *buf)
 {
 	int ret;
@@ -2438,11 +2438,10 @@ static ssize_t hot_add_show(struct class *class,
 		return ret;
 	return scnprintf(buf, PAGE_SIZE, "%d\n", ret);
 }
-static struct class_attribute class_attr_hot_add =
-	__ATTR(hot_add, 0400, hot_add_show, NULL);
+static CLASS_ATTR_RO(hot_add);
 
-static ssize_t hot_remove_store(struct class *class,
-			struct class_attribute *attr,
+static ssize_t hot_remove_store(const struct class *class,
+			const struct class_attribute *attr,
 			const char *buf,
 			size_t count)
 {
diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
index 774755052618..a895915affa5 100644
--- a/drivers/gpio/gpiolib-sysfs.c
+++ b/drivers/gpio/gpiolib-sysfs.c
@@ -426,8 +426,8 @@ ATTRIBUTE_GROUPS(gpiochip);
  * /sys/class/gpio/unexport ... write-only
  *	integer N ... number of GPIO to unexport
  */
-static ssize_t export_store(struct class *class,
-				struct class_attribute *attr,
+static ssize_t export_store(const struct class *class,
+				const struct class_attribute *attr,
 				const char *buf, size_t len)
 {
 	long			gpio;
@@ -478,8 +478,8 @@ static ssize_t export_store(struct class *class,
 }
 static CLASS_ATTR_WO(export);
 
-static ssize_t unexport_store(struct class *class,
-				struct class_attribute *attr,
+static ssize_t unexport_store(const struct class *class,
+				const struct class_attribute *attr,
 				const char *buf, size_t len)
 {
 	long			gpio;
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index f83954180a33..0e9e04f8c685 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -1229,8 +1229,8 @@ static char *umad_devnode(const struct device *dev, umode_t *mode)
 	return kasprintf(GFP_KERNEL, "infiniband/%s", dev_name(dev));
 }
 
-static ssize_t abi_version_show(struct class *class,
-				struct class_attribute *attr, char *buf)
+static ssize_t abi_version_show(const struct class *class,
+				const struct class_attribute *attr, char *buf)
 {
 	return sysfs_emit(buf, "%d\n", IB_USER_MAD_ABI_VERSION);
 }
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index ae6d35e3da9c..32105bd35831 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -95,7 +95,7 @@ static DEFINE_SPINLOCK(ubi_devices_lock);
 
 /* "Show" method for files in '/<sysfs>/class/ubi/' */
 /* UBI version attribute ('/<sysfs>/class/ubi/version') */
-static ssize_t version_show(struct class *class, struct class_attribute *attr,
+static ssize_t version_show(const struct class *class, const struct class_attribute *attr,
 			    char *buf)
 {
 	return sprintf(buf, "%d\n", UBI_VERSION);
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 8996bd0a194a..0bb59da24922 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -31,12 +31,12 @@
 /* "show" function for the bond_masters attribute.
  * The class parameter is ignored.
  */
-static ssize_t bonding_show_bonds(struct class *cls,
-				  struct class_attribute *attr,
+static ssize_t bonding_show_bonds(const struct class *cls,
+				  const struct class_attribute *attr,
 				  char *buf)
 {
-	struct bond_net *bn =
-		container_of(attr, struct bond_net, class_attr_bonding_masters);
+	const struct bond_net *bn =
+		container_of_const(attr, struct bond_net, class_attr_bonding_masters);
 	int res = 0;
 	struct bonding *bond;
 
@@ -59,7 +59,7 @@ static ssize_t bonding_show_bonds(struct class *cls,
 	return res;
 }
 
-static struct net_device *bond_get_by_name(struct bond_net *bn, const char *ifname)
+static struct net_device *bond_get_by_name(const struct bond_net *bn, const char *ifname)
 {
 	struct bonding *bond;
 
@@ -75,12 +75,12 @@ static struct net_device *bond_get_by_name(struct bond_net *bn, const char *ifna
  *
  * The class parameter is ignored.
  */
-static ssize_t bonding_store_bonds(struct class *cls,
-				   struct class_attribute *attr,
+static ssize_t bonding_store_bonds(const struct class *cls,
+				   const struct class_attribute *attr,
 				   const char *buffer, size_t count)
 {
-	struct bond_net *bn =
-		container_of(attr, struct bond_net, class_attr_bonding_masters);
+	const struct bond_net *bn =
+		container_of_const(attr, struct bond_net, class_attr_bonding_masters);
 	char command[IFNAMSIZ + 1] = {0, };
 	char *ifname;
 	int rv, res = count;
diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index 582ac301d315..cff2eea88f98 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -340,8 +340,8 @@ static const struct attribute_group *zcdn_dev_attr_groups[] = {
 	NULL
 };
 
-static ssize_t zcdn_create_store(struct class *class,
-				 struct class_attribute *attr,
+static ssize_t zcdn_create_store(const struct class *class,
+				 const struct class_attribute *attr,
 				 const char *buf, size_t count)
 {
 	int rc;
@@ -357,8 +357,8 @@ static ssize_t zcdn_create_store(struct class *class,
 static const struct class_attribute class_attr_zcdn_create =
 	__ATTR(create, 0600, NULL, zcdn_create_store);
 
-static ssize_t zcdn_destroy_store(struct class *class,
-				  struct class_attribute *attr,
+static ssize_t zcdn_destroy_store(const struct class *class,
+				  const struct class_attribute *attr,
 				  const char *buf, size_t count)
 {
 	int rc;
diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
index b5af3e43e677..c2c958a5423e 100644
--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -418,7 +418,7 @@ int server_queue_ctrl_reset_work(void)
 	return __queue_ctrl_work(SERVER_CTRL_TYPE_RESET);
 }
 
-static ssize_t stats_show(struct class *class, struct class_attribute *attr,
+static ssize_t stats_show(const struct class *class, const struct class_attribute *attr,
 			  char *buf)
 {
 	/*
@@ -437,8 +437,8 @@ static ssize_t stats_show(struct class *class, struct class_attribute *attr,
 			  server_conf.ipc_last_active / HZ);
 }
 
-static ssize_t kill_server_store(struct class *class,
-				 struct class_attribute *attr, const char *buf,
+static ssize_t kill_server_store(const struct class *class,
+				 const struct class_attribute *attr, const char *buf,
 				 size_t len)
 {
 	if (!sysfs_streq(buf, "hard"))
@@ -458,7 +458,7 @@ static const char * const debug_type_strings[] = {"smb", "auth", "vfs",
 						  "oplock", "ipc", "conn",
 						  "rdma"};
 
-static ssize_t debug_show(struct class *class, struct class_attribute *attr,
+static ssize_t debug_show(const struct class *class, const struct class_attribute *attr,
 			  char *buf)
 {
 	ssize_t sz = 0;
@@ -476,7 +476,7 @@ static ssize_t debug_show(struct class *class, struct class_attribute *attr,
 	return sz;
 }
 
-static ssize_t debug_store(struct class *class, struct class_attribute *attr,
+static ssize_t debug_store(const struct class *class, const struct class_attribute *attr,
 			   const char *buf, size_t len)
 {
 	int i;
diff --git a/include/linux/device/class.h b/include/linux/device/class.h
index 59af129f77e1..9145d35fe65f 100644
--- a/include/linux/device/class.h
+++ b/include/linux/device/class.h
@@ -175,10 +175,10 @@ static inline struct device *class_find_device_by_acpi_dev(const struct class *c
 
 struct class_attribute {
 	struct attribute attr;
-	ssize_t (*show)(struct class *class, struct class_attribute *attr,
+	ssize_t (*show)(const struct class *class, const struct class_attribute *attr,
 			char *buf);
-	ssize_t (*store)(struct class *class, struct class_attribute *attr,
-			const char *buf, size_t count);
+	ssize_t (*store)(const struct class *class, const struct class_attribute *attr,
+			 const char *buf, size_t count);
 };
 
 #define CLASS_ATTR_RW(_name) \
@@ -218,7 +218,8 @@ struct class_attribute_string {
 	struct class_attribute_string class_attr_##_name = \
 		_CLASS_ATTR_STRING(_name, _mode, _str)
 
-ssize_t show_class_attr_string(struct class *class, struct class_attribute *attr, char *buf);
+ssize_t show_class_attr_string(const struct class *class, const struct class_attribute *attr,
+			       char *buf);
 
 struct class_interface {
 	struct list_head	node;
-- 
2.40.0

