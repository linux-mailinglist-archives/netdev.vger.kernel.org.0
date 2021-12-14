Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F02474DE2
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 23:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbhLNWXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 17:23:48 -0500
Received: from mail-bn7nam10on2075.outbound.protection.outlook.com ([40.107.92.75]:58625
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231132AbhLNWXr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 17:23:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W7ltI0b0JoVcZQlPxBpV/6VRd7/jkpvA8FH3gp/kiYj/+lAvDIhxul2RnpBCqmnhqs8FIaAl1lfx/3mSpHirINpI5qV8VWBg1qOLs0ySbKQIeRsU/QlDzdOOpKGk8mGTZu+5AugkC5AGkW4g4majVbX95YRP01BSPUiRPjQmyOURA8IUA49yylh2QPAbOYZ6ifl5lPb3/lV0NbllycZF8PC12hD8zIDeczBJ49mvh4ejEM8PmtRnSShGyS6f7gF9DlafKFwNNFtI7BgHSS+XZtG+bXJPWNZ/css7iEW5xv3r1q+MquoEdl9yoOCdRx/ngQmTSvMSoyoQ5mtSYQ3OLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aN/ypNYWg4nvC5d/FKiTZuoHDirbOC6eHg1wc8QPtmE=;
 b=TUJDk+1LusvXcLwf9GU1WdpaJLyAViEQhYf0UA+rjjMbMTSJsDB/Umgp1bXdVXxAFK5GVU15nVW/eqB7HJat6Nr9uta7x0lpNS0Yrlgt6QhQv8EhxUQI0n3HuYq9A0CdpTDgEdWb+XswgTYYfqoYyR0jl5Ano2NhWSsKUwZnfwZUnJDjToTEbqLvhEuf/VpdmK0moGWVRwRWyPVx245FS3taBEX2V8f+HIRi9nColagMR61OntxsNpfbURrjLyjPlG5mkjoVt30meKMxlcKkgNtQCA8FoaLBUZ8r6TeYTuxt4Rh/qbhXtws65KBOILJl3DVWMqGHkeu2Bl7EO97/ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aN/ypNYWg4nvC5d/FKiTZuoHDirbOC6eHg1wc8QPtmE=;
 b=qOGY+Vo5e9Wym6op1aS6gF3Sc6YY1lKOsqCgxTtIZvs/bvqGydlSkgI9mM4+KEf8CKWXAk6vryiOKnh3cVV7z4oJL2ZTnwBNHWzDgHoPEJVNvWdSdpm0zvhkZKAogvVcjOnwqTqOgdMsYXhEz5rl/krnT5qo5r8BviXLJ8ATXko=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5072.namprd12.prod.outlook.com (2603:10b6:5:38b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 14 Dec
 2021 22:23:38 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.028; Tue, 14 Dec 2021
 22:23:38 +0000
Subject: Re: [PATCH V7 1/5] swiotlb: Add swiotlb bounce buffer remap function
 for HV IVM
To:     Dave Hansen <dave.hansen@intel.com>,
        Tianyu Lan <ltykernel@gmail.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
        Tianyu.Lan@microsoft.com, michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, konrad.wilk@oracle.com,
        hch@lst.de, joro@8bytes.org, parri.andrea@gmail.com
References: <20211213071407.314309-1-ltykernel@gmail.com>
 <20211213071407.314309-2-ltykernel@gmail.com>
 <198e9243-abca-b23e-0e8e-8581a7329ede@intel.com>
 <3243ff22-f6c8-b7cd-26b7-6e917e274a7c@gmail.com>
 <c25ff1e8-4d1e-cf1c-a9f6-c189307f92fd@intel.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <a1c8f26f-fbf2-29b6-e734-e6d6151c39f8@amd.com>
Date:   Tue, 14 Dec 2021 16:23:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <c25ff1e8-4d1e-cf1c-a9f6-c189307f92fd@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR15CA0049.namprd15.prod.outlook.com
 (2603:10b6:208:237::18) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by MN2PR15CA0049.namprd15.prod.outlook.com (2603:10b6:208:237::18) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 14 Dec 2021 22:23:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11af7221-fda9-4a28-deb5-08d9bf505fcb
X-MS-TrafficTypeDiagnostic: DM4PR12MB5072:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5072C7592FF644D706972458EC759@DM4PR12MB5072.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r/mV53upqhm/I6Fy6wp82xN4BYDZ6QpFL/sxwj0CxD3MNDEH5AhMN63AQT8ixwXoJ0Kp8K9HK3zFEX0sx6F8IkcGfIhCkLz1J8j6fFCW78DXrCR1h7Vub9qxI2/6buaY2QdbTitZ2N5DsAfLPSKnpzJ3jwD04Rjlzf43I//soLNA7fert146FiYxF6WEoQiQNvQ5Hy/ZoIeUwbYlaE3Ycfc9wxub/0rDBkIpLhJHgYbQzCq8yYtoIUJyqo30TmRwzSNSioYLfPycHrJeSfWUjl5xVKyASFMML+YQ1s34AlFIupUvhDqgO+C4RMOVMB+EybPcuHe7RNrinEQB9ih+TFpCCDrigkuLaShiYq6tCgGFfdaybr8clwhedSAghC4nY08GRRDnwxS4oEPQce4bJwtIpicALtMti5wTmmFCv8wcC+FMWbUZTyw1GzAmatyj0S33x4PNiKhwLnHNPZpsOO9nzEGDN84Z3YU6Q06MARMaWN0xe50oQTCgg6SNw2fnUd3xiEeO53MsnqpKue1FMGIFSrSUr6aFni4bWJj21rtsbDgZIHINQOhsnUPqjfdNYRACt/JnDojqLY9fZPMSDXXE0xc7zRsPYiRobUM3nCyoCBtWR9wnlHnVo+D9AXwyLrmdXLao6F00ivLsvvN2wksB/ml/lSrAr+O/LZw/PpfydLlYOt92w20poMos4TqFllRExCkSpOZyTJV5XJKSN0BOtyPBolViNLvg/Ph81q3bh9zfPNG7wvEkD3CHHUsrhC524QvycKHWHRLHeNpfruriuod2v61/lVT6waVFJnpbG1EQoi2PRtL9VaE4pfY5+Jr6L6f9+4cfDjczIIxPFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(31686004)(6486002)(31696002)(921005)(16576012)(508600001)(26005)(36756003)(38100700002)(316002)(66556008)(2616005)(4326008)(2906002)(8936002)(5660300002)(8676002)(7416002)(7406005)(83380400001)(66946007)(86362001)(66476007)(956004)(186003)(966005)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3JIV1EvTFkrL2w1Y2c1LzROVVJYWnMvQnRObXk3VUo2bkpTa0xldk43RVcz?=
 =?utf-8?B?TnJSalBZQTFkWmJrazVuSGUrUmljOVdMdDJyZE56RENNV1NSb3lRYkNWNE9S?=
 =?utf-8?B?bnl2cWNYZGZMTVlrZFgweVEwZzYyNkpvcVYrR0EyOXhXdFdEQytUbTVhZ0lG?=
 =?utf-8?B?eW9KVlVQdW5aUFNyMEw1NWZvVS80dGNRZHNwNGhOWEYzOTVUdmJleFVsTGNm?=
 =?utf-8?B?c3piNDRtL3J5WnFQY1ZBV1BubkNHTUl0SVhIMjExdlNSUXFKdWdTRytNM1dC?=
 =?utf-8?B?WG04bSsvZWRJaUZxa2s3NE5kc0RVcERYdXlXcEFVeEZJQzM1SW5ia25nelRC?=
 =?utf-8?B?TmpVdEV2Wm9tM0ZqM3owV3pIalZTM2htbjV2aWV3VmVLRDJLYy9TMGpzZGs2?=
 =?utf-8?B?QUpKaVV0S0p6NlZVdUJMSTdncXMxeDJUbDhoNFhEM2ZDSEhuNFdCd3FSa3pp?=
 =?utf-8?B?SDdLTGoxOWo5VGRRZllXcmpYeTJHZ2RrSFVDSVZIeWh3cGhoczB1NEpOK3kx?=
 =?utf-8?B?UVFZR3NydGlsVlB5ZklEZTBNcFBNSGIrWk5GanBPOVZLemlMM0cybEdFeE92?=
 =?utf-8?B?eHkrRkFMakxDQ2QzeThmS2FZcVR1OUY3dUlGNkxsekZVcTMrdVlwZE56NXhl?=
 =?utf-8?B?RXhSNzR2MEZqM00vU2RmT3k5d25PbDUrc3Z5alJFVFNFL0drbitURzRoa0ZF?=
 =?utf-8?B?ZVcwSkVyVXo4RG9LSE9QTmo4Qm5aTWRQdlkxczJFZjhrSHRYK3pRNGduQUdk?=
 =?utf-8?B?TEUrdGFTV2JjajhhVGhHZVN5RUg1NHNtblp4Nm5rN0t3NkhrdkhTbDByWGlv?=
 =?utf-8?B?TGZ6U2QrV2g3U3JSWTRXeEw4WnVZOTRwUzhlRTA5cmRKaHh2RXEybzlza2t3?=
 =?utf-8?B?THRoMHBRcGFRbDQ1cnhEc0JLSWs2dzVsbjJTUytxcEE4TUsyRm5ROWYzTjg1?=
 =?utf-8?B?Ni9SWVlsd2RzN2NFNktzbUt1ZnpwRGhTMVVmQWF6bVVkbVIvZ0hLeit4QVNE?=
 =?utf-8?B?djY3M3N0bnZUYjhmaEtZOE5Bc0hPYlJuRjh5V3JjRkZ4OFNSK3FRUFZIM3Q1?=
 =?utf-8?B?WVl6SEVBRTZVeURvMktaUFk1YzFiWlZwT1NlWUxiYTg5YTRwMWErM2NhTlhP?=
 =?utf-8?B?K1FRQlR4bEw3ZUhSYmVjVmpadlVaSitaY21oQy9TTFk1T3FURDVhbzYyRWF0?=
 =?utf-8?B?ZlI3MmRvdWRpUnJwNUs5cGZUSW1Idkc5TENKZkU0clVzNzl0U1g3cjRvUnZD?=
 =?utf-8?B?ZnhEdWF4dnJkWTVOZVdTY2FBaHdWN1hGcWhRM0k4eVhxNGpaWmlvZ0xaQThw?=
 =?utf-8?B?S3dPNFNVaFMwcWczUyswWVBRZjl0YURzaC9lTUJDT2JYNXNFNENkK1lCcS81?=
 =?utf-8?B?S3A3eFhlM1g1TjhqRzB3Z3Zpb2daM1JSR3FyNm55ZHdwVmw1MmFVSHB6dTZk?=
 =?utf-8?B?ZDJncFNmaWhYSWxUNkIwd1UxalUyNWovZnE5ZE93OUtLQ29RMnpUZUxEZW1M?=
 =?utf-8?B?eFYySExzWnhsTm10TWwvcmgzdWFVcXBLSW1OaWVDbmd3a1ZQRUloNHMrcFhP?=
 =?utf-8?B?eDQ1amlTbEZOSDN4bTJVdGl5RVZhRzZ4TTRpQzlYZGFzZHViTHAvUy9Odnhm?=
 =?utf-8?B?RVErdFVXaDMrb0IxdlVlb3orQ1JrNjREY3U4ZENKdWx3eUt4aGc0d0hsOWZy?=
 =?utf-8?B?N2VTMWx3eHV4RTNrMVlOaGpBSHlEc2pKdGRwNTRjZGtsWWd3YlVnZmM5MWxB?=
 =?utf-8?B?MWMzdmt6dkFkQjQrcVZJZ0dxSXJLNjAzL292b1RJYWwvOEN3OXFuVHpyRnRo?=
 =?utf-8?B?blJ6b0E2a1NTSnBTZCs5QjZwRlo4WWJnbCszUmI4eVUvL2hNeHRIaGJ6YS8r?=
 =?utf-8?B?OEdkSVkzT2VkeURncVJHMHE5MmhKZWdMVjNXOWo1emZOcXpzeG4wSDBBWG1m?=
 =?utf-8?B?SG8wZjJGV0tPN1ZJQXUxOXRBUWtoamVUaFZNUTQrREJKTXB3cmhXYVpmZThK?=
 =?utf-8?B?ZlRXNC84TlZhd3RodjBwSUMwUkE4OEFKeG9SaVBYVkdOa0NpNjFyWVVwaHdR?=
 =?utf-8?B?K01tczgvdFJlOElOa1Z4YTFpTWFyeTJrdlc3STlCd1BaSVdIaXU1bGFJditi?=
 =?utf-8?B?UVBMUGpXS3JIelZBaUk5NkNqVGVtWHZkVnJPbloySFovSyt0dG5mc05zK1N0?=
 =?utf-8?Q?j+vegUo3YzjtqluI8BKssHg=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11af7221-fda9-4a28-deb5-08d9bf505fcb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 22:23:37.9402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: trOwXHynVzJyIwVe5uejfFp/vUHp26bayatLp18EF4QxWNEGbel+3XJXuR+KNBwDrgUHz/siKO2IsBMNNs9n3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5072
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/21 12:40 PM, Dave Hansen wrote:
> On 12/13/21 8:36 PM, Tianyu Lan wrote:
>> On 12/14/2021 12:45 AM, Dave Hansen wrote:
>>> On 12/12/21 11:14 PM, Tianyu Lan wrote:
>>>> In Isolation VM with AMD SEV, bounce buffer needs to be accessed via
>>>> extra address space which is above shared_gpa_boundary (E.G 39 bit
>>>> address line) reported by Hyper-V CPUID ISOLATION_CONFIG. The access
>>>> physical address will be original physical address +
>>>> shared_gpa_boundary.
>>>> The shared_gpa_boundary in the AMD SEV SNP spec is called virtual top of
>>>> memory(vTOM). Memory addresses below vTOM are automatically treated as
>>>> private while memory above vTOM is treated as shared.
>>>
>>> This seems to be independently reintroducing some of the SEV
>>> infrastructure.  Is it really OK that this doesn't interact at all with
>>> any existing SEV code?
>>>
>>> For instance, do we need a new 'swiotlb_unencrypted_base', or should
>>> this just be using sme_me_mask somehow?
>>
>>         Thanks for your review. Hyper-V provides a para-virtualized
>> confidential computing solution based on the AMD SEV function and not
>> expose sev&sme capabilities to guest. So sme_me_mask is unset in the
>> Hyper-V Isolation VM. swiotlb_unencrypted_base is more general solution
>> to handle such case of different address space for encrypted and
>> decrypted memory and other platform also may reuse it.
> 
> I don't really understand how this can be more general any *not* get
> utilized by the existing SEV support.

The Virtual Top-of-Memory (VTOM) support is an SEV-SNP feature that is 
meant to be used with a (relatively) un-enlightened guest. The idea is 
that the C-bit in the guest page tables must be 0 for all accesses. It is 
only the physical address relative to VTOM that determines if the access 
is encrypted or not. So setting sme_me_mask will actually cause issues 
when running with this feature. Since all DMA for an SEV-SNP guest must 
still be to shared (unencrypted) memory, some enlightenment is needed. In 
this case, memory mapped above VTOM will provide that via the SWIOTLB 
update. For SEV-SNP guests running with VTOM, they are likely to also be 
running with the Reflect #VC feature, allowing a "paravisor" to handle any 
#VCs generated by the guest.

See sections 15.36.8 "Virtual Top-of-Memory" and 15.36.9 "Reflect #VC" in 
volume 2 of the AMD APM [1].

I'm not sure if that will answer your question or generate more :)

Thanks,
Tom

[1] https://www.amd.com/system/files/TechDocs/24593.pdf

> 
