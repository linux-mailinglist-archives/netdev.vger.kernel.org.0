Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD9768AFB5
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 13:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjBEMYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 07:24:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjBEMX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 07:23:59 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2049.outbound.protection.outlook.com [40.107.241.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BF8420D
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 04:23:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtuTi/q19HFRbkzmd41bGPdWymE7glZ8WFKh7iOC/YmgSWzTEszAD5Xr8WqBRwN6tlYj9Bk1cvy2AAF4E6/OmLgh6jX9i16ztX2IxqPokVZvohkmFN3Xs3YE6RAS2Gsu0yFBYW0wggz8iZVOgXM2FwbvTKD7jKlufTteWA5arb9tXwM9JYyMQUoHgbr6zETu9FZfUxHxqALPTSupDz9O4twnuNu/y4TKxGtLx6T0IwRA83+3dZTpNO8Edr9KLUUKa8610PTZDiMdEcVGBiCF4HYbzWXfm2/FqK93D6HjBEd5SHJreBym+/efaPICY/uJcqFAQyFRTxzxv2qVVRV6dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HZlkNorbgM0yOYkwKv1J+s5rko4BphoIuLBvexDAmzo=;
 b=TBjeKm2J47wanQrZ0uocMMFRhdlw3cOloXI6F7Cu+yrQrIlUW/XnVXuu9kK5lCCB2VbI0ZCwCW3e8Kwxpc10gvE6hJ9KO7Q/2ulqLoNg+Z8RRT1zqsizL/OHetjGx4W5CWTAC8pOnk+qObXwfCUdS5n165g9q8t5YDSlOnn5v91KKp6QOUlPfjLUzwHzzD4F74osG67X18NUZUsdqMSwA0Rh8ztYoX50JycYYtgrqXn5wfKYIUYFjGXmAsVKISdri73S7ra/jccAjaBJE0oRGHAnLay1weM6tzTV3I+IpD33p3kv/y32wrYoVRwyZEjkDc+zqoOuqQbNyqcOZR5mVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZlkNorbgM0yOYkwKv1J+s5rko4BphoIuLBvexDAmzo=;
 b=daPlV4NXRwef2hEFovjCgiXiZt90gtc8B1huRT+mva+UGi4Pzc0xo09rBy/uQOWLJXbbqC8LDyAM00M+p1r4+5PFI7XPfYjUKzirVVgmXeFiHfS4jxt1E6Lxua9RgrFZ/NasZQPS1+7OcJdfOCfBmQf1mwLr5WzFAD4nUDpPS2U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7766.eurprd04.prod.outlook.com (2603:10a6:20b:2aa::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Sun, 5 Feb
 2023 12:23:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.032; Sun, 5 Feb 2023
 12:23:55 +0000
Date:   Sun, 5 Feb 2023 14:23:52 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH v5 net-next 11/17] net/sched: taprio: centralize mqprio
 qopt validation
Message-ID: <20230205122352.njikjy4da54gqmnx@skbuf>
References: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
 <20230202003621.2679603-12-vladimir.oltean@nxp.com>
 <58608f36-8ea7-77e0-4b36-efe9f255764d@engleder-embedded.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58608f36-8ea7-77e0-4b36-efe9f255764d@engleder-embedded.com>
X-ClientProxiedBy: VI1P191CA0015.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:800:1ba::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7766:EE_
X-MS-Office365-Filtering-Correlation-Id: b81dee38-ff20-42e9-c839-08db0773d984
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GHLvOLcVssy/z34s93BbZFcpSi8Ojumnb3E5HFR3aKSkjYfIP4Wtq5XsaU/i7RVq1we8wZbb2TPuq33ctY4g2/uU8yUq54H0nE1GKgYvwHOs6+2kfGhI+w6kYXn7Y3xE+dS3JC2Ils/084tyTk9Kn5+rEVdX3hEyEldgHniDMmuPFkiMfCkOB3yhjOmu/pIxbbnvT319SmdTQP7XdpmPOIKl6tSZljFFp0TxXNAYrxtPW+h2Y4OxNV3Dmrz2LiuHYFsjTry4bSgorS+qUCvEIi27Wg7Sg4c2pLP2CLsysM/CnVLlRLfZJQk2dNTSXSS6JCc/ah4YMPZKzJlMxRu+tmN+gAqe9+VMvWOMXd4l3ciq5Cvd+O0qVfPaZQioVdnHVHF2n/yVcoAp3HH9La/nM0Obk0UnEFItcNDSSpTe9QuhH/jj3Pj7ZKzX7tESQyz52sKEH+FXKVJ+vHM3a9XCGCfZ6mFCYyP3Kd26FomdcTKCVNIeRiTvt/B3Y9bF67KAEr+5udMQQsuU4o/lsapyqsAep1nDi21MKKDcXwKwgw6zYVN9Dte3O9gx4qpELb3kkS+WkrU/nsXikW+PJvPcKLoPr5VAlzlT1MPD6+qLAMCkgmYNLWs8zTcDFls/cOnPd6wqbelJeP6HPka3vPlLyRKbTM3SCVnYdWLWobYgus4S11adewfRib8/L6Jk+W49
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(136003)(376002)(366004)(396003)(39860400002)(346002)(451199018)(38100700002)(316002)(66476007)(8676002)(6916009)(4326008)(66556008)(54906003)(66946007)(8936002)(41300700001)(86362001)(6666004)(966005)(9686003)(6512007)(186003)(26005)(6506007)(1076003)(2906002)(33716001)(44832011)(5660300002)(7416002)(4744005)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P8nmvUmdy5x7BdcbHHv0ZinumBeWPMQJZhpooWGi3ACuW2gzWlBBOEfwAldS?=
 =?us-ascii?Q?EfXwlQG7pViqlmdmsSLWUuLhU7CowLU9bCKExnAQWZ/TKBz/chfSlRQkHvZK?=
 =?us-ascii?Q?+i85pC77PvPt4OUrP0Jh7e+vjVQTO5bVEce3lI6vhAzH4OBFiEfBYsTsdlDF?=
 =?us-ascii?Q?P/AtL/DYs7bG6hNOtiobayLYbZIG0e1ks326SROjsxzuxj0BGiCZzaTysVmk?=
 =?us-ascii?Q?OtBf3Odzp5/jt3nPnznwzDJWXmDdazuyCpvVd5lTaWgBrnGC94fLz35km34Q?=
 =?us-ascii?Q?Ggt+jICr972ylwsGQDlemYbFPoJgHcff+GQEJ4JdYDwyyx2GT0niy3CmYMLx?=
 =?us-ascii?Q?jej2qF8BOTqdAWU14BaFMwhptxf2/Kewl5bVjACUpe0cMMAVPn8yRg9ljVd9?=
 =?us-ascii?Q?t9S5QF/vFTnxnp0MKf0/MpzVoEknCiktkXmEn0hO0T0j12d3EVpt20lGS6H8?=
 =?us-ascii?Q?oFedPIqlYVF6a6qH0Yf3e4+2pK/aI50b2wFSNesO+9Vu9smd2gsjjd29T/dg?=
 =?us-ascii?Q?7I0BkKczQqZJm/jAA31BQUvxQ0lrSR/9xU/U7mTPhIINI8A0BEr7HE26w6oj?=
 =?us-ascii?Q?kfyu8JLxpGc3xTlmsef0XwfyT0roYZtu1VrMMhPllahSA/Ux+sU4fXNckIZp?=
 =?us-ascii?Q?EabOtwFl3K4kLkTmM/6413sHtI1NNbgsFRcKVU5Bhk/4tvYzd+5+xEeCd/08?=
 =?us-ascii?Q?rNzlnomhCq0q+eeSxZ+iP+EvZWc6YBawyJHHpnqaeqZyWNguEwlQWYZABt6g?=
 =?us-ascii?Q?Ed2nI+I+kMtVGav/CHPvZpB+z5a92a7I9ub87+pmyNtkls84oKXX0YrJDBBK?=
 =?us-ascii?Q?49wKjByPO86t+CHul7isR1RKCm1EEyCYh6yQIK9tUZtyeSzGRIRf3nOml4OO?=
 =?us-ascii?Q?1xB2Rj10gZUiptEla5EGGJ9Rsnaq8JAW9nbsWZXbkuCEz93tNjgIHKRvF+WW?=
 =?us-ascii?Q?OIOhib5I++GgJP1Z6wxzpugY0zgOCQhbPBkZeWcguicbo8hoPVVwEAJX4PY3?=
 =?us-ascii?Q?VxFVQkyH3svScqESrLuSgPkk/Nv31WE1XC4oqSOpVc2LFtHs7sBda9yUhk/b?=
 =?us-ascii?Q?GQ2pxa1nH1zwMuNi103kLG8bnlN271+QD16GWlcfMbo7ULUBeSoDIiVbHAgn?=
 =?us-ascii?Q?ZwKRb8mEn2AERDP/w208Fo1mnn9lhbS/eTXBQbM4gdo0jS2cFwkUPWSFwR/O?=
 =?us-ascii?Q?/ZwPCteK60grtM0jnXCKUGN2vic4RfZ//84CiXou3Gexh+DtNcVT9HCDA3it?=
 =?us-ascii?Q?Y4SV437sYNbgXes/tgVOUBMxdQOWgNdzVChouIdXlN4c/9Naom1w10PSgMtT?=
 =?us-ascii?Q?vGxI+2niklwBt6BHBMN/xweRQg3mmgAe6y3q5a3HcFR6ycrq4QczmbkQKG+i?=
 =?us-ascii?Q?CkK2WO/u4RluNWQQXcKQHoaeqFO0WXpqpyOZTOePOabyXYikT9yiZYGX6lXb?=
 =?us-ascii?Q?s7zAbsKAe9zemGhinLXWqgdFvfyA+n9I2ZHhg58Xa9W5VA0TVX0KGisB5DCT?=
 =?us-ascii?Q?4bg1g929FXRkBVEl4cWz4hHaAHGOU5VG2gEFnjRkCcy3SLdYbIKOo5BsNFGh?=
 =?us-ascii?Q?+Y8xE+JsUs2vneRiWf9TBYUvq1W/tl9cp/JNieU4EAJ5bdvVC/X3mJZ9qtrV?=
 =?us-ascii?Q?AQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b81dee38-ff20-42e9-c839-08db0773d984
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 12:23:55.6298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MbMle/2QPYNgQyjnRixRVWJBSsBBCchagkHf/K5a3YfKRqlD8jlxx7hfoScURAcS9gcz7U4x5gvMmEKeduGxDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7766
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 05, 2023 at 01:10:35PM +0100, Gerhard Engleder wrote:
> > +static bool intervals_overlap(int a, int b, int c, int d)
> 
> You may could keep the comment for this function.
> /* Returns true if the intervals [a, b) and [c, d) overlap. */
> 
> Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>

That was fixed in v6.
https://patchwork.kernel.org/project/netdevbpf/patch/20230204135307.1036988-8-vladimir.oltean@nxp.com/
