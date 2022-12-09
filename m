Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00CE064882D
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 19:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiLISH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 13:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiLISHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 13:07:52 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BD025E81;
        Fri,  9 Dec 2022 10:07:49 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 2B9HW0aX007223;
        Fri, 9 Dec 2022 10:07:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=MWHByBTZdN19X7K+Znkgm/2rcfzvu9XmIue+r3LgNd0=;
 b=mYuZ/LEOoFpcDyDIfkrT52uz9SjHGpF4AIPx0/QpMxkOCKHeOE1sACVPSAe+FUIXfeLn
 aeji0jwDNlDtr/fn6vM3KbK7NjbmDtShaSQnOCnOC2oQVzT/9qnR7/Gb4+2jxOsYjX5h
 0xEkffZmBMvlFyXC5P7wlaHpbFEuTyFWUBURVV6tXNY6mjfH7HwB9X8C4wci2Ih7Tpew
 yOmMVjSzoriEExKQJ9RCITqtrRze0hswpLDOTxkr0XUQJjb0gWVx4wpoyFWq02dVfTxQ
 broxypd75c0wa/nIF0+0P1vssiuuDccpgrCaCIdjiX0dj2LFZAyYTfeS8csPgKkqzeta rA== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by m0001303.ppops.net (PPS) with ESMTPS id 3mc8asgsfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 10:07:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Palc9xMfg5aC4fwg9uiDCbaGQShlLh6uSAx2mA8LdfYExAvjKuSYdjNnJUaPwBm1T6+Q0HKl8NhtDvzuQh4P3i/3UEUPH8HcnGD0Vw1IDYp1Zxe1CPA8iNNZ1R/p6y260um6s12bJAchtUM5x23+KE7k3VwnCRytJu2f6xwmnMxJgX7HK/04Tj1BfKLnG0HkMnJaOGg7Xk+4XmWk58jyAgP0lqUw8FPhMcDc25OFe0bG+emotUfQzHodGO6EbAk26YVaEriVxuTtZ23YE2yC+0vV42/I8o+5aRrVvgLR8dJHCTJFvQVPnL3eC2EbUBWH9UlbmErIp/N8IrMw0H6FuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MWHByBTZdN19X7K+Znkgm/2rcfzvu9XmIue+r3LgNd0=;
 b=jYhiPKzEVzokQVW6tEV0p7vCBYwW88TYSv8OTEDPNPcBeFtkeCrZ5oMskmh19LoRPcyfIH+Ds7ow5ErriUhb+ToM63HAYD11V4ANwjSgcfPToKJY+g+3bXNcG37x/B8IiOt0JUFFl3mfCn//6ZOpCH6CSvouWfTjt9A5NYeEN7jQ1+FK6PLcY/QrTTAK2aY9R5u0BBsX6wyfMclfV79WZD//KNnSHvVlAvzNwfV5+pelgnbNJlowBgU6W1WCr1sD+TiQE/zhc5TOGHfdeFYxuSoPHjF9iSA/L6WQfdjuFQZiNfXoTkPrZmNC+011f1PJGUE7C3WmqeTIfBHMoiFbEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BN8PR15MB3123.namprd15.prod.outlook.com (2603:10b6:408:91::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Fri, 9 Dec
 2022 18:07:18 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d665:7e05:61d1:aebf]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d665:7e05:61d1:aebf%7]) with mapi id 15.20.5880.018; Fri, 9 Dec 2022
 18:07:18 +0000
Message-ID: <232e350b-09d3-83dc-9490-9785a1995a6d@meta.com>
Date:   Fri, 9 Dec 2022 10:07:15 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH bpf v2 2/2] selftests/bpf: Add a test for using a cpumap
 from an freplace-to-XDP program
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Shuah Khan <shuah@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20221209142622.154126-1-toke@redhat.com>
 <20221209142622.154126-2-toke@redhat.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <20221209142622.154126-2-toke@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0049.namprd07.prod.outlook.com
 (2603:10b6:a03:60::26) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|BN8PR15MB3123:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cf75db7-b238-409e-1bc0-08dada1035b0
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H3zxowxNApzTO06/yDfsq0HXXg0DFZNGhXU+58UE2wWhptCmW/YLF+LQ9DRDC7yt6DDC5mZZ91Xi9xVX+oOYi2RVFegavl1Em5k1Ot8rXRBmvs4MRqk8MqZxR7iIZCpJGhTgZrXMSna9psXh2QhnQWfHyZ5k3ap8hPSaqNf7ex2SYCC7Yf76Aofc5B6mgrZwYMfQqz3Yswv0gJAb88nFNjggTqFMrL8mNAqIsbLxWIQWRVf5Nk0ghMs2g+4a7D8j1igDl9lrC/xMJgpEIAfus/QiMXaJCw7dJMMAiwHCh6ELSIayraJ+kKy6EF6qAyc+1itmW5rcus7fb1XJ8+5EYEFeDjzbyhcrpTcFVID3OfRMQZ0m68cvdC0zcNJbQecNjl1OoTq0BYhm2OSJ/3TdtzUZnoY3MKnAUc+STe3qzxjvAgNBMkeJnN2XoAxDP/IrGq/VUB5975mA1ePret4aERrlfEYyhNh6lOh34d79NdotCrQH3AvLC057yrTh7RThEp5qcLUYDWUcwNedSZ1IRI9JzQysxEnopJg+2R4I16YYw8vJXKKo+8m3zT9Of2PA944JmdaJOV1/gucMBflZ2rXRL7ugR5bwrQt9PB8q6ZUJGK+Iwh7zoNY8sy9otWZH7KsoJctx7H2X3eIaqlCV2BjBvkLcG+wUgVtU1SDT57TMu4BeaVHPaCpViABbRUTLGQMS0puv+zb0qbMIZNtTzFqFA6RX++k3kE635GXJnI6Bch0WZXeIbci+ix17D6s/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(346002)(136003)(39860400002)(396003)(451199015)(36756003)(6512007)(83380400001)(6666004)(186003)(6486002)(86362001)(66574015)(316002)(53546011)(110136005)(31696002)(2906002)(6506007)(7416002)(8676002)(66556008)(4326008)(66476007)(38100700002)(5660300002)(66946007)(31686004)(8936002)(921005)(2616005)(478600001)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGpway9PYWVpUGxBZzVVdTZsM3VkT2JmVjZDQUd2SmVuWnZwL1hER0VVbkJy?=
 =?utf-8?B?MW16b3FUdTF2V1B2VzBTRzBkRHJQRUFGM3UvcFdVdzQ0ZEZlNmloTXdxbGdD?=
 =?utf-8?B?MG0yQTZ0bE1oTnlodVRXdEpHRFRTUThEa1YwYko2RGpqSUNzQ04vZGdnRXFy?=
 =?utf-8?B?a2JQcHpsaUtoeGZoTXZuZU9GMndmOTdxZm5hZHFHWjdnSVRRREhNVTBEUHV1?=
 =?utf-8?B?dFBjWU80MktydVg1TTQycGFUK04vemxOVVNac2V5SVdhNW1pUUxWQitlNFIw?=
 =?utf-8?B?dS83UUZER05Ha0lqQnJYeEpra2hJMlJnZUNHZ1hZY0RtUDN0WWZqbm0yOWFk?=
 =?utf-8?B?a1BxRXpNYzE2dmtSUTN6eTdMcklta2E1TVpZK0wxanh0VVpEUFYwZ00zOHJM?=
 =?utf-8?B?V3lYWlEra0tFc2RsSWtpOTFUUGJ5SllDb1V4UzB0KzRrajcvV0haVXh6Mm5W?=
 =?utf-8?B?VTdHMVRQRHAzRTUrM1Z5SHhKbTBKQ0RaWDd2MkgzRHhYMWVZNDFkYVJpeUNJ?=
 =?utf-8?B?L1VibE9CMXBGNkZPdTQ5OGNLam9ON0NzbHdnUkcyZU1uUlRPV29qeDVLaTZ3?=
 =?utf-8?B?VXFwZURaOWdnQmlzTHpoZXJhazQzeVRBN05UMlVmWW1LNUpmdmc3S01Rb1pq?=
 =?utf-8?B?aFpHMFdJTkE2dmZaRWJrZUhLZC9WMnFHcnp5emhPdHpqcmNlcnBYenJsZlg4?=
 =?utf-8?B?RE56WVB6dEpwOEhpL0d5ME1pN1dHMDdDSjI5b3I4dEpxMUpGQlFTZHdPNExZ?=
 =?utf-8?B?dHVYaUwyN1g0cWh2VW0yd094OXl0dUVURURqVzB3QWJjNHRCLzVBNmY5SXpG?=
 =?utf-8?B?YUdXVS92S2paUDdsb2hFWXUwUGk1ckpjU0hpdGlRaWhHdmxqNHdwcVNXTnRj?=
 =?utf-8?B?Y0dRbFh2c2dMR2FENVFPMkZBOUhDLzkrSkw1QjkzdGlNUnh4SXU0L2gvWW5W?=
 =?utf-8?B?dG8wZGdCN3M3TldvU0hSclMzcWhaQnBRWXJjUjg1UWFCaWdEUGNtbCtqaHFM?=
 =?utf-8?B?WDIxTndGSk9hNzJQV1lWcWhvMS83TlBzN0tURk1xdWVqQ2hmQU5uR0Foai93?=
 =?utf-8?B?aHQrSWdtK1JxdGk3YTRFNkRZWU9nZ3MvQWNhZHZBZFpML2cxOHBtc0pHYlhJ?=
 =?utf-8?B?LzcrWEMzRnN4Wmg1TXdkcXNsdDBPZ3dITFRFcWtmcGM0a0k3UTh2cjd4RGxs?=
 =?utf-8?B?bWhQRmQySmxLZkFKeldNR3U3aG02YjRRSzVPU2JMVHRIeDRKYlB0dmgwcUFx?=
 =?utf-8?B?dDRhZHM0M1dORE9jUURUSU5zTzBqbFRRbFlWeHZKTTVLSXFHMi84MDlLd3Bi?=
 =?utf-8?B?aFBJOHlSaGpjUTF0eHFXRjJGUUhNYUFRS1RnVFBlemZhRlh2VXVYNVV6WWNM?=
 =?utf-8?B?UERXQlVLOENpa01CYko3M29JRC9TRjBWQy9lNlJ0WkpQN1Z3d3dBZEJkMFBG?=
 =?utf-8?B?dXhDMGhMS0hpMXl6NkNkL1J4UElsUmRQa3ZqUU4rdERCdlhRYVlGTkV6eEJy?=
 =?utf-8?B?eWQvcXNkc3Fhb3VzUVdtVHNvTndVUDkzQXlYblBpMFd1WjRkQ1FlQlVlUTYv?=
 =?utf-8?B?c05MUlM5MzZ2aUpzalNockd4NzJYeTlyVS9zSTA5WFc3MGZyclFkUHpKbUM1?=
 =?utf-8?B?SFhPUzF6UisycEFZQWZQTXFmYTZOTE8rMUNUeEtFMFNnRVcyQUxEbFE3K0JE?=
 =?utf-8?B?SW1oQTVydXZ5VnpLanppTXRUR0Z3YXpwQkFTMlA3eDhRTDhNUWN3UE9DUjBk?=
 =?utf-8?B?bjFZNWZYNTNqZk0xa21RWTAxbjZ1bmJPTUJXcmtCbTMrQ2FBMHFiaUFtdGxp?=
 =?utf-8?B?RnhQRzBqUUhIOWhSaW5GNjkzMHpoNUVsYnBIcVVsMGxTb3JHQTZWQUZQa0FR?=
 =?utf-8?B?aU9zVGxPMng3L2FYRnJ4VEVMREN0UWQ2Z0NPMERwa1l5UUZUVS9OazB5K3Mr?=
 =?utf-8?B?NmIvM0h0VG9YYVZEZEVLYlkrUDJBcjFrNEVob2hGaGViUDNLSitFNWNxZ0xW?=
 =?utf-8?B?cUJpR2Z0VFN4N1pkQjBQMDR0Z24zTmc3NUFiMmhZdnJZdnJuY09XR3lqRkpH?=
 =?utf-8?B?NExaWmhTSW1oSVJrSVFMWFdIY20vbFVTbENRbTljRWdUSk9aZWFvempnbmhU?=
 =?utf-8?B?OGFXWDF2ZTZlT1NWay91UEpkVlYzU1ZMN2gzYisrQVhzeGVrbzBTVUxRcFp3?=
 =?utf-8?B?amc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cf75db7-b238-409e-1bc0-08dada1035b0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 18:07:18.3287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yvZztaDeq6enfmosrhZj/U+WLAC9sCZBngEhF5Y35ucAlX98iRlVCts4zQgRy74I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3123
X-Proofpoint-GUID: WM4bW2YzmhVN_4nRdiyo55prdXL4ljQf
X-Proofpoint-ORIG-GUID: WM4bW2YzmhVN_4nRdiyo55prdXL4ljQf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_11,2022-12-08_01,2022-06-22_01
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/9/22 6:26 AM, Toke Høiland-Jørgensen wrote:
> This adds a simple test for inserting an XDP program into a cpumap that is
> "owned" by an XDP program that was loaded as PROG_TYPE_EXT (as libxdp
> does). Prior to the kernel fix this would fail because the map type
> ownership would be set to PROG_TYPE_EXT instead of being resolved to
> PROG_TYPE_XDP.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

LGTM with a small nit below.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 53 +++++++++++++++++++
>   .../selftests/bpf/progs/freplace_progmap.c    | 24 +++++++++
>   tools/testing/selftests/bpf/testing_helpers.c | 24 ++++++++-
>   tools/testing/selftests/bpf/testing_helpers.h |  2 +
>   4 files changed, 101 insertions(+), 2 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/progs/freplace_progmap.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
> index d1e32e792536..dac088217f0f 100644
> --- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
> @@ -500,6 +500,57 @@ static void test_fentry_to_cgroup_bpf(void)
>   	bind4_prog__destroy(skel);
>   }
>   
> +static void test_func_replace_progmap(void)
> +{
> +	struct bpf_cpumap_val value = { .qsize = 1 };
> +	struct bpf_object *obj, *tgt_obj = NULL;
> +	struct bpf_program *drop, *redirect;
> +	struct bpf_map *cpumap;
> +	int err, tgt_fd;
> +	__u32 key = 0;
> +
> +	err = bpf_prog_test_open("freplace_progmap.bpf.o", BPF_PROG_TYPE_UNSPEC, &obj);
> +	if (!ASSERT_OK(err, "prog_open"))
> +		return;
> +
> +	err = bpf_prog_test_load("xdp_dummy.bpf.o", BPF_PROG_TYPE_UNSPEC, &tgt_obj, &tgt_fd);
> +	if (!ASSERT_OK(err, "tgt_prog_load"))
> +		goto out;
> +
> +	drop = bpf_object__find_program_by_name(obj, "xdp_drop_prog");
> +	redirect = bpf_object__find_program_by_name(obj, "xdp_cpumap_prog");
> +	cpumap = bpf_object__find_map_by_name(obj, "cpu_map");
> +
> +	if (!ASSERT_OK_PTR(drop, "drop") || !ASSERT_OK_PTR(redirect, "redirect") ||
> +	    !ASSERT_OK_PTR(cpumap, "cpumap"))
> +		goto out;
> +
> +	/* Change the 'redirect' program type to be a PROG_TYPE_EXT
> +	 * with an XDP target
> +	 */
> +	bpf_program__set_type(redirect, BPF_PROG_TYPE_EXT);
> +	bpf_program__set_expected_attach_type(redirect, 0);
> +	err = bpf_program__set_attach_target(redirect, tgt_fd, "xdp_dummy_prog");
> +	if (!ASSERT_OK(err, "set_attach_target"))
> +		goto out;
> +
> +	err = bpf_object__load(obj);
> +	if (!ASSERT_OK(err, "obj_load"))
> +		goto out;
> +
> +	/* This will fail if the map is "owned" by a PROG_TYPE_EXT program,
> +	 * which, prior to fixing the kernel, it will be since the map is used
> +	 * from the 'redirect' prog above
> +	 */

The comment is confusing like 'which, prior to fixing the kernel, it 
will be'. IIUC, the verifier expects the map 'owner' program type is
PROG_TYPE_EXT, but it is XDP without this patch. Hence, the test will
fail without the patch 1.

> +	value.bpf_prog.fd = bpf_program__fd(drop);
> +	err = bpf_map_update_elem(bpf_map__fd(cpumap), &key, &value, 0);
> +	ASSERT_OK(err, "map_update");
> +
> +out:
> +	bpf_object__close(tgt_obj);
> +	bpf_object__close(obj);
> +}
> +
>   /* NOTE: affect other tests, must run in serial mode */
>   void serial_test_fexit_bpf2bpf(void)
>   {
> @@ -525,4 +576,6 @@ void serial_test_fexit_bpf2bpf(void)
>   		test_func_replace_global_func();
>   	if (test__start_subtest("fentry_to_cgroup_bpf"))
>   		test_fentry_to_cgroup_bpf();
> +	if (test__start_subtest("func_replace_progmap"))
> +		test_func_replace_progmap();
>   }
[...]
