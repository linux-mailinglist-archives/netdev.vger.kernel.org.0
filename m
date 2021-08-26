Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20DAD3F7F48
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 02:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbhHZA12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 20:27:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40338 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231210AbhHZA11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 20:27:27 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17Q0A8EU020811
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 17:26:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=XaA05mxXysbDMsRfC49IeooU5yjQQc8SDkCFvLTLyiU=;
 b=bhq0eQhgvEBoYA5Vt3W8P+MR4OAnDfz82wUTBw//4oKaceeD5OW3eH3xcpHwcm9LdsDb
 3vWfH8D39brplGj6j2nku/fcZvEPY9ijNjpswfHZDuNvDFYTlr8NLoivsh/tvVwDv4FW
 GwdgB16L/fFeLyPIqdfqdmj+Ej5/qa/c4Dg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3an6d41h7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 17:26:40 -0700
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 25 Aug 2021 17:26:39 -0700
Received: by devbig139.ftw2.facebook.com (Postfix, from userid 572249)
        id 171621A94518; Wed, 25 Aug 2021 17:26:35 -0700 (PDT)
From:   Andrey Ignatov <rdna@fb.com>
To:     <netdev@vger.kernel.org>
CC:     Andrey Ignatov <rdna@fb.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <ebiederm@xmission.com>, <kernel-team@fb.com>
Subject: [PATCH net] rtnetlink: Return correct error on changing device netns
Date:   Wed, 25 Aug 2021 17:25:40 -0700
Message-ID: <20210826002540.11306-1-rdna@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: Iuj5a2nxjBmUszm265LEiUeUjZUI16tk
X-Proofpoint-GUID: Iuj5a2nxjBmUszm265LEiUeUjZUI16tk
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-25_09:2021-08-25,2021-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 impostorscore=0 clxscore=1011 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108260000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when device is moved between network namespaces using
RTM_NEWLINK message type and one of netns attributes (FLA_NET_NS_PID,
IFLA_NET_NS_FD, IFLA_TARGET_NETNSID) but w/o specifying IFLA_IFNAME, and
target namespace already has device with same name, userspace will get
EINVAL what is confusing and makes debugging harder.

Fix it so that userspace gets more appropriate EEXIST instead what makes
debugging much easier.

Before:

  # ./ifname.sh
  + ip netns add ns0
  + ip netns exec ns0 ip link add l0 type dummy
  + ip netns exec ns0 ip link show l0
  8: l0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT gr=
oup default qlen 1000
      link/ether 66:90:b5:d5:78:69 brd ff:ff:ff:ff:ff:ff
  + ip link add l0 type dummy
  + ip link show l0
  10: l0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT g=
roup default qlen 1000
      link/ether 6e:c6:1f:15:20:8d brd ff:ff:ff:ff:ff:ff
  + ip link set l0 netns ns0
  RTNETLINK answers: Invalid argument

After:

  # ./ifname.sh
  + ip netns add ns0
  + ip netns exec ns0 ip link add l0 type dummy
  + ip netns exec ns0 ip link show l0
  8: l0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT gr=
oup default qlen 1000
      link/ether 1e:4a:72:e3:e3:8f brd ff:ff:ff:ff:ff:ff
  + ip link add l0 type dummy
  + ip link show l0
  10: l0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT g=
roup default qlen 1000
      link/ether f2:fc:fe:2b:7d:a6 brd ff:ff:ff:ff:ff:ff
  + ip link set l0 netns ns0
  RTNETLINK answers: File exists

The problem is that do_setlink() passes its `char *ifname` argument,
that it gets from a caller, to __dev_change_net_namespace() as is (as
`const char *pat`), but semantics of ifname and pat can be different.

For example, __rtnl_newlink() does this:

net/core/rtnetlink.c
    3270	char ifname[IFNAMSIZ];
     ...
    3286	if (tb[IFLA_IFNAME])
    3287		nla_strscpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
    3288	else
    3289		ifname[0] =3D '\0';
     ...
    3364	if (dev) {
     ...
    3394		return do_setlink(skb, dev, ifm, extack, tb, ifname, status);
    3395	}

, i.e. do_setlink() gets ifname pointer that is always valid no matter
if user specified IFLA_IFNAME or not and then do_setlink() passes this
ifname pointer as is to __dev_change_net_namespace() as pat argument.

But the pat (pattern) in __dev_change_net_namespace() is used as:

net/core/dev.c
   11198	err =3D -EEXIST;
   11199	if (__dev_get_by_name(net, dev->name)) {
   11200		/* We get here if we can't use the current device name */
   11201		if (!pat)
   11202			goto out;
   11203		err =3D dev_get_valid_name(net, dev, pat);
   11204		if (err < 0)
   11205			goto out;
   11206	}

As the result the `goto out` path on line 11202 is neven taken and
instead of returning EEXIST defined on line 11198,
__dev_change_net_namespace() returns an error from dev_get_valid_name()
and this, in turn, will be EINVAL for ifname[0] =3D '\0' set earlier.

Fixes: d8a5ec672768 ("[NET]: netlink support for moving devices between n=
etwork namespaces.")
Signed-off-by: Andrey Ignatov <rdna@fb.com>
---
 net/core/rtnetlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index f6af3e74fc44..662eb1c37f47 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2608,6 +2608,7 @@ static int do_setlink(const struct sk_buff *skb,
 		return err;
=20
 	if (tb[IFLA_NET_NS_PID] || tb[IFLA_NET_NS_FD] || tb[IFLA_TARGET_NETNSID=
]) {
+		const char *pat =3D ifname && ifname[0] ? ifname : NULL;
 		struct net *net;
 		int new_ifindex;
=20
@@ -2623,7 +2624,7 @@ static int do_setlink(const struct sk_buff *skb,
 		else
 			new_ifindex =3D 0;
=20
-		err =3D __dev_change_net_namespace(dev, net, ifname, new_ifindex);
+		err =3D __dev_change_net_namespace(dev, net, pat, new_ifindex);
 		put_net(net);
 		if (err)
 			goto errout;
--=20
2.30.2

