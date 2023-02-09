Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA43690684
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 12:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbjBILRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 06:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbjBILRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 06:17:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C37B6D5C;
        Thu,  9 Feb 2023 03:16:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA102B820F0;
        Thu,  9 Feb 2023 11:16:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DC4C433D2;
        Thu,  9 Feb 2023 11:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941367;
        bh=Un6JpB0UHci0qIBH1D+no3jpcc+8i6GyZ7154XvIZjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KW0AFJO7mQuweGIFzlwCQzmgDRQXVUmeELvm1zAxWxgoc1S+UguwpA/WEDJZpx8l1
         qWphYM1CVLsCZ1M0Tijmz4HcRnf+52MYlTfuewVSJjg3uy5L42NVsbdNjKEkfVU1FL
         Uz7F7cc5d+WeYiRGFkhuQN/p5crKpas+Dw3NDZSnjmpSIU2j42H9LeT3tj/0BOTqhW
         OwQyHtmXpZ11dzuVTS3wyifuhaz6BpOVq8/LcURDZQ+Tnz2gLH718VPKFYIH0wi3uc
         mqdWcpnAGWTZusPB53UGp6kSATFMRfvPaSDaTO3hue3xuQh0XEA3+rU+IWq5cVINA5
         hTOgRQiVPba1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrei Gherzan <andrei.gherzan@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 16/38] selftest: net: Improve IPV6_TCLASS/IPV6_HOPLIMIT tests apparmor compatibility
Date:   Thu,  9 Feb 2023 06:14:35 -0500
Message-Id: <20230209111459.1891941-16-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111459.1891941-1-sashal@kernel.org>
References: <20230209111459.1891941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrei Gherzan <andrei.gherzan@canonical.com>

[ Upstream commit a6efc42a86c0c87cfe2f1c3d1f09a4c9b13ba890 ]

"tcpdump" is used to capture traffic in these tests while using a random,
temporary and not suffixed file for it. This can interfere with apparmor
configuration where the tool is only allowed to read from files with
'known' extensions.

The MINE type application/vnd.tcpdump.pcap was registered with IANA for
pcap files and .pcap is the extension that is both most common but also
aligned with standard apparmor configurations. See TCPDUMP(8) for more
details.

This improves compatibility with standard apparmor configurations by
using ".pcap" as the file extension for the tests' temporary files.

Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/cmsg_ipv6.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/cmsg_ipv6.sh b/tools/testing/selftests/net/cmsg_ipv6.sh
index 2d89cb0ad2889..330d0b1ceced3 100755
--- a/tools/testing/selftests/net/cmsg_ipv6.sh
+++ b/tools/testing/selftests/net/cmsg_ipv6.sh
@@ -6,7 +6,7 @@ ksft_skip=4
 NS=ns
 IP6=2001:db8:1::1/64
 TGT6=2001:db8:1::2
-TMPF=`mktemp`
+TMPF=$(mktemp --suffix ".pcap")
 
 cleanup()
 {
-- 
2.39.0

