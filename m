Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 497FA122896
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 11:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfLQKXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 05:23:10 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:56675 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbfLQKXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 05:23:10 -0500
Received: from orion.localdomain ([95.114.21.161]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1Mm9NA-1hyzXw3sOG-00iFiX; Tue, 17 Dec 2019 11:22:53 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     info@metux.net, linus.walleij@linaro.org,
        bgolaszewski@baylibre.com, dmitry.torokhov@gmail.com,
        jacek.anaszewski@gmail.com, pavel@ucw.cz, dmurphy@ti.com,
        arnd@arndb.de, masahiroy@kernel.org, michal.lkml@markovi.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        linux-gpio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH] RFC: platform driver registering via initcall tables
Date:   Tue, 17 Dec 2019 11:22:19 +0100
Message-Id: <20191217102219.29223-1-info@metux.net>
X-Mailer: git-send-email 2.11.0
X-Provags-ID: V03:K1:q9QRdzq8RyD7WuYmF06+kLn3yB2SAYG/f8x6DXsYucy7ol7pj+H
 GoSwhks22Adw9rjWVn2SvtJgYmZY7MQVv6DnYrKYY//vL+BPhsmi73WCdSOhSQbVMkFIXl5
 eNGgGWK+7T62lrlm9O5XwrY4gJBl76TBB0RZpPIZXHnGfDgkmAAEvXyZu5jxMjaxX8NzXN0
 wzNuJCxLMT3fk9jGyGEaQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:MEBVByY17cE=:ZpSvUigw9Q0VIfkknPktjg
 BFVhRjzAJIpft/EiCUGnUcYUNiwtFYaDxUjfi7eEsNnx55NfwBzt9IXOyaMmXqV7D5z57PCkr
 DhREU+H/vjd8nXDP2tNjP4njZg0vfkaauSdS+CjSwIVj/ReCk3VUaqOiQ85uTafVzWnXL5f2G
 DVCfK2X0pnTy65kIw83HaJIfZZcx4r6wcjsq//zPgt9gFPy1qY9OWGd1IaJvAbdn0zSkmVjJS
 0QwgG1e2CFy8m1nt+lx8OKlMPuCZHJmJvlAklHYyntGdAzC9FgNIsbRUGodATFLIAZLx4SUzz
 Hc9hA/zmjpebZvwUJez9KvzOzm/D3DldiiQrvMzxDlHnGhdqhGFHB24ATxAUkSJPT7vxxhnHg
 THeJV835OoIXuU/J7hHMmxxaCSVGbShj+/4r+KFwJP1w5+YmhOZqujwEvrWtYqNa1aTyNOekG
 eo2G64lPrr8OS+Yat19ud+EFe4iINaRovnnUtHBqiN3T1WGVz+NfleB2LFAHaiEii1bb9aSiI
 K0N3wGqtTj4UHARYkZXkjgBwROPsakEziONBykBvCtbFZ5WuVVgQVr3pD2TskyWW0oNqSxt99
 Yv3k7eODE6dyIo+tsw+mOtktzmttvGPVF2Am82XltcatNFcdlQzqOCAOr9HQCXxCJEU9VZa1T
 8Q9yjqkwYUencbv3dTrm07D+xDClDQUu+/kzvCUYSnPFmWHf3kvhR8Ag7uMG6g4XSxsz8ZbB+
 cPrIGI1lMZKohDBCshgj52E7WqvL7KHGeETLIg5nDujn6tHDFlTgcmO6xXMR6U7uV46s4OWZq
 CqDNKho78Vs+RAUNHF1nW50fuSOuVXTvH+EMRnnS6zl48eV09vDC2jDT1f6j5C72D06pHt4YF
 lH+zexB5L6EggxdwCFcQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A large portion of platform drivers doesn't need their own init/exit
functions. At source level, the boilerplate is already replaced by
module_platform_driver() macro call, which creates this code under
the hood. But in the binary, the code is still there.

This patch is an attempt to remove them it, by the same approach
already used for the init functions: collect pointers to the driver
structs in special sections, which are then processed by the init
code which already calls the init function vectors. For each level,
the structs are processed right after the init funcs, so we guarantee
the existing order, and explicit inits always come before the automatic
registering.

Downside of apprach: cluttering init code w/ a little bit knowledge
about driver related stuff (calls to platform_driver_register(), etc).

For now, only implemented for the built-in case (modules still go the
old route). The module case is a little bit trickier: either we have to
extend the module header (and modpost tool) or do some dynamic symbol
lookup.

This patch is just a PoC for further discussions, not ready for mainline.
It also changes a few drivers, just for illustration. In case the general
approach is accepted, it will be cleaned up and splitted.

2DO:
    * check for potential arch specific issues (-> um ?)
    * implement loadable module case
    * add other driver types (eg. spi, pci, ...)
    * design a practical way for converting drivers step by step
      (or shall we just brutally change module_platform_driver() ?)

Please let me know what you think about this.

happy hacking
--mtx
---
 drivers/gpio/gpio-amd-fch.c               |  3 +--
 drivers/input/keyboard/gpio_keys_polled.c |  2 +-
 drivers/leds/leds-gpio.c                  |  3 +--
 include/asm-generic/vmlinux.lds.h         | 20 ++++++++++++++
 include/linux/init.h                      | 25 ++++++++++++++++++
 include/linux/platform_device.h           |  9 +++++++
 init/main.c                               | 43 +++++++++++++++++++++++++++++++
 scripts/mod/modpost.c                     |  2 +-
 8 files changed, 101 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-amd-fch.c b/drivers/gpio/gpio-amd-fch.c
index 4e44ba4d7423..2542d30258c6 100644
--- a/drivers/gpio/gpio-amd-fch.c
+++ b/drivers/gpio/gpio-amd-fch.c
@@ -183,8 +183,7 @@ static struct platform_driver amd_fch_gpio_driver = {
 	},
 	.probe = amd_fch_gpio_probe,
 };
-
-module_platform_driver(amd_fch_gpio_driver);
+MODULE_PLATFORM_DRIVER(amd_fch_gpio_driver);
 
 MODULE_AUTHOR("Enrico Weigelt, metux IT consult <info@metux.net>");
 MODULE_DESCRIPTION("AMD G-series FCH GPIO driver");
diff --git a/drivers/input/keyboard/gpio_keys_polled.c b/drivers/input/keyboard/gpio_keys_polled.c
index 6eb0a2f3f9de..0c107c11dd1d 100644
--- a/drivers/input/keyboard/gpio_keys_polled.c
+++ b/drivers/input/keyboard/gpio_keys_polled.c
@@ -383,7 +383,7 @@ static struct platform_driver gpio_keys_polled_driver = {
 		.of_match_table = gpio_keys_polled_of_match,
 	},
 };
-module_platform_driver(gpio_keys_polled_driver);
+MODULE_PLATFORM_DRIVER(gpio_keys_polled_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Gabor Juhos <juhosg@openwrt.org>");
diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index a5c73f3d5f79..cf0ef4a9eb79 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -313,8 +313,7 @@ static struct platform_driver gpio_led_driver = {
 		.of_match_table = of_gpio_leds_match,
 	},
 };
-
-module_platform_driver(gpio_led_driver);
+MODULE_PLATFORM_DRIVER(gpio_led_driver);
 
 MODULE_AUTHOR("Raphael Assenat <raph@8d.com>, Trent Piepho <tpiepho@freescale.com>");
 MODULE_DESCRIPTION("GPIO LED driver");
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index e00f41aa8ec4..5956f64db7c6 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -851,6 +851,25 @@
 		INIT_CALLS_LEVEL(7)					\
 		__initcall_end = .;
 
+#define INIT_DRVS_PLAT_LEVEL(level)					\
+		__initdrv_plat##level##_start = .;			\
+		KEEP(*(.initdrv_plat##level##.init))			\
+		KEEP(*(.initdrv_plat##level##s.init))			\
+
+#define INIT_DRVS							\
+		__initdrv_plat_start = .;				\
+		KEEP(*(.initdrv_plat_early.init))			\
+		INIT_DRVS_PLAT_LEVEL(0)					\
+		INIT_DRVS_PLAT_LEVEL(1)					\
+		INIT_DRVS_PLAT_LEVEL(2)					\
+		INIT_DRVS_PLAT_LEVEL(3)					\
+		INIT_DRVS_PLAT_LEVEL(4)					\
+		INIT_DRVS_PLAT_LEVEL(5)					\
+		INIT_DRVS_PLAT_LEVEL(rootfs)				\
+		INIT_DRVS_PLAT_LEVEL(6)					\
+		INIT_DRVS_PLAT_LEVEL(7)					\
+		__initdrv_plat_end = .;
+
 #define CON_INITCALL							\
 		__con_initcall_start = .;				\
 		KEEP(*(.con_initcall.init))				\
@@ -1022,6 +1041,7 @@
 		INIT_DATA						\
 		INIT_SETUP(initsetup_align)				\
 		INIT_CALLS						\
+		INIT_DRVS						\
 		CON_INITCALL						\
 		INIT_RAM_FS						\
 	}
diff --git a/include/linux/init.h b/include/linux/init.h
index 212fc9e2f691..9aa1695bf69c 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -123,6 +123,11 @@ static inline initcall_t initcall_from_entry(initcall_entry_t *entry)
 {
 	return offset_to_ptr(entry);
 }
+
+static inline struct platform_driver *initdrv_plat_from_entry(initcall_entry_t *entry)
+{
+	return offset_to_ptr(entry);
+}
 #else
 typedef initcall_t initcall_entry_t;
 
@@ -130,6 +135,11 @@ static inline initcall_t initcall_from_entry(initcall_entry_t *entry)
 {
 	return *entry;
 }
+
+static inline struct platform_driver *initdrv_plat_from_entry(initcall_entry_t *entry)
+{
+	return *entry;
+}
 #endif
 
 extern initcall_entry_t __con_initcall_start[], __con_initcall_end[];
@@ -191,13 +201,28 @@ extern bool initcall_debug;
 	"__initcall_" #fn #id ":			\n"	\
 	    ".long	" #fn " - .			\n"	\
 	    ".previous					\n");
+
+#define ___define_platform_driver(pd, id, __sec)		\
+	__ADDRESSABLE(pd)					\
+	asm(".section	\"" #__sec ".init\", \"a\"	\n"	\
+	"__plat_drv__" #pd #id ":			\n"	\
+	    ".long	" #pd " - .			\n"	\
+	    ".previous					\n");
+
+
 #else
 #define ___define_initcall(fn, id, __sec) \
 	static initcall_t __initcall_##fn##id __used \
 		__attribute__((__section__(#__sec ".init"))) = fn;
+
+#define ___define_platform_driver(fn, id, __sec) \
+	static initcall_t __initcall_##pd##id __used \
+		__attribute__((__section__(#__sec ".init"))) = fn;
+
 #endif
 
 #define __define_initcall(fn, id) ___define_initcall(fn, id, .initcall##id)
+#define __define_platform_driver(fn, id) ___define_platform_driver(fn, id, .initdrv_plat##id)
 
 /*
  * Early initcalls run before initializing SMP.
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 276a03c24691..3868b0e75f5f 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -244,6 +244,15 @@ static inline void platform_set_drvdata(struct platform_device *pdev,
 	module_driver(__platform_driver, platform_driver_register, \
 			platform_driver_unregister)
 
+#ifdef MODULE
+#define MODULE_PLATFORM_DRIVER(__platform_driver) \
+	module_driver(__platform_driver, platform_driver_register, \
+			platform_driver_unregister)
+#else
+#define MODULE_PLATFORM_DRIVER(__platform_driver) \
+	__define_platform_driver(__platform_driver, 6)
+#endif
+
 /* builtin_platform_driver() - Helper macro for builtin drivers that
  * don't do anything special in driver init.  This eliminates some
  * boilerplate.  Each driver may only use this macro once, and
diff --git a/init/main.c b/init/main.c
index ec3a1463ac69..754b68111b53 100644
--- a/init/main.c
+++ b/init/main.c
@@ -94,6 +94,7 @@
 #include <linux/jump_label.h>
 #include <linux/mem_encrypt.h>
 #include <linux/file.h>
+#include <linux/platform_device.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -955,6 +956,22 @@ int __init_or_module do_one_initcall(initcall_t fn)
 	return ret;
 }
 
+struct platform_driver;
+
+int __init_or_module do_one_initdrv_plat(struct platform_driver *pd)
+{
+	int rc;
+
+	rc = platform_driver_register(pd);
+	if (rc)
+		pr_warn("init: failed registering platform driver: %s: %d\n",
+			pd->driver.name, rc);
+	else
+		pr_info("init: registered platform driver: %s\n",
+			pd->driver.name);
+
+	return rc;
+}
 
 extern initcall_entry_t __initcall_start[];
 extern initcall_entry_t __initcall0_start[];
@@ -979,6 +996,29 @@ static initcall_entry_t *initcall_levels[] __initdata = {
 	__initcall_end,
 };
 
+extern initcall_entry_t __initdrv_plat_start[];
+extern initcall_entry_t __initdrv_plat0_start[];
+extern initcall_entry_t __initdrv_plat1_start[];
+extern initcall_entry_t __initdrv_plat2_start[];
+extern initcall_entry_t __initdrv_plat3_start[];
+extern initcall_entry_t __initdrv_plat4_start[];
+extern initcall_entry_t __initdrv_plat5_start[];
+extern initcall_entry_t __initdrv_plat6_start[];
+extern initcall_entry_t __initdrv_plat7_start[];
+extern initcall_entry_t __initdrv_plat_end[];
+
+static initcall_entry_t *initdrv_plat_levels[] __initdata = {
+	__initdrv_plat0_start,
+	__initdrv_plat1_start,
+	__initdrv_plat2_start,
+	__initdrv_plat3_start,
+	__initdrv_plat4_start,
+	__initdrv_plat5_start,
+	__initdrv_plat6_start,
+	__initdrv_plat7_start,
+	__initdrv_plat_end,
+};
+
 /* Keep these in sync with initcalls in include/linux/init.h */
 static const char *initcall_level_names[] __initdata = {
 	"pure",
@@ -1005,6 +1045,9 @@ static void __init do_initcall_level(int level)
 	trace_initcall_level(initcall_level_names[level]);
 	for (fn = initcall_levels[level]; fn < initcall_levels[level+1]; fn++)
 		do_one_initcall(initcall_from_entry(fn));
+
+	for (fn = initdrv_plat_levels[level]; fn < initdrv_plat_levels[level+1]; fn++)
+		do_one_initdrv_plat(initdrv_plat_from_entry(fn));
 }
 
 static void __init do_initcalls(void)
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 6e892c93d104..7fc8871c4da6 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -957,7 +957,7 @@ static void check_section(const char *modname, struct elf_info *elf,
 #define ALL_INIT_SECTIONS INIT_SECTIONS, ALL_XXXINIT_SECTIONS
 #define ALL_EXIT_SECTIONS EXIT_SECTIONS, ALL_XXXEXIT_SECTIONS
 
-#define DATA_SECTIONS ".data", ".data.rel"
+#define DATA_SECTIONS ".data", ".data.rel", ".data.platdrv"
 #define TEXT_SECTIONS ".text", ".text.unlikely", ".sched.text", \
 		".kprobes.text", ".cpuidle.text"
 #define OTHER_TEXT_SECTIONS ".ref.text", ".head.text", ".spinlock.text", \
-- 
2.11.0

