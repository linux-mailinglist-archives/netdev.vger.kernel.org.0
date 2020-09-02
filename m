Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448B825A3F9
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 05:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgIBDWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 23:22:39 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:39637 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgIBDWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 23:22:38 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 46988806B5;
        Wed,  2 Sep 2020 15:22:35 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1599016955;
        bh=pA5jZtYGbadRL6MpsDi7RfTcACMi8fe+m3GaZOwbkX0=;
        h=From:To:Cc:Subject:Date;
        b=qrzK4Iy5fijirooHGX6wQqbMYHJO6KCGCNbWqPU28KOlSHlSjn07DQIHz0ooIfIge
         SSM7i7gyOmlEXUORuavt7AIx2CLIunu029fhJJs6l0MGg9JpO9DuMFzxv5IM4wzr9q
         70XnRE3c9sYK1EDVGpkEb6r9Vvnt8fA9xeEDTnlEAaDjs4KGsVbT0hCdwxLSYXUkrD
         /M4EHWCqpugnffM09s/yusc9WfaKhCAjM5raHLU0UFnC9AJe1PMw/ZDUx2oZjmnr+R
         S/7K9lQNK9R4ySd6wyBo1R8m3N2UP1ayW4ZQBxNIkxGYnhpQJ/YeQj2tRUoWFN87nd
         WBv6E23XJYFpw==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f4f0ffb0000>; Wed, 02 Sep 2020 15:22:35 +1200
Received: from pauld-dl.ws.atlnz.lc (pauld-dl.ws.atlnz.lc [10.33.23.16])
        by smtp (Postfix) with ESMTP id C161413EEBA;
        Wed,  2 Sep 2020 15:22:34 +1200 (NZST)
Received: by pauld-dl.ws.atlnz.lc (Postfix, from userid 1684)
        id 14FC51E05C4; Wed,  2 Sep 2020 15:22:35 +1200 (NZST)
From:   Paul Davey <paul.davey@alliedtelesis.co.nz>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Davey <paul.davey@alliedtelesis.co.nz>
Subject: [PATCH net-next 0/2] Allow more than 255 IPv4 multicast interfaces
Date:   Wed,  2 Sep 2020 15:22:20 +1200
Message-Id: <20200902032222.25109-1-paul.davey@alliedtelesis.co.nz>
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
available for the VIF ID.  There is enough space for the full VIF ID in
the Netlink cache notifications, however the value is currently taken
directly from the igmpmsg header and has thus already been truncated.

Using the full VIF ID in the Netlink notifications allows use of more
than 255 IPv4 multicast interfaces if the user space routing daemon
uses the Netlink notifications instead of the igmpmsg cache reports.

However doing this reveals a deficiency in the Netlink cache report
notifications, they lack any means for differentiating cache reports
relating to different multicast routing tables.  This is easily
resolved by adding the multicast route table ID to the cache reports.

Paul Davey (2):
  ipmr: Add route table ID to netlink cache reports
  ipmr: Use full VIF ID in netlink cache reports

 include/uapi/linux/mroute.h |  1 +
 net/ipv4/ipmr.c             | 12 +++++++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

--=20
2.28.0

