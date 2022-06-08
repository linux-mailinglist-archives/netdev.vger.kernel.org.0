Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB62543065
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239246AbiFHMbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239091AbiFHMau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:30:50 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A65BF78
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 05:30:45 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id o10so26844085edi.1
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 05:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q/5Fri5VxJYpq4TjJbjEAXubPNUfqRwDqbzms152K4s=;
        b=Bc3OWzx7Q0k91PaWsMLKcAn9fZf6mnlfJQ4lJHI7wKzJ8WfzaC5kzUpghWfJXX2ev5
         mX+4KJwSFnetKckKt5SHJRtdYM96AKTvPG1m2jw01ZdR30wdVnAFv8JrxDUeTQhiv1o+
         Fla1WJoPcEW6ym35Hp+f9nkxjvbflJw0OuIXa74g4CBCywVq1i0MsTaBw64Q6Fe1QZzf
         DjBg9EmlfZMTG4pflQ+P42Nt/FE6YUukIi+eNG3WKmJIsM8h7YQ+/+e3yQtnEm/qEJOB
         qRES5So7Od8RBE44iwj2HLFVNerOSaVjob5Em9oPKa9DYerp1Jy0BAUpRXJIhDpUqUAn
         Aayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q/5Fri5VxJYpq4TjJbjEAXubPNUfqRwDqbzms152K4s=;
        b=u8DMmBzAlVrg+Y6V4tRZhh+bpvmjbtn3MxcZJaGjHyi9KKrmgxzerm5hJvpdwD4o7M
         1tSyWdNg2BKRkmREPAT3dN0tNdE71or6HGXVIHfMhF2SbZEypUubRR6aJUq8Kn4qELtu
         ocxDG17ETHyTPPjp2tvMu5WjtVIdulPAmj9rpF3H0W82bppvLrm4Rv9LuWHm8ttOiV7p
         RQxcdBCiaQ0EWZhXdZ2S0NXesoeILThg/prlvvman5F/q4g0mhark493i0aeItC9istH
         ZOwhjLDXzck7wESAcYz2EWyYkzjQtDNi6sfZwcTM5ixFBkbgbN3diB4HOVL9kas5yGuc
         3aZQ==
X-Gm-Message-State: AOAM533Sa6IKXDAAMHkpNn2c8izNHePYjO5qfrod3mpBFHloY6A8EQ/X
        50VBLFn02qe1Vji1XcFpCQJFoSjEtp1NtNA9
X-Google-Smtp-Source: ABdhPJxG4JF23OzLcJw48QRrKCTbaVY+Jw13yFFZe3AQnKmb8GIIPLwtiJrr3TkK8TaE1wifJMsIqA==
X-Received: by 2002:a05:6402:d:b0:431:98fe:c5fd with SMTP id d13-20020a056402000d00b0043198fec5fdmr6879400edu.170.1654691443440;
        Wed, 08 Jun 2022 05:30:43 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id o7-20020a50fd87000000b0042dc25fdf5bsm12161687edt.29.2022.06.08.05.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 05:30:43 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, roopa@nvidia.com,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH iproute2-next 08/10] bridge: fdb: add flush [no]extern_learn entry matching
Date:   Wed,  8 Jun 2022 15:29:19 +0300
Message-Id: <20220608122921.3962382-9-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220608122921.3962382-1-razor@blackwall.org>
References: <20220608122921.3962382-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add flush support to match entries with or without (if "no" is
prepended) extern_learn flag.

Examples:
$ bridge fdb flush dev br0 extern_learn
This will delete all extern_learn entries in br0's fdb table.

$ bridge fdb flush dev br0 noextern_learn
This will delete all entries except the ones with extern_learn flag in
br0's fdb table.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 bridge/fdb.c      | 8 +++++++-
 man/man8/bridge.8 | 7 ++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/bridge/fdb.c b/bridge/fdb.c
index c57ad235b401..e64e21cb0cba 100644
--- a/bridge/fdb.c
+++ b/bridge/fdb.c
@@ -47,7 +47,7 @@ static void usage(void)
 		"              [ vlan VID ] [ vni VNI ] [ self ] [ master ] [ dynamic ]\n"
 		"       bridge fdb flush dev DEV [ brport DEV ] [ vlan VID ]\n"
 		"              [ self ] [ master ] [ [no]permanent | [no]static | [no]dynamic ]\n"
-		"              [ [no]added_by_user ]\n");
+		"              [ [no]added_by_user ] [ [no]extern_learn ]\n");
 	exit(-1);
 }
 
@@ -720,6 +720,12 @@ static int fdb_flush(int argc, char **argv)
 		} else if (strcmp(*argv, "noadded_by_user") == 0) {
 			ndm_flags &= ~NTF_USE;
 			ndm_flags_mask |= NTF_USE;
+		} else if (strcmp(*argv, "extern_learn") == 0) {
+			ndm_flags |= NTF_EXT_LEARNED;
+			ndm_flags_mask |= NTF_EXT_LEARNED;
+		} else if (strcmp(*argv, "noextern_learn") == 0) {
+			ndm_flags &= ~NTF_EXT_LEARNED;
+			ndm_flags_mask |= NTF_EXT_LEARNED;
 		} else if (strcmp(*argv, "brport") == 0) {
 			if (port)
 				duparg2("brport", *argv);
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index b39c74823606..af343cc1a719 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -122,7 +122,7 @@ bridge \- show / manipulate bridge addresses and devices
 .IR VID " ] [ "
 .BR self " ] [ " master " ] [ "
 .BR [no]permanent " | " [no]static " | " [no]dynamic " ] [ "
-.BR [no]added_by_user " ]"
+.BR [no]added_by_user " ] [ " [no]extern_learn " ]"
 
 .ti -8
 .BR "bridge mdb" " { " add " | " del " } "
@@ -849,6 +849,11 @@ is prepended then only non-dynamic (static or permanent) entries will be deleted
 .B [no]added_by_user
 if specified then only entries with added_by_user flag will be deleted or respectively
 if "no" is prepended then only entries without added_by_user flag will be deleted.
+
+.TP
+.B [no]extern_learn
+if specified then only entries with extern_learn flag will be deleted or respectively
+if "no" is prepended then only entries without extern_learn flag will be deleted.
 .sp
 
 .SH bridge mdb - multicast group database management
-- 
2.35.1

