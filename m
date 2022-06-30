Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFE2561A48
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 14:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbiF3MZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 08:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiF3MZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 08:25:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7342AE05
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 05:25:13 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25UCNKjm021329
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 12:25:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pqOo7IEXZuN4o2GJtHjkXskjvWSpvNljjvnukPmdQyc=;
 b=TIMVzqBHrC867hj3kwOpHZUaiQCw0FJ3PZUQSyE8hmmXGQhIWCHCmYZTZHuvySNiPEFz
 k5olNxCtMH+6VV+TB/szIOvLB20CnAvlXvRPqQ8JoTTUvsxzARUpolIk0jhMDtNXcSab
 Dl3GpHTbexZGqi1wbAjmNjWUMRFeeA3NIlgK/vDgzBWq0g+V5K93W+rKfhXhLd90fon6
 O4DlL+NmAMPhz4OdQXvLSemDk+WI7NdgTKg0kskiFZ+Ojz8080ZdtGtKxfE8yMaLBmN6
 OjEhDwJStw8M5v0rE5HvGCbl+2fCjdccHuSzIT/puhiZ8dE6x30EfapkNIHLVJHsF5x+ zg== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1bsn00y3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 12:25:13 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25UCMPge018553
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 12:25:12 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04dal.us.ibm.com with ESMTP id 3gwt0bs76q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 12:25:12 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25UCPARf28180802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 12:25:10 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8022AE062;
        Thu, 30 Jun 2022 12:25:10 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A7A3AE05C;
        Thu, 30 Jun 2022 12:25:10 +0000 (GMT)
Received: from [9.211.107.2] (unknown [9.211.107.2])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 30 Jun 2022 12:25:10 +0000 (GMT)
Message-ID: <6d57e9bf-8a73-ae66-eeea-c1b5d5733cf3@linux.vnet.ibm.com>
Date:   Thu, 30 Jun 2022 07:25:09 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] ibmvnic: Properly dispose of all skbs during a failover.
Content-Language: en-US
To:     Rick Lindsley <ricklind@us.ibm.com>, netdev@vger.kernel.org
Cc:     bjking1@linux.ibm.com, haren@linux.ibm.com, nnac123@linux.ibm.com,
        mmc@linux.ibm.com
References: <20220630000317.2509347-1-ricklind@us.ibm.com>
From:   Brian King <brking@linux.vnet.ibm.com>
In-Reply-To: <20220630000317.2509347-1-ricklind@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3mVWi54c9VdQCY-vNxZETrWt3N6IyDiy
X-Proofpoint-GUID: 3mVWi54c9VdQCY-vNxZETrWt3N6IyDiy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 spamscore=0 impostorscore=0 adultscore=0 mlxlogscore=620
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206300048
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

