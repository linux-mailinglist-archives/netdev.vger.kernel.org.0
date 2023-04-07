Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A87E6DB0C7
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjDGQlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjDGQlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:41:14 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2089.outbound.protection.outlook.com [40.107.6.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA81835A6;
        Fri,  7 Apr 2023 09:41:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XdweRw0m8JKo5/Ynr8yKE0JlYjMyFtq/WCYr8xY7TYFjdVFeQ+JlJUeZJbBvRT/fq4c+UL975z8hDHtyD+/dmq95THw9u89POH7WD577Zg6T0tCxPAil04b86lkQg3NH6ZuQV0g4tuSXZwDMjjq+R76aHhU8y2PIuBAi4CdNAwgLIGBSZVsXYJhr2QsfZvnhh3CHAMmUta3MpZqRzwe7r8WEU/jZnvtkcF0jyxyFZstGJpdEpUszIXtsLCo4hs/Fi3HfyJTwWFLxLvgiajlKxefn9V7SR13Dmqd7z4SQToCq74b9bkcwEIFC5/cKN/oSflOzG8GBUZ70xlYz9n2aCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a4EdMQWn6E0krw7yvU/75t01nwGa6GX88k/uQ3YeiGc=;
 b=MRXClJ2UVY8Imh3Ud3WifEI+Ysjv3Ke75L33vqjNojHDwSYmmES2+xxuqQbDgJlUZQNCmD6YYQ1BWHimApZReAappfnoZub4yDXy3MemWOWmSUKAFUFSCHf9Gmq1aqdnujubwXfIMbklxYNcSVm6ar2rbGayWcG7HAPCZockOp4xCOv/735ISGKfB5KFQfT0t6NHxGZN0CkQcRwLxlxqDg3h+KbiH0EbC+DYAiOvltgrKOZrhCMP7yyzYZoScLiUzPL4kwu9nn0d1MWecGUnxoHuFTUKMc/UAhZUoKMK/4xSBuzSjtZBPZrGg3cyHy4fslP6fx6IbqlCEyu1a5clXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4EdMQWn6E0krw7yvU/75t01nwGa6GX88k/uQ3YeiGc=;
 b=i1Binl0szAYzEVXZcSxtw8razXbkE+akmm7r+7RQNXfhuxhtz8RgP85vpKUEtFqNvMSy5g6GI3GzTnx2ij0ZRelwDT1KfovOZ9+Qpm1bQ4BQeFnGwVKlDCO8T7agfq77McpQFE8J7nZiWpEF2uROSjbnNFng8fVgax6tD7+q4n4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PA4PR04MB7773.eurprd04.prod.outlook.com (2603:10a6:102:cd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.33; Fri, 7 Apr
 2023 16:41:08 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6277.033; Fri, 7 Apr 2023
 16:41:08 +0000
Date:   Fri, 7 Apr 2023 19:41:03 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH v4 net-next 6/9] net/sched: mqprio: allow per-TC user
 input of FP adminStatus
Message-ID: <20230407164103.vstxn2fmswno3ker@skbuf>
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
 <20230403103440.2895683-7-vladimir.oltean@nxp.com>
 <CAM0EoMn9iwTBUW-OaK2sDtTS-PO2_nGLuvGmrqY5n8HYEdt7XQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoMn9iwTBUW-OaK2sDtTS-PO2_nGLuvGmrqY5n8HYEdt7XQ@mail.gmail.com>
X-ClientProxiedBy: AM0P190CA0023.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::33) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PA4PR04MB7773:EE_
X-MS-Office365-Filtering-Correlation-Id: 92d09b8c-c4d6-46be-fdc4-08db3786e338
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: crpLQP6IUSsBcNRk5NaBN3AI/Mz+K7yiIfR9lmRXwdeNDPerL4jSzopqhLNNIsvuYnQR05ened5/vGL7lYb7+/d7/TBZQjize6gEY0JB4Apo5zxdUElqUlUXdi2wrK3hRTttaqJBMT740SuJ9cfCiV/4OzYt91Wbt9LD66FYiI2BTSlTOpqvqNW6xbyP8lH2n6IWni765ED8bO2Kuh4j2SUJjSwBHdcNbNoUhTnpk+I3n2pwBo+3Oplz3OOQQRZ3KHBV/o7AhRSY79U0K/XroxSGfJZsKcASLft8mtgQH9tyMcoz2ktDO21T8cU8ESq5jriQdd+nluTXEmVr7/C93W3QQ13eJGv8u2sWc05lsILal2zdTFH9gB57M5t5sp10D1OR2Y3kUXztonMI3JA1VqS32e/KnC+swZPE9lMPWvhvdnGfpzPfXgDtIbBwAmcsG1jqHF0QOd6VtHnY2/ctGYd3uwxwjsXAOtXWVWSQEuIFh2Sx64cCRs+iLYlo/VErDy/+wfClwYFTINi8hH6cQaw553Z68CJnDjwLEeCsqQcnQvox5pEzZQf/tE6YCNeQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(376002)(136003)(346002)(396003)(366004)(39860400002)(451199021)(8936002)(83380400001)(1076003)(478600001)(6486002)(6666004)(26005)(186003)(54906003)(6506007)(33716001)(6512007)(9686003)(316002)(7416002)(44832011)(2906002)(5660300002)(38100700002)(4326008)(66556008)(66476007)(6916009)(41300700001)(66946007)(86362001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hic+wfzMA6hfetVDDgQnqQEKS0tVfeJMTkDZt22qS3tM60UML38Zb3mcd66P?=
 =?us-ascii?Q?IrqMleh2zNvks6QzNYw1pPXmEbbB1zVyLjAGqcc7lnMj8bzTCtU3DhcJNT+0?=
 =?us-ascii?Q?3npglBQjL/YTcnL9/4zn1tnHFQtXPAYxCXbEIloZLMSk6CWPdaF0Ze1B4LN0?=
 =?us-ascii?Q?DzWYuovYjuZ/DvmGY3DeJw7GPeC908AX441ocwl/emRXp5NIrLpybFS9WOig?=
 =?us-ascii?Q?uPLV86l3NkaVpy4p3aL/bNdA903eiVC8BrnZgsl3JLNkfQuAR80Ebc8mGwdZ?=
 =?us-ascii?Q?FpteeA+KOUVyQ8rlVnGW9AYMJMgq8QJmnMAqMjVPqIVjPl6+knXLmhznJcpd?=
 =?us-ascii?Q?hl8g2bp9zooInp9VWTu3M6T2I79/hp3Z+dvrfPzyYU5Ls4mNbSW3JR7g7IYM?=
 =?us-ascii?Q?PgvHXslrpoCgWf+7Mnhf+F/oNITnngM3WSqcwMApHV9RrJedxqeJglOAyFij?=
 =?us-ascii?Q?jwiHqd65oAgj859EjBhTnQ4dFqtljXUszKlxD9pPRmZAS/vvgoV80q39SjXf?=
 =?us-ascii?Q?dMaF8QSIqgquaOr5QgOUX8y2qdadYYadiXY4ppCKy1Pzp9Z4FNa4XHnyk7xp?=
 =?us-ascii?Q?IKfTPE/Egdv8NsBdZnXu0Kw1vFTGYIIbZsdfOOmBvjHKSjMXD2kCgDI3UfaV?=
 =?us-ascii?Q?YNY89hDFRDw/EDOWjJCFHG3vCSArkrQ7G+fCYQRyLx9ZhtqN67EmeTh2CKeh?=
 =?us-ascii?Q?ralY4nVCk5xk5RuuFbCpR4e3lvXhVbzAu1HnhalRBSE8gkU3uylV5dH8l4eC?=
 =?us-ascii?Q?o6pXHztbXgBpr+YykbtNH0IkCLEE2v0IpvesawbczBoi7Z5GCqFf3xqdJXVH?=
 =?us-ascii?Q?YlU10aBC1Moz1pdCu0Ml9mtxf24j+U4BMMYFC4vqaloKlS4yH2mZ7qUaaSfK?=
 =?us-ascii?Q?OBw1kfACTepGFfGq0uDcSVafYSaz0tDkbhONZp3uHTiq//k+n1rxrYSqkwtl?=
 =?us-ascii?Q?0DgjyhUxn/mnQ09t2gmLdk4nGBLCAC/lTRSKCTYvhOIrI0DhuTx8IiyAdCJz?=
 =?us-ascii?Q?e1u+RqvUxqvqt0Q/IWXEilcqlz6ScxzMe2/7c9gTuDdIF+OxTFLA14cNNeXa?=
 =?us-ascii?Q?sBCGvQTSnnTkKEZQ/9d3QfNUBNPP7uAvlXlb1/UyZP6ZjGllAK17gGspEHnz?=
 =?us-ascii?Q?XLuj09F8VFZxRzwmy4t7nDwXuJUEwZwNlTf35nJ75eOwrsG7PIqe+foJ3s9h?=
 =?us-ascii?Q?mhfoli0WAzEV5Sjp6+RpvU3DB9i5EKzhN5Pq12U0orfiTAwSiUQ/fWwj2Q0G?=
 =?us-ascii?Q?WrilimBODOz1vbiFDxoBZ7D2j7JhorT7q3fNqryzcm6G4io2cIrj0E/aWxbB?=
 =?us-ascii?Q?w6eaCNJBX+Mkd6EbpFSJq5Im8UzwpBKoGJ1Cw5mGruSJTllVjzUY68k+Fpbb?=
 =?us-ascii?Q?kwFBLycAlHlNKc9SPF9HIbfSVOwpcTZOdIlKGgB1jOihYyWJiif5i5NbljSG?=
 =?us-ascii?Q?WNP7sqelPxfP1DkZiniRVlkIJuEjuL9Jr/MhO/gdrXNP6Tc1Zxfx9aNIUc2V?=
 =?us-ascii?Q?h/vfN4VDalTevN9+KC6VSIleR0IUFnuY3D3Ibn/8IigBzXCLbOw5haBa5l9S?=
 =?us-ascii?Q?6jCqpzLLpZMoM/+tUkCerHdE9LCQg5jFJfBBS7ysbf7MOAKV1IT5ZZjo+kKO?=
 =?us-ascii?Q?cQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92d09b8c-c4d6-46be-fdc4-08db3786e338
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 16:41:08.1983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TxWB8TmUCXFYSb/F4Y5knPFsXSfxQa3WMhjdcjoCPB3PXQIW00HdcAuJQyv0hXBoFQsMp6OoqghYK79TLDWXBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7773
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 12:22:26PM -0400, Jamal Hadi Salim wrote:
> > +enum {
> > +       TC_FP_EXPRESS = 1,
> > +       TC_FP_PREEMPTIBLE = 2,
> > +};
> 
> Suggestion: Add a MAX to this enum (as is traditionally done)..

Max what? This doesn't count anything, it just expresses whether the
quality of one traffic class, from the Frame Preemption standard's
perspective, is express or preemptible...

> > @@ -145,13 +149,94 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
> >         return 0;
> >  }
> >
> > +static const struct
> > +nla_policy mqprio_tc_entry_policy[TCA_MQPRIO_TC_ENTRY_MAX + 1] = {
> > +       [TCA_MQPRIO_TC_ENTRY_INDEX]     = NLA_POLICY_MAX(NLA_U32,
> > +                                                        TC_QOPT_MAX_QUEUE),
> 
> And use it here...

Where? Above or below the comment? I think you mean below (for the
policy of TCA_MQPRIO_TC_ENTRY_FP)?

> Out of curiosity, could you have more that 16 queues in this spec? I
> noticed 802.1p mentioned somewhere (typically 3 bits).

"This spec" is IEEE 802.1Q :) It doesn't say how many "queues" (struct
netdev_queue) there are, and this UAPI doesn't work with those, either.
The standard defines 8 priority values, groupable in (potentially fewer)
traffic classes. Linux liked to extend the number of traffic classes to
16 (and the skb->priority values are arbitrarily large IIUC) and this is
where that number 16 came from. The number of 16 traffic classes still
allows for more than 16 TXQs though.

> Lead up question: if the max is 16 then can preemptible_tcs for example be u32?

I don't understand this question, sorry. preemptible_tcs is declared as
"unsigned long", which IIUC is at least 32-bit.

> 
> > +       [TCA_MQPRIO_TC_ENTRY_FP]        = NLA_POLICY_RANGE(NLA_U32,
> > +                                                          TC_FP_EXPRESS,
> > +                                                          TC_FP_PREEMPTIBLE),
