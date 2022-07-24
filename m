Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0FD57F22E
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 02:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbiGXAik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 20:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGXAih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 20:38:37 -0400
Received: from mx07-0057a101.pphosted.com (mx07-0057a101.pphosted.com [205.220.184.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99A014030
        for <netdev@vger.kernel.org>; Sat, 23 Jul 2022 17:38:35 -0700 (PDT)
Received: from pps.filterd (m0214197.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26O0ODUt029320;
        Sun, 24 Jul 2022 02:38:04 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=12052020; bh=Dr9mIdFoxA+uJnGlPkvj4VSnpdpSXDs2SgCUQNfNjKE=;
 b=nBl/TcZxeWvchbrTOCqezCv0aEfVn95IgnPj2u+WqkGWAzZegCWNW0XGe/4gODDNUg66
 Se7jDnanEM8GjWDar9Z3Slyp+1XPbrnY1VegjX99+TAYKHrZcWe7+5PuiPZ0F/6C/ULF
 JE8QX5jfEjVSmPOGh+Nt9Ba2obc356JDnasrcQQGM4Ly/dNavsnS6aWf2DvddyP/mgTX
 86uDxWoHW6C+Wc5ZUG12CKzpMOEaEuASxrw8eWlmzTdsVuJHqfh/sxDonruehUcYWf5Y
 qfNzIii2ZX31PUX6FRD8CnLYccUeD20g8HFv980Rus9HH1y3P6LhYUXSxzDtxkqIkh3d Xw== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3hg5bbgrky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 24 Jul 2022 02:38:04 +0200
Received: from Orpheus.nch.westermo.com (172.29.100.2) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Sun, 24 Jul 2022 02:38:00 +0200
From:   Matthias May <matthias.may@westermo.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <nicolas.dichtel@6wind.com>,
        <eyal.birger@gmail.com>, <linux-kernel@vger.kernel.org>,
        Matthias May <matthias.may@westermo.com>
Subject: [PATCH 0/2 net-next] geneve: fix TOS inheriting
Date:   Sun, 24 Jul 2022 02:37:39 +0200
Message-ID: <20220724003741.57816-1-matthias.may@westermo.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.29.100.2]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 EX01GLOBAL.beijerelectronics.com (10.101.10.25)
X-Proofpoint-GUID: L-hfHzRnloXqbZLBCKDLL-DFgxcspLTq
X-Proofpoint-ORIG-GUID: L-hfHzRnloXqbZLBCKDLL-DFgxcspLTq
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when the TOS of an encapsulated frame is inherited,
the 6 DSCP bits are cut down to 3 original TOS bits.
Compare to other L2 tunneling protocols (gretap, vxlan) this
is unexpected.
IPv4 and IPv6 have both this behaviour but for different reasons.

For IPv4 the bits are lost in the routing table lookup.
The patch copies the full tos out before the lookup and uses the copy.

For IPv6 the RT_TOS macro cuts off the 3 bits.
I'm not really familiar with the IPv6 code, but to me it seems as
if this part of the code only uses the TOS for the flowlabel.
Is there any reason why the flowlabel should be restricted to these
3 bits? The patch simply removes the usage of this macro, but i don't
know if there was a specific intention behind that. I can't find any
immediate breakage, but then again my IPv6 testing is fairly limited.

Matthias May (2):
  geneve: fix TOS inheriting for ipv4
  geneve: fix TOS inheriting for ipv6

 drivers/net/geneve.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

-- 
2.35.1

