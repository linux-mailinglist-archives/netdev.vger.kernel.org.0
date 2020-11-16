Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299B82B4FFD
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 19:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgKPSlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 13:41:07 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27522 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726494AbgKPSlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 13:41:07 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AGIWO1D017346;
        Mon, 16 Nov 2020 13:41:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5OXbyEHiqeKhGMGqNRwltCAd1jn/ZQLtgK9b3eV1Zm4=;
 b=pW9mHW94bsugmBsm2rOlOx0jyNQl6wSW5yguEJYkseJyDKjFzQTEp2jX9Kj9dHropLEU
 T3dAzbNLKjJAvQf2CgRUHeh8GPP7dTS1c6gWqE6YLIaWMyjpo6Sr6rtR9PmpAt1y8Mwb
 ONHxW+Tk6M2xTT0/M9fAvkj5BCz8PM/UdzubjLx/aPhYjTVeJOvnQYAjv47MtaDU1JYW
 yHQYwUdoo/kmGoNxGy3INoITdq4Zg8vajdd0t/lE+/xfF/iOpo1LT1ynXBJPzIkCQRYt
 0YH9kjT36/X1C9HKTxcPBPAWP90Oz24twbB21TA+uh+LywYSlT+YmZN1EWGPwpWemi+T nw== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34usvfh9pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 13:41:00 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AGIW3nQ015813;
        Mon, 16 Nov 2020 18:40:59 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01wdc.us.ibm.com with ESMTP id 34t6v8rqnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 18:40:59 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AGIewJ75308954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Nov 2020 18:40:59 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE497B205F;
        Mon, 16 Nov 2020 18:40:58 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D191B2066;
        Mon, 16 Nov 2020 18:40:58 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.39.145])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 16 Nov 2020 18:40:57 +0000 (GMT)
Subject: Re: [PATCH net-next 04/12] ibmvnic: Introduce xmit_more support using
 batched subCRQ hcalls
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dnbanerg@us.ibm.com, brking@linux.vnet.ibm.com, pradeep@us.ibm.com,
        drt@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        ljp@linux.vnet.ibm.com, cforno12@linux.ibm.com,
        ricklind@linux.ibm.com
References: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
 <1605208207-1896-5-git-send-email-tlfalcon@linux.ibm.com>
 <20201114154632.55e87b1c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <68899039-c1d7-0b2a-430b-03dfa51a9a49@linux.ibm.com>
Date:   Mon, 16 Nov 2020 12:40:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201114154632.55e87b1c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_09:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 phishscore=0 mlxlogscore=915 lowpriorityscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011160106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/14/20 5:46 PM, Jakub Kicinski wrote:
> On Thu, 12 Nov 2020 13:09:59 -0600 Thomas Falcon wrote:
>> Include support for the xmit_more feature utilizing the
>> H_SEND_SUB_CRQ_INDIRECT hypervisor call which allows the sending
>> of multiple subordinate Command Response Queue descriptors in one
>> hypervisor call via a DMA-mapped buffer. This update reduces hypervisor
>> calls and thus hypervisor call overhead per TX descriptor.
>>
>> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> The common bug with xmit_more is not flushing the already queued
> notifications when there is a drop. Any time you drop a skb you need
> to check it's not an skb that was the end of an xmit_more train and
> if so flush notifications (or just always flush on error).
>
> Looking at the driver e.g. this starting goto:
>
>          if (ibmvnic_xmit_workarounds(skb, netdev)) {
>                  tx_dropped++;
>                  tx_send_failed++;
>                  ret = NETDEV_TX_OK;
>                  goto out;
>          }
>
> Does not seem to hit any flush on its way out AFAICS.

Hi, I included those updates in a later patch to ease review but see now 
that that was a mistake. I will merge those bits back into this patch 
and resubmit.

Thanks!

