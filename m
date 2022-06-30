Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC52561F6F
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 17:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbiF3Pft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 11:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235361AbiF3Pfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 11:35:36 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B854441610
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 08:35:34 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25UEwSIN012320
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 15:35:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NJ9niJTvFAV9zzPWGmns0V0h7BQz1sCAqnfcnWVy4tA=;
 b=WO44x5+CrL+x3tSZjzbLzEFfQrXnHhYimm5nETH8RtTFOuE8IHv79Cz+BT8AZrxKOo+b
 MgX5RX3AAZ7v1VPoWCM0qOLbW6/yL+0zmertRfABU4J2F7m1UDV8Al+4ArL7rmen7gPJ
 WQ+gwIu7fqwR3lncwLv5AFNaRR3SRU/yeaU5JSHtNaHc7QFFF81Jw4w0Sjo6B51NdWkO
 lgPfmnP3bKIpYtqHhoQBg84VhtMzfo3v4KXnixD02Hy4nxwBLBKj5TrNww/L+ua/L3Ny
 mg8rXeVGsm4xCcXqvC55gt3gN0HzfuZgAKG4nNfzb8gfdYPPf1/OcwoSlYGW2QPtnp8H JQ== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1e2ah7ju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 15:35:33 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25UFLJ7o001133
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 15:35:33 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04wdc.us.ibm.com with ESMTP id 3gwt0abwcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 15:35:33 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25UFZV7740829218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 15:35:31 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A83556A047;
        Thu, 30 Jun 2022 15:35:31 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17D7D6A04D;
        Thu, 30 Jun 2022 15:35:31 +0000 (GMT)
Received: from [9.77.155.233] (unknown [9.77.155.233])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 30 Jun 2022 15:35:30 +0000 (GMT)
Message-ID: <7e3750ab-d123-1b40-ae92-0920db555475@linux.ibm.com>
Date:   Thu, 30 Jun 2022 10:35:30 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] ibmvnic: Properly dispose of all skbs during a failover.
Content-Language: en-US
To:     Rick Lindsley <ricklind@us.ibm.com>, netdev@vger.kernel.org
Cc:     bjking1@linux.ibm.com, haren@linux.ibm.com, mmc@linux.ibm.com
References: <20220630000317.2509347-1-ricklind@us.ibm.com>
From:   Nick Child <nnac123@linux.ibm.com>
In-Reply-To: <20220630000317.2509347-1-ricklind@us.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2EjlWa0ENU8BUfFs6FuCvgglW8Qsv3zP
X-Proofpoint-GUID: 2EjlWa0ENU8BUfFs6FuCvgglW8Qsv3zP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1011
 bulkscore=0 mlxlogscore=476 priorityscore=1501 phishscore=0 adultscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206300060
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tested-by: Nick Child <nnac123@linux.ibm.com>
