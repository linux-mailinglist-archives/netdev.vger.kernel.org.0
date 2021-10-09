Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9D7427A0D
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 14:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbhJIM2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 08:28:22 -0400
Received: from mail-eopbgr70080.outbound.protection.outlook.com ([40.107.7.80]:19092
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232332AbhJIM2V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 08:28:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RA51rdfclXAw5USFa9Op31KKEu4TNbT8AgUrsR5WVulr1XZ1Nq12xQP4VrX9CGoV43MxQRzyh96skccvDaQP+gOiSq6lbOMGghQNLdqpFZdi1050U52evLUT0zXWbJqYL1Zq8vpFo1sFbrEzcr+QA2ZFms/S/EwcUyueCUQiaV4Y284ULeQkvY30F9LAbSV5FL+lw5AnosjzVmAFiVMCNGnUtggpJsFIDGu6Q20ttkmIPYBAtkQTg/4NVB0DHGu0WMencf5G5S+DAJYNNL9gMv9zgTy4UNUrHbhYEnXgNkKEKZaCUwh3oB1cGOHUiKxvJKBDSjtwpmivs+0HCHhz+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LtY+NnnubGBhIrrLs5toa6uoFcPf1jihgAHoBXIC9oQ=;
 b=C8sMexI0TlrZEjkEXz2kh1zqt7jOXQvdGdXTXlrPoIJKhWeJ1UA3zst39gPPZF4NerMjjbMFXZaQ8299uPiJAjZJnefRI8RGwjJQsq9CQbdfIehEQ+lS4VBKGZ+YrrAbUdPeSNDmYEBWh5Qy413Oml79PPa0YlRFcs7EMaSySLdfO6duhZMNIwZcMSPRenO5qZu5PuB/OUdaK3M45IuEp1pheniW1AqXrt4R6qPdJ7A1gQjjTYIfJ8LC8GV/AbRFiCkLQRNbTj96OMH5baZK8xSlkGrURpRUkeZ38wlDc6cHL2N73HxLTODe6QytyQ8NRmjddqhiHK6C2hpqPV0bXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LtY+NnnubGBhIrrLs5toa6uoFcPf1jihgAHoBXIC9oQ=;
 b=i3Pq4oPGmIJFcBkYdI4HryLU1eZz6ZW/FfUte85iHLYkZLDV3XNb3i8C9rRdo4V4Hwhbi73ATh20IbUGNw6BF/Nq4yfS/S5AofK7FoZAzNzodRQYd/bRWB4kqk0T6TuO6GX/VIvnR8h+AekpLcm7fPird+tJiW3/Jp+4cn48JO4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3616.eurprd04.prod.outlook.com (2603:10a6:803:8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Sat, 9 Oct
 2021 12:26:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.026; Sat, 9 Oct 2021
 12:26:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net] net: dsa: hold rtnl_lock in dsa_switch_setup_tag_protocol
Date:   Sat,  9 Oct 2021 15:26:07 +0300
Message-Id: <20211009122607.173140-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR04CA0028.eurprd04.prod.outlook.com
 (2603:10a6:206:1::41) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM5PR04CA0028.eurprd04.prod.outlook.com (2603:10a6:206:1::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Sat, 9 Oct 2021 12:26:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 614c0e63-b06a-4a4c-0b72-08d98b200026
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3616:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3616816EFC4EBDE0AA6EDF13E0B39@VI1PR0402MB3616.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HybcgkJY6ltMm75W4mW63WwtkT+j/Ooo3sO/XhARY+vvDrJj8NVfbEgnxNE/I8+aBw4dlBaWskRIbTmSRbR4tsXXupNujkuOGG7k0t0VO+Ifei/hocp1OBRlQ3vfA7t59Aed6tZVr8E4ys643eo3qwwhEwD98nQqre9c6U4gP6IVWnPZbTEoTUKRvhfurXAnAUqkWTpHsOPYkn1KvSyfLf8pwLWMWRvA92puWxevpInC4b2Ci62pLj1wmw2sWgsOkt15K/eNxolezLMiJ+7GkmvmhKnOPpAyXjQwRo13r2CKeLQ52iDRv9QvMk96gyUz97JVVYUZwrHMDfp82B9NXm+Z12CZmIM9NQdB8tHNreJ6MVBxqzJwdYoQ/T5LZlcs7SY9OzWMvgl8Ua5WgkNvZx1S6Z3bkS12zoXPEy65LjTtGG3NX1VokHhdKM8qNwty698iGTDNVac7fJs6PPK7OIVthxnIHQqLo9OHKNmVlf0iFtjc/hq/OA2ZW2JXJ7AaSDRumPB1ZNOJk5+8UGqTn+uMPy8wKOA4n+yVoxqTZxOkPgUZ6wmyBCzj7fbhF8Tpkcb1kTxAnbyU0R7QDcPGcLeq3taqTZGemZtn+N7Gzjr1PjYIIuTuPbJzckPNuXauxM/6+OnpxgergxQZlLBmnXlNPcS1LZ4ls4jJAND8zYVlJtxfpdUzQ0QLV20EeVvK85CF+h1WnqprX2HkIkVuoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(508600001)(38350700002)(6666004)(44832011)(38100700002)(26005)(52116002)(5660300002)(6512007)(6506007)(86362001)(6486002)(54906003)(4326008)(2906002)(8676002)(83380400001)(8936002)(36756003)(2616005)(956004)(316002)(66476007)(66556008)(66946007)(1076003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?thKB3ue2TFALsVF8JU8wrz4mM77Y0wHSyJlPm4KKOwRg+2LCH6d77UnJ/yYY?=
 =?us-ascii?Q?dSscROyDuwZirpqzHVvrtLUAbPw8ZITzGQG/c2g4krb8gdltVYI2Y/+Drr7B?=
 =?us-ascii?Q?1ErmhhJHtgWDvkt32Lujb7Cgh8KltOOgPbkQ4IaLXfyWTBMOioBejyE3M8Z1?=
 =?us-ascii?Q?aWw20PZdglcvjzj6q8N6PVDdPglmqY8+rwkPOp6RH0Ssbe0A738KfMV4E6F5?=
 =?us-ascii?Q?n7RxZ51wN3x6hbZANaqnWy5X+xtTVrGkLYURFp44swbSbkwrI3+J3rrwG+YM?=
 =?us-ascii?Q?tVT6IloaxCrAPtXo0HMuX7TccyvsoSkZBkNpFRWqHmLtJuOut9fa06DMKhvx?=
 =?us-ascii?Q?rEMK9R2vE0BfJ85czeboSU3cDOEvuB76EDMzdp1SvGamTEp3tESNL4ifYZ76?=
 =?us-ascii?Q?Myg4dLlhlcfCB/eGq+uSgo9PKnaIhLzvuKyFA/4eavuu+aXbjs7REth8r8SQ?=
 =?us-ascii?Q?yku3a7h23BeHycGaZamwvbYP3kzjEGw2P63whu+vJLnM4d/VjSywHrZPA1zO?=
 =?us-ascii?Q?Klz/FjQ36tbN4pnXtJDk84XrmdInft3DYkFMSiLgVShYZv1spm6HLD7ohvpl?=
 =?us-ascii?Q?NRYAeaqc0rg6PYlKwPnpEV4clNy0Iqtu97VKQZxLtM8iudkEApGiKB9vP2vN?=
 =?us-ascii?Q?yB1olKP6b6puJoOxatbnu8KwBon15KTBH2XH65O9NsSqk6K9VvJ+9Eadpjmc?=
 =?us-ascii?Q?PWsVckHxrlJW+i8eb7vP0xdEoGj19Ju/UQS+L6V/h8zEQzMYTiEfnUNFHgtZ?=
 =?us-ascii?Q?OCN/RITnVjSqmKgjrjU/1fubWxYgjiXnbPaRdAHzlndc43+a3RmzXWD1RCvd?=
 =?us-ascii?Q?xnZL7pfrWfhDHLiBI7xDwwOJsg0XzLD5eXzpYo0Ia51c0Ls0tX7tjFEPF5Yg?=
 =?us-ascii?Q?bTSj7tKgdNdJ1RU/iIcAm9aoeIThp0REVuxd+RwC8l/zRnHkWNeoSaFMtOfj?=
 =?us-ascii?Q?JveJWevWv7X5pz19ROPBW339JEV41TEiM6V6OKM7BQASREReeDizTXJvQKd3?=
 =?us-ascii?Q?04alh80d1UeLI9vAvfW/+cBlEHGS4GyIu/1kx3B+4HzE2BTBJOGVjqmVehUO?=
 =?us-ascii?Q?cyKsyBmB70+LLk6YNWcg730+u/wDa1CdsxH/KeIT0s0yhGK5eotWjvgzRaSM?=
 =?us-ascii?Q?jHUbiZ62x1TFabtAQMu5r348FjxcxxudIWArSBG+p9A4yr8KYCd9+13NE2gK?=
 =?us-ascii?Q?jdCBKhPe6Ohf3/dp5ae05WR5vsJmZ5pUlP7XbdAJiEjUCB1OS5pHd37B6rsC?=
 =?us-ascii?Q?+vXfSUIsaYk3GlMQ5v+oXSdboPWDM8qrUFPEXnqhV/bqRkneEQkaT3IujG0L?=
 =?us-ascii?Q?WF5W7FLcomWyCdi3an5I+umk?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 614c0e63-b06a-4a4c-0b72-08d98b200026
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2021 12:26:20.9792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uCqMX+2afp9OrVyUtlMXe3+WjSzdk4QUOArGhxQUIVxeGS+idB0NdnbGqwMAwbdSIgshGA5a1HL7CyNsDLYb/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3616
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It was a documented fact that ds->ops->change_tag_protocol() offered
rtnetlink mutex protection to the switch driver, since there was an
ASSERT_RTNL right before the call in dsa_switch_change_tag_proto()
(initiated from sysfs).

The blamed commit introduced another call path for
ds->ops->change_tag_protocol() which does not hold the rtnl_mutex.
This is:

dsa_tree_setup
-> dsa_tree_setup_switches
   -> dsa_switch_setup
      -> dsa_switch_setup_tag_protocol
         -> ds->ops->change_tag_protocol()
   -> dsa_port_setup
      -> dsa_slave_create
         -> register_netdevice(slave_dev)
-> dsa_tree_setup_master
   -> dsa_master_setup
      -> dev->dsa_ptr = cpu_dp

The reason why the rtnl_mutex is held in the sysfs call path is to
ensure that, once the master and all the DSA interfaces are down (which
is required so that no packets flow), they remain down during the
tagging protocol change.

The above calling order illustrates the fact that it should not be risky
to change the initial tagging protocol to the one specified in the
device tree at the given time:

- packets cannot enter the dsa_switch_rcv() packet type handler since
  netdev_uses_dsa() for the master will not yet return true, since
  dev->dsa_ptr has not yet been populated

- packets cannot enter the dsa_slave_xmit() function because no DSA
  interface has yet been registered

So from the DSA core's perspective, holding the rtnl_mutex is indeed not
necessary.

Yet, drivers may need to do things which need rtnl_mutex protection. For
example:

felix_set_tag_protocol
-> felix_setup_tag_8021q
   -> dsa_tag_8021q_register
      -> dsa_tag_8021q_setup
         -> dsa_tag_8021q_port_setup
            -> vlan_vid_add
               -> ASSERT_RTNL

These drivers do not really have a choice to take the rtnl_mutex
themselves, since in the sysfs case, the rtnl_mutex is already held.

Fixes: deff710703d8 ("net: dsa: Allow default tag protocol to be overridden from DT")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index be9ea9a3e2bc..58f7dce0652c 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -827,7 +827,9 @@ static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
 		if (!dsa_is_cpu_port(ds, port))
 			continue;
 
+		rtnl_lock();
 		err = ds->ops->change_tag_protocol(ds, port, tag_ops->proto);
+		rtnl_unlock();
 		if (err) {
 			dev_err(ds->dev, "Unable to use tag protocol \"%s\": %pe\n",
 				tag_ops->name, ERR_PTR(err));
-- 
2.25.1

