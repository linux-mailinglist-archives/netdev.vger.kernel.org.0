Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D7E6DBB98
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 16:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjDHOd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 10:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDHOd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 10:33:27 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2099.outbound.protection.outlook.com [40.107.237.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE124271E;
        Sat,  8 Apr 2023 07:33:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7nW07TYBwW+uzZaItaoab0qAiHnDg5XkQGvDU41hbWAGD6xCm/Njvf8r+GtdZkMrX4gCgjD28yXdYHwerM0nJ4SfdXryB0wJr+TLWQdukioC7z772WCXLxM888SYhv89ZVGKOWdxo1If2HbTYdDx2UTjfVkU3EaMDS/EK0/2Jai9MNfS51GpPO5Ed2SMJW3iZyZZ3tOoCg3H8PdyAzXsI1GrEyys1/yLXatJtydmrZaaoz7/jRRfda3wU/m+xC96OS5BWKU2g12mKqZCGiLiCnYDA9wBDe8NGtzaYig0Ia2lH2dDZpgaWOhrPfhXAqhr1V8kgb+V7PtFb8WIgfWjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1pKSpoRryPwo29q9PUMKIlEJ8mc6tu1G3f9+v5PVxKY=;
 b=VMJNNN/32spro7zqVMQCiidbbNwn7tCcijaRFfyUjaXE5/ZCsmb71zKFhM6ccCTzYq9kxxvNQiic889paDsrkJdrw8e0LSqhDuiE9ssvEj1ysnQwQ48x31AuNIpCQ2ibfZfKe/16dU7PN4ooGuEth5txY29sgxTwK9lDkrfoWhNZE0onwbOJ6S108kmJd6+npHheTu0yEdumH+wIkeAzGzo871OlIqruWKkLuXmN3rNMqXJJ6D2DfSalSGb7q8L+TdwPb35n7G6A98lJylQdr5kL1k4ncTLIdAkoyuf/rrkhPP3VWeu/sXIQZN+7CWkLxs1zKPSKjAnoKiqlRaTuCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1pKSpoRryPwo29q9PUMKIlEJ8mc6tu1G3f9+v5PVxKY=;
 b=LzMSOKFCHTPjbhoUW0NFwrQ+HjVYBQFmd5qaanzKwrGAM8T5VnCdcsLr3N9xVH9tlEfuR0CBbZdKGiT/a4T/i0fnOY2ZxxEFibwd04s339iXb0pAG/cr0Osyj8RbCoBbilntesR+zTc21Hp61/9wbqDWDRNERgGX1pOM04tAtqw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by BY3PR13MB4867.namprd13.prod.outlook.com (2603:10b6:a03:360::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Sat, 8 Apr
 2023 14:33:21 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::8e7a:5558:6bfc:85f9]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::8e7a:5558:6bfc:85f9%3]) with mapi id 15.20.6277.036; Sat, 8 Apr 2023
 14:33:21 +0000
Date:   Sat, 8 Apr 2023 16:33:12 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        gakula@marvell.com, richardcochran@gmail.com, lcherian@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com
Subject: Re: [net PATCH v2 1/7] octeontx2-af: Secure APR table update with
 the lock
Message-ID: <ZDF7KFavZuM2SoGO@corigine.com>
References: <20230407122344.4059-1-saikrishnag@marvell.com>
 <20230407122344.4059-2-saikrishnag@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407122344.4059-2-saikrishnag@marvell.com>
X-ClientProxiedBy: AM3PR04CA0137.eurprd04.prod.outlook.com (2603:10a6:207::21)
 To BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|BY3PR13MB4867:EE_
X-MS-Office365-Filtering-Correlation-Id: f696b953-b280-4547-fa1a-08db383e339f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /e0UcylOIvFqLA8vHuyrcOkfYpJD1DRbHM6xMyXMjkfUgalh3N21T9Y+lKN7PtzjCydEW/psor+3G817wJB+VutxX5fdCfD//wHXxLLkCYXmdUT27KLs29kH5SSf0Gm3c4KhDxVX0W8FIjO47zgpk/oCKcn1vwMb2Ea4Qfd/1+o6xpv4+N7INhDt4aJYbXgFPaI2OUHWlbnsQJV2+qhrbu/m4tG0ncWMo90UbrhEYmEObElCc032FHt5HtAOuagynLdlft82ru5OU2oWvKuqw/yLK/vig0wA8PqKgwEHk2V5OM0KzE2hCzpc2SrzYM5V65gfdbxkPxSyE1ZK4IxbHkHjAeD7VLjtLGUo8K/UH+mA4eJUeO8ELhiMT4rEhYSPsYyk3xWJbOlQc46i9m9GnSWj0DbXfaM/VZu348L1MCab+tgXJUumhmHPEmvnY1zn1W8gIDnuP7GiHMSVMcN9W2HddFCPucjEea9rBZGtrcoJmSLPgZV3Ad3l7U5Fsh24K9JpluXdMr4QsIkWmvhayhbjLpKcpPdBYwUOWikA01S5U20sy+CNiMnTsoMv8+XQWv2z8AvH/ST2LFdEf8xti6JAp+2qi88ym4xvPKle73Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(39840400004)(366004)(346002)(451199021)(478600001)(86362001)(83380400001)(36756003)(38100700002)(2616005)(6666004)(6486002)(4744005)(2906002)(44832011)(316002)(186003)(6512007)(6506007)(7416002)(66476007)(8676002)(6916009)(41300700001)(8936002)(5660300002)(66556008)(15650500001)(4326008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kYYUGBO9DHp68G3c1ZHs5qNHbsUZyKeRCOx91Gxwvptbv33PW7koHXOAsdv8?=
 =?us-ascii?Q?qxOWd27QF55ckb4DdPuEqNM8uyfwptAkmVh/VGQXbPLPyyqHRRp7bwbQkifU?=
 =?us-ascii?Q?5hajEIUOf9nHWuwWu7TuiIDOVGfNMPgwe6guivS5WJmkUR5jxiduDOiAP0oL?=
 =?us-ascii?Q?/6F0NiORzxgKTRHwcpulRWfWOMytLdroKXvbK4WM/zhnFQZTKze+Chw4TctZ?=
 =?us-ascii?Q?VYU1ugytEJV9fD3d/dJfhj+bm5muSvA62S1cUOB4MkYKLX8BdNn2RjbQ4kZC?=
 =?us-ascii?Q?a1lNe2pOqcd5grKFDnVwyJP/Wz+Cqqltjeit4NRViD9U5mOf2viqv3fv+nE8?=
 =?us-ascii?Q?NPJyPVIj/D0DFXO3sRsWVBAeuGBXZW4n9RV6ybpc0usuaaptFMsY13OhG67J?=
 =?us-ascii?Q?mBp5RU212jJzuls2A39a3hG1LwcdejmfRvCIye3J5KXZThB2tgwbb7orooz+?=
 =?us-ascii?Q?DeDS2HThEHJCB5e2ftvH17prWFmxQBiACA+EhEGccs+ziA+hqa4A4Kd0jQ9v?=
 =?us-ascii?Q?ljeemQPG9N4bIjHDWs7scEDVWA62r+iy2jDEjuSwUkWUI8OScEl9ZkzFO9cL?=
 =?us-ascii?Q?acMUmY+z+X0TtJwNti9a8Ej6GPAwTrm8WgujAa5qrMbEdTtWgG3+2PwE2HZJ?=
 =?us-ascii?Q?6q00fZVIVRwNSX5cvHTbbLINuBn8K6dgO8wlrpgrkAU6JDCxEumX8RbNeUw7?=
 =?us-ascii?Q?9S1tQLA+V5vS3cTs6rvWJTRP8JjGEdhOL0t7HGsHI4YBT5kSsXix5nqt9wTE?=
 =?us-ascii?Q?7ZY/gZ4SodL/pN6xtvSFm46PB483smKxh6Kc3564Q3KMqdZiG93b6v0yBEgQ?=
 =?us-ascii?Q?URN4tPy4STn4eufqL/XILuGKqFaeWes0f3sDl5GZpLLBTegQ3uV6+aUt3Ayz?=
 =?us-ascii?Q?nYciTayMJqSRjgB/I21aRYZE5xxXVv8ViZiBLlm11KYQVLwN0qvqkMsun7Dz?=
 =?us-ascii?Q?XHhAZ89J3HMRNADBOHaizBPo4rlQaywq7J+ao2KSz2mf4z/Ta75VMNKDBhPa?=
 =?us-ascii?Q?3N2gmd88SLR81jt79aTV6hWxQXSXmjCInvsx3/zBPk4RMCiIU8FnFue9ojrV?=
 =?us-ascii?Q?+VbH/r4DVI8GOCrYooFkfHH+p0Wf9t1NzIc2p9imgkfiKTlvPVspx7CNBn7r?=
 =?us-ascii?Q?dlIdkpwq8QJrCFY/b83yPh+OsxQDFKz2LA/ekveHASF/jwhMfxGuL8+LI5lk?=
 =?us-ascii?Q?PtTWr5ocSkYpNFNgRxQl5+ZOjZeRcsIPHbi3Z5/VR3ywfhrlH7Q5e7ousq1B?=
 =?us-ascii?Q?/bvoAAwE8BllHc/3yycysLA6pwGrRTIqapSNeJ8qi5ZyXHkPM2xQNWBmhufr?=
 =?us-ascii?Q?4b9yyt62r9VAYpFyX4oP0cgbyrHiLhZhTlXoJDK1xiV+0rllqD3MSNxYebIO?=
 =?us-ascii?Q?uwwfHopNZXmdvHlLNIcMasdg2uw6uTyY8lYVUp38suFvOTmrjixtfJf+Hry6?=
 =?us-ascii?Q?BEJR953lsUPh1OC1TdS7wq6KH+OLzR3bwEm4rs2tRnhbQ7/ipBMn67O3L/yQ?=
 =?us-ascii?Q?TJPyQzcw04WjrLh6Jf5HN1lyLuRkGwIXO9Q+RIfksXIUs2CqcD+4tnBW0K+g?=
 =?us-ascii?Q?m/zM8l92myTyOOYcwVmn8HTdnk1gd56eguT/x3ZIJRLUTtuQt53byFmqRGXg?=
 =?us-ascii?Q?oUaE8HUcsWS5FpB2VKNjDRA0Ygj9pNTYtcxfnjRUJpQP8QY/bJXDPXnCAbFd?=
 =?us-ascii?Q?3KPB7w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f696b953-b280-4547-fa1a-08db383e339f
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2023 14:33:20.9724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M9MC1fcidUzswDUgWENcVdIhuTeMCQJUdFh5us3Yngudvej0uT470iGrA6KwHHTCz6xt8pnj5bZtobfrpWBwBRr9OtqOWrHD84kD81An/7A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4867
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 05:53:38PM +0530, Sai Krishna wrote:
> From: Geetha sowjanya <gakula@marvell.com>
> 
> APR table contains the lmtst base address of PF/VFs.
> These entries are updated by the PF/VF during the
> device probe. Due to race condition while updating the
> entries are getting corrupted. Hence secure the APR
> table update with the lock.

Hi Sai, Geetha,

I think it would be useful to describe what races with
rvu_mbox_handler_lmtst_tbl_setup().

...
