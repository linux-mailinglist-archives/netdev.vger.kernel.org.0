Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14F911A2CAF
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 02:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgDIACG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 20:02:06 -0400
Received: from mga17.intel.com ([192.55.52.151]:18010 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbgDIACG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 20:02:06 -0400
IronPort-SDR: N+lPKJc4UBhyCal2dBKnU75kTU+nSfkMIhln8u6J7Refp//scvCMyk7L7MtWkFVxxx7eQliVqM
 eAj4zcBSXAYQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2020 17:02:01 -0700
IronPort-SDR: +ypRmnB5gwAK8bb/tfHXzvqLQ68o9DPvqW5AIryWRX5RYB2yaXmNDSEUwi9NDoq7t5Zq2Or0DO
 EmN+ByjxbHVQ==
X-IronPort-AV: E=Sophos;i="5.72,360,1580803200"; 
   d="scan'208";a="330686210"
Received: from rselimox-mobl.amr.corp.intel.com (HELO ldmartin-desk1) ([10.251.9.202])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2020 17:02:00 -0700
Date:   Wed, 8 Apr 2020 17:02:00 -0700
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jessica Yu <jeyu@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-module@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: RFC: Handle hard module dependencies that are not symbol-based
 (r8169 + realtek)
Message-ID: <20200409000200.2qsqcbrzcztk6gmu@ldmartin-desk1>
X-Patchwork-Hint: ignore
References: <f8e3f271-82df-165f-63f1-6df73ba3d59c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f8e3f271-82df-165f-63f1-6df73ba3d59c@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 01, 2020 at 11:20:20PM +0200, Heiner Kallweit wrote:
>Currently we have no way to express a hard dependency that is not
>a symbol-based dependency (symbol defined in module A is used in
>module B). Use case:
>Network driver ND uses callbacks in the dedicated PHY driver DP
>for the integrated PHY (namely read_page() and write_page() in
>struct phy_driver). If DP can't be loaded (e.g. because ND is in
>initramfs but DP is not), then phylib will use the generic
>PHY driver GP. GP doesn't implement certain callbacks that are
>needed by ND, therefore ND's probe has to bail out with an error
>once it detects that DP is not loaded.
>We have this problem with driver r8169 having such a dependency
>on PHY driver realtek. Some distributions have tools for
>configuring initramfs that consider hard dependencies based on
>depmod output. Means so far somebody can add r8169.ko to initramfs,
>and neither human being nor machine will have an idea that
>realtek.ko needs to be added too.

Could you expand on why softdep doesn't solve this problem
with MODULE_SOFTDEP()

initramfs tools can already read it and modules can already expose them
(they end up in /lib/modules/$(uname -r)/modules.softdep and modprobe
makes use of them)

Lucas De Marchi

>
>Attached patch set (two patches for kmod, one for the kernel)
>allows to express this hard dependency of ND from DP. depmod will
>read this dependency information and treat it like a symbol-based
>dependency. As a result tools e.g. populating initramfs can
>consider the dependency and place DP in initramfs if ND is in
>initramfs. On my system the patch set does the trick when
>adding following line to r8169_main.c:
>MODULE_HARDDEP("realtek");
>
>I'm interested in your opinion on the patches, and whether you
>maybe have a better idea how to solve the problem.
>
>Heiner

>From 290e7dee9f6043d677f08dc06e612e13ee0d2d83 Mon Sep 17 00:00:00 2001
>From: Heiner Kallweit <hkallweit1@gmail.com>
>Date: Tue, 31 Mar 2020 23:02:47 +0200
>Subject: [PATCH 1/2] depmod: add helper mod_add_dep_unique
>
>Create new helper mod_add_dep_unique(), next patch in this series will
>also make use of it.
>
>Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>---
> tools/depmod.c | 26 +++++++++++++++++++-------
> 1 file changed, 19 insertions(+), 7 deletions(-)
>
>diff --git a/tools/depmod.c b/tools/depmod.c
>index 875e314..5419d4d 100644
>--- a/tools/depmod.c
>+++ b/tools/depmod.c
>@@ -907,23 +907,35 @@ static void mod_free(struct mod *mod)
> 	free(mod);
> }
>
>-static int mod_add_dependency(struct mod *mod, struct symbol *sym)
>+static int mod_add_dep_unique(struct mod *mod, struct mod *dep)
> {
> 	int err;
>
>-	DBG("%s depends on %s %s\n", mod->path, sym->name,
>-	    sym->owner != NULL ? sym->owner->path : "(unknown)");
>-
>-	if (sym->owner == NULL)
>+	if (dep == NULL)
> 		return 0;
>
>-	err = array_append_unique(&mod->deps, sym->owner);
>+	err = array_append_unique(&mod->deps, dep);
> 	if (err == -EEXIST)
> 		return 0;
> 	if (err < 0)
> 		return err;
>
>-	sym->owner->users++;
>+	dep->users++;
>+
>+	return 1;
>+}
>+
>+static int mod_add_dependency(struct mod *mod, struct symbol *sym)
>+{
>+	int err;
>+
>+	DBG("%s depends on %s %s\n", mod->path, sym->name,
>+	    sym->owner != NULL ? sym->owner->path : "(unknown)");
>+
>+	err = mod_add_dep_unique(mod, sym->owner);
>+	if (err <= 0)
>+		return err;
>+
> 	SHOW("%s needs \"%s\": %s\n", mod->path, sym->name, sym->owner->path);
> 	return 0;
> }
>-- 
>2.26.0
>

>From b12fa0d85b21d84cdf4509c5048c67e17914eb28 Mon Sep 17 00:00:00 2001
>From: Heiner Kallweit <hkallweit1@gmail.com>
>Date: Mon, 30 Mar 2020 17:12:44 +0200
>Subject: [PATCH] module: add MODULE_HARDDEP
>
>Currently we have no way to express a hard dependency that is not a
>symbol-based dependency (symbol defined in module A is used in
>module B). Use case:
>Network driver ND uses callbacks in the dedicated PHY driver DP
>for the integrated PHY. If DP can't be loaded (e.g. because ND
>is in initramfs but DP is not), then phylib will load the generic
>PHY driver GP. GP doesn't implement certain callbacks that are
>used by ND, therefore ND's probe has to bail out with an error
>once it detects that DP is not loaded.
>This patch allows to express this hard dependency of ND from DP.
>depmod will read this dependency information and treat it like
>a symbol-based dependency. As a result tools e.g. populating
>initramfs can consider the dependency and place DP in initramfs
>if ND is in initramfs.
>
>Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>---
> include/linux/module.h | 5 +++++
> 1 file changed, 5 insertions(+)
>
>diff --git a/include/linux/module.h b/include/linux/module.h
>index 1ad393e62..f38d4107f 100644
>--- a/include/linux/module.h
>+++ b/include/linux/module.h
>@@ -169,6 +169,11 @@ extern void cleanup_module(void);
>  */
> #define MODULE_SOFTDEP(_softdep) MODULE_INFO(softdep, _softdep)
>
>+/* Hard module dependencies that are not code dependencies
>+ * Example: MODULE_HARDDEP("module-foo module-bar")
>+ */
>+#define MODULE_HARDDEP(_harddep) MODULE_INFO(harddep, _harddep)
>+
> /*
>  * MODULE_FILE is used for generating modules.builtin
>  * So, make it no-op when this is being built as a module
>-- 
>2.26.0
>

>From af3a25833a160e029441eaf5a93f7c8625544296 Mon Sep 17 00:00:00 2001
>From: Heiner Kallweit <hkallweit1@gmail.com>
>Date: Wed, 1 Apr 2020 22:42:55 +0200
>Subject: [PATCH 2/2] depmod: add depmod_load_harddeps
>
>Load explicitly declared hard dependency information from modules and
>add it to the symbol-derived dependencies. This will allow
>depmod-based tools to consider hard dependencies that are not code
>dependencies.
>
>Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>---
> tools/depmod.c | 38 ++++++++++++++++++++++++++++++++++++++
> 1 file changed, 38 insertions(+)
>
>diff --git a/tools/depmod.c b/tools/depmod.c
>index 5419d4d..5771dc9 100644
>--- a/tools/depmod.c
>+++ b/tools/depmod.c
>@@ -1522,6 +1522,41 @@ static struct symbol *depmod_symbol_find(const struct depmod *depmod,
> 	return hash_find(depmod->symbols, name);
> }
>
>+static void depmod_load_harddeps(struct depmod *depmod, struct mod *mod)
>+{
>+
>+	struct kmod_list *l;
>+
>+	kmod_list_foreach(l, mod->info_list) {
>+		const char *key = kmod_module_info_get_key(l);
>+		const char *dep_name;
>+		struct mod *dep;
>+		char *value;
>+
>+		if (!streq(key, "harddep"))
>+			continue;
>+
>+		value = strdup(kmod_module_info_get_value(l));
>+		if (value == NULL)
>+			return;
>+
>+		dep_name = strtok(value, " \t");
>+
>+		while (dep_name) {
>+			dep = hash_find(depmod->modules_by_name, dep_name);
>+			if (dep)
>+				mod_add_dep_unique(mod, dep);
>+			else
>+				WRN("harddep: %s: unknown dependency %s\n",
>+				    mod->modname, dep_name);
>+
>+			dep_name = strtok(NULL, " \t");
>+		}
>+
>+		free(value);
>+	}
>+}
>+
> static int depmod_load_modules(struct depmod *depmod)
> {
> 	struct mod **itr, **itr_end;
>@@ -1569,6 +1604,9 @@ static int depmod_load_module_dependencies(struct depmod *depmod, struct mod *mo
> 	struct kmod_list *l;
>
> 	DBG("do dependencies of %s\n", mod->path);
>+
>+	depmod_load_harddeps(depmod, mod);
>+
> 	kmod_list_foreach(l, mod->dep_sym_list) {
> 		const char *name = kmod_module_dependency_symbol_get_symbol(l);
> 		uint64_t crc = kmod_module_dependency_symbol_get_crc(l);
>-- 
>2.26.0
>

