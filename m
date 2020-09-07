Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB6B2606C9
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 00:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgIGWE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 18:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbgIGWEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 18:04:20 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC21CC061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 15:04:19 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id C8D39806B5;
        Tue,  8 Sep 2020 10:04:14 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1599516254;
        bh=Q02+/9NY7pSuY9wiR+9Qb9y2Y6jEeyrcs5Z2A0X3LB0=;
        h=From:To:Cc:Subject:Date;
        b=EAwXcvhPjr4/jl3mLpfonY2+A0A1HNwzg/5jDFqjf4UJ62suA4PZDpoaDB1/OcXa7
         8U6dWhUkrz7oRO1kOhiwXoT7VnE4x5o3bw3/75Hs4ACIouksjuOgfiAFOyTxH9CylJ
         4rZn/HmjPAJYg64x79ETH41datqgfkvXsJq151Xquf/baCCMkJJiSuiV9PhOob/TeT
         Xu2PO6At1diZkS8xBiw53fNnL7y3q91keuR3Kz+Cesq5rJCVB7lJEQ7XiMM/Bt7dM6
         a9P4XBNSJW3khAa8106tAIuAGIM2yoaS39d+5G+TszegsZwYEyprkED7Ym3C0IsiWW
         z1mEr1cwNm1AA==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f56ae5e0000>; Tue, 08 Sep 2020 10:04:14 +1200
Received: from pauld-dl.ws.atlnz.lc (pauld-dl.ws.atlnz.lc [10.33.23.16])
        by smtp (Postfix) with ESMTP id C2EEB13EEBA;
        Tue,  8 Sep 2020 10:04:13 +1200 (NZST)
Received: by pauld-dl.ws.atlnz.lc (Postfix, from userid 1684)
        id 7657A1E3850; Tue,  8 Sep 2020 10:04:14 +1200 (NZST)
From:   Paul Davey <paul.davey@alliedtelesis.co.nz>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Davey <paul.davey@alliedtelesis.co.nz>
Subject: [PATCH net-next v2 0/3] Allow more than 255 IPv4 multicast interfaces
Date:   Tue,  8 Sep 2020 10:04:05 +1200
Message-Id: <20200907220408.32385-1-paul.davey@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently it is not possible to use more than 255 multicast interfaces
for IPv4 due to the format of the igmpmsg header which only has 8 bits
available for the VIF ID.  There is space available in the igmpmsg
header to store the full VIF ID in the form of an unused byte following
the VIF ID field.  There is also enough space for the full VIF ID in
the Netlink cache notifications, however the value is currently taken
directly from the igmpmsg header and has thus already been truncated.

Adding the high byte of the VIF ID into the unused3 byte of igmpmsg
allows use of more than 255 IPv4 multicast interfaces. The full VIF ID
is  also available in the Netlink notification by assembling it from
both bytes from the igmpmsg.

Additionally this reveals a deficiency in the Netlink cache report
notifications, they lack any means for differentiating cache reports
relating to different multicast routing tables.  This is easily
resolved by adding the multicast route table ID to the cache reports.

changes in v2:
 - Added high byte of VIF ID to igmpmsg struct replacing unused3
   member.
 - Assemble VIF ID in Netlink notification from both bytes in igmpmsg
   header.

Paul Davey (3):
  ipmr: Add route table ID to netlink cache reports
  ipmr: Add high byte of VIF ID to igmpmsg
  ipmr: Use full VIF ID in netlink cache reports

 include/uapi/linux/mroute.h |  5 +++--
 net/ipv4/ipmr.c             | 14 ++++++++++----
 2 files changed, 13 insertions(+), 6 deletions(-)

--=20
2.28.0

