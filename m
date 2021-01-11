Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7362F1BDA
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389247AbhAKRIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:08:42 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1277 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729405AbhAKRIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 12:08:42 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffc85f10000>; Mon, 11 Jan 2021 09:08:01 -0800
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 11 Jan
 2021 17:07:59 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net] net: dcb: Accept RTM_GETDCB messages carrying set-like DCB commands
Date:   Mon, 11 Jan 2021 18:07:07 +0100
Message-ID: <a3edcfda0825f2aa2591801c5232f2bbf2d8a554.1610384801.git.me@pmachata.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610384881; bh=Hnypd/LvO7EaP7eDklpe+9/bfde0U9Rjd2Awe3M/nFk=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=CUkiXRBSPHKjPqEAyJgg0c8S5kyXKPkO09swKI8oVxyxQakU6GA/EqLUiRWSa0mdw
         XZ46btO10tc4kUMWJACo+rlEOPyGOu7kfbqS0i+aq9/9NeAkChSOnNyNkNRNVTZsuH
         dWZpkWPrDE+GVIphPKePcAUXo9X86lr0tW0zEHu7T4unT6fONP4CeIH6TLbbJyjxxQ
         +pxVn6p/bijS37jNg7IjOUQ+VWNo1bdtOXSMMz1UQ1MZVtiGkDkyH7/ZFZ8KhHKmsC
         NsOD+dYJfEcwxy+SXgHt3kxfCyWg8TlMigme4p1cC0RbN7KpVba6j4DffRB+qfHjMT
         rZVI/dMe2oUpA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 826f328e2b7e ("net: dcb: Validate netlink message in DCB
handler"), Linux started rejecting RTM_GETDCB netlink messages if they
contained a set-like DCB_CMD_ command.

The reason was that privileges were only verified for RTM_SETDCB messages,
but the value that determined the action to be taken is the command, not
the message type. And validation of message type against the DCB command
was the obvious missing piece.

Unfortunately it turns out that mlnx_qos, a somewhat widely deployed tool
for configuration of DCB, accesses the DCB set-like APIs through
RTM_GETDCB.

Therefore do not bounce the discrepancy between message type and command.
Instead, in addition to validating privileges based on the actual message
type, validate them also based on the expected message type. This closes
the loophole of allowing DCB configuration on non-admin accounts, while
maintaining backward compatibility.

Fixes: 2f90b8657ec9 ("ixgbe: this patch adds support for DCB to the kernel =
and ixgbe driver")
Fixes: 826f328e2b7e ("net: dcb: Validate netlink message in DCB handler")
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 net/dcb/dcbnl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index 7d49b6fd6cef..653e3bc9c87b 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -1765,7 +1765,7 @@ static int dcb_doit(struct sk_buff *skb, struct nlmsg=
hdr *nlh,
 	fn =3D &reply_funcs[dcb->cmd];
 	if (!fn->cb)
 		return -EOPNOTSUPP;
-	if (fn->type !=3D nlh->nlmsg_type)
+	if (fn->type =3D=3D RTM_SETDCB && !netlink_capable(skb, CAP_NET_ADMIN))
 		return -EPERM;
=20
 	if (!tb[DCB_ATTR_IFNAME])
--=20
2.26.2

