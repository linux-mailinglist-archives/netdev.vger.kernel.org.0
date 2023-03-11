Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE626B6149
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 22:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjCKV42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 16:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCKV41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 16:56:27 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2061e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe12::61e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D921700;
        Sat, 11 Mar 2023 13:56:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G5BCypw2pgB0iBKKlV/Q8OqRXN//pOERY6X8Wro7GXHtRXTU0lyTsWTZVjoK3xsW+T5ZJwtH/LjTXiT9mGWETuXJBOhm9++A7nuuCFznF3L9C8qeCj4IsQrzd0jk7JH3qf8cnEF3TTHDybdkJvGatAEDC8Q0RRDZIf7lnbjzXxt1RGVJQHU2eELqYVZLiNHC1YYocJIvvxka+JHCIj7HCLE5AVygpfmY9zcMZYmlYNkovYxEhevYTuHMGqf7Kt6R/h//SeAJIMf4DYrYWyGSnmHS25KG8RBqYGSufFCUN80vEJLeRMDMKHJvJqESEY14d7WZ1WPHtnzyQjcPawZ83w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GEfpjX3hqVHgdSrTg/UfV31iyPxD2qRgCn8ekoQ4Cxk=;
 b=aUEMeATOYs74xbytFRCOso4UWWZD8H4bgFdV+6S2Ibao3tvzD91q7MkEQXl5jZPco3tQJaIqsMOGH0+a4noGUJqroHmOHnpw1iKWVz/i/ViTFvhdbEFxjKhfjlogNnoH3438DSS/ZPvsH2P0dfg2nR5zUUwZzUoEmEuY7Sd0kcXqkZ71GPQJVSeDIhT3xfRtcagbngUwMWTC/+6uNdwuA0dGfmE4N8cS4K7zlsOORQfzxEyDbwp+O33lFJ84WY2Ccnf/dIUic0Lh1hAljYBrGIdN/sVaQMfR95VGGYd+i4dv9yxypznkbLoNBdFnpbJuiQKe8JcHRXiePAdZTE1CNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GEfpjX3hqVHgdSrTg/UfV31iyPxD2qRgCn8ekoQ4Cxk=;
 b=QsVeTy3N5iJ/yZ3cJ8sRxhequhtosgrTr2mig3qGyHznKp4HsHuNais7Sd0kelAEZJv3O0qgJ8QUFVlHXjgrMWAUYbmsxlu26KJEK6zFD+BWMUrJYzxiMP7fu7DssnpiVbA2CtxqaI7PpOSz1UHmvBD9ir60fFg6Kyev29D9XAc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DB9PR04MB8480.eurprd04.prod.outlook.com (2603:10a6:10:2c6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.23; Sat, 11 Mar
 2023 21:56:21 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.023; Sat, 11 Mar 2023
 21:56:21 +0000
Date:   Sat, 11 Mar 2023 23:56:16 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next 00/13] Add tc-mqprio and tc-taprio support
 for preemptible traffic classes
Message-ID: <20230311215616.jdh6qy6uuwwt5re7@skbuf>
References: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: BE1P281CA0035.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:22::12) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DB9PR04MB8480:EE_
X-MS-Office365-Filtering-Correlation-Id: 5945690f-33b3-42f3-4f54-08db227b7307
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aR/Uy4+bjBXAHj2yiw0Y0IKAK1ExVq0kj+KnyVH2dg0ZffvYOY2DOP6tSNhWr7/AMNvTweDrVGnK7taAnIzKKj+fHMESPK9g03En2CZcNljzCXeuMes21k3om1DtZgJ/p67someDyZr3l6R4B10MAHDfkdRyRw+ipOUx8KoMnm3xkEK8wff3CSClZokfWmlrDukpzpplYvfcp37vC9SdsjXe1/S/ENF66r16c/WmhzTePuUKMVFH8mm+neTBFSW72mmvYNtDUxOtVYV8H2h5Qjz8eJBBwNxOlYUF58FOMkwxFXBLQMMoVxw3aQ9MPWtDcQ247gpGMXv4px9Qzjfh8xlIYU+owef3kFsmq9/D1BmVnzMBdpJHxOxMIkIcOl9HD/y6OjjxsM9FNxJmNLglhaD/bS1jhOCHEQw/D9A03xJpXinx+XzVJWVQDCY7GDlCP5YPhXOsL4HA1V71e3IeMUy5w8BqAOyYAqVLHX1QBE9kO5Vfqjd//216e47u8pDO7FHNiecsNTzyD0O9R+FcVTGBzRAnsI2Q/wiqpjAJs6rlR47eJFdCh1V5dkAr3kdYA5A2UvEn1sPv23+0ILuN/ViJ3XdZrAAGjtp2e5lDl3LeBRFvlrJOfuQ91LAb8jXgL0Eqhq5dtm+tcAV921N4OA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(366004)(39860400002)(396003)(376002)(346002)(136003)(451199018)(5660300002)(7416002)(44832011)(4744005)(54906003)(186003)(478600001)(6666004)(1076003)(26005)(6506007)(6486002)(6512007)(33716001)(9686003)(6916009)(4326008)(66476007)(66556008)(66946007)(8676002)(8936002)(41300700001)(86362001)(316002)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CzoV9+HkbSydvi9p8A+mhqrW2noxBz+7iRqgV5xF9glH1QAcHnzTLKTXw2+z?=
 =?us-ascii?Q?Hc6JF/b0KqWtH73uSBIfZAjoH+Aaszk2w/HcfrvvvZHs5v/laJQtyDQNDqMj?=
 =?us-ascii?Q?AlM4l/sDaGdcP9bDdCB4cqv422kQbDb4jUF5IrN9OFLih0cKQKByswvCZntw?=
 =?us-ascii?Q?YTQGCebhPiMCZ5MhZfVwOgMV3Bzh8zMB5gW+ND5Z/cJCpySH/eXUc2IJYzOJ?=
 =?us-ascii?Q?l/iqGIQW3Jj5N3ZbpOJaiuUM8QMdNsAaLGzVjBcmnkxaKWbXd69SQIA6DH9M?=
 =?us-ascii?Q?9MoQOgpSTzmYRHMyIMJ/riiyxV3h9iHwvoVnILMgY+dqEswcKEfZ/ETQ3dLa?=
 =?us-ascii?Q?FM8Vuhx4wvZcVyjOr3CwQcT+J6uX4IALVOHeuxK48odN54pT00jTYNv7+/k3?=
 =?us-ascii?Q?KlCFGLQBlnjXuHiTRFAEECafDz+XSaoIKVhHbXc0nRmay9/YK03owEIKd/k5?=
 =?us-ascii?Q?vc1dUWAlLYsyzEE+4n6SS5vi0PvyIq0mAD7RRMDaRv6ss2bPK+VUzBvLrnXn?=
 =?us-ascii?Q?kH7SXOC6xardC7Wi4Lgt/htgsEPDGv7/dba76N8MJ36Qpj7nfGwQMcxwnPcB?=
 =?us-ascii?Q?NsMzHEIA1eBWpEI3TOZKnglPz0QGM50+lvSFrk9/Cyx4xCGdxeWQyG2H1wLm?=
 =?us-ascii?Q?GekntmXBF6RoFImoj6bC1oQwpWOByCcZIpfr9+cjCNtIv1cnyfvrE6HLycaY?=
 =?us-ascii?Q?6cPYSBEZ6Vs/udfMdCfWphHRhYrndRROcoIeggVKj4i2VC3o/a2Te+Uyz1zz?=
 =?us-ascii?Q?XFujH5BmSmPUS7IBKwxuxyuwvSDq8nPWzrw+m7rE98Yka7Cvf0hucYGvGtYx?=
 =?us-ascii?Q?NTzx44q/C5sVGA+OXkcFuDJqozmJVHvcoTsVYZnH7LpeoqLSnQ2YAP54EwiL?=
 =?us-ascii?Q?2dSLJ8FwMCGHjhTt8q4ax3V2fLVHxdSsim2wr15WieY0mKYou5szas70E2mb?=
 =?us-ascii?Q?EFE6CZPakz1qz1VoWlWboGfaL7mKJhOMhRzBfcY80RnWVEpRITgwCuSfsvcQ?=
 =?us-ascii?Q?Rz02B4jzvNQixG5bRSZ09x+UHwTRJPVRNIaUCTd2qqiEuUG4p8I8rxJflR1x?=
 =?us-ascii?Q?e3u9Qfp8WWN+AG4ri4OBhqtDFWsi+R92buPq4R2hnGnzOpdzV/tYRHT8fYXu?=
 =?us-ascii?Q?B17U7nrwE4C1n7bso2Wc3d93NaavUXEOV0idb5eEJw5hME838rbcn6u8oP3i?=
 =?us-ascii?Q?I6UmkZ2+btyqF0jfjG4+/femzhqUM0gHuKno9oFo6XDVj1cahvhwFgjDwXPp?=
 =?us-ascii?Q?f320jynabRJe3kioFHqZB0vw9RJXqnjjBZhdyq3wgbTEvDIoPerPgPodrVZ+?=
 =?us-ascii?Q?t6rruGmNxzwSqH7YNsYbWtHjBrKIDUhhlq2p6OHkVsMFHi9bZOXPyeXaHOMl?=
 =?us-ascii?Q?uP9cvAaeQYojGa8UVkMOgggXNIWUnT4u8nweBqAiINIGL1wn7RVZJCltWBHy?=
 =?us-ascii?Q?wRYxpBImcIAiMhN9bqmB5m9qX750tA+fAQWUewzZ/xJcfeHdyYxhmBHdGeMW?=
 =?us-ascii?Q?tXfMeumv4Pn2yGROUVHXft0AEvZOr4suEnxoGUvW5ivg1WE5wyGZci/3t2oX?=
 =?us-ascii?Q?lk7idSt9w9j9LP+loRnGFnDrv4VS73iZaBCHEryyaTYAJ83OwMkcMQdXSvGb?=
 =?us-ascii?Q?Aw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5945690f-33b3-42f3-4f54-08db227b7307
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2023 21:56:21.1112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +OVppawY2mGxOgQbyoZr3FuISBRMapVJTFUN7i0390EHdIqykGvOMrDkm6y/BGUJjS1stEEOUj6bE94n+3AbkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8480
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 02:23:30PM +0200, Vladimir Oltean wrote:
> This series proposes that we use the Qdisc layer, through separate
> (albeit very similar) UAPI in mqprio and taprio, and that both these
> Qdiscs pass the information down to the offloading device driver through
> the common mqprio offload structure (which taprio also passes).

Are there any comments before I resend this? So far I have no changes
planned for v4.
