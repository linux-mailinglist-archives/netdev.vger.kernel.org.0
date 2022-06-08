Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D74E543062
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239076AbiFHMa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239077AbiFHMap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:30:45 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2163125A09C
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 05:30:43 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id c2so26839129edf.5
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 05:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RMIXgENSbS7lfvXaTKmwghh2k71/pRJlrPplAA50aVo=;
        b=uythQQJkTQYdCUmGkI9ZUAsoeVCyb6og7LH90hUiuxkYMmJXOy8rboqK6o9Na2RA+w
         PjXOWk+q/tT0oGxPqqsJuzRHLq78LKYJ9u7mBl3T92guUPkmu0cbNjjwpxdSVs3xLLTO
         50cxMO3eSTqzIPfCakY5qoeB/jJflYpoM8Jf4qkcUq5fs2Q10W9zKtJ1wFYoluOsUITo
         9b8rMbkBk0B2ojN0ptdr0sa+05qkxkMgA/z9OUcv/ya63Xiv5n+uWGY6urhszBXwpnDk
         G90S2ae5dws+Y+8LfZlOTCgQq4F2TMvliepgd+66XW9Mq34dpF16swgjbk+tb1HQdF51
         hzXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RMIXgENSbS7lfvXaTKmwghh2k71/pRJlrPplAA50aVo=;
        b=SmBKMHfvg4mLsdePjtIoDkeLhTG+1L+RCbRyFL+P1h+8O0PlE/mzWR6MLeP0Jl+4a7
         ngZUbMkUnW9PJTAwRWL/WvjFGrQxwpz1QcbUd/f6UKzjyisQBww6iKeqJ4wQzNTwWKp/
         S6BXmltJfIdU1tbTDYcAjjfZ5Pxe7jPtOoAoS0+IufxY3ZiKjO2W2hiFxjW7WUPAFwuk
         T8joFdku1aPz1chRIO7DFP3RM/qtB4/A8zxhoE1QupaqXHaeTu10r6IXEbCMES+d0OaP
         po7XkZLYpOLtJUy+/PXJ6VA3eGsQDhYLk3tKLVsvFb0KHVwiGyQsBT6MdxyKOoRmn1H2
         mkHw==
X-Gm-Message-State: AOAM530Aw5Esqz2eQ3/vlkboF4DRuxYSZHcUM5g6MsHh0QmoybOg7M53
        cw/c+IPUeB4K6herKsS53w2xQARnb2BfXzuu
X-Google-Smtp-Source: ABdhPJz57i+VEi7FawwJYpysEeF8jQW3QA8k0f5PvFHrlNakwUny3POwOqW+Qr1FeR8Pfw4/sz/GRw==
X-Received: by 2002:aa7:ca1a:0:b0:42d:e1b0:2dd2 with SMTP id y26-20020aa7ca1a000000b0042de1b02dd2mr39434533eds.157.1654691441142;
        Wed, 08 Jun 2022 05:30:41 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id o7-20020a50fd87000000b0042dc25fdf5bsm12161687edt.29.2022.06.08.05.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 05:30:40 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, roopa@nvidia.com,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH iproute2-next 06/10] bridge: fdb: add flush [no]dynamic entry matching
Date:   Wed,  8 Jun 2022 15:29:17 +0300
Message-Id: <20220608122921.3962382-7-razor@blackwall.org>
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

Add flush support to match dynamic or non-dynamic (static or permanent)
entries if "no" is prepended respectively. Note that dynamic entries are
defined as fdbs without NUD_NOARP and NUD_PERMANENT set, and non-dynamic
entries are fdbs with NUD_NOARP set (that matches both static and
permanent entries).

Examples:
$ bridge fdb flush dev br0 dynamic
This will delete all dynamic entries in br0's fdb table.

$ bridge fdb flush dev br0 nodynamic
This will delete all entries except the dynamic ones in br0's fdb
table.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 bridge/fdb.c      | 8 +++++++-
 man/man8/bridge.8 | 7 ++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/bridge/fdb.c b/bridge/fdb.c
index 93806d7d35b5..9c1899c167be 100644
--- a/bridge/fdb.c
+++ b/bridge/fdb.c
@@ -46,7 +46,7 @@ static void usage(void)
 		"       bridge fdb get [ to ] LLADDR [ br BRDEV ] { brport | dev } DEV\n"
 		"              [ vlan VID ] [ vni VNI ] [ self ] [ master ] [ dynamic ]\n"
 		"       bridge fdb flush dev DEV [ brport DEV ] [ vlan VID ]\n"
-		"              [ self ] [ master ] [ [no]permanent | [no]static ]\n");
+		"              [ self ] [ master ] [ [no]permanent | [no]static | [no]dynamic ]\n");
 	exit(-1);
 }
 
@@ -706,6 +706,12 @@ static int fdb_flush(int argc, char **argv)
 		} else if (strcmp(*argv, "nostatic") == 0) {
 			ndm_state &= ~NUD_NOARP;
 			ndm_state_mask |= NUD_NOARP;
+		} else if (strcmp(*argv, "dynamic") == 0) {
+			ndm_state &= ~NUD_NOARP | NUD_PERMANENT;
+			ndm_state_mask |= NUD_NOARP | NUD_PERMANENT;
+		} else if (strcmp(*argv, "nodynamic") == 0) {
+			ndm_state |= NUD_NOARP;
+			ndm_state_mask |= NUD_NOARP;
 		} else if (strcmp(*argv, "brport") == 0) {
 			if (port)
 				duparg2("brport", *argv);
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 9e2952b8c6d6..f4b3887a9144 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -121,7 +121,7 @@ bridge \- show / manipulate bridge addresses and devices
 .B vlan
 .IR VID " ] [ "
 .BR self " ] [ " master " ] [ "
-.BR [no]permanent " | " [no]static " ]"
+.BR [no]permanent " | " [no]static " | " [no]dynamic " ]"
 
 .ti -8
 .BR "bridge mdb" " { " add " | " del " } "
@@ -838,6 +838,11 @@ is prepended then only non-permanent entries will be deleted.
 .B [no]static
 if specified then only static entries will be deleted or respectively if "no"
 is prepended then only non-static entries will be deleted.
+
+.TP
+.B [no]dynamic
+if specified then only dynamic entries will be deleted or respectively if "no"
+is prepended then only non-dynamic (static or permanent) entries will be deleted.
 .sp
 
 .SH bridge mdb - multicast group database management
-- 
2.35.1

