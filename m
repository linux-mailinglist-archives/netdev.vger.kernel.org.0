Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B272E9461
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 12:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbhADLyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 06:54:40 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19236 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725830AbhADLyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 06:54:40 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 104BVHa6054087;
        Mon, 4 Jan 2021 06:53:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4IQnPu2d9QGTflVdDqWTyx4SaeztywUda5hp0W5Dhj4=;
 b=YlNVqI7JULaYMR1Jueb4ylEiGzVYj3G3qRmfFgoGDzL8qiUzcUQ0D415FanSCEWL/wBm
 OzpcY5/Upo0RaPWO3W1AOoEbIU9HgzLnwwjMxDKh8Db7Dqp5lhfSuPrkkh6HfjB7JMW5
 aAwVVPYKz3iXdlYunK6C4C4MI0iS4oPmq3DhK2PHKnwIWKaSkOoAiJSUkStty1addxXi
 SPyG/tiKr+7JJS7rE2oDZ9DmmMCdH+X8uFoI3/VQjlkKQXMo63WeUCvkebei0X+sBSiH
 0zFvIp7TS4Ok/XSMyTXo2dlOUi3My1zeRWHH9VOEXXMJz54Ts8a/SAT+od72EXKkNhJd RA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35v16at1my-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 06:53:53 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 104BlLtn027620;
        Mon, 4 Jan 2021 11:53:52 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 35u3pmh6xa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 11:53:52 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 104BrknC31916382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Jan 2021 11:53:46 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2F124C040;
        Mon,  4 Jan 2021 11:53:49 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F57E4C046;
        Mon,  4 Jan 2021 11:53:49 +0000 (GMT)
Received: from [9.171.91.54] (unknown [9.171.91.54])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 Jan 2021 11:53:49 +0000 (GMT)
Subject: Re: [PATCH net] smc: fix out of bound access in smc_nl_get_sys_info()
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     guvenc@linux.ibm.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+f4708c391121cfc58396@syzkaller.appspotmail.com
References: <20201230004841.1472141-1-kuba@kernel.org>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Message-ID: <4ca9487e-2834-1c45-68eb-a6be8be671d3@linux.ibm.com>
Date:   Mon, 4 Jan 2021 12:53:49 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201230004841.1472141-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-04_07:2021-01-04,2021-01-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 malwarescore=0
 spamscore=0 clxscore=1011 adultscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101040073
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you Jakub,

this patch solves the out of bounds access due to snprintf() copying size bytes first
and overwriting the last byte with null afterwards.
We will include your patch in our next series for the net tree soon.

Reviewed-by: Karsten Graul <kgraul@linux.ibm.com>

On 30/12/2020 01:48, Jakub Kicinski wrote:
> smc_clc_get_hostname() sets the host pointer to a buffer
> which is not NULL-terminated (see smc_clc_init()).
> 
> Reported-by: syzbot+f4708c391121cfc58396@syzkaller.appspotmail.com
> Fixes: 099b990bd11a ("net/smc: Add support for obtaining system information")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/smc/smc_core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 59342b519e34..8d866b4ed8f6 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -246,7 +246,8 @@ int smc_nl_get_sys_info(struct sk_buff *skb, struct netlink_callback *cb)
>  		goto errattr;
>  	smc_clc_get_hostname(&host);
>  	if (host) {
> -		snprintf(hostname, sizeof(hostname), "%s", host);
> +		memcpy(hostname, host, SMC_MAX_HOSTNAME_LEN);
> +		hostname[SMC_MAX_HOSTNAME_LEN] = 0;
>  		if (nla_put_string(skb, SMC_NLA_SYS_LOCAL_HOST, hostname))
>  			goto errattr;
>  	}
> 

-- 
Karsten

(I'm a dude)
