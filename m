Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0AB4812AF
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 13:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236535AbhL2Md3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 07:33:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50016 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236146AbhL2Md2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 07:33:28 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BTAVIMe030257;
        Wed, 29 Dec 2021 12:33:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kupsKleItlwxybiWjliC+jxy1bQwQOLVjbXcnTt80+8=;
 b=GL+2pdDDuVKeMe/hubFqZVG4wYrZitUM8QJM7t/kfNECJlvmcs6gX54z2irm80BhqiZ2
 PlCZze3N79ibQ4db25jF+pvPqGFMxbwr6IHAxXcYkjyMJA45hANep3gPwDYjOX6slKYU
 a2o2VeXMEsj1EkeKOPIdAqAVCUuuLlZruN3c1lWZ7noUKWKLVqDTmazNWXXHz8NMgHsT
 rf7cB+SMCZ/01LSRGocCe5GM7J/YTUmtLr7aTWLCvuuQgmn+zFqs9b7isOBEtszswlkL
 24+qq/YTKTdgTJ6PzPvWTjyPMpD2HE9xAg3nkEim0c5XnfVeHwFpICzWhbPWdNimMGbL Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d81229eqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Dec 2021 12:33:26 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BTCXQq6005410;
        Wed, 29 Dec 2021 12:33:26 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d81229epj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Dec 2021 12:33:25 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BTCWKDY027431;
        Wed, 29 Dec 2021 12:33:23 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3d5txaxfye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Dec 2021 12:33:23 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BTCXKWP45744500
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Dec 2021 12:33:20 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2BD94C044;
        Wed, 29 Dec 2021 12:33:20 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6CEF24C040;
        Wed, 29 Dec 2021 12:33:20 +0000 (GMT)
Received: from [9.145.32.240] (unknown [9.145.32.240])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Dec 2021 12:33:20 +0000 (GMT)
Message-ID: <444f15e6-db60-3e86-fe20-32f24928844c@linux.ibm.com>
Date:   Wed, 29 Dec 2021 13:33:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net 2/2] net/smc: fix kernel panic caused by race of
 smc_sock
Content-Language: en-US
To:     Dust Li <dust.li@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        Wen Gu <guwen@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
References: <20211228090325.27263-1-dust.li@linux.alibaba.com>
 <20211228090325.27263-3-dust.li@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211228090325.27263-3-dust.li@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: drGtO2SeMLeibxgULjLyBcuTdzvXpyzU
X-Proofpoint-GUID: cIRylylHq4CBCtLiE9uLVyGdL9xj5lFx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-29_04,2021-12-29_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0
 bulkscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112290068
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/12/2021 10:03, Dust Li wrote:
> A crash occurs when smc_cdc_tx_handler() tries to access smc_sock
> but smc_release() has already freed it.

I am not sure about what happened here. 
Your patch removes the whole dismisser concept that was introduced to
solve exactly the problem you describe. And you implemented a different approach.

In theory, when smc_cdc_tx_handler() is called but the connection is already
freed than the connection should have gone through smc_cdc_tx_dismiss_slots(),
called by smc_conn_kill() or smc_conn_free(). If that happened there would be no
access to an already freed address in smc_cdc_tx_handler().

Can you explain why the code reached smc_cdc_tx_handler() with cdcpend->conn
pointing to a connection that is already freed? I think if there is a bug it should
be fixed instead of replacing the code by a new construct.

Thoughts?
