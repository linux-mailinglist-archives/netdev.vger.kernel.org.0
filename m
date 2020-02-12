Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6197B159F64
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 04:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbgBLDD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 22:03:59 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13069 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727587AbgBLDD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 22:03:59 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e436ade0000>; Tue, 11 Feb 2020 19:02:54 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 11 Feb 2020 19:03:58 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 11 Feb 2020 19:03:58 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 12 Feb
 2020 03:03:57 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 12 Feb 2020 03:03:57 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5e436b1c0001>; Tue, 11 Feb 2020 19:03:56 -0800
From:   John Hubbard <jhubbard@nvidia.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <rds-devel@oss.oracle.com>, <linux-rdma@vger.kernel.org>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH 0/1] net/rds: Track user mapped pages through special API
Date:   Tue, 11 Feb 2020 19:03:54 -0800
Message-ID: <20200212030355.1600749-1-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1581476574; bh=I3bn2WyQuDcUUFQOOPBBlziwLHs8IZsP10xSkCXJjGo=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         MIME-Version:X-NVConfidentiality:Content-Transfer-Encoding:
         Content-Type;
        b=TUcTIdGea9BSNZOmBW0mAOFC4jy8i92C+KqRO77B/+horchnw/n100w6RzJ5de+vg
         Kxp7SoRBQ/JbYa4eCsJRXtwxcR7CX2kYvcHZMv01E6CbVjerwbFEqXDExaC05vNbct
         pwMoBtP/AfL2daJiUr6CP6xn1LeojkqvI9bXiT8rOA2vYrxFsuf+5Nvr0qa2QzdkB5
         /v0+jOS8VZwlvR/ICYEpvRv+zzctQlbOXj/NnDmYBNfvcgcjFLDqRFf+eh89IUuTNb
         lC3hQkoeTdSKAYH5DMzWMBqXDbd9dvtruNvVxk2zjj9/DWVH+jghRv4hZn/MWek5QV
         zzNzZP3QdmrRg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew and all,

Here's another gup-to-pup (get_user_pages() to pin_user_pages())
conversion patch, this time from Leon Romanovsky, that we agreed is
better suited for the linux-mm tree than for linux-rdma. And it also
couldn't be merged until now (5.6-rc1) because it relies on stuff from
a few different git trees.

(Leon: I added my standard blurb about "this changes set_page_dirty() to
set_page_dirty_lock()", to the commit description.)

I've reviewed this, and done some basic checks (cross-compiles, and
a subset of an LTP run on x86), but I have not personally done directed
tests that would provide coverage of this change.

For that, could we please get some Tested-by tags, and any other tags
(reviews, acks) from those of you who have reportedly tested this? That
would be Hans or Santosh (on Cc below), I'm told:

Cc: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>


Leon Romanovsky (1):
  net/rds: Track user mapped pages through special API

 net/rds/rdma.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)


base-commit: 359c92c02bfae1a6f1e8e37c298e518fd256642c
--=20
2.25.0

