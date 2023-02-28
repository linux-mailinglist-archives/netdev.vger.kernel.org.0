Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1543B6A5806
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 12:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbjB1L1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 06:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbjB1L1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 06:27:47 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20729.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3679008
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 03:27:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jtUh417sMjBl3vE+M6R4Wavc8JaO4qQ0kCFwK4hijh5IgXAWK4eAAr7e+Ataxibvbd4sY8NYILHf9XnJh3l87JSSNxAghIEDXqna6SajUWtjyfICUklSavWsKESwasNHqcBXtb+htjOQ2QMsSm5bX+Uko883CHdz6UXD3pqF9jRou0OMLFmH/fORSGITZpfi25hEqOJrPJO0uotjR1V3eSN81v5Mzi6D/oNbu9NuqjCq3Sf2OGEu/XpuZp3vtKbIioMIgtTgBNCf0Wr+kVmzV59AoIz/V3AzJS5jbuppN7JkllE9m+QMCREvWrio4EBNnPghWsof6mL1qqV1PaAhRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6MX8glnjqGFfKGbNB+A53mS7+w41oH9gZHQEveuvnBY=;
 b=RJiIxV+8aMjfu8a1IqpgTgZCi170+PR1z/EbvF786LXERvTrGOO2wEjGNPzC4rXo4acJgpYRhYWxNNHXL09aVE/3KDQPBVNeH83VRcvDL7/s6jHFjkxeVs17B8RDYHmG/ggLAa9oupZQV2ZyPzyvaNRwsUEP4MH4j6YdKReDksivf7ngOku0EapiGGcm8VOAywrkNp7UJjAioQazN6b/D0OkrAolgxryCCfpVrYw5pNCVpY9tZ6Bsw2H3ISniS2ayy6+dv9+iSyRkCGT1rpHRrwG6SnF8qOafh2TbEZd2mJ6EE8pe+fqvjpulLDAv6ZKAaJmmIQkJh7hWFMZ5durDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6MX8glnjqGFfKGbNB+A53mS7+w41oH9gZHQEveuvnBY=;
 b=VPqtlIT8QiPncpkNS2Tu5EHw87zrfTv8vU6VvmpRMwO72BSnQhpFSzLJ3dvF/80SGKOY4uXYRsGY5Y9De6gnf+Jr8lZ86dT9/zhlCsadRPUFdQNqYwwK7QwAi9Pg/Vn87R/DrPGSr4PUOE2/iA6m+B6NW37uUBtTbflX6E3sHPc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5373.namprd13.prod.outlook.com (2603:10b6:806:20c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Tue, 28 Feb
 2023 11:24:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 11:24:31 +0000
Date:   Tue, 28 Feb 2023 12:24:20 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, gaurav.jain@nxp.com, borisp@nvidia.com,
        john.fastabend@gmail.com
Subject: Re: [PATCH net] tls: rx: fix return value for async crypto
Message-ID: <Y/3kZDAzhTT4RlYY@corigine.com>
References: <20230227181201.1793772-1-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227181201.1793772-1-kuba@kernel.org>
X-ClientProxiedBy: AS4P250CA0025.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5373:EE_
X-MS-Office365-Filtering-Correlation-Id: af188cfa-5185-4487-bea5-08db197e5c8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h4/Kc+PnFC6ypQJ9GIwwieRElorosTdM5rJiHhvJic0qPrQjjnwHWAjrpDBs+pQa8QZhCYNJEzNmAVWCP8GXRWVdDW3N5NNHhPBqYf6iEgyuMgUxSXB4UmLioCTapbCRFuKSsO1nt+fiLDur5MLgGDtRoMClM82qJl1O+FrlPo5JSpaR5UfPfKweE0wuMdPC5OZ6uOrOxl/GvKWfVCs+eOl9DQXi9TwbpKdchTDNLAOpDJi59COOMqbUua3fq/MsiYQTsECB1hUIXuBY/i77u1vCheBIheYQiZ3fw1qTRJI9iKOc8V8fQ5w6RTcC2cZULbQHlMfkk2NEFKyKcMxOJ73vwsat588xWyJ1Wxl8UilU3YmStza9actp2tigAgkjgheSASy5grI3OT4Gk9Q1KVfGwzacnVJJMehw5E2arE+buz0TkiV04zOI9qhfqshLLkF/1ellwJ1ztzyui/NjMlR5RVHx7WYs6kR73ey9vWoznLAk17YNz4X6yfS6maQZFWsBkg4i6pxWhmAiYSk3cnFsSoCgJuSOPodbC5iVLxW7WnjNPX5nqdQS31sCGjVUf+Hjok0NoNL4mZLkmbuQ53oj5Pg8nO90J8/5MkonodEmxKXPdUCGCGKwkw5jeUFagSpWPeAebOGJmIe7tHgx+PJhsDiE/JjzA9YSFIvlxHI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39840400004)(346002)(136003)(396003)(366004)(451199018)(316002)(5660300002)(41300700001)(186003)(66476007)(6486002)(6916009)(83380400001)(66946007)(966005)(86362001)(6506007)(8676002)(66556008)(478600001)(2906002)(6512007)(36756003)(6666004)(2616005)(44832011)(8936002)(4744005)(38100700002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y4hp4bH+X4F8uIvyCPRfbyf2BRte50TqYu4YxBET23flJvvQHdgLjSpFvMyO?=
 =?us-ascii?Q?NlxNtcssrXT9mrA+LuP52OntX7MY3Rg4/6xxKxfol1/Vc1tMaz6BT6kpQfla?=
 =?us-ascii?Q?qwYZm1eEEsh/2W5ziDZ0lr/U3K3lpphJJcYTQOPzdFcy/0nih6WxvPgZhcD6?=
 =?us-ascii?Q?JHm/qq8PZPtGsAzKHwOgQK7bqjoItXDArty2Wrj8MfYfrJloSG/VLqAyWwVO?=
 =?us-ascii?Q?Ryv96lwWRp6b1pLJq0Rcbz7awS5TZmq0XlwRkvWVnNq91p11w5WQgbQru1Fc?=
 =?us-ascii?Q?QvDwv2rnzwfpEI56YUg6NmjpzsVYtU2BySeFSUqE2qWEPh6i/qXU+Y4k/T/e?=
 =?us-ascii?Q?j3T5/q6P/MGCYpFURAth0TmXw31YmsiXwKuBKh48b8GcpMoUA/WOqk6rINGO?=
 =?us-ascii?Q?GSdT7wtiADfWz8SFYZbk+Ofssj084Wzi65gCM5GTXEXfTjZ/aY300vyPhlkS?=
 =?us-ascii?Q?dND91gVuKO0825nxf8Iw98NRzBgE9dZsfSayVmy/5tIborCLYcL1FOjvJfIN?=
 =?us-ascii?Q?agPMFGgW/Jt/y4/j+Oczk56r3dWhGeUl6UbWJRFabojiKaaFZuNyhfRJyveM?=
 =?us-ascii?Q?YCZBA4TcF5Ii58Rqfhm35sB7a/fki6Us8QrM4aauvvAZLQ3fdytH1NYmzAOj?=
 =?us-ascii?Q?zUGj4b6NIXIBusm+ynFvEZelmpS91MbIg1EuEEzv8YuUGLAUayigFwmN0vFV?=
 =?us-ascii?Q?5EhXRqRfIQ6bnKwhfFrMZ9ZNayhjC4upkek4UFa5k9kUQU2y+ls+ptdm9d4g?=
 =?us-ascii?Q?ExTiwnOUNXd/KEpAq+i2odpLdcXAZeeeLUol23Sbaohtx/8tERNZMPejKSDv?=
 =?us-ascii?Q?8l6HwuipBBReB3vx9sh0Oy4KbpxvpvRpwvVD8gbUbn9ektFN9p35fuh1fLxn?=
 =?us-ascii?Q?Jw1O7W+ZNQayeADpI0zJQAO4lOHoEb2mAZTzDNTvUswwi74GU8V+0JUSwn2I?=
 =?us-ascii?Q?HrGkI89Y6EHxySRt+b5dL6y1yIcilRs7T4OYWXFDvWGgY2wrgRNBs4XPOGzt?=
 =?us-ascii?Q?Vo1DBurVrX0tM7aJh8wTOU7tGSRwcjdG8vzJpsIPeJ9O+CBSMoeXVfzEXXy2?=
 =?us-ascii?Q?ezkQKRa7Gw6jhDqcGL31TgHFE1ujpcASLVulM3HoxIuKLMieWmCOSbx+I69j?=
 =?us-ascii?Q?1WQeplr/4wLbJUFYN5WofHtqpsD6SiDV2iwwa99Wn9t08wK8VzZ/qutL6y9M?=
 =?us-ascii?Q?q5YdnH3JkMvgA84STrpZh6ucRnmeF7PbFNwj/OTelD70EGWN2f/Qj0sa0lOd?=
 =?us-ascii?Q?zL6Nh0umxis0mMIYlBtaEPBCRXABZnLXdG2SaVtOgtxkvu4672TXwocrvWWx?=
 =?us-ascii?Q?rVZ4neugpfkfaW//ODWvwuHCA1eVL7KziCDpSTYRtbf8boT3YVBYNHisWbXu?=
 =?us-ascii?Q?Ih9FFSVOKVRXzyXLsSD+HHGA9LeXe+PH4SBtd/Qw33Fio6NHMAMCAnW4A+jG?=
 =?us-ascii?Q?JWumYUud45zzrAsHCQR6naR8SNM3IihGEVAjuQnITl+7Dd5MdE7B0stUXN6x?=
 =?us-ascii?Q?41Zs99i/bI1eo9L50eOVZG1E9GMj95LJdCITfonqLNmCWTYK3g+QLk120atH?=
 =?us-ascii?Q?9z5TYysFRIyaJnzY+M0H6F0zWJ35j1NFYasbxsfOi8lwp8PxFFd8kSSmDaXa?=
 =?us-ascii?Q?Aj8yYFxel64WvjPaKxgbznW4xVYAPk9ZxJQh9iMZokgdtV8ibqO56+RB7lPE?=
 =?us-ascii?Q?Rth/Vw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af188cfa-5185-4487-bea5-08db197e5c8e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 11:24:31.4676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2L/4kfLCntf2krm7h8Pxe6/c4RBKcuU3qWWTnisP9MGq04AtHoOn+bigy4VnfyStuVlv1X/xwda0KMY8yIKr8ERSIuAe83gePKSC+4SN7WA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5373
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 10:12:01AM -0800, Jakub Kicinski wrote:
> Gaurav reports that TLS Rx is broken with async crypto
> accelerators. The commit under fixes missed updating
> the retval byte counting logic when updating how records
> are stored. Even tho both before and after the change
> 'decrypted' was updated inside the main loop, it was
> completely overwritten when processing the async
> completions. Now that the rx_list only holds
> non-zero-copy records we need to add, not overwrite.
> 
> Reported-and-bisected-by: Gaurav Jain <gaurav.jain@nxp.com>
> Fixes: cbbdee9918a2 ("tls: rx: async: don't put async zc on the list")
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=217064
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

