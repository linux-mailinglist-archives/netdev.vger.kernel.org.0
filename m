Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C43FF1093A2
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 19:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfKYSkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 13:40:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47726 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727029AbfKYSku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 13:40:50 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAPIc9La015520;
        Mon, 25 Nov 2019 13:40:45 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wfk3nybx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Nov 2019 13:40:44 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xAPIeJOH018102;
        Mon, 25 Nov 2019 18:40:44 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02wdc.us.ibm.com with ESMTP id 2wevd6ccq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Nov 2019 18:40:44 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAPIehYB52625900
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Nov 2019 18:40:43 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C157112063;
        Mon, 25 Nov 2019 18:40:43 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F8B7112061;
        Mon, 25 Nov 2019 18:40:43 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.80.224.141])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 25 Nov 2019 18:40:43 +0000 (GMT)
Subject: Re: [PATCH net 0/4] ibmvnic: Harden device commands and queries
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, linuxppc-dev@ozlabs.org,
        dnbanerg@us.ibm.com, brking@linux.vnet.ibm.com,
        julietk@linux.vnet.ibm.com
References: <1574451706-19058-1-git-send-email-tlfalcon@linux.ibm.com>
 <20191123174925.30b73917@cakuba.netronome.com>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <52660c98-efd6-16e7-e66d-3528e5b32d3d@linux.ibm.com>
Date:   Mon, 25 Nov 2019 12:40:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191123174925.30b73917@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-25_04:2019-11-21,2019-11-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 phishscore=0 adultscore=0 priorityscore=1501 mlxlogscore=999
 malwarescore=0 lowpriorityscore=0 bulkscore=0 clxscore=1011
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911250151
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/23/19 7:49 PM, Jakub Kicinski wrote:
> On Fri, 22 Nov 2019 13:41:42 -0600, Thomas Falcon wrote:
>> This patch series fixes some shortcomings with the current
>> VNIC device command implementation. The first patch fixes
>> the initialization of driver completion structures used
>> for device commands. Additionally, all waits for device
>> commands are bounded with a timeout in the event that the
>> device does not respond or becomes inoperable. Finally,
>> serialize queries to retain the integrity of device return
>> codes.
> I have minor comments on two patches, but also I think it's
> a little late in the release cycle for putting this in net.
>
> Could you target net-next and repost ASAP so it still makes
> it into 5.5?
>
> Thanks.

Thank you, sorry for the late response.  I will make the requested 
changes ASAP, but I've missed the net-next window.  What should I target 
for v2?

Thanks again,

Tom

