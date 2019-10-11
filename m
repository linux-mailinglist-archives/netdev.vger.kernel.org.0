Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46C8CD47E4
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 20:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbfJKSsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 14:48:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52472 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728835AbfJKSsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 14:48:32 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9BIlbs9123924;
        Fri, 11 Oct 2019 14:48:05 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vjy14rkb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Oct 2019 14:48:05 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x9BIjgA4021935;
        Fri, 11 Oct 2019 18:48:04 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04wdc.us.ibm.com with ESMTP id 2vejt7wssw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Oct 2019 18:48:04 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9BIm4FH14681040
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Oct 2019 18:48:04 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1979AE060;
        Fri, 11 Oct 2019 18:48:03 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FC6CAE063;
        Fri, 11 Oct 2019 18:48:03 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.85.168.232])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 11 Oct 2019 18:48:03 +0000 (GMT)
Subject: Re: [PATCH] net/ibmvnic: Fix EOI when running in XIVE mode.
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Juliet Kim <julietk@linux.vnet.ibm.com>
Cc:     John Allen <jallen@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20191011055254.8347-1-clg@kaod.org>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <755ed199-0579-2b59-f033-91ac9582a233@linux.ibm.com>
Date:   Fri, 11 Oct 2019 13:48:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191011055254.8347-1-clg@kaod.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-11_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=993 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910110158
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/19 12:52 AM, Cédric Le Goater wrote:
> pSeries machines on POWER9 processors can run with the XICS (legacy)
> interrupt mode or with the XIVE exploitation interrupt mode. These
> interrupt contollers have different interfaces for interrupt
> management : XICS uses hcalls and XIVE loads and stores on a page.
> H_EOI being a XICS interface the enable_scrq_irq() routine can fail
> when the machine runs in XIVE mode.
>
> Fix that by calling the EOI handler of the interrupt chip.
>
> Fixes: f23e0643cd0b ("ibmvnic: Clear pending interrupt after device reset")
> Signed-off-by: Cédric Le Goater <clg@kaod.org>
> ---

Thank you for this fix, Cedric!

Tom

>   drivers/net/ethernet/ibm/ibmvnic.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index 2b073a3c0b84..f59d9a8e35e2 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -2878,12 +2878,10 @@ static int enable_scrq_irq(struct ibmvnic_adapter *adapter,
>   
>   	if (test_bit(0, &adapter->resetting) &&
>   	    adapter->reset_reason == VNIC_RESET_MOBILITY) {
> -		u64 val = (0xff000000) | scrq->hw_irq;
> +		struct irq_desc *desc = irq_to_desc(scrq->irq);
> +		struct irq_chip *chip = irq_desc_get_chip(desc);
>   
> -		rc = plpar_hcall_norets(H_EOI, val);
> -		if (rc)
> -			dev_err(dev, "H_EOI FAILED irq 0x%llx. rc=%ld\n",
> -				val, rc);
> +		chip->irq_eoi(&desc->irq_data);
>   	}
>   
>   	rc = plpar_hcall_norets(H_VIOCTL, adapter->vdev->unit_address,
