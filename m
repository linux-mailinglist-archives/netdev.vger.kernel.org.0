Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D5269CA5B
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 12:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbjBTLzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 06:55:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbjBTLzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 06:55:31 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2077.outbound.protection.outlook.com [40.107.21.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8BE1258E;
        Mon, 20 Feb 2023 03:55:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BRNmx4H47dv/XJb5VLS6+0ODk+8WYeZxtF1GKFmLEIA0+YM44yMKCKWq52cDFmitpAafiTPLl6D5Vi52qipZn9z3L8W946wF4sqex02Af8eDgJTVE2FOWVIAuiT9XTgbExh4Uf6fbQl0dwuC7FNKFw6A11hHzlla65iv1qpDTHK/5ZetXx71KFL5KwgZtbzZ7L+lSXHwINyV0hrEvlOJuv/+XEi+vSnDBl4z5iU957r1XLHNTddBx0/Qysdbid9w3yJ4/TzGttAFqY3I0wVJNct1O86H6JtMY+YAKTUugBwsYhX7QTZG1HYXGSLHnmQgeFyZeJ5mm+nKGt6t/zzrmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CE7aTTYhHzBhJhBjbQ7p/sXFc1IJHC4prjRga/M2Dqw=;
 b=EVrx+UyZgNWHBsbXwYQhCQr/cEQV9FS5XqWmlAd2jMsSOFQjal68Vow0lSkPr7evYOqWGoZsbciE8wYbVyh3J3cteszco0pjdcDeMcDDozf+3NR8J0T/luxk1Cnj3sQFwui0v+bT/j2gce2hrDSyg7XAOWY33/HXerZ2yiKwi9rX853YvnXbG/AgyJwHWzR8ibRBQNJj0z7abhqkHFps2BpDoLSbh2gExORRHOcNLOKge9HbPCGml4FSJO5txQ+t3eltXPl1q/icHYgFREVEC1RsfMdE0uXVZ7yzt5w9Vi5mozXpB+luedgOyY0ch3e/WOhON61pdVvDpqTq1Z8WkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CE7aTTYhHzBhJhBjbQ7p/sXFc1IJHC4prjRga/M2Dqw=;
 b=Fr5YDBw4+kxicMe9v0iEcmCSTLOJmoFCWttL5xhCa/6B8X+zAIzlBiJ8Ftu7QMdEmxpsQndVyJ1JRJ323pEm4FFiX1TgMKfT/Qwot14w2NTO9/r7FzWw4aE8j34X6+W29t6C5WNs7rG7XyV/Mf9ENmt57S0wyhkqQensjqClz00=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8909.eurprd04.prod.outlook.com (2603:10a6:102:20c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 11:55:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 11:55:27 +0000
Date:   Mon, 20 Feb 2023 13:55:20 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
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
        linux-kernel@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH v2 net-next 04/12] net: ethtool: fix
 __ethtool_dev_mm_supported() implementation
Message-ID: <20230220115520.oidzuwzc6ifytd2s@skbuf>
References: <20230219135309.594188-1-vladimir.oltean@nxp.com>
 <20230219135309.594188-5-vladimir.oltean@nxp.com>
 <87sff0ftdg.fsf@kurt>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sff0ftdg.fsf@kurt>
X-ClientProxiedBy: BEXP281CA0013.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::23)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8909:EE_
X-MS-Office365-Filtering-Correlation-Id: 7aace47c-c376-4121-5eaa-08db13395a13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xyb/HHiB6ZlsMqth1usoHOl5lvk3ci5gySw7/KUpS0zzIcICVLVWQPSIZckJEwHHaMLvtu+rHKi6zAuRIt4APgk7NrxcaREMVihPd2r1GdyemgnHZSltAQF07gIDVAkxAFM1jhtTnDdfs1lpT2a9+jXjnz+TZnGigt9inmxGZ7+VtJbWUL9Yl9/VsTLEBBXjdPoh1u28nnDnHW9FuQawToGvpl96Kr1ANvpxPgpQ6DzeNZOkfZU/DOJrvvivoZWm/mlj2ew24/9psFPkiGZT64nY8i1gh5Qo05JM7eamV5dnYb9KJ/xpkF1C+aUfXWSjoJBq5RODvuEgpjZtKjuYvlg6lcx/qnq4/RQZZwegSApZ7VMbMcv6/bJ9V5n6lftZrF8So6nJhSMDJA7Dc0XHpMvUGuNxs1ufrfl4TR4tO68y4JkdfIqaIE823n3r8AlfHL/zvKBMX2TcstBYI2lXe3MjTkghMudiROn1Clkp6QW3jrBdL1egBa7jW75Z6djjaNnpkrmd1R2AzW6Jw/6fgSkA70VdUDOqz8hoFxIxrNZXDtwBgh8Od4Y10e1Sv7cX5oJxMAkzUo01H5ao51aWmYPm+Y+EsmXNseg4+bTQqQkj4AYoTDerV5lI1CBPPjoQC6iIsHZOE7lk8gn5IWbqWXbvC0VifOjL9lgaE+vdlgA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(366004)(346002)(396003)(136003)(376002)(39860400002)(451199018)(6916009)(86362001)(38100700002)(33716001)(8936002)(5660300002)(7416002)(2906002)(966005)(6486002)(1076003)(8676002)(6666004)(6506007)(478600001)(66556008)(4744005)(44832011)(66476007)(66946007)(4326008)(54906003)(186003)(41300700001)(26005)(6512007)(9686003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xEUE3sIzC2JTNH4TLhSITqR0EJoth9rvmGl0CoF7xW7kfe7GepCvijwlVNbg?=
 =?us-ascii?Q?MggagCySe//P0sa+V4nqJD3lNRVOenNMgOolfvKok1Zerm+yhpvIFz/asVqH?=
 =?us-ascii?Q?uZECgzRV9bn0KLH+z+TbsECQQfwGCd17NHBchCeMGfFkmhhNV7pNaGjBcKjd?=
 =?us-ascii?Q?UvNY2amD3pYzTPxGnm3Ml+ceHrJ9eZp0GTWe42e+7t1weWvAXVBzotwOEyrc?=
 =?us-ascii?Q?Ufo8HbD6GQ5My0m3zwcrzv20b2tQwy5gT+/7F21F0LSe9A4i5Xrbuh0kFtV3?=
 =?us-ascii?Q?eBUTTp+25KEQrozhI7bTWY20Vet1SLujdvBvWK06n4UqLgAYYwNNQJf/W1Me?=
 =?us-ascii?Q?9zWLTSC6Gqt6WH6TeUwYK0bFYeAbS2NIlYQwDQkotOYQMxkDNcSEuwQ9Qp6S?=
 =?us-ascii?Q?Ld4le/9f/caX6A4DTVhn/PZpZV2iWHfwgI7TU8YgmcO0OWLwea7sg6KDWBov?=
 =?us-ascii?Q?3Uz0Ew7meHtCpzYoU7wxHStxcTISfOtDXuYaICv/OxahFPH9F7e/h0Baf6PF?=
 =?us-ascii?Q?Tqltk1Ldncqfe6FjXpPuQOtg5zzPjxMgw4HKbyA1b8WaNi/+mlGaM5QuzAB1?=
 =?us-ascii?Q?H1xvjYHsWvbjIuR/UVzLLmCxsw4IFTMMxzFz0Cl8IET+47de3bYPiH94SfsF?=
 =?us-ascii?Q?mstAAiXF5AeKdS35YT6XsjhO+hwgyjMclZaBPxXfdNEkoMG/zhHQ2vJJAX6/?=
 =?us-ascii?Q?ypkFBy/R1OdVbbWicWidTEgly5Mpo4bMQs+z6OtciuD7c66U6w3fD/dZGntr?=
 =?us-ascii?Q?Gry5jYMVbb/OyUeSh87uFzj8uMduuEvf8dw/W2mnM5yqTrJbmzd1aK+yL4bc?=
 =?us-ascii?Q?ADLwNhi5f5oAuDy+zlt7ivtmTeFH2BST3eEZwzrMmJzZO1BH/Kw3b9cgyTZL?=
 =?us-ascii?Q?flpLPXKLVtgkHcrz3TJCpG1EHZdT4Ju7EwSsfiZDedhWhp3lJrwkHzKWuF71?=
 =?us-ascii?Q?tYONXwcSM5AldsURm5melDfQkABtaxJ+LjfGB1gQzcONabqYva2cw57KyAOF?=
 =?us-ascii?Q?lDnlFOW8rtKTKauFIJadxbmmr9JWN1GAkmiXr1h9Y9ttqEkS69+kRGMa4o5O?=
 =?us-ascii?Q?WtivvxD4+acUuI5hEPt8TmLvbe6hU/o9sA/bhct1OIZLR3xubwLHcNlQz982?=
 =?us-ascii?Q?q2YDnZ4RgjMyNL9dezkG4KAzPCDevR0ulodNSuzlvXlphHmzdheJ0QbzoCAS?=
 =?us-ascii?Q?HddWkzmYE/fi1T3WaA7GNKGGz9ozI9jRidrnds4tzQzDgj97HFM/RH69LMsm?=
 =?us-ascii?Q?0pqUC6JkQOOX6a8jGsmYhkWdfh8hO8qgBrzaSz/PdC1gyMQJZzPMxZXfwcte?=
 =?us-ascii?Q?cZWxpfv6lygHKhPouwEd6ETJdnlEoEAIF2FS7b4v4EP3PR1/A4PLTDvSZs1G?=
 =?us-ascii?Q?wKMOw676+4M2Dbz8rxt6VBKBvqci6Ajg8L4IkgtxtA+0W6ZOvr1OvhrZyiWx?=
 =?us-ascii?Q?K2wDK5BJcIyOVwV9hZxJcsTqkUdYT6UC8hXLnD4xDW+3CDP471fFLZIKu29R?=
 =?us-ascii?Q?9Wz63GKvU9K5T40lIcbIS+tBNR/EZ3j23Fq+xENyUvDBbdel6xDbmRbqNdks?=
 =?us-ascii?Q?0Aq8F1Zne6hm3HXmcWpqHPvbJgBRDDI5E7dTbB0CsfdJETWyfcZt/DAfEZZs?=
 =?us-ascii?Q?iQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aace47c-c376-4121-5eaa-08db13395a13
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 11:55:26.9431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GVF/kTUoUJVbybD4F9o7IAMyt8H7SM3jw/k/mQGArA4aF1AUQ2aEf6vtkV2E0yIXeRDeViZBsJqb/wk/vmQZOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8909
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 12:50:35PM +0100, Kurt Kanzenbach wrote:
> On Sun Feb 19 2023, Vladimir Oltean wrote:
> > The MAC Merge layer is supported when ops->get_mm() returns 0.
> > The implementation was changed during review, and in this process, a bug
> > was introduced.
> >
> > Link: https://patchwork.kernel.org/project/netdevbpf/patch/20230111161706.1465242-5-vladimir.oltean@nxp.com/
> 
> Nit:
> 
> Link: https://lore.kernel.org/r/20230111161706.1465242-5-vladimir.oltean@nxp.com/
> 
> is preferred, because it is supposed to be stable. Same for patch #8.
> 
> Thanks,
> Kurt

Thanks for taking a look, I've made the change.
FWIW, your /r/ link redirected me to /all/. I've replaced it with /netdev/.
