Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A163DCE13
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 01:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhHAXR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 19:17:56 -0400
Received: from mail-eopbgr50085.outbound.protection.outlook.com ([40.107.5.85]:49035
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229990AbhHAXRz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Aug 2021 19:17:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b1B0TDHN1VzXO6ts7le+2JwxRCcOYoNuU8Xi7GvU8cu20w9I45oQnE9E97tsC5mk3pVzZZRo82tCO+4l5r1viw08mO6AJS6LYcEbaopU6+sg2PxdGFFO1fkhRfFYqFmvJTnpp4a7IJ0H3lGmSutFz1NbIx+iCqWcFCLAJPCIwxMHvXomjVccUPYNHddVW3H3vWfdmchB9g8Pnn+9fPB44sfwO5Xg9ytE3INyWNIrC2QvtF/dGUc5TyKv+s689ZQtHwpEnMKKjn02dvV7ZD8g078jrhdn69f5s/y1BU/jUQ5WmZ2uPA+7ciI/HS6LvylbcK+C5LyqNEpVy6fFhGfQnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+vBKU578/NOgzhCq08tPezZ4CiQpthseCn3vP7eUHtc=;
 b=OwwYVYEb8MwnWbLm2tEG7aXBckVjXqI0zxBEmAzKvRuNI6SPtuYnw+J5JZLpVazjXP+VAeSxa/fhDNoX4Aya3WhB7AT1iGGA+UbiQnAaSNBwlRND9jR4R3/jrsmYJ40vlSZ1Yx9yBka6EdKII3CZxunkg9J+SUVCd04K/Jwca6GT2Qt8e155kqMzd/cpzXq+GkicmSEDOPh6F7q//LvyEV/JsJD8l4z1ufGDfdWjj3dSf8dDXqSPCqm9j4jD130iM+HG8OQfUpBVkDrxpzziLmYHFKoxG9baIH7jGA+RGDgtAr+sAMXKvaqAD4PpImuNzromEAJJeRY+fgJU//OR2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+vBKU578/NOgzhCq08tPezZ4CiQpthseCn3vP7eUHtc=;
 b=VAaEviyFmGIVSBvW0ZytKjx/t9/Y6WWxdDIkNhHf5ikqFCvfQZgguesjaxnfwxlXnHWWiTOV5xllOunO3gyRTGJm13KcTQOO+40niTsP5JNALpWRqkUkFrtHb+6Eb9bGgocEuZVgVGiXDFujoNiLoV06ggNRoNO6RxLG/v7+Rlo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Sun, 1 Aug
 2021 23:17:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.026; Sun, 1 Aug 2021
 23:17:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jiri Pirko <jiri@resnulli.us>, Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        bridge@lists.linux-foundation.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com
Subject: [PATCH net] net: bridge: validate the NUD_PERMANENT bit when adding an extern_learn FDB entry
Date:   Mon,  2 Aug 2021 02:17:30 +0300
Message-Id: <20210801231730.7493-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0051.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by FR0P281CA0051.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:48::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.10 via Frontend Transport; Sun, 1 Aug 2021 23:17:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e12ba5b4-2db8-4c56-38b3-08d955429016
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5136E4A078DD2FB8C16DED9BE0EE9@VI1PR04MB5136.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NYEFKeR7ayzrX4GBoJrhk2khdksRaLrOVumNtTM3eYrWlFsFrwix6JShzdJ8ucgXgK5bJHWyzL9MbK8hmkOVsJsHTLY5YYrEicAxCdGnT4DZVUQgxQ7Hx8yrTYsGjFwwmsM/+bVegB9DaSfFiQwd389FyCGJ54f2e/HTs9LqUDB8FRst9ZnEp4F0MSPkomuayvEZRTZXrO92m/Z9feQ5sO9G+rrNAc4eZS77P3lZeXHItJ3q8tPb1Fu1AaJH378DR2620SRU+WEcEQd+gNR8tf0esJBkcD3i1Q7spb0NG7Y54YiWGL0ektdl0k8Qc70sLefjqZxHgIlkDwH7ZlRP8HbDQFkI35hTWTC/iuPPaKJCpjo6ykgMbBlq3m+OLYi6WQNYHsLeom65JRftrjoSA7RTf5TPRuPetOKw0/N23JQnBt+KwR4CfYth+KeuF60vmPRfeu3BXP91WGcNbiaKanLj9A9PTWK1mpHy5/PrtY13JkIfyNyXcNKXbeo/dzUtUpi56dz3xBkG5dX3A7E3v4nEQsUQ4Q0vobqVno6zP92d+AeIdK8YEgR7c4h+tCD3K1E0cL3ylscHJDzyJxvZxkLhrZWzo5qiYZBxs0uDOPQK6aC/QpjaLH/UhkUEKcSS1WBaHwNngiBQ66qXfpdwkYvehSCvCWLO9+NCi/eXpIrBVSdkHd3YgJdGdWE50xJi45b0RgA96kn+UXKIgz8ySg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(366004)(346002)(136003)(7416002)(86362001)(6512007)(83380400001)(186003)(316002)(4326008)(6666004)(956004)(52116002)(2906002)(5660300002)(26005)(1076003)(44832011)(6506007)(2616005)(54906003)(8676002)(110136005)(8936002)(6486002)(478600001)(66476007)(66556008)(66946007)(36756003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jtZO8umluMJjAMn9BtFmRDjSvpO+0RKVBykXCCWd7vqgbKS4qT1M8vG3FmQ0?=
 =?us-ascii?Q?q3VE+8ibCrCcwYIaxZNax6EpFA8Nclf7Af3dhp9ehHPr2pL69W6m8D3GPcw2?=
 =?us-ascii?Q?9uUKsA7ZDxek73jBsN99DNUL/x2SZ8iJe/IrsUciAsfxQ7n8J7BTWvmdwyvA?=
 =?us-ascii?Q?aA7Y5GuWGvhRLE2eSXn28Cm6hn8KXm0diRaNCcMFYqKF2ZYNy6qs+GWS/YJh?=
 =?us-ascii?Q?NVZj7evIrU79wmoYdSvWe94HhQY4FHB+iIDzqtUr+wJlHjhvy9ZMbRciNSAT?=
 =?us-ascii?Q?0rmQL77Xd5y0AE+SiisqF10dSEaNMzTVuQYuzo9t19AA14quK/vXpZ+6va9Z?=
 =?us-ascii?Q?EGy5YSSx0xS0GgBP1ky2eL+5ocO3IuguRmaq+b3FST9S3nwHrPa+bDiwwc5+?=
 =?us-ascii?Q?cdaFwgfdKL0rRCgfNRmIhln52zuWYdS2IF5ZTlQAJ4ArpMmtojTaLigfIcog?=
 =?us-ascii?Q?qybXlvFziVCU29xPZ8LiEomdDh1k3zrX4ad2/hkdmobQAolEK7jHeW1bOpMG?=
 =?us-ascii?Q?GGEhUgDGya1WUZvCtkLnvfmOKixa9zY6SlBfIqSmziSJ4Fa828XTNTwLD4gl?=
 =?us-ascii?Q?Qp1iwntsNHNjNWCKKS3HDn+ZH1RuFP4DeLiRj4wv3C2a6/UOBP/eTpYFOCQa?=
 =?us-ascii?Q?blm4uQR4NmauJI+5eqjtobYnjeGDvi0a4GG5Dp6wvcVyAEg3hl5BbKYlOQMD?=
 =?us-ascii?Q?viYfA9OfwESPUz0SD/9HqpadjrZ6TCRFUazeG/CaR2w3i/iNCKgSQBk+5ajt?=
 =?us-ascii?Q?/Hxcw+OLGrad4hX6SGbhcLuYr2/nfGfXzA5hQo/hEaDq1jxWDKvrQKV8lsG+?=
 =?us-ascii?Q?g8dBqDZ0ivzbvddIs79BW6PQsKxS+58ML560eftsgo6pjRwkgIRftrUofgxY?=
 =?us-ascii?Q?/tCEkbG3LNJ2i1mLwgOqwj9rYahtJ9A6OUnflkVquXLGV3u8jGxvTlHFgFH8?=
 =?us-ascii?Q?i5FDn+0tZ2K8LjMSKa1lwhpvRM9Ybm9RZS0NNjpS1ChGJdTCjQuKWpYxlFKp?=
 =?us-ascii?Q?SF+ddT5M7kYO09zxjO08if1oeMXA7rD2qGIbx8wTnh3XOJVgnL1783FTWmXx?=
 =?us-ascii?Q?N+N+NHZGCm9wQPgacpOUI3uuIkGWKxILs5yYWpdQPJ/0DmYpePQiUxgJ01Tf?=
 =?us-ascii?Q?H47UHdwnqAJrwFIIx+jKLfOTY2PHSPvU9lDAYSIxTcx7o/vk09Q9IaAi1a0F?=
 =?us-ascii?Q?kobkBRQtsTu7EodjcmBfq0+hbm8IYpEGuxFgUBP/3Z4Fyar6Mj0TgpFUrUPz?=
 =?us-ascii?Q?tqWUk97fvv9QuJDbZ6MVxVNxHkR04GMECedwoJJJsBDHj5s/8/c9rU7aYI7L?=
 =?us-ascii?Q?27oIdsEDnjavPw9A8638tsIZ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e12ba5b4-2db8-4c56-38b3-08d955429016
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2021 23:17:42.5782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eE0OXtQXdiB5C/uRXumoCXN14v+IqoI7IYjh7w3VRUZvrPDk9IU0BhDVZMKCXLKq7pjwpSFfsPbiHNMkvGuENQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5136
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently it is possible to add broken extern_learn FDB entries to the
bridge in two ways:

1. Entries pointing towards the bridge device that are not local/permanent:

ip link add br0 type bridge
bridge fdb add 00:01:02:03:04:05 dev br0 self extern_learn static

2. Entries pointing towards the bridge device or towards a port that
are marked as local/permanent, however the bridge does not process the
'permanent' bit in any way, therefore they are recorded as though they
aren't permanent:

ip link add br0 type bridge
bridge fdb add 00:01:02:03:04:05 dev br0 self extern_learn permanent

Since commit 52e4bec15546 ("net: bridge: switchdev: treat local FDBs the
same as entries towards the bridge"), these incorrect FDB entries can
even trigger NULL pointer dereferences inside the kernel.

This is because that commit made the assumption that all FDB entries
that are not local/permanent have a valid destination port. For context,
local / permanent FDB entries either have fdb->dst == NULL, and these
point towards the bridge device and are therefore local and not to be
used for forwarding, or have fdb->dst == a net_bridge_port structure
(but are to be treated in the same way, i.e. not for forwarding).

That assumption _is_ correct as long as things are working correctly in
the bridge driver, i.e. we cannot logically have fdb->dst == NULL under
any circumstance for FDB entries that are not local. However, the
extern_learn code path where FDB entries are managed by a user space
controller show that it is possible for the bridge kernel driver to
misinterpret the NUD flags of an entry transmitted by user space, and
end up having fdb->dst == NULL while not being a local entry. This is
invalid and should be rejected.

Before, the two commands listed above both crashed the kernel in this
check from br_switchdev_fdb_notify:

	struct net_device *dev = info.is_local ? br->dev : dst->dev;

info.is_local == false, dst == NULL.

After this patch, the invalid entry added by the first command is
rejected:

ip link add br0 type bridge && bridge fdb add 00:01:02:03:04:05 dev br0 self extern_learn static; ip link del br0
Error: bridge: FDB entry towards bridge must be permanent.

and the valid entry added by the second command is properly treated as a
local address and does not crash br_switchdev_fdb_notify anymore:

ip link add br0 type bridge && bridge fdb add 00:01:02:03:04:05 dev br0 self extern_learn permanent; ip link del br0

Fixes: eb100e0e24a2 ("net: bridge: allow to add externally learned entries from user-space")
Reported-by: syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br.c         |  3 ++-
 net/bridge/br_fdb.c     | 30 ++++++++++++++++++++++++------
 net/bridge/br_private.h |  2 +-
 3 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/net/bridge/br.c b/net/bridge/br.c
index ef743f94254d..bbab9984f24e 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -166,7 +166,8 @@ static int br_switchdev_event(struct notifier_block *unused,
 	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
 		fdb_info = ptr;
 		err = br_fdb_external_learn_add(br, p, fdb_info->addr,
-						fdb_info->vid, false);
+						fdb_info->vid,
+						fdb_info->is_local, false);
 		if (err) {
 			err = notifier_from_errno(err);
 			break;
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index a16191dcaed1..835cec1e5a03 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -1019,7 +1019,8 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 
 static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
 			struct net_bridge_port *p, const unsigned char *addr,
-			u16 nlh_flags, u16 vid, struct nlattr *nfea_tb[])
+			u16 nlh_flags, u16 vid, struct nlattr *nfea_tb[],
+			struct netlink_ext_ack *extack)
 {
 	int err = 0;
 
@@ -1038,7 +1039,15 @@ static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
 		rcu_read_unlock();
 		local_bh_enable();
 	} else if (ndm->ndm_flags & NTF_EXT_LEARNED) {
-		err = br_fdb_external_learn_add(br, p, addr, vid, true);
+		if (!p && !(ndm->ndm_state & NUD_PERMANENT)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "FDB entry towards bridge must be permanent");
+			return -EINVAL;
+		}
+
+		err = br_fdb_external_learn_add(br, p, addr, vid,
+						ndm->ndm_state & NUD_PERMANENT,
+						true);
 	} else {
 		spin_lock_bh(&br->hash_lock);
 		err = fdb_add_entry(br, p, addr, ndm, nlh_flags, vid, nfea_tb);
@@ -1110,9 +1119,11 @@ int br_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 		}
 
 		/* VID was specified, so use it. */
-		err = __br_fdb_add(ndm, br, p, addr, nlh_flags, vid, nfea_tb);
+		err = __br_fdb_add(ndm, br, p, addr, nlh_flags, vid, nfea_tb,
+				   extack);
 	} else {
-		err = __br_fdb_add(ndm, br, p, addr, nlh_flags, 0, nfea_tb);
+		err = __br_fdb_add(ndm, br, p, addr, nlh_flags, 0, nfea_tb,
+				   extack);
 		if (err || !vg || !vg->num_vlans)
 			goto out;
 
@@ -1124,7 +1135,7 @@ int br_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 			if (!br_vlan_should_use(v))
 				continue;
 			err = __br_fdb_add(ndm, br, p, addr, nlh_flags, v->vid,
-					   nfea_tb);
+					   nfea_tb, extack);
 			if (err)
 				goto out;
 		}
@@ -1264,7 +1275,7 @@ void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p)
 }
 
 int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
-			      const unsigned char *addr, u16 vid,
+			      const unsigned char *addr, u16 vid, bool is_local,
 			      bool swdev_notify)
 {
 	struct net_bridge_fdb_entry *fdb;
@@ -1281,6 +1292,10 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 
 		if (swdev_notify)
 			flags |= BIT(BR_FDB_ADDED_BY_USER);
+
+		if (is_local)
+			flags |= BIT(BR_FDB_LOCAL);
+
 		fdb = fdb_create(br, p, addr, vid, flags);
 		if (!fdb) {
 			err = -ENOMEM;
@@ -1307,6 +1322,9 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 		if (swdev_notify)
 			set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 
+		if (is_local)
+			set_bit(BR_FDB_LOCAL, &fdb->flags);
+
 		if (modified)
 			fdb_notify(br, fdb, RTM_NEWNEIGH, swdev_notify);
 	}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 2b48b204205e..aa64d8d63ca3 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -711,7 +711,7 @@ int br_fdb_get(struct sk_buff *skb, struct nlattr *tb[], struct net_device *dev,
 int br_fdb_sync_static(struct net_bridge *br, struct net_bridge_port *p);
 void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p);
 int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
-			      const unsigned char *addr, u16 vid,
+			      const unsigned char *addr, u16 vid, bool is_local,
 			      bool swdev_notify);
 int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid,
-- 
2.25.1

