Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19BC1DBE32
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 21:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgETTlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 15:41:51 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:6841 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgETTlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 15:41:51 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ec587f20000>; Wed, 20 May 2020 12:41:38 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 20 May 2020 12:41:51 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 20 May 2020 12:41:51 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 20 May
 2020 19:41:50 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 20 May 2020 19:41:50 +0000
Received: from sandstorm.nvidia.com (Not Verified[10.2.48.182]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5ec587fd0005>; Wed, 20 May 2020 12:41:49 -0700
From:   John Hubbard <jhubbard@nvidia.com>
To:     <syzbot+118ac0af4ac7f785a45b@syzkaller.appspotmail.com>
CC:     <akpm@linux-foundation.org>, <davem@davemloft.net>,
        <jhubbard@nvidia.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <rds-devel@oss.oracle.com>, <santosh.shilimkar@oracle.com>,
        <syzkaller-bugs@googlegroups.com>
Subject: [PATCH] rds: fix crash in rds_info_getsockopt()
Date:   Wed, 20 May 2020 12:41:47 -0700
Message-ID: <20200520194147.127137-1-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <00000000000000d71e05a6185662@google.com>
References: <00000000000000d71e05a6185662@google.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590003698; bh=BDc/TGIweZ3py3sn3bABD+UZSkqou30hrSEE7VKAsls=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=Usr87tV7HeZqbUmbIRIvw15CSaVc3ECl1mv4frv1GaPVCn0N+XWQUYPrPeBLsI5Kj
         qEFSsUaJEllygpY4GjniXqBJg/DC7Mf0b1FgsyP1o56Ts56pRSC41uDR3uCE0/cDdD
         ycoaKbA8edjJPxfZFkjABe2Gu5KhC2w87pS0BowsUUDhWcuWIa5+axkCpH+YwQcc35
         doFGfTOmtwNfhdTSd7J1ml+udns7lKS0zqOtBZ7zAY1mgaPwjiJentF/DV7gIHnI+y
         8y8DUkl5Z4LAYmsiLoMbqyJlqkcFKaA4b//8wFK1xz37dfYxfF+Fw3UtD7+X1RaXKx
         90vuJWTA+inPA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The conversion to pin_user_pages() had a bug: it overlooked
the case of allocation of pages failing. Fix that by restoring
an equivalent check.

Reported-by: syzbot+118ac0af4ac7f785a45b@syzkaller.appspotmail.com
Fixes: dbfe7d74376e ("rds: convert get_user_pages() --> pin_user_pages()")

Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Cc: rds-devel@oss.oracle.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 net/rds/info.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rds/info.c b/net/rds/info.c
index e1d63563e81c..b6b46a8214a0 100644
--- a/net/rds/info.c
+++ b/net/rds/info.c
@@ -234,7 +234,8 @@ int rds_info_getsockopt(struct socket *sock, int optnam=
e, char __user *optval,
 		ret =3D -EFAULT;
=20
 out:
-	unpin_user_pages(pages, nr_pages);
+	if (pages)
+		unpin_user_pages(pages, nr_pages);
 	kfree(pages);
=20
 	return ret;
--=20
2.26.2

