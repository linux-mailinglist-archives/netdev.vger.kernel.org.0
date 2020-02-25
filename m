Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57F6C16E9D0
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 16:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731015AbgBYPRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 10:17:18 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37090 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730616AbgBYPRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 10:17:18 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01PF9BEY101811
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 10:17:17 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb1b8qgvt-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 10:17:15 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Tue, 25 Feb 2020 15:17:13 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 25 Feb 2020 15:17:10 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01PFH9eq43712732
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 15:17:09 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21E815207E;
        Tue, 25 Feb 2020 15:17:09 +0000 (GMT)
Received: from [9.152.222.57] (unknown [9.152.222.57])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id ED6B95206B;
        Tue, 25 Feb 2020 15:17:08 +0000 (GMT)
Subject: Re: [PATCH net-next 1/2] net/smc: rework peer ID handling
To:     Hans Wippel <ndev@hwipl.net>, ubraun@linux.ibm.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20200224235901.304311-1-ndev@hwipl.net>
 <20200224235901.304311-2-ndev@hwipl.net>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Date:   Tue, 25 Feb 2020 16:17:08 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200224235901.304311-2-ndev@hwipl.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20022515-0028-0000-0000-000003DDE065
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022515-0029-0000-0000-000024A2F95B
Message-Id: <35171bea-1940-ef31-4266-3f421cac6225@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-25_05:2020-02-21,2020-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 adultscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250119
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/02/2020 00:59, Hans Wippel wrote:
> This patch initializes the peer ID to a random instance ID and a zero
> MAC address. If a RoCE device is in the host, the MAC address part of
> the peer ID is overwritten with the respective address. Also, a function
> for checking if the peer ID is valid is added. A peer ID is considered
> valid if the MAC address part contains a non-zero MAC address.
> 
> Signed-off-by: Hans Wippel <ndev@hwipl.net>
> ---
>  net/smc/smc_ib.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
> index 6756bd5a3fe4..3444de27fecd 100644
> --- a/net/smc/smc_ib.c
> +++ b/net/smc/smc_ib.c
> @@ -37,11 +37,7 @@ struct smc_ib_devices smc_ib_devices = {	/* smc-registered ib devices */
>  	.list = LIST_HEAD_INIT(smc_ib_devices.list),
>  };
>  
> -#define SMC_LOCAL_SYSTEMID_RESET	"%%%%%%%"
> -
> -u8 local_systemid[SMC_SYSTEMID_LEN] = SMC_LOCAL_SYSTEMID_RESET;	/* unique system
> -								 * identifier
> -								 */
> +u8 local_systemid[SMC_SYSTEMID_LEN];		/* unique system identifier */
>  
>  static int smc_ib_modify_qp_init(struct smc_link *lnk)
>  {
> @@ -168,6 +164,15 @@ static inline void smc_ib_define_local_systemid(struct smc_ib_device *smcibdev,
>  {
>  	memcpy(&local_systemid[2], &smcibdev->mac[ibport - 1],
>  	       sizeof(smcibdev->mac[ibport - 1]));
> +}
> +
> +bool smc_ib_is_valid_local_systemid(void)

You introduce a non-static but its used only from this module.

> +{
> +	return !is_zero_ether_addr(&local_systemid[2]);
> +}
> +
> +static void smc_ib_init_local_systemid(void)
> +{
>  	get_random_bytes(&local_systemid[0], 2);
>  }
>  
> @@ -224,8 +229,7 @@ static int smc_ib_remember_port_attr(struct smc_ib_device *smcibdev, u8 ibport)
>  	rc = smc_ib_fill_mac(smcibdev, ibport);
>  	if (rc)
>  		goto out;
> -	if (!strncmp(local_systemid, SMC_LOCAL_SYSTEMID_RESET,
> -		     sizeof(local_systemid)) &&
> +	if (!smc_ib_is_valid_local_systemid() &&
>  	    smc_ib_port_active(smcibdev, ibport))
>  		/* create unique system identifier */
>  		smc_ib_define_local_systemid(smcibdev, ibport);
> @@ -605,6 +609,7 @@ static struct ib_client smc_ib_client = {
>  
>  int __init smc_ib_register_client(void)
>  {
> +	smc_ib_init_local_systemid();
>  	return ib_register_client(&smc_ib_client);
>  }
>  
> 

-- 
Karsten

(I'm a dude)

