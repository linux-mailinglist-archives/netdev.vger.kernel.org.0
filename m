Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182C46B7737
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 13:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjCMML1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 08:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjCMMLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 08:11:25 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D3835241;
        Mon, 13 Mar 2023 05:11:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MkqqFCiWJwjxGCTtUX9TPuPezNB4BTX6PBKS9aDuvOSbuxQylmdFegBdVX5D+Qcr2nTabvsiCuqt4sbN4SECJQAGc+ZXTKa4mIIqNDO6ITnI2rgAuVMmWFYfvX42xzZS1Yos4otHCn+q+ChHqE04VSp/SZDH73URsgq9fpX2Pk1z+cHF54ixVM9+QrGhWJcww+frX7oawMLZtXlAtD9JoQ5lDQ2S53pCMCN6dMJJ2QcWiD0h9aSURLlYZCcxBs7OnV+u8dsPYZYTaO8rpndAvIT3IJXMUZpB8wH2XmwAaBrF7UubMMZc4lphS+U4F9f1CR9vsOTcrmIN+o0SLyn5eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BV3xD7JWNLCPZ5/2nJRSaBVE38TXyAoIss1KbDCsPVg=;
 b=VvMDrEMJC3jxzSkOJ2aGM8lHAZyx2h4QLrJTI+7VzOslhpV1fYPE74Lfjf0QvtcRK5KQZ9LAL/A++ySt8WmI6j2pma2pWFycUZwUXbOvT8tlcIg5QChSjhxXpbDSH+ClYXsSSSIMr1/g2mJfNlV6pk3JpnfPkOZRjSguhuwNexpNTgymrtg4v51cABWw4RTFrvka0B/rEMGk0/+ZLdRoRfxSWwJnY5RC0vS1l/h/9LLXjjS6uX+bRpGRKyLdAwFRFcxVFBcU9NbBa4FbQ34ZNn/dbwUDCTC0HSXC6UJNw/fcLZdF7pq1zVs56bFLtJxguzcYCIEnJysKMOGAOUW8MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BV3xD7JWNLCPZ5/2nJRSaBVE38TXyAoIss1KbDCsPVg=;
 b=qGQXvqt6oaneAJhnQH6eHzsoU4mBjQF33UdyjI/mGN4uiXV4JOJsG2LT/1sNCE5fs/l/g7nMxmOU3aifOr04NPr4OXwVKJVeyahqyCqBcOmLQdqGLaOvUwFSuU4GNt2LwBSpKg87sCvlKAbcjswTFC7Q6WPN4IOfEB4cRNaaJOY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4807.namprd13.prod.outlook.com (2603:10b6:303:fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 12:11:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 12:11:09 +0000
Date:   Mon, 13 Mar 2023 13:11:03 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH net-next] net-sysfs: display two backlog queue len
 separately
Message-ID: <ZA8S14QtdBduQEVq@corigine.com>
References: <20230311151756.83302-1-kerneljasonxing@gmail.com>
 <ZA4huzYKK/tdT3Ep@corigine.com>
 <CAL+tcoDi5fVWjyTX6wjJGKrszqL6JWkEgDBajhZchYSW7kyhGQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL+tcoDi5fVWjyTX6wjJGKrszqL6JWkEgDBajhZchYSW7kyhGQ@mail.gmail.com>
X-ClientProxiedBy: AM4P190CA0023.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4807:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c571574-6595-4a09-7c80-08db23bc07b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZCvYcH8rEnjzyqvxfM66Mv7eAWvfXd6ZpHTbVO3aDvLB9hqiv7EkFxXP9bVvAO97z+5/4V8G0TWdmHWF12qZWB8ef8ELyVF4Cf6uR47qRe1YKVaUZMcBWACu62SmP9ugQYNtWvnbcztqXETxfdcvylfeNrLM7KAsUmgVsODfkM8s6fTYyTTORL6nnTAYzTJxGoKjbjOvmiGEGSnCvdoB3cEyIRoLVsX9OumA/E/8sgjPP1duXCpvtZPW1JEtYq8IyJspUqEC5mikguLfsWcTKJ8zsniDxND7wQek20bbEOah8wqLXBVyp24HGCsfPjrHwqPyR12fy74wC1QiXymlkzuWvqFKDEMj8pQ/HyUAe//qHdecIqKJJVTA2WGzHxQ4FS5Z1wbrEB2jwgi3Ymg3bDrwPQtDduok74HheR6lLVu+TP5IgrKQhBJjJnyq8m+HDHS7rc9uRdsllcCGHU/CFZDUbm3sU4qjdrMtcg0cMbsxUDCAJSLCUB2YylWMyjUW4og06a9PgRszE3vXggC/WiDQfnIwtwl5J+ogws0dhQsG/7CcOB01Z1sy/N9MKGMM47eNlV8Gq2SW4PpBVUB/lpHM0qVJOAzUU4BtTyvylbOw7lzcCJ7hSL7Y7gvmYT8TcIIRqmaGD7D7c8AkwWMumw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(376002)(396003)(39840400004)(346002)(451199018)(38100700002)(2906002)(478600001)(316002)(2616005)(6506007)(6666004)(6512007)(86362001)(36756003)(41300700001)(66556008)(6916009)(4326008)(66476007)(66946007)(8676002)(186003)(53546011)(6486002)(8936002)(5660300002)(83380400001)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NkpUejdEbG5BYnhBNC95M0d6QkNNLzlRb1BkRFdqb2ZzekpKMmMrZFB5V1Z6?=
 =?utf-8?B?TG52dGZ3VnVNZFRWVm9VYnhvNGN4RkZCMnB1TTNwWVltc2p5Ynk1Wmw5dkJ0?=
 =?utf-8?B?UGZXTSt4Q3VBRDU2b1ZBR0FmdTF6Y3ExS1Vvb2kyeTVVbWpOTGhEQ0JQUHZH?=
 =?utf-8?B?SW1IRy93RWk0QUtUR29JUzZGUFhnS1NKaFZBNkxrdkVsY25FQTJtWW1rdVJI?=
 =?utf-8?B?NHZUQ1NYclZFZmlZS1FDY2NHaDl4WmFIR2kwZUVMUXl3SWVab3k0SG1pejZo?=
 =?utf-8?B?OXNqVXlTbitYeVBEZUQ1VmV6ckFCTTNRcG5mOUNaWUhCbHhja0wzL1MxQUdm?=
 =?utf-8?B?eUkrSVFxcGp6SVE5VkU3YWxsYm1aekJqRHk4WmFzL24zeXc5MXgwbWZBZ2gw?=
 =?utf-8?B?cnp4cVV4a0FxS1dTL3RTd3Q1Ylk2clA4T0hOR1RTQjIxZk03azF0Y2tpeEgz?=
 =?utf-8?B?a0NySEVEZVI2V0VTUDIzS2NvS00xTHNvSFJDa1V3bXlVMC9BbUhUdXJBM3du?=
 =?utf-8?B?RDNrZTRzQ0JrNXZIN3RKMWRYaTZlWWpQNTZYMEtKcm8vNm90S2p6aGJrNnpS?=
 =?utf-8?B?NTdibDRIbHNaYy9OZURCV2l3MGFoZmxKUEpoc3FEcUdpSEtiUWNvUFAwYUlP?=
 =?utf-8?B?ZGRYV3lhb2YyVDdJVjJ4aWFpdmNOMFByd2lsZXVsRVdRTmhTT1R3V3FUR3o5?=
 =?utf-8?B?MVY0U21BU0NKcUJReXhyVFp5RmtMaVpzbmNZSExOekU5YlJNRWhRSjZHZjV1?=
 =?utf-8?B?Z1BuLzJFb0I5c2VDUy9QVm9qYWFjOXhTd3Vqb1ViOXc5T2NkYWh6cjhKcmcy?=
 =?utf-8?B?RU0veVlLMUduUkhLUEgvNjRTbkkvMWg3dEp5THRLa1dZQzVLWE54a25LODZs?=
 =?utf-8?B?U0lwSTZjcDJwdmlsWHRXc2pHVU01eUx1eVhZNjlLZGlQanNyZSt4SE1EQm5P?=
 =?utf-8?B?cUxRcGtuRzkzNWxoejJsbkxZUkJVSkN3d2ozSVhVRUZBcWJoOGZ5L1lCYTdx?=
 =?utf-8?B?WWxWSUE4ZWpvdUV0TVRxTlJBTEFtdzByeDhTNURFZDJxNUVudUZXMnBhSXo4?=
 =?utf-8?B?dHdnRWJVRHVqdnZ0ZzVzMjNvSWJKK3grNGFyWVAycEJ4RWRiQmZqM3lmVzJ3?=
 =?utf-8?B?RDR4dGVlV0Jjdjl0R1hoMHhPNFNNZmxXV1RNODhqMGJzVjFaTXozdTZWRDJI?=
 =?utf-8?B?OGNTV3k4S1puWDJ2eEMyRjdsT0JpUVpVZ0xpRjQvZVZ1S1Q5Wk9kajlNQURV?=
 =?utf-8?B?Z0VTa3ZESE5xM0VYNWlyTGY1MldZeGlCUFl4enZSNmZkV0xDTkQvOFFVZzRM?=
 =?utf-8?B?M0E1NnR5em1MOW5rWEVOaHJEcXVQUGg1bml1UjBrNlJaY2ROWU1HMUJXQlVY?=
 =?utf-8?B?VTQ1VHUwcFpXbUhoNzEzV2pPMDFmYVJrSlhhSUc3QkpEdWNlYU5kYnREWUF6?=
 =?utf-8?B?a3NjdHpmbi9IVzFlNzNlYTVBQzVCR2FNZDdlUy9jSy9SN21rWUkyZElPa3JU?=
 =?utf-8?B?TGNmUUxEU3pmVjFkVC9rdkF4dlRYNW9DNmNFeW1iVGVFNHdCaHpLSkhYYnFP?=
 =?utf-8?B?OTFadjhCeHp5cVNoVHlyS1EvUmpWblVoS250ckJJOG93TkMrRjNsNDA2NVZp?=
 =?utf-8?B?bjB1QjZsdXI5anU4dGYxbmVvRjlROHlkT1R1NkNjbU4xMTg3VUI1eGpTRW56?=
 =?utf-8?B?N2F4VkJiZm1kMjVpeEFIUWVmWHhaalNSN0o1a2hWaVowOVA0SGl2VWd3OFM4?=
 =?utf-8?B?eXk4aDdRZ3FJK2xoNWdRNDVCcTd0UE5XTGhTMHY3SktYZEJIYTlLYWNvMVNC?=
 =?utf-8?B?MDdFSlZ6MnlMaWR0eFNYTzVxVkgzaUVMQWJTZm9YMkxWcXFCRFZEMXFQRmVO?=
 =?utf-8?B?R09XUUdobmZLUkg4L0Mxc3NFYmVMZm5LdDBJUmpSelJzVDZGeE5oc1l2bE05?=
 =?utf-8?B?Nk9HVmtPRzN1aW53enExbkZqMGlKRVUyZkxrbmNPcEFsVzNoeXVoKy9udFpR?=
 =?utf-8?B?cE9KOTVkbEtDNldaMzFISUFpVWdqMjZ4M0tQL3lzMjdOQmRjdEJiU3RYNmI2?=
 =?utf-8?B?d1kvL3dxK0pmK1VGV0czUW9vWTNSbDhxZDNPMFhVSWZueEh6Y2N2QndJYitP?=
 =?utf-8?B?YXhMYUZTZ0ZrUmtZekJ3dFFKOE90cTNINVNQL1lxdW9haVF2eDg1Zk9kSjZU?=
 =?utf-8?B?ajFhK0V1ejhYY0ZTYXl3Q1NHRjR4WDZIUnc0dEIwVzF4Q1plS2lPVEk1SVlt?=
 =?utf-8?B?WWZEdWJTSktQbHpNQ3dyNGNpeHBBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c571574-6595-4a09-7c80-08db23bc07b0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 12:11:09.4762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PxZOGKc/VFMyMjtiiXBw6z3FyrlicyGGjhrZtbokgCeB8LbWNme+AWDkRD0x/iIhKI5shE7R7G2fRySEn1kMdpBrp3Jk44TE1b7qYtJOJ0U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4807
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 09:55:37AM +0800, Jason Xing wrote:
> On Mon, Mar 13, 2023 at 3:02 AM Simon Horman <simon.horman@corigine.com> wrote:
> >
> > On Sat, Mar 11, 2023 at 11:17:56PM +0800, Jason Xing wrote:
> > > From: Jason Xing <kernelxing@tencent.com>
> > >
> > > Sometimes we need to know which one of backlog queue can be exactly
> > > long enough to cause some latency when debugging this part is needed.
> > > Thus, we can then separate the display of both.
> > >
> > > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > > ---
> > >  net/core/net-procfs.c | 17 ++++++++++++-----
> > >  1 file changed, 12 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
> > > index 1ec23bf8b05c..97a304e1957a 100644
> > > --- a/net/core/net-procfs.c
> > > +++ b/net/core/net-procfs.c
> > > @@ -115,10 +115,14 @@ static int dev_seq_show(struct seq_file *seq, void *v)
> > >       return 0;
> > >  }
> > >
> > > -static u32 softnet_backlog_len(struct softnet_data *sd)
> > > +static u32 softnet_input_pkt_queue_len(struct softnet_data *sd)
> > >  {
> > > -     return skb_queue_len_lockless(&sd->input_pkt_queue) +
> > > -            skb_queue_len_lockless(&sd->process_queue);
> > > +     return skb_queue_len_lockless(&sd->input_pkt_queue);
> > > +}
> > > +
> > > +static u32 softnet_process_queue_len(struct softnet_data *sd)
> > > +{
> > > +     return skb_queue_len_lockless(&sd->process_queue);
> > >  }
> > >
> > >  static struct softnet_data *softnet_get_online(loff_t *pos)
> > > @@ -169,12 +173,15 @@ static int softnet_seq_show(struct seq_file *seq, void *v)
> > >        * mapping the data a specific CPU
> > >        */
> > >       seq_printf(seq,
> > > -                "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x\n",
> > > +                "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x "
> > > +                "%08x %08x\n",
> > >                  sd->processed, sd->dropped, sd->time_squeeze, 0,
> > >                  0, 0, 0, 0, /* was fastroute */
> > >                  0,   /* was cpu_collision */
> > >                  sd->received_rps, flow_limit_count,
> > > -                softnet_backlog_len(sd), (int)seq->index);
> > > +                0,   /* was len of two backlog queues */
> > > +                (int)seq->index,
> >
> > nit: I think you could avoid this cast by using %llx as the format specifier.
> 
> I'm not sure if I should change this format since the above line is
> introduced in commit 7d58e6555870d ('net-sysfs: add backlog len and
> CPU id to softnet data').
> The seq->index here manifests which cpu it uses, so it can be
> displayed in 'int' format. Meanwhile, using %8x to output is much
> cleaner if the user executes 'cat /proc/net/softnet_stat'.
> 
> What do you think about this?

I think %08llx might be a good way to go.
But perhaps I'm missing something wrt to changing user-facing output.

In any case, this is more a suggestion than a request for a change.
