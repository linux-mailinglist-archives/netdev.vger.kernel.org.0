Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43A428D952
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 06:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729983AbgJNEeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 00:34:16 -0400
Received: from mail-eopbgr130102.outbound.protection.outlook.com ([40.107.13.102]:39302
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726037AbgJNEeQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 00:34:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fc6slny19Uusap8np4VRVXjXjTghHLXjPYQ6XCBxiTx9DEiwan7WBJLtWT5Fq5zyri92bvsZV/HJYoK58mP0gQwMi0wwCGbQnxK/aa0ktAdOmJod2Yga/88dd6uXO3H9sKq/bvW2TtkRR1byqro9qjZoe6lGOfmRthTWmJdHnK+x94b1ZggNImCTooF2jo/L1qy8jF305lBdXdT9WI0KMVHhkSWIQThlZkfpDQ2hnECYVT036l/zgn0IcRuWM8SeBpc/5KUUeIOBuWMfcbs1moWOZszYEjxA+sGso/5mDjhPm0GkbeadNNnvMuh3t00h95SKR6NSeYIdI9eCp3dbdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hGSJ7YJdvcFwqNoPQZ91sjJlaPq1SQ1mL7mvW1WR/f8=;
 b=WXDW9gb7FkcnPRO67SCDWJspQ/2lmKUn84tkTau1kgx6IJivwmrNthPokJvvNLkRBpdlg/urItP8U46OQBXF6wRtKeGTXrcPLC90Q6zaXm37cfUL+rmUkGNRORCUcyC39NKRY1raZyhtGJF78aHw/dyaNHJ1+1FYYtyY4b7h0knBFWeuzc67XuLjUUCMjwMeBb4b9a1gMZ7kJl992TetLZ1/P87m2M+vBBqW+309epUYXdYnpUWbfg6GcNtVWaw8ZYEoVEP1ohtpn3WW51Eagv06mlv8jcQvwl8R92HR57Mt8yOK+oT3Y8fRyJLKknurJs9Yp1wNng6Poko+Opq3xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hGSJ7YJdvcFwqNoPQZ91sjJlaPq1SQ1mL7mvW1WR/f8=;
 b=EePYeExAlr7Oy0lA7tNcyML8TIBDdtJnlM9LVLCeatw5A+FWsUgjqOvToHyC1Vf+NB30W/IODNHg//rMWT1p29EwWiubpHXMHwI67IboWI5iiLwoXA5Cllpsat/hshkU9CmGLV+HQ7dn/n8K99hYgmOU5BkPtu3ZrK+eaWThIak=
Authentication-Results: fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=none action=none header.from=virtuozzo.com;
Received: from VI1PR0801MB1678.eurprd08.prod.outlook.com
 (2603:10a6:800:51::23) by VI1PR08MB4382.eurprd08.prod.outlook.com
 (2603:10a6:803:f5::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.28; Wed, 14 Oct
 2020 04:34:11 +0000
Received: from VI1PR0801MB1678.eurprd08.prod.outlook.com
 ([fe80::e84c:a74e:9d0f:841a]) by VI1PR0801MB1678.eurprd08.prod.outlook.com
 ([fe80::e84c:a74e:9d0f:841a%8]) with mapi id 15.20.3455.030; Wed, 14 Oct 2020
 04:34:11 +0000
Subject: Re: [PATCH net v2] net: fix pos incrementment in ipv6_route_seq_next
To:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
References: <20201013183121.1988411-1-yhs@fb.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <2fff43db-4a78-fc2d-dff7-66c2445fccaa@virtuozzo.com>
Date:   Wed, 14 Oct 2020 07:34:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201013183121.1988411-1-yhs@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [185.231.240.5]
X-ClientProxiedBy: AM0PR10CA0114.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::31) To VI1PR0801MB1678.eurprd08.prod.outlook.com
 (2603:10a6:800:51::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.24.21] (185.231.240.5) by AM0PR10CA0114.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23 via Frontend Transport; Wed, 14 Oct 2020 04:34:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9dbbbcd-4335-49ae-0d68-08d86ffa658a
X-MS-TrafficTypeDiagnostic: VI1PR08MB4382:
X-Microsoft-Antispam-PRVS: <VI1PR08MB4382BE0C5F33240A87039E8FAA050@VI1PR08MB4382.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:113;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pw4dC42BxVfaOj3A5NdFSIm64DFliSlGWIjMvFysr1DhoGqlFUpHyZzK+epPXrbmea/9Tc/gyD8BP3wF0qnCqgRBbIG1cZxyViEz2wj+qKmDIY7K5Mqy5+D5AiHX1ES5cDFVJIpRhAS+dRl37f8VOVHVDoOUx2eMmYtiL2sCiZXHPDqYbEZYm9RIG/0iY0vpyg0f++eH3MioPfWBFwGoOo8+lwzB7bWJ59WRMNMupCa/o+FJTGNEA8RZtPYH74qxrFe0RZsRmJyy8QIzkGe4A73dtQM/pfPv2gXcdazO3xihDg/A9PqbfLE8VzKlE8z1Wt+2DAwABQeJs4RQunOiGAwqOD4HAjzeyx5JderLz/vKesdeKotvfO/8pA/0hTEIyZymbp85AYO+p1VcL+J8npePGP1xDhcUpJhE9KbyGB3nCZXiSlbcDNklC9Uiz7Ax+wX78XLNyYn/CRqCFf+1Ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0801MB1678.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39840400004)(396003)(136003)(376002)(346002)(186003)(4326008)(8676002)(16576012)(54906003)(26005)(966005)(36756003)(478600001)(83080400001)(52116002)(5660300002)(86362001)(6486002)(31696002)(53546011)(8936002)(66476007)(2616005)(2906002)(16526019)(31686004)(956004)(66946007)(316002)(83380400001)(66556008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: nmCzdlS85webTuvIgVkrkqNgFrsnNmZBKR+XxT9zAIIfWyMJXJYGzCkUfaKaxaHFR3tqII0AFCYJ1JMKnaXZKSau6WBmyi3J5nX1mOh4XjCePuuscHTfXxA5ZlEPRt/rp+soef4PQKlZDJWDhZE4U1z+NIpxmmNN1yOcTr4wlRv7BKXD6HrDsi6aQQ/5vjJB/xbJqMx/yHral+BxI4jm9RVZR558n85qJHIWiZqR6XuRZx1V5fyUKgXzQ1v16fd5xuT+vQxCbIsxbhnQmPvltnCi1GNTMhkJnWDci0jQt/zWougHRsfeZpRmNfA8ZispHtDKSRZG0+p7PrLHa3uiudCWQSKUgQM/xaC39AGToDiNX3f3uRSdyHuMjjxXI4hR4tvld3Ffc9LzhP8VfoLArZMrie3n+Ddl4zH2XLX3zxAGI8iQhc6P8XJoHC9n7Yx5DSCLm8oOXrwpXpRMEqE6s+jtQdAfQeCRSWRaI6ZFM1IA6Kq91zRJGpSwf20yOL+RdtaxqiPoM0Kcp1anWeIdjVWTpqTTolRYmglDgF/APEbGc5Dd+9aWZH9n2FxwVvoZ56FS328Uj66f+Uut5KpfM5CjN3YrSVyM3YWiQ1MH1OdKTt7aVxgk2yHX+CtVnHYS9bBMY6UM6cVXZdQHNl3Lpg==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9dbbbcd-4335-49ae-0d68-08d86ffa658a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0801MB1678.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2020 04:34:11.5765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O2IqrGfqhF+GbFNd9bDJmFeh7qkIYlm0rXmrsskwBwcNtHc8MjBJi2ss0NEKIHYkPSUfBg7jkpbiaNg/L6kw8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB4382
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/20 9:31 PM, Yonghong Song wrote:
> Commit 4fc427e05158 ("ipv6_route_seq_next should increase position index")
> tried to fix the issue where seq_file pos is not increased
> if a NULL element is returned with seq_ops->next(). See bug
>   https://bugzilla.kernel.org/show_bug.cgi?id=206283
> The commit effectively does:
>   - increase pos for all seq_ops->start()
>   - increase pos for all seq_ops->next()
> 
> For ipv6_route, increasing pos for all seq_ops->next() is correct.
> But increasing pos for seq_ops->start() is not correct
> since pos is used to determine how many items to skip during
> seq_ops->start():
>   iter->skip = *pos;
> seq_ops->start() just fetches the *current* pos item.
> The item can be skipped only after seq_ops->show() which essentially
> is the beginning of seq_ops->next().
> 
> For example, I have 7 ipv6 route entries,
>   root@arch-fb-vm1:~/net-next dd if=/proc/net/ipv6_route bs=4096
>   00000000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000400 00000001 00000000 00000001     eth0
>   fe800000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000001 00000000 00000001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>   00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001       lo
>   fe800000000000002050e3fffebd3be8 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
>   ff000000000000000000000000000000 08 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000004 00000000 00000001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>   0+1 records in
>   0+1 records out
>   1050 bytes (1.0 kB, 1.0 KiB) copied, 0.00707908 s, 148 kB/s
>   root@arch-fb-vm1:~/net-next
> 
> In the above, I specify buffer size 4096, so all records can be returned
> to user space with a single trip to the kernel.
> 
> If I use buffer size 128, since each record size is 149, internally
> kernel seq_read() will read 149 into its internal buffer and return the data
> to user space in two read() syscalls. Then user read() syscall will trigger
> next seq_ops->start(). Since the current implementation increased pos even
> for seq_ops->start(), it will skip record #2, #4 and #6, assuming the first
> record is #1.
> 
>   root@arch-fb-vm1:~/net-next dd if=/proc/net/ipv6_route bs=128
>   00000000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000400 00000001 00000000 00000001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>   fe800000000000002050e3fffebd3be8 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
> 4+1 records in
> 4+1 records out
> 600 bytes copied, 0.00127758 s, 470 kB/s
> 
> To fix the problem, create a fake pos pointer so seq_ops->start()
> won't actually increase seq_file pos. With this fix, the
> above `dd` command with `bs=128` will show correct result.
> 
> Fixes: 4fc427e05158 ("ipv6_route_seq_next should increase position index")
> Cc: Vasily Averin <vvs@virtuozzo.com>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Suggested-by: Vasily Averin <vvs@virtuozzo.com>
> Signed-off-by: Yonghong Song <yhs@fb.com>
Reviewed-by: Vasily Averin <vvs@virtuozzo.com>
> ---
>  net/ipv6/ip6_fib.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Changelog:
>  v1 -> v2:
>   - instead of push increment of *pos in ipv6_route_seq_next() for
>     seq_ops->next() only. Add a face pos pointer in seq_ops->start()
>     and use it when calling ipv6_route_seq_next().
> 
> diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
> index 141c0a4c569a..e633b2b7deda 100644
> --- a/net/ipv6/ip6_fib.c
> +++ b/net/ipv6/ip6_fib.c
> @@ -2622,8 +2622,10 @@ static void *ipv6_route_seq_start(struct seq_file *seq, loff_t *pos)
>  	iter->skip = *pos;
>  
>  	if (iter->tbl) {
> +		loff_t p;
> +
>  		ipv6_route_seq_setup_walk(iter, net);
> -		return ipv6_route_seq_next(seq, NULL, pos);
> +		return ipv6_route_seq_next(seq, NULL, &p);
>  	} else {
>  		return NULL;
>  	}
> 
