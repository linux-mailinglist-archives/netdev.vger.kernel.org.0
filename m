Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5697B32C451
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392110AbhCDAMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:12:52 -0500
Received: from mail-eopbgr80044.outbound.protection.outlook.com ([40.107.8.44]:63007
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1382991AbhCCNjr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 08:39:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cVRUjEF05YEtg8hC1oeuUWoXtnkEow0TaEH4lJAcm07dwkVCLzE/efrcV2pAKxjtK5SbdYPGC2LM0+o87cS+/8mHOptdcC7IMj0HtPPEHNpVF6irrUVKwrICkGmAVPi/w3CxJaw7GojAHI2OLRGUZj/84lZj7uHZ5mjWmUqcY8e4cQ8JLDjsANpJYUevibts9EEqJBUtO99QprPDBFlXC/aN5hZjAM+LbmUUbcnYjGKkWiY8wI71Slf2QvO6lftJNwKKw9yfQgWsdP6ivt1l8olyIRKhKcvdL+0+YZjxW5iNn7yvLFHn6StrXk+sGotrJk2bbnAqwnIKhUb89HnO/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFZTlRkkpCg6umSnwqHRzv1Q8ABEASUxSi7gsk/UFEE=;
 b=iHeMyK50Aw1ALxkncGQq+GhsGfpbZj+3lAbNoCXumaryMugpD0rZxc5Bw3WOWQUOsjPgxiT6atQZeDOi5GG8kBjWcqZ0WCl6MGUfARLbodgX3zGFpx75S/+f9AKYNbtZMY6An0zLs4IoYYIz80lendXkoFYk7AEI4Kok9e0tn92lfMTjrRYp0KfpXW+A0FOg+m16JB5K3mlbZrz5rNQxccYDjm+B0xtelAjlsdkR8aK2nmGrJFA5KdEmF8jZuVLuIlFXcZiVN//jCh73y6FRQF1qdMJE7tuttQoYIzUlwcAjq/8UXfyVZVxYND1o+FeQqHclNobZUBinUd+A+PsW8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nextfour.com; dmarc=pass action=none header.from=nextfour.com;
 dkim=pass header.d=nextfour.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NextfourGroupOy.onmicrosoft.com;
 s=selector2-NextfourGroupOy-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFZTlRkkpCg6umSnwqHRzv1Q8ABEASUxSi7gsk/UFEE=;
 b=FPVPuSNgvjbAU8lNm6CBPtKhz2UIElLuoRQTVLxJUD89vQa2f0fujAXm+9UffsHA5bg8/9LyiqDHZVI4EI0QOuYk1Xs+lXZlIuBZdxoyacUF41vckFQHbljfNL25pE8Mp0HHnjQW4qGq7QDi2pqYFzbvhG/Ob32GyS3Ke+e13ds=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=nextfour.com;
Received: from DBAPR03MB6630.eurprd03.prod.outlook.com (2603:10a6:10:194::6)
 by DB6PR03MB2854.eurprd03.prod.outlook.com (2603:10a6:6:34::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Wed, 3 Mar
 2021 13:38:43 +0000
Received: from DBAPR03MB6630.eurprd03.prod.outlook.com
 ([fe80::708e:9058:61ae:cb9d]) by DBAPR03MB6630.eurprd03.prod.outlook.com
 ([fe80::708e:9058:61ae:cb9d%7]) with mapi id 15.20.3912.017; Wed, 3 Mar 2021
 13:38:43 +0000
Subject: Re: [RFC v4 05/11] vdpa: Support transferring virtual addressing
 during DMA mapping
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210223115048.435-1-xieyongji@bytedance.com>
 <20210223115048.435-6-xieyongji@bytedance.com>
 <e2232e4a-d74a-63c9-1e75-b61e4a7aefed@nextfour.com>
 <CACycT3tFS=UOUqFKNP0R8fztymz+p9RP_d0843xDbVFd_govEw@mail.gmail.com>
From:   =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>
Message-ID: <aad1b7a9-0a3b-6220-06e1-bc4a3e2b59ed@nextfour.com>
Date:   Wed, 3 Mar 2021 15:38:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CACycT3tFS=UOUqFKNP0R8fztymz+p9RP_d0843xDbVFd_govEw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [91.145.109.188]
X-ClientProxiedBy: HE1PR0901CA0060.eurprd09.prod.outlook.com
 (2603:10a6:3:45::28) To DBAPR03MB6630.eurprd03.prod.outlook.com
 (2603:10a6:10:194::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.121] (91.145.109.188) by HE1PR0901CA0060.eurprd09.prod.outlook.com (2603:10a6:3:45::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 3 Mar 2021 13:38:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76bcdbc5-b59a-448b-6557-08d8de49a96b
X-MS-TrafficTypeDiagnostic: DB6PR03MB2854:
X-Microsoft-Antispam-PRVS: <DB6PR03MB28547DFC97F7EC6923BF8EB583989@DB6PR03MB2854.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: chJIM6y2ywD4Ya+iSUTv3TIE5nq7KRoId/3Eesayx4dXXPZRs49TMhkit2Hc5mwR+PFzQiIP4hRHuzEYSGR5LoeJhLl6IXxczbd+AcJkyXaA9xdTVkKMc9lba/bSwHMNr9S07nsIf7w93IlhJmf9xV/ws1CH355ITPjREbhAcrqtAT2rBBOh6AGYmLIp1T/ecMvz10Wm/gid3sXYugWOdjsD8oQ9X13isMwDebwVUXsDkRWkfZfRCptpvN35oF9rlzVW9u1egu+PCmdQ27tHTl/U3/A++FT/LJefO7gvAnPOB76P5KbzaypopYtIOprmu6hbm4T3D+FpOXv8AEoMi3VvpqR49/TwBbd7W1Bt1gU0I6hs2Ku0HgVsZjr0KzwQaIYLOviaLb0eCUivI9+1KOx3RuPFkqEGJ/VnZUsfmHu8CNtcQtreMnAIAGbRl0yhI0KYHnvO2CuN9UcDpNIfMN3r32dqjRr5OE7M7UCD7P/M7D2EAEsqqW6UsQdRIvU710mBRTS7zBtQQ7su6+i3hgVLdr5XvLhxceE/+NdK2pihrAe2u4cXJ6qaPAkmkBoXhMPrwpVk5uFQcBVRwwO/ZUAhzNHHuVP1s+QMjNoWaso=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR03MB6630.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(39830400003)(136003)(376002)(31686004)(16526019)(8936002)(2906002)(8676002)(186003)(7416002)(31696002)(5660300002)(53546011)(83380400001)(4326008)(2616005)(54906003)(6486002)(86362001)(6916009)(66556008)(956004)(16576012)(316002)(36756003)(66946007)(26005)(52116002)(66476007)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RmdBOTgzUHUyQlNTYThDN0dyc0hRblNPazF2dkFwWWRWQkE4RjF1K3krRm1r?=
 =?utf-8?B?cHZzMjBjZUV5dVMxZEdCOFhhODhENmpoMzVVVGVsMWhrTzM3UDYxUFdVMnNI?=
 =?utf-8?B?OWExbG1oSDZzS2R4Z21sLzJpMUtVQlQvdnU0dEIzbCtIbEUwQXE5UTVMUUxY?=
 =?utf-8?B?aWltMHVoZk5KQkxMVHp4aWNtRnA1SEtsWnBaTW5nYS9jUSs2bWVzVnk4YUdK?=
 =?utf-8?B?Z0RuOEVxK2NPb2FLbXpPS1NoR0dNYmcveDFjMmRQUkZwbXpBTWVoUXVNc2Zr?=
 =?utf-8?B?dm9wUFd2QXdidXVkK09HTFdFYjBrOVdWdG5hRmZzMlFGZGNnK1dTbmcyZnR5?=
 =?utf-8?B?aDF5SW04NkFZR05hMXlkcmY2NnVTZ1NJQUJlZlI1QWlyWGVxV1Q1R3BtZjY4?=
 =?utf-8?B?cWdOL09jK2l0aTNxTmRMV3ozcXNKM090b0xUWmtGYjZMdlZySzlPZTlNMWM2?=
 =?utf-8?B?U3RDdlNKNVNSVWVYV3JadUpFQnQ4NVArSkN2OEF2Y0VxanJvK1E5M2phUVFh?=
 =?utf-8?B?UzJGMHZJNG1zZXAvT2NXanNBZy9YME11MFFXVHd0ajlMVHBEUCtBWkVQbk90?=
 =?utf-8?B?Y3FYV0tUNngvT0pWaHhjZmlkejdRSWtzKzNMWnlQSFJPZVpnRkFXbEZhbXNa?=
 =?utf-8?B?VzZDSVdHcXBLVXV1blRpUjNWenNwM2hoWDlZV3BsQy9SQ3h6R0tlUUI5c3ZV?=
 =?utf-8?B?RnczaHZXT01VSUJIL0VKUkdJeStyTzUxK0ZiQU02eWZGNkJnT1Vqd0ZqNi9N?=
 =?utf-8?B?eEpkNGRucXl1aExZWmhsbG1wUmdBanorelMrL0QyenFsOFVmdGYvMnZaeXVi?=
 =?utf-8?B?UGcvMVZ5RWJzdTJQWFdwbXd4NERUVE5VYk1BcXBIaWZRcXRSaWZyaWs2bDBl?=
 =?utf-8?B?eE5VVUlMbWNueU85OXIzTHpUeHdLRkFETC96Z2Y4VEZSUnhiNElmWDAraU13?=
 =?utf-8?B?K3VsVCtGcGlZRmhmMUxKUTBxbTN1b2RTQVhGOGgrSDF5RE1OUnhXM2JjOEtt?=
 =?utf-8?B?ayt0L2pTMzAzb1VabVA5ZE5EQXFtTEhGcXRhbzZyS0swandUeml0ZDlHUTg1?=
 =?utf-8?B?Nk5MaTBYbGZHdnp3UVIvZE1zaHlaWEFrSTBUMHZSSS9acXBTZFozVXFuWC8x?=
 =?utf-8?B?NHRGNWJpNmkwS1FZUWtmUkI0ZUhQTUFubGdCcHR0N1dBMFJBeHRqMC9vOGVV?=
 =?utf-8?B?M2NjNElHTkF5cDJjY3NSRWhQc0M5MTJKYjY2TjRBWUdGNGl0SGd5VFhXOTlk?=
 =?utf-8?B?MmVyNU5qYjZWS3NHZjhkUy9CanJhUEg4WUZ2K2EwVUFZaWRJYUl4ZDlkcnc2?=
 =?utf-8?B?NitlV1hxNjB2YWlHb0pPaS9yZXVLamJqLzNKL24rTURJbjEwdUk2NFQybkR2?=
 =?utf-8?B?ak1EY2xWblBQTUg0UUVVd3pCLzFteW9jZ3B5aXNzSlhkNzEwNXI2Lzk3cU9p?=
 =?utf-8?B?UUhzZkh5TmwvV3o4cHA1ZWFKd3BFNms3ODVGWkpldnJERUlEMmNobkh3MEp0?=
 =?utf-8?B?MTNGV3BEWlVlR3BFYmwzbWFNOFFId1dzRFNiajk3MUE3WEhwblFycEtxWjhv?=
 =?utf-8?B?WnFlcTRVYnVaTVh3UmtpMEVwRndwTVVzVTJDRTBtSUFYNHNXbFVXYmZJaXox?=
 =?utf-8?B?OU9ROCtzQ3U2WkRDQmdFSkE4L05JNVVGWVdlUXJsQk5zWi94enUvNTRjT0ta?=
 =?utf-8?B?N3Q3VC9MY20xMlNrek54R01RSndsNlFwR0ZSMm1xZ01PWitzMFFXNEIwMVZO?=
 =?utf-8?Q?3pMWOIarWMe2IDjP/L2D2DQWdJ2JilQS7ocCWIb?=
X-OriginatorOrg: nextfour.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76bcdbc5-b59a-448b-6557-08d8de49a96b
X-MS-Exchange-CrossTenant-AuthSource: DBAPR03MB6630.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2021 13:38:43.4349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 972e95c2-9290-4a02-8705-4014700ea294
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xnbNJlayeZg+To40SxkOua1LIdG0nxEQ785WIhOTXUs+9siWkrNdjQ0QrR6qSmJNk2KnxA33wDyfpXs1AwSYvfbmnEuooL2fgSprjkLQTS8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB2854
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3.3.2021 14.45, Yongji Xie wrote:
> On Wed, Mar 3, 2021 at 6:52 PM Mika Penttilä <mika.penttila@nextfour.com> wrote:
>>
>>
>> On 23.2.2021 13.50, Xie Yongji wrote:
>>> This patch introduces an attribute for vDPA device to indicate
>>> whether virtual address can be used. If vDPA device driver set
>>> it, vhost-vdpa bus driver will not pin user page and transfer
>>> userspace virtual address instead of physical address during
>>> DMA mapping. And corresponding vma->vm_file and offset will be
>>> also passed as an opaque pointer.
>> In the virtual addressing case, who is then responsible for the pinning
>> or even mapping physical pages to the vaddr?
>>
> Actually there's no need to pin the physical pages any more in this
> case. The vDPA device should be able to access the user space memory
> with virtual address if this attribute is set to true. For example, in
> VDUSE case, we will make use of the vma->vm_file to support sharing
> the memory between VM and VDUSE daemon.
>
> Thanks,
> Yongji
Ah ok you have a shared file pointer + offset.

thanks,
Mika

