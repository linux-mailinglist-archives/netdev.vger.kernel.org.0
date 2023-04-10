Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F796DCBA8
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 21:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjDJTgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 15:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDJTgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 15:36:39 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613FD1BD9
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 12:36:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Za43uFxDhPL2TpP0aN93UGjZPcuaoz6pqZkoprK5ZPVydmNZLhDhEjXgZSJcutlxJQ3RPZ+UDEXPPmKJg1BM2MW8q9mo5dc8bqTKD0cMNZCeK8j6n9Uu4EpM88e8o6F4ePjlX3vuoLEifCjFJyC1USgBQxvY94MNJMU+iBcRolE6iNJXIeaM3DqKTQLm8RSvGTTAYW1gLoDad206/lusaiSCbZRK02EaAv2WRsRqhRfxa+wXJHHrsp9uf/X97wEFtUx7yGGOa0vDBZgr0CIWtUe5ap4niOVdpYTeHRwlZx2BikLOKcoal8eRxmZuV0Oc1Zk78Egf/mHZl6L0jaORhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7z1zU1eyRcq9oKGWhccHhzUG0wCs6gtdKprpjErdNsM=;
 b=IeQoy6UXAPKhbxftzIwLl/kbqnDtFG96C7F0PifK+XZDN8k5EHjA8nXKpZa7yhmDIdhi1aiFekMgJpD7Uyg3nBshWh1vkbV89r1fI7RT4hzw9tgwwJ3B5IOCOQrzechIfII3wlaIfUiHnhqrzCgKwxSLLmXktkTZY3KHAAqC3fkugOI3DpIXDvtMJAB7nJHwUlxMsNrLdX9KCto7wEdBDCIe1Ev68ALEWqiwBx6S9NqgEBwpLy+S6iSeY2enL2igL2Oh8m0K/zXWwBjvT3TJnzStF1n6SSafA02OKnk8zOT1FeNax7CZl7BG8oRkFRgCoNsooQ8cOXHgMZaoLDcM7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7z1zU1eyRcq9oKGWhccHhzUG0wCs6gtdKprpjErdNsM=;
 b=ueMC5T4JGkaahoFdYx2V2K12blpDJZXDvykj4VfLBec6NflcoG1NeHugqoXVPY53on6jLsbcZQmhwBgfZjVlVzp2CsXD1C5P+ZiCNVXuF1AQkXqdallnb8FpSoojzoQ5JcrQt1sSrRFGUIcl3QRBgLFPYQCnL4umw/IL/PXuyGY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 PH8PR12MB6817.namprd12.prod.outlook.com (2603:10b6:510:1c8::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6254.33; Mon, 10 Apr 2023 19:36:35 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86%6]) with mapi id 15.20.6277.034; Mon, 10 Apr 2023
 19:36:34 +0000
Message-ID: <1d9f57d4-19ec-62ce-de51-742dc32e2019@amd.com>
Date:   Mon, 10 Apr 2023 12:36:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v9 net-next 08/14] pds_core: set up the VIF definitions
 and defaults
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-9-shannon.nelson@amd.com>
 <20230409120813.GE182481@unreal>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230409120813.GE182481@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::7) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|PH8PR12MB6817:EE_
X-MS-Office365-Filtering-Correlation-Id: f4658231-a5b0-41b4-3563-08db39fae4c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0lEtVpJZCBLwuySOO41MsbVV9w3GOioN1jxKy4EwK+ClyWBG+Z0xHwNPjWIuDOpi+HqGoo45Zdvlt3/y5JnusdFQ23u43hIEOHS7fwR6W6MwevgU3quUWyIvq08fRMOe5nbxuSAWLfdz8z0xgmb7tBhlP0Rg5xKJAk/T9mOWnTgHzUgYUeWVvAUp+gCO8PIzFZ9/Sh4VCytTtAsSYuzzLoj7SR2T4siK8SuFa8nuU4bUxlb2/Zp4nwff3jDe6Fh35JjXaAY63qFBWS7K3K98+5LZoUXg0BwL6c+t8wUWW3SUGsCMVBNmc6lz5QQXBwgcqwTNMibje678eCpbwgud80tSKHo69nD9q4i4M3aAgcOdagpIFYrDv/eKxobZ1CXwZqTCDqXvYkR/6YMQib8a4X+nRlsTUHNMYKpwr0L6o04nMnXzgZn7CDzd7aARA7ub2YOiDZn8klm5K1LfOBtXMmw/SxFrMh62TfhNe0yO2EQK2b2jiiCOuu5U6U0TSM2kzftkEr1haLdIM3KoP5HElPgwvbR7Q6Kf1eHJ0fNUYySSD/czD6dwAgiNqgvEKpg5kL/BIK+/UK3QrKWPTpTC2vNzE8aMPlqO9DrL/95oOSx63ojI+JIdK91VMMBFDKc5ayKjzcePyFAqCRq3olo9pg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199021)(66556008)(5660300002)(86362001)(6512007)(53546011)(186003)(31696002)(38100700002)(6486002)(8936002)(36756003)(6916009)(66476007)(41300700001)(2616005)(478600001)(6506007)(8676002)(66946007)(26005)(4326008)(44832011)(6666004)(316002)(31686004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a01NbVRKcFZqZmtDVTJhdWtkbXhzSll6a1RWcERnWElxQ3IveGhvWU9QMDRF?=
 =?utf-8?B?WG1panNrcmhkREVCMllQTHAzZk1KQ1lzMTM4Qm5lV1hEUEdjQWRRUllUT1Fm?=
 =?utf-8?B?T3FFbWdKZUgwY09wRGkxQ1lCbmZUS3cwZ01vQWNCcGxyamtCaFdhR2lQV2hq?=
 =?utf-8?B?bFpWT25uN0wxcjFTamJBdnE5U0JJTFNKc01QUXZ3YXIzdVJCOEVRa3djRzhi?=
 =?utf-8?B?cWtib0FXTm5acXI0cm44d09CblBGUXNlYVpXeHpRVytUWm9tV3NoTHh2dkVE?=
 =?utf-8?B?Zk9PbXYrMDdTNWVhaEdraVVuSW9PcVRpVlA0eGdLUTN4Y1V0TlFnQnBPeVQ0?=
 =?utf-8?B?T3F2TzRqUEVlYjdvRHlmUEU5eGhFRGNvV2RldVh6SkpxYyt4blYyYVFBNi9z?=
 =?utf-8?B?c3prQzRWM3BkaFJwVXlaODFMdWZ6d1ZVWnN1bUZtTjVFQ0lPWldid2t5cVkr?=
 =?utf-8?B?bnUyY1JacFlqRE4ydzFqdDNyTS9RY0phcEQ4MFljSS95VW5GUlAxOXhOZGRX?=
 =?utf-8?B?dGpORDhFdnZTSFIyT2YzUTBHSHlybEtrS2t1L3RXMnVERzdZbSs5N2tuaGRX?=
 =?utf-8?B?Z3V6TDkvQm45K0VNbFZ1NzlvTGVGK2RCR0dLRk5NOXNyNHdaY3creStyWGtt?=
 =?utf-8?B?TlFBUktOcW9ZTmtCcjB0cmppSkJxUEdzVmMwWlBJK0ZET25QRWFUcEp0UnhI?=
 =?utf-8?B?SGlBOXoreUE2S2x3MlEzUDNoTTlscitNQU9YUWFHWXRsN3JTVTMxbnl6Nm8v?=
 =?utf-8?B?TEpQR3JVUDlwbnN5Y1JsOUE4YjNRTGJwN0c1WnRvU3VmL3ZSSndPUTJSVFNU?=
 =?utf-8?B?d2w1bDFTZTgzMWx4RHQvWXNEdWxOMS94clhySFNUT3h1dHVKVnlJWVZMb0pq?=
 =?utf-8?B?R2hFS1lISmUwWFhzVk0wYUFTTVhwMFdxWnJIeHUyNVlGWW4xQjZocmV6bjgz?=
 =?utf-8?B?RlozTVlnZ1laaXAvTnVJUjNBSGxObzlFejIvMnF2YkM4OU14UVZYWnBjMW5t?=
 =?utf-8?B?N1NPYnptbGdaS1F4QTVBZkR4SUZmUWNPdVRiYjQxMjJrejVFakhYVEZvdEpT?=
 =?utf-8?B?eWl5MXIwYUV0dnZ3STVqcGJOZEFpVi9NK2FCdG9JRnhEUWZ5NTUxcmpJRmVs?=
 =?utf-8?B?cyt1eHJuTjQxQ0VUZVJuL3RORjVCZld3amI3Uy8rRFg0dEM4T0lXQ2dkZDV0?=
 =?utf-8?B?WGREUjMwQmNZTHp5bmo4S0pGSmlLQmJtVlFhNjYvejZmcTNYTC8vM2lTMThj?=
 =?utf-8?B?blkxMHdYTDI2dVUwTHB3NnBrZnRneUQ3aDNwTktrVzZselQrM0IrOGlsbERh?=
 =?utf-8?B?SGxXUjQ5Tkl5dW5JdGpoTGJUOUFmVkdwOHg1R05UaVR5b2lLWkJ1cnZGOTBx?=
 =?utf-8?B?bnFOeUNXZjhNUHVablRWOFZpWFU4N0NwVGpTaHJWcWxrc2lnZzMyUWllbDJX?=
 =?utf-8?B?Mit1cTlsKzN6TXQyc2c0U0FWdlRicyt1S01QL0xxT2dabjBUQ2pVaVgyY3da?=
 =?utf-8?B?N3dpZjZoZVNid0QxQThBdmdJVVVjWkl4U3hKWHRMVmkrVzFwSzA5eGJHM0xJ?=
 =?utf-8?B?eEp1TUxLeVB6OWhuTkgzd3l5YnZtRTVGWkhXcEFUbUFVOW1oMUhacmlRZ3lP?=
 =?utf-8?B?SndUMFo1ODlUU2dYeGJveUQyMmltbU9ES3lCZW1qbE0rRHViVlZzbmI1SXpW?=
 =?utf-8?B?MVVZNnNnUklBMi8wV2tZTEJQWXRKU0VPWHRRUU5Od2Z1ZmI2eUtOWVpsRmth?=
 =?utf-8?B?WkhmNUdna0wyODIxK1dMejltS25La1grZXhnMDRkT3lQU2dGcG1YdjdnbXUw?=
 =?utf-8?B?YUlyL24rb091MEx2NUZiT3VMUTdUTkVkc0s3VnlSRWZTVFkwRWlmSlo0ZEph?=
 =?utf-8?B?bjFVeTNRZ2c0MUh5NEJvQlFaUUVYTFlxMjBER0dWdmZrdHZPa0l1U3JRM1ph?=
 =?utf-8?B?L2Q1V21pcEg1Yms5aExXTER3bmtwNFYwN1BBMTlRTk93OXRRc1I3bndhZ3B5?=
 =?utf-8?B?dmdQbE1sVlZ3aVhsVEJpOW40Tm04YWZrbGtiaXdKZHYxUnc3WTZoazNyN3Zr?=
 =?utf-8?B?QzhQNGhqa1pjMEVRV2t0SFlKME5WS2xxNUJxZC9TRUk4VUd3Wk9GVG45ZXVl?=
 =?utf-8?Q?A1qsX+bFuurFlSOM7j5owlBTE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4658231-a5b0-41b4-3563-08db39fae4c6
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 19:36:34.7633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S4LyGE1v8T/TZBhqnjvMsiKFQ7aWkciHFRwvK/GeOtZMZ5L7V+iVa02ngHM5WtRVzxTrchmcJRLtOrrfi+NC2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6817
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/9/23 5:08 AM, Leon Romanovsky wrote:
> 
> On Thu, Apr 06, 2023 at 04:41:37PM -0700, Shannon Nelson wrote:
>> The Virtual Interfaces (VIFs) supported by the DSC's
>> configuration (vDPA, Eth, RDMA, etc) are reported in the
>> dev_ident struct and made visible in debugfs.  At this point
>> only vDPA is supported in this driver - the other interfaces
>> are defined for future use but not yet realized.
> 
> Let's add only supported modes for now.

As stated, only the vDPA feature is supported in the driver.

> 
> <...>
> 
>> +static int viftype_show(struct seq_file *seq, void *v)
>> +{
>> +     struct pdsc *pdsc = seq->private;
>> +     int vt;
>> +
>> +     for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++) {
>> +             if (!pdsc->viftype_status[vt].name)
>> +                     continue;
>> +
>> +             seq_printf(seq, "%s\t%d supported %d enabled\n",
>> +                        pdsc->viftype_status[vt].name,
>> +                        pdsc->viftype_status[vt].supported,
>> +                        pdsc->viftype_status[vt].enabled);
>> +     }
>> +     return 0;
>> +}
>> +DEFINE_SHOW_ATTRIBUTE(viftype);
> 
> I think that it is handled by devlink.

Yes, this is handled for those for which the driver sets up parameters 
(only vDPA), but that doesn't help when we want to see what the device 
is actually advertising.  This shows us what the device is thinking, 
which we find useful in debugging, but it doesn't belong in devlink 
information.

> 
> Thanks
