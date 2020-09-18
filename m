Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9107627020A
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 18:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgIRQYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 12:24:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60718 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgIRQYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 12:24:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08IGKipY077374;
        Fri, 18 Sep 2020 16:23:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=ysUJ8GsPifQOWpjoAHKKFWtWqPWByaF7A8cQh+uuS+k=;
 b=BnErJDkSbl4OCYXi41UXvZ7oC1+gGWZGRXnNXtPTegtzlRcMAgcHhtU+E3rNAurcD9Ui
 641pYS4YTcbTv0manRVcJ/3emB1/MMdyol+037VGQ6rigrAByRG0kL7MYwaFVQweLSd+
 7IdKiipu5s52BkxkQhZXf+sSRPUTGcqGNkD6iLj1WG6cnPgkZXiX86MkFgNNP1gDnN2G
 MqRqIcscwthRZV4N6/GABePcVvxbxwsd0GZdGCQOZVfHKZvV0NZRS6hxRc2L5YWi3plZ
 ciMjKh8DNdFg0uIPXKit0KhFKLapASVkT/wKW8QhUsKiAEzbc34hXDwZKI2LlqdU3Fk0 HA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33j91e1tmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Sep 2020 16:23:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08IGK5rn115741;
        Fri, 18 Sep 2020 16:23:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33hm373ge5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 16:23:50 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08IGNfNE015188;
        Fri, 18 Sep 2020 16:23:42 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Sep 2020 16:23:41 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH] SUNRPC: Flush dcache only when receiving more seeking
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <20200918125052.2493006-1-zhe.he@windriver.com>
Date:   Fri, 18 Sep 2020 12:23:40 -0400
Cc:     Bruce Fields <bfields@fieldses.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6C34098D-7227-4461-A345-825729E0BDEB@oracle.com>
References: <20200918125052.2493006-1-zhe.he@windriver.com>
To:     zhe.he@windriver.com
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9748 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009180133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9748 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=1 mlxlogscore=999
 clxscore=1011 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 18, 2020, at 8:50 AM, zhe.he@windriver.com wrote:
>=20
> From: He Zhe <zhe.he@windriver.com>
>=20
> commit ca07eda33e01 ("SUNRPC: Refactor svc_recvfrom()") introduces
> svc_flush_bvec to after sock_recvmsg, but sometimes we receive less =
than we
> seek, which triggers the following warning.
>=20
> WARNING: CPU: 0 PID: 18266 at include/linux/bvec.h:101 =
bvec_iter_advance+0x44/0xa8
> Attempted to advance past end of bvec iter
> Modules linked in: sch_fq_codel openvswitch nsh nf_conncount nf_nat
> nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
> CPU: 1 PID: 18266 Comm: nfsd Not tainted 5.9.0-rc5 #1
> Hardware name: Xilinx Zynq Platform
> [<80112ec0>] (unwind_backtrace) from [<8010c3a8>] =
(show_stack+0x18/0x1c)
> [<8010c3a8>] (show_stack) from [<80755214>] (dump_stack+0x9c/0xd0)
> [<80755214>] (dump_stack) from [<80125e64>] (__warn+0xdc/0xf4)
> [<80125e64>] (__warn) from [<80126244>] (warn_slowpath_fmt+0x84/0xac)
> [<80126244>] (warn_slowpath_fmt) from [<80c88514>] =
(bvec_iter_advance+0x44/0xa8)
> [<80c88514>] (bvec_iter_advance) from [<80c88940>] =
(svc_tcp_read_msg+0x10c/0x1bc)
> [<80c88940>] (svc_tcp_read_msg) from [<80c895d4>] =
(svc_tcp_recvfrom+0x98/0x63c)
> [<80c895d4>] (svc_tcp_recvfrom) from [<80c97bf4>] =
(svc_handle_xprt+0x48c/0x4f8)
> [<80c97bf4>] (svc_handle_xprt) from [<80c98038>] (svc_recv+0x94/0x1e0)
> [<80c98038>] (svc_recv) from [<804747cc>] (nfsd+0xf0/0x168)
> [<804747cc>] (nfsd) from [<80148a0c>] (kthread+0x144/0x154)
> [<80148a0c>] (kthread) from [<80100114>] (ret_from_fork+0x14/0x20)
>=20
> Fixes: ca07eda33e01 ("SUNRPC: Refactor svc_recvfrom()")
> Cc: <stable@vger.kernel.org> # 5.8+
> Signed-off-by: He Zhe <zhe.he@windriver.com>
> ---
> net/sunrpc/svcsock.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
> index d5805fa1d066..ea3bc9635448 100644
> --- a/net/sunrpc/svcsock.c
> +++ b/net/sunrpc/svcsock.c
> @@ -277,7 +277,7 @@ static ssize_t svc_tcp_read_msg(struct svc_rqst =
*rqstp, size_t buflen,
> 		buflen -=3D seek;
> 	}
> 	len =3D sock_recvmsg(svsk->sk_sock, &msg, MSG_DONTWAIT);
> -	if (len > 0)
> +	if (len > (seek & PAGE_MASK))

I don't understand how this addresses the WARNING. Can you provide
an example set of inputs that trigger the issue?

Also this change introduces a mixed-sign comparison, so NACK on
this particular patch unless it can be demonstrated that the
implicit type conversion here is benign (I don't think it is,
but I haven't thought through it).


> 		svc_flush_bvec(bvec, len, seek);
>=20
> 	/* If we read a full record, then assume there may be more
> --=20
> 2.17.1
>=20

--
Chuck Lever



