Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8451A41E145
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 20:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343982AbhI3Sg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 14:36:28 -0400
Received: from mail-dm6nam12on2048.outbound.protection.outlook.com ([40.107.243.48]:65312
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245683AbhI3SgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 14:36:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nq4I0L8VXIfNZB3fEBuY5rMEyDuYk1HXY9zbQcICh9KCocKpvyT5fF1KQOGYo9ah9hgHGXJSoeoqe8wGqOaprs3rpy9BUZtRq/wA9VbcPsOfXlCnZ6B4MzakevfirZPGe1CQlFTzzskVgXzdLo9cmUSl98StRPgfKDjL8Oss5gW+BUuzvP7XabfMFEiAg8YvOnfk6jlFmTMrXiGkkXbBb3NB1DUHG1FLu/m5xpnShG7WTDnnQ1Fj2h/m8Fj9c0wNU3uN0nyIlhyVF8PQG47Fk+FsJz33O+Ti4rQcBfj5opJb/gJGRoW7nFy9Q+N+g74RwRjt9QyzR62HlkN7M1d/Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=y7EOAKWOsmn3v/ffm2kAGObAa3aRdxAM0hHtpX8OpRQ=;
 b=A8/fUdCsVQAWb+8CM5aELCtT1YOsDIbFqbH8LJ+faG2i46uPS6zqn2OEUTlJFu7V4Gapyb/u0bgKguYZkTe9TlxxjFaTSx919rhkPNortGYBLz/PDELMSoY5pVKG92aRuQLdaJLUb515WpjnHEHf+pKpvDLLBk2TQAg4gkbvXpuCx9bxvy178R22vi+EertSmbKh3SvSYbEW6dHSb9rYYaJZp8WBN3tjAazLphaGFE7Azw/mfL6kFUErYfg187Dl2/8WCsGrlymMwEIdUtR64nIlXzGeZcYjklpV8/dy8KeIU+2qZ/cl4qMhNmfXZvj2vBzfr2xTl/MjN5WTELm5Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y7EOAKWOsmn3v/ffm2kAGObAa3aRdxAM0hHtpX8OpRQ=;
 b=DV5JL/bLvskyuRmjh/Tf/z4XnvnnSIxT6hHpf6WgKIiILDe1U43WlrdhxK6aHNvvkP7aoALw2n3Nyv95DEHiy+6W2X7o5iXg/eaRpY0CsH4bsHGBDLYNJp5mT0W2bpyBADnLVm8GmgmRo4PYJR8vdcMR3TWtmZoIyG4YtXqsY6E=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM8PR12MB5493.namprd12.prod.outlook.com (2603:10b6:8:3d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16; Thu, 30 Sep
 2021 18:34:39 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418%7]) with mapi id 15.20.4544.022; Thu, 30 Sep 2021
 18:34:39 +0000
Subject: Re: [PATCH V6 5/8] x86/hyperv: Add Write/Read MSR registers via ghcb
 page
To:     Tianyu Lan <ltykernel@gmail.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, brijesh.singh@amd.com, jroedel@suse.de,
        Tianyu.Lan@microsoft.com, pgonda@google.com,
        akpm@linux-foundation.org, rppt@kernel.org,
        kirill.shutemov@linux.intel.com, saravanand@fb.com,
        aneesh.kumar@linux.ibm.com, rientjes@google.com, tj@kernel.org,
        michael.h.kelley@microsoft.com
Cc:     linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
References: <20210930130545.1210298-1-ltykernel@gmail.com>
 <20210930130545.1210298-6-ltykernel@gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <a10b24fa-98dd-ae57-ca63-2789a06abe7a@amd.com>
Date:   Thu, 30 Sep 2021 13:34:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210930130545.1210298-6-ltykernel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0234.namprd04.prod.outlook.com
 (2603:10b6:806:127::29) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by SN7PR04CA0234.namprd04.prod.outlook.com (2603:10b6:806:127::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Thu, 30 Sep 2021 18:34:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c77fda6-5deb-48b3-bc13-08d98440f5f3
X-MS-TrafficTypeDiagnostic: DM8PR12MB5493:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM8PR12MB549351F74ED6507AAAA420FCECAA9@DM8PR12MB5493.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oNM9mNQun7pMDbf7U8NX8SHEdFkBKGAIJbiD1gz0hHBgyAuSutFUIB0jdE+3CzAVFuCoeDxDizmr5g5lGI5oZXA1Wk8mjewy0J7VP5GJFFH0Ip6qk3Kd/l+/I4lZPW8kLYO3732frh6fCrxY+PrNti2fIaIrbnlMhdHQ3nfBhlmdT5pZ/Qr60Afg8+TnHv1vlsMi3Sic9fljYvYMvFIUDh4QrCASKz+fsz+hjFX7CjkWz2uu5XYuF7EIhmVky6TTQYBtjDCjtHysqi0x/0gB5WlcXpbFMgSkeEYP7EUYD1hOMItU/Agh5PAgThQGEhsn+9s2ezQBmWSRQE5bxyI5nsY//APk1Cn/IvWrJcY6G7fs18+xBcq3I2xKyK4VN+Nw9Z4YYVs2In+a04EjfrKJt9YbIBulEvrq/xssdighEXtC+BffhaMySwSDlK9hEL+lr1A0fMXy51KItHBGQQ/PyWyzmKyszqxN2yaAXsEEltKhAIATSsQI6fQe+Wszj0WI+ojQmAyn+Gzg84xyqA9cOJlfSEQzLcmcxkeI2XTz1Q6lKYxoAhmT41L+IfbDNVYyrgRZZGQgUa14w/P8wqXadxLerpSHjyiNDvlhwGhVl+KuhmsXdbWEZz/B+zaafWLeIZFy0mOYtccS+J+6JNFjvfWnDznGqNrjJbjwMgd717Mx6O8UWr+sDqBZ6N/o+zzEebXWYosjca1SkYfuuLMWX9U8PZGzvobGD3F62JBcXZBif/ExEjW7f5TGjihot8gN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(4326008)(31696002)(45080400002)(921005)(16576012)(36756003)(2906002)(186003)(6486002)(508600001)(26005)(956004)(2616005)(66556008)(4744005)(31686004)(8936002)(7416002)(7406005)(8676002)(86362001)(5660300002)(66476007)(316002)(38100700002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0k3c0tPdEt0dXNGMW4xYXZmZEVGYkFJSGZneDI0NWl2ZXVvR092Sm9neC9V?=
 =?utf-8?B?LzV5TFJ5eXZzbTlLZ3JNWS9PR1kxc3kvOVRUZ1gxSVltSDRYMUdlb2w0SnZX?=
 =?utf-8?B?K3JpSlZ1eG82dlZ4NVJUVnMrSThySENBNVFIZ2hOdlFPc25lU3B0WVpBamY5?=
 =?utf-8?B?M1NoeDV1eHZhSTB2WFRJMk13S2tPNVpIUGRFSTdVTXR6TlRnUEczMGVaUTRi?=
 =?utf-8?B?VUJ4ZVJ3V29uUXF4cFVGR2ZLTmEzYk1zOHY4NkRCUjFmTkNLN3A2V3dzUlg4?=
 =?utf-8?B?dWJneWo5RldjQm5tYXdMakZ1c3prSG9iMkRiZyt5c3pkdGxic0xVT0QxeTAv?=
 =?utf-8?B?aWVLM3BBVWE5OWd5RzBFU2FqM25ZM1MyK1cwL3k0NFpKYzdKZmRvN2R4amxm?=
 =?utf-8?B?RUNnSkxiYnhBQXRQRFowcUNQV2tQSEJyd0JJY2gwejZwc0UzQStTbzBnYjZO?=
 =?utf-8?B?eUVwUWU4c09jeDJ5NHpLdU9ReGhlaHJycnJ6YzY2VE0wbHUzYjA1VmRrdTJY?=
 =?utf-8?B?UWIzZnF0d3Z6d0hIN1dsWk1vb1VNb3l5UENLZXRpUjNGbldFUGw5K2tZU1dE?=
 =?utf-8?B?aitMOEcvSXcxN2pDM01hQlRDZThxeEh2R2l4VkExQVB3dlBnMDZSSzJPS0pn?=
 =?utf-8?B?eEt3bExrQ3BWeSs0Nkd0V0V4L3pxMGp5MmtsRFlId213S0d0dDJkRmM3WUZz?=
 =?utf-8?B?TW5DbmpvU0V6a3BVUUFzeHVTWWdqbGozMTNWWGZUemU5RXp4N3RxeWFZd1Fx?=
 =?utf-8?B?YVdjcWMwWXNwOEh6TFJVRExlblBxT0tLclRmTzExQ1FMMThVZWJHbGw3RjVm?=
 =?utf-8?B?bVFDZlFtcURJMVZmZjFFb1VpOSsranNpaklncTZSOWcyM2VMUWJqbUxMcE4r?=
 =?utf-8?B?SkFmamZnQmNwU2xCRjdaWENMSnQzbUduck1KQ0EvTUtyQ0xzYXQ2eGpEd2hr?=
 =?utf-8?B?RElwRU1xSlhJQi85MVBDelAyNW51THRHZGF6dy9EY0pURElyTzlJcVJQTW82?=
 =?utf-8?B?MjB5WHBGWjhQV1pESXZYZExSczJ6RXd6cHhCcnJDR0VkWXA1a0p0eXJ5RWNh?=
 =?utf-8?B?Y3V4ZFBzZlRvMmN2Q1RaQzBvY0dHcmozWCt5SWRTNFNleU1LVlBaZTdmUU9z?=
 =?utf-8?B?d3lzTS92aDJhWHVWZWp4YW1mWTN3a25iYWtKcVNGdXgwT09jVVJuVGV2NTRO?=
 =?utf-8?B?UjhNR081aTVpREFPMmU5Uk5aUm1kbEl4bk4zVVBNN2NvVEsrajJNaVhGSkNh?=
 =?utf-8?B?SjFrSlhYdTVCclB3a2xkV29oMHJScTFQcDNBNjZmUTRwb29BNzU4TTJHNzVi?=
 =?utf-8?B?bWNZVjdXb29UMUtxZ2pOWjBiR1c4YnV4RDJjTktTaVRXY0dEUjNXcm9Nd1J5?=
 =?utf-8?B?NmVwd2YzWU1mRGxOSjVzVkRPVnpVUkh2NHlmbVFiQURIRXYxT3lPaDJweWtU?=
 =?utf-8?B?cGU5OUJjRXBNUkxjTFlzelAzMUJSNUx3eVZjWVQ3YjRvUUt0aklzcTNTb2h4?=
 =?utf-8?B?S1U4d0Y2cFh4SHkzN3cxcGN6cW5yWm5VZ2pvT3lQZ0FnTVZrMGpoaEV6THpT?=
 =?utf-8?B?c0lwaGNTRzM3NDJEVGhGRXZST2srYno2NjdvVHFGQ081R1Nsa0Z5TkM1eUhr?=
 =?utf-8?B?bTNWb3B5c3h6eGNjdThjUmJqWVdsT2FCeDl4bVVSZklUU0dyc2FrQ1l0VkNo?=
 =?utf-8?B?TmpaYnBWYXJ5K2NaZmptZlZrZzlMUmtCMDl2aDBJaTN5Ym5DR1ZiYXNIYXVr?=
 =?utf-8?Q?ZKionn6azNBHtsBYzBfqfkR/vAH6nZ1arYxVe4x?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c77fda6-5deb-48b3-bc13-08d98440f5f3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 18:34:39.5311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bh5rKL4Ar9OwCE2Ws+MvsM8V39LAcLDAQgHEWQaicxfi0PUJ4P42w3xeIHEPM70AFpTQ7C/S4WFzSq1kfjm8pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5493
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/21 8:05 AM, Tianyu Lan wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>

...

> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> index 9f90f460a28c..dd7f37de640b 100644
> --- a/arch/x86/kernel/sev-shared.c
> +++ b/arch/x86/kernel/sev-shared.c
> @@ -94,10 +94,9 @@ static void vc_finish_insn(struct es_em_ctxt *ctxt)
>   	ctxt->regs->ip += ctxt->insn.length;
>   }
>   
> -static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
> -					  struct es_em_ctxt *ctxt,
> -					  u64 exit_code, u64 exit_info_1,
> -					  u64 exit_info_2)
> +enum es_result sev_es_ghcb_hv_call_simple(struct ghcb *ghcb,
> +				   u64 exit_code, u64 exit_info_1,
> +				   u64 exit_info_2)

Oh, and a nice comment about when to use this function directly vs. the 
non-simple one would be nice to have (basically use this one only for the 
Hyper-V Isolation VM support).

Thanks,
Tom

