Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555682B8F34
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 10:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgKSJnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 04:43:39 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63792 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725816AbgKSJnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 04:43:39 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ9XOVO046850;
        Thu, 19 Nov 2020 04:43:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : in-reply-to : references : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=DETla2P0bMOshP3ToLQ7nRIRlzdfwifxmy327xXRyrM=;
 b=YVP8tPXJ4ll6p0k9+xgCRKFWEeKh1XYC+b6zj79BU/Ofktda3pMPkSUkgbOWfsTrSYG0
 641DTc7ilnW53HiUWQugSbr+XCYUhV+b1fNyqfghJxe51OU892a2MlD526paWRcLbss3
 yK66A3z6jiVIygvjWLkDyVbOe+CBRXm+1SXJ6J0WRyLG6lva5jroLfCXVlr3qliJlWIO
 W4VikgIGkn5xQv3gSAbaxPikVvRm4pCnVkT44Fou6Qy2vdhtMVeNxl9G7z34sbDtnFds
 6/JVQCKuIhC8mxbb5506EXeH4XPbSsDNHOsqJR5lQ6S1el56XbwsVEp8HbECvryIvOqs FQ== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34wg661hyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 04:43:34 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ9SCWu002859;
        Thu, 19 Nov 2020 09:43:33 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01wdc.us.ibm.com with ESMTP id 34uyn1m02h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 09:43:32 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AJ9hVfB17891634
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 09:43:31 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A24D7C6059;
        Thu, 19 Nov 2020 09:43:31 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C3FEC6057;
        Thu, 19 Nov 2020 09:43:31 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 19 Nov 2020 09:43:31 +0000 (GMT)
MIME-Version: 1.0
Date:   Thu, 19 Nov 2020 03:43:31 -0600
From:   ljp <ljp@linux.vnet.ibm.com>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     kuba@kernel.org, cforno12@linux.ibm.com, netdev@vger.kernel.org,
        ricklind@linux.ibm.com, dnbanerg@us.ibm.com,
        drt@linux.vnet.ibm.com, brking@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        Linuxppc-dev 
        <linuxppc-dev-bounces+ljp=linux.ibm.com@lists.ozlabs.org>
Subject: Re: [PATCH net-next v2 9/9] ibmvnic: Do not replenish RX buffers
 after every polling loop
In-Reply-To: <1605748345-32062-10-git-send-email-tlfalcon@linux.ibm.com>
References: <1605748345-32062-1-git-send-email-tlfalcon@linux.ibm.com>
 <1605748345-32062-10-git-send-email-tlfalcon@linux.ibm.com>
Message-ID: <1a4e7b1ef1fb101cbb26fb9d5867ee46@linux.vnet.ibm.com>
X-Sender: ljp@linux.vnet.ibm.com
User-Agent: Roundcube Webmail/1.0.1
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_05:2020-11-17,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 suspectscore=0 adultscore=0 impostorscore=0 mlxscore=0 mlxlogscore=782
 lowpriorityscore=0 priorityscore=1501 spamscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011190069
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-18 19:12, Thomas Falcon wrote:
> From: "Dwip N. Banerjee" <dnbanerg@us.ibm.com>
> 
> Reduce the amount of time spent replenishing RX buffers by
> only doing so once available buffers has fallen under a certain
> threshold, in this case half of the total number of buffers, or
> if the polling loop exits before the packets processed is less
> than its budget.
> 
> Signed-off-by: Dwip N. Banerjee <dnbanerg@us.ibm.com>
> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index 96df6d8fa277..9fe43ab0496d 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -2537,7 +2537,10 @@ static int ibmvnic_poll(struct napi_struct
> *napi, int budget)
>  		frames_processed++;
>  	}
> 
> -	if (adapter->state != VNIC_CLOSING)
> +	if (adapter->state != VNIC_CLOSING &&
> +	    ((atomic_read(&adapter->rx_pool[scrq_num].available) <
> +	      adapter->req_rx_add_entries_per_subcrq / 2) ||
> +	      frames_processed < budget))

1/2 seems a simple and good algorithm.
Explaining why "frames_process < budget" is necessary in the commit 
message
or source code also helps.


>  		replenish_rx_pool(adapter, &adapter->rx_pool[scrq_num]);
>  	if (frames_processed < budget) {
>  		if (napi_complete_done(napi, frames_processed)) {
