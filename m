Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80CB23F6E34
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 06:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhHYETb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 00:19:31 -0400
Received: from conuserg-11.nifty.com ([210.131.2.78]:45848 "EHLO
        conuserg-11.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhHYETa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 00:19:30 -0400
X-Greylist: delayed 67844 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Aug 2021 00:19:30 EDT
Received: from localhost.localdomain (133-32-232-101.west.xps.vectant.ne.jp [133.32.232.101]) (authenticated)
        by conuserg-11.nifty.com with ESMTP id 17P4GiCL020114;
        Wed, 25 Aug 2021 13:16:45 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-11.nifty.com 17P4GiCL020114
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1629865005;
        bh=1wLIpiebg99hItGHemsWx98J3K7UeOaCPEUf3e672lI=;
        h=From:To:Cc:Subject:Date:From;
        b=G/4OiGhxHia4g/8G5CnboXu0wY5xACRJsnoAdK2dTPl34riwfFplzi3VHlywh+MAJ
         hKNh+ZS2zIOBG7qOMstqDjKNEO9c3XjkvH0IMPPvag3ZrM1U3F5eYNO1MCNWXhdlL4
         edVaM5S1Bg8xr4Pdi004/VBEYRhOx8xWeGU3Js2RQ8XvsET7Z5J5UhYhVHdCWMwVl7
         WTwU1l/W2ASLag6PijSV2aOgjDUGJ9v/4mqptuNV05Kq57wG60quq4Q+5wpmH505k/
         3F64jEe2OWzEqHuF33ACLjKt619ZKTFyaeQpGJkXFYEM2iirw/M7KzFHdpr9a2HTyf
         2i0P+Md1pa3Pw==
X-Nifty-SrcIP: [133.32.232.101]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     linux-kbuild@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Kalle Valo <kvalo@codeaurora.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] kconfig: forbid symbols that end with '_MODULE'
Date:   Wed, 25 Aug 2021 13:16:37 +0900
Message-Id: <20210825041637.365171-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kconfig (syncconfig) generates include/generated/autoconf.h to make
CONFIG options available to the pre-processor.

The macros are suffixed with '_MODULE' for symbols with the value 'm'.

Here is a conflict; CONFIG_FOO=m results in '#define CONFIG_FOO_MODULE 1',
but CONFIG_FOO_MODULE=y also results in the same define.

fixdep always assumes CONFIG_FOO_MODULE comes from CONFIG_FOO=m, so the
dependency is not properly tracked for symbols that end with '_MODULE'.

This commit makes Kconfig error out if it finds a symbol suffixed with
'_MODULE'. This restriction does not exist if the module feature is not
supported (at least from the Kconfig perspective).

It detected one error:
  error: SND_SOC_DM365_VOICE_CODEC_MODULE: symbol name must not end with '_MODULE'

Rename it to SND_SOC_DM365_VOICE_CODEC_MODULAR. Commit 147162f57515
("ASoC: ti: fix SND_SOC_DM365_VOICE_CODEC dependencies") added it for
internal use. So, this renaming has no impact on users.

Remove a comment from drivers/net/wireless/intel/iwlwifi/Kconfig since
this is a hard error now.

Add a comment to include/linux/kconfig.h in order not to worry observant
developers.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 drivers/net/wireless/intel/iwlwifi/Kconfig |  1 -
 include/linux/kconfig.h                    |  3 ++
 scripts/kconfig/parser.y                   | 40 +++++++++++++++++++++-
 sound/soc/ti/Kconfig                       |  2 +-
 4 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
index 1085afbefba8..5b238243617c 100644
--- a/drivers/net/wireless/intel/iwlwifi/Kconfig
+++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
@@ -70,7 +70,6 @@ config IWLMVM
 	  of the devices that use this firmware is available here:
 	  https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi#firmware
 
-# don't call it _MODULE -- will confuse Kconfig/fixdep/...
 config IWLWIFI_OPMODE_MODULAR
 	bool
 	default y if IWLDVM=m
diff --git a/include/linux/kconfig.h b/include/linux/kconfig.h
index 20d1079e92b4..54f677e742fe 100644
--- a/include/linux/kconfig.h
+++ b/include/linux/kconfig.h
@@ -53,6 +53,9 @@
  * IS_MODULE(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'm', 0
  * otherwise.  CONFIG_FOO=m results in "#define CONFIG_FOO_MODULE 1" in
  * autoconf.h.
+ * CONFIG_FOO_MODULE=y would also result in "#define CONFIG_FOO_MODULE 1",
+ * but Kconfig forbids symbol names that end with '_MODULE', so that would
+ * not happen.
  */
 #define IS_MODULE(option) __is_defined(option##_MODULE)
 
diff --git a/scripts/kconfig/parser.y b/scripts/kconfig/parser.y
index 2af7ce4e1531..b0f73f74ccd3 100644
--- a/scripts/kconfig/parser.y
+++ b/scripts/kconfig/parser.y
@@ -475,6 +475,37 @@ assign_val:
 
 %%
 
+/*
+ * Symbols suffixed with '_MODULE' would cause a macro conflict in autoconf.h,
+ * and also confuse the interaction between syncconfig and fixdep.
+ * Error out if a symbol with the '_MODULE' suffix is found.
+ */
+static int sym_check_name(struct symbol *sym)
+{
+	static const char *suffix = "_MODULE";
+	static const size_t suffix_len = strlen("_MODULE");
+	char *name;
+	size_t len;
+
+	name = sym->name;
+
+	if (!name)
+		return 0;
+
+	len = strlen(name);
+
+	if (len < suffix_len)
+		return 0;
+
+	if (strcmp(name + len - suffix_len, suffix))
+		return 0;
+
+	fprintf(stderr, "error: %s: symbol name must not end with '%s'\n",
+		name, suffix);
+
+	return -1;
+}
+
 void conf_parse(const char *name)
 {
 	struct symbol *sym;
@@ -493,8 +524,15 @@ void conf_parse(const char *name)
 
 	if (yynerrs)
 		exit(1);
-	if (!modules_sym)
+
+	if (modules_sym) {
+		for_all_symbols(i, sym) {
+			if (sym_check_name(sym))
+				yynerrs++;
+		}
+	} else {
 		modules_sym = sym_find( "n" );
+	}
 
 	if (!menu_has_prompt(&rootmenu)) {
 		current_entry = &rootmenu;
diff --git a/sound/soc/ti/Kconfig b/sound/soc/ti/Kconfig
index 698d7bc84dcf..c56a5789056f 100644
--- a/sound/soc/ti/Kconfig
+++ b/sound/soc/ti/Kconfig
@@ -211,7 +211,7 @@ config SND_SOC_DM365_VOICE_CODEC
 	  Say Y if you want to add support for SoC On-chip voice codec
 endchoice
 
-config SND_SOC_DM365_VOICE_CODEC_MODULE
+config SND_SOC_DM365_VOICE_CODEC_MODULAR
 	def_tristate y
 	depends on SND_SOC_DM365_VOICE_CODEC && SND_SOC
 	select MFD_DAVINCI_VOICECODEC
-- 
2.30.2

