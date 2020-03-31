Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5914F198EC2
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 10:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730217AbgCaIna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 04:43:30 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59561 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726299AbgCaIn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 04:43:28 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 628665C0475;
        Tue, 31 Mar 2020 04:43:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 31 Mar 2020 04:43:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=i3dVnUb16UOnqhSvwXG1T0HoFeUB/vhBKcKUBKI+oDM=; b=3uribXGc
        HlrZ0/rYyZRfqiOuVjE8QE7k8pgU7tBVL07j+GCr2bwAnOgv21kmEMgDljTldMT3
        JIJPo+bDJho5qxL/fHjABx/BE5kEPkNYU2+sAVzIIXo19kpMRhoSBe/5lX/RKT5P
        sq8dVtdY3hpwXjbLrr+DW8YQ7lhU3QHOirNwL81SsvOtgnfLEdcMP3k/kt7e8gr7
        wbRD9j8i7BwCvHmVYOGnd4VYkvWWjrgRyvUmbFRVdDuszOk/GGSbuIM/bUL0c5ci
        +1dNXFnZcy3U9rKpxsyCtJdeLIco7/EIOs2BY6nAIOWohqS2aXlLDEJr/SW1VgUX
        Qf5teRCKYQqtwg==
X-ME-Sender: <xms:rwKDXoiVgDlh9InZxe1rY04-88cQiykw13_vJpshgJNKu4Mbk0XGcw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeijedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekuddrudefvddrudeludenucevlhhushhtvg
    hrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:rwKDXtXHIo3oDIzq2wswIW8ra42uAjrRsSYfCZKhmSUYw9mYwEVa3A>
    <xmx:rwKDXi19s1RZySRZonZqSaCAbRJBolkaSbjiWg-3hxJbcY8c5JqTow>
    <xmx:rwKDXrFZ8pZAiysB9EqQdRty-gc-06dzwCFYfKWf51reuV6jTAOdag>
    <xmx:rwKDXoCFclcxbi3Cx1zP8OKiV4ukH-B_A-Z3CwL6Q-w3SMOx9DAFcA>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1374C3280063;
        Tue, 31 Mar 2020 04:43:25 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2-next v2 2/3] devlink: Add ability to bind policer to trap group
Date:   Tue, 31 Mar 2020 11:42:52 +0300
Message-Id: <20200331084253.2377588-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200331084253.2377588-1-idosch@idosch.org>
References: <20200331084253.2377588-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Add ability to associate a policer with a trap group. The policer can be
unbound by using the 'nopolicer' keyword. In which case, the value
encoded in the 'DEVLINK_ATTR_TRAP_POLICER_ID' attribute will be '0'.
This is consistent with ip-link 'nomaster' keyword and the 'IFLA_MASTER'
attribute.

Example:

# devlink trap group set netdevsim/netdevsim10 group l3_drops policer 2
# devlink -jp trap group show netdevsim/netdevsim10 group l3_drops
{
    "trap_group": {
        "netdevsim/netdevsim10": [ {
                "name": "l3_drops",
                "generic": true,
                "policer": 2
            } ]
    }
}

# devlink trap group set netdevsim/netdevsim10 group l3_drops nopolicer
# devlink -jp trap group show netdevsim/netdevsim10 group l3_drops
{
    "trap_group": {
        "netdevsim/netdevsim10": [ {
                "name": "l3_drops",
                "generic": true
            } ]
    }
}

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c       | 11 ++++++++++-
 man/man8/devlink-trap.8 | 12 ++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 9380792ad423..6405d4be760f 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -1507,6 +1507,11 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (err)
 				return err;
 			o_found |= DL_OPT_TRAP_POLICER_ID;
+		} else if (dl_argv_match(dl, "nopolicer") &&
+			   (o_all & DL_OPT_TRAP_POLICER_ID)) {
+			dl_arg_inc(dl);
+			opts->trap_policer_id = 0;
+			o_found |= DL_OPT_TRAP_POLICER_ID;
 		} else if (dl_argv_match(dl, "rate") &&
 			   (o_all & DL_OPT_TRAP_POLICER_RATE)) {
 			dl_arg_inc(dl);
@@ -7068,6 +7073,7 @@ static void cmd_trap_help(void)
 	pr_err("Usage: devlink trap set DEV trap TRAP [ action { trap | drop } ]\n");
 	pr_err("       devlink trap show [ DEV trap TRAP ]\n");
 	pr_err("       devlink trap group set DEV group GROUP [ action { trap | drop } ]\n");
+	pr_err("                              [ policer POLICER ] [ nopolicer ]\n");
 	pr_err("       devlink trap group show [ DEV group GROUP ]\n");
 	pr_err("       devlink trap policer set DEV policer POLICER [ rate RATE ] [ burst BURST ]\n");
 	pr_err("       devlink trap policer show DEV policer POLICER\n");
@@ -7125,6 +7131,9 @@ static void pr_out_trap_group(struct dl *dl, struct nlattr **tb, bool array)
 	print_string(PRINT_ANY, "name", "name %s",
 		     mnl_attr_get_str(tb[DEVLINK_ATTR_TRAP_GROUP_NAME]));
 	print_bool(PRINT_ANY, "generic", " generic %s", !!tb[DEVLINK_ATTR_TRAP_GENERIC]);
+	if (tb[DEVLINK_ATTR_TRAP_POLICER_ID])
+		print_uint(PRINT_ANY, "policer", " policer %u",
+			   mnl_attr_get_u32(tb[DEVLINK_ATTR_TRAP_POLICER_ID]));
 	pr_out_stats(dl, tb[DEVLINK_ATTR_STATS]);
 	pr_out_handle_end(dl);
 }
@@ -7181,7 +7190,7 @@ static int cmd_trap_group_set(struct dl *dl)
 
 	err = dl_argv_parse_put(nlh, dl,
 				DL_OPT_HANDLE | DL_OPT_TRAP_GROUP_NAME,
-				DL_OPT_TRAP_ACTION);
+				DL_OPT_TRAP_ACTION | DL_OPT_TRAP_POLICER_ID);
 	if (err)
 		return err;
 
diff --git a/man/man8/devlink-trap.8 b/man/man8/devlink-trap.8
index 113eda4ac790..f01f831759c4 100644
--- a/man/man8/devlink-trap.8
+++ b/man/man8/devlink-trap.8
@@ -37,6 +37,10 @@ devlink-trap \- devlink trap configuration
 .ti -8
 .BI "devlink trap group set " DEV " group " GROUP
 .RB "[ " action " { " trap " | " drop " } ]"
+.br
+.RB "[ " policer
+.IB "POLICER " ]
+.RB "[ " nopolicer " ]"
 
 .ti -8
 .BI "devlink trap policer set " DEV " policer " POLICER
@@ -109,6 +113,14 @@ packet trap action. The action is set for all the packet traps member in the
 trap group. The actions of non-drop traps cannot be changed and are thus
 skipped.
 
+.TP
+.BI policer " POLICER"
+packet trap policer. The policer to bind to the packet trap group.
+
+.TP
+.B nopolicer
+Unbind packet trap policer from the packet trap group.
+
 .SS devlink trap policer set - set attributes of packet trap policer
 
 .PP
-- 
2.24.1

