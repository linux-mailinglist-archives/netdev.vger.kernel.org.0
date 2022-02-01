Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C684A5AA7
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 11:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236953AbiBAKyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 05:54:02 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14612 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236943AbiBAKyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 05:54:01 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 211AcBDo032200;
        Tue, 1 Feb 2022 10:53:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=f4UZimUTkkgLdlh/G4lKs3faewimH5Z7C7FGlSi7BkA=;
 b=npTkYgPL6g42qCHwl8o2HGCXEHj0Pl8qE1PKXhcIV3FYMyGmNJTeAHmYrdMsK8kWA4TR
 6srP55BIsSUTPkO2wufDM/9Z/mpFsROR71miGmX0bqkVmixfbI+KQSOlbPB+0FNsuLxu
 Vg+1SuQI9lm+6PdR+oON1+Z15rKeahMrGSv8oM+nhmY0iU9F2pDY9xEhOecki2Dz+g0k
 fophS6tr735R50NSzkUj1H5PXqHu11PzfTiqeq13quyVZx3dPH0g2AoIRuFuF1Y5DzAa
 6wCNLfCWsA+rmCIyVHz2we4R+eaHib75i53BVFe/nIjpXeccFW1VrL8mtah7P7Lpfc/F iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dxrbkuu1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Feb 2022 10:53:59 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 211AfWKU007683;
        Tue, 1 Feb 2022 10:53:58 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dxrbkutyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Feb 2022 10:53:58 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 211AmSFQ006323;
        Tue, 1 Feb 2022 10:53:56 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3dvw79j9bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Feb 2022 10:53:56 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 211ArrIt40567172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Feb 2022 10:53:53 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE57542042;
        Tue,  1 Feb 2022 10:53:53 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66E2942045;
        Tue,  1 Feb 2022 10:53:53 +0000 (GMT)
Received: from [9.145.64.14] (unknown [9.145.64.14])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Feb 2022 10:53:53 +0000 (GMT)
Message-ID: <fc2d73bb-a614-eb84-e635-31f8836f612a@linux.ibm.com>
Date:   Tue, 1 Feb 2022 11:53:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [BUG] net: smc: possible deadlock in smc_lgr_free() and
 smc_link_down_work()
Content-Language: en-US
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Wenjia Zhang <wenjia@linux.ibm.com>
References: <11fe65b8-eda4-121e-ec32-378b918d0909@gmail.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <11fe65b8-eda4-121e-ec32-378b918d0909@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WmMxtRy01sKQrw90KW1v_vmF6sxDSxFv
X-Proofpoint-ORIG-GUID: WVLJbhOYn4TYKz_86L8z8bAqeJGdcORD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-01_03,2022-02-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 clxscore=1015 bulkscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202010058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/02/2022 08:51, Jia-Ju Bai wrote:
> Hello,
> 
> My static analysis tool reports a possible deadlock in the smc module in Linux 5.16:
> 
> smc_lgr_free()
>   mutex_lock(&lgr->llc_conf_mutex); --> Line 1289 (Lock A)
>   smcr_link_clear()
>     smc_wr_free_link()
>       wait_event(lnk->wr_tx_wait, ...); --> Line 648 (Wait X)
> 
> smc_link_down_work()
>   mutex_lock(&lgr->llc_conf_mutex); --> Line 1683 (Lock A)
>   smcr_link_down()
>     smcr_link_clear()
>       smc_wr_free_link()
>         smc_wr_wakeup_tx_wait()
>           wake_up_all(&lnk->wr_tx_wait); --> Line 78 (Wake X)
> 
> When smc_lgr_free() is executed, "Wait X" is performed by holding "Lock A". If smc_link_down_work() is executed at this time, "Wake X" cannot be performed to wake up "Wait X" in smc_lgr_free(), because "Lock A" has been already hold by smc_lgr_free(), causing a possible deadlock.
> 

Thank you for your reporting and the good description!

We will look into this issue and get back to you in a few days.

