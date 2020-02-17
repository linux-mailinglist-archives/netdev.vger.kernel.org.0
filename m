Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73979161037
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 11:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgBQKjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 05:39:17 -0500
Received: from mail-db8eur05on2047.outbound.protection.outlook.com ([40.107.20.47]:29593
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725972AbgBQKjR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Feb 2020 05:39:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhnunRVaRwyL2/A2NLBZovbj7hnFtznY+pMm8r+MgGUn2RVyG2LOvad/RLBEJQ7kwO+3+LrEvgz1XJE5t8yLE5/nwkGyTCBJcvpJAQvyR/ksAI88TdWJWI+PVHSlrlH7nGMEjQkwMI+ll/q10MkTWRnX+eViIubgwLjTcp5lzc5cNDyVZ9ViQMyNbVFYoHseRbV2eRqYxhb4eu8DJCKeJ4lhEPgO2HHOiG+ZCWzgRkNfqUD7jDOP/UGl29iMPlbaaBw1ITGNhDOIt+mUywPlamS6KIbjm6EyQrVVRvllKCbJTPBBL10/RtXhsNCraM3ErWjGJ3H5DXDNBFYqIGpZzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tZiSOQFsOpr4ryUSgsLwCKNpK1XbzZxGFzjFIE/Kb5o=;
 b=Ay0eWUcDG5GLmwrDzg2jVFydgQ3Lsv/V8m0/JEfaV1fYY97mny2EmvBIJTmXLbCEqSQv6uuHmr4u/OUQvolHia1N6oaX9JgM5Uw9HMZNT0okAsnfRCMSAa7+vw28NY4MzQsj2Nk1s2T2iuKz8WBw5pGsZ2/s/jOs00yo0z3/i9PWz/cjRDHK2Nw/3v2kaxbCmxdt21GDlTgt3uzykyJjhHUyGrTYEH9Ycb3q4P4ab4O7zLlmKveUY2k1cDd0XixkuXlVMOLczNbbMgvE+ZJosvmzbRUBWhkL9O1IOwdAw7EvJwIoEuf5bNQFPdBx5kyfnfDZPFkEzjfux16Z/cEKSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tZiSOQFsOpr4ryUSgsLwCKNpK1XbzZxGFzjFIE/Kb5o=;
 b=P6/bX6u8qtZeDUrTOeUP7DH/D++XMWYjzSo6hoL6F5xL2ADcE62J8vtN/k1LNmdQvOHPCIVQzmjIlQ5hL9eYkFEMsrw0vc8aMT8mZ9eUvdriYrUVFdv4WXJRJGGbkZjOygr90z5L/PQbMjk4EwarN6pfevDBFTT2WtLQsz2UjZo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=borisp@mellanox.com; 
Received: from HE1PR0501MB2825.eurprd05.prod.outlook.com (10.172.125.8) by
 HE1SPR00MB05.eurprd05.prod.outlook.com (10.175.29.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.31; Mon, 17 Feb 2020 10:39:11 +0000
Received: from HE1PR0501MB2825.eurprd05.prod.outlook.com
 ([fe80::82f:15b7:38a5:2c5a]) by HE1PR0501MB2825.eurprd05.prod.outlook.com
 ([fe80::82f:15b7:38a5:2c5a%4]) with mapi id 15.20.2729.032; Mon, 17 Feb 2020
 10:39:11 +0000
Subject: Re: [PATCH net v3] net/tls: Fix to avoid gettig invalid tls record
To:     Rohit Maheshwari <rohitm@chelsio.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, manojmalviya@chelsio.com
References: <20200216103108.14034-1-rohitm@chelsio.com>
From:   Boris Pismenny <borisp@mellanox.com>
Message-ID: <6833bb8a-0d38-eb5b-7186-c028eefe63e1@mellanox.com>
Date:   Mon, 17 Feb 2020 12:39:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
In-Reply-To: <20200216103108.14034-1-rohitm@chelsio.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: FRYP281CA0002.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::12)
 To HE1PR0501MB2825.eurprd05.prod.outlook.com (2603:10a6:3:c0::8)
MIME-Version: 1.0
Received: from [10.80.4.9] (193.47.165.251) by FRYP281CA0002.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.23 via Frontend Transport; Mon, 17 Feb 2020 10:39:10 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2e62385f-3012-4197-e4ba-08d7b395a01c
X-MS-TrafficTypeDiagnostic: HE1SPR00MB05:|HE1SPR00MB05:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1SPR00MB05EA8FAD111F777D3489B5B0160@HE1SPR00MB05.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0316567485
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(189003)(199004)(8936002)(8676002)(81166006)(31696002)(81156014)(52116002)(2616005)(956004)(186003)(2906002)(16526019)(86362001)(36756003)(26005)(53546011)(6486002)(66556008)(31686004)(66946007)(4326008)(478600001)(316002)(16576012)(66476007)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1SPR00MB05;H:HE1PR0501MB2825.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TjvDc2RpPuZwChkOh8+S5Xq6d4u9eV0CHYQX2tGeaQ0RNo0dN/nE6VV+iHp06ne843Gk8B7po2fAj/qWJtDn1VxGa9ceGvsELbcyhZ2W5NKyk258EweU32UxFn85VMThNY9S5L/Ylxn+eCad33mByNewIaDVk8iMpkSF2XcK3joxFNitLug5BUkUyhWq9862Vfvzlq1b+Upqn3s+OgkSUSgVaXwXqFgRCKjnO6Hb9QCG52+pMZJ4CpFe0obqwTxnf1hPxk36DOloyJdaru24f93hgQ56JgiV8cWk3s+LgjjkhAzPJuuYFQCXHRoIO+RigQFh2T+OS3OdLJKyLBWXCcBDwLJpIp+od01VyxV19hgLHdSnoXdtwSqyCaI7ChVnL8eogHkP/0re+cq1J+GoSJK1MGHUrz/imJJfOX5WKvcroEo9Dhx43g+H4Cf4SUo0
X-MS-Exchange-AntiSpam-MessageData: CcFPfBCTCXzoTQoFM3nOMqrsHbnsK46mA5xeAFzAujWflW43u/aVhY0SfLoV6wv+7ziXzp9EpnFjXM+sZxtnWgqVa+sMbFLRIgJ1r3k6ECd4XczHVCOTnEkCQyIyS1V44eUvDOhNgK7nhINF/33b5Q==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e62385f-3012-4197-e4ba-08d7b395a01c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2020 10:39:11.7889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tuu3435ys0+GBN3CDsIW9PmUiM5hNAIxBgcOhllnygKW1MFYL/fnQqN3BAS6j8Ie3UQGtK3NYfNbLy6XfXQ2Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1SPR00MB05
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/2020 12:31 PM, Rohit Maheshwari wrote:
> Current code doesn't check if tcp sequence number is starting from (/after)
> 1st record's start sequnce number. It only checks if seq number is before
> 1st record's end sequnce number. This problem will always be a possibility
> in re-transmit case. If a record which belongs to a requested seq number is
> already deleted, tls_get_record will start looking into list and as per the
> check it will look if seq number is before the end seq of 1st record, which
> will always be true and will return 1st record always, it should in fact
> return NULL.
> As part of the fix, start looking each record only if the sequence number
> lies in the list else return NULL.
> There is one more check added, driver look for the start marker record to
> handle tcp packets which are before the tls offload start sequence number,
> hence return 1st record if the record is tls start marker and seq number is
> before the 1st record's starting sequence number.
>
> Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
> ---
>  net/tls/tls_device.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
>
> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index cd91ad812291..00a26e66d361 100644
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
> @@ -604,6 +604,25 @@ struct tls_record_info *tls_get_record(struct tls_offload_context_tx *context,
>  						struct tls_record_info, list);
>  		if (!info)
>  			return NULL;
> +		/* send the start_marker record if seq number is before the
> +		 * tls offload start marker sequence number. This record is
> +		 * required to handle TCP packets which are before TLS offload
> +		 * started.
> +		 *  And if it's not start marker, look if this seq number
> +		 * belongs to the list.
> +		 */
> +		if (likely(!tls_record_is_start_marker(info))) {
> +			/* we have the first record, get the last record to see
> +			 * if this seq number belongs to the list.
> +			 */
> +			last = list_last_entry(&context->records_list,
> +					       struct tls_record_info, list);
> +			WARN_ON(!last);
> +
> +			if (!between(seq, tls_record_start_seq(info),
> +				     last->end_seq))
> +				return NULL;
> +		}
>  		record_sn = context->unacked_record_sn;
>  	}
>  

LGTM. Thanks Rohit

Reviewed-By: Boris Pismenny <borisp@mellanox.com>

