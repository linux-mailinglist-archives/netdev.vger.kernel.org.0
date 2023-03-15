Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9536BBCBE
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 19:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbjCOSyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 14:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbjCOSyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 14:54:07 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2096.outbound.protection.outlook.com [40.107.94.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD69862DB6
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 11:53:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NOgMwuX4Gn9cy2hZdKFXGVB3mJ6Kq7ePmxa4rv4INTO1PMBJQLKB5fa94IiE8E9cMtEN5JV8pbim1ES5VZHr3legkAzypyvXe8NZ4KHPqGnoLsvMmOA8Iiwvk7Rzoqq2JXG7wLdo5UpBoV+yGHLANe6y/2Sf/hVIsOZl+3dt7M1niOrJexOuHbKyUGSkHgAmTYWT0iFCAqd2AGjzZBCg4BIYdpNL0IvoVzMyGpzGOc86iBsxamXJGlDsIJAm1ECbxj2c2Ww4peB/TjW+j+CMEAqXUxnXENYHoC5I/B8i2JwSALqsCpmQfG6XrAyxS1Y0V7+Vj7dmdlJ2ZuJxAo19lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ft+RalbpU2QhqL+KMBlovgr1Vg2glvX7Ntcov85Jvb4=;
 b=XhhdwJTpKINnKTiMsgkqEoZ0Uh/z6DfVqM0KRqTo8eKeY+oF/w9me5ZTw/a4dd16V0tmgH6qbyU4aj+AfH1lhoLkDfbVpFAt0MoCCLyYH4SpcGi3785TT2YsG71XfPXDeNhjT/ZE4a7G+i4MnDpLyFt2WGteBIRb5sGIhfWwFpVoQapGtyx505HTgkqbSPo1e4IDJDFhlt3L/8x/hfcbgQ2FIHXary/JyaIHkKh+jV2+2duLylDxlsm+H+2XrAFVSn3TKpFm6zPv5t8wHXqVX8IL4Mrf4ybjXdBSo9l7lzgMCcG0WTUrV6viGxoUL8Zs4Wo/CWdEsnmTPsUCOq0PHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ft+RalbpU2QhqL+KMBlovgr1Vg2glvX7Ntcov85Jvb4=;
 b=axugPTRNYXAkKYGI4WIqu4juuGM0F42WBeDqjX0SobFY0FVV6fkj7xhSQi7Qh4A3EkGimYp00vlpBcsVOWg9excUycP1vPPVrtiLUkM8+mIOFYdqnQgBV8BLDgR5vSJhdabYpXGJK1+dqEMVUxNN1+QR4bft/Ohw9cRJcZ5HFhM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5584.namprd13.prod.outlook.com (2603:10b6:303:191::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 18:53:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 18:53:52 +0000
Date:   Wed, 15 Mar 2023 19:53:45 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 5/8] udp6: constify __udp_v6_is_mcast_sock()
 socket argument
Message-ID: <ZBIUOQLwxXQfMSV+@corigine.com>
References: <20230315154245.3405750-1-edumazet@google.com>
 <20230315154245.3405750-6-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315154245.3405750-6-edumazet@google.com>
X-ClientProxiedBy: AS4PR10CA0015.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5584:EE_
X-MS-Office365-Filtering-Correlation-Id: 98433620-05f7-4949-025f-08db25869e78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L7T8qJvnZuf6ogH6IvKguZnyLoD5Hm0h+LLLSkIYQEgF2DKhfn3sp5t0IsncBAgWWO+/JBgFCWAgBNRbH2TcRdwaZfHsQtP5b4iUlk9gOX7uQXE4uJnyJsEW11tO8TJXNpvDpODTyptQB0ZBpPy4/VFuUI1/Q6iihOJPViXpfpqqyIUr5WzWpLrtmSxBw4HfwhefsjXzzkfqPUUojNhxao0JKYfdlrE53ZhfuWz95mNsTcgcWVpOFSoUFp8uSd3n5/oTe4Hf2GMzgRRXZe0a31rM1Cx8Y1qEKQxnGPSuuvD33jOVWvHlvgULrNrQjcBlOHnCELWZNaezdD+lXvprBvRXkchLSATFNRP6yer2AGS/02eH6MYQMwMvV51yuWKjJyNqG1wC8MoBNsTEHPyfK20zVr45tOxY5UKo7MR1C35KjiebUOQz9UvRu2cIdRVgL8NxDRvR/prICKeTf1Uz0R6WV+rdWRZof+9gB+ITO3JtGEDxOWrCGSWU9yLyoh73MN+8dBBzqYjBMy5NwoJymqLfIb4G7tLegd93YYW/eeolJSayLyVbguKHtw0Mf0dB3144BzOUafSiRhoAD3jC+JEMIsIZsW0keuT3XM5d5IrmbZx0ZvcdI+FEOEDw/27kcjfJVhWnzDeLcJpnCYgXww8M7tkiLYfolNklnc+mTPrDcwBDqW/XwctQB0aJDGap
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(366004)(346002)(39840400004)(136003)(451199018)(36756003)(86362001)(558084003)(38100700002)(41300700001)(8936002)(2906002)(5660300002)(4326008)(2616005)(6512007)(6506007)(186003)(316002)(54906003)(66476007)(8676002)(6486002)(66946007)(6666004)(6916009)(44832011)(478600001)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YKiUH8mQY16Rjrnc5T8Qif496F7RDg0CzLoU34WU6m1dePJhpTRpKOs3kpYN?=
 =?us-ascii?Q?V6vcwaf1fHtqwYkdTw5BjSRRI7NQ02sqHeUZD6JFoOLtUeYS8a59rSNw4bbP?=
 =?us-ascii?Q?Wr6UmRmROL6Wa5oS9A/nY1fmBKA57uuekjUDGClRMaaliZpeIp4CpNOq81w8?=
 =?us-ascii?Q?+2F+zS9v+nxmqsOPMkViSCtQ3xcK2a2nl/KpRznxoHKx6pHSR4C/2fBKvtfz?=
 =?us-ascii?Q?7AFoWFeQpQDCMhv49LJrOecxCWqF15wGE5GWNHj4Dxu8FClTzqEcdZmm8d8U?=
 =?us-ascii?Q?d0uppiSt7RTscI6vI2xOMsVexIsc6UOKz9FrynOhHKuUBiuvsa+CpZs1jIuN?=
 =?us-ascii?Q?pHa1nLscbDrNHtRjccC+kkRaRtmcAu+JMR2HzysLS0+ELsxZPB5USh2P4UeE?=
 =?us-ascii?Q?4CLWxr2FEWPo874/Vh0m5idQR73UFMbANVhRtPrxDdxzzmE29yF1xGo7w9Du?=
 =?us-ascii?Q?Fg9D+VyHWaVXgWvxh5HDuJqgHc4SdrlU5XFjNVYvcRH+FYPecnrArvJauc2t?=
 =?us-ascii?Q?OubeAbZUuGcfNVkKgFzfYSJ+b3+gzkWjsrzvdsk94030JL7GG60Nmld2MvhG?=
 =?us-ascii?Q?ggfBQyIRANAjJl4zClm3EqKq1fpTwGDFxV6XxoXYrOXLXvWrKSn+YeptdLzZ?=
 =?us-ascii?Q?wb+Kx4Y4C78/XDDxaUEvjdrnL5NM293UlaErJXTlkUWqiYOWRF+KEZ6TknOk?=
 =?us-ascii?Q?g7p+TEJWQPqAop5Zss3UpqNbBWajfD/97q/Wl08ijEyrIHvSTZZUa2jpnV/R?=
 =?us-ascii?Q?Zt/P6A83Yd8s+rFQBdoJVddYkzBttUpEC2BSnmEAc1h50D5BFgRYxgze9XT1?=
 =?us-ascii?Q?81eGydnWRvZdMHo1K4g0H2yt+rNyvswmGiY3aeMl3QWg2Plj6W+4D7ZrenMD?=
 =?us-ascii?Q?LoG1etAAw7UpzJnlQeT2e21h84ue/UaVtvxmcKebQvTZITVX6MC77RitNf59?=
 =?us-ascii?Q?9vXBVtVaqxzP58dPpQL1ARtVzPYuNIevwp8oqATyhkilfK9fwCl3UMN9kd19?=
 =?us-ascii?Q?mqpSVhh85PcpxWvkxyrgKZnIvlDbOOX+Y6z6Ihm+e01lDP8QrGGjbxl/LZsn?=
 =?us-ascii?Q?BvRK7vsnBwPxJsws6fruTpiCRx/Pj/e1STH4+HdT1hq2F0nZOfsLGSXG9JRM?=
 =?us-ascii?Q?pUzkPbGnYsWrcMRnz0GhivMngPpmYcDFLtCcA1NK+j1Q4EotaJnHySILHf8v?=
 =?us-ascii?Q?LlQVeZHikawwICfGNYtec0cNoeNsZW6ORvEKCBnrcEP82kHgyaaOIYTDJ9pg?=
 =?us-ascii?Q?on5f3+J9L7P0xOAOksZNsCsqSlII31/S2Mr3fZLEQ8YfmYriLnhAR/rngdhj?=
 =?us-ascii?Q?aviBnAi+ZbZJaAkqpH6q/8jokSj6doiWqHK88hkvN435nONDqaIuLLZvG4HB?=
 =?us-ascii?Q?ZHDveqbqI1pXravFCUDUkUoOJ3AZkgreIcG57PVQEnfajTMAhZm34sBEZ6PB?=
 =?us-ascii?Q?dfhgyaDdbcM9ocJd0OYUgnEB/uoFyov29XhS45qkupEycidHzHVe/FwFIUm7?=
 =?us-ascii?Q?uFpEFLaeSZl2YAej+tCM1e4CWrrogp0tRKZ+YU0P0fdLckojYJM05C8PLJAf?=
 =?us-ascii?Q?+zBCyozJJNQYxG/29o7skaP3ZmHpje/EZ7qf0+MEojfbxjdS5GfDgJneEGyJ?=
 =?us-ascii?Q?ad98EYw2eiDIgu9pjCUzo/9DVjgX2gvLeYYfngnfqojW3V/ZiE6ONkoMiXz0?=
 =?us-ascii?Q?0sAvBQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98433620-05f7-4949-025f-08db25869e78
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 18:53:51.9298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7h3xpgr1wPe7OOVrH8CHqlP0UoW52DzfErXRbKg2t+v91XaS8VeBieW16rbIhXoG7DGf/SuVtHBkMo7Z89r6Gcif4e3HV+HzoTop/PUdkJE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5584
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 03:42:42PM +0000, Eric Dumazet wrote:
> This clarifies __udp_v6_is_mcast_sock() intent.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

