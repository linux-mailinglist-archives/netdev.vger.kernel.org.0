Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1776E1F0A8A
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 10:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgFGIhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 04:37:23 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35043 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726441AbgFGIhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 04:37:22 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 84DFC5C00A9;
        Sun,  7 Jun 2020 04:37:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 07 Jun 2020 04:37:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=vMTDaeJEGGAu8iz90ds8HTgXeZX7paLMeNqHUgPoRrI=; b=NJdtp7xN
        aPUk0N5D3AoaXnJoV2MQnkxT4nG+GWhNO+nRMGLeKVyi6OpK5O/peExV5CX5Y72+
        5lRkagKv7O87OMNxNyx9a+PQavbUZVh6C61XV/3VC1/AFnUNCADO08WOsi5iKQku
        ncS0PKXGpbeP/FWGZJaHSWNqCO+HbyAMMYCU4R8ePPLulc0ZlA2W3VHo1xR8mcYa
        ttXJOgDCJQRQ1vfKseULFRVfBLbZgsuEoiYpqQKKtZEPlb2x7rl+SXgIQJmH0dDZ
        fFqC1BF1W5GA1adb3a18uLCAhRVH/W6xp/lYME4UzVL7bm3xWD80pr4ul3kcpbKH
        gcRa/exZPT/LOg==
X-ME-Sender: <xms:QafcXsoN3syoAOY5EC-vAS-l1k0MksOz1GtQXX5YUF4a0MdIoyQzeA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudegledgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejkedrgeehrddvvdef
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:QafcXip3HeXO7TbPOC9TID0vdNNirh3sJ8kHcstVgAXDL7iMQ-jm0Q>
    <xmx:QafcXhPRs0ToIXaRG9aE17grjej-8YxjG1Jmx-LLYRDYbvPmFVerTg>
    <xmx:QafcXj6DzkqaJCFJR7DxSx0oq5bimaKwv_0elmaHswLQ1bEbNL6xrA>
    <xmx:QafcXlR4b31WL9wdCN8znsCMo9RNSy02hwE1Klfi842kUy9sYkDLOA>
Received: from splinter.mtl.com (bzq-79-178-45-223.red.bezeqint.net [79.178.45.223])
        by mail.messagingengine.com (Postfix) with ESMTPA id 45DCE328005A;
        Sun,  7 Jun 2020 04:37:20 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2 2/2] devlink: Add 'mirror' trap action
Date:   Sun,  7 Jun 2020 11:36:47 +0300
Message-Id: <20200607083647.2022510-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200607083647.2022510-1-idosch@idosch.org>
References: <20200607083647.2022510-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Allow setting 'mirror' trap action for traps that support it. Extend the
devlink-trap man page and bash completion accordingly.

Example:

# devlink -jp trap show netdevsim/netdevsim10 trap igmp_query
{
    "trap": {
        "netdevsim/netdevsim10": [ {
                "name": "igmp_query",
                "type": "control",
                "generic": true,
                "action": "mirror",
                "group": "mc_snooping"
            } ]
    }
}

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 bash-completion/devlink |  4 ++--
 devlink/devlink.c       |  8 ++++++--
 man/man8/devlink-trap.8 | 11 +++++++----
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/bash-completion/devlink b/bash-completion/devlink
index 8518e7aa35e8..f710c888652e 100644
--- a/bash-completion/devlink
+++ b/bash-completion/devlink
@@ -678,7 +678,7 @@ _devlink_trap_set_action()
             COMPREPLY=( $( compgen -W "action" -- "$cur" ) )
             ;;
         $((7 + $i)))
-            COMPREPLY=( $( compgen -W "trap drop" -- "$cur" ) )
+            COMPREPLY=( $( compgen -W "trap drop mirror" -- "$cur" ) )
             ;;
     esac
 }
@@ -708,7 +708,7 @@ _devlink_trap_group_set()
 
     case $prev in
         action)
-            COMPREPLY=( $( compgen -W "trap drop" -- "$cur" ) )
+            COMPREPLY=( $( compgen -W "trap drop mirror" -- "$cur" ) )
             return
             ;;
         policer)
diff --git a/devlink/devlink.c b/devlink/devlink.c
index f06e7c2a0a29..2cf2dcca91bb 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -1149,6 +1149,8 @@ static int trap_action_get(const char *actionstr,
 		*p_action = DEVLINK_TRAP_ACTION_DROP;
 	} else if (strcmp(actionstr, "trap") == 0) {
 		*p_action = DEVLINK_TRAP_ACTION_TRAP;
+	} else if (strcmp(actionstr, "mirror") == 0) {
+		*p_action = DEVLINK_TRAP_ACTION_MIRROR;
 	} else {
 		pr_err("Unknown trap action \"%s\"\n", actionstr);
 		return -EINVAL;
@@ -7087,6 +7089,8 @@ static const char *trap_action_name(uint8_t action)
 		return "drop";
 	case DEVLINK_TRAP_ACTION_TRAP:
 		return "trap";
+	case DEVLINK_TRAP_ACTION_MIRROR:
+		return "mirror";
 	default:
 		return "<unknown action>";
 	}
@@ -7161,9 +7165,9 @@ static int cmd_trap_show_cb(const struct nlmsghdr *nlh, void *data)
 
 static void cmd_trap_help(void)
 {
-	pr_err("Usage: devlink trap set DEV trap TRAP [ action { trap | drop } ]\n");
+	pr_err("Usage: devlink trap set DEV trap TRAP [ action { trap | drop | mirror } ]\n");
 	pr_err("       devlink trap show [ DEV trap TRAP ]\n");
-	pr_err("       devlink trap group set DEV group GROUP [ action { trap | drop } ]\n");
+	pr_err("       devlink trap group set DEV group GROUP [ action { trap | drop | mirror } ]\n");
 	pr_err("                              [ policer POLICER ] [ nopolicer ]\n");
 	pr_err("       devlink trap group show [ DEV group GROUP ]\n");
 	pr_err("       devlink trap policer set DEV policer POLICER [ rate RATE ] [ burst BURST ]\n");
diff --git a/man/man8/devlink-trap.8 b/man/man8/devlink-trap.8
index f01f831759c4..1e69342758d5 100644
--- a/man/man8/devlink-trap.8
+++ b/man/man8/devlink-trap.8
@@ -26,7 +26,7 @@ devlink-trap \- devlink trap configuration
 
 .ti -8
 .BI "devlink trap set " DEV " trap " TRAP
-.RB "[ " action " { " trap " | " drop " } ]"
+.RB "[ " action " { " trap " | " drop " | " mirror " } ]"
 
 .ti -8
 .B "devlink trap group show"
@@ -36,7 +36,7 @@ devlink-trap \- devlink trap configuration
 
 .ti -8
 .BI "devlink trap group set " DEV " group " GROUP
-.RB "[ " action " { " trap " | " drop " } ]"
+.RB "[ " action " { " trap " | " drop " | " mirror " } ]"
 .br
 .RB "[ " policer
 .IB "POLICER " ]
@@ -76,7 +76,7 @@ Only applicable if a devlink device is also specified.
 - specifies the packet trap.
 
 .TP
-.BR action " { " trap " | " drop " } "
+.BR action " { " trap " | " drop " | " mirror " } "
 packet trap action.
 
 .I trap
@@ -85,6 +85,9 @@ packet trap action.
 .I drop
 - the packet is dropped by the underlying device and a copy is not sent to the CPU.
 
+.I mirror
+- the packet is forwarded by the underlying device and a copy is sent to the CPU.
+
 .SS devlink trap group show - display available packet trap groups and their attributes
 
 .PP
@@ -108,7 +111,7 @@ Only applicable if a devlink device is also specified.
 - specifies the packet trap group.
 
 .TP
-.BR action " { " trap " | " drop " } "
+.BR action " { " trap " | " drop " | " mirror " } "
 packet trap action. The action is set for all the packet traps member in the
 trap group. The actions of non-drop traps cannot be changed and are thus
 skipped.
-- 
2.26.2

