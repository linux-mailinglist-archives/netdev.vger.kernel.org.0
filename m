Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE1096822FE
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 04:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjAaDrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 22:47:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbjAaDq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 22:46:58 -0500
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FA31C596
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 19:46:56 -0800 (PST)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id C19902C0420;
        Tue, 31 Jan 2023 16:46:54 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1675136814;
        bh=gdmqii2FMSblyIZ+z6bZYQvRBp1UcXznBFYC6w7oleQ=;
        h=From:To:Cc:Subject:Date:From;
        b=RtTybWZFlkbUvz4XC3eOjOzHAPztwmKTc7XCGy8+9Blyenj2DZ3QHVieWxHTP1XnS
         KXE49oPo7CufM2z0LWwJ+QG0ODbtAlJFVs2BEDhA+FWXgYX/mvFfVRugRe7wYoTtPp
         oC/0RNnP8D/naqgQWt9t3l1A1iUPoJHpuBkqxdJ3eneA+92lqduxEzCVv49uERcG0u
         1N0w0FmeVqQtUNEVAvi6s6MvQYKoTchvFKN/f1NHxnBgQKuoJuxHdrw2kOksKHjVxz
         pUHcXXMzkNsBAwQAAhYzfWskA3G+Tzn4TrtDNRZdU7DvJDl6LOG5nyZXJtoB9hSzLX
         LlQ2V67ymDhNg==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B63d88f2e0001>; Tue, 31 Jan 2023 16:46:54 +1300
Received: from thomaswi-dl.ws.atlnz.lc (thomaswi-dl.ws.atlnz.lc [10.33.25.46])
        by pat.atlnz.lc (Postfix) with ESMTP id 74BF013ED0C;
        Tue, 31 Jan 2023 16:46:54 +1300 (NZDT)
Received: by thomaswi-dl.ws.atlnz.lc (Postfix, from userid 1719)
        id 7313F3E089B; Tue, 31 Jan 2023 16:46:54 +1300 (NZDT)
From:   Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        pabeni@redhat.com, edumazet@google.com, kuba@kernel.org,
        a@unstable.cc, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
Subject: [PATCH v5 0/2] ip/ip6_gre: Fix GRE tunnels not generating IPv6 link local addresses
Date:   Tue, 31 Jan 2023 16:46:44 +1300
Message-Id: <20230131034646.237671-1-Thomas.Winter@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=a6lOCnaF c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=RvmDmJFTN0MA:10 a=IpZYufPWUN2N8bb5Va0A:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

 net/ipv6/addrconf.c | 59 ++++++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 27 deletions(-)

--=20
2.39.0

