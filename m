Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2985B6F1A8C
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 16:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345960AbjD1Ofk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 10:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbjD1Ofh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 10:35:37 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2484690;
        Fri, 28 Apr 2023 07:35:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VunCsV18USN9/sZ80QN84NeBBB8A8P7HnZLIgxTWs4tqFe6fcxJSNYoDew+xCDKMhAJ5t+2oLbR8sTQqWL6Z0jX/OQJiG9oXZCvY2BLOCEKDvmi3GMzjBSi4bZEtJYLIUb8M8ttP3SDSRPApspZyDkCMFdgObqFvs7lJt/Bsj5GvDjvU4LiY0DWEuvMhEIFyjHvDC+FI9LV8Hz9HUGQ4nAMw6MK+Ez72cNAnmEryKGB9ZhRKGphCd1XsAxn185h45DYR0me1UOexwfh4vzL4IqF5RW9UkSqzDXrzGV10ryCy8unHZor759P8Aq9PWSxQjoF0HipjAcgsMIkATRF6kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cXtX5qwjE0B7nOiXRFSGK1eSaOsv/+YmLYapCdL3dfg=;
 b=EWosFxgeKZOggQMNstTD0ntnlOTu5ivyrvfrWI/GgGvUfildukBn4AfmQvE6hhoCWLUBELrvHnCKPIpykPNaHn6GY9F/8EDAc2N0pimJP4oaVwrSV7JC9lnS9C+r2WcQNbKjehsxZmRLcP21+522SN5goEpSGQLpK2nqviRUNkDlepwRizXDV1GQw3M6I850LSalI4lZkyT0Fs8sptJDAZTUdHZRmqj1nlP0pFdxhMKLOVxrOY7pdPQNreGKpufysh11yFA0rV8uQXV2ix+EmSCFuZ+TIgNiQV7DvqUxxlWBzq/mQ1jPRCiDqWzXNpxjHqz6I0jDJhP8HQn8rxKc2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cXtX5qwjE0B7nOiXRFSGK1eSaOsv/+YmLYapCdL3dfg=;
 b=b7luDXoo00uI6EiKz1VFjbDe9NcpIG62eF8Kt/fNj9++1TajRDdw5HpPbkk8KD9nWlNOyaNdfltlyJVHjomnz15NyJSNd7jc5g3apW226OIYt7yoz4cvNt+I6+SitB/3rJWo1xjhjQyjFG94To21RcSv0OOfq60mozNVQ6CPR49I04IgCA9IoO+8W+BMCMHeGowfqqIij7hpHWLNI/0RFzY9iLa/uJFbQ1EYYBFwlf+seDAbQ6ZJVBn9VJiY59TjjqUNff7akLo3wMEjzAcgLlf2iHVwWMDG++LBsGBHQSRRmiFO8lU6MadhcbeJbh0jkk9icroxlgpazLKZO8bZng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4968.namprd12.prod.outlook.com (2603:10b6:a03:1d2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Fri, 28 Apr
 2023 14:35:33 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.024; Fri, 28 Apr 2023
 14:35:33 +0000
Date:   Fri, 28 Apr 2023 11:35:32 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
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
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <ZEvZtIb2EDb/WudP@nvidia.com>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
 <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
X-ClientProxiedBy: BL1PR13CA0434.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4968:EE_
X-MS-Office365-Filtering-Correlation-Id: faaa790d-c0f9-4044-7ffe-08db47f5d2df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2xrGEShKDMnyq4gy8vWxoUrB+AbUU4ROS7JN42w2NMuz1sedxjecD1FiFySjWOEigMQ4vJaQL1QVErKdxxf9DpZx4U7s7TIHj5teIvyEc6JS1R1+H+E31WQr49VRyxvPENuU/1ac/1FynqQOr9CCE/meY2yvr6Fo9n+XVb31ylkSNuRBM/Vpp0w0SqxFmPmCrruim5RcbpW+LKfOn81JILyR+38x2f7OMxHloRorb6SPClplkEIH7h5eaYBC+UbhhW3x0mdYDMzmG8XR9It2cO7TBF7sl3At1w8V5E0Hmb8JVL33m5B9sGWwl9t8JTQwZSHouL6C9g1yUEVhNFRDF/ZTU/fun0qidRmAagmzrzvWzpONAneqHE9NfRVIYZsuRnnWWOBYPR7785RDWVlEUgMj8jspuKpFezZX1fDGczWPUOdkwv55irm+0U5vz047zyUK8eDyFvATnQk7q/7eS9A/tBw5qtS+0yB2lZaM6r8bbGwB0IYqOFxtGkWWHKaIVEY1KXOpglb5a3zHVPVvIWgtHTFPcZjdIbBSp90QOh+XjjfP7aBzM5KxFbuKPfOZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(366004)(136003)(396003)(451199021)(316002)(54906003)(6916009)(66946007)(66556008)(66476007)(4326008)(36756003)(6506007)(186003)(6512007)(26005)(53546011)(38100700002)(2616005)(83380400001)(86362001)(8936002)(8676002)(5660300002)(478600001)(6486002)(41300700001)(7406005)(7416002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tz1P2s5YdrLLv5ePaM9oRAbbEtoIH4OfGWrnU1KP3+BfxJUwqNbbM9upRdxq?=
 =?us-ascii?Q?q4H1zYCQ2MJ9+SAx1IDiigbx/asFYvHDhbS4HojnICYPOpGcr0wSlUAz4uu1?=
 =?us-ascii?Q?Y7vppBbaRRK9u6WOpbc5bardTuXxEYoZQE6//KapmnaOkWPSRhhp9JE5DU2/?=
 =?us-ascii?Q?dKogWYNbstrJdM2JbZD54pnW6rBbh+1iije25OYnkh2sOwmALdnX53QNKHNI?=
 =?us-ascii?Q?gWm4Cm/AYqAfqYFPmi2/dE3oSc+oL/iJhcF2DuIR4OZ9AJXkx3YOT2yztpqF?=
 =?us-ascii?Q?7H7HvqfApHoA/h3lCK2pqfdQ6SKvU0nKeTBF8rtKHoevsJoYZxnI86XzjxR8?=
 =?us-ascii?Q?s67cfT7hSG+bgkadISsatemfIDjoLZRlKY8wORr23ScxUiN7DQLDSN3mNQtU?=
 =?us-ascii?Q?kFe7BUyKsgTevn1WbfoWWWJUuajwZIIrNguqwArraU7udFfKWGAM2G2GbXHe?=
 =?us-ascii?Q?jiAcZmB1UjMqjWVG50bHraK7KGtFa2KS7rQCj20x8IjnFC/O257XlJdtI2/j?=
 =?us-ascii?Q?Xdu1zMJWPbacmLy3GC3uOFCZhXBg3LQOMH3o09NS4gv36X7drdDyvbZYntzB?=
 =?us-ascii?Q?Ti8Q0PmqKKxq67OgqcFPSsI936JXXWYBqpst5DACBe1epZV6OYGSj75xK6dZ?=
 =?us-ascii?Q?h1hxDsa+DUjrRJWl+ICUwgdtUk/t9TJptSZ89hVCAIwfh8dfrXRtYnvWmMXR?=
 =?us-ascii?Q?KTzoJvNJPmUCJJZUrVb975lpK7ks1XQYCBztu840APcz2OKMfiY3/B2783rt?=
 =?us-ascii?Q?pMFfHOSMTH67iiHa3peb3BmhdnWvjv3vdaUgHuy1qHrJv5llOjYQ/NS8JKRC?=
 =?us-ascii?Q?msGQg4kNnR2WzPoAylRLwYGp1/BCQw1Cm3fxMqfKxxBDZpZ0BbjEMMgquY/N?=
 =?us-ascii?Q?7qBBEe6x83l5Bun/THI7Nk7ciNE39Lxu2U0IwCQlGX/99wVeLdSlfCSaMUlb?=
 =?us-ascii?Q?J7lfahT6Awqhn2JrU1aCbQkNjvNPMbp67vB4jYF1YdGUpsFHuwg48Ym5EhlK?=
 =?us-ascii?Q?HMhqiJcpad3RTMnpQfWfPoYKKjMdXlJ5Tbeq92jYQ+uSqT1XhsOn7PijIHev?=
 =?us-ascii?Q?sASuVHc0fdBbsrGAwod5ykdPlfMdSKdOixOl+xggpTZ5LMzrVw1NZU06P1VE?=
 =?us-ascii?Q?VsKCYHd+ug2pehThvsesbkKPhhd+BIvPnft8HH15IU/7g5dlAJnw7o76ILej?=
 =?us-ascii?Q?0nc8r3gpT6jnAcVB7MJo8nCH5Isy0FDMNUvuNZff4CnBaciOTf7BWmQeC7r0?=
 =?us-ascii?Q?5O6984+gwGK6Y+w8PZO1bHNDOU8MbIUdQ1oBznY9yQiXo8uV52wVbVFiPjWB?=
 =?us-ascii?Q?S0etCCLEeRZ330lXiJD/pimIcFuytufkPJHfm3kVGd/vhfciN8DepbrjXICf?=
 =?us-ascii?Q?CSunR2cN7TPNe7Q+RYVVpB3w3/MdJsRQBKISbo1Nn4u+YImm+IFsMlKpnw+Y?=
 =?us-ascii?Q?eUVBeJC6SheWhQJLSLHFYyXtsy2e1kmdIMM9PCIQTZ08BARM1wfuKHmizeyw?=
 =?us-ascii?Q?mIkIMgSZGljr7rfuP2rKt+N+SR9jDi457xyTlQuAO54Y56oAw8Zn2cjAo2Ai?=
 =?us-ascii?Q?xaxrYxXj8zPTANq+NnBjNuT83jgF5KjqkmmsNJ9s?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faaa790d-c0f9-4044-7ffe-08db47f5d2df
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 14:35:33.5768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ez8ZgkzkNMBJO52wCHIjUWtV2aTU5dEftcEz3kLOaKTC58UfCBHWQpqW0L0UhiSS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4968
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 04:20:46PM +0200, David Hildenbrand wrote:
> Sorry for jumping in late, I'm on vacation :)
> 
> On 28.04.23 01:42, Lorenzo Stoakes wrote:
> > Writing to file-backed mappings which require folio dirty tracking using
> > GUP is a fundamentally broken operation, as kernel write access to GUP
> > mappings do not adhere to the semantics expected by a file system.
> > 
> > A GUP caller uses the direct mapping to access the folio, which does not
> > cause write notify to trigger, nor does it enforce that the caller marks
> > the folio dirty.
> 
> How should we enforce it? It would be a BUG in the GUP user.

I hope we don't have these kinds of mistakes.. hard to enforce by
code.

> This change has the potential to break existing setups. Simple example:
> libvirt domains configured for file-backed VM memory that also has a vfio
> device configured. It can easily be configured by users (evolving VM
> configuration, copy-paste etc.). And it works from a VM perspective, because
> the guest memory is essentially stale once the VM is shutdown and the pages
> were unpinned. At least we're not concerned about stale data on
> disk.

I think this is broken today and we should block it. We know from
experiments with RDMA that doing exactly this triggers kernel oop's.

Run your qemu config once, all the pages in the file become dirty.

Run your qmeu config again and now all the dirty pages are longterm
pinned.

Something eventually does writeback and FS cleans the page.

Now close your VM and the page is dirtied without make write. FS is
inconsistent with the MM, kernel will eventually oops.

I'm skeptical that anyone can actually do this combination of things
successfully without getting kernel crashes or file data corruption -
ie there is no real user to break.

> With your changes, such VMs would no longer start, breaking existing user
> setups with a kernel update.

Yes, as a matter of security we should break it.

Earlier I suggested making this contingent on kernel lockdown >=
integrity, if actual users come and complain we should go to that
option.

> Sure, we could warn, or convert individual users using a flag (io_uring).
> But maybe we should invest more energy on a fix?

It has been years now, I think we need to admit a fix is still years
away. Blocking the security problem may even motivate more people to
work on a fix.

Security is the primary case where we have historically closed uAPI
items.

Jason
