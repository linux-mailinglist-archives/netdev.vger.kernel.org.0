Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26712B4F7E
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 19:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388531AbgKPSaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 13:30:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26206 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388277AbgKPS2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 13:28:14 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AGI2CAq068906;
        Mon, 16 Nov 2020 13:28:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=IORfG6nVIcp215PlTtjwf3IOLYlfXOtfUm+UvjkoU1M=;
 b=AAhvgPTU4rKwFRvSNq9R27mnFskaS34DTY9gV0L2aH708HCutVVGsXYK7hTzDqbwFERC
 i4d/W6rwH2Y2yGBmz75p7dsOlrowjndzrHJCGCYv4TZwS31hbiE395s4AKwiTgt/A+w2
 J1yeohQk9OwRfodPkkc0GBxq1CdnJqOlwN51op+dAeiLq7X5jwj2h+IP6q90RyQfRxwg
 4WPEF0FJ1NICn49Fyuo7kxO7wHwMuJtDl/WBTH+PM74skkkc3giSqaR7/wqINYO+u4Rw
 upL73chUAp6tYjVT6Xe7nGgM5AvzIsmC0K1DhiMtqVRvvOJc5UvPav5Xvv11t6ihg3dI 6Q== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34uv23w1by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 13:28:10 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AGIS8bK010062;
        Mon, 16 Nov 2020 18:28:08 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02dal.us.ibm.com with ESMTP id 34t6v94y0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 18:28:08 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AGIS6mI8323594
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Nov 2020 18:28:06 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A0B5B2066;
        Mon, 16 Nov 2020 18:28:06 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1425B205F;
        Mon, 16 Nov 2020 18:28:05 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.39.145])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 16 Nov 2020 18:28:05 +0000 (GMT)
Subject: Re: [PATCH net-next 01/12] ibmvnic: Ensure that subCRQ entry reads
 are ordered
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dnbanerg@us.ibm.com, brking@linux.vnet.ibm.com, pradeep@us.ibm.com,
        drt@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        ljp@linux.vnet.ibm.com, cforno12@linux.ibm.com,
        ricklind@linux.ibm.com
References: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
 <1605208207-1896-2-git-send-email-tlfalcon@linux.ibm.com>
 <20201114153524.1a32241f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <b0cd74bb-8f05-a201-080c-e325ae4a27b2@linux.ibm.com>
Date:   Mon, 16 Nov 2020 12:28:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201114153524.1a32241f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_09:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 phishscore=0 clxscore=1015 adultscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011160102
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/14/20 5:35 PM, Jakub Kicinski wrote:
> On Thu, 12 Nov 2020 13:09:56 -0600 Thomas Falcon wrote:
>> Ensure that received Subordinate Command-Response Queue
>> entries are properly read in order by the driver.
>>
>> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> Are you sure this is not a bug fix?
Yes, I guess it does look like a bug fix. I can omit this in v2 and 
submit this as a stand-alone patch to net?
