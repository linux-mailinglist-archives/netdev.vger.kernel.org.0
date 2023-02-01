Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E00468680A
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 15:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbjBAOMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 09:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbjBAOMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 09:12:54 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2110.outbound.protection.outlook.com [40.107.102.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E0D5925D
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 06:12:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KA58sjaIr+p+QhixeCVvvHjruvDEQ1swgmv35QmZDGSaYbJ/uqi4KJXoItCUeUnaoLuhqANOUwhBo8IVFM/SqO/fivAzUYwsiGBoexmOPjjXZCQ7qjpDfNmnkapS9PAkuZh5W6W49s2W0ZyBzJXdT9Ky1cvS7x615/pP0OxGil1tKGrghdMyCmmfl/n/UPhROpk43Q0LvL56FgcOs6b7Wm2EmVLdrZpBacJhf8tLBzLLzRrsyNRxDpwYe3Km9Nt/0iuSw+A9a1AINbELbWHQQ34UnH6iXnPwBQWVAYuE3wUQxx0e10v4h0ybs+o8emIp+KIi23svK5MK2TknUu/J2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hlUOqpBxh9t+DmyZevMvh1N//1NMp7wvpXwE6RkpKo=;
 b=OoOx/pHKyKByLNBvkT7Epi51Q5Oi0alv/HHhmueSRlHd83eQTrjJ+7rLrGbLOIXD/wYIRVSYSR5DwLdwhbwVCIEYLxv7FPdtlCDM54Rg8TKGtYouXJW68T3TppRvCjNbNLNuXjZDeFwtqY8hdzIIGsbnPzQoqR2kKCXIOZNfmghEUwFQSErURzyOxCr+aCJ1RYX8spF7qq3SZwpmCNKzxD/IQnxjnZqiS8IfG6xH0Hpow6z3Wdnw8nPQTu8ze2WOuFyNSWXKGQ2rFixNEzx2yOzcw91MDT+7OrFSbjETLWYypIe3/snY6BXKYKE4s05y0wFBxKYgJqQCWQQ19imLcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hlUOqpBxh9t+DmyZevMvh1N//1NMp7wvpXwE6RkpKo=;
 b=jkLZxOrarbZjc+g0Qpbe6SVMEb1/dbqosBUXUhV2OBeCTC3C5jjVT6/DspuRcntz8i+2eho7b2nmveElPUi1OjQ1K0K9FlqSK+byOMnzyZwBfm7AbXnuxirrfsDyQpzreuHoU0NJ4gjlttV7+MwYiUqBkyRRdEPWBWSXT+fLOXE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3795.namprd13.prod.outlook.com (2603:10b6:a03:21a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 14:12:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.025; Wed, 1 Feb 2023
 14:12:51 +0000
Date:   Wed, 1 Feb 2023 15:12:43 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
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
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH v4 net-next 10/15] net: enetc: request mqprio to validate
 the queue counts
Message-ID: <Y9pzW3i3yqO/bnjE@corigine.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
 <20230130173145.475943-11-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130173145.475943-11-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM9P193CA0009.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3795:EE_
X-MS-Office365-Filtering-Correlation-Id: eac54592-b56d-4a71-50ea-08db045e675e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VEGip7EZjzacHIqghtlsmsE5I75giXx3MNenZkuE65qPRuZErTj3BvnxpbnsYoneAwdOmRRfGluR3S7Yjb1/tPtV2VHzLO5ReJIIkWExAtR0Vl85CUARRSTfUvT/jzhmRuAlLRqfbpwC3iPptPBnhlbip4r/s7ZaBebToYySY02rzy5P5fVCaipa+DyjkBDJNuMlUj++Nhz555190tgtno8F7RTY21ZuQNm6C6gSi7/8vFBvvQS1/kq/nHov9BjuZGJl/gsKNx5tWozjsa5RhBn5tCextUa2d9Rw6V5JaG4XNFQZMetMUFpoQb/lwFI3blXs7dP/xdwSqxgcU+dNciRaVIjJGU6n4vH1EO5m5WWsIaxu00FhXRv+2rhPIazvzdLT+5TMdXXM4VVpyx7m7E5RViVxyKTozouHzBC+Y/cboQ5VHSxwfODst063+IKkTrqBXJc7MfBD+fwXJZn2P4YbGhlQDMnPxqcsmmXINjPW3AMmAIlVRnnVb0LKAVGfmpxUaavsyCG5bDXF92/MHPure7zqyR+TidupMfM7vOa/rjNmu8T3Lu24k8lTavX0vhwMlKUIdwJtB6LVlMfaOhlfjHMX6fndrnhWXeuofFuICcyzj12Y9C0yW9T8DDPlOE52sMTeXHL9xCvBRiIHhybrBePZivl0O2R8wu+oiL4K1J6Rq8yvWMFEFOuadtum
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(136003)(39830400003)(366004)(451199018)(6666004)(41300700001)(36756003)(6916009)(66946007)(54906003)(316002)(8676002)(4326008)(66476007)(8936002)(66556008)(7416002)(5660300002)(38100700002)(86362001)(6506007)(186003)(6512007)(2906002)(4744005)(44832011)(15650500001)(6486002)(83380400001)(478600001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s4Ilga7817HteOVojK3CrSZZUJFSy6s7y4wpwEzAmRN/MlT/HqcC+gh0q7Ho?=
 =?us-ascii?Q?yPHySK47pAGQyn6m51VihbgFviBbszrXmX5jEzbd6iUzZFGCxstS5EUO62Qi?=
 =?us-ascii?Q?QaTBALlAFzEDvm9yLRWxU81Jc+x87c84iHBN73Aa9fLJ70h1aF/M6SQPYSWT?=
 =?us-ascii?Q?S1dBmvxkT55kPqCtk8gfyQNwDIjsZDkcoriuciGVpS9/NwN7EksANjY3XOqf?=
 =?us-ascii?Q?XVgd1NM5jtymFkdas4G4s+8ll4/BgqlXKivpCAkpCM9gSU3NZeqNMkRw1P3K?=
 =?us-ascii?Q?X9Z/H58WUuvijCb15PdaT7P0IwrF3LJHwc1kkPS2jZiA9Ctq7pdpgxyPLUxX?=
 =?us-ascii?Q?AT1B470uCb5D9ZWZ4s7zhgQ5l9mjc5fzvOfBVpd5KiP046nNB4prGh4G0/yW?=
 =?us-ascii?Q?4O+u3WcLTVn2U/jOJ0V2qhh01l3YZYOarJ3Ty5I8fSc9sQNmM1/p/T4oGmoT?=
 =?us-ascii?Q?c8jO1OzlKgSrhpw5g93gTrzUNc7Jetg0DRhHTzlgYaWpZZaKnWC+Bp83pwkE?=
 =?us-ascii?Q?IRuvVZZm1YOXauZ092YLsey3VVeVOwPkqKgVuOKZ6vzwIzTcfmkhxJ81HURe?=
 =?us-ascii?Q?RcfropS894NDk8UrXC3EA+IFRmkHUtGM00eP+Q68wsRovsXAuzkypMeiHnSr?=
 =?us-ascii?Q?PQINgLU5FaeQlxuW6SfZ7ny8zzRWAe04eUZ8gVGim8yb14HW7wJw+leQUdI1?=
 =?us-ascii?Q?ab/qxnVBQO4Nzhk5+FGQS/uCsQ+5tdOsz1FHJJkviRG+ZdDX1HqGEoITL2rU?=
 =?us-ascii?Q?2sb4lYQVBRqJBsIVyZDLqPc4eKyw9oMff6CRfh9e8KO5HeyLhlCti40xE++1?=
 =?us-ascii?Q?0FZp1PxuuWzuxxOYwT87eNfAWYGwS68z9UKlPkEtVHlcjWC9dLwOmHHAt7fE?=
 =?us-ascii?Q?u33iMtslXaT8kbx7zjGjzjE4VHsy73eKRTqpJcItUusQPORYbtqmAd/GW4uO?=
 =?us-ascii?Q?/KSutKpKLlUSpEcZFSRB7LUUOZku+16/o7mVM57xSrtDmG7VB+u8ENXw/ZfW?=
 =?us-ascii?Q?AiSunES592IdbTbEibY8RU7nzUFqA0H/qaVWvmPRGoVZV8EcLb0NUlvPV/jE?=
 =?us-ascii?Q?n3b+JiH9fB4ZaHsrzPuFlzLX6L6uLn8jlb1/iotXMGs9qZ3nS/eRsYOHiq2D?=
 =?us-ascii?Q?lW8cnJmy4pJnPlnKRkG7MSS0Qu28Cvs1HJA3kiUgIJUDe0cWXnrqAuAPBeXu?=
 =?us-ascii?Q?nvZt0cpqR55cZgqMMiow9oYan2tByLtx0xrEMgCW7NgahUVO+bGpIcF5xDB0?=
 =?us-ascii?Q?M9VcgcM9I9KJh7Qi8y3U+S8o38ff5Bd+eE9mW082o5jJ5c3zkG9cUbLLCjGw?=
 =?us-ascii?Q?Mh8lyPwvnpTkI8K4S0Iz2WcN566wlE/2VoROYEVZkS6zfrZYcrQOt/Mdxepg?=
 =?us-ascii?Q?4kyu9djxP/963UkFkFEe37TW7yk2DqiIXGgdUdhM5yWC+Q+h2zEsP9AiuZVc?=
 =?us-ascii?Q?beBsa1Pt9xmcDmXkjQ+1/ejfV5jb8r4yqqYcOvBHAnsUeOB29+I4CKnYrZLU?=
 =?us-ascii?Q?o6QF8BDrX0/jxYM4Uf5lrv/WOTfuacjvvCL0d00spRBUggD5cya21s6QeUXK?=
 =?us-ascii?Q?NyOn87ozr8zT5hIxibPSseJs3ZIJBIV5ezQQfDImJq6CYjVvQ19UcSCi6Acr?=
 =?us-ascii?Q?dcTnq7WgiQNG9Lhbhqs8//SAaGPoOuvYQ5u+e/Io0dFxf4Mvi2btY1b9aylU?=
 =?us-ascii?Q?OwjWPw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eac54592-b56d-4a71-50ea-08db045e675e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 14:12:51.3384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JZYGLuxCdnm7tKbrAidP1A9naxNUYeerpw4dMyoLpzOmqAsZfSC4F9DQWwhUxs5BiX6S1iojHb9kskaLPQPsuQRND1/IFfDpWTmLjmVQZWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3795
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 07:31:40PM +0200, Vladimir Oltean wrote:
> The enetc driver does not validate the mqprio queue configuration, so it
> currently allows things like this:
> 
> $ tc qdisc add dev swp0 root handle 1: mqprio num_tc 8 \
> 	map 0 1 2 3 4 5 6 7 queues 3@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 1
> 
> By requesting validation via the mqprio capability structure, this is no
> longer allowed, and needs no custom code in the driver.
> 
> The check that num_tc <= real_num_tx_queues also becomes superfluous and
> can be dropped, because mqprio_validate_queue_counts() validates that no
> TXQ range exceeds real_num_tx_queues. That is a stronger check, because
> there is at least 1 TXQ per TC, so there are at least as many TXQs as TCs.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

