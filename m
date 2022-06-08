Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB05543064
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239240AbiFHMbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239210AbiFHMau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:30:50 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7058325B059
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 05:30:48 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id h19so26903538edj.0
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 05:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aufacjr97z0R0RcEiapQwUaRj/Widdv+CgCH2LPXq7I=;
        b=WaUuER6DMxWTBMltbxpLxppNMQreWxMpy68AArqzUOc5pqN6KvS/KafB4wxKs+g4u5
         vjLC4OcxhR90rlzN4PrniIJ1bAiLJ6ccPaAZJcQhkINcciYXS6KnE262rb/vvHBCgai+
         eXA0yFq8y+52S1ESnETtSyAEzVJxHeLQKCXtjbtPM0Lh1qWrjyTuc425+j/0JgfNBL/v
         UVktaIJlYcif4Dm2OuJm0RsDycL2U8XNyiuG4SyzUqsAnErWj4UNjWGp7KGTvBoQKglB
         1OQyZV+hhsgkY1mcBAsVen11UlKJbcBlM3M30vH4S2KZlH0sSsMXftmxmq5dIz84hpbI
         BUqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aufacjr97z0R0RcEiapQwUaRj/Widdv+CgCH2LPXq7I=;
        b=g41y2JIZvBoX+vBrsotb9Osw6ipVdOm+mCt0Xp7A0ZMNT6nPa0NGmBmyt18hW+OE7J
         rGK+6nfnyYmBbodOKXe73IxHSufdHlbYV3ZyEgXK2IwGQ6ZWmCxSEVB1Cc5EuuEtOAsW
         4DIOMDRePGmwy6AynHAtc8YzBzs0GXrLm6IGQ1VDuu8MPhPR3psnBCd2k0kcKYVcaAFd
         cCjDMkG+lVXSjCEgKmb7413zqLBxzGcon5iazkWrHclWrWfqYCOYbqFhQLndyUBzPr+Z
         EamS/oU2508S3rtu5sUN91sF939F3VKbSYlM7D9T20IKSTZCTxICJ0Bdp1tx8UNFgzhr
         XIkw==
X-Gm-Message-State: AOAM532nAl2ooeyy355w7+XPlnnjwpZoKDP+OcbRR9rdJJ2djmUuWraW
        dIxB/cFxYA99v9fp4OIQaqzSzO6tmhjLTWJv
X-Google-Smtp-Source: ABdhPJwgwQSOtB2Y6DN9JLUqPaYS6RpRkg5CTrbJE6PVpmjgD3xxnRhVuZZmQj20YfrCKCZqaXb7oA==
X-Received: by 2002:a05:6402:3318:b0:42d:f04b:f50a with SMTP id e24-20020a056402331800b0042df04bf50amr38803401eda.210.1654691446422;
        Wed, 08 Jun 2022 05:30:46 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id o7-20020a50fd87000000b0042dc25fdf5bsm12161687edt.29.2022.06.08.05.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 05:30:45 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, roopa@nvidia.com,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH iproute2-next 10/10] bridge: fdb: add flush [no]offloaded entry matching
Date:   Wed,  8 Jun 2022 15:29:21 +0300
Message-Id: <20220608122921.3962382-11-razor@blackwall.org>
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
prepended) offloaded flag.

Examples:
$ bridge fdb flush dev br0 offloaded
This will delete all offloaded entries in br0's fdb table.

$ bridge fdb flush dev br0 nooffloaded
This will delete all entries except the ones with offloaded flag in
br0's fdb table.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 bridge/fdb.c      | 9 ++++++++-
 man/man8/bridge.8 | 7 ++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/bridge/fdb.c b/bridge/fdb.c
index d268e702d257..b71b20c8b6e6 100644
--- a/bridge/fdb.c
+++ b/bridge/fdb.c
@@ -47,7 +47,8 @@ static void usage(void)
 		"              [ vlan VID ] [ vni VNI ] [ self ] [ master ] [ dynamic ]\n"
 		"       bridge fdb flush dev DEV [ brport DEV ] [ vlan VID ]\n"
 		"              [ self ] [ master ] [ [no]permanent | [no]static | [no]dynamic ]\n"
-		"              [ [no]added_by_user ] [ [no]extern_learn ] [ [no]sticky ]\n");
+		"              [ [no]added_by_user ] [ [no]extern_learn ] [ [no]sticky ]\n"
+		"              [ [no]offloaded ]\n");
 	exit(-1);
 }
 
@@ -732,6 +733,12 @@ static int fdb_flush(int argc, char **argv)
 		} else if (strcmp(*argv, "nosticky") == 0) {
 			ndm_flags &= ~NTF_STICKY;
 			ndm_flags_mask |= NTF_STICKY;
+		} else if (strcmp(*argv, "offloaded") == 0) {
+			ndm_flags |= NTF_OFFLOADED;
+			ndm_flags_mask |= NTF_OFFLOADED;
+		} else if (strcmp(*argv, "nooffloaded") == 0) {
+			ndm_flags &= ~NTF_OFFLOADED;
+			ndm_flags_mask |= NTF_OFFLOADED;
 		} else if (strcmp(*argv, "brport") == 0) {
 			if (port)
 				duparg2("brport", *argv);
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index ad16b4fe0940..d4df772ea3b2 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -123,7 +123,7 @@ bridge \- show / manipulate bridge addresses and devices
 .BR self " ] [ " master " ] [ "
 .BR [no]permanent " | " [no]static " | " [no]dynamic " ] [ "
 .BR [no]added_by_user " ] [ " [no]extern_learn " ] [ "
-.BR [no]sticky " ]"
+.BR [no]sticky " ] [ " [no]offloaded " ]"
 
 .ti -8
 .BR "bridge mdb" " { " add " | " del " } "
@@ -860,6 +860,11 @@ if "no" is prepended then only entries without extern_learn flag will be deleted
 .B [no]sticky
 if specified then only entries with sticky flag will be deleted or respectively
 if "no" is prepended then only entries without sticky flag will be deleted.
+
+.TP
+.B [no]offloaded
+if specified then only entries with offloaded flag will be deleted or respectively
+if "no" is prepended then only entries without offloaded flag will be deleted.
 .sp
 
 .SH bridge mdb - multicast group database management
-- 
2.35.1

