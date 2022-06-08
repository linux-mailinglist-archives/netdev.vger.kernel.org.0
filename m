Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8567543063
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239238AbiFHMbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239172AbiFHMau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:30:50 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136F525BFA1
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 05:30:46 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id v25so26875635eda.6
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 05:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mw+TeLN00urjm5eSG5gWepTM2y3SQReXF09d+sH2RpI=;
        b=pF6zGpn0hiNgwNbZmYFIjRtiR+LxGEunDpOS3rjx/K59qsHvLy1EVFnrjw7OGgCIKO
         S7GyUQvbKsVo9/oDsL77cI+ymN5XcLWXzolZgwEF4h4prsW+P4rr2NqxH0Vitjb2gtMb
         6jEVc8pXrEx16ajRW90dsZ3lhjuSFg6Xql3y9v9Swja0K56rjZJFFU+WwwTn/Q/DQW3N
         tAW6IVm0Io7TGXCeDH1WCgiMl4poZ7JFwrMg7XxmzWLCkgIkrQYLup6bKslQGEmWzIdv
         MC6ekCg8GRgoUOt2sZltVebWBzAjGwoefYQw8AUBLmvSLoCIrMXfJc2J7sZLf1ADxV5k
         M4eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mw+TeLN00urjm5eSG5gWepTM2y3SQReXF09d+sH2RpI=;
        b=ExIO9E5N+8rmZF/qZIxAV0IWSD2xhuhdOE6LXKHRFYXv5iCC4iqUNYpWkBzKe8i79Z
         6D2Zb16I3942q/9wqjt9pn1TDb25+kMCTBnHNoogGnbjOd8hH5IVKnzyOOQF4J4lQ3Y4
         eO4rZ6M05xbTRIT433kRGTZ6IkZdUaXePh/UWTKGZXn/ggI7WxPCQDzu8yBf7745dMEN
         fpUeoaUei45FhwKt3zIJwS6iNxaUZzh1AHcHrASpd4ITT5EpPsaeMa7PsfeK5ayA7xDZ
         Qi2Nx0fwjNYeEtD5Mec8NWHPo+dhvsjJK2hD+P/0TBzzwuVnUwz5Aeevq56Khp+04EQJ
         cyQA==
X-Gm-Message-State: AOAM531k4LWc9fDHxcotHx51oVnB8Bvpks0kKzkN80XDHk8NbiGAG+xC
        Qz8d3SmUV+Fhz9IByH752h1ntv/3Q5IfY5IO
X-Google-Smtp-Source: ABdhPJw9Ya7MMGIXglzptt8zufwuQ7Us73YZ1Ih9Y0JZK/Rt7HBgLvGI+VyWywVO208zutU5Ch3KpQ==
X-Received: by 2002:a05:6402:4309:b0:42f:9ff8:3f11 with SMTP id m9-20020a056402430900b0042f9ff83f11mr29741084edc.67.1654691445095;
        Wed, 08 Jun 2022 05:30:45 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id o7-20020a50fd87000000b0042dc25fdf5bsm12161687edt.29.2022.06.08.05.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 05:30:44 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, roopa@nvidia.com,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH iproute2-next 09/10] bridge: fdb: add flush [no]sticky entry matching
Date:   Wed,  8 Jun 2022 15:29:20 +0300
Message-Id: <20220608122921.3962382-10-razor@blackwall.org>
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
prepended) sticky flag.

Examples:
$ bridge fdb flush dev br0 sticky
This will delete all sticky entries in br0's fdb table.

$ bridge fdb flush dev br0 nosticky
This will delete all entries except the ones with sticky flag in
br0's fdb table.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 bridge/fdb.c      | 8 +++++++-
 man/man8/bridge.8 | 8 +++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/bridge/fdb.c b/bridge/fdb.c
index e64e21cb0cba..d268e702d257 100644
--- a/bridge/fdb.c
+++ b/bridge/fdb.c
@@ -47,7 +47,7 @@ static void usage(void)
 		"              [ vlan VID ] [ vni VNI ] [ self ] [ master ] [ dynamic ]\n"
 		"       bridge fdb flush dev DEV [ brport DEV ] [ vlan VID ]\n"
 		"              [ self ] [ master ] [ [no]permanent | [no]static | [no]dynamic ]\n"
-		"              [ [no]added_by_user ] [ [no]extern_learn ]\n");
+		"              [ [no]added_by_user ] [ [no]extern_learn ] [ [no]sticky ]\n");
 	exit(-1);
 }
 
@@ -726,6 +726,12 @@ static int fdb_flush(int argc, char **argv)
 		} else if (strcmp(*argv, "noextern_learn") == 0) {
 			ndm_flags &= ~NTF_EXT_LEARNED;
 			ndm_flags_mask |= NTF_EXT_LEARNED;
+		} else if (strcmp(*argv, "sticky") == 0) {
+			ndm_flags |= NTF_STICKY;
+			ndm_flags_mask |= NTF_STICKY;
+		} else if (strcmp(*argv, "nosticky") == 0) {
+			ndm_flags &= ~NTF_STICKY;
+			ndm_flags_mask |= NTF_STICKY;
 		} else if (strcmp(*argv, "brport") == 0) {
 			if (port)
 				duparg2("brport", *argv);
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index af343cc1a719..ad16b4fe0940 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -122,7 +122,8 @@ bridge \- show / manipulate bridge addresses and devices
 .IR VID " ] [ "
 .BR self " ] [ " master " ] [ "
 .BR [no]permanent " | " [no]static " | " [no]dynamic " ] [ "
-.BR [no]added_by_user " ] [ " [no]extern_learn " ]"
+.BR [no]added_by_user " ] [ " [no]extern_learn " ] [ "
+.BR [no]sticky " ]"
 
 .ti -8
 .BR "bridge mdb" " { " add " | " del " } "
@@ -854,6 +855,11 @@ if "no" is prepended then only entries without added_by_user flag will be delete
 .B [no]extern_learn
 if specified then only entries with extern_learn flag will be deleted or respectively
 if "no" is prepended then only entries without extern_learn flag will be deleted.
+
+.TP
+.B [no]sticky
+if specified then only entries with sticky flag will be deleted or respectively
+if "no" is prepended then only entries without sticky flag will be deleted.
 .sp
 
 .SH bridge mdb - multicast group database management
-- 
2.35.1

