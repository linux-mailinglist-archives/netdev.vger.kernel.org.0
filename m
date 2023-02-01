Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0EA6869E1
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 16:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjBAPR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 10:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbjBAPRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 10:17:39 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2105.outbound.protection.outlook.com [40.107.101.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39D76778A
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 07:17:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G8bJkctgfVCZB9WFeHYBtx57WGAYgDfTheeDeyXpFLDJh44yoCWSbiZr4BKa7F8OKifUn58Qj8sFRJJmmnkrV6sXSbW81QWlxTIyAPNwmtabSNpqT28NEgmImHGGAIImIRuGZ7Gb9YAoV73pWiJUETteKq1TJ17SrRhO56WWkady0yTBss24fPxSk8G3KbyS0WjMLpFTC84I7FZ42rX11MemsKtApz18QYbwnH6OJXN0j9WAJFM+dj5Gp1qx1hWb7txs1TVHdIPllN9UCl4BM6pv1HdFvlYr2ZfUHu7Ct2KwVstSoNnkjQMYY7mke8xv6m4IjnGI6qnmQ/x/dVKPIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HRFlpPnkeUrODiJZLsNJ/0mRGLceEy447R0paltkpKg=;
 b=GSGZD+pbHCd0OGd1+00eZyvGIZ0WLiPZR3sssiL9/tJFrbW7dVDJZ+JvqCHwtEleSyr7QM5wgRjKmXJ2vvot6mOg45ADcCnoWSpOEPd5tG1lRnZ7Mc8Mylq3r8A9a3xbptlBUmTMG8q0JmhfuI9LyCzokqqGnnOM4G2hXAUFv0Yy8iPTivchYxA4CGekjrE5sW+WR2F2jPhJTk8hcL/xCvG5y9XtADZw8Dls4Xko+Cg8XS92osrHGkstNhLpVLxRNCSKcM+Ohnqpp2dxCXh0uNUw6FZsxxBv+BKNZLC5B9Q9L7NwlAVvx9ACHo/81g0eWAfr4MOX6ESNAceV30khPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRFlpPnkeUrODiJZLsNJ/0mRGLceEy447R0paltkpKg=;
 b=Vl5wJLdo8jcScdAIiSTMu6HTfqevtTb770EzYAof9DuDpOjMcgbbobnvxVWAdt+/WuQqKJbV2wbLhURcov0GBa/bCS2cSpTkm+xi7o2+/hRJKpebfdOGfYLoYgnF/fooShygSmjfQI1Q4Q7rXAYcuXZGc98cQcEz7kQctYcPdkw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO3PR13MB5719.namprd13.prod.outlook.com (2603:10b6:303:171::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 15:16:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.025; Wed, 1 Feb 2023
 15:16:51 +0000
Date:   Wed, 1 Feb 2023 16:16:44 +0100
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
Subject: Re: [PATCH v4 net-next 13/15] net: enetc: act upon mqprio queue
 config in taprio offload
Message-ID: <Y9qCXNrqA0lfgq4W@corigine.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
 <20230130173145.475943-14-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130173145.475943-14-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AS4P192CA0020.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO3PR13MB5719:EE_
X-MS-Office365-Filtering-Correlation-Id: 115e888e-2b72-4d18-9b9e-08db0467582e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8JTu5C6azgXFetdo9CtTi+3SYqgxupdrgwwOa3GQ3sUZTqiL2vwlpItmuYDP2NTyv+Al22NIoZ0/oUD0VTqlKdkxnmIbZI0fiLZtJqv1odJVaUdgiDc9BCM6pe40IFXWPqExEk0i2Ly7d3uPRVrWRYt7+ub8LTPkqQpvejUfbNwJr0Rgu9ymy4NJ94Z6ZAn9jAYWRTpD/dUfjKMwQwoIUWNeeg07fEyqP5F+BbwNd2uB/lL8rmsPw3Ln28cbDJ/1glo0Ymoh9R0Sq8Z1//7EJrJxCkg9IaztOhrugpZ8yy/q1gHl3dxvYUxAWgU6Mp2d4TbBe61hrcf2pmTSiXLvlajMwo9hDSDHlW6AuaEkU2y7eXGeKmeNG6NF7UCDUORGPqwqqJIeP0q8o0O756GuxfM7auWiu25JmzfdQARUYi1pM4hV0oXbOQAX3sQ3H5nVVRQM9jKhuzn8SovzVVbAFI6VgY4/TWjgaoZ3CyYB7eawD1UCJh1bA/dodDjA4WW9VsV8mLrXQRoatwk4fBF+6Gbuf5UnmmulaMuZheZPcyTVUNauOzp2/dv2IB7/kY2ycGciTw809rd/eXMuNPLwOoEj4ShP7+ngahCcsEkg6WQePKLMFdoDy1us6ogElEy1Aqv7+yufvNNtjoLOAL/V6j6DFoyz752Lofq53YFymrU0MfsETFTbmpfHm+8UJkF8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(396003)(346002)(136003)(366004)(376002)(451199018)(478600001)(316002)(6916009)(4326008)(8676002)(8936002)(66476007)(41300700001)(6506007)(66556008)(66946007)(6666004)(6512007)(6486002)(186003)(86362001)(54906003)(2616005)(44832011)(5660300002)(7416002)(4744005)(38100700002)(2906002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FKlHU83vDWwCttVUwCk5oqym5ztdIwCYzx4wb783OrR7lZ9YVFqBrnkAaaFm?=
 =?us-ascii?Q?jpL5wx47/L2Py521+ud7Ztm5E7UMYFkQ/76NbaTFRwfeVP4bb44xFSE2MbFB?=
 =?us-ascii?Q?eyvGmeAs0fh0C83bCOLZ6LggLLirczGAdK9ghSwVyFTAwvMB8X4T2YdNJPeY?=
 =?us-ascii?Q?2OUNgkDkGIhnA2mnBr+tcqZ9a+yryRrcIdU6AFj3s/GJKXCh6KC+j1Z5y4mw?=
 =?us-ascii?Q?Cn7SdOT6qf8+7FDiG1ATC6dLzrRrhdZxrkQxB/p4YKTWzkIpc39zudV1YIol?=
 =?us-ascii?Q?/Z81LwMuvZJc/yXFp70hP3rDqP6cUvft5dfvJWbO3d7wUfJXVGfzjITY/aIe?=
 =?us-ascii?Q?PbZ2zY01TdY6x26375q0hZ2vASKi0rFpUpceIUdr1oI3tuj1KgYThxaIGdY4?=
 =?us-ascii?Q?fbMuC5nFkJzKJ2icu5cnjdu6NoB4WZvDEXWIM2J81nj2Y/gsNEzVeN3yCFD9?=
 =?us-ascii?Q?Wy+iudZ3juDyTxx2kipJuQ6kVOUkmxMPBxcm2E+Fr46Qq3p+Rnah/cPw5by/?=
 =?us-ascii?Q?qqR43Nlr4iYHAhuA5C3OnXF+uYN2jPi0CH4Gbqp3qTD9eISb8uZVSUn9Ox8S?=
 =?us-ascii?Q?JFA/TeSWDq6/Lca7Ru7Y4+evaQbXjyxVmnvpv8SOGj24Y70wfT2qnztLMiRZ?=
 =?us-ascii?Q?H62tv+Zg8f+6o0rb52YW90WVxikMxr+TdhgaPIXJipnCEJ6J2BRcoG690uQ4?=
 =?us-ascii?Q?0fEQjlI5UNzHUnhmWXJC31aIDz0gz/oEGWmhr0wYTVaSGJHDgeFi0o5dF5n9?=
 =?us-ascii?Q?/Qgh+vfYQgfhF5JNqGaaJbWR6uG2dDXGUgbjVM3mPGybhc5Qc18eoYetJl29?=
 =?us-ascii?Q?Ff12EGxMgFIgnfIImVFRLTQJn8rOTTL9Kaq/du3Hnrhs2v4meVatRn2b5bws?=
 =?us-ascii?Q?HjBn+UT5aL1nIlXULfgUF+NQBv9b1LtlRryZo9zQzuZkvt7kxPTIs6s5ro1K?=
 =?us-ascii?Q?XrBn3WgFJ0OVmP47sa2RCWWAiD15FMc2dlSFvjuCcCbIqG0KDocLiL04mIa8?=
 =?us-ascii?Q?r/mIdnAyIFhtuD52S0f0ie7RtVvnRrT+RexuHLwuPplgmnvV4UzCkGJDRVpj?=
 =?us-ascii?Q?7zR1KCGV12qSVcazHdRMTkrSDgGLW1uK8PII/AHbo0HB00u9vf1ieLvVHbpK?=
 =?us-ascii?Q?Q8XLS2tdkW9s90GdASsJk+SvHuYZP10gw9IN0v/BP3iCedvA1ruZ1mwefWnm?=
 =?us-ascii?Q?8czmPKUQydsaZTPq/JV0OvuBH7wN2PegU2e3/p2ovErz63b2dE4JkzcMNz3a?=
 =?us-ascii?Q?dsf4AeZmipqjvz6qOEmWDIITaQC27B0D/D992xfUSl1YIM2CQNBLnhuzgRNb?=
 =?us-ascii?Q?eUbfthQv3lga8eH9ZfrD9iNe7PbfegsygItfLvVm8tBa77uNDgre4Et+q2En?=
 =?us-ascii?Q?Wg7cZwS2la7c7picjHqXHL0YV3swid5TG5GubYW6zfWPbs28WZ0nYAVLFZq7?=
 =?us-ascii?Q?w+Fzg+scfiWAbZbxsyxuTp1Q50fePrG92VZR6B7nhv/qHjZkiJcyJfnVBK4L?=
 =?us-ascii?Q?IGASHDU6KMORd52VtbWvFj95a+7558vPma7KV37W3URaI4j9svzEc/XsCh9W?=
 =?us-ascii?Q?aq6dch8s+zrLTENYVzHiwL9cLdkmBHwr1RIuJxNDv9m8xGdpm6TpXJWtdy/D?=
 =?us-ascii?Q?6hd+UQDzTlgRDARJmmz6zirjBlKJpzvBSOzj3HwK67WYVA15KmoDnXQAxR0j?=
 =?us-ascii?Q?McSgLQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 115e888e-2b72-4d18-9b9e-08db0467582e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 15:16:51.3148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: siv94hezpxaRSL+1dMrWyRUqhWCV4Tj81QC2WCdX9fAVHUB30zKFNIdhYUbj2W2TShWykjMy+ms9LyOCOmTy2bZSLGx2MsPPKdPisy3j6yA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR13MB5719
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 07:31:43PM +0200, Vladimir Oltean wrote:
> We assume that the mqprio queue configuration from taprio has a simple
> 1:1 mapping between prio and traffic class, and one TX queue per TC.
> That might not be the case. Actually parse and act upon the mqprio
> config.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

