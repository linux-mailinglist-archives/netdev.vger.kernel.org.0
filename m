Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19FE563652D
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 17:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237172AbiKWQA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 11:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237586AbiKWQAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 11:00:22 -0500
Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on20617.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1b::617])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA88A6238B;
        Wed, 23 Nov 2022 08:00:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IbTpqxlHkCJ53Lp3LCQ7eic25vKB47EyPBilAajoUuzXUpupx1m/zZe2nqk1Ch+DGp9OL0V2MSmyMy+Uvc1oZvIa/dUDIto0oN0WRc3Q7MYJtc1MOBgRij/LYFQsZcLXZqaGNFTy8B86LJ4VAFlTAL5XPUFBvc2+EcWswlMe2LqaPOyil8PSJMsAMjBlUCtraxRp2BWa+0HuqWqt25kH49ibVwsGfJcHJTUsbOjqOvjMU8bGkTqXm4vO29MTzRnCw5qmLDQoxYVrrDSP4EBNCAmlPPB7idwkycCE9WIaho39kpWKt44JM6lbVNrHTGcJMulCHCKVXG8nYJnd4sUrUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fx82twOvfRrVeyF05ZeP1pDz2IhREiT89wuZIZMqzwk=;
 b=WGXL22xGobUy6Pv/uqWJcRBZC3KFOrZoNwmmCew4ikQ1t2DLxiplARo/RDDysSb2AT95v+tlBRRSlD3zZqEDVDIB5+OklK5/FCNyErEtTNXvvJFadV+ydB/GmmYQNRZqCY+Riy3Zby4avkTz+RYw1O4L00am6o1ffu8djDZyFn2xmeDP+1v6+3+4gq+DggwGiNOFyge5KYtGVh9EJZywYW/o5MTyU8xDrW4BXE3PD5flOUkwGCdN4YQpXLg79S/F0S4qf/eXEIsdVhOcqAh/d6fBorgduzBy0goE1qYPWAjojoLuug05gAIvDypSEErEtfySR/et1MTcpWHJii3ezQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fx82twOvfRrVeyF05ZeP1pDz2IhREiT89wuZIZMqzwk=;
 b=WsZs/BJ8tkFpzwl/72vuQ2gac68prlgCHb1l3VtmkmraP1IXm9lwL19UkNaJkfN0n/H1Kt6ejivHgS+qgn1tjPWM0jv3kXGwiTwfqwa4DyKCjlbBbJMJey/UcSvkXJFXO2JgJiUSE7QBfaoGUYZPkMDb87/9jPLwDHstQSGKCrw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7989.eurprd04.prod.outlook.com (2603:10a6:20b:28b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17; Wed, 23 Nov
 2022 16:00:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 16:00:15 +0000
Date:   Wed, 23 Nov 2022 18:00:12 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: enetc: preserve TX ring priority across
 reconfiguration
Message-ID: <20221123160012.k3h3og6f5tjxpjcg@skbuf>
References: <20221122130936.1704151-1-vladimir.oltean@nxp.com>
 <20221123155116.484163-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123155116.484163-1-alexandr.lobakin@intel.com>
X-ClientProxiedBy: AS4P191CA0004.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::10) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7989:EE_
X-MS-Office365-Filtering-Correlation-Id: c61bb1c5-f8f8-40de-cd1c-08dacd6bcfbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w236uua2QZvoEVx2ghRz0k3egVtzg7+IBPCZ47saw+bZeWUU/yr9r+WC/C+OqAsLV9cRk0ecFsRCXt2nK4mzYmyQRFp1bvNpCaI0ov/nq+jK/EQZjgPL7DHdjQGX5sSsIFuIGRnbKrlJWccEgBzBNjJGoKdsyGi4++IbmOz7DlQSTUWQfUhddTdJT9QMrfsAFrZHl1gIlvO32w1XwTubDrIcVYdOH8O/Z+o0Zbq9jwrO3XaKs6HJMMRJ/HJfZ/K7jpRuWMDa61iW3QHjNmRYK/rHt0ejiIfQVuLfaMgkj3JYOPTLXbKNaEswjowRa84Ds6sQ4nyOT6sXY113AwVN6Nge8ESlqDAKS1AdwRNWjMFNimLTf9YnrTlQ9s2g3Y5AadDOCr0i9Krn/2EC2cjXR5M/YRghULaF+XhPQWM3oa85MFPyzG5E+qlmVEFWdqwGPNIRm7TE/lOnfA/7A/aHj3EsyYbN4dijgLqWO3qeWrZr5u6umK7wFOl27bgC2Ms8GJgHWvjhrlRLphUa4ot3f1D+WG/5tOO67RR2zyPnLnoxYcNUSLXkBnIQ9XU84rp2I84GBGX7aHxQutBRhvu87Arfz4VW6QK5EXuQG2/GOYLo3RuP6O5h2BwXdRuK4r7S5BKEFAOe31UgJT/4VvKITA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(396003)(136003)(376002)(346002)(39860400002)(451199015)(4326008)(66476007)(8676002)(66556008)(83380400001)(186003)(478600001)(1076003)(66946007)(6486002)(86362001)(41300700001)(8936002)(33716001)(26005)(9686003)(6512007)(5660300002)(2906002)(4744005)(316002)(6666004)(6916009)(54906003)(38100700002)(6506007)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8IViytByvMBhilOKp02zCS7RqYA8gJbOA1sYXzdtP7+TWnlSpR/Wq+YrYYaP?=
 =?us-ascii?Q?t2O5XcVp0fDvjnzh008AK8AsdST9jPjV0/LMo+HfsFQXjsDQyvlyzOCc8gD/?=
 =?us-ascii?Q?o0kB51p8VAjL3WWoGXANiL5Kz+QPq2Ajg/jzE7YpqFhrV2Es5Wfb1zuSP7vC?=
 =?us-ascii?Q?jAnZJGrT4Rv1gl6Ccu31m7x9G643eqZJ/wppN75K9ov85VyydLYRHF+IrwcA?=
 =?us-ascii?Q?CKqAN3bUT0RO9VrN4KKkpY0jxaDx7WANdR8Oz5/xnjX7SkP7ELJsz9KxRZok?=
 =?us-ascii?Q?I06v82BHKY2mN8mxWxg0vIXM6lxOjrS07uThT1KQTmZKVBsI4YVrrzxsxcsy?=
 =?us-ascii?Q?B9Xdjecu5R5z22u+PF2pdYuCD+tZFlYPGyBunqmXVduITbueIXzT2GK06u7m?=
 =?us-ascii?Q?1gaN5WRszlpTnH39bgHpvXwTqoEp9BI/ezjDf3dRJARDE+uqiA1c6eCqqcUc?=
 =?us-ascii?Q?VDVnb3S+9/krmkA9IFCV/1Aj7H2sLf6KanrX4X4+fDMaY2X3Uy7CwGc5Ij6/?=
 =?us-ascii?Q?G67NpLiKddvAF/Dy4gUpSYIezTBtn25juvRIpJMFCmqy3ngrx1ojIxRAXGTo?=
 =?us-ascii?Q?sJ0gBV4SiZUdBNsO0fDuMnJug87cGnyNpqIIMIJ2HVLw93dIN6LkP+hWfgdu?=
 =?us-ascii?Q?E+TRky4/0qIGpn1vNfVohDwjh9Qjh088ayOEbx8kD3+CkKxv8BdVYWcoax3f?=
 =?us-ascii?Q?YD6QjdO+k+QGW1NbpcKKecy5plCOVx/jVnS0f2XSOFGoyUzuDV16roYNjEY9?=
 =?us-ascii?Q?sqd020YxPOlnj9ouFA9DaoPKt0BRAqoqxM/hyyKCQMYsv2tfmsrfiozROSUU?=
 =?us-ascii?Q?aPRTf9CrWHJH51qcDWRO/ZZKny1g/jeEXJlb+c+KMjo/cFGIsLBvGOYl7FK5?=
 =?us-ascii?Q?FYp84GVl/tImkp7aQRszk1CFozBKqdkFheLX0WnK1yDypCQO2XXFsWcZESaQ?=
 =?us-ascii?Q?jpB4AWXKo4KpViQ3T5tNE69RiWdPx+OMKhhEaalMR/FvtUKssJj3kIoJ5y2F?=
 =?us-ascii?Q?MRGRoJFtQcRO9vgGLN+BzeBPTMwFougikt5qCTSt5L0wjjIkosrfy4Dq7IW1?=
 =?us-ascii?Q?s+n3zSfabnL5uHxTYVn6RoWC6VabjVF99SckSg9V/AuTJ1SqiH58EWSSnIU8?=
 =?us-ascii?Q?GrJopPHrUtpO5exmd8N4wsQD3Zx5Xr7VTuk62goCoInvHHX1ybZy0HoBPAvc?=
 =?us-ascii?Q?bENs5g9PXW4fUoAqlF3Ym1konrMY42Rtp8OJdCRtOmqEb+c80l1xdhhgneAg?=
 =?us-ascii?Q?uV2x2XIMQzj+SUYozERIspIcZSTh2/tQJ4qgE7vk/fslcPJ5SG7iP2NfoYfv?=
 =?us-ascii?Q?MwuJy6wZn90ORNKUjLwZPitr21w681w96ryxQuQaCE7hOO22AihZ3WS6HY6V?=
 =?us-ascii?Q?3Y3qYr/dvft3D94KGONu+L0dC00S9V8Z1KVYxMIJcxJJb4hXIAYh/gNoFYUY?=
 =?us-ascii?Q?2+mSo4lf//61ZQswWRITxtXQld7UN0oIJvATAzysc0nYqBdW1xhUOHl3dKfS?=
 =?us-ascii?Q?DgV+po1HGcv9ctus3FhyOByNB+5bxS7rhExXMU+efdy09H6Ws2yQUyO0wF5B?=
 =?us-ascii?Q?GF8pmZFb414/GEJYZnUpaKi3xScpRJIBTeJs+fWZZbLetrkFACZs/vKUIYEc?=
 =?us-ascii?Q?Tw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c61bb1c5-f8f8-40de-cd1c-08dacd6bcfbf
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 16:00:15.9025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mhNWeuP4FQUkgZ+WhMPH9ZZUJWgdozT4lNcqV4xLxzmM8+loHJgW3EbWPin9aM5A2aZpstUsTZ4XW31Luzstpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7989
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 04:51:16PM +0100, Alexander Lobakin wrote:
> > +	if (err) {
> > +		for (i = 0; i < priv->num_tx_rings; i++) {
> > +			tx_ring = priv->tx_ring[i];
> > +			tx_ring->prio = taprio->enable ? 0 : i;
> 
> Side note: is that `taprio ? 0 : i` correct? It's an error path
> IIUC, why not just unconditional 0?

Yes, it is intended. On error path the priorities are restored.
If taprio->enable was false, but disabling failed, the ring priorities
need to be set as if taprio->enable was true.
