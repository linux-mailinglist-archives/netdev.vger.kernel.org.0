Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42CF56685B8
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 22:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240516AbjALVoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 16:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240872AbjALVnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 16:43:43 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2088.outbound.protection.outlook.com [40.107.6.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D927A3E0D0
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 13:36:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S/scA3lnO3j1PxGwn1Gth/vMNh6brTTQGVjLUHRInxKRUO475T/FYSnzcqQnkfU9/M2LYvl6XrBvPPnGyymKnquIN2J4Gbl6spSnC1lKsFBFJ1ZnMmAwEWnQkCXpaH4QL3M7QIpJusFJ4FDO/sagpytdvWMDNDdsFFkBFVrKCWWKidnJXlFmukOGXvDyg+7KQIW6KBX2g17Zkjo313JSUkCkKiOO4TZfYyqEocWB0P1qCcUHJ33X1saCB6OCx/qC5/yigVYKKOC9GKmzoudatouEJOLC7lym1jypLXFWaSx14149uXKBwuGgCQsOfP1vtwyD+jr+re5IP3XJ9fQH3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mrujzc6UO1kZ5kPlqQlYnhBGqO04MVnirDloj/zirNM=;
 b=jrAnmyImlFjVwtAOXBCAH3wdSjJk7/9qA464FKeVf+mv5CeYTjSPISCPEfGRFduCdADbYjgm71VZ7FPuSNbklQWLc/FdoJOBx0QS31kBiIB2dl4Tv4KeYhcon0835dpHC6c3hv0se1g+D1DxD0xWn72CRYuY33Oa4WgcoMqFZjSSgFJY6qjLaqCkrmlkfiND9LsyvYqe87I1/KPGTIZUIJxOAoNNSSKLYPChBc4Zn+hXQoDWhSuBGuu2Cxjp5FPLm9eDarWDOwXlXE6zZevZBq0QE/8D1QUnhty33lUHPiBvSyZqXF63FFlJhfreEA9KS2NB48WNX7u7ntP33zHSIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mrujzc6UO1kZ5kPlqQlYnhBGqO04MVnirDloj/zirNM=;
 b=ePS5kc7Om+Eg5eiHWir0ZUlirUEAt6I5kjHcWi+2Ynqx0FZlrDq9yAg26DXEkaUw6ThbCNHthYSjbJTtV/WIMwB8s0G7keVtFV+hE2l83ptOWkhR/1x6bg+ahocfRqE80MLKrVXRmhjkNPH52JHFGNVnPT5CRTSDduMgpJf7G/k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB7173.eurprd04.prod.outlook.com (2603:10a6:20b:122::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Thu, 12 Jan
 2023 21:36:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 21:36:33 +0000
Date:   Thu, 12 Jan 2023 23:36:29 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Y . b . Lu" <yangbo.lu@nxp.com>
Subject: Re: [PATCH net] net: enetc: avoid deadlock in
 enetc_tx_onestep_tstamp()
Message-ID: <20230112213629.4luzdpktiq7ho3pk@skbuf>
References: <20230112105440.1786799-1-vladimir.oltean@nxp.com>
 <0031e545f7f26a36a213712480ed6d157d0fc47a.camel@gmail.com>
 <20230112185355.yltldjsbxe66q54w@skbuf>
 <CAKgT0UfnRceCA__HkpVnONO_AAp+wt+1GC2b6-vNk8oPh6aV9g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UfnRceCA__HkpVnONO_AAp+wt+1GC2b6-vNk8oPh6aV9g@mail.gmail.com>
X-ClientProxiedBy: AM0PR02CA0135.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::32) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB7173:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ea4b888-c71a-4eb1-c631-08daf4e51343
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /SOWFe9UKpmzaFvQyaXiWh5lXz+BkBe+VzAssg5niGFO4Ca6UIduiOL57e8rP7hxtRWZqYMJp+84DE33zblow66Jsv0Z0F4J7U34JzPUh+I6MM2vw0qsape3v0sFJHzdpqRA/1pJSzMCiXHkUad/qbEiLf3J3pMnGC7ZLdrlawPJuHHh08c1sB3Ux4NQd5/J9yL4DiXIPAGo7u30UcaKhb3xQzJqkHB96L8UO8QO2t2A5LOv9GuDITBOf7oTFB20SfY0VYh5r2x+5sWxVjhBAjhhAdomhbbPX5n39rVO7kY57Lislp0lG1/P7aWxnqfVFYcZ8w3tKVfGgMYTlezK4cWfF+Ho/NPlhlaaavINoGZ/CGaGqKcQCGgjjKv6aLg1Qn/ZzaRV0PL7E96YqcFir9d4+eCxrKQcc9h9J548BlINHEwnxM+2Oobg6IznJE9ru2kjixr+HAdSI1cA0IZ2l328L/JN4eNN0rxaqDpZ6Ll19TFpp4ctjoj4zoIQLn35EgbMzIm8kkOT0raH2gg4Yue8GNPUZgu4wc8eNPOnMOtbHZnPXBp+guen6HeJhY5BmCTqH7A+YzhqjIKFgrgv30QXZELvpe1m/svogWixnOOXFeotx9qY/EhnklKCMcp/3yPWWdg9vndaT0lPe5zq2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(136003)(366004)(39860400002)(396003)(376002)(346002)(451199015)(9686003)(6512007)(186003)(6486002)(26005)(478600001)(1076003)(316002)(66476007)(66946007)(66556008)(54906003)(6666004)(6506007)(4326008)(6916009)(8676002)(38100700002)(8936002)(5660300002)(41300700001)(4744005)(44832011)(86362001)(2906002)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bY03Le2FCHAU1zzFtde7FWFKNG7zv/zCxXoKjAEKsjSs10znMGNxh19w3Ioa?=
 =?us-ascii?Q?glAxmJPIUs+kpxk6u/OxnE4r0H53mCUTXVjlNW5fzwABhsJQeQWs5suDJ9ts?=
 =?us-ascii?Q?mChXkUvXSEO0wioVjjf+2RJQl+3O/K4+2nPaB5UluhR4j1gDM+DGpWLm8fty?=
 =?us-ascii?Q?MICN1CDNbuNCflJWQZehSaM83hFus5YvqZjd5YZvAVCn5szT/4/TaJTlVvh9?=
 =?us-ascii?Q?RmGLd257cWDpytQI4qBd8ToU08gGD+zyIFoNN7bl7OBh7fqbE6iO/LMwiMX5?=
 =?us-ascii?Q?rqMJ0b6HFR8qyAH8naTgf61l8V4cU1CSOhY8xJeNaYe0uSi4bQWGSzWM8DOV?=
 =?us-ascii?Q?E+wXAfAUgB+i6X9NRVxsyjUrnCu1melntOeTuOgVEKki3wtuzFibn23rdIWj?=
 =?us-ascii?Q?qYTqa1HM7usHcfzj0/H96riKqQ+lX0NmfCHrGKFIxxVF9yOwlfLZ7jPswdfK?=
 =?us-ascii?Q?uBE8sWTng1bxxENytW/Alu+5/MjKRjwZAnoo40U1+1SaC+0tYbdsp3DXaBo1?=
 =?us-ascii?Q?PMHAX2SwjkoZN1/kbYZBo9C9z/ugdHd3meziNm1zHTJAxyrEhD94fPPLdPCD?=
 =?us-ascii?Q?IqSRl2YSVvh+UKVMrBrsa09qPASIVx82yMdeMahkf6hJqfsE8RY+S4fZB1GH?=
 =?us-ascii?Q?/5atHJv2qk+gmGLlRs+t67uKU/AQdf1cA2N0/pjVsvlBEM8cg/AThLxUYd2e?=
 =?us-ascii?Q?Dt478/izzYiovc0JTPs8vur0KxJSJYv2MdY+SunxlXP5JyS7mxiU3POBlcBw?=
 =?us-ascii?Q?DlqBE097Jxe011hPMMmYiU9rTy2pncvodLvj5V436NOcNRWaxHEjLjlDF2o0?=
 =?us-ascii?Q?Jl2Tj5vAgyqbMudVPbGB3F3HwB0wsj/IgIt0J0ESkT/tvXxVycWyMCR/Ed1O?=
 =?us-ascii?Q?xxe2QyuYAr+oDAXjT5CWR5b1lVuPprY5K1AIpL3+TLdQVkpJedTHfDWzspey?=
 =?us-ascii?Q?8vH0croQXSdW7VD1lL9bWpnnh/WHM1jGm7OCjV0h2dAzI1KBXBZZpDZ1Dwor?=
 =?us-ascii?Q?Q57dhNq2G+PS71W5I/Yc+2W+9kvBcBR5lj4+h9Tyxozp2qyprt4kDT+B5mzk?=
 =?us-ascii?Q?djZv6CPFbJEVeXJW8TA2BMeyvVFoF57JmZP522gekdZf6ynidK/sWfknyrBX?=
 =?us-ascii?Q?WWmoTmQBAYZG3JX7CfCSs0v19q8atOx4FTCqrJoVtO2GI5n9j3YV+C+aw4W3?=
 =?us-ascii?Q?b/hBMFD3SDemFggM1yua2hjEC5hRIqxP7yvZqdcNBuvc1N+WdFMEEiAKck3X?=
 =?us-ascii?Q?gtfS2mMDKZcPULd2FZSScHqu87+vYB3Y3kH/E2uug3Wskokai1xYKbZ4L9Eu?=
 =?us-ascii?Q?PHBTQMV/tftwtK9IQ4jTiYEl+OUb2YGkCq6+7KKtbDtXnLY07idkLxmCUK97?=
 =?us-ascii?Q?0fHOPdcEMsI0Cp6VF8H9T0vTBDO1i9/ezqSRwC3jBSjRWEYtgaLRwotQ4CiS?=
 =?us-ascii?Q?LBSnPLnyMnqqrWJQ7qc4VbQ6CpbUC0S1Lvewo2QAuPU+RNhs/aXI8yKMgdyW?=
 =?us-ascii?Q?GEwx1roiFJNh58q0xvY1nAhiqfvk6UCr9xNw4Tubf7gdGjLGkawnFVWDG0mq?=
 =?us-ascii?Q?C9SFSYxLb5JW5TWuAA8eUwiBlLdhZsbVVF7m8V8FQW6PO6qYvm3JFvp0lKmY?=
 =?us-ascii?Q?CQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ea4b888-c71a-4eb1-c631-08daf4e51343
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 21:36:33.6118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fFRced6do71hb4ZddIS3C7OxG/dsXb6OM3vvnJ4g34shaQH9ot7wjcy0ova+IDq08QMIP2enj6EYsN7+mpX3hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7173
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 01:29:21PM -0800, Alexander Duyck wrote:
> One other question I had. How do you handle the event that
> enetc_start_xmit returns NETDEV_TX_BUSY or causes the packet to go
> down the drop_packet_err path?

We don't. If the enetc_start_xmit() asks the qdisc to requeue the skb
via NETDEV_TX_BUSY, we aren't going to do that, because we aren't the
qdisc, or if the packet just gets dropped without being mapped into the
TX ring, ENETC_TX_ONESTEP_TSTAMP_IN_PROGRESS will remain set with no
possibility of ever becoming unset ever again.
