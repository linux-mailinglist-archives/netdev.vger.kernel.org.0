Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B86E36504E2
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 22:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiLRV5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 16:57:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbiLRV5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 16:57:30 -0500
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E24C74F
        for <netdev@vger.kernel.org>; Sun, 18 Dec 2022 13:57:28 -0800 (PST)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id AD8782C0288;
        Mon, 19 Dec 2022 10:57:23 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1671400643;
        bh=wswQ/KMRzD2puKOHYOnzQLN1QFz3lsndlcSA4xBLrfM=;
        h=From:To:Cc:Subject:Date:From;
        b=y/A64C0+Iq1Mz4IsvQ5ipgqfiL6/tb/klZ6Hdn+Jp9TVZ/PAf52b5jKnXt5bQGyJd
         CuszkBTiBOK0ougQ8ujtt36KCWlpg6Qpee6gOAd2I9lHjQEaN0bI3Jb7Fc+QE/nBax
         uQY6gNJzUwMX43nV0a2m5eAiZGWv0XG8X1AeEAd6XslLx7O7thUgvjb8vGyN31b/Bw
         1Fb6weEsG3if3Eby4bQQ4EEDD+gQhRddNLGX/d0rrglfa9dUiNahNweDqYMkQ2rszQ
         HbjBLqIafSP94WZ7HIASOxwoYnjMwQr4AvxG6XIxTARNVCb0bBHIBRLmcYj0bMDx6G
         zyKNHcBFL6S9Q==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B639f8cc30000>; Mon, 19 Dec 2022 10:57:23 +1300
Received: from thomaswi-dl.ws.atlnz.lc (thomaswi-dl.ws.atlnz.lc [10.33.25.46])
        by pat.atlnz.lc (Postfix) with ESMTP id 77FBA13EE3F;
        Mon, 19 Dec 2022 10:57:23 +1300 (NZDT)
Received: by thomaswi-dl.ws.atlnz.lc (Postfix, from userid 1719)
        id 731483E5131; Mon, 19 Dec 2022 10:57:23 +1300 (NZDT)
From:   Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, a@unstable.cc, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
Subject: [PATCH 0/2] ip/ip6_gre: Fix GRE tunnels not generating IPv6 link local addresses
Date:   Mon, 19 Dec 2022 10:57:16 +1300
Message-Id: <20221218215718.1491444-1-Thomas.Winter@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=X/cs11be c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=sHyYjHe8cH0A:10 a=IpZYufPWUN2N8bb5Va0A:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For our point-to-point GRE tunnels, they have IN6_ADDR_GEN_MODE_NONE
when they are created then we set IN6_ADDR_GEN_MODE_EUI64 when they
come up to generate the IPv6 link local address for the interface.
Recently we found that they were no longer generating IPv6 addresses.

Also, non-point-to-point tunnels were not generating any IPv6 link
local address and instead generating an IPv6 compat address,
breaking IPv6 communication on the tunnel.

These failures were caused by commit e5dd729460ca and this patch set
aims to resolve these issues.

Thomas Winter (2):
  ip/ip6_gre: Fix changing addr gen mode not generating IPv6 link local
    address
  ip/ip6_gre: Fix non-point-to-point tunnel not generating IPv6 link
    local address

 net/ipv6/addrconf.c | 57 ++++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 26 deletions(-)

--=20
2.37.3

