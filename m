Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A389D67D695
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 21:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbjAZUkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 15:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbjAZUkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 15:40:00 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2070.outbound.protection.outlook.com [40.107.22.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B1610E9
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 12:39:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ny/Onn5jthowpcBOXY9hQo1BSCKlWElt3HYoGT7GcT1W3eETWReW4sNhZ00Eml+JXeRD2shDAWdAVysANNaggkS3c/6B7SprgyEnNePx34F+e1KLJ1+aC4+4EN1DK0Y2Jh5XlOwnFbsh44YrVYJ5cUcnHb4a0HAD5wT28FojelK7mRzfO2ZG2wkxFheNayzNElTmjB12cDdA7jhwoszLlC9mc+AJrThiXTZcJaoyMO6f3wHtROjw7vJn8vSHFwPmeoN7UKx9P4rC/axJXN7Zo+5crP2e8wj+fmIzHw8X/uGUClOh2UIfatxANpD8AMmk2PhmYZ0cJ8AWufxL/zVi/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GBfh3XGEGRPPnwvNNnycTSj7KTmHJ/7yNKl+xPzvYqM=;
 b=ZfqcTDMBvA/j77c8P6KauzqGQbPzDXdeqEOP+yaOl+Mo4SnNl1uTWFb6o/xiHyidXCCNFSQBWrXVlUMbeIml6+rmWUai/Co7tT9mUXvt5ydPCsDB+3Ug9uHHhdITEJR5KN0ZBDA7+ASyLIxx/UPV0h/cldIdmcOZZdFHm/B577PEKb1MKMo8jy437Fj2pwVul3ufzdIh7f0yf1VvK+Z6Bt8xKWIVn9M9EiW504nceAXnbko3O+GUUJtn+ldcJs4GlqPmHfzlkllu4/d67CnGX0MaAJVdUqrkWOkNgIs0kky3FR/ijIa5dR150euChXwRVNU9cpkXHpFIFNIMtLrFLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GBfh3XGEGRPPnwvNNnycTSj7KTmHJ/7yNKl+xPzvYqM=;
 b=lNu51iV5WR4GZtpSGYPTz255WjWe2qtqZzBG2ZlYKG/kAgEGdqA6Fm99cGVbciafBVWM66+PK7USmqV73Zsm+L7OrJT/4uC0RUF3jNtlKVevFIfRGjAr07soB6ihDY/v0WkkX1rjGALkYap/pXmRu+4Q5XwBlKJcA8fysHItCko=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7624.eurprd04.prod.outlook.com (2603:10a6:20b:291::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 20:39:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Thu, 26 Jan 2023
 20:39:55 +0000
Date:   Thu, 26 Jan 2023 22:39:49 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [RFC PATCH net-next 00/11] ENETC mqprio/taprio cleanup
Message-ID: <20230126203949.vd2mptdxmbbz55r2@skbuf>
References: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
 <87tu0fh0zi.fsf@intel.com>
 <20230125131011.hs64czbvv6n3tojh@skbuf>
 <87h6wegrjz.fsf@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h6wegrjz.fsf@intel.com>
X-ClientProxiedBy: BE1P281CA0110.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7b::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7624:EE_
X-MS-Office365-Filtering-Correlation-Id: 66d50c66-51fc-4dab-a2f5-08daffdd7b59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vzXAXOZYe9GSYFAlh+4NfLwQKd4FBrKgPLmMUqb8z84gFOEMxSQfhBkGf2NIQY3wdrrdkuc3sHcCXurEGKNpEfiejvDCn/mUbtfkK32qxcqV+uQTXYjKPVLkEv1X7/Sdeua0ZU66e1rf42kyiHpGMR7n2Qa6trqzvxSNSiuuKJTRVda38PrzNmL65AirrRLk531Tku+tHG6H2PEzaVCnUUsO8jlb9evleEXFTxMXXXSVu7x1sQs3PVN7KVuY98MNdHPwpMNM1+PAqdtIdzDBxpGNmpXC43sthVc8fbgTWSDuyYWJRO6Q4hnpTIkMBo2Op7E7I9wmp0TgmaV5kUYZIggdQReFrcAq74Ua1K1bj2U7QNnYdAy8XHiBPzTX2gjJEn+SSm/wUTzE0ZN5YAK3eH1X2M/wY4Eg13YR6+nxiTdB5z6yR0H+gxNLODY2s+W6qQ/Tlkd4b/iLYKZUGf+pvx7WDDbS841wit7cVBiQv3iLj9Q/vxC7Gbhu0YdthinNhqryz0ILbzr8dnpBqZG3TSzlTNOZquqAj2j0MjpeMHq+QKgYB1enSAeOFObe7OsBO0T3iQ9AdHSIgFEIN02D4Y6/+JITW7pqsfW81uj8UpOyZfyEeONExpPc3vaIsyVpQ/usUQq9eWYZMp2lBYaY0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199018)(316002)(54906003)(38100700002)(41300700001)(8676002)(66476007)(6916009)(66556008)(5660300002)(7416002)(86362001)(8936002)(4326008)(66946007)(44832011)(2906002)(6506007)(1076003)(9686003)(26005)(6512007)(186003)(66899018)(33716001)(478600001)(6486002)(83380400001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eluCGcyIHKLrF/EDEM1MzppZgyN+3Rl4qATCepi+lWIpFGYlM1iPDyL5EcTJ?=
 =?us-ascii?Q?NAaAsu9Bm7PujMYPXL/Shz49vGmIKoZyAJq/ZCTi8UkCYDqWZK8+SLrQLsdI?=
 =?us-ascii?Q?GdCu1+j9tzhjn+yQHFGKflTVEEg6gBEk67gjJe8bBFrrLOWCLl/m7tWqUMBT?=
 =?us-ascii?Q?An8z/gQhxVtRaj/a//RrvUVPfrEqlx62zk+9P4cHqHQTYTHLkjCRAcjUq8Zq?=
 =?us-ascii?Q?NoAXo1vTjB+MT8LkuxeRgl30c33iy2JKFB2cLvP47AMrlYobUE92kx1d3RuD?=
 =?us-ascii?Q?VmQstXkVo9mXoRfKRfRpYusBgxBI5z5MvtNLqoa0fHYoJ4l83rC9zJABk7aV?=
 =?us-ascii?Q?hOMrRKL08Jjha3RwWUbeqi4ujs4v6bzP/MDx9t+uJTFSUpJKUF1zOvnMLE37?=
 =?us-ascii?Q?gxs5x0mUifgfyiNRN5k9AOiZuIaxH0RCKYsDPPnmswWth1oduQf38xaWxIiK?=
 =?us-ascii?Q?oCjaoqVv3tK6H3wyQ0XgT7SIrq9CDLOdXPY7YD6ecA09OoYnPHpCvtbjCcyv?=
 =?us-ascii?Q?cvcR/UJGijGi8JqjKlZUgcGnIILE0Ro54uI7kT40Vd74D8RrWW0SZQ3W9gFx?=
 =?us-ascii?Q?Hnx/1Bp/oyg1JEYiZ+UShZx04DK5ZzPHFvs9bDB8+nX1NMFMhBTn8DSyXOwf?=
 =?us-ascii?Q?w2IVvr0aFKM06M5oRjzIFCrlZFmOLtCpYfeeo9A7gOYM4dNBEyJkQdZhxrul?=
 =?us-ascii?Q?/P2jIO55+Qzf1x6RyvozrEIh1N+ouPFmuoX7awEAwNDL6t3R+SgGdtL5mJAJ?=
 =?us-ascii?Q?7k/l0ED5/Npn4228W+Q2wRPyDf6Xitam6rJMqYbrXzfc67RcNqY0NBmXYdWV?=
 =?us-ascii?Q?6nk0jz3jYIIO7F5svunB7dznOeIsD2yRG062ObA92sm1m3G9sDbDz/dMdwfJ?=
 =?us-ascii?Q?WBD1tEYAWFBsOF2aDkgHmV7drecDNqV1fu7xzrX6cUNv76TJb6l4VVQYN+Gq?=
 =?us-ascii?Q?pPiVOEAAkFcnhgv0CoKpnUJWQy3nuiY3j3bwil6FyX8phH1e0rYn4phrRfAp?=
 =?us-ascii?Q?+afwnt0PelV45NuE0tM/vnGpyv7C8KFfP1ze8N7lIWR5jow4kyNTsU8y9X+q?=
 =?us-ascii?Q?xvYkZ5We+2BOUb98mGlwiJoiEcuG5TNZieTYA8WcBSqbDQEr7dF6zZvH8XJf?=
 =?us-ascii?Q?SA+Peto47tuim3u46vqiuXIMGD61tXtc2XJoJGVNURMuyGXLlznj2KnqZFbn?=
 =?us-ascii?Q?zZFn7iKNbrX9uIsfYeZWOFI/zlFiTeQYzDxbjj2LCfcALnd9PiC9hMguoWj6?=
 =?us-ascii?Q?CMaUeU3OpltUEgzDi/Zhif9BIwscJNZ/nxOzJB/oT1o1olCkigAkLYTOQeF+?=
 =?us-ascii?Q?0gCYyJ1B2oVD8fI83HJ8djXByPz9JendxzL7IpwAz9FJU8rN4Ih4l2HcL5/b?=
 =?us-ascii?Q?qJJWfRxFMBAUkhUn0jSf4t6FQyFpdR5IFL3XEhCQ+0F3Knu+VroTDe51qcr3?=
 =?us-ascii?Q?HbqFKHOuKTkFM0YICzQJ0h7AHmsVNx/P1BpvRdvOEJRzR6FNDNG/EkbajCwp?=
 =?us-ascii?Q?B6jeU0mqjW8lt3LDIpncRZG2EvsE99XV2Ie0JFvUPj644cIuOuJ+irCOb9st?=
 =?us-ascii?Q?dS/PdRyo1mWGsuaplGWFkYxEMW7wdAHqDLoN1MjaPXEZOGN3QJp8/L0e+fYl?=
 =?us-ascii?Q?BA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66d50c66-51fc-4dab-a2f5-08daffdd7b59
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 20:39:55.3517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IfGv8Rem30tRXQxPpBLm9WF/Cun0U0fmcZtIG8sDetCHKIYoIFLthymDCH5yL8DTdzoZizb5BhF0wlIzcHts3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7624
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 02:47:28PM -0800, Vinicius Costa Gomes wrote:
> > The problem with gates per TXQ is that it doesn't answer the obvious
> > question of how does that work out when there is >1 TXQ per TC.
> > With the clarification that "gates per TXQ" requires that there is a
> > single TXQ per TC, this effectively becomes just a matter of changing
> > the indices of set bits in the gate mask (TC 3 may correspond to TXQ
> > offset 5), which is essentially what Gerhard seems to want to see with
> > tsnep. That is something I don't have a problem with.
> >
> > But I may want, as a sanity measure, to enforce that the mqprio queue
> > count for each TC is no more than 1 ;) Otherwise, we fall into that
> > problem I keep repeating: skb_tx_hash() arbitrarily hashes between 2
> > TXQs, both have an open gate in software (allowing traffic to pass),
> > but in hardware, one TXQ has an open gate and the other has a closed gate.
> > So half the traffic goes into the bitbucket, because software doesn't
> > know what hardware does/expects.
> >
> > So please ACK this issue and my proposal to break your "popular" mqprio
> > configuration.
> 
> I am afraid that I cannot give my ACK for that, that is, for some
> definition, a breaking change. A config that has been working for many
> years is going to stop working.
> 
> I know that is not ideal, perhaps we could use the capabilities "trick"
> to help minimize the breakage? i.e. add a capability whether or not the
> device supports/"make sense" having multiple TXQs handling a single TC?
> 
> Would it help?

Not having multiple TXQs handling a single TC (that is fine), but having
multiple TXQs of different priorities handling a single tc...

So how does it work with igc, what exactly are we keeping alive?
