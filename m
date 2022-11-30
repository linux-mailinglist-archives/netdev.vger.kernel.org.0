Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D9C63D7AE
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 15:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiK3OHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 09:07:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiK3OHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 09:07:30 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F75D77220
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 06:07:04 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id bj12so41517810ejb.13
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 06:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IXRqop1kGCEX2u8HK3BLrgeD9xK0rFoNB2L0UfRu0sg=;
        b=v006RZGKNhV7QldYcKIzJsCYNB63Tfp5FEfdFmJp6bROQIuqlnk8+FKbW7+BQPm+Pp
         zOFNnSXmfagXgOSLKxFs3oROvyDkHghKcrDA9NxWVlHOLUnZ8OM+Z8uSLIs8p7hA/rv9
         pnl/w3ie8D/tGrXuDFnTxTNKHdp/ZusM67kXjNzHCcQDhAsqKdwZW26VkHNMCGmftWaU
         EbMGpaDORdqqdOCO1/imCDSQXswP2t+1j4KZ4L8udoAYRYbhVPDDz+9xzQPlK1w+e3jV
         jwVPhPV6VB74LpQnBqQob/ZZW34U02qr9YRFSzBEFJS2cotxPXsoSqh9xy+CGrRSSEXx
         MBAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IXRqop1kGCEX2u8HK3BLrgeD9xK0rFoNB2L0UfRu0sg=;
        b=Zz4oxppTFcOwihrayb0ZttEIiUbysCUSOlP+2CtV9zwnjIL0TnqC8QdQJ9/ut1IOXJ
         5tGqKT6zjwtYaSBSrtLh/NG+/OF2L5f/4XsS+MrCovQpxBBX2Oe+Rv8UuFaVSJHzAsAL
         wA/DSy9g2AdKUMLh5IxoO5ZsMh70DNtGUqAlzfuni0skIKIDPFlc3YJkm1Gqxj1RNxQu
         vdMjyyJNhFeOENhxY/TYCbselVsVSES9p2qNGv/OP7XR3sjTn3X8p+L9JK94QmUcLTgH
         19vk3b9OGBQO8r7MLUbDosM4fE2ZZrnDLUi0vxZ7TpCf+HK2+2oFsRDnQNbr5ZpUN8Sd
         pNFw==
X-Gm-Message-State: ANoB5pk8rZBZk3ijnxq91gVdX0MzzMowMHJ0lxRP39cQIoR5xxQPPzp1
        t2gIF020rMICQreoAa9W5EjroA==
X-Google-Smtp-Source: AA0mqf5Qkten+sdz5wTXblKGqR7rZD+RmmlVt4D0tNeFA1XdsS9NPPsgEi01P7NfbalH9380k5PJUQ==
X-Received: by 2002:a17:906:89a3:b0:78d:408a:4a18 with SMTP id gg35-20020a17090689a300b0078d408a4a18mr52479961ejc.261.1669817221279;
        Wed, 30 Nov 2022 06:07:01 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id mh1-20020a170906eb8100b0073d83f80b05sm692454ejb.94.2022.11.30.06.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 06:07:00 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     Geliang Tang <geliang.tang@suse.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 04/11] selftests: mptcp: clearly declare global ns vars
Date:   Wed, 30 Nov 2022 15:06:26 +0100
Message-Id: <20221130140637.409926-5-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221130140637.409926-1-matthieu.baerts@tessares.net>
References: <20221130140637.409926-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1440; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=vm+YLBU/ZtD1x+WUlv2naFFwGpGoYmoqnp2qkgB760M=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjh2NouvnL/n/xWVXPFT9olXEh+lvvARvqTTsiHK9z
 UqifJbeJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY4djaAAKCRD2t4JPQmmgc46LD/
 4yS1d70STmWag1bHFpeVw3ewfxgyI0JTsJlKmrxDdeXnjRoj8sRHXrkRobl50q/96ApVaXpU97L1nQ
 BCXBSV0x+sbrHOLpGn8KHxVdse30n4D9woXwWRc+FNi8XPiPLnFPWM0tEK8ygBLYxE1w9dlyD5NZwA
 cPKp0P8s//huK0fLkK7iE4uppBFbGqm5YIarbemAWgLeaAFSaXlX2V9wzFMkFR32oKceqLDFv92nV9
 qMnm5xhVyE9756j696iw/TAjOxTtDvCha6mPq/LM94udQH+VAnbfB2LLKZboXCK6cXn1YQe5nbf/zn
 ru9NnJrCZ6aZQEKqsW0djOKuAFEhCO/K9aDRAlfPtAorL6ECoxP8b42b+HxZe8TB3/5maYXsgaJkHd
 EWfdH6S2L4GnxAodoQ723QJNi10w/9idJUH+TsDUcOSUJesB9FTepZtryG10/FDh/OeibPk/wfjCQH
 VC9dpfuC7rw+jyuJ5NfCQAlylCWYau/6+4U2ufgfSu2HUUmP0zk0NzTDBnpHEz8lbA3BEwS0xsIaiL
 pbSoSyJyXIoAyQeVkiZXPteRcf56y29vQgytqdcbcAFu2f2Rlg1pcHAydtGf41Ot/a/f1QZxgTnavG
 kDVBiiYLFdns8jD69enBIwfKdGmXIsxTVpmaYQaqegnwjLrTGyhAOvN34Lnw==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is clearer to declare these global variables at the beginning of the
file as it is done in other MPTCP selftests rather than in functions in
the middle of the script.

So for uniformity reason, we can do the same here in mptcp_sockopt.sh.

Suggested-by: Geliang Tang <geliang.tang@suse.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/mptcp_sockopt.sh | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh b/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
index dbee386450f3..f74b237bcb32 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
@@ -11,6 +11,12 @@ timeout_poll=30
 timeout_test=$((timeout_poll * 2 + 1))
 mptcp_connect=""
 
+sec=$(date +%s)
+rndh=$(printf %x $sec)-$(mktemp -u XXXXXX)
+ns1="ns1-$rndh"
+ns2="ns2-$rndh"
+ns_sbox="ns_sbox-$rndh"
+
 add_mark_rules()
 {
 	local ns=$1
@@ -30,14 +36,6 @@ add_mark_rules()
 
 init()
 {
-	local sec rndh
-	sec=$(date +%s)
-	rndh=$(printf %x $sec)-$(mktemp -u XXXXXX)
-
-	ns1="ns1-$rndh"
-	ns2="ns2-$rndh"
-	ns_sbox="ns_sbox-$rndh"
-
 	for netns in "$ns1" "$ns2" "$ns_sbox";do
 		ip netns add $netns || exit $ksft_skip
 		ip -net $netns link set lo up
-- 
2.37.2

