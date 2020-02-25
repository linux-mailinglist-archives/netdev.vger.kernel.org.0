Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7EB416E9D1
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 16:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731019AbgBYPRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 10:17:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60410 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730616AbgBYPRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 10:17:23 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01PFG6bD033198
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 10:17:22 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yaxt8jtgh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 10:17:22 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Tue, 25 Feb 2020 15:17:20 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 25 Feb 2020 15:17:18 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01PFHH8B24641610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 15:17:17 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CEE35206D;
        Tue, 25 Feb 2020 15:17:17 +0000 (GMT)
Received: from [9.152.222.57] (unknown [9.152.222.57])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3077B52051;
        Tue, 25 Feb 2020 15:17:17 +0000 (GMT)
Subject: Re: [PATCH net-next 2/2] net/smc: improve peer ID in CLC decline for
 SMC-R
To:     Hans Wippel <ndev@hwipl.net>, ubraun@linux.ibm.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20200224235901.304311-1-ndev@hwipl.net>
 <20200224235901.304311-3-ndev@hwipl.net>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Date:   Tue, 25 Feb 2020 16:17:16 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200224235901.304311-3-ndev@hwipl.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20022515-0008-0000-0000-0000035650F7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022515-0009-0000-0000-00004A776D0D
Message-Id: <9a7c5736-1f85-5743-8963-ce8a2d27f83b@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-25_05:2020-02-21,2020-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 adultscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250120
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 25/02/2020 00:59, Hans Wippel wrote:
> According to RFC 7609, all CLC messages contain a peer ID that consists
> of a unique instance ID and the MAC address of one of the host's RoCE
> devices. But if a SMC-R connection cannot be established, e.g., because
> no matching pnet table entry is found, the current implementation uses a
> zero value in the CLC decline message although the host's peer ID is set
> to a proper value.
> 
> If no RoCE and no ISM device is usable for a connection, there is no LGR
> and the LGR check in smc_clc_send_decline() prevents that the peer ID is
> copied into the CLC decline message for both SMC-D and SMC-R. So, this
> patch modifies the check to also accept the case of no LGR. Also, only a
> valid peer ID is copied into the decline message.
> 
> Signed-off-by: Hans Wippel <ndev@hwipl.net>
> ---
>  net/smc/smc_clc.c | 9 ++++++---
>  net/smc/smc_ib.h  | 1 +
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
> index 3e16b887cfcf..e2d3b5b95632 100644
> --- a/net/smc/smc_clc.c
> +++ b/net/smc/smc_clc.c
> @@ -372,9 +372,12 @@ int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info)
>  	dclc.hdr.length = htons(sizeof(struct smc_clc_msg_decline));
>  	dclc.hdr.version = SMC_CLC_V1;
>  	dclc.hdr.flag = (peer_diag_info == SMC_CLC_DECL_SYNCERR) ? 1 : 0;
> -	if (smc->conn.lgr && !smc->conn.lgr->is_smcd)
> -		memcpy(dclc.id_for_peer, local_systemid,
> -		       sizeof(local_systemid));
> +	if (!smc->conn.lgr || !smc->conn.lgr->is_smcd) {
> +		if (smc_ib_is_valid_local_systemid()) {
> +			memcpy(dclc.id_for_peer, local_systemid,
> +			       sizeof(local_systemid));
> +		}
                ^
Adds curly braces for no reason.

> +	}
>  	dclc.peer_diagnosis = htonl(peer_diag_info);
>  	memcpy(dclc.trl.eyecatcher, SMC_EYECATCHER, sizeof(SMC_EYECATCHER));
>  
> diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
> index 255db87547d3..5c2b115d36da 100644
> --- a/net/smc/smc_ib.h
> +++ b/net/smc/smc_ib.h
> @@ -84,4 +84,5 @@ void smc_ib_sync_sg_for_device(struct smc_ib_device *smcibdev,
>  			       enum dma_data_direction data_direction);
>  int smc_ib_determine_gid(struct smc_ib_device *smcibdev, u8 ibport,
>  			 unsigned short vlan_id, u8 gid[], u8 *sgid_index);
> +bool smc_ib_is_valid_local_systemid(void);
>  #endif
> 

-- 
Karsten

(I'm a dude)

