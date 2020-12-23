Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAC52E2201
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 22:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbgLWVYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 16:24:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:50936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727147AbgLWVYG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 16:24:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BB5B22273;
        Wed, 23 Dec 2020 21:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608758606;
        bh=Byb4fjHHlydql2g8PI51aKxdzGmYBaZL8YcYQ25sw7U=;
        h=From:To:Cc:Subject:Date:From;
        b=K7z1359uO7p0AStNOI1MRhtU/Hj2e7xMxUvnkFjyf/RFUUkDq09C+Dizt5skFTDPM
         8J5Qwk4Jkes4ceA9Wbu5bj1xntU75SRMq+Uc49aOpYZZebQ+yyIGwIYNXrynJMcX/v
         wbYato8F4SwTmGd0OZ/mDehzpf+aFmNwPt/K/802OgZidOvPHHJH0kUeeT50GJ3tSp
         labSaOOMe2lH2rkcHLBNm9H//+TF5pGwzB2eMGyY/wXzPPnt5NNJP9JKT7ih+EBywh
         L/5+7vXAb2BmxR7nztRHoH9MLCZuezhjMZFm47Y4Q6RSEHPl8SeHEEpbrTOfDLJwOx
         LvonziJ9DXU1w==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        pabeni@redhat.com
Subject: [PATCH net v3 0/4] net-sysfs: fix race conditions in the xps code
Date:   Wed, 23 Dec 2020 22:23:19 +0100
Message-Id: <20201223212323.3603139-1-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello all,

This series fixes race conditions in the xps code, where out of bound
accesses can occur when dev->num_tc is updated, triggering oops. The
root cause is linked to locking issues. An explanation is given in each
of the commit logs.

We had a discussion on the v1 of this series about using the xps_map
mutex instead of the rtnl lock. While that seemed a better compromise,
v2 showed the added complexity wasn't best for fixes. So we decided to
go back to v1 and use the rtnl lock.

Because of this, the only differences between v1 and v3 are improvements
in the commit messages.

Thanks!
Antoine

Antoine Tenart (4):
  net-sysfs: take the rtnl lock when storing xps_cpus
  net-sysfs: take the rtnl lock when accessing xps_cpus_map and num_tc
  net-sysfs: take the rtnl lock when storing xps_rxqs
  net-sysfs: take the rtnl lock when accessing xps_rxqs_map and num_tc

 net/core/net-sysfs.c | 65 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 53 insertions(+), 12 deletions(-)

-- 
2.29.2

