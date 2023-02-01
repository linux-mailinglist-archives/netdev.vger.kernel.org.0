Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3F0E686A6F
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 16:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbjBAPdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 10:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbjBAPdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 10:33:37 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2093.outbound.protection.outlook.com [40.107.243.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E99C174
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 07:33:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HjmOTET3e0s+2Xii1V1Ad+WgsCa8oVt3jbWx+wLyMksjt/k5qcwo/yfuNX8F4pl6VG/MxJyhQQ2OvEgcW1V9jDxk8FtCHgraf7Lq+89uRxb5VlcIdvtUunT41ocKEcLhS8Jd5K61jqx5UHdVRXLMaUsRHioCtJ/vd8/DVmEDHTTi0Z8+4jVh2iKnbj0eihWeukcth9H1NhoD7sNtKgzeI1jJqxbypNR3BT8gTw6UdbrpxYGRS0eTxlf1EIW7G75U8l/PpqgmPJRwZd/fJ3o1LoCxRZdFIRcQz+6c+wE8LD4MmC1k9TqVasAsJ4x0D3l4KTmgQhAkmQcb2CXRkyrJ2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XLKAOaMvvtqUcaqDKJ++i2wJulk+x8VxhiDSyB3Cytk=;
 b=Zbx+70SYjzDoucFHSxTCU1A6EnsaK/kocstw6Ho7GugV9dblToBK8EsJYYV5RrRKPHAEOWleaEbWnMX7Lp3TQQ/jXMNWG7m8vV4JvXUuGBIzerZpikgFd4ZJXUI57XJkdfK3gEj79hhpoCbYupYF+AvMurOo48JgD6Wd3onghMO/ORBGPtcItUHsrwOPRIWIYHocY5507rOrCsiqKcdKmOzmyjryYjpvWGHDN1Mv24EDUctX0boeKy4PTQqtipkTT5Aai49bzuk8yoWet2oTNFFWyWwNZqfwFKbRiYn7sPr9399KaMbGQ3shm8WTN5NFhGPkIJmVaytl0j4pKzXJEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLKAOaMvvtqUcaqDKJ++i2wJulk+x8VxhiDSyB3Cytk=;
 b=syl76ZEZ8zR76BRsi2mFYfvObD3a9NID56q60N4ljx70hBP0kb5hiyzNwQIVTkkLE1dU5ypjt3e066s4fmSGRXe+t9d28O25jNJeOWWp2uouJDjP4Uc7hGXeVfrI9QpZqukndfltQl14Rm9pdQJX6dmuAm+i/7zb1sqSQf3fo1k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO3PR13MB5813.namprd13.prod.outlook.com (2603:10b6:303:17e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Wed, 1 Feb
 2023 15:33:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.025; Wed, 1 Feb 2023
 15:33:33 +0000
Date:   Wed, 1 Feb 2023 16:33:26 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v6 1/2] net/sched: transition act_pedit to rcu
 and percpu stats
Message-ID: <Y9qGRnjwMLwO/YhO@corigine.com>
References: <20230131190512.3805897-1-pctammela@mojatatu.com>
 <20230131190512.3805897-2-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131190512.3805897-2-pctammela@mojatatu.com>
X-ClientProxiedBy: AM0PR03CA0018.eurprd03.prod.outlook.com
 (2603:10a6:208:14::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO3PR13MB5813:EE_
X-MS-Office365-Filtering-Correlation-Id: 3daa2209-4e2a-48b6-8633-08db0469ad7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DlMFZRRpHVn1q2j+SY9OzmgM/m00g3uAmlEq8xmf97tvaiN/pE3wh277Jox3mNtIggZsPvuX9XpevJ8qrZHEKzGiQkBAwjLOzs8H5lKLuIo9V1RPTqEWe9dcnvKPiSX6hS2pPw1UWNfqkVf/UGL6vZdWe5v37uZlIBBKX1U80kgbG2aLFlQZ6WQOC6hXKPIo7NNBaOneSDEvRa6MUZSLwnCr6K5uUNJXauSUqVwj2r+b6AVJY7+KiGjboIwcDtmGOtXe0McBfSv9AslTrRlrd9Q9cDkitNhe+yWIhHlhs4ZXBMPHcv8iRSdDwPEmWDp9exFPMn229f5B3nFkVVn8JKipwnBhvS8TUo7sCVUgtS5kvnIcuqAWM9Do1DVgIdS4NIAiG6SVy3Y/q1LxY5lgsAZpefhiw4xZJu4NTVY9LW5h83VDAU0Ax73hWCyhk/hlJFs8Ouhbtkfmpy3XM9FaZJ4cGNmt7pEpRc94QCtdyQfI0e31aaH16kNDSqwmB4ynJS4mUl/2bGrAsPCBr5ZiyiTHMsx4YHnV/VftTf4JLbEa1gOEJ9l+8lkVzBvlOPU7LVHwlmE8TwgCFSShtBij0TFJmPFNfCaZJvJrStiNAAHfnl+XRGfdFH4XT8J74EJkbd94rRjoxWw3MTBUsFzhlctu1F7XDrTrucel3F3ykhnNENjmJiDZn1sOS/ImXcvn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(39840400004)(366004)(376002)(346002)(451199018)(8936002)(41300700001)(6916009)(8676002)(66946007)(66556008)(478600001)(6486002)(86362001)(66476007)(4326008)(316002)(36756003)(6506007)(4744005)(44832011)(5660300002)(6666004)(2906002)(6512007)(2616005)(38100700002)(186003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V1W55U22NSdlLdy4eEjwAXXL5IU13Egu7hDkjhC3nOc7rs8RARwXOHt6ufju?=
 =?us-ascii?Q?BmhvnURBClY4egvFboeh7d7VWWXRQTtK7cvmxerb05r7WP6ADP0m7T5lDGus?=
 =?us-ascii?Q?t3N0xmyFfKp/2irOrSHHUYrBklY2XRLL9cjtSjmrNKDYIPZ/lcwW7Rg+Uw+E?=
 =?us-ascii?Q?U5Hao8HmeU3a2smf3Zxl4XybuXSSXAtzRX66swL+GEe4yrTvVIpqR1Wtk7qd?=
 =?us-ascii?Q?W/aDAxKDNkTu+4yCocH/vsp4a3gWbm3wIyxgSappZUk+T7pFR3gbLgd1bI75?=
 =?us-ascii?Q?FcWFipVzflC2z4JPY6PUue6PToERJkVpheDYfP3wS9FPd52Nvza8k7Tkt2Kf?=
 =?us-ascii?Q?TBiljtLqy3CPk0kUscuPhH/1IBTmP3KzZIupH6K4wPd6FihoXO0Z5NLCU2++?=
 =?us-ascii?Q?IkjZbKfIlw0gBYqElUqfHp0u3UPmcVp14VmRHZL7GLAh+8p4d3B+eXUuMsE4?=
 =?us-ascii?Q?6aMBKok+ZzF6OaSBGjomp1bVyr90i6+V060ssl77rM2hU46AkchiHm5JTt78?=
 =?us-ascii?Q?ppmTBvn5OSMwcpvWkXJLb2CuZwfFkWLXmqoZ2v/2SsP5oscscRB0Y29OnFdT?=
 =?us-ascii?Q?GfTbBE9dXUO7H4bGISsCnbUpjyTCjdi03r5jq6nmuR4fPYOLNJnDPZ3irxru?=
 =?us-ascii?Q?3DUJxnvaOT9eSFUZaTfZHkn+Am/PjdiLTaANbfm3PyPAO+QykxFIttDXM0F3?=
 =?us-ascii?Q?QDAvBjwYpEsN+ohSFjybkB0pVjYi/JN+/3pJ2kEbrJTXYRCqPy4fOUGj6rEU?=
 =?us-ascii?Q?e+B90UZntbznhmW3xMuPVpeRi9Bbd2iUysY7ITX8ImyAGpB6GAV/BPWnXpob?=
 =?us-ascii?Q?N5v71/Be1iDmrdrLGb2DAn0MBsdRzl+gY8PtJR7h7u5SJ0X0RHR3bfVw1ji5?=
 =?us-ascii?Q?cMoU866hHZVHJv0NibMwqcDeqOXgkf88G3f2ftFEsS3LBL8gmQ5uS5oYRCx0?=
 =?us-ascii?Q?A9XvJXIhkPzHhyW1iTocga8F4N6S14urpYHgV8yjFYT+uoifYazJ8PUDU7LI?=
 =?us-ascii?Q?7GjuytRF0GupiUGrjn5credIA2BirJ21peKzhHrX9MAAZdfr1e1+WT6f8E7O?=
 =?us-ascii?Q?whdkkxbxHofrlmzCEoRXgOPtMUwJB42yXirFZfphQXvxSMQ+IlH7x3s0uTPH?=
 =?us-ascii?Q?jdPpTXOau/60pjIDq0f/HZB2JFzkM201dGCtiFnwAwuRPVcGWPFeOO+3cIHw?=
 =?us-ascii?Q?iotW4BLRsWDoR54toK3uVCM+Oo4tL7eMBntXNFEOiXMRpWDZ+LAgDZdiQ9dN?=
 =?us-ascii?Q?9Q1OecvmnO9mMSJ0cvN01nfUprqdjl7y348tB0YUBlZTtggaQvXbSs58ebjP?=
 =?us-ascii?Q?rxSH0/XdPOTOkAL04qCPsN9T5HnDB/PHh+tRhcEpsUyWaMkcSZf37S4LnJfz?=
 =?us-ascii?Q?vaqIC+mFC8Ns4Pm1g6duGoOOLwut+c/2GsOTPLzblRZ4al6BAL6pMtFOCneK?=
 =?us-ascii?Q?UT8cQ1S5TGG0fe0i5ph3xGQ9hPJYi8g9NOZ9goCHvkG+sq3SClPuVJomnG0D?=
 =?us-ascii?Q?bqDbUVSXfcjfoeLSJsjEv7zW5CKCL8+HKvWEEzhAd1P+hIv5ZFE1uqLyKm2W?=
 =?us-ascii?Q?6Us80celyPX0Aqr7pTp5Yv0zdsTq1n7LK2kcdRALwYp7omR3cLMhsU9Tnhof?=
 =?us-ascii?Q?fjQkBGkRUfd31czIPrhgb/nM8Jr8ge99S3YSToR+leXaWCw2b+9IcTonzBly?=
 =?us-ascii?Q?jEWjcQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3daa2209-4e2a-48b6-8633-08db0469ad7f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 15:33:33.4620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yJLF1MxbJ0Y4iuqPEtBQAd5j0J6wKd1oI3oNu+vRlb1mYwEjZ27WkpeeZMtzqUPTQ82GQC+atFzFVOuqQoPf+8Gss8VSecKkNUhzTYjoNek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR13MB5813
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 04:05:11PM -0300, Pedro Tammela wrote:
> The software pedit action didn't get the same love as some of the
> other actions and it's still using spinlocks and shared stats in the
> datapath.
> Transition the action to rcu and percpu stats as this improves the
> action's performance dramatically on multiple cpu deployments.
> 
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

