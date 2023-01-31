Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBF66825F0
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 08:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbjAaHzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 02:55:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbjAaHy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 02:54:57 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2057.outbound.protection.outlook.com [40.107.13.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C49265AF
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 23:54:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jF91ZQkb+vIqR9nW4N1LrcV6Xcgt19ZdPdhzJovmpltMlDvfJ+I6iB29DsDCFWDV4EGboOBgWjiIcGSfIBniVakqMpymecG7LGxZfLEqdD5jhCujsoWiSVENlkPIAtjU/22uhSKiVNsUkppK5BKNoSVSxToEOl2nCPkWfWtPWbC31Een2VhxGw3dew0eygJezZXZuCZ6sZNOHOhoOS6tZdt/kruSq2MhhKz7Abn+omKbCK5MKWR15Eqxb+lO1JLLeKfHLFuV18QjbZWEr5fTBFf8EMdeyfkuE+DIWLFVO4R9/FgdsCb8ljPnSewBi2VD3QTzX9dcFCNS+aJVHVl/7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Clf+4MwVTYpf4QD/lQxXa35g37jLQ2HLt/dO3A0Igyw=;
 b=oOhGNlLXCc6C1HJbW1KHN/MZpVOg8iv+fcFRYcbtNNiTJwehF0YAc8GjbLNlLqIdp08L9kLhdOW4uvdbin5VcT40Q+3ZIi34RUfmNcHZqMbriVZUsDukIhKSy3Q/f90CC0rHXJKRZtnoQHsXOljd/gTsON8Yqd2q2LQflwM/nHDFo4uJsvwX+z3RsgyD7F/DAec8DebFQhY6PXwa1LjaD4JBbQumCl2/OPvmawmFaPRgfGR+BAlibTbba0EAQ2gO1Kt512UnhqV1wbgANAm3wpxXdR72a4edkyN/kOfXT03nO6BLQRerXFlXnUtOOmGqFpL2ZJLJcL7fwteEAYmsdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Clf+4MwVTYpf4QD/lQxXa35g37jLQ2HLt/dO3A0Igyw=;
 b=Ya2GLC0Dk6QBicoQfABDpzvCeBXj/mebQa2QITUdtDzQqJuCelm62h1/wuRGrz5QY9kLmddnsW2BtC6DVCTcO7kF9mL+C1wQLbQaLkmtzWYwFl5Repn5fEGQMbyynVy1cHFqBKJgoEh3vrxBKSRrle2F4NcLWebpELQ361zPXqs=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AS8PR04MB8401.eurprd04.prod.outlook.com (2603:10a6:20b:3f3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Tue, 31 Jan
 2023 07:54:51 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::ef98:3174:3c92:d2e]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::ef98:3174:3c92:d2e%5]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 07:54:51 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: RE: [PATCH net] net: fman: memac: free mdio device if
 lynx_pcs_create() fails
Thread-Topic: [PATCH net] net: fman: memac: free mdio device if
 lynx_pcs_create() fails
Thread-Index: AQHZNOFjg710C4RmREGQDNCyLWYsEK64KE8A
Date:   Tue, 31 Jan 2023 07:54:51 +0000
Message-ID: <AM6PR04MB3976C49C0FE000A571DA6CA7ECD09@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20230130193051.563315-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230130193051.563315-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR04MB3976:EE_|AS8PR04MB8401:EE_
x-ms-office365-filtering-correlation-id: bc1f7015-39d0-44b5-7545-08db03606eb1
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YwsoLJNpQr1tNEFhtN5UdTv2yoC52xpx7UM8ERXDPq1iSeoDE13ad/17/CUpxfkhS4qwUN3mh9KV5oDJxFp2A6FddXvHYe4xGVmctEUgpphCOjOo7PN2rfs5MKY/g2qlc2aq1IjcjDigpY2BMrxnnyxGYOTkqS/QlzWlBwp7Zsb344mk+1/Y2ixXrqRmrKvidNFNocjzmmfrKpLzZuc8QEzqHcuq03uJ9Z5TE5xbu4wCoLcQS+eP4iV5YF0an7o1ZqVYnvJ9TTxCQzyHHwCKDPj5D7WPyHGgrIdki3i1qzMOLodYjQP6jZbSTAmnzoE4kaL7VgNQFTPPZoEiT49wzNBwcA1kPeZ6Nc0ja8X2DDFQzpdTAlY5XyAw/o++7gqZDKgPe6uPV0/3cbLscOXiYeHXEFCcuFIqDHrjGh6rQhGB+tEuNeYPEkpc99RDdpq44dsldqRKHJpAabkuddttpjc5SREXdQKpW7w9BtCkSMIqbaQLD3+NByVIMWv+LsMot3puyk7pGPVhSTh3UqemUJLnkktN+d++oxORl8LCmtm/wxlaUAIDRTw1g2kbNq7wSBCNP99A0DrG2q6DrfijwUYHikC4Ms51A0zjP3VMJX93Z51Za+FARkAZ5LbaT2Kd4hgeq3+G3qDG1EMSEDPZopyO2hZtfzxLIKGMQCj1w+0yJzoWnd994+Yjdcjzyb1IiK8hqeMzBt8Lgf3mH01TOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(376002)(366004)(39860400002)(451199018)(41300700001)(66446008)(66476007)(66556008)(66946007)(76116006)(83380400001)(64756008)(8676002)(4326008)(316002)(52536014)(8936002)(9686003)(122000001)(4744005)(71200400001)(55016003)(2906002)(33656002)(5660300002)(54906003)(110136005)(86362001)(478600001)(7696005)(6506007)(55236004)(38070700005)(26005)(186003)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cKwmIYhqeXQuPPm/Ey05hXctV9iAUHiuaDB6tivgGETdK7Uu59Wg0k5blOmR?=
 =?us-ascii?Q?286b8FlCYkaW3Qe7Gb2zZfJjyv2K64cm9hN5OtzAzV8loj3RkCihqc80Ntr4?=
 =?us-ascii?Q?4YbiaWArzlNxJGyyEgrSyqrpbYSMshen5uQeBqnxnI1horAGxbnRwNxnS5Hd?=
 =?us-ascii?Q?Afw7rN197PmDCZJW0a+hg8R3n+f3JT2cg6uicGbYkS4AVSDVpt4PVRZsGpY2?=
 =?us-ascii?Q?rrO4F+oUc+Ef12fczBiwWoyz5RoUSUGfrrVRYZXeJk9h8KHUvSH2CoCNrOoR?=
 =?us-ascii?Q?eK3LjWTkPH43LInE5U4DYRRy8q+6ogFb0uoUrCGUQe7n7SzBCaX3nlnpqW6f?=
 =?us-ascii?Q?lUW4Gjjzq7RRo4Ke6qY2a2rsYCiLyeNRNjCBmy8N9GkpkNRTI6cZgiW3lhlD?=
 =?us-ascii?Q?3BQ/VxAst4eMo979KAkw77DSN3MKTKRXv+Ha8Z4GA6n4sw/63gqrE8+NpFmN?=
 =?us-ascii?Q?Oms/XEuXWD4TT+hteQy0/PqVGtrdqqe8xevO2kASDRjuLDUVNqg5jcRYSQ3q?=
 =?us-ascii?Q?9Uh6HnRAQC9fRmB69/7u5k5UngJjyekDcCQ98LurBHi/fq3UgIs9Erp50vUc?=
 =?us-ascii?Q?etOJzylPM3yYvZDzDLtIoDjEC8sp5UxQtW6CVZ2FdZVu/xxxiIm+n+wqb5jc?=
 =?us-ascii?Q?/botA9RDKdf4Z2aTFPvja8iVTU8ItGld4qKmh6azm9UUtil5ek+FEAyW2B6v?=
 =?us-ascii?Q?/uxKvIL8caJsEQatCMA1TEXOcDlKWrQNhhDT2NeeLzmW2a0L2PNgrqiCxp1s?=
 =?us-ascii?Q?x62xbm60cbZaX3ScME/5h7dniV9dyUeXUOZgJj8K7L+bzXmnQP3WbDjN5Hqg?=
 =?us-ascii?Q?ohBT3OrI/hWS2Kg18htdGt4PGp3vd37jtq4OlAfFzJMKDtK+fhfkHk6ccjS5?=
 =?us-ascii?Q?7LCPSb7sXPIOtfreO3Ip/Ui4CAueCUT8d7w0zYSrBVXp7jtUOP89GPBHY+O8?=
 =?us-ascii?Q?r6AOXBnaHKY7trjbODVt0jIclehJriIwzQAC/kSojwaKR0HlcS7a52WB3q9x?=
 =?us-ascii?Q?731/NuozMOTKJgn/AuN2dCznxQhcGdDw1C7D772mIN1C7dc6XEJ+/+hr6rVX?=
 =?us-ascii?Q?NGzFYNXUF955TfyFCS68/2Wg4CeqSdPsbXks4QmdjtP40SC6K7o9Pi773G5T?=
 =?us-ascii?Q?qDRKLhpZa3pU7IbYMTvlOv5o5WPkKlZ+J6NfVN2RIuAUzzAWRI0O+b131nza?=
 =?us-ascii?Q?q4jT6X5+RinZjeXxWE5ojz2MjedstIYNC3JU/L/18ZmwEi+Hajz8dhyrApDb?=
 =?us-ascii?Q?VZW2i4IboRvK1iXoYz+RYxiSyG/8TgPZwDcjbzdNwn17DBc94djh8kp2JSDd?=
 =?us-ascii?Q?mQbcHbNgYznfBXaT586ZyehSlRWt5+DIl3PhDLvoDMrXDsh61WA9SyqCNY1y?=
 =?us-ascii?Q?lb2AlYN6r/8Ku3Jg8f8E06VeLofNd0+1QA2RNYSXpaNou7NJQebmIu7CTcuf?=
 =?us-ascii?Q?5AtYjWRwbyJNJJsm7YvTch8WAvCedjp35FQGcKZsAJOlHByt1FpcxD8XXd11?=
 =?us-ascii?Q?HsSZc1maIRVJyxzFS7sRa9mZ937mja9WUWemhlxXDSiqlbFzCWJBsC2Vmog7?=
 =?us-ascii?Q?T2KTNMug50vK8JQ37so/hAipxHU0dRdz8luXJd0I?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc1f7015-39d0-44b5-7545-08db03606eb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2023 07:54:51.1768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mSFUZZq7dfZFQmeQFwxbdo/ZgdnimfaipDRD8oeQPUaRGVw3iwtcDdU7/hcwQ8E1WcHsBnpL4dGzvQ9FGOuYyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8401
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> To: netdev@vger.kernel.org
> Cc: Madalin Bucur <madalin.bucur@nxp.com>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub Kicinski
> <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Sean Anderson
> <sean.anderson@seco.com>; Camelia Alexandra Groza <camelia.groza@nxp.com>=
;
> Maxime Chevallier <maxime.chevallier@bootlin.com>
> Subject: [PATCH net] net: fman: memac: free mdio device if
> lynx_pcs_create() fails
>=20
> When memory allocation fails in lynx_pcs_create() and it returns NULL,
> there remains a dangling reference to the mdiodev returned by
> of_mdio_find_device() which is leaked as soon as memac_pcs_create()
> returns empty-handed.
>=20
> Fixes: a7c2a32e7f22 ("net: fman: memac: Use lynx pcs driver")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/freescale/fman/fman_memac.c | 3 +++
>  1 file changed, 3 insertions(+)

Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
