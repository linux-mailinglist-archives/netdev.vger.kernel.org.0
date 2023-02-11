Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F30693412
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 22:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjBKVpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 16:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBKVpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 16:45:54 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2073.outbound.protection.outlook.com [40.107.21.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F0A12873;
        Sat, 11 Feb 2023 13:45:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mMMHiXY82ybkPGR9FXANgU8asHGUnxr+dRZl8qxcRDPfdcvc1uuoHRF+V1qG9B7uIlnAI4GOGnFc5k3CODIYOiN2oGbzFDgOI1VWHPnG7blWRfXnqhuGroSj3NIXRepZ26QatD1iLfObulmuTxsxL/ujQRDCY8+sf3atiZLBRXMvWAoFEOgFJcvHbT/8b4dgg/cS68/Hi3rkiwJ1aatKqfs+02etmL3kUTiIB3VtF5iclTZSVxoHEZzqgw3TSyXgA7A0XWwlRJ+N6foWjXjCYPEV/ze2RKYG8IwiOWbUrg5o9dSuUpQBnuxH5j2E+ly7ZtoZTzWtAWQk7ogG31oCnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OeKME+EOIHd9HGhrGd5WuGczpmELYh5cWW+4rQuMwJw=;
 b=Fv6j0u+QsOKfNqpn8OTUS9wJjq+DPpo0xhQJELcBGaxjHBZNQJfU4UPnGnbUTDoV4tgneWYnCB0OXRFHBfeQ/o7Iu/G4bSN68nkPDmpj4KCLZlrPg8zdC8LqLpV1XkukBKLnT34YIqyJbyRTB2g6iVQRbrZVVoXkALOHkRK/faKBNExCvxwdQzqGVoaqIu7vUhu4TzGWMGIiAYFtkPwh/BmWAIiuEEf4CkCuuJQw9nBjKKMcmuhAJQ5J4SVJArwJ0xWI9OCImc8E8Ewb4kW0ji+KJtJQW9lxRi5IvJIZoLbnceOjnbAWhFBlPkkAjqlEN5vYLHB7ek8OwPcrEtoLhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OeKME+EOIHd9HGhrGd5WuGczpmELYh5cWW+4rQuMwJw=;
 b=VVGswdYRsNvkPwAPkUTfjOs58zgTLVXu4LSqqZL/pmb7d3vco4cXygqAXkactrJZWRcmNWib5/rIh6NcQBvupQv5BtklM6ihxR0oEt0M25wWOIWLZ4AOfyOId3jo5gNZWp0vdi7R5YQUJrO3hFFtMisgADYWPwkiVyTdh0/loD0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7597.eurprd04.prod.outlook.com (2603:10a6:102:e0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Sat, 11 Feb
 2023 21:45:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.022; Sat, 11 Feb 2023
 21:45:49 +0000
Date:   Sat, 11 Feb 2023 23:45:45 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next] net: pcs: tse: port to pcs-lynx
Message-ID: <20230211214545.5tu5cfg6jcwy5njd@skbuf>
References: <20230210190949.1115836-1-maxime.chevallier@bootlin.com>
 <20230210190949.1115836-1-maxime.chevallier@bootlin.com>
 <20230210193159.qmbtvwtx6kqagvxy@skbuf>
 <Y+e1IfWcmHJjJlgp@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+e1IfWcmHJjJlgp@lunn.ch>
X-ClientProxiedBy: BE1P281CA0131.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB7597:EE_
X-MS-Office365-Filtering-Correlation-Id: f37f2527-928d-4ad7-ad95-08db0c7956aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UF6gkbGB9M4agTtd37OAOvN+yvjJUEmweulLPrB8lJLDWmXpg3/kvCKlyo6pefxzSxTchWbZnGFn9n8ZMh3HXGNNFDI7YeHihO/zkGFXpgEevxeOm8K/wYjir8EWNSYFXtbwpRAt5ocs+fgGDWuydleD79sdE4FGIr0VJIdYOD3Q4LIo70NcjAlqYOVcVQLMXbNxYI7Ay5LLdtU/UxU1jD/nT9NShiLQrmodhyMpjP3sGuBi3sbyHLCVRgXHBwvOE7xdUjEjULkxh/lbFT7OpJCpo29o7H2UQj5+AL8vZJz1aE05wK5ThKEiXJaCuffKwu4hv1WfB5KwjgA18XApX426+mu944yZNyFYFyG5LGF/qbrkflf9XMq3X1EEDzz5+JXpbrelUcq0TLnWHRmoZ8B9Kj4G0SAQYylX4kDJjO3oNDi0lNlI68Op3Pu5fTZJc7cXNtQ+SlVxZKOAL92YKlOMdT/ux16TIIyhQGBkh/cYYOlL03sIrT67VsUPMKhb/re8utMGfnAVtWg4DnWqxR7y8S3aXBelmBqH7IrVTP0F1fxmD1j0krm521PMW6FMeJcSV114vil1p8xrfLXHW56xIbibdal6VZDyWMEOMDw7Skaj/l1eIAAA2PQ2vVE15ApUtJU5AWm5GgeqrlTpyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199018)(316002)(54906003)(66556008)(5660300002)(8676002)(66476007)(4326008)(8936002)(6916009)(66946007)(4744005)(7416002)(2906002)(44832011)(41300700001)(6486002)(478600001)(6666004)(1076003)(6512007)(6506007)(186003)(26005)(9686003)(33716001)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xdfY3ppHIWqnnWl8xHVE3pBRuhlJe3finCYi3FftpItWxXNNsTMPdEAh3yO6?=
 =?us-ascii?Q?5iEt4EMMN6SwU/QlhN+tKI2JjHqjCh93qXR4xvwGjuHf+d1ER9UjcDzn5w8Q?=
 =?us-ascii?Q?jcXkE4KqD3fNtOT4eTni7Ni64qg0IqZgeiLdqFthmIuO07oWkFLH1KzW6DOP?=
 =?us-ascii?Q?r/+XFNB5tloVLTe8CkgYu9LLqhoU2CxakR9OXU2er+QxHGIe6/TSTsL4bbJm?=
 =?us-ascii?Q?FmPx74349i5q3MXapT2+rUFvzjjplvZScGm/80Sy++mImdTzfN+taJzRUgi4?=
 =?us-ascii?Q?dUr1nzXL9K2Uat6pEfkV2bNTWF8zo/vU78BxFMyWzxBfJ2kL/qFDnmsGBFL7?=
 =?us-ascii?Q?6PlRoCLwnrsJZlM+ZLUmu8DxB9h8D+lINmSWw59diqqIiwrTMVSxhsTFdpHw?=
 =?us-ascii?Q?ZL6UjNzXg4dazGQT5TQmNTyZLjnIkl87k+F6s/bptpB20gpW/LOwuYMzIiCy?=
 =?us-ascii?Q?qlHxkWkLB+8fY2nXi4QwDzDoH1LdX+0PCXX2ewKk46PrQelCQetrQ8+ZXlrZ?=
 =?us-ascii?Q?z6o75oYuUJ7mAE9AlpK7MeEr9gIoNrgp6VhkT9E02+pgQk8TxqeSL8qY1XOY?=
 =?us-ascii?Q?yhGZb4T8hORLIwFusWd/2IfRzygx3p3h/fsMe1xws+vVNO3vnAZP4n8ilFKo?=
 =?us-ascii?Q?A3FT+d3AlQlRTO8o8W75ppY7MhY7wyJ9lzuiOb3NPm3DmWEjCwai9e8ZbWAt?=
 =?us-ascii?Q?OxxvW/hFzB+qVlXcsc6fnx4auwQU6pxOa4t8jsQkG3G136fmYf0LJ2XqZ26W?=
 =?us-ascii?Q?K3lfzdYVfI2u8enBf+p4fZEDUfzTXpm5GuPgLII4PPcD5sdPFp7vfwPrHv85?=
 =?us-ascii?Q?+Z/wRDEJvjlIU/jzkpSZYAb9M1GoHgJsVV0hcolIXJBjiGH7H4NmIom+oKE6?=
 =?us-ascii?Q?R50m+4/2aym4HDPQT/SGBXGqic3+z1a38vXlAVm+QuwQeBtlm3Kq9WieySZR?=
 =?us-ascii?Q?+Gs9UVj30h1CiZiYJz5MquLhgjpvOQqAPcxxqdhLpVHwXOhyiRzSrGusqCSV?=
 =?us-ascii?Q?Ntjk/qJrqzREbH4IduI6nmfzEvCY/V5KMMpoBn66vvX49cd87s6dyeWW1ooX?=
 =?us-ascii?Q?l91rlEv3BUCzBIexcnfkBLrIjW3h06qwrf6IXx9UuBZkZO0KaOyKZSYU1xwH?=
 =?us-ascii?Q?vg76kJC40ppiW0BYjw7B4zhQ/+Ja3UIvT+CgDIc296BRi+mJqQ7NM//xwAfN?=
 =?us-ascii?Q?flKoAphKSv2z51x9sc/reQswTcI+zPfWgdKV7hV2bc3IyCu7FnzehdwJtp5T?=
 =?us-ascii?Q?qXJ8smcRUDGXFxy5+eVhef2Tn2sMkcT3HLgJc3mJbUuZm9o1ykm9dP0eNsAE?=
 =?us-ascii?Q?X8tx0RCN1D76BrDHmqnWQe/KNXUIJdFBEL7HdoNgM8viV3YIkE2Q/D1YGgiz?=
 =?us-ascii?Q?KukmM/DMtrWB6Is4JLZRi7X8ZPpFrztkF3KAOvtEHEcheAJW8LCqON55Rzyc?=
 =?us-ascii?Q?7onZWeUTEV2fcQBd1Uaq/qgSj1TuNSMYfMDbttz4VWe2MQBDtEnnyQxaOz8v?=
 =?us-ascii?Q?wvdD6iobcxmhrYpEqIQ279kQOrygD+f2Y7ZaDAbOnIznyVU4baZG/ze70wAQ?=
 =?us-ascii?Q?Gl/YKDj1b0gzafBZ42N0TcJynzeUZ8GSUT1zKkhmJ2mi2XWtl12N/aC7ngrT?=
 =?us-ascii?Q?/A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f37f2527-928d-4ad7-ad95-08db0c7956aa
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2023 21:45:48.9534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mYHD7TzV92FZusY3ZYE1uFUpL9/dQTFcA1ZYHh/5/EgEol5ACjVKehdAlFETdf169tYtYoyBsYhUz5M13R46kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7597
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 11, 2023 at 04:32:49PM +0100, Andrew Lunn wrote:
> Another option might be regmap. There are both regmap-mdio.c and
> regmap-mmio.c.

Maxime had originally considered regmap too, but I thought it would
involve too many changes in the lynx-pcs driver and I wasn't sure
that those changes were for the better, since it would then need
to use the more low-level variants of phylink helpers (for example
phylink_mii_c22_pcs_decode_state() instead of phylink_mii_c22_pcs_get_state()).
