Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7281319E664
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 18:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgDDQQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 12:16:30 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42093 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgDDQQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 12:16:29 -0400
Received: by mail-wr1-f65.google.com with SMTP id h15so12248145wrx.9
        for <netdev@vger.kernel.org>; Sat, 04 Apr 2020 09:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hzBRSuwecWXhdox6RvN/89NNmTMJqYQWyijJHwj3vUo=;
        b=wopzOpLi7zn9LQFXV/3xv1x+jbAF4Cq8KlclI5ilZ3/dkYXUeAjkO4L9xB4f7g05Pr
         xn4UYj0I0PgbindbfLxMuqL7UwDPiVNGmrz031SHqQlz9ydY9DDle6h6sh9WN7DC1J6F
         Z8THaAwmMCn7xsDkb4uTC3tcA0QBozqURvugasVFgVsLeyi0ycS7QoG3PsZlrcJP18Vy
         9T/V39H/DDjRYmh97MR26rrqRuGR49nBVVkqDX77XwWKYj4Ta84jExtfB26XomazM/W9
         FQuETiDh36xZyGNfNu/0FwVb3eqXI07kkKvHGJTYv7efOedJc3+L3/brF70zIFE8ffJ/
         gEwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hzBRSuwecWXhdox6RvN/89NNmTMJqYQWyijJHwj3vUo=;
        b=XLPAEkTsYN6MSU8TVxRJ7va9AZB/v0gYe8pFyNHY9HtXwQRiRjqvxa9wGVRtn3RMY8
         a65JUYI74Lbhx8+1OZ91IFaRHUA7VxOSoO84NUtnSc0Mqq4EHJucJIvVlfrA99DSOYS5
         KeeA10EonJFMC8BJ9FgFhsNviZzRY67/PK2ny7tLa0f9JB2WLy24DMCVRkBwltG1XjaQ
         YJAFFQhsTG7MDiZsrbRt/A88XvfFLn1dBd0pr+ohUyaCM3fDHn1jl1ve+KWbpDvyfq3x
         7cXhcKjpurXaW/nH5i0oHc6rixiamAjaz5NLwk2JVXHrQHMlGatoRYBa/yT/v25V2SrA
         U9tw==
X-Gm-Message-State: AGi0Pub0GArzXNLnu8ot0hdaoWkBi7yyw6dkyGCnTxrjMFsC2+F2wvml
        Yh6AjobW9otBTdupUUZzBofVCBbf5Ns=
X-Google-Smtp-Source: APiQypJ4Xpos2IabDbFctoa/WiiZw3xEniyUtYn5bpGCLRtQVUnlaw/WdhbbaahgmjD6zS+t1Y5zTQ==
X-Received: by 2002:adf:90ea:: with SMTP id i97mr14607043wri.123.1586016986771;
        Sat, 04 Apr 2020 09:16:26 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id z11sm1513101wrv.58.2020.04.04.09.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2020 09:16:26 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@mellanox.com
Subject: [patch iproute2/net-next 3/8] devlink: fix encap mode manupulation
Date:   Sat,  4 Apr 2020 18:16:16 +0200
Message-Id: <20200404161621.3452-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200404161621.3452-1-jiri@resnulli.us>
References: <20200404161621.3452-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

DEVLINK_ATTR_ESWITCH_ENCAP_MODE netlink attribute carries enum. But the
code assumes bool value. Fix this by treating the encap mode in the same
way as other eswitch mode attributes, switching from "enable"/"disable"
to "basic"/"none", according to the enum. Maintain the backward
compatibility to allow user to pass "enable"/"disable" too. Also to be
in-sync with the rest of the "mode" commands, rename to "encap-mode".
Adjust the help and man page accordingly.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 bash-completion/devlink |  8 +++----
 devlink/devlink.c       | 46 ++++++++++++++++++++++++++++++-----------
 man/man8/devlink-dev.8  |  8 +++----
 3 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/bash-completion/devlink b/bash-completion/devlink
index 45fba75c1539..73d85d5eafb6 100644
--- a/bash-completion/devlink
+++ b/bash-completion/devlink
@@ -100,11 +100,11 @@ _devlink_dev_eswitch_set()
     local -A settings=(
         [mode]=notseen
         [inline-mode]=notseen
-        [encap]=notseen
+        [encap-mode]=notseen
     )
 
     if [[ $cword -eq 5 ]]; then
-        COMPREPLY=( $( compgen -W "mode inline-mode encap" -- "$cur" ) )
+        COMPREPLY=( $( compgen -W "mode inline-mode encap-mode" -- "$cur" ) )
     fi
 
     # Mark seen settings
@@ -127,8 +127,8 @@ _devlink_dev_eswitch_set()
                 "$cur" ) )
             return
             ;;
-        encap)
-            COMPREPLY=( $( compgen -W "disable enable" -- "$cur" ) )
+        encap-mode)
+            COMPREPLY=( $( compgen -W "none basic" -- "$cur" ) )
             return
             ;;
     esac
diff --git a/devlink/devlink.c b/devlink/devlink.c
index 559b6cec2fae..79a1c3829c31 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -41,6 +41,9 @@
 #define ESWITCH_INLINE_MODE_NETWORK "network"
 #define ESWITCH_INLINE_MODE_TRANSPORT "transport"
 
+#define ESWITCH_ENCAP_MODE_NONE "none"
+#define ESWITCH_ENCAP_MODE_BASIC "basic"
+
 #define PARAM_CMODE_RUNTIME_STR "runtime"
 #define PARAM_CMODE_DRIVERINIT_STR "driverinit"
 #define PARAM_CMODE_PERMANENT_STR "permanent"
@@ -305,7 +308,7 @@ struct dl_opts {
 	enum devlink_eswitch_inline_mode eswitch_inline_mode;
 	const char *dpipe_table_name;
 	bool dpipe_counters_enable;
-	bool eswitch_encap_mode;
+	enum devlink_eswitch_encap_mode eswitch_encap_mode;
 	const char *resource_path;
 	uint64_t resource_size;
 	uint32_t resource_id;
@@ -1091,12 +1094,19 @@ static int eswitch_inline_mode_get(const char *typestr,
 	return 0;
 }
 
-static int eswitch_encap_mode_get(const char *typestr, bool *p_mode)
+static int
+eswitch_encap_mode_get(const char *typestr,
+		       enum devlink_eswitch_encap_mode *p_encap_mode)
 {
-	if (strcmp(typestr, "enable") == 0) {
-		*p_mode = true;
-	} else if (strcmp(typestr, "disable") == 0) {
-		*p_mode = false;
+	/* The initial implementation incorrectly accepted "enable"/"disable".
+	 * Carry it to maintain backward compatibility.
+	 */
+	if (strcmp(typestr, "disable") == 0 ||
+		   strcmp(typestr, ESWITCH_ENCAP_MODE_NONE) == 0) {
+		*p_encap_mode = DEVLINK_ESWITCH_ENCAP_MODE_NONE;
+	} else if (strcmp(typestr, "enable") == 0 ||
+		   strcmp(typestr, ESWITCH_ENCAP_MODE_BASIC) == 0) {
+		*p_encap_mode = DEVLINK_ESWITCH_ENCAP_MODE_BASIC;
 	} else {
 		pr_err("Unknown eswitch encap mode \"%s\"\n", typestr);
 		return -EINVAL;
@@ -1342,7 +1352,8 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (err)
 				return err;
 			o_found |= DL_OPT_DPIPE_TABLE_COUNTERS;
-		} else if (dl_argv_match(dl, "encap") &&
+		} else if ((dl_argv_match(dl, "encap") || /* Original incorrect implementation */
+			    dl_argv_match(dl, "encap-mode")) &&
 			   (o_all & DL_OPT_ESWITCH_ENCAP_MODE)) {
 			const char *typestr;
 
@@ -1678,7 +1689,7 @@ static void cmd_dev_help(void)
 	pr_err("Usage: devlink dev show [ DEV ]\n");
 	pr_err("       devlink dev eswitch set DEV [ mode { legacy | switchdev } ]\n");
 	pr_err("                               [ inline-mode { none | link | network | transport } ]\n");
-	pr_err("                               [ encap { disable | enable } ]\n");
+	pr_err("                               [ encap-mode { none | basic } ]\n");
 	pr_err("       devlink dev eswitch show DEV\n");
 	pr_err("       devlink dev param set DEV name PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
 	pr_err("       devlink dev param show [DEV name PARAMETER]\n");
@@ -2105,6 +2116,18 @@ static const char *eswitch_inline_mode_name(uint32_t mode)
 	}
 }
 
+static const char *eswitch_encap_mode_name(uint32_t mode)
+{
+	switch (mode) {
+	case DEVLINK_ESWITCH_ENCAP_MODE_NONE:
+		return ESWITCH_ENCAP_MODE_NONE;
+	case DEVLINK_ESWITCH_ENCAP_MODE_BASIC:
+		return ESWITCH_ENCAP_MODE_BASIC;
+	default:
+		return "<unknown mode>";
+	}
+}
+
 static void pr_out_eswitch(struct dl *dl, struct nlattr **tb)
 {
 	__pr_out_handle_start(dl, tb, true, false);
@@ -2122,11 +2145,10 @@ static void pr_out_eswitch(struct dl *dl, struct nlattr **tb)
 				     tb[DEVLINK_ATTR_ESWITCH_INLINE_MODE])));
 	}
 	if (tb[DEVLINK_ATTR_ESWITCH_ENCAP_MODE]) {
-		bool encap_mode = !!mnl_attr_get_u8(tb[DEVLINK_ATTR_ESWITCH_ENCAP_MODE]);
-
 		check_indent_newline(dl);
-		print_string(PRINT_ANY, "encap", "encap %s",
-			     encap_mode ? "enable" : "disable");
+		print_string(PRINT_ANY, "encap-mode", "encap-mode %s",
+			     eswitch_encap_mode_name(mnl_attr_get_u8(
+				    tb[DEVLINK_ATTR_ESWITCH_ENCAP_MODE])));
 	}
 
 	pr_out_handle_end(dl);
diff --git a/man/man8/devlink-dev.8 b/man/man8/devlink-dev.8
index 289935dbcac9..ac01bf603a44 100644
--- a/man/man8/devlink-dev.8
+++ b/man/man8/devlink-dev.8
@@ -35,7 +35,7 @@ devlink-dev \- devlink device configuration
 .BR inline-mode " { " none " | " link " | " network " | " transport " } "
 .RI "]"
 .RI "[ "
-.BR encap " { " disable " | " enable " } "
+.BR encap-mode " { " none " | " basic " } "
 .RI "]"
 
 .ti -8
@@ -125,13 +125,13 @@ Some HWs need the VF driver to put part of the packet headers on the TX descript
 - L4 mode
 
 .TP
-.BR encap " { " disable " | " enable " } "
+.BR encap-mode " { " none " | " basic " } "
 Set eswitch encapsulation support
 
-.I disable
+.I none
 - Disable encapsulation support
 
-.I enable
+.I basic
 - Enable encapsulation support
 
 .SS devlink dev param set  - set new value to devlink device configuration parameter
-- 
2.21.1

