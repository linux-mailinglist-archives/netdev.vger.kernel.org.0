Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 350A169A34C
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 02:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjBQBMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 20:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBQBME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 20:12:04 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2082.outbound.protection.outlook.com [40.107.7.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789B0498A7;
        Thu, 16 Feb 2023 17:12:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H0Yi0owBPlbdObuniIPsqktWefnXvHwnXl7FrmADimbrvp7wLbWYvXu8886PyxVuFYA0XtfTvEZhoDdyI9R4Sy20frnq+Cdidu9teGUSuhf3YYft25ST+NiNZlczHX6/Su19/wtvSL5xLYFnij8lR3R7Q4IrruvFfTpAFRSgpCTkf737650D/WLEzofkCUVhfUHrVgRPV8DLWRkr+uQB1e6n4DEgfg1PwUlq9gvvFQ5+VqiwnEdgG4X8d7Qpg0l0/MVguYgpn9TagOVunZeA4qt969xbuhgwHHl+Erpwd/+dhzQk5OcEaA6lwl6ppVAfqaUA71ljEXazmBfi4FFKbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rsv9SVNEXLz9Z8JipLWjdraLUe0F+X31ONNSHWU6kq4=;
 b=OcyIydeRYi9gInWGun6BKjdPEt0tiRb9H86ClwNUn1mnGtYNC8wiz0ZQSdCdI4IQBjRS19bJa080dNzpBv4xB/8xkXQiHICanpy2kzpOxzh9Fe6YuUUzrJ8WhN0OPGqOiQSYgPUNL0Qp+OOPNbWO1yhhB9UJb169klJRzNUbbAve9G3ZDNK/W9aG2/PL86cSb/tCFgI7+fOjl5IRDtXySsijTY2BNe3dDD5xBL4flYw96YCEAHk0wHKJaIEn4jj/sJHi1qaq2zsUSVf9PgRcxQXg/G59FBhI+r6yS6CqMU8+vPHkqHDf5HRGRgpGdFzVHaAjg/Cs0K9lyzFyDAh9cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rsv9SVNEXLz9Z8JipLWjdraLUe0F+X31ONNSHWU6kq4=;
 b=CKr6qC7xhSOm+Q1F1F8SRzLRpOQyZYJ08vNRiaHHXlXg3nR3/m3UEWzCC6/Prawrf5JF3l0KVcf8iA1jbP9f7aLaq2RqPgRXLhq6AAg6Gq8iSrIN8gdik0ll0cyC9Sh/HwSAXi7WVrwhFdIekqLFaV8cYdK0Mvg89gbecFdIulE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7380.eurprd04.prod.outlook.com (2603:10a6:20b:1d5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Fri, 17 Feb
 2023 01:11:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Fri, 17 Feb 2023
 01:11:58 +0000
Date:   Fri, 17 Feb 2023 03:11:55 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [RFC v1 net-next 0/7] add support for ocelot external ports
Message-ID: <20230217011155.4ztjsiqnzhvxvf3b@skbuf>
References: <20230216075321.2898003-1-colin.foster@in-advantage.com>
 <Y+4eLmpX9oX3JBVJ@shell.armlinux.org.uk>
 <Y+7NXoFTBYVG3/+b@colin-ia-desktop>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+7NXoFTBYVG3/+b@colin-ia-desktop>
X-ClientProxiedBy: VI1PR08CA0221.eurprd08.prod.outlook.com
 (2603:10a6:802:15::30) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7380:EE_
X-MS-Office365-Filtering-Correlation-Id: e5e360a9-dcfa-4dd8-6449-08db1083f746
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 59BN5+Nfb32bw93nmMDC2ZAUsPCGDkwo6DPk3O9AVVVKxZnqiWZDzaYWbza1ho0KLdkLmK6ppQW8e6nRUo4u502nKC2JXrScI9hUTzU6SbMeJDJ3qHhSbH8+r0+YIFuQPPkS0M3tvjFRXnbUaexpWe+JDHZmZ8uSMf3xvCjQSRKOllSFT1dglM6ebndDU7u6j7zxcRzvEJyvJ2WtYZ/q3FR+/fcE5K2EQQT7aZYdElVdKwUxkQ7S24kgTXltFQN3N7pWi5tkxJjgVoMIPUylEBpeMNWmlc2nhIRUaWpEALdXDCzzQucybuuNoeevqgaYvZNM9PYDCOeljZDTtNy+6I2weYFMkcaeYS8uzNdDCykfkHMWhd1LTAn4mSHA2HePAxD+OTw7H6JkwxjWuVRdR4J75m0XGI5iUqTnlwtOLMbM4HSrq1av42HpbHnNCcBYUA8rL+xXF2iYNIbEYadkA9QsQkO4uGbQ8Y7dV5IJBQVaSX0cwQHjXQC7C6jTyIJ2Qgx4tgVYW4UswfUeqgKLqg2roVztM41RpJ7r4nCLbtDUJ461cPRA9duPLNq4WF91aiBF7pnvxsQRIDoQ6LPI1JW1e0kTfyziyn5e/jr9f/tR8szsoGw7/Ws/hUYl3z4ro4725StZlbYJB3sl+PCm0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(451199018)(86362001)(4326008)(38100700002)(41300700001)(44832011)(7416002)(5660300002)(66476007)(6916009)(8676002)(2906002)(8936002)(66556008)(66946007)(33716001)(26005)(6512007)(186003)(9686003)(83380400001)(6506007)(316002)(54906003)(6666004)(1076003)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?invzcK0ImrdhGVqIMLvoJ9zw38z8VdPD9nRvh/WRqakAX+XF4ZHcELd/dlWC?=
 =?us-ascii?Q?aAEShTkR4tOsEi6uhRxTHR4wBhTo0OazQS9ey4n0BrTRNaWpXFBzTnRaN2EK?=
 =?us-ascii?Q?NoIaCiEeUDQrr+nG8H2h7kp32ujLvbWJIJzoIbolSNTrxW31/MYpmTyFZhMk?=
 =?us-ascii?Q?JvAv8JyxfHOUoQu2KOZ6alVxYBE5Ovsk7D1j1t7m3fKJJYfpPyASGKupRmAO?=
 =?us-ascii?Q?mVEA8rIb4sF/LNRjOLwGS0WJqrKmJhlSAaBkBP40TumedBMMTBO//9aH2k/x?=
 =?us-ascii?Q?mthtzZm8lN5VbTav2z+3q9uEQKPqOK6/jk05ze7Ho0n+m10qFwjxquDSLGsq?=
 =?us-ascii?Q?N8D3nrEo2ACPjKLydM5rex3BE2q7wWwakSsc29WBU2paCMrTozf+iTG25fiu?=
 =?us-ascii?Q?D+CHt8E2SgUk1VXQaMjzHuCCElKsIjY+XepRELmG0tKVyo4j1D5mI8a2zS2T?=
 =?us-ascii?Q?CS3F/6gncsVJj5aSACa8I5heV+7Wp7fKx5tpqmLxiObjsc3ur8nqa1+DPRy9?=
 =?us-ascii?Q?iPYQKUzrygdwvZ7sIxrjW+4X7oBKqIBpWNVswJD0ZTbEWiUyVxIs5LhSSFDJ?=
 =?us-ascii?Q?o0nadRAi0zd/Ux783klLfh9pIeQJG58BhAXGW/zNnOYsUhpnDbXxRjfIHE0F?=
 =?us-ascii?Q?bw37s/XSpd9juIbIIWUKgIEDAC36DeBMyKmPY2HC9BzT4lCjnIO7kMb/cyvo?=
 =?us-ascii?Q?TY31I51kTpyrhU3insd2SC7eLQC1rSYqIUnCGCSE4vAxGqBdOee5yrFYCvsu?=
 =?us-ascii?Q?5uBG/dW+/4zkhGz301rH3L8saYmf+y8R4YGqrGC5sykimn7cS91/iDV0+PeQ?=
 =?us-ascii?Q?KGSrrLuwhqLXjaY7SnXGufpbvH8yg3bSMiAUSMWzkXn+E2E6rrGP7I5STTkC?=
 =?us-ascii?Q?IGZjOaewuII63TKuTgzm/DDU5Dr6CyLhMregniclYNzI5eNp+RHpO5zpHPN6?=
 =?us-ascii?Q?5P//Lxu7brGf/OL2aT+5XSpy8eIbG+MZq+eTo9VGjUF/NQvv6VyBwZTe71Zs?=
 =?us-ascii?Q?CYvwpG2GI1rDyQIjN+MRrIu5hqyaNeGklzPVu6qWn1W47kIR+NeY4G2V+iqZ?=
 =?us-ascii?Q?fbIHvdZouQkVQqPi7wriHsZpTNPjaKor4szjkWR+cMUliImkNBKjIkmeIUdX?=
 =?us-ascii?Q?GBYej1kh6pBwDABktSsdHCuVAxD4R9kQwdx/kgG+3rDsvF/TP0wcZF51nHHO?=
 =?us-ascii?Q?OBqHIlWAXPlTwixYDBdVTCXzUCVQW8Xkv+eXaeUnHomIKCEOZJ7Pa+W4j1rt?=
 =?us-ascii?Q?5+B0z6ArwlmfdmSBGlRiyhH2SyGeSuVFRdOQGEfpCvBiXaSA2NakJRjAT2Pe?=
 =?us-ascii?Q?qO6cycAn9w9XpnkqA7XHTcpm3dTlIRM3rVS0IvHqxtOLyHrNiXcJXLJAZqlq?=
 =?us-ascii?Q?3Qsb6lcTAyAPKh0wJ+iviGuDoe9J0aNtVRPNDW0BUqxgSgYBOcL0+uwL7eeW?=
 =?us-ascii?Q?qSNUd4kKW9TA0le/8VkxGAKTvHhcrgq4dyzGIh58FVZ+6a2KKwN70D/crUyS?=
 =?us-ascii?Q?CA8at8pKyiZCThl2+MzvxR8MUJt1N8OHjbnUXRLPLKp2wS66ot4PbQzl/P/V?=
 =?us-ascii?Q?cS0NSIQ9m0k7cPqkI3vnY3vToDzYu4VIYARsEHY5Tvexm7XvA611E7nxNFBj?=
 =?us-ascii?Q?2g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5e360a9-dcfa-4dd8-6449-08db1083f746
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 01:11:58.0277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vhRUME4BADmIZG+sYYJclsUVW9nwysOYohruqn5BGhsmDqzUtAJj/9EBzmfKj6xn7WYRCaLcqxTIB8dr/TpAEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7380
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 04:42:06PM -0800, Colin Foster wrote:
> I believe the main gotcha was that control over the phy itself, by way
> of phy_set_mode_ext(). That needed the 'struct device_node *portnp'

DT parsing in felix_parse_dt() is not the only DT parsing that is done,
and certainly nothing depends on it in the way you describe.

dsa_switch_parse_of() also parses the device tree. felix_parse_dt() only
exists because the SERDES/PCS drivers from NXP LS1028A do not support
dynamic reconfiguration of the SERDES protocol. So we parse the device
tree to set the initial ocelot_port->phy_mode, and then (with the
current phylink API) we populate phylink's config->supported_interfaces
with just that one bit set, to prevent SERDES protocol changes.

Do not get too hung up on this parsing (unless you believe you could
simplify the code by removing it; case in which I'd be interested if you
had patches in this area). Each port's device_node is also available in
struct dsa_port :: dn.

> 
> .... Keeps looking ....
> 
> Ahh, yes. Regmaps and regfields aren't initialized at the time of
> dt parsing in felix. And the MDIO bus isn't allocated until after that.
> That's the reason for patch 6 parse_port_node() - I need the tree node
> to get MDIO access to the phy, which I don't have until I'm done parsing
> the tree...

Nope. Device tree parsing in DSA is done from dsa_register_switch(), and
dsa_switch_ops :: setup() (aka felix_setup()) is the first callback in
which the information is reliably available.

You can *easily* call phy_set_mode_ext() from the "setup()" callback.
In fact, you're already doing that. Not sure what the problem seems to be.
It doesn't seem to be an ordering problem between phy_set_mode_ext() and
phylink_create() either, because DSA calls phylink_create() after both
the dsa_switch_ops :: setup() as well as port_setup() callbacks.
So there should be plenty of opportunity for you to prepare.

> There might be a cleaner way for me to do that. I'm tiptoeing a little
> bit to avoid any regressions with the felix_vsc9959 or seville_vsc9953.

I can test those. I'd much prefer if you made an initial effort to keep
a relatively consistent code structure.
