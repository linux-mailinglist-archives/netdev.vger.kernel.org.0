Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3566628F7CC
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 19:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731378AbgJORtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 13:49:19 -0400
Received: from mail-eopbgr50057.outbound.protection.outlook.com ([40.107.5.57]:11681
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725977AbgJORtT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 13:49:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S9fWfHIbUrZUZdWfVjT8dcPQj/403iww3M2jCbkzUHfsZddEladOOuQqfXOxy/ReN4R+gP1WMzqviEuuEXl1lRmh7Jps6FeKb0IjmqKH3OfCQvkZVLzvVCiNb/k1sR9Qbikf04nVniR7L0Wz68zf/CcYo/Gjyk5RvxHZd8Jsp/AKhEzdQP2hFziE+2yKXMdkcwnS1H30uz8iTsTcDvyvzfSvRS/LawGy5zD7PapRkcV0YdqimCcgohb5uBapG99gBDpSaqWvMiXAkezmdAPNjn6UduUa2kIEX3viG3OCkStJ7+sKWOTe0WMZoswvCNjRKIZXphDx0t9O9NFWil96fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SLOrV6s97Ry0iwdu3RpTJSfKFrcfcJmqEfZC/VKfwFk=;
 b=QtWFuX6eEE/FVoUsCroQustyQqTW1fN/QkTmWZ95X7h0gJ4O6MMAvCpMX0i6HFB3H8R8GJxaYKwMUoBijFzsEhP3+zfSrE93w6/iTP5k2OWncR4vRcx8ik7Y9ANnvHQ2fgSIpvGNROkvP9cq1WaRvzbjoGxsuUgol40ALoaVsUM0OMHAh8Sgm4ZTcNjnFICy7HeLhXirPoOoJfWLdIbH/zfkQR5qRvEnLhCvZyYWceZuZTn07yV8OjUbj1UlAuDI5uIb5hpjv8pZ84YJH9580156LZlerXFu7yeTBkdy+6mRiiinshGouhUuz38gSguAMFaFRK7YOdwqygSXHdVMJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SLOrV6s97Ry0iwdu3RpTJSfKFrcfcJmqEfZC/VKfwFk=;
 b=dlq6wYn855QwR8iGdp04H45PmM5H6c5BGsFxDQaf/0O34zOjL0O1sE3aPozO5M60jct+67G0jmVOGHMgEsRnwD5DzVcoE35GRlEOjNVSs211kiG1pVF0Oh83KwUC7Jc7bk+/gV1zhPBbBxnSbZmoPuevM+cUUxQoRSnHDzlnXoA=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6941.eurprd04.prod.outlook.com (2603:10a6:803:12e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.24; Thu, 15 Oct
 2020 17:34:11 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.020; Thu, 15 Oct 2020
 17:34:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH] net: bridge: call br_multicast_del_port before the port leaves
Date:   Thu, 15 Oct 2020 20:33:55 +0300
Message-Id: <20201015173355.564934-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.174.215]
X-ClientProxiedBy: AM0PR10CA0046.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::26) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.174.215) by AM0PR10CA0046.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Thu, 15 Oct 2020 17:34:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 64559137-636d-4dc9-7e50-08d8713086d3
X-MS-TrafficTypeDiagnostic: VI1PR04MB6941:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6941EEBBED26AD3F4DC67B80E0020@VI1PR04MB6941.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lS96LPO4y8JGFA+nXL0vE+1kb/wMuf4wYhvexxfmkRx6wpPiJk8ZFgkGu1guefrpyHnWuhIJ6ntZ9C8iIw0g83n9swksKjTUYNxF+Iocng892+JVQKXA2OpMYWyKp42A0PJurmJVndfrXuqKHbcM60az4hj/9/5c7kpTzFN3+nozHG52l7up+bOgD5sdfcIdkCK+1ubQZm//MOjGcdyiJELva7CaQMNEYv5gzRlrCm2I7Y9FXMeyZDv3TLQbu8kn1/VCY4LSau+Jbfk8C1OhrI7l6YvujS+tp3o7T5LnmMhpCH65hfxItnvsWBpnT4nV7EtzGfh0IJ61HhMeJYhBdiuO3WdeOELHMjDHvzRE4DB0V2IvYcsFu8b5TMO8M4AuJGU8SgC+tMwX27B9YyPfrCRmAMEO5Gelcj4QfaZW6bM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(376002)(396003)(346002)(36756003)(26005)(52116002)(86362001)(66476007)(69590400008)(8936002)(478600001)(16526019)(186003)(66946007)(66556008)(44832011)(6506007)(5660300002)(34490700002)(110136005)(2906002)(316002)(83380400001)(6512007)(8676002)(1076003)(2616005)(956004)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3vJwU860ZTgFGN0GlcrwkateYfub8nbJ0dVJ6Yd8HIgMuWYoYr4i/DW2fY/4dU+UpSIulj1K/ruKUVgmRwAvTy2a16Qf0Ykz4FvbkUWamYetPsovGcy7cu89nMN6kH+C+v7PbCI7TcAYn4D4K9mGHTxZLIyRDrtOtdfwbjD0gqTCMmsD5K0EhdbroMwzH7wbuq59w5TozDaZwfKkkz1z53dnt9JBrfIFKHgVhSsEx1IZv/qGu70pBBDay0eJ5NoXJWfi4hkV2WW9S6qvEiqu7o+NSUVcoOpNo4g+I1xWxLgwvvtT1gmrzIdECP/NzZwH09empvj5xlmpSdstHXwbltgjMBHOcDSsvqJz6nHFfT/fGyBLkTBIb1ZOQCkCVR877nsRrw+izT1yYGlEH7BlNhee85nXknOm7qpU5zVjJ3KZlIC0MrUd3iHLKewT+10A+YFLq87KNrKGbnN6wVOzUV0bPq/I3EZ1+TmlFmjTJGH8Jnr8zxHFgk1E9WwHF6Ln1VMQ+d3h9xLnfdX05CrJ1Cftpg+iO6Sr8yVSEJbMFlK6x/6idfVsF4cvJ7S4C8AiZAn17SvrJZPHxb5/va18CIshSqSDHmR1Q9YOr0nDwRgCVkm3P0G7scQUxcZccsLiQ1f6kcBaGGuqvEirbsk/Rw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64559137-636d-4dc9-7e50-08d8713086d3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2020 17:34:11.0899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1bxS7WQsxf8jZmSTDGXhVEwcj7yOMdPvh0jS05ERMb+LZ+4yBwqSpOtgQuYGDKD1wmDjm1P2DMrlIKyEHkf3sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6941
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switchdev drivers often have different VLAN semantics than the bridge.
For example, consider this:

ip link add br0 type bridge
ip link set swp0 master br0
bridge mdb add dev br0 port swp0 grp 01:02:03:04:05:06 permanent
ip link del br0
[   26.085816] mscc_felix 0000:00:00.5 swp0: failed (err=-2) to del object (id=2)

This is because the mscc_ocelot driver, when VLAN awareness is disabled,
classifies all traffic to the port-based VLAN (pvid). The pvid is 0 when
the port is standalone, and it is inherited from the bridge default pvid
(which is 1 by default, but it may take other values) when it joins the
VLAN-unaware bridge, and then the pvid resets to 0 when the port leaves
the bridge again.

Now because the mscc_ocelot switch classifies all traffic to its private
pvid, it needs to translate between the vid that the mdb comes with, and
the vid that will actually be programmed into hardware. The bridge uses
the vid of 0 in VLAN-unaware mode, while the hardware uses the pvid
inherited from the bridge, that's the difference.

So what will happen is:

Step 1 (addition):
br_mdb_notify(RTM_NEWMDB)
-> ocelot_port_mdb_add(mdb->addr=01:02:03:04:05:06, mdb->vid=0)
   -> mdb->vid is remapped from 0 to 1 and installed into ocelot->multicast

Step 2 (removal):
del_nbp
-> netdev_upper_dev_unlink(dev, br->dev)
   -> ocelot_port_bridge_leave
      -> ocelot_port_set_pvid(ocelot, port, 0)
-> br_multicast_del_port is called and the switchdev notifier is
   deferred for some time later
   -> ocelot_port_mdb_del(mdb->addr=01:02:03:04:05:06, mdb->vid=0)
      -> mdb->vid is remapped from 0 to 0, the port pvid (!!!)
      -> the remapped mdb (addr=01:02:03:04:05:06, vid=0) is not found
         inside the ocelot->multicast list, and -ENOENT is returned

So the problem is that mscc_ocelot assumes that the port is removed
_after_ the multicast entries have been deleted. And this is not an
unreasonable assumption, presumably it isn't the only switchdev that
needs to remap the vid. So we can reorder the teardown path in order
for that assumption to hold true.

Since br_mdb_notify() issues a SWITCHDEV_F_DEFER operation, we must move
the call not only before netdev_upper_dev_unlink(), but in fact before
switchdev_deferred_process().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_if.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index a0e9a7937412..cdbeaf203b0b 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -344,6 +344,7 @@ static void del_nbp(struct net_bridge_port *p)
 
 	nbp_vlan_flush(p);
 	br_fdb_delete_by_port(br, p, 0, 1);
+	br_multicast_del_port(p);
 	switchdev_deferred_process();
 	nbp_backup_clear(p);
 
@@ -355,8 +356,6 @@ static void del_nbp(struct net_bridge_port *p)
 
 	netdev_rx_handler_unregister(dev);
 
-	br_multicast_del_port(p);
-
 	kobject_uevent(&p->kobj, KOBJ_REMOVE);
 	kobject_del(&p->kobj);
 
-- 
2.25.1

