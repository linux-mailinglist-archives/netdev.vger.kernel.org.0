Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBB069D0B4
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 16:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbjBTPdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 10:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbjBTPdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 10:33:40 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2053.outbound.protection.outlook.com [40.107.241.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D328680
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 07:33:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MuF/VTLXQTb3SODwPZ0H4KWwVlzv2GYQAZjreL+DLmMKLbXZfKqPY76cpOe/JxTS5jfZVEpVlJ2rMOBx0kn4Gim+cabMTwHpMMwu6SOcIMWvM8pFoxwBDdvzcG6oLgqsIYCUHhRawXtf7IUXNlVoJogzyfwr6GIp5YPDfQ4L8O+Ny3RGaEARX7FSc2T/qokIMEQ0eAGmdlzY8fN0dXKwhxb7XjqcZ5FJ7ELxrYPL+fKPPqwfQ803fXPcw84YtEKEZvCsg7oUs/eJKgt/KczIk/PepDzqx0Pug04KE1R+p59qB9xUf4WrphTVDKYWXqtcJF9ENJF+f35Nt34vo+yIZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=201iCm83sZaJnvdebO+u6COIeWYrZ5T7+lGusRY5pn8=;
 b=Sp85gLL5t7v8VAuo1xPle5SndtGxHUxdn5DSMteLG9+VmR4uapDE++s+Cczdr1gz2mwkvCu/vqrGc3c9eG+TJG4Jwxu3aN3J6MjWQZfqtlHEBoXHiOSzoW+QTBWh/6KxySnrYSeIxf2cBwyQVneShKniDghzEqX5lbQS3baLk4CorKqswDltJe/rJw4LCEKsQdE6z8jj3lGjTYmgMajXVNEBtYMlD5USu5hSj5A49D+FjPH8DsJ0VDm1ONTehSfyt+BQ8FqZL58HmXB68t2UYHEx8iOertAB2i4qa3D7KyfRYnasP8WgcqMcdEIFZpZGKMutsv9atLJ4/NqXCepZ5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=201iCm83sZaJnvdebO+u6COIeWYrZ5T7+lGusRY5pn8=;
 b=UsUTwCH/91YmFwBjhY+nn+jSB0y5VVz8hr8spOVtMp++JzVKUrkNf/e67p0VAUoltpJUNPE13hyb1Z8+kVXzP5JEiaArJGD8yGzR9CKStlpPfE4XIXdvlC/EL/upSqgNOFFAEtwcJRTwucn77MfwnUQPpmltoi26Gv3BJyN66Gw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB9116.eurprd04.prod.outlook.com (2603:10a6:10:2f7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 15:33:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 15:33:28 +0000
Date:   Mon, 20 Feb 2023 17:33:24 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ferenc Fejes <fejes@inf.elte.hu>
Cc:     =?utf-8?B?UMOpdGVy?= Antal <peti.antal99@gmail.com>,
        netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        =?utf-8?B?UMOpdGVy?= Antal <antal.peti99@gmail.com>
Subject: Re: [PATCH iproute2] man: tc-mqprio: extend prio-tc-queue mapping
 with examples
Message-ID: <20230220153324.h7drlvwtemymqr43@skbuf>
References: <20230220150548.2021-1-peti.antal99@gmail.com>
 <3e18a65c57ea935ba1ae09fc821197f25a269398.camel@inf.elte.hu>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3e18a65c57ea935ba1ae09fc821197f25a269398.camel@inf.elte.hu>
X-ClientProxiedBy: BE1P281CA0104.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:79::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB9116:EE_
X-MS-Office365-Filtering-Correlation-Id: 48c40530-6b23-4c29-c41c-08db1357d01e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +nxzsp9zaxN/LRhgJ2LGAMq7OtfpkfBqMpQQvaTzuz4/9k10j587wIGUnyFnxiavBFIjsytKPIxkb6HHLz0jV0xIwMA4JgQNmvPaqg/bgIJ/dSGDJCCwJkXqn2FocNM/Nz5YuNyFNLWMpidIgIclJ10efGFywCZXQOyVpGbnpmL5f8YQ4gb25Z7yi+SvsgQeG++Ia5LJ/MZgy+1Z9UKQP1TVJH2G+OWj096LLvgnp5C0nLF5f0bq3CSRd76FU0oJRgRawNWhEvIro0/9iPuSbs+IRByd/S47ZGEK/Ht6lD0NVN9Ym0kAeeDX9YlcGgJGb70yGkfONI8HGUbfthuHAiaP4MtM+uZkQmR7XL4KUbhtrFRpBGNmvWQqmauy5QN4cfagd4fHJVLd7cCR84cYJHa1GoSKQ0krOiuhseygs0/JzSn0LxLsaSsvBMknz8P0lVVdepm462n9Dotr+LrlaKP/tdpMTvqMAn0zw4xtfesnwm79OBK72hbKXWjA3BtY+Sk6FIw1+jv/lka35Eue15fXuN1IQEV2CS0aKuzoBr2rgnQjSmrQfYGjvHWnvPt7P/30q2OYN3InD1XGiT4IIy4/v67r6+V2ntAAsEIchzfZ8gggIkai5i2DllbWMCEx5nlrJll2+TAtjmDTQN7PWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(451199018)(26005)(186003)(6512007)(9686003)(1076003)(6506007)(6666004)(2906002)(33716001)(86362001)(6486002)(38100700002)(4744005)(44832011)(5660300002)(8936002)(41300700001)(4326008)(6916009)(8676002)(66946007)(66476007)(66556008)(478600001)(54906003)(296002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?94Xhb64vVOyVDrJxYzsRorUHH9uOwqmMYarYfhQuMWhUKOwN8UdpV7yQRn?=
 =?iso-8859-1?Q?6JQM6IIeA0iTC5hBhpHO29tx2Mn3V136UJgBjgCHPFBiPEXLjyBW8oq6Jk?=
 =?iso-8859-1?Q?hRcR1byGzqIC5S4J9P2T0SvUdr8rAhPJMxxFoa3e+5XGxmi8S8Apr+eVY3?=
 =?iso-8859-1?Q?zMshAgFVQJMpWL0oSa11FiCp+Q0DfSkt5j98UxoLCQAWCXDpXaU1UOQA2G?=
 =?iso-8859-1?Q?P092r5kRI05bMkFLtLp3nXfqzdTQS5RovUL9MdjhKkyMrKBJIWE6ug4cEc?=
 =?iso-8859-1?Q?sHyax0VAo8pbwODlxKMxdGa+YUn8VtJVpBH5TT+WLevazOFpJGm+LKKztD?=
 =?iso-8859-1?Q?95LnzfcxYAU4q10/Br0Mo8o6E3uO/eBBnbMzAdSi4tfCKrZWpVOLrAcdp0?=
 =?iso-8859-1?Q?qk1CMFeeL8V4vQIB3lOn6EtWaaGHR9DU58zxwocUaRpJedM8rREh0KuHZX?=
 =?iso-8859-1?Q?uT8tlz0NLmWvcWVma3iZOoQPupUqZ70BvJpzappToWF4t/5y+Dt41vLDrf?=
 =?iso-8859-1?Q?3IRGIlMqyqgMO7wf4u4m4rgwqT1jka5ADXt8QZ3yMem8VCn5YkCOeaxPZq?=
 =?iso-8859-1?Q?uD85ibcH/iW+SXGLrSEugB6R8P6c1up5Ltod9nlsyxHFmvexq7wgikPbOR?=
 =?iso-8859-1?Q?EKA+Fwwht9/FuPcjnBmtGkXO4aBQ8M4GRaJKLhU9xH3cYg72LasHGk/3ge?=
 =?iso-8859-1?Q?s1QNHye8Ge1uLTmofqfBfdGpFShUQpgQQMaTwt2K+3xYfWFJNmCIalNKCS?=
 =?iso-8859-1?Q?HzHiLc9EK5yt6hMdqt+W788H3Vf/N5g8zzJIzkLpPp7lLSJEw5/5u+lPrA?=
 =?iso-8859-1?Q?hQPBuS3IqCde5b6kv5drDxV6aV0U0o0/SmpZeyW3ikpOX5gPgLmgKE5LE4?=
 =?iso-8859-1?Q?LgaflH+xmRWP3k8pDkjcXlC17Bd2HtcflVhQVYYPtr+SYTJPVfwRBRUn0p?=
 =?iso-8859-1?Q?xL7cQk55xVqpmZgJ76Pa637uB+xpP+CfBg9YlqUkd0QTRpVyNPiZFkPo+M?=
 =?iso-8859-1?Q?WOLknyO5tZ37nUhtX85aajt8LlgAgudu5qMW5GwAtYJPWsLCQMqW9W1n+p?=
 =?iso-8859-1?Q?zfZYObudvuFvALvPiOLHDlF0x6YBNFv1TG/bLj8jqedT3sijlU4qgqNeOJ?=
 =?iso-8859-1?Q?GMa5DA92MBVA+PcB17u/WTuWVwOWN5FPTmOifY3gbUU8JYwmRvYmgW2psn?=
 =?iso-8859-1?Q?i0FEZRQDA+9F8pZGthwIoBLEJxh1Z4teRhOORMwzjIeVmDxzb58LQNyNBk?=
 =?iso-8859-1?Q?0lHFRo7EVR66KUgpHbc3gmE7MDL7L8IlW+y5TBp8wzgEF8Fk8gQmELnVqe?=
 =?iso-8859-1?Q?ZZFQH6WBEpaZLVMz8SFy8BJzziEOF4v8pbtcpFN1mEnrkMb9EmpZlXsmiN?=
 =?iso-8859-1?Q?8jVE2PKKa8F0qqnc5kP8j4GO451i/CU2/lMhNdcWisaatFFM9WqGYppLVG?=
 =?iso-8859-1?Q?Mvdbtmk0vGt1yb7wBNZ1eiwvzh0H0oh13xArjLQwIVv80Ydp+92MQTr8Ui?=
 =?iso-8859-1?Q?CwtFFuXGTS0Ollp3VnfJYzjaLaaaxfqN4caBCA7YVQMdBkPMu9l/HfJirD?=
 =?iso-8859-1?Q?yV7aRWuMsaUGeQUvLt/yFi7Zxzfo9yZJgHFdFPkccX5kisKlaHUg0yLKPn?=
 =?iso-8859-1?Q?e6R9liO7/Kuih9WTp6UQFSN23/0Cl5VWoE/S3cKPZU2PsBEWAJhm+9Rg?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48c40530-6b23-4c29-c41c-08db1357d01e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 15:33:28.0316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IcPnGwSmozzA9WB9kjMH+SzJH1XoT0ExSxLcZDrwSiDtMZfhr8ZXgrhtIVLjExRLPQWmC01iV1MOMBjh5hoCww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9116
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 04:15:43PM +0100, Ferenc Fejes wrote:
> Hi!
> 
> On Mon, 2023-02-20 at 16:05 +0100, Péter Antal wrote:
> > The current mqprio manual is not detailed about queue mapping
> > and priorities, this patch adds some examples to it.
> 
> Thank you Péter for doing this! The same principles however applies to
> tc-taprio as well so it would be nice to see a v2 with those included
> too.

I think that the well-established phrase "See mqprio(8) for more details."
will do just fine.
