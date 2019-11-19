Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0D5102F86
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfKSWst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:48:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46056 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727403AbfKSWss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 17:48:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574203728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=GeEavm54frEh+j2XuhIdx2fo2A7J1EySGY1VMtVQreI=;
        b=UBJLB5STbZ0tdZY/ufWZB5Pai/aKit8LfnxoCd/bQ0CJb2fiMRo1Psv8ngj/Yf7TdWYxqN
        9LpxL7HXrvgC/7S1I5Huza5ub70iVTto2T5/iSWmeMd2hyA05E3L/I85/4Om33dYF/nEcj
        eUMf+kUgibeCwMP1yqmZBhBIbwUuXio=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-EsAKjoEdP8-VRuwmPuoqHQ-1; Tue, 19 Nov 2019 17:48:44 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BF4A801E5A;
        Tue, 19 Nov 2019 22:48:43 +0000 (UTC)
Received: from new-host-5.redhat.com (ovpn-204-53.brq.redhat.com [10.40.204.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F0AA4691B4;
        Tue, 19 Nov 2019 22:48:40 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net] net/sched: act_pedit: fix WARN() in the traffic path
Date:   Tue, 19 Nov 2019 23:47:33 +0100
Message-Id: <485b2235cb9c1dc53d7094969c131f05f2df5258.1574203001.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: EsAKjoEdP8-VRuwmPuoqHQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

when configuring act_pedit rules, the number of keys is validated only on
addition of a new entry. This is not sufficient to avoid hitting a WARN()
in the traffic path: for example, it is possible to replace a valid entry
with a new one having 0 extended keys, thus causing splats in dmesg like:

 pedit BUG: index 42
 WARNING: CPU: 2 PID: 4054 at net/sched/act_pedit.c:410 tcf_pedit_act+0xc84=
/0x1200 [act_pedit]
 [...]
 RIP: 0010:tcf_pedit_act+0xc84/0x1200 [act_pedit]
 Code: 89 fa 48 c1 ea 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e ac 00 00 00 48=
 8b 44 24 10 48 c7 c7 a0 c4 e4 c0 8b 70 18 e8 1c 30 95 ea <0f> 0b e9 a0 fa =
ff ff e8 00 03 f5 ea e9 14 f4 ff ff 48 89 58 40 e9
 RSP: 0018:ffff888077c9f320 EFLAGS: 00010286
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffffac2983a2
 RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffff888053927bec
 RBP: dffffc0000000000 R08: ffffed100a726209 R09: ffffed100a726209
 R10: 0000000000000001 R11: ffffed100a726208 R12: ffff88804beea780
 R13: ffff888079a77400 R14: ffff88804beea780 R15: ffff888027ab2000
 FS:  00007fdeec9bd740(0000) GS:ffff888053900000(0000) knlGS:00000000000000=
00
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007ffdb3dfd000 CR3: 000000004adb4006 CR4: 00000000001606e0
 Call Trace:
  tcf_action_exec+0x105/0x3f0
  tcf_classify+0xf2/0x410
  __dev_queue_xmit+0xcbf/0x2ae0
  ip_finish_output2+0x711/0x1fb0
  ip_output+0x1bf/0x4b0
  ip_send_skb+0x37/0xa0
  raw_sendmsg+0x180c/0x2430
  sock_sendmsg+0xdb/0x110
  __sys_sendto+0x257/0x2b0
  __x64_sys_sendto+0xdd/0x1b0
  do_syscall_64+0xa5/0x4e0
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
 RIP: 0033:0x7fdeeb72e993
 Code: 48 8b 0d e0 74 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00=
 83 3d 0d d6 2c 00 00 75 13 49 89 ca b8 2c 00 00 00 0f 05 <48> 3d 01 f0 ff =
ff 73 34 c3 48 83 ec 08 e8 4b cc 00 00 48 89 04 24
 RSP: 002b:00007ffdb3de8a18 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
 RAX: ffffffffffffffda RBX: 000055c81972b700 RCX: 00007fdeeb72e993
 RDX: 0000000000000040 RSI: 000055c81972b700 RDI: 0000000000000003
 RBP: 00007ffdb3dea130 R08: 000055c819728510 R09: 0000000000000010
 R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000040
 R13: 000055c81972b6c0 R14: 000055c81972969c R15: 0000000000000080

Fix this moving the check on 'nkeys' earlier in tcf_pedit_init(), so that
attempts to install rules having 0 keys are always rejected with -EINVAL.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/act_pedit.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index cdfaa79382a2..b5bc631b96b7 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -43,7 +43,7 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(s=
truct nlattr *nla,
 =09int err =3D -EINVAL;
 =09int rem;
=20
-=09if (!nla || !n)
+=09if (!nla)
 =09=09return NULL;
=20
 =09keys_ex =3D kcalloc(n, sizeof(*k), GFP_KERNEL);
@@ -170,6 +170,10 @@ static int tcf_pedit_init(struct net *net, struct nlat=
tr *nla,
 =09}
=20
 =09parm =3D nla_data(pattr);
+=09if (!parm->nkeys) {
+=09=09NL_SET_ERR_MSG_MOD(extack, "Pedit requires keys to be passed");
+=09=09return -EINVAL;
+=09}
 =09ksize =3D parm->nkeys * sizeof(struct tc_pedit_key);
 =09if (nla_len(pattr) < sizeof(*parm) + ksize) {
 =09=09NL_SET_ERR_MSG_ATTR(extack, pattr, "Length of TCA_PEDIT_PARMS or TCA=
_PEDIT_PARMS_EX pedit attribute is invalid");
@@ -183,12 +187,6 @@ static int tcf_pedit_init(struct net *net, struct nlat=
tr *nla,
 =09index =3D parm->index;
 =09err =3D tcf_idr_check_alloc(tn, &index, a, bind);
 =09if (!err) {
-=09=09if (!parm->nkeys) {
-=09=09=09tcf_idr_cleanup(tn, index);
-=09=09=09NL_SET_ERR_MSG_MOD(extack, "Pedit requires keys to be passed");
-=09=09=09ret =3D -EINVAL;
-=09=09=09goto out_free;
-=09=09}
 =09=09ret =3D tcf_idr_create(tn, index, est, a,
 =09=09=09=09     &act_pedit_ops, bind, false);
 =09=09if (ret) {
--=20
2.23.0

