Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4018A442909
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 09:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhKBICc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 04:02:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27422 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230353AbhKBICX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 04:02:23 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A265OI4031734;
        Tue, 2 Nov 2021 07:59:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=OF+anmzgpqz6my5ltu5jjDFekadtOeguseVlb1jtWkk=;
 b=DsSCNn3dw9QQ+IagiLffTGee4cdzuOhald5KoLRw+tbdxlaK/DGalBs4XSO9SN7+aZGJ
 9jDERxfbFvAkE1cp08rswcuMSRGEOGCg/35oIkZo24lH5xmn9m5+3K5LAXz5blOJeGmH
 4OGLuciMFqh240iSPvEHMVpnpBm+rj/26U2TfkKQrPBJ37/wno2sEz1Y0CKPOQ2EN2Vc
 ZjWrCv2m22r+EfVUelyYY89shRKj2ebiOvttMKhjdEjTUpw4d711aTNfaTLMFOWcIxsp
 vJCEPR+0DSgtTO1punQqgFOzwTGYT4hGLGMZU5GrO+WXm9L/KDv9WNYxlS+NYLH1xMjD oA== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c2rd02165-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 07:59:46 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A27viec003343;
        Tue, 2 Nov 2021 07:59:43 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3c0wp9qkey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 07:59:43 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A27rKGh64356760
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Nov 2021 07:53:20 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C653AE055;
        Tue,  2 Nov 2021 07:59:41 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81B66AE056;
        Tue,  2 Nov 2021 07:59:40 +0000 (GMT)
Received: from [9.171.61.66] (unknown [9.171.61.66])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Nov 2021 07:59:40 +0000 (GMT)
Message-ID: <d3454aa3-a502-d02d-be4e-e6393eed026b@linux.ibm.com>
Date:   Tue, 2 Nov 2021 08:59:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH -next] bonding: Fix a use-after-free problem when
 bond_sysfs_slave_add() failed
Content-Language: en-US
To:     huangguobin <huangguobin4@huawei.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1635777273-46028-1-git-send-email-huangguobin4@huawei.com>
 <d6cd47b1-3b46-fc44-3a8d-b2444af527e6@linux.ibm.com>
 <5c02fbac130941a1a8578965975116b5@huawei.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
In-Reply-To: <5c02fbac130941a1a8578965975116b5@huawei.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _U_-_Okz7Q1wGGehoI3fMKmNsFL8S3Bn
X-Proofpoint-GUID: _U_-_Okz7Q1wGGehoI3fMKmNsFL8S3Bn
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-02_06,2021-11-01_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 adultscore=0 suspectscore=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111020044
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.11.21 03:55, huangguobin wrote:
> I think bond_sysfs_slave_del should not be used in the error handling process, because bond_sysfs_slave_del will traverse all slave_attrs and release them. When sysfs_create_file fails, only some attributes may be created successfully.

[please don't top-post]

The suggestion was to use sysfs_create_files(), which would handle such rollback
internally. There was no mention of using bond_sysfs_slave_del().

ie. something like the following (untested):

diff --git a/drivers/net/bonding/bond_sysfs_slave.c b/drivers/net/bonding/bond_sysfs_slave.c
index fd07561da034..a1fd4bc0b0d2 100644
--- a/drivers/net/bonding/bond_sysfs_slave.c
+++ b/drivers/net/bonding/bond_sysfs_slave.c
@@ -108,15 +108,15 @@ static ssize_t ad_partner_oper_port_state_show(struct slave *slave, char *buf)
 }
 static SLAVE_ATTR_RO(ad_partner_oper_port_state);
 
-static const struct slave_attribute *slave_attrs[] = {
-       &slave_attr_state,
-       &slave_attr_mii_status,
-       &slave_attr_link_failure_count,
-       &slave_attr_perm_hwaddr,
-       &slave_attr_queue_id,
-       &slave_attr_ad_aggregator_id,
-       &slave_attr_ad_actor_oper_port_state,
-       &slave_attr_ad_partner_oper_port_state,
+static const struct attribute *slave_attrs[] = {
+       &slave_attr_state.attr,
+       &slave_attr_mii_status.attr,
+       &slave_attr_link_failure_count.attr,
+       &slave_attr_perm_hwaddr.attr,
+       &slave_attr_queue_id.attr,
+       &slave_attr_ad_aggregator_id.attr,
+       &slave_attr_ad_actor_oper_port_state.attr,
+       &slave_attr_ad_partner_oper_port_state.attr,
        NULL
 };
 
@@ -137,24 +137,16 @@ const struct sysfs_ops slave_sysfs_ops = {
 
 int bond_sysfs_slave_add(struct slave *slave)
 {
-       const struct slave_attribute **a;
        int err;
 
-       for (a = slave_attrs; *a; ++a) {
-               err = sysfs_create_file(&slave->kobj, &((*a)->attr));
-               if (err) {
-                       kobject_put(&slave->kobj);
-                       return err;
-               }
-       }
+       err = sysfs_create_files(&slave->kobj, slave_attrs);
+       if (err)
+               kobject_put(&slave->kobj);
 
-       return 0;
+       return err;
 }
 
 void bond_sysfs_slave_del(struct slave *slave)
 {
-       const struct slave_attribute **a;
-
-       for (a = slave_attrs; *a; ++a)
-               sysfs_remove_file(&slave->kobj, &((*a)->attr));
+       sysfs_remove_files(&slave->kobj, slave_attrs);
 }


> -----Original Message-----
> From: Julian Wiedmann [mailto:jwi@linux.ibm.com] 
> Sent: Tuesday, November 2, 2021 3:31 AM
> To: huangguobin <huangguobin4@huawei.com>; j.vosburgh@gmail.com; vfalico@gmail.com; andy@greyhouse.net; davem@davemloft.net; kuba@kernel.org
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH -next] bonding: Fix a use-after-free problem when bond_sysfs_slave_add() failed
> 
> On 01.11.21 15:34, Huang Guobin wrote:
>> When I do fuzz test for bonding device interface, I got the following 
>> use-after-free Calltrace:
>>
> 
> [...]
> 
>> Fixes: 7afcaec49696 (bonding: use kobject_put instead of _del after 
>> kobject_add)
>> Signed-off-by: Huang Guobin <huangguobin4@huawei.com>
>> ---
>>  drivers/net/bonding/bond_sysfs_slave.c | 11 ++++++++---
>>  1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/bonding/bond_sysfs_slave.c 
>> b/drivers/net/bonding/bond_sysfs_slave.c
>> index fd07561..d1a5b3f 100644
>> --- a/drivers/net/bonding/bond_sysfs_slave.c
>> +++ b/drivers/net/bonding/bond_sysfs_slave.c
>> @@ -137,18 +137,23 @@ static ssize_t slave_show(struct kobject *kobj,
>>  
>>  int bond_sysfs_slave_add(struct slave *slave)  {
>> -	const struct slave_attribute **a;
>> +	const struct slave_attribute **a, **b;
>>  	int err;
>>  
>>  	for (a = slave_attrs; *a; ++a) {
>>  		err = sysfs_create_file(&slave->kobj, &((*a)->attr));
>>  		if (err) {
>> -			kobject_put(&slave->kobj);
>> -			return err;
>> +			goto err_remove_file;
>>  		}
>>  	}
>>  
>>  	return 0;
>> +
>> +err_remove_file:
>> +	for (b = slave_attrs; b < a; ++b)
>> +		sysfs_remove_file(&slave->kobj, &((*b)->attr));
>> +
>> +	return err;
>>  }
>>  
> 
> This looks like a candidate for sysfs_create_files(), no?
> 
>>  void bond_sysfs_slave_del(struct slave *slave)
>>
> 

