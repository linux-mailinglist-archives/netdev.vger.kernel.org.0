Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F8E6A4C5F
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 21:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjB0UjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 15:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjB0UjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 15:39:16 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C6D196B1;
        Mon, 27 Feb 2023 12:39:07 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31RHYZFP012450;
        Mon, 27 Feb 2023 12:38:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=Mwo4DytSvdVzpGaezOr40wySiEfM/k3el3TpyyyQI/Q=;
 b=W+S5NmYtXvBbgrzhkx91FxIFY5I4sFPUz0HqmdY9odSOJheSsW8U4XLslyBHWlES1eHV
 J6IMXHVFz+EEPp7Y8bkUGTVTT5tcgokqFnamvAD/5xx323ZEsPf1U3huBu9JPMTEIn5I
 yXC9fyUmqrr66mtb60RLkuL4a6eQxBPEeYMjJ+BdpP3IrQpmr2MAi64oQtdNgZNz7CWD
 zEf5bUz3p+R9LU70ZEVGb9QbUD4DH/J7LWq/TqBQmmxQypQnJPyyHGNOgjjo5wL+BT9o
 vl7EZF4k581XklaWLdpVKPjsfZuJDzuTFsmRLkkWm9yGAIbNzW7Tmyq7FcF1Y4hULLjn XA== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3p10851uh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 12:38:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUeuUkMDFOrJH53YGNTp+kGTlgRQ+3W9tWdsDx35h5Vn/9d/MyTOxmfTZ3fz2p+O8IXENw/oLOabR75Y1BYPlfFyo7UKKl4ULRXH47u+l13RjYeo/RCrnfHz1gfoN8q11NAdI5WRXToQaJgTPq0or4+GLc4WBvWK7j45MuBUXeIDg9+ZUfnuT4o0PQBFJXApI22h6VCOMOtj/8Q6AUxFHprZwtYLvPiCO+GtoNoZ7F3lFdmUC4E/AABgGUyLIu6augCesAbu7TiR/V7E8nSngv0VLFCyy0TqWZI+7vy+IgzEJJV5ali2QWR5jUarmInrWXdfUclhxJU6OJCxRXrNTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mwo4DytSvdVzpGaezOr40wySiEfM/k3el3TpyyyQI/Q=;
 b=QfJjnZQgbhwCasWAPz3NSOog5Lznwj8dCuvgMZPcYqNiGgyVABZk+nXWF9VdSims9qBYylGejR1Fcvvn2qSAkqXEYXdTANqGGVGekXIhxvf6V8gIwL1er1oV8ARAV3QsrIEvocIkNiu8ORxMvmOWXuLt8J06j42VwXar1bz9vPj7rk8qPHRXHYdRMGWgJhf8v67hVkFtrGnRtp8pvSUBsuyT4m4A+720xNcqcZ50ZrdGejfBUpseb+RfcGa8//CuG1pedVX0IMCzO7LZ7oBgYNkNFFbKi8fmPs9EZB2t01EgYP5Y9vADjNmCpvsmPQsMPQJcUqmxIjkizra9AgWQoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM4PR15MB5543.namprd15.prod.outlook.com (2603:10b6:8:110::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Mon, 27 Feb
 2023 20:38:50 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a595:5e4d:d501:dc18]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a595:5e4d:d501:dc18%4]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 20:38:50 +0000
Message-ID: <e519f15d-cdd0-9362-34f3-3e6b8c8a4762@meta.com>
Date:   Mon, 27 Feb 2023 12:38:47 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH v5 bpf-next 5/8] libbpf: add API to get XDP/XSK supported
 features
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kuba@kernel.org,
        Martin KaFai Lau <martin.lau@kernel.org>
References: <cover.1675245257.git.lorenzo@kernel.org>
 <a72609ef4f0de7fee5376c40dbf54ad7f13bfb8d.1675245258.git.lorenzo@kernel.org>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <a72609ef4f0de7fee5376c40dbf54ad7f13bfb8d.1675245258.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: SJ0PR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::14) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|DM4PR15MB5543:EE_
X-MS-Office365-Filtering-Correlation-Id: f45b47c3-c9bf-4836-44e8-08db1902a239
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: egU3Wl1Flpw54ZtET9TBp2/XPnIZCF/+OVt9MUB05tvogM/btuKtdDZ4uKk/sdIQpiQXBSKUSYUPTIUk/YXe2gcIo9u3+vAGI+QhwEIW2taOvExs6WMhZTxcBaXpT1sXwo1sSk16zryFn6wkfAyTEsgoxYD3hIoRZU8wIQQDlIYdxqwxB4NAc1mEayunR4BNj0xs0+DIWU5eWrBfTwHxebtdwnrpsKALcGnQVGjp/Ye9GKUheWvQH4oT27cbbxHzfJZtGOWL+ntb66yZd8mZ5hVeXBXdKLmILRupyVh1RxxNfDir+GFlzHPBxHw88hqC2nS/zAlJIXNh/bqneTaosujELzqGnplQnIBqOSz15vaLPkA717Veqy5iTeMnjNxMDmH1Bo4w7XPuLeRFaEtSmG/cNDYMcYwgVOm5DCgVXomJAuPd3BCpq7yM2VZadoTmZGogELrQ7c3GkIyaDF3xmjzQ72uhIMQtbMbNuD0R6fR+YQozRAUi69f5Hv1no/NJwUUcfrGicCFI5ErzYtGTX+0L8MGHGcP/WP87BKuPYsMKo9QvGMJynjQSQJQRBwIAFGtMMhRpBo8tzC9QzaHS21/frYYdt3pM59Pu2faXjJmykz72Ozy+qzNPG4xto9ti1Tpvpwvv//59SEegsodGGOTpATVJbHl5pTw6M4omvtMLmxiH7r4KsidEGF6mZnZFJ/B29M3tOJf3EG6hKRozY2V1tuEHp9TQP4DPIP/xNi8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(451199018)(31686004)(2616005)(36756003)(31696002)(316002)(86362001)(6486002)(186003)(41300700001)(2906002)(4326008)(8676002)(66556008)(66476007)(6506007)(66946007)(478600001)(8936002)(53546011)(6666004)(5660300002)(6512007)(38100700002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bEMyUm9yL1R6ZWN6Z2labnRiRmM2a3V2d1FvZ3hpSmtDdysyMEg2c0Z4YVRK?=
 =?utf-8?B?RVpyYnBqVEhmcnhBVU1zN2FraWlDQUdPbGh6TktXQkdrZ3ROa0l1MFZsZEFy?=
 =?utf-8?B?bEV4WC9xaDJrcEZyVVo5RlR3eWpsVUVXandFTkpHSXR0Mk5DNkI4bzdhZFhC?=
 =?utf-8?B?VGtqSXZjc2t5LzBKSC8zQWp0UWg2MHRaQzNVUkxVQWR3a1N3eVdLMENYcEx3?=
 =?utf-8?B?NGs0TkV2TjZzeHFIUEM0SlNGbGR6S0JhK3NkNUhybC94cWRPMlMxdkVzc05M?=
 =?utf-8?B?TFpoZXphZ282Tnlwa2ozalBiRzRrTTRxWVRvYzNHMzY3MlpQMHB3WU5vVTMv?=
 =?utf-8?B?VDFqWnNlN3JWQmJGWlFaZlJtaCtpMTJNMFdmWlBVbjJzU2czZUJYNUhKdlVU?=
 =?utf-8?B?OHY4a2JHS3NxbkpaN1dLOU5WN2JIZGZnTmNTbGFadWRZd1pFU3YrTkZCRFdu?=
 =?utf-8?B?aDB1R1c3SXUwTlQrWCtkamxoaXJKeE9tWVhTT0RKRVIra2hFVmZ4VnJMS2tu?=
 =?utf-8?B?ME45T2lkMjBYVVViR2tXc3pweDBBa2pIaWxKcWJaRzhwM1N6RytNUjVMRWJ4?=
 =?utf-8?B?RHhJVkhLSFFIa2lWUS9xbTBSSFBYcVNZVmwxbnNZM2NFbUg3dW5VYmhOUXpH?=
 =?utf-8?B?YjBXL25tdFdueWVrNlR5Y2JiSDlDdnVtRXZNYTlNbTRRemliaWJJNXo0aERu?=
 =?utf-8?B?bHJBOFF2YjZKNVI2RWZBVGJBSkJ6VUlzaDZ1WDBDL3RKZHNYbHhjeHQycUJL?=
 =?utf-8?B?K3lGQk8xV01qWGtoRERMbnNic0pzWVFRSUYzZFpqSE5NVkYvVG9oWThwazUy?=
 =?utf-8?B?cmZ4YWlZWmRZN1NTeDBvS3g0dGFDY3FQUitKSWtPRENxeWhENEt1R3lmRUNR?=
 =?utf-8?B?OWRKS0JKcU5XOXR2emdycnV5SWpRR2pFOFpvWTdLb0c4dE0rZ0IvZVFiZTRi?=
 =?utf-8?B?enErUTRIS1N3SDE2dWVVRHMxR3RDK2Z3Vng5WnNUcG9hUXhzY3lEdTFQbmpW?=
 =?utf-8?B?YlVCMDE2NHNxbGFLQTJZaytaRDZpSU80WnJmT0Fib29aak9PNGpzOXM3NDhu?=
 =?utf-8?B?YnlTK2hvZmwwQWhKcHd1dGdVRGNwRktKdDIvZmlsN1JTOTlwazlLRHRiaE5o?=
 =?utf-8?B?VEZjYXJNaDZ1eVdBa1gwc210c0lwS3Z0cGYzNWw4NWFUSHl1Z2t4SFQxSENS?=
 =?utf-8?B?TnBFcVE3OHlRNGMwdUI1QmxybFRDWlNJaS9rc2FvaWdzcDBSeGJUKzE4aUpF?=
 =?utf-8?B?YlpCcWc2OEpXT2toUmVrRm9XdmdZckxaS2RQU1FVNlU3ZmFuaFlGMnZpVUVC?=
 =?utf-8?B?YlcwU2k2c3p4K29RZktqQTV1ZDVja0Q0UWxpcVo0YkFhS0RHVG9PNTAwYVdz?=
 =?utf-8?B?a0dlQzNVUUFXSWtMeURzZEpqMVQzTjE5NkplWTlGanMrRmJjcGkyY1dJczNv?=
 =?utf-8?B?bHhwS09wWjJvYWtZYmxVYjAzaDRTbCt0WUhrQTBPQ1FrM2p6Z3g5TU5KTkVp?=
 =?utf-8?B?R0w4TUwwZWhZOWRSeFJ3eUFzUXFGTk9Bb1B4d2pVQzd3UmpJZU9ZdDE5ZThQ?=
 =?utf-8?B?STdQcVhYUzNKaDhmdlBkSENDQ2dwaHdwUzBPbitHakxKa0o3N1FUTGI3Rk8y?=
 =?utf-8?B?bjF5T0JrRHlMSEFyMDNvR3BjTThTa1BRbnJ6WW94QmZPaWxhUnhFUUtiSW4y?=
 =?utf-8?B?dUNPdmc3YXByY2ZsNmFJbVpaTHZGUlV6U09uR1ZqK0l2OVFBUnJoRklDTHdL?=
 =?utf-8?B?MWMwb3A1L0xYWkRRT1BIayt3ZHlodXo3VWU0eSt5bkhOSGYvYW1ySnFmSEF6?=
 =?utf-8?B?cGdHUS9ySDRqWFgraWlsRVdaQ2U1UWRDOU5Pd3piRGZhMFplUnVlVFM1MDV6?=
 =?utf-8?B?WGxZSzE0L0pPT2dHNjQ4RnVzMlhnQnVWcXNTdEt4QkJBTlg1bERBd1UxaTdT?=
 =?utf-8?B?RHkwZUwvRWtDQnd5Y0ZPOEZ0OGxmYXBlMWN2OU9yUXBqR3d2YWdVTGROUjR1?=
 =?utf-8?B?L3F0ZXc4UjQxY0pLWlBjdXh5MHVCSC82THBDdE5uaUV1RklISE54MitKa0tz?=
 =?utf-8?B?VkpaQzk4TzQ3S0UxTVJRczlKSHFQMUcrcG9HNWJ0K01LTE5lQktVM1J3a2lE?=
 =?utf-8?B?dExJaHpZelZaZnFXR29xM0wwNGh0RDQ4T21sd1NLWXRmSzVFdzY2YzVqR3JV?=
 =?utf-8?B?MlE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f45b47c3-c9bf-4836-44e8-08db1902a239
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 20:38:50.6910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1AmuGbDWnpJA/Vk26lGx+Uz8HB7d6FQnDhUYI7eJSdj10PGNbjZv71rRQHx7Uw5q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR15MB5543
X-Proofpoint-GUID: H5gNPRLIgJ-8FxonqNxLOPqupoDEb-Hz
X-Proofpoint-ORIG-GUID: H5gNPRLIgJ-8FxonqNxLOPqupoDEb-Hz
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-27_17,2023-02-27_01,2023-02-09_01
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/1/23 2:24 AM, Lorenzo Bianconi wrote:
> Extend bpf_xdp_query routine in order to get XDP/XSK supported features
> of netdev over route netlink interface.
> Extend libbpf netlink implementation in order to support netlink_generic
> protocol.
> 
> Co-developed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Co-developed-by: Marek Majtyka <alardam@gmail.com>
> Signed-off-by: Marek Majtyka <alardam@gmail.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>   tools/lib/bpf/libbpf.h  |  3 +-
>   tools/lib/bpf/netlink.c | 96 +++++++++++++++++++++++++++++++++++++++++
>   tools/lib/bpf/nlattr.h  | 12 ++++++
>   3 files changed, 110 insertions(+), 1 deletion(-)
> 
[...]
> +
>   int bpf_xdp_query(int ifindex, int xdp_flags, struct bpf_xdp_query_opts *opts)
>   {
>   	struct libbpf_nla_req req = {
> @@ -366,6 +433,10 @@ int bpf_xdp_query(int ifindex, int xdp_flags, struct bpf_xdp_query_opts *opts)
>   		.ifinfo.ifi_family = AF_PACKET,
>   	};
>   	struct xdp_id_md xdp_id = {};
> +	struct xdp_features_md md = {
> +		.ifindex = ifindex,
> +	};
> +	__u16 id;
>   	int err;
>   
>   	if (!OPTS_VALID(opts, bpf_xdp_query_opts))
> @@ -393,6 +464,31 @@ int bpf_xdp_query(int ifindex, int xdp_flags, struct bpf_xdp_query_opts *opts)
>   	OPTS_SET(opts, skb_prog_id, xdp_id.info.skb_prog_id);
>   	OPTS_SET(opts, attach_mode, xdp_id.info.attach_mode);
>   
> +	if (!OPTS_HAS(opts, feature_flags))
> +		return 0;
> +
> +	err = libbpf_netlink_resolve_genl_family_id("netdev", sizeof("netdev"), &id);
> +	if (err < 0)
> +		return libbpf_err(err);

Hi, Lorenzo,

Using latest libbpf repo (https://github.com/libbpf/libbpf, sync'ed from 
source), looks like the above change won't work if the program is 
running on an old kernel, e.g., 5.12 kernel.

In this particular combination, in user space, bpf_xdp_query_opts does
have 'feature_flags' member, so the control can reach
libbpf_netlink_resolve_genl_family_id(). However, the family 'netdev'
is only available in latest kernel (after this patch set). So
the error will return in the above.

This breaks backward compatibility since old working application won't
work any more with a refresh of libbpf.

I could not come up with an easy solution for this. One thing we could
do is to treat 'libbpf_netlink_resolve_genl_family_id()' as a probe, so
return 0 if probe fails.

   err = libbpf_netlink_resolve_genl_family_id("netdev", 
sizeof("netdev"), &id);
   if (err < 0)
	return 0;

Please let me know whether my suggestion makes sense or there could be a
better solution.


> +
> +	memset(&req, 0, sizeof(req));
> +	req.nh.nlmsg_len = NLMSG_LENGTH(GENL_HDRLEN);
> +	req.nh.nlmsg_flags = NLM_F_REQUEST;
> +	req.nh.nlmsg_type = id;
> +	req.gnl.cmd = NETDEV_CMD_DEV_GET;
> +	req.gnl.version = 2;
> +
> +	err = nlattr_add(&req, NETDEV_A_DEV_IFINDEX, &ifindex, sizeof(ifindex));
> +	if (err < 0)
> +		return err;
> +
> +	err = libbpf_netlink_send_recv(&req, NETLINK_GENERIC,
> +				       parse_xdp_features, NULL, &md);
> +	if (err)
> +		return libbpf_err(err);
> +
> +	opts->feature_flags = md.flags;
> +
>   	return 0;
>   }
>   
[...]
