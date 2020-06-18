Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3781FFCEF
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 22:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgFRUv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 16:51:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25866 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728033AbgFRUvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 16:51:55 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05IKYEJv036046;
        Thu, 18 Jun 2020 16:51:51 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31rcbax30k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Jun 2020 16:51:51 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05IKp6kj001087;
        Thu, 18 Jun 2020 20:51:50 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03dal.us.ibm.com with ESMTP id 31q6c649u8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Jun 2020 20:51:50 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05IKpn3W40894828
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Jun 2020 20:51:49 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 938BCAC05E;
        Thu, 18 Jun 2020 20:51:49 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38D69AC05B;
        Thu, 18 Jun 2020 20:51:49 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.31.222])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 18 Jun 2020 20:51:49 +0000 (GMT)
Subject: Re: [PATCH net] ibmveth: Fix max MTU limit
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <1592495026-27202-1-git-send-email-tlfalcon@linux.ibm.com>
 <20200618085722.110f3702@kicinski-fedora-PC1C0HJN>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <ef46e726-5be4-de64-a34c-8a98823a920a@linux.ibm.com>
Date:   Thu, 18 Jun 2020 15:51:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200618085722.110f3702@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_15:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 mlxscore=0
 cotscore=-2147483648 mlxlogscore=999 bulkscore=0 priorityscore=1501
 malwarescore=0 phishscore=0 adultscore=0 clxscore=1011 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/18/20 10:57 AM, Jakub Kicinski wrote:
> On Thu, 18 Jun 2020 10:43:46 -0500 Thomas Falcon wrote:
>> The max MTU limit defined for ibmveth is not accounting for
>> virtual ethernet buffer overhead, which is twenty-two additional
>> bytes set aside for the ethernet header and eight additional bytes
>> of an opaque handle reserved for use by the hypervisor. Update the
>> max MTU to reflect this overhead.
>>
>> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> How about
>
> Fixes: d894be57ca92 ("ethernet: use net core MTU range checking in more drivers")
> Fixes: 110447f8269a ("ethernet: fix min/max MTU typos")
>
> ?

Thanks, do you need me to send a v2 with those tags?

Tom

