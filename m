Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A582B159F
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 06:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgKMFwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 00:52:09 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25746 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725962AbgKMFwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 00:52:09 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AD5UlHQ046687;
        Fri, 13 Nov 2020 00:52:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : in-reply-to : references : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=xNiyn4Y51RJlc4SXv0PuT/5DxJ1bHGgnNYVemUFjePs=;
 b=D4bZQO2F9YWOBEEoXuO/LN9HUVhmxUBbpsgmcxSHeI8EvYD52cizOPXCSV4DG6pGeAst
 YUAeQtPEyAAAmjMBMLk6ScL5lHykiu4r2OgvOOKaA0I6rkZ0mkpLMnbmS4zJG6ET3h2d
 gReKNkV9G9YkwJ4cwiUykUPXh93jUDMLj4fYz5Mwv3SzbTFwOgJCZSJr8xv6RQtKzpI+
 U5LlDzT04F4fObpWH5kRBj2QY9ytXD5KiFrgGBNMO/2sQe8yX6wQD1SJVBY/2KLo3NVu
 cPVkTBq/2ZGTma2v5jTiK1urQy+dvLVzMlTZ4M+3g8LUw8DE0oK65M87Cj4uMZfg2XL6 qw== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34sht1bpsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 00:52:04 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AD5b0kx027864;
        Fri, 13 Nov 2020 05:52:03 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma05wdc.us.ibm.com with ESMTP id 34nk79rfhs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 05:52:03 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AD5q2w98127042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Nov 2020 05:52:02 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37FC7C6057;
        Fri, 13 Nov 2020 05:52:02 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB75FC605A;
        Fri, 13 Nov 2020 05:52:01 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 13 Nov 2020 05:52:01 +0000 (GMT)
MIME-Version: 1.0
Date:   Thu, 12 Nov 2020 21:52:01 -0800
From:   drt <drt@linux.vnet.ibm.com>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, cforno12@linux.ibm.com,
        ljp@linux.vnet.ibm.com, ricklind@linux.ibm.com,
        dnbanerg@us.ibm.com, brking@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        Linuxppc-dev 
        <linuxppc-dev-bounces+drt=linux.vnet.ibm.com@lists.ozlabs.org>
Subject: Re: [PATCH net-next 12/12] ibmvnic: Do not replenish RX buffers after
 every polling loop
In-Reply-To: <1605208207-1896-13-git-send-email-tlfalcon@linux.ibm.com>
References: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
 <1605208207-1896-13-git-send-email-tlfalcon@linux.ibm.com>
Message-ID: <3f9e87689fa954cb9d938d1492039d07@linux.vnet.ibm.com>
X-Sender: drt@linux.vnet.ibm.com
User-Agent: Roundcube Webmail/1.0.1
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_03:2020-11-12,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 priorityscore=1501 phishscore=0 spamscore=0 lowpriorityscore=0
 malwarescore=0 mlxlogscore=845 clxscore=1011 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011130029
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-12 11:10, Thomas Falcon wrote:
> From: "Dwip N. Banerjee" <dnbanerg@us.ibm.com>
> 
> Reduce the amount of time spent replenishing RX buffers by
> only doing so once available buffers has fallen under a certain
> threshold, in this case half of the total number of buffers, or
> if the polling loop exits before the packets processed is less
> than its budget.
> 
> Signed-off-by: Dwip N. Banerjee <dnbanerg@us.ibm.com>

Acked-by: Dany Madden <drt@linux.ibm.com>

> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index 0791dbf1cba8..66f8068bee5a 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -2476,7 +2476,10 @@ static int ibmvnic_poll(struct napi_struct
> *napi, int budget)
>  		frames_processed++;
>  	}
> 
> -	if (adapter->state != VNIC_CLOSING)
> +	if (adapter->state != VNIC_CLOSING &&
> +	    ((atomic_read(&adapter->rx_pool[scrq_num].available) <
> +	      adapter->req_rx_add_entries_per_subcrq / 2) ||
> +	      frames_processed < budget))
>  		replenish_rx_pool(adapter, &adapter->rx_pool[scrq_num]);
>  	if (frames_processed < budget) {
>  		if (napi_complete_done(napi, frames_processed)) {
