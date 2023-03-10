Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B43216B440D
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 15:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbjCJOVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 09:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbjCJOUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 09:20:44 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2129.outbound.protection.outlook.com [40.107.94.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF41C49E6
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 06:19:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvPv4N29zQ8kh99VPsD6SW/whufDhruaJjsd4Desxsas9CdmJAKRKeRKK6/F1IncPnMeEtjxuL92A308/c2yBeKIrPfBvpOj2MxEbDG6pPfyWEhH8yhtPid+WqIro2hVRrwroGNgiuCgJkrHMyAWFamrFtopuILmRtgkpM2XgEby739XHS+CpMpMfA6CXvYCFy0Bps5LKC11uxKL0LZ+sZ7nbbaptJ2bnNO9LfJaZpKjwBh+JYQOHFep3rtex8xw+z/q4+yibPe1ykRO/VybHlO3aSuQDZ9kBQPrECtX3dU8dJX1ceR7AMNeuMBvY6ANwOV5vQ6SzBfTAs5orlBppg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IDVSOgMdLG9vvRhKWIOUdpocbufVihehn/paMDco0T0=;
 b=KwOZr5fRUoFjqFgIoj+0sq5wveMPH7Gi3svSB27Rg2ci3un0llSwirTQPJ4OWY2QVZvB5q2/cNEvTtPyMYdXvTH3nyG2kuVGn0JsFCWzMkoNLMpCKq7DvxLrY/8kYKRH9ZdtsAj7QzkGMn9Uo8nVmQ5dGy7WQMN/e14mfGaY0qWfmI0s4c3BRR1UapG3NzVb6vWjbryud0DIhMRdB5hDmwep5dNO/g5UTI38UNaEssjwEQcIFSpzGDn1Q6QZtnUZKw2Syyjf1ERuPjVAB7DtAs/fI5cmoXtq2lQaSM1fadgXPshk0PKDgnsz5ldcX5DCZAA9OxEDWfCr4mQyO8mnbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IDVSOgMdLG9vvRhKWIOUdpocbufVihehn/paMDco0T0=;
 b=N8f5CTBYjmRKUrnS/j+hY0MJZVyBfqdLscCAY2FVs3jx/1FWXpyoe7S6Czmwu65V/Qv/6Ysg6CkuaWNaKzeRwPsQEWKiXSL3YHWgKc8REz55VYUYhW0v92Pitnfax0fFnb8+bfTrJTf1GgCYSvdMMZAhJK73TfXWp6cwW6v57D0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4828.namprd13.prod.outlook.com (2603:10b6:510:93::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 14:19:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.020; Fri, 10 Mar 2023
 14:19:12 +0000
Date:   Fri, 10 Mar 2023 15:19:05 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next 1/3] net/sched: act_pedit: use extack in 'ex'
 parsing errors
Message-ID: <ZAs8Wc14R3hE/Z4z@corigine.com>
References: <20230309185158.310994-1-pctammela@mojatatu.com>
 <20230309185158.310994-2-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309185158.310994-2-pctammela@mojatatu.com>
X-ClientProxiedBy: AS4P192CA0006.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4828:EE_
X-MS-Office365-Filtering-Correlation-Id: f12760f1-5678-419d-7811-08db21726ba6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nV3m+Bl3BeIB9IVg3q5qcVUt3KdXeA+t19JbF2KW6Jw0itVLcU/rleWv+lGMjYsj2iP8aaBCeffo0NCukVsHeiiAsFRPCxwthEekV6CGcuciedm4N5GnP5mCVuS3mXrHUXcAghQ1gLprYjLE1fP4dtgFg2oUxeftDdG7/zD+dwgNxnBF6pClwiHn+xJmv9XNyT96rzo50vCirpOL8z7aknQOYvo/Fv54mnCkfbuq1GLZNe62TX2ilO6jyDiDzOAfSxUcenG0U3mfY5su7ZaiLaCpNMmvkdbQtWhdcDurfLM9tZZ3ErihuSzaTsOa4oJvKwKjPPmAroKDlvZ6rVDQIzfCukam5ah97lLygdrRR6Y+Z9DfBXSNloc7njIYoyF+igajMs4mqd5Sl1+R/0fNh0YtbsY61udj6eHD/imJmA68uWTDhy6xPHgqIiLQ501LrHm/ew2sEhrKhHS7WMMdggG8gS2tJuVolM9gQCzg+YSaEYMXFWDNmK1KeDxVoMeIrYmdapmoHHgV/icErORenoFDv47m6Cvf3Tsvk49VeqICU2+3ZF+4//Sh/U/hLBzhbzEeV0T7IC1BaRK6kV+OzWlqREziPAgGHM8iXuuqAHxjBb82H75UoSohhbCVeVf4D6Y3IBVm6azP05N631OLs7aaJ6i4J1cK+9vjaZ9JImc8F4r45/ksMnMgMS7Pfe1s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39840400004)(366004)(396003)(376002)(346002)(451199018)(66946007)(6916009)(4326008)(8676002)(41300700001)(44832011)(83380400001)(316002)(66556008)(66476007)(2906002)(8936002)(4744005)(478600001)(5660300002)(36756003)(2616005)(38100700002)(6486002)(186003)(6512007)(6506007)(6666004)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sdVbyZygDbv75xI2Le9+2RlcJ1PkHcMBqwz8nYw67yTiJKCvyEyYWEShE1ys?=
 =?us-ascii?Q?7wzGcgMQdNzUlGc2ZKIUu48f0nqw3+vcR37y9OvnUohSwtEL0UYHLMDK1a0O?=
 =?us-ascii?Q?01i/x++5byV3fJAGSWc27Pwher0SNLJnUr3omOXfMPkIMd/8s+kq7Hl7ZIFb?=
 =?us-ascii?Q?4wkqOg0XUB13El7LrxEI4dg5gi0rQd8lu+UUaB4pojvWCD4c3X9SZGVRE0K8?=
 =?us-ascii?Q?1C5y2Arh7iwGyE+bYU4kyGEd4XOL/Nn61LswDenpJTEguf/tBez+AnIOpa+u?=
 =?us-ascii?Q?HJkzLHB5Z7eDGA6aIHk0sz9OCr7NiaDLknkZq0DVyWUnPisNBpbZEHvjWYjb?=
 =?us-ascii?Q?MT0foWZP46cPqQV/NNKhSaz/Nfj2ByfSbsuVk261dBoutWy9yDNsYgyBWdWE?=
 =?us-ascii?Q?WmbgE0Ui97QmBmuFUZS46U/xw8Zyh6I0vMd1a+m8JUlsVvVa6Fcpv2+mSApB?=
 =?us-ascii?Q?xbImNB82cAHQ/kEbPi65T0hFw4Yb3Z+fLZx0j0vssntieO5Gg/5jBctpLLUd?=
 =?us-ascii?Q?Lc3Dq2ZK5hfxRYAqbGn4lpyIz6a+8LRr1DERlRORUWxPoubgZp+L68CdM4/2?=
 =?us-ascii?Q?u0d0PiwWhSvMC0Fjc4LyAE57Ns8+QEM8X+ti48leZRtVXJ3r+7UObR0TiUjE?=
 =?us-ascii?Q?k5YHyLnCFI/BrUxDDWwLCK67MUn2Gm6xSEDyjy48iSj1qqdVVBnSeJaa8KW/?=
 =?us-ascii?Q?1Wc3Q9/A+iSjPuATuxJWm+OSRZ8r3geTvtUFSgeduL180G7saa8+dooLJNkF?=
 =?us-ascii?Q?nlEQK99SQJzpwUP/71k3PNgPITVIkTTm7YZh5dsCiUAZS8+mUpb1H+gyfoI0?=
 =?us-ascii?Q?y9GSvT6XXhA/Hgcj+22b35VftISEbFLbZRNulVGSRvVxD0AFbjYU32R8lB6r?=
 =?us-ascii?Q?EoVYpKHFzPksLRbWWVZS5FCV86suxjFb42BeN+4GCsp6NdNvKMVnX0PJGTab?=
 =?us-ascii?Q?5ERRV/36dHhjXIJ6es2z5Q4mV7vt6N+T4utOhpqXExv41tvUKU21cr3cly0n?=
 =?us-ascii?Q?GYdppx+0Z/mCFO+Th7nqPRI1rXfQQqQUdmkdyVvWTEaBSS52cjsR4LpSl55A?=
 =?us-ascii?Q?SXHmc6JYgpeB3rd0JNAlNDNST7Hv1Chw7pk1fHOLPAccL9a8Np6yxk8j3rAf?=
 =?us-ascii?Q?dQTt/3zPNUMkNxvnglqxyO0y4kPAzwfbksfoCRHjB/Xa9h14sn8dsiOO5jgW?=
 =?us-ascii?Q?+kXtNCYjSADEwDBZIvNPKpf0sM7aJeGH6mtcw4k31hLmUt1LxHcDuT7HcIaF?=
 =?us-ascii?Q?UxzubDNABFPJNySLOkhnD+YjgLoRc7sMWTGTeJPKR1Y4DynblpvLjyjeP1Vi?=
 =?us-ascii?Q?NLX9YgrstHkzFmC4noCi9NHzPBIjKdb5+w8M4qWYurc8BMomlLMOHirbNFHw?=
 =?us-ascii?Q?Mv2tOrO3TCLzWiu3DmHddDirvRqD/Zjzuw0Gza9MHsugLowoejVMr3C81PUZ?=
 =?us-ascii?Q?kGPVCkVTLBn603DJJsmozmq9H3m5sWRQfbUJHWnYK2F0CRxdjuqIP6nhE2d9?=
 =?us-ascii?Q?AJumMsbOC1g1HR02vjg5Eetd5gk68OKu0zkEIMqMebZHR5hTsFB9OADjh4n4?=
 =?us-ascii?Q?x7hCA8O890e2Ds9WorIKC9w2R11aFjUPp2TUnT2EvVqS3rrskbtAFLKfBaZp?=
 =?us-ascii?Q?QadcsV0dKZpLjDb8BHCRZ24i2fM3TeD0CncMdL1dgEniXRvYuILv3zAKp3Vh?=
 =?us-ascii?Q?fv8ZbQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f12760f1-5678-419d-7811-08db21726ba6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 14:19:12.1304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HgiU7Jz4yYUyrjgMUMadhmxv4IifDyPdeD8WwIzusz/aj2pNlzoIZMqpi1EEUmvJX8AMCycGgaP5HpYWv3tgHNXdKI2TIRE2rohy4TlstA4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4828
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 03:51:56PM -0300, Pedro Tammela wrote:
> We have extack available when parsing 'ex' keys, so pass it to
> tcf_pedit_keys_ex_parse and add more detailed error messages.
> While at it, remove redundant code from the 'err_out' label code path.
> 
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Some errors in tcf_pedit_keys_ex_parse() result in extact being set.
And some don't.

Is that intentional?
