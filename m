Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7B5270E17
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 15:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgISNPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 09:15:31 -0400
Received: from mail-dm6nam12on2041.outbound.protection.outlook.com ([40.107.243.41]:29792
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726388AbgISNPb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 09:15:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GYWUzKT7Sfjo14ZEZVcHPJh0gxhZBoysWFjCkAHvUNjSLErEGxSPcSr4GoRPF8comLQvgaQB/REpJCkNTVElKZIpBH/ihfdVBGQaY+TMpYmtf9fpK8m1BflzLfR6jLd1+4Aywn/4aI/mC+Ub75ibaU1gLnV3IgHMBa/RfVPQsZ7FjNhYQsPfS+aNTSHPSt4Dl/syaNmOvRjvGHEwqK4FvS/PtIwKzi8q3H2Mebvye8qniwhCgdpebitNurRPTrL9NROXnNkb+eKmTO/l11xVhoVAh+x7mxIvxyZ5TuzCxBbVzXT5BVkqBp7wD++AjxSE2ExtzjUdIP0Gr+dGr1ue3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2SmWhvI7BfmA5UkOixVDInCF8GGhhYgVGIIOyTFoM88=;
 b=S/CsnUJuHCbbksYiypPz8r6DIzdanoSmCRsE+gxfAphgFyU0uPh1ch+tkEQxLGa+FiB65dLWypM2IXv0trf10WhACO77+HlghQVyJ0tX9i7iAPlr/ObVgNj7SSqHZadMebjeUBI9AaJVeHOGekLkLEJxGWglmOJ99dBrgAm80jQg0UaJVwR9qRM4eyMRDxV1i/Qv+u69jK0pkVw1Fhl+B6Shh9kO/Bt0MHa885RrQgq9PLsMXaDFW3J7xifXcZhLqiAZp/0mVuq2p24+ra4QhJ5p6i1NW4xNbcPY8ber90JkrrV8cfUGlSdPvZ3zGC74zJMas0P/oLgh5RmNtJ6ZSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2SmWhvI7BfmA5UkOixVDInCF8GGhhYgVGIIOyTFoM88=;
 b=lMkuBuYd6ZgjxiFFJ+tRnwHWP2mOmueE/bsc+d5MXKqjjiEquExiD8dEF1zfHBOwu4WiD0r2FmMsVLjM13xUQoAyy+HRiwlloMB0cJSq7WFUl8q3hDEtsn6QYMjT/pL85eBo+f+MaEzVxlvQXkVxM+E4zlhMcbGElx3Soa8tlUE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from SN6PR11MB3360.namprd11.prod.outlook.com (2603:10b6:805:c8::30)
 by SN6PR11MB2815.namprd11.prod.outlook.com (2603:10b6:805:62::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Sat, 19 Sep
 2020 13:15:27 +0000
Received: from SN6PR11MB3360.namprd11.prod.outlook.com
 ([fe80::4dbe:2ab5:9b68:a966]) by SN6PR11MB3360.namprd11.prod.outlook.com
 ([fe80::4dbe:2ab5:9b68:a966%7]) with mapi id 15.20.3391.015; Sat, 19 Sep 2020
 13:15:27 +0000
Subject: Re: [PATCH] SUNRPC: Flush dcache only when receiving more seeking
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     Bruce Fields <bfields@fieldses.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <20200918125052.2493006-1-zhe.he@windriver.com>
 <6C34098D-7227-4461-A345-825729E0BDEB@oracle.com>
From:   He Zhe <zhe.he@windriver.com>
Message-ID: <7ee57ab3-80e1-5fab-9885-a6fb191b0b04@windriver.com>
Date:   Sat, 19 Sep 2020 21:15:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <6C34098D-7227-4461-A345-825729E0BDEB@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: YT1PR01CA0088.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::27) To SN6PR11MB3360.namprd11.prod.outlook.com
 (2603:10b6:805:c8::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.175] (60.247.85.82) by YT1PR01CA0088.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2d::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Sat, 19 Sep 2020 13:15:22 +0000
X-Originating-IP: [60.247.85.82]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b41b987e-d25d-4a88-86fa-08d85c9e1243
X-MS-TrafficTypeDiagnostic: SN6PR11MB2815:
X-Microsoft-Antispam-PRVS: <SN6PR11MB28159A203DB301D78FA9A2388F3C0@SN6PR11MB2815.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ZLwxOToMgy/g27CeWoAog9S84ov3iFVpFkoj3HLYAmRnXqNEigG7ieomjVSJphM0aNlXdETNEpyCdb7XQL2jLFeD0b/st/P6PtSXtrdjHvsLumDMUy//MIm+bbDiSKLCMqK/PdLDFSZ3RSzUXSNyzhuG6ZIro//uF4ByQFFskOtyD/63HwxD/aQkJvIjElFLKSit3m9gEThVSKQXSiqvptd037KKEGw2ghU8bb77hxSfSB6dt6hL6IGe6RTtnYo3TJr6MbWJ0Lx5U8DXMWoPp9bj8MA8yNPnYCoUVMHX/x8e9jWeUmI7ooaG8pQtwvCNmn8dJLoeM8P9NLuGbL/LVWolMWp26vHyOtWfDFEKJf5F34KAGZBvRvbF1+CmqBTeXYnwHmGVsxonqQECbVBlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3360.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(396003)(39850400004)(366004)(26005)(186003)(16526019)(478600001)(956004)(53546011)(45080400002)(16576012)(52116002)(5660300002)(6666004)(31686004)(6916009)(2616005)(31696002)(36756003)(316002)(6706004)(86362001)(6486002)(83380400001)(4326008)(2906002)(8936002)(54906003)(8676002)(66476007)(66556008)(66946007)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: eUsV+TSrK3SEgF7K5zgyRhBiJGLZhbju88RKfdo751W58L83fYOlsdbrHvQEL31h/HLXzlvHF1/sV+sIaZqBqLnUt0gvjLu/8NrkTa/sJpNfpePSXZbrM+YpFmGMqEAwRlOYp6BKTTwoutgLoGYPgsHX7JrnyUDaQzFTTjLbeHWIkz+iXOwb+dKb+JmqiX7ju+xu4tPrPAleYuWP8Ps3KrC+fUMRwhMQF8+rOzKKuHk75Dn6aTmGwkRHMP6JpcEu60ZHUNpKCGXd9cMHJ1UnwebJLBeglMJ4ar+KA1RwkvIxQixxrrexEzTpFWEDQoMTPyyjl0YbXyF6ibz4dgA7FL605Lxat5upodciivUIQ38q6z7buo7nvBQ69cNmIV9Me1rmSV7SC8LcEH5LWRTVNanVX/ljEzJlrMhv7lywDbxQA+D04qBMKkwSiR48BjKab9+BuBJHudGea8cZP6KhOA/WA8zAkHtpKvx0hRHAwHUncGoA5L4Jji/MyGuCqWV8sUizQiw7VoBufxy+XoQ97FlEY7kai5m5tFQ9JDj9rGZaIddx/Hz2PKDlu/7cPzKgcgFrbUOFk2uBH0AtTYX5wp7Mb26/Rus32e20QeOomvn5r8w/cDxPeK0ZOdXZcJT+T2zLjYKNxS1ky/iifOG6VQ==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b41b987e-d25d-4a88-86fa-08d85c9e1243
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3360.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2020 13:15:27.2638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vaUkt2oqbKnfn7BPowH7QzQ+CiEp48QGRz2173i+FH/hL3wca8PYD7zct/sJ0OVcUZ8ygTpyTyVJXZbvlgkrPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2815
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/19/20 12:23 AM, Chuck Lever wrote:
>
>> On Sep 18, 2020, at 8:50 AM, zhe.he@windriver.com wrote:
>>
>> From: He Zhe <zhe.he@windriver.com>
>>
>> commit ca07eda33e01 ("SUNRPC: Refactor svc_recvfrom()") introduces
>> svc_flush_bvec to after sock_recvmsg, but sometimes we receive less than we
>> seek, which triggers the following warning.
>>
>> WARNING: CPU: 0 PID: 18266 at include/linux/bvec.h:101 bvec_iter_advance+0x44/0xa8
>> Attempted to advance past end of bvec iter
>> Modules linked in: sch_fq_codel openvswitch nsh nf_conncount nf_nat
>> nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
>> CPU: 1 PID: 18266 Comm: nfsd Not tainted 5.9.0-rc5 #1
>> Hardware name: Xilinx Zynq Platform
>> [<80112ec0>] (unwind_backtrace) from [<8010c3a8>] (show_stack+0x18/0x1c)
>> [<8010c3a8>] (show_stack) from [<80755214>] (dump_stack+0x9c/0xd0)
>> [<80755214>] (dump_stack) from [<80125e64>] (__warn+0xdc/0xf4)
>> [<80125e64>] (__warn) from [<80126244>] (warn_slowpath_fmt+0x84/0xac)
>> [<80126244>] (warn_slowpath_fmt) from [<80c88514>] (bvec_iter_advance+0x44/0xa8)
>> [<80c88514>] (bvec_iter_advance) from [<80c88940>] (svc_tcp_read_msg+0x10c/0x1bc)
>> [<80c88940>] (svc_tcp_read_msg) from [<80c895d4>] (svc_tcp_recvfrom+0x98/0x63c)
>> [<80c895d4>] (svc_tcp_recvfrom) from [<80c97bf4>] (svc_handle_xprt+0x48c/0x4f8)
>> [<80c97bf4>] (svc_handle_xprt) from [<80c98038>] (svc_recv+0x94/0x1e0)
>> [<80c98038>] (svc_recv) from [<804747cc>] (nfsd+0xf0/0x168)
>> [<804747cc>] (nfsd) from [<80148a0c>] (kthread+0x144/0x154)
>> [<80148a0c>] (kthread) from [<80100114>] (ret_from_fork+0x14/0x20)
>>
>> Fixes: ca07eda33e01 ("SUNRPC: Refactor svc_recvfrom()")
>> Cc: <stable@vger.kernel.org> # 5.8+
>> Signed-off-by: He Zhe <zhe.he@windriver.com>
>> ---
>> net/sunrpc/svcsock.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
>> index d5805fa1d066..ea3bc9635448 100644
>> --- a/net/sunrpc/svcsock.c
>> +++ b/net/sunrpc/svcsock.c
>> @@ -277,7 +277,7 @@ static ssize_t svc_tcp_read_msg(struct svc_rqst *rqstp, size_t buflen,
>> 		buflen -= seek;
>> 	}
>> 	len = sock_recvmsg(svsk->sk_sock, &msg, MSG_DONTWAIT);
>> -	if (len > 0)
>> +	if (len > (seek & PAGE_MASK))
> I don't understand how this addresses the WARNING. Can you provide
> an example set of inputs that trigger the issue?

I was trying to meet the not warning condition in bvec_iter_advance to make
the flushing meaningful.

svc_flush_bvec
    bvec_iter_advance
        WARN_ONCE(bytes > iter->bi_size,...

Here are my steps:
mkdir /root/mount_point/
mount /dev/sda1 /root/mount_point/
systemctl restart nfs-server
exportfs
mount -vvv -t nfs 127.0.0.1:/root/mount_point/ /mnt
cp /bin/bash ./bash.tmp

>
> Also this change introduces a mixed-sign comparison, so NACK on
> this particular patch unless it can be demonstrated that the
> implicit type conversion here is benign (I don't think it is,
> but I haven't thought through it).

Thanks, I didn't notice the different types. What about this?
if (len > 0 && (size_t)len > (seek & PAGE_MASK))


Zhe

>
>
>> 		svc_flush_bvec(bvec, len, seek);
>>
>> 	/* If we read a full record, then assume there may be more
>> -- 
>> 2.17.1
>>
> --
> Chuck Lever
>
>
>

