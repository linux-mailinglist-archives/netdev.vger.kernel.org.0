Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F2F3A67E0
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 15:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbhFNNbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 09:31:41 -0400
Received: from mail-dm6nam10on2047.outbound.protection.outlook.com ([40.107.93.47]:30368
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233180AbhFNNbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 09:31:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TssKbYwq4JWlNirEuKAXIYFbhBum6dE3vzgfeTkaYzrFB2ioxzfCDymBenqjoIxsqQPYP0ra6zqPSmmYq7WYxyvB+OzR/MAuRcbIg3oEgSuBJ/RapBVR1QTpsbkSlOzDbY8GiQcK715dwRURWXGuF77ieoSaQWpl5z8aUlDoVOIpLBtGWv1NPO/p9dO4Pu3ag2UtYfvlKh8M2ku0gqXCevHduCdlU5RtJj/Ku5pnp0nvGTc+DJabdFMUh1y28+6XTetqezJtddMY9QEJmqQnFxz8xxyAx9sOK0x6+9gdDNeyGSqSwuHw6mNhOdB/F04oRTiXvDH/axh0KXsylHquzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4tEwxi4hVyxOZ0eN1UAOCZfBuAaTWIOrLO/RC/MnHdI=;
 b=R4DLhS/2GP2HTh8B08DBVpbcfhE849XDYc3nE2CaVJs0p3ux8lNYleOiKQxzNm9HWzev8MyrrNoOpeHll69FSbZxjuqzWb8XxMIty5PCj42rTbhi/+AVTPQPMmvk5Tgy0hyh3cbIqcHI1E35kQg36ek+XERq5x2WsxdURc52lgwVWy35mXDp5Jx4+en5upDtAFvZ8wuraOJerrkoxtuDzuGuUNW4rbSC2lrF2/GMwP4V3GNTkpDMx/bTAq9bg2r7Z201maQfivlEjZyQB8621MlkDsj/03zP4ClfxrkubKNg47IX208lklIbOXqzjr6lKMicoe5c4ijWdIE34TyjGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4tEwxi4hVyxOZ0eN1UAOCZfBuAaTWIOrLO/RC/MnHdI=;
 b=ZzpgrFF/sG/4Nosw4z7DxYtRE3dX36+KREkrQTnaqtOGDEEDGAnJlUIbQeIwixqknnSmvJryf5PqfFrsjID1VgKioG1ac5FQcg9mASJqfmBLr8Raj7FQ1A9PH8WqnX6GWNuNIY6B//1YzYneknadUbCKQUzBPwZoqomkTbhc8aU=
Authentication-Results: microsoft.com; dkim=none (message not signed)
 header.d=none;microsoft.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3369.namprd12.prod.outlook.com (2603:10b6:5:117::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.23; Mon, 14 Jun 2021 13:29:31 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::6437:2e87:f7dc:a686]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::6437:2e87:f7dc:a686%12]) with mapi id 15.20.4219.025; Mon, 14 Jun
 2021 13:29:31 +0000
Subject: Re: [RFC PATCH V3 08/11] swiotlb: Add bounce buffer remap address
 setting function
To:     Christoph Hellwig <hch@lst.de>, Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        arnd@arndb.de, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        hannes@cmpxchg.org, cai@lca.pw, krish.sadhukhan@oracle.com,
        saravanand@fb.com, Tianyu.Lan@microsoft.com,
        konrad.wilk@oracle.com, m.szyprowski@samsung.com,
        robin.murphy@arm.com, boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, joro@8bytes.org, will@kernel.org,
        xen-devel@lists.xenproject.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, sunilmut@microsoft.com
References: <20210530150628.2063957-1-ltykernel@gmail.com>
 <20210530150628.2063957-9-ltykernel@gmail.com>
 <20210607064312.GB24478@lst.de>
 <48516ce3-564c-419e-b355-0ce53794dcb1@gmail.com>
 <20210614071223.GA30171@lst.de>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <e76644b9-8eda-8e9c-8837-42299b0754d5@amd.com>
Date:   Mon, 14 Jun 2021 08:29:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210614071223.GA30171@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR13CA0156.namprd13.prod.outlook.com
 (2603:10b6:806:28::11) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-ryzen.texastahm.com (67.79.209.213) by SA9PR13CA0156.namprd13.prod.outlook.com (2603:10b6:806:28::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Mon, 14 Jun 2021 13:29:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e989d99-af08-4a06-4c51-08d92f38711e
X-MS-TrafficTypeDiagnostic: DM6PR12MB3369:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3369A3BCC0CC33B7CD0B7E7FEC319@DM6PR12MB3369.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1QmDGjWWEbGHHVdPamyugQhhazHt47b+mkPusoQGt9Ms/n426x5PB2UvkugkitKBIBvfXLnNi2ZR9RnQuO7cvIN8/Ly0sf02CRgcGMcO+jaRMDZZSHVa/uA2jgenuLLMsuxN1hwvTRjJDDqrBUyVYSUVlgWd55AUbLzUHNNfmG23XzYvY4ciyBTTsx0ffYIqDd3QseUNFZe8uKhh7vdTxLHZkHJZehOdMlY1eRqRSFQlYXKpppWVBBuZbEgMIbyHsUgDVajruTR3ygUazc3U4AcvEb4SiDUnt1UdMGBCCHSvUBkLWKdVtVI2N7w+0pBfL/dtQhDrVozV5/+i/Gb1dQ1Zk9gFHxrb10QTaRIOLpwDj2sTFJAZeUG/fxCxkk6s7YHXZBxrDIJS8M4XVLeDxAzDrtLjMvQF9i7K3471NZbYwEz/YNXh9yJS/zTO4o5gAoRTXYE41QZxbxJWHfPe3xxvCf3T69KL2V2s+5O6G8AzLJVTkc6mV2BTcsMKK6nR703FY/Ilf8iHpUYn3yqXMCWGTpe/0hd3Cfpi0gW0JiLgdl/u/F0mhjsHsi1SqVnY+qABvw+Ks6ZtLvwM4eETAPkOPNQohevxatH4sqYaA7tIpAkbNapUhRCKbbxrRnVPg7pBnjSK6EyLv6zjR7N/+Xg/EVl4pbBKgq8+1dQPqFJbArKwS179+AMIaX5k5WhUPXTKyAEe+MvOHa+0mbIN8ppm8xlm3WL5wpSlOpGOiRxuVwESXB8nDimPgpsST2H9J+hcALOIjl2ipXIoS9cOTVYBZIwjtehtjPIpYO4C9fxlxqHZWiWjyhcKhuTeLnoD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(2906002)(16526019)(26005)(83380400001)(186003)(6506007)(7406005)(53546011)(7416002)(5660300002)(66946007)(4326008)(4744005)(86362001)(66476007)(8676002)(956004)(8936002)(2616005)(66556008)(38100700002)(31696002)(6512007)(36756003)(31686004)(966005)(316002)(110136005)(478600001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U09KclZSaDBTaTI3bnJlL0oyUzg2OHVoU1lETnluRVByV3JlT25FZk5ZcjMx?=
 =?utf-8?B?aS83R1BiUkdNVjRuZ09yYjJBYTE3bSs3Z3JWWHJweXlPK3FTTzM3NjFQYWNE?=
 =?utf-8?B?aTA0czVZNU1ZOVA2SEFVT3lkZ2dDdDQ1ZkU0dWN2WHdNNHByWVA2VDFYeGtV?=
 =?utf-8?B?QmpNdWtzYXo5VWJnVXB6c1YxRHJUQWdqb3FmWkJqaWdOMldNNkxvNFRUM1Zn?=
 =?utf-8?B?c1FCWTZKRWFnNGthVDdiWHVTU0MvVUNOcW5TeDZ4dkVLUnpMS0x0cFk1R1lS?=
 =?utf-8?B?L2FCNGVzSTl6ajUvT0ZnbHZWd1VoMVJvTFdnUjNnVFRxNmFDNzdnMmtOd2NY?=
 =?utf-8?B?UzArc2liWU41UzNldFF4ZmVDTW9FR0tIMzhLYXlvNWNsakZiS1FpckQ4aC8z?=
 =?utf-8?B?d2s3QjlBbnBXSFhTNTNBVmlEZytuZzBlVGdFcUE4R1d2Mmh5ZlJSZjlPY0JS?=
 =?utf-8?B?bmV0SmpNNk45ZFRFMXlsQm5GWGhGT1M2M1UrWVY1ZmorNTZWSEE5VkEvWG9S?=
 =?utf-8?B?UzJjd25HZGxveCsvRkkxTFlNQ1ZYei85Mjlya3NISkxadDRkRFhuWC9lV0Rh?=
 =?utf-8?B?bERCTmQ4UTcyOGxnR20zM1ZMNzFHMDR1QTRndG4ydlhOZUNnRlk3a2xKMDlz?=
 =?utf-8?B?aldJSDdvTll6QkZSaGpjRUhjNzZwb1hOTFpCc0lMdXpGZ05LM1JOWUFsM1dt?=
 =?utf-8?B?YmNlWDJZV0pRUGxwOGhuQnRxTzlZdnJsM0h5cnJWSjU5bkJEbEtFUzM3YjVl?=
 =?utf-8?B?YVpseGRkYW92QXRpWjd5V3NOYmE0Z1VlZ2FSYTQyNzUyVU9yaWJxS1ZZZWo3?=
 =?utf-8?B?a2NBMmpjVVIwVU1RaXRvQStqQmxlYTQzTUhmYU1IWXFaczVOSXZaM3dCVXZW?=
 =?utf-8?B?WDgwNXh1UnJsdUhRTE1ocm5WTWFzMHI2Q3pzcVIxNW9HZ2doc1NCMHdRSWFT?=
 =?utf-8?B?aW5zaGlUV09sd0VsTGVJOXorZ2RxNzJxTDFZMmlUeG1HYlpidkZWUmJLWGM4?=
 =?utf-8?B?VEh5SlJYMzhWMVVJTmxERHpGbjBoTjNOdkNzMHUvamVyeWVzOHhjRmtNeHV4?=
 =?utf-8?B?NUlTTGgyVHVOd0t3bndIU3NLejViNlJlS2h1TmFScHlWc1Z4bm1pR1NLQkR1?=
 =?utf-8?B?WHBUeTNyWm1UODJ1QnpRZndXN0dORWVzOHJCdVRVVnhTUmU1NzJUOFZvNFNv?=
 =?utf-8?B?TWZHSHNpWUhoRklic1l4TjNNU21nTlRyR2RlMFAycmtKN1dFQUtnSmw1cEdJ?=
 =?utf-8?B?WWdEMnc3bzdkK3laMFhoVDRPeW0vRlZ6bEhlN092eVI3RTYrSVIwTHpiRCti?=
 =?utf-8?B?TVJkY1lhenNZZCtPL1RCMkVpSGkrV1lVYWZiT3BvcU1KVlc0cjlTR2xlaXll?=
 =?utf-8?B?NFdUN3Z5VVRiY1BQb3BZOTBKODJoVHZ2dStMRWlUMG0zamdLN1BFL05lbjMr?=
 =?utf-8?B?RTZYaDFtQ0dXSE1Hdkxhd090cXFpb1BWa0lqQmJ5QnhMNXZ0c0lpNDdoZ1VB?=
 =?utf-8?B?RTBjTDBGUDZORkc5TGorOGtKQTRMaUs0UlVVRGhpSDlJVkd6RTI4VHg0Wlc3?=
 =?utf-8?B?Sk1RQlNoakdJNVFzOEx2eUJBNmVsM1Aydmtod0FFYjBIRmxPOC9DbEM1aU0x?=
 =?utf-8?B?U1N4aHRFZjNNOFF4WlUvL2hSYmt2RDJTaWlQVHFHVk05czFQS2s0S01RZUFZ?=
 =?utf-8?B?ZmRMT3Z3SkpGR1JiWHBjWkZyeVJBeEJYclQ1YzBpVG9acjFsT3k5UUpoL2xL?=
 =?utf-8?Q?ZHYZOzjn4BogJ5Uq0Zqb/GJaQ7hliEsKT3RlIOF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e989d99-af08-4a06-4c51-08d92f38711e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 13:29:31.5169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WI31GdrXDga81nCxIOcSfQ8NG9RmlJ/RvBfGoXtWFVMP2J3ukSn6BXcu+zCQcToiNLLEwGct1WP42ocHUZLDKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3369
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/14/21 2:12 AM, Christoph Hellwig wrote:
> On Mon, Jun 07, 2021 at 10:56:47PM +0800, Tianyu Lan wrote:
>> These addresses in extra address space works as system memory mirror. The 
>> shared memory with host in Isolation VM needs to be accessed via extra 
>> address space which is above shared gpa boundary.
> 
> Why?
> 

IIUC, this is using the vTOM feature of SEV-SNP. When this feature is
enabled for a VMPL level, any physical memory addresses below vTOM are
considered private/encrypted and any physical memory addresses above vTOM
are considered shared/unencrypted. With this option, you don't need a
fully enlightened guest that sets and clears page table encryption bits.
You just need the DMA buffers to be allocated in the proper range above vTOM.

See the section on "Virtual Machine Privilege Levels" in
https://www.amd.com/system/files/TechDocs/SEV-SNP-strengthening-vm-isolation-with-integrity-protection-and-more.pdf.

Thanks,
Tom
