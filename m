Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBEE1C2693
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 17:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgEBPfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 11:35:00 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:46870 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727897AbgEBPfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 11:35:00 -0400
Received: from mxbackcorp1o.mail.yandex.net (mxbackcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::301])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 7A8042E09B7;
        Sat,  2 May 2020 18:34:53 +0300 (MSK)
Received: from iva8-88b7aa9dc799.qloud-c.yandex.net (iva8-88b7aa9dc799.qloud-c.yandex.net [2a02:6b8:c0c:77a0:0:640:88b7:aa9d])
        by mxbackcorp1o.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id Wt7SerPtPA-YqbWLRpn;
        Sat, 02 May 2020 18:34:53 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1588433693; bh=ItS7qMky3WsDKuAAiwZW5eAEqpnMDhf6GjWH/yoKNgM=;
        h=Message-Id:Date:Subject:To:From;
        b=YOzP2JJJwbiOOehEqKRBWaqfE+FIxzlDxd5DUS0Hm2g8NxU6RpXIP8ohsHTuwOL9P
         piyoqqqGpcB4IsnPJRL7TnaUO8fE+BHHs/jyqw4vv9J1TG01P2FBVMeQb5FJxr9CCZ
         CPxg6Qv7xT8lRtNz4Mp76QKOej2jlgLs24dYApUc=
Authentication-Results: mxbackcorp1o.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from unknown (unknown [95.108.217.196])
        by iva8-88b7aa9dc799.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id sVVyFfmTp0-YqWSCMai;
        Sat, 02 May 2020 18:34:52 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH net-next] inet_diag: bc: read cgroup id only for full sockets
Date:   Sat,  2 May 2020 18:34:42 +0300
Message-Id: <20200502153442.90490-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix bug introduced by commit b1f3e43dbfac ("inet_diag: add support for
cgroup filter").

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
Reported-by: syzbot+ee80f840d9bf6893223b@syzkaller.appspotmail.com
Reported-by: syzbot+13bef047dbfffa5cd1af@syzkaller.appspotmail.com
Fixes: b1f3e43dbfac ("inet_diag: add support for cgroup filter")
---
 net/ipv4/inet_diag.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 0034092..125f4f8 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -746,7 +746,8 @@ int inet_diag_bc_sk(const struct nlattr *bc, struct sock *sk)
 	else
 		entry.mark = 0;
 #ifdef CONFIG_SOCK_CGROUP_DATA
-	entry.cgroup_id = cgroup_id(sock_cgroup_ptr(&sk->sk_cgrp_data));
+	entry.cgroup_id = sk_fullsock(sk) ?
+		cgroup_id(sock_cgroup_ptr(&sk->sk_cgrp_data)) : 0;
 #endif
 
 	return inet_diag_bc_run(bc, &entry);
-- 
2.7.4

