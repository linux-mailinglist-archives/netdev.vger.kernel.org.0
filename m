Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2513415D6F9
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 12:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgBNLyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 06:54:23 -0500
Received: from mail-eopbgr70057.outbound.protection.outlook.com ([40.107.7.57]:45011
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727835AbgBNLyX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 06:54:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZkMM/5JnZPVw9D9XJjkK6MLKt37l+rZkmOMOudL9NS2H8CdS3p6D8DSxTmDqoc0uPvfSuaN8axPmczw9JWRaS10VR2IPocb6snaKIsmanetcABzTWt6S6C6xcfiB3+UsavcBDIL3AsY2CJEpY9qrB5Zqj5gVHYJAMDMjBLTvf/sNEDF/NKAOVYTRqKkxmwccsh5cXXWGxqNsSHhEIU//TFMtP9Jdx9eSM1+9yHSsMp1P6eLmrmW/zzj6dMxdKm+KHa96kjMDfBR2ZFZtfFtY6un7GOjECsfpcrFX5Ep6VELgSS52sZgezbApJ5fd3B9IDTmL1U2PZWs5xe6Dtjje5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TjsszTnH2pTZlHuUPuClETEdXVlcPnwLp+GJtWAaqlc=;
 b=PPjqjxoNjXFy+APzzo2ZDgvng7FVsB0a5zYvEqivca87gCkC6rmRLPAvqLAnFzZzHmH8M6iDCoCK8I694pEj0JY67hZ6Ef/KOtnLpfeW2SzpT8bpAzUr7aFv/Vjwbs2FfPrEIwnPxqHHMl1osnKhXfTCjGwtP19NwdRcU8VrakbqrYm2/JuqiDk7HVbAX5325ZM5mpJ8yOqNdLlwhN/PgIDvotJIf/jQgBKFNeds+YlchDEkW6VOyZ9+YXoHG3yC3LYEfInoKBuZhH7OWMLWHLPUyuPWZ8MSelu9rhaMiaU9fNHpStIWapGcMLRzg0qmw5YTkmToBxtPgTqZqbTJOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TjsszTnH2pTZlHuUPuClETEdXVlcPnwLp+GJtWAaqlc=;
 b=P1Mag3BqSUpcMfwltJV5FaCiP/Y60DWvkrHQmFoQRaPchpu6f+8iwMzIRuympzSbDsVc6e5Pr8mas3pCRiCj4iBnakp3szrpRAysSTNSgmhySXsd3n53VhMl5s2PAs/JuC96r0ZnfTX2qLF/EYDkhNUP0/Ql526XQr6ZnKO/Py4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=borisp@mellanox.com; 
Received: from HE1PR0501MB2825.eurprd05.prod.outlook.com (10.172.125.8) by
 HE1PR0501MB2603.eurprd05.prod.outlook.com (10.168.127.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Fri, 14 Feb 2020 11:53:34 +0000
Received: from HE1PR0501MB2825.eurprd05.prod.outlook.com
 ([fe80::82f:15b7:38a5:2c5a]) by HE1PR0501MB2825.eurprd05.prod.outlook.com
 ([fe80::82f:15b7:38a5:2c5a%4]) with mapi id 15.20.2729.025; Fri, 14 Feb 2020
 11:53:34 +0000
Subject: Re: [PATCH net v2] net/tls: Fix to avoid gettig invalid tls record
To:     Rohit Maheshwari <rohitm@chelsio.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, manojmalviya@chelsio.com
References: <20200214091433.1868-1-rohitm@chelsio.com>
From:   Boris Pismenny <borisp@mellanox.com>
Message-ID: <93e332bc-08a2-8fd3-a634-3d84c2fd2a55@mellanox.com>
Date:   Fri, 14 Feb 2020 13:53:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
In-Reply-To: <20200214091433.1868-1-rohitm@chelsio.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P191CA0028.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:54::33) To HE1PR0501MB2825.eurprd05.prod.outlook.com
 (2603:10a6:3:c0::8)
MIME-Version: 1.0
Received: from [192.168.1.14] (213.57.108.28) by PR3P191CA0028.EURP191.PROD.OUTLOOK.COM (2603:10a6:102:54::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.23 via Frontend Transport; Fri, 14 Feb 2020 11:53:33 +0000
X-Originating-IP: [213.57.108.28]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4a740787-b4fb-49bf-4665-08d7b14484ec
X-MS-TrafficTypeDiagnostic: HE1PR0501MB2603:|HE1PR0501MB2603:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0501MB26035A794CB15B3B28A131E4B0150@HE1PR0501MB2603.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 03137AC81E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(366004)(39860400002)(136003)(199004)(189003)(4326008)(5660300002)(66946007)(86362001)(31696002)(478600001)(2906002)(36756003)(6666004)(31686004)(6486002)(52116002)(956004)(53546011)(16526019)(186003)(2616005)(26005)(316002)(16576012)(66476007)(66556008)(8936002)(81156014)(8676002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0501MB2603;H:HE1PR0501MB2825.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X+Z6VJJ7Y0vQpV15qPLt1CAbmaWS/MsDJ8K0JhxgiOI42UJMHKJTScYO0gRHeOAeutF6WuxDHggpb09GpWFlfsc8oUcY3QIkrABE8Zb4zGnbHT84iVBeg2hez37Vy/M+1hSnDgSC++O/TaZ4hFKr1YoDjqFZNiQ3L9dXj/coxzGkmAI4Y6cdnR3isrDr+LwNmVkPxiuvdLle5Em2yYrF5U7eND3t9FeRgQp9e1niXElcZJkNcxC/hFxOy7Y3kUg5QdGzhHUA4xLiIRpjsunf6Bak5/I7qszI7phKgcdaOoh4ntdnp+k/aKcO1qa1rBTjY8F3uyAYUkPPu3FtGvDfd5ebujs88b+m9RmN1pEQWvAkp1/qMQB3lISNTOWzd3eFx43rQMaV2DEKbuxk1x0jQQqHFp5BteU0cIbBBRwtVIZRr1IT3Rt8vZcHU96OxpKN
X-MS-Exchange-AntiSpam-MessageData: +ZZHa4VP/dnBSNT2Phw+Oaac4AX3yiNumbdt+oUCquKqKr1rGHgok3D4WRf14XIu3brzofo51jpeC18g34w/XDgPTgrnnw8J8506v2TIjDMnFnyVvt7T1EKd+aDUadaLlQhdLCiGHhyOkNUszf0q/A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a740787-b4fb-49bf-4665-08d7b14484ec
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2020 11:53:34.5132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f0BzmU6aPBz2cKeoUw2nyriIuvcd31N4BMtrqn1ACqUpgiXJQu2LWVMFCv81Ts7rf9L32gOj1cQhHp128wqQoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0501MB2603
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rohit,

On 14/02/2020 11:14, Rohit Maheshwari wrote:
> Current code doesn't check if tcp sequence number is starting from (/after)
> 1st record's start sequnce number. It only checks if seq number is before
> 1st record's end sequnce number. This problem will always be a possibility
> in re-transmit case. If a record which belongs to a requested seq number is
> already deleted, tls_get_record will start looking into list and as per the
> check it will look if seq number is before the end seq of 1st record, which
> will always be true and will return 1st record always, it should in fact
> return NULL.
> As part of the fix checking if the sequence number lies in the list else
> return NULL.
> 
> Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
> ---
>  net/tls/tls_device.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index cd91ad812291..3ee06759dc80 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c
> @@ -592,7 +592,7 @@ struct tls_record_info *tls_get_record(struct tls_offload_context_tx *context,
>  				       u32 seq, u64 *p_record_sn)
>  {
>  	u64 record_sn = context->hint_record_sn;
> -	struct tls_record_info *info;
> +	struct tls_record_info *info, *last;
>  
>  	info = context->retransmit_hint;
>  	if (!info ||
> @@ -604,6 +604,15 @@ struct tls_record_info *tls_get_record(struct tls_offload_context_tx *context,
>  						struct tls_record_info, list);
>  		if (!info)
>  			return NULL;
> +		/* we have first record, get the last record to see if this seq
> +		 * number belongs to the list.
> +		 */
> +		last = list_last_entry(&context->records_list,
> +				       struct tls_record_info, list);
> +		WARN_ON(!last);
> +
> +		if (!between(seq, tls_record_start_seq(info), last->end_seq))
> +			return NULL;

There's one case in which this is problematic:
TCP packets sent before TLS offload has started. In this case, we use
the start_marker_record (end_seq=first_offload_seq, len=0).
The record_info of the start marker is returned by tls_get_record, and
the driver can handle it properly. However, this patch breaks this,
as the code above returns NULL for these packets which implies that
these packets have been acked and should be dropped by the driver. But,
these packets should be transmitted as they are with no offload.

Adding an unlikely check for the start marker would resolve this issue.
