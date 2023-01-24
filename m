Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87C8679662
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 12:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbjAXLPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 06:15:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233417AbjAXLPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 06:15:42 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2056.outbound.protection.outlook.com [40.107.21.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF8AEF8F;
        Tue, 24 Jan 2023 03:15:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EbuCoQTDpGV7XRvzDw5LLvjpg+Z5+EMcNhzg7paNMHNcxfXoxYBXO+9P4XzpUs+cyEi04pGBM5VRAoRGgc2w2nU4uJx1IJxRM6dck14PsGDC1mBSOVYBnrHrXx92B+wr8crd2vdOcFPro/Gdhlt7Jn9TYA7SfV2MLpgcTtAmQrMDN+M6pJV98f1wNblNadf2oXX9g3GGQr5e+Dl7G8VWNAtz9fbVumCjtv9NkHx8kP9TCitF7cw0/RRpDF2RG7TUHvYXO6aCTk/QOiET18cqU9Oj8gsgmk4V+l4Da1eD/8yIHM46/U4c15vUkHwt+SuiFqBfm5cIfF6JiCwwHuQQCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=spbjeZDSUgz8sWbKWjiYalI+ac678lXA0dPxaJsry0s=;
 b=N5KdqpbdJAP3t6JbjEGrSRbhRDQ3pDycfHBqA7Wm2z283fOCvfTyhcj3/2jx8/UR/B+l/x50MqRXOHnDVnklBKcmNRi8YY2isGzfzeLFSgYnjg4zi9I2ZuBWPZfaa42eW9rhCiU/lqjJ84O8PMHWeJEoUMuJoPLFKm6MGqQlin/4M/hUKKnJ2YN4DxKL0BEAe7h9d64736GKz4O96rWm2aHpvnX5COy/En2SKM3XC3DOBeC8gs6EQEa0haitygKPP8aaWfriBc21I/gHxJbjpQxO6kmZUMbJtTCxmVkhabf/qDDkHW63gp8mHbf8AQgUkcfgc6+68xe/lzSxujAUog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=spbjeZDSUgz8sWbKWjiYalI+ac678lXA0dPxaJsry0s=;
 b=f+SmgYqN3zeJ0+P1lNjjNDcREWmjmZO9mIHZoPN/WSPlZod9wI42xNb9VqgZV/SwmdnkIu7WrkOV8OUaa6l2TLyJa4Gt9J4Qwuos1Xr9ng2z5wCS24h3fBNtBbpJI27P4PaAKfFMmi3dduriT39VY5WEunabtoZkjrcGCVZQO1A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8118.eurprd04.prod.outlook.com (2603:10a6:20b:3f2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 11:15:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 11:15:38 +0000
Date:   Tue, 24 Jan 2023 13:15:34 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v4 net-next 04/12] net: ethtool: netlink: retrieve stats
 from multiple sources (eMAC, pMAC)
Message-ID: <20230124111534.6eah24trofndera6@skbuf>
References: <20230119122705.73054-1-vladimir.oltean@nxp.com>
 <20230119122705.73054-5-vladimir.oltean@nxp.com>
 <CANn89i+-Vp3Za=T8kgU6o_RuQHoT7sC=-i_EZCHcsUoJKqeG9g@mail.gmail.com>
 <20230123223033.3ad37ccc@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123223033.3ad37ccc@kernel.org>
X-ClientProxiedBy: BE1P281CA0165.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:67::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8118:EE_
X-MS-Office365-Filtering-Correlation-Id: d39ed8fc-b86b-46fe-acf2-08dafdfc525d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8QGbHhlSdBDxhmsnlMIuQA7ZN2qhUPycfJsy3MQTjD4Wc35YxffXZNeWbOvq/3aOWegzXAoQQ4Sfd5ti5JGf3LVCFjveN750CFE7RS/bpcpMLS/9+qbqKu0YV1xjpvWmq0Vvf2DX+VJawCtgbcGM1CvqDv5Hm252rUZtLzW6AfJFlqz08csrSq7EC57WISjNjIPKFdgPAm27Cc21RUjpQDgJDnMrcgR7kh0ogsfCs8K9IBR/5w8KKhD6ZfNunX4NiwR4dJR0uzOiw/AGY5FktVk0M+n+8wj97IcFhQhEnEXNyErRyehoisRAliENC2mRpT4w8Itjk39psYDYyCTVBXBzgEMSK2wqMpR5YpHm25cTYfC1l5dNkC/NV4vW7akEAz+JYrbZAX1nenkTLNhBq+GAQLeWXgMhXulrcHcB37CJ4U1sDLrxprcfSxsGsqcwfsODiI8GCo1h0bdLdbHtmuyPsBcq8Boeph/jE+j85hoZZpcp+eScQ9hIQMsMUOqFeL6uYr38PdSxBWSA8huqoEW0VVbGr+WTiQ/08FdBBCYghC/Otpn+yTAmA1x07H3jnnw6KWrgxw9X/kUNmnCrNXoOQufK1dL7BM0N/JqnODRYiHNCH6uLSba2cZsmgaCdZssCcnxwAYnskaiaxa3ivCECnxapLdIWJ0GTkDkdmH92L0/VOy7+BRcHeWhCcZdcCT/MzELRg45lZRnFzO6K1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(376002)(346002)(39860400002)(366004)(136003)(396003)(451199015)(54906003)(1076003)(6916009)(6486002)(66476007)(4326008)(66946007)(966005)(8676002)(66556008)(26005)(41300700001)(8936002)(186003)(9686003)(44832011)(6512007)(7416002)(5660300002)(6666004)(6506007)(2906002)(33716001)(38100700002)(316002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X+Rh8b1tqWwtkiHb2douE4gyCX95VNZJXSu8Q8/+zBLF/A4b/etHRGPLQlqI?=
 =?us-ascii?Q?u1DlLnAOIIxdhMIPn0pMaSHhOr1JVdbxaiGZmYzxXQ4eAlfSDPBrWBiwfd5S?=
 =?us-ascii?Q?IByH+zx93wgpvOyCHp3FPUfaBft6M90mtjsjTjQhUMQyMAyNO19rN6hTBcmc?=
 =?us-ascii?Q?o5qECs1n23miLNLTOQW/FD+CGGfrKcsXjIq2F52YxRBiKYCAhz7nw3qsmNby?=
 =?us-ascii?Q?rUWCiN7xWWQKrmDXQuRx3iSzJ09jGRD0feOb+nYGH8AvTohpw2g0fZjDFxgZ?=
 =?us-ascii?Q?xY62pFV3xxp+KVC5l0G0R7/MwQOmJjSBebxhy/ZFxxzvrthh6eM6CzcCWwwy?=
 =?us-ascii?Q?QI57OnitqiTb7nVZXEVRuinHN5fodXcw0TrK/T8YpZALHGvupmoWpgAk4PMM?=
 =?us-ascii?Q?GOj68IxzVekp4IMYvuREdo997st0ztqidVxMtDGWYD3MZAq1B49+/LrLh0qB?=
 =?us-ascii?Q?SFF1vgqtMdImoccA5jLQnmMRR/IvqucX99GbOiwJgeHKIqGfVLAD8+ZtnvkE?=
 =?us-ascii?Q?tDI+Ux46EHTPT/LDtRiK9bBIgTcXJGcsl4f417DRtCYxe6tf48QqadTkROeh?=
 =?us-ascii?Q?bVxnuP0xDUzSngOF54AtvIRuJ9Tgv7KwLiKm3PuhGEJLsfozEnQ8Rm0jiOiP?=
 =?us-ascii?Q?ynXmBVNtHKiEP4qvmyNObbHDbdZ289YvNZsGxk6obVlOmq1iUt/66+ycu7aB?=
 =?us-ascii?Q?A78ah8Eo/XCDitM6htql2pz30KEsYkGMSJhSuPxVzjA0kETXr74Ru/unMdGZ?=
 =?us-ascii?Q?AAvPXCV4GtWdHXnySK1NXjY5NF4ceKKalGv95p0fS7eUfN+lHG0Xg9WkmIv4?=
 =?us-ascii?Q?yuqGfVEKx+FVOeI4+wp4hzFy2pHwR95HLN9Ta4xmauy8W9pUyTet5hTfIHWo?=
 =?us-ascii?Q?U8xrtZ0LVp0FNHWICiheii8AzQ93fQ4GI6WNgWKE4097MfKZPXplixSeOcEP?=
 =?us-ascii?Q?4v38hWwX1r5GpdtiIvQCu2HhgVKy2kKanDx/wL7wJqNtClMM+wO/gL48/SGO?=
 =?us-ascii?Q?PsQn9CjqneQn2edLxa6BjoxoUSthUhwnhqnvnwhp4klMuHDdud0eFaYHOb2n?=
 =?us-ascii?Q?/jJua1EA15LvFOVTvrVzQ6/WnP/TzVOIREMq5CLtsgQCAoeIRXzg+7V9XYad?=
 =?us-ascii?Q?9CHXMQiKKH8NOaibBFCuAk7pZzplheGQ+iXo61isctCkeJHJ5/DyxO4IxORM?=
 =?us-ascii?Q?QAoz3OLSi6uMcIrQs4J5CbBSRiWuerhE72xwO68tUBNyVFKVx0djJmOy8Zoe?=
 =?us-ascii?Q?kTPZx2SQ0A3NItCav2+IhZIdEiAF3RqUWh4DNaZ3q4CHfFj8MQWhlvyolqd7?=
 =?us-ascii?Q?uWwcfYDT0nqVKv5hRztSFsfLSHM2c1qcjzhSorpj4pSsX+ux0XFC9WGH54Kj?=
 =?us-ascii?Q?YfvNk1hIEQCVSMs2J5WQSI10s2v+3sR/JxU0nNLbqKlZMIGUevFpwyh4ti08?=
 =?us-ascii?Q?AMNVLBOZ+LY/toGjqsfoD6uufGeb4gUHq9McS5HH6urVaVfxOh780tz/YzUl?=
 =?us-ascii?Q?Y1yIJYEVlSKEpZdMp40JKnIg6IF1kyFxU7WoATQ3o3+ihc44W5VySUGrO/tm?=
 =?us-ascii?Q?o0MIn4ILQxzPdyE6Eipyij/Z1aYlIjz4q1YSBefB73Bza/IFmRAjsJnpEC79?=
 =?us-ascii?Q?8Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d39ed8fc-b86b-46fe-acf2-08dafdfc525d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 11:15:38.4146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gKHivyObMVYk+nIXWGBJzGSwRpIQZZxkxr5djLdCfiYRrvOutTvV3wW0pgqQ/y+YOt2jb8MImcZ2s8s+RyWI/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8118
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 10:30:33PM -0800, Jakub Kicinski wrote:
> On Tue, 24 Jan 2023 07:20:20 +0100 Eric Dumazet wrote:
> > >  static int pause_prepare_data(const struct ethnl_req_info *req_base,
> > >                               struct ethnl_reply_data *reply_base,
> > >                               struct genl_info *info)
> > >  {
> > > +       const struct pause_req_info *req_info = PAUSE_REQINFO(req_base);
> > >         struct pause_reply_data *data = PAUSE_REPDATA(reply_base);
> > > +       enum ethtool_mac_stats_src src = req_info->src;
> > > +       struct netlink_ext_ack *extack = info->extack;  
> > 
> > info can be NULL when called from ethnl_default_dump_one()
> 
> Second time in a month, I think..
> 
> Should we make a fake info to pass here? (until someone finds the time 
> to combine the do/dump infos more thoroughly, at least)

Thanks for letting me know. I've sent 2 patches that fix this for
ETHTOOL_MSG_PAUSE_GET and for ETHTOOL_MSG_STATS_GET:
https://patchwork.kernel.org/project/netdevbpf/patch/20230124110801.3628545-1-vladimir.oltean@nxp.com/
https://patchwork.kernel.org/project/netdevbpf/patch/20230124111328.3630437-1-vladimir.oltean@nxp.com/
