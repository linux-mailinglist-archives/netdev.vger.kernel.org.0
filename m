Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2696EC20D
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 21:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjDWTh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 15:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjDWThy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 15:37:54 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20718.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::718])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E6E10FB;
        Sun, 23 Apr 2023 12:37:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VdrNQfMXW4BnPsgAU36uAVRGEVprou6dT/7+YmD7qMAxEnZmKtmI8674Wa8mBuqstHrBGKSrO2Q/a3LpYfCKmEE9NsbXJO8qg8xbQWv0/DA7oxnsuICG0mKPSA4yinZXqK7MgXSUNJvzpTnzl+GAyYwye8ohQlixS1Jcy3ROiT7kiLWceD4M7iiv5YmIUMil397C4mbm3m9r1tmpDVDTSCOjnjRkpTzE/DqxCMc3dOVUEg7LrdKEg+NT5FJEF1u1J8szECUrq4h9OsetOo+79JwsWYUtfQ8v7OPEZJGrFOa8C68s16Jz92hfG19ptDBFNbl4MefJKfqGOiKCWkOMSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sRzijtC3r3OzRdihsIEasZUOnkrBMe3AX/H3bgylpds=;
 b=fP7DVpQErGBk/sKyjegyyA7UdxUK1007ND5zRUOj/0lluS8P4caSpWkVhsPmEdUMIKenFirdSCGceVQCu54esXrPc0JbHfz9LbMHbtzJTi3FxGsfrDR0lWZ6MQNAUMa8J67N0pJBzuGjhz0IrLvTv0QojJFRmaIsGSdewr6zNLnt3g17yYF9oozz5AZzFiPWpCNKtcHkRSuNJsWA6PnW/1K/Pa54lziXWoJ1X92jke+Oasp/xQcpg/nB2XiAg3zBry42/4wkzXsR8FrIAkhOiPUCjOkmGDW+39inZPd8xQehalJ3G9FmDP1ap2J4tM3kMs6jqIFXwRSCvdpfT26sIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sRzijtC3r3OzRdihsIEasZUOnkrBMe3AX/H3bgylpds=;
 b=L1JbxueJWtb7mA3YIouSAblWKIFujkmLty+fLA9tXr4cnPvK6tfH2tEPE1oJKMsYMce/ClEeLMcU7/KfU+A7SG8eDFBQc24VQ+2xja4fWZMbg61Ba9gS2ZKtRyDUMN7tc5lQ7UrG+FdqMsZGmtu4h54TcHYYoY1rjRP6H/BWfLc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5167.namprd13.prod.outlook.com (2603:10b6:408:152::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Sun, 23 Apr
 2023 19:32:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6319.033; Sun, 23 Apr 2023
 19:32:12 +0000
Date:   Sun, 23 Apr 2023 21:32:01 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] mm/gup: disallow GUP writing to file-backed mappings by
 default
Message-ID: <ZEWHsbxhQlrSqnSC@corigine.com>
References: <f86dc089b460c80805e321747b0898fd1efe93d7.1682168199.git.lstoakes@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f86dc089b460c80805e321747b0898fd1efe93d7.1682168199.git.lstoakes@gmail.com>
X-ClientProxiedBy: AM0PR04CA0054.eurprd04.prod.outlook.com
 (2603:10a6:208:1::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB5167:EE_
X-MS-Office365-Filtering-Correlation-Id: fa9b4082-ee29-4fc5-1889-08db44316fdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XzWs/2NUR1TtAefCnHvOBHeTRqcNSC6OnsJ2bEoGkSFoBIhsUToo1VVw2+IPtKvV5jEfk3HBahaXEYf02TVGBjhdaj4e5DEEnNfVW9cZ2z6q73kGm9eYlBVuZWlGYikPIA4iFKlSc33X0424KTu69lYQ0Y6+5+Hj1o03iBJspy+3dgV06slw2uFe0xNpkhXtxFaRPHStwjyXeCErOvctMYtWMGQmiWGL+BwCrCHygucXCg55CdAIafOz2FFcZ7Bt2ycgumXY3FzND7DxOLG7lcZNvHc00rXpuxkCF2/vbKQx86bclIedi2Wd3P4eKwf8CSEDfflBQuu2zJt4pqqd2HN5nBKASv6eKrpDB26IL8w6m1yo75Wp9Y+iaDYlFFoxxqtUSL9rfjzfKhPcGQIqPhpX01Szm1BBZwhS1kLDkMfwpn/DW3qjuqyT721J05CPjPN4z0xdpMJayohcpkNdbmqPMpxHpFrZdMtaMknYqyo/E4n/MhDr3SrdRo9VogLvBhFbJXtL4c5vPUGmvAH+U6j7dqQ2ZymHLPrGp72gpRKCOVQ0/cR4itQXX4NKfxe+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(136003)(39840400004)(366004)(451199021)(2906002)(6486002)(2616005)(6666004)(6512007)(6506007)(186003)(66946007)(66556008)(66476007)(8676002)(8936002)(316002)(41300700001)(6916009)(4326008)(478600001)(44832011)(7406005)(5660300002)(7416002)(54906003)(38100700002)(36756003)(86362001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?soUJBCApcfQiwe2/wueHCc+O3gLCqZ5gZHGeFPDXIY38IsF7qEnMq7Ojs4dL?=
 =?us-ascii?Q?eoO/U4r95pOCClO5ZeLkdvlz/85ZoY/UvJPSafyyzbnytcrr+YjG6HEgjDup?=
 =?us-ascii?Q?Xwc4+rAtFSXQ9eMfFJFNUo04PkF5Qawhej+V9OMEZPMX7L4Bpgj4sFPKcfTJ?=
 =?us-ascii?Q?k75HNGJJq2xAbY3jCU75YNvrJwulGjZAvj2kO1kjrtpkXbHGYFiZBaijRNGK?=
 =?us-ascii?Q?HODiG/O+Nvd5Y5bf7qnCs2/V1hnRyBnwn/C6GDLxl5n7N9tLEN8HhLs60896?=
 =?us-ascii?Q?GEnxQSymou6uc/0PK23+9qdCq33RuDHb39uazAi5nkjLJict9Q+1W+NP+gOA?=
 =?us-ascii?Q?Tdpsp/5K4GgQ5Cg0+vYgHHz4cpRFd+TEPC1OiGD6jBbtyDX8UCPgEt5rX7r8?=
 =?us-ascii?Q?0GqPRg0v/CrNaKgm0gmqO8x1vcTXekZa6kTBmf8qBzsmnvZjPNM1W9FCJEbE?=
 =?us-ascii?Q?EteMIFuCkDYdAM2joWfBdccgho+hTKGI93oRWPa+NcTRQY/I58XTHkUHps3t?=
 =?us-ascii?Q?ygggRz+nGwsMqhC4O6CcKMeoU1MfoPl1gKp0M2Y9ZhOBV6+opu0Bde7YFHD4?=
 =?us-ascii?Q?fNiWR/dIZAQjXwoJsamAL8x6DL69SfAmVW3yYydzpyb09Tj3xLsmwdt4LkeX?=
 =?us-ascii?Q?3YRH72O0cx/OdU0CWaR4BQa+h8rSzlG32DvmTyPJfZwplrcu9e8jYYzgGyGY?=
 =?us-ascii?Q?gynnQpiFQUQ0Eo1PcDvzlKaH5W/SDqr8fUF6wlkFt3KdXAXJFcla+o2gT7gV?=
 =?us-ascii?Q?sIH0ld2kRYCIkRO6VymTOwel/m+Ion39Ww4/jFE0ZqWfdie2Lh7ZL8Rog3W2?=
 =?us-ascii?Q?iExAeCJB6YlCF4sCdj97wewK8lSrbTp1kWfdcG5qfSvUq/5Bnvvfuw0xhB2I?=
 =?us-ascii?Q?b28hz+RylVKxD0KV7WwxRpk0KVcVub2sTLcRgdRvX3llRKhI3x4ELLiXOmvm?=
 =?us-ascii?Q?2UG3amCn24f11vTzDJiTxNgJdw8mUPWXZ3QBrzmOERH57oAr2htbo3grkBgJ?=
 =?us-ascii?Q?g6MGHg2oWbgp5dYZm7/ru4Hm3Z9+5FnOjnN+aTYdK4edI54+pdF6/yaDJAmU?=
 =?us-ascii?Q?mPvsOZ0TNZyjOBjBOn4ZBXxjUel12AqmQI5D0KP818va0wRd5RfHYnSUMbyu?=
 =?us-ascii?Q?qVk5o8Wj8yQm6r38JfjYJbO9tITnO8AHXginx64y6nKf6FSCRFbRex9d22V8?=
 =?us-ascii?Q?j7gilFUc6v6bwjfrn1IqCQ3/NApDbjFru/KrakA+BkElc2JH2FJy1NZuxkap?=
 =?us-ascii?Q?oTrve9FZWLqEcZ14Jdv2JxIqDKVXdH+OJ+562xbfCwUN8mko27QP9Qz4SDWH?=
 =?us-ascii?Q?kQIb3cQnaMPcOFPZuLQVo/1IABm/iU6GQw4+vCi+So8zJDqKiT03eTrE9Lyh?=
 =?us-ascii?Q?junML99Dyoei+ZBN3KH/tVGneN4BodK17cLLJWoQ25RDXwEGIGlnpr3qCbCO?=
 =?us-ascii?Q?7yqJVhXU/qH7MwlAa7HFFCg8XbLRJR/2rNwJYMV4VcriJaMUxQ7p2Xqh3yyb?=
 =?us-ascii?Q?UOce6UXTfEzhJoxNfrE+WEht12hiSkAOrE83qFnKgxpXPLR+nA+6Zrcxa7Jw?=
 =?us-ascii?Q?nQ/2pXagGtZRbk8vMW6a3qKyBPQg+nm5mth4z+ZZod02G957v746gNfZpry8?=
 =?us-ascii?Q?1+LpMMCMmgJSUp1NTD2tN8BmH3kTxt07P+BSg+8FDPKZMsyQfjp31mqc3Eg/?=
 =?us-ascii?Q?41Xkxw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa9b4082-ee29-4fc5-1889-08db44316fdd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2023 19:32:12.6120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +OuMxX14iuVMZDcdKLA6Yvyg2x4IqIEeKuBn7df6TpANh9Mmtb/5WPFX4EwIujMoafFJLY2Xf5Nzwj3agMXe7fk1taHjN+UqBIjpOn1ZiRI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5167
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 22, 2023 at 02:37:05PM +0100, Lorenzo Stoakes wrote:
> It isn't safe to write to file-backed mappings as GUP does not ensure that
> the semantics associated with such a write are performed correctly, for
> instance filesystems which rely upon write-notify will not be correctly
> notified.
> 
> There are exceptions to this - shmem and hugetlb mappings are (in effect)
> anonymous mappings by other names so we do permit this operation in these
> cases.
> 
> In addition, if no pinning takes place (neither FOLL_GET nor FOLL_PIN is
> specified and neither flags gets implicitly set) then no writing can occur
> so we do not perform the check in this instance.
> 
> This is an important exception, as populate_vma_page_range() invokes
> __get_user_pages() in this way (and thus so does __mm_populate(), used by
> MAP_POPULATE mmap() and mlock() invocations).
> 
> There are GUP users within the kernel that do nevertheless rely upon this
> behaviour, so we introduce the FOLL_ALLOW_BROKEN_FILE_MAPPING flag to
> explicitly permit this kind of GUP access.
> 
> This is required in order to not break userspace in instances where the
> uAPI might permit file-mapped addresses - a number of RDMA users require
> this for instance, as do the process_vm_[read/write]v() system calls,
> /proc/$pid/mem, ptrace and SDT uprobes. Each of these callers have been
> updated to use this flag.
> 
> Making this change is an important step towards a more reliable GUP, and
> explicitly indicates which callers might encouter issues moving forward.

nit: s/encouter/encounter/
