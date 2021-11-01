Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 180A24420F4
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 20:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhKATiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 15:38:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28556 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229727AbhKATiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 15:38:51 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A1H08gA006473;
        Mon, 1 Nov 2021 19:35:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kXePD+qqqYTgoF8z1fx/eiS4ZCl18A8ptJ5MKVYftE0=;
 b=Nu7mN6fVUx34eNDoJgvHqY1BeAqTq2xGcqudAaeoCvnu5lRzffN8kOOOubclR7UyicEa
 gCRFmBHIXOUCcWvSiDvPwoGxi1U+MFuK8jyWAQh5oRwRAKUuVkRydyzg1A30vw9X0+qV
 9l4dcB0ZvDqt6dbCkkDpb/TtjCe0+O2LxID92w3nYRM3OELYMBg05nRriCnlC9p4nd7G
 Rn0i6MN80T46Gs7Oy5oPG2WUsWefFj3sAxIeAwRouH8TUki0FFDfbC4bkLIwPpKKrwvE
 n+44LkGkUgEOqlbpVw7ouc5WIBIyf5gaE0mAbTvZ2h0eRT7fD1RWJUo6hOBh0o6UdQbF QQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c2ht3pcug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Nov 2021 19:35:50 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A1JVadf005819;
        Mon, 1 Nov 2021 19:35:49 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c2ht3pcta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Nov 2021 19:35:49 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A1JMeXh010962;
        Mon, 1 Nov 2021 19:30:46 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3c0wp9m3hx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Nov 2021 19:30:46 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A1JOP0m63635914
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Nov 2021 19:24:25 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65FD352054;
        Mon,  1 Nov 2021 19:30:44 +0000 (GMT)
Received: from [9.171.58.152] (unknown [9.171.58.152])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3BC9B5204E;
        Mon,  1 Nov 2021 19:30:43 +0000 (GMT)
Message-ID: <d6cd47b1-3b46-fc44-3a8d-b2444af527e6@linux.ibm.com>
Date:   Mon, 1 Nov 2021 20:30:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH -next] bonding: Fix a use-after-free problem when
 bond_sysfs_slave_add() failed
Content-Language: en-US
To:     Huang Guobin <huangguobin4@huawei.com>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1635777273-46028-1-git-send-email-huangguobin4@huawei.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
In-Reply-To: <1635777273-46028-1-git-send-email-huangguobin4@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rwpKu5KL9-f1RaFHV_KnVsb53ENLew8u
X-Proofpoint-GUID: r7mjF3b7DU9HfBwWvSSov86N6XVq2qWN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-01_07,2021-11-01_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111010104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.11.21 15:34, Huang Guobin wrote:
> When I do fuzz test for bonding device interface, I got the following
> use-after-free Calltrace:
> 

[...]

> Fixes: 7afcaec49696 (bonding: use kobject_put instead of _del after kobject_add)
> Signed-off-by: Huang Guobin <huangguobin4@huawei.com>
> ---
>  drivers/net/bonding/bond_sysfs_slave.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_sysfs_slave.c b/drivers/net/bonding/bond_sysfs_slave.c
> index fd07561..d1a5b3f 100644
> --- a/drivers/net/bonding/bond_sysfs_slave.c
> +++ b/drivers/net/bonding/bond_sysfs_slave.c
> @@ -137,18 +137,23 @@ static ssize_t slave_show(struct kobject *kobj,
>  
>  int bond_sysfs_slave_add(struct slave *slave)
>  {
> -	const struct slave_attribute **a;
> +	const struct slave_attribute **a, **b;
>  	int err;
>  
>  	for (a = slave_attrs; *a; ++a) {
>  		err = sysfs_create_file(&slave->kobj, &((*a)->attr));
>  		if (err) {
> -			kobject_put(&slave->kobj);
> -			return err;
> +			goto err_remove_file;
>  		}
>  	}
>  
>  	return 0;
> +
> +err_remove_file:
> +	for (b = slave_attrs; b < a; ++b)
> +		sysfs_remove_file(&slave->kobj, &((*b)->attr));
> +
> +	return err;
>  }
>  

This looks like a candidate for sysfs_create_files(), no?

>  void bond_sysfs_slave_del(struct slave *slave)
> 

