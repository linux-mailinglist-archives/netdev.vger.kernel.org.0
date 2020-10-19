Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B576D29246D
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 11:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730190AbgJSJLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 05:11:14 -0400
Received: from mail-eopbgr150095.outbound.protection.outlook.com ([40.107.15.95]:30328
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727235AbgJSJLO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 05:11:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FdZyyeYW5/rdTRfmmVYDHMMFRE2X5M9VMuXt0f+C1AYDMx05pAlVR/3Rj10P0+C8itKvKydNM6xxkl9m05HecYqCFIUIJoQaDbCGJvXxSLyJaqzDXDkfILzwP+JHh+MgkJFARvPt29Q5h76sCoAwqa1gNh3IWvFMYV4fNm8tvyG9gRXEwNdVqywgZAuHhRUZyZNifaA9+AvTaz9HSRON+OI8Dy3bb+HnYzHtpoHxUW/edUnNZK737/lk35y3IMH5S5JY5m8bEnWyIMJu+zu80CGB/PUM0LgxHWBd3gwfwuZ9/uS68Z6xJuEu6j0S+MS5hjagY0zxll23lTtjSzzQFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qBunoeqzoYWSjuQQaJRLSSK+At0DlQKtbaw17A9OBlg=;
 b=J7ltksGFM86p9ZJ1auVnpcZyfRb1tZcph2aozzua/dPIkoBZK1AHQbn6HAgRnKW8jbKblt3ntJZ/aCXFS1CJoMPPlrt0llD96b9fI0OgYV/eZz3XqF0kuaoVKdEM0jUbZjJ/Xj6WHrgfA08Hs+BrvfKUIdW3DjLdbCQlrmbW8f5BPZmRHmb28fcuZ/86ByZ2Shqfh0mCKKIr+Edi5iqHUw+lZWdCw4ONvUsdDe9Iz5jPBpX/E90wBwZM4VFwiK77Ovb0F/4lboCGehGJ87Xcf6CmyBmGVHkiUc9SbYMXvDlkrFD9DE5W0OwDnaUneQOCaDBQ6nRtcFmF+uAjKktWKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qBunoeqzoYWSjuQQaJRLSSK+At0DlQKtbaw17A9OBlg=;
 b=S/W377a3X8jKN6rGEmeANqQWMOYz5KVkxk6W+5VUkJcqC+MOerbHMzMaslqiAYSEpTAw1YuZo1+/WFl2bAPD1OQediIdW2z7RFaQvljigoWbq2BJ9cJoDaXfSSA1DALK0VviCTOvvgjNX/oNLqAPTwejR+de+Q9nOC2Kd4lSdD4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nokia.com;
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com (2603:10a6:208:6e::15)
 by AM0PR07MB4177.eurprd07.prod.outlook.com (2603:10a6:208:ad::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.4; Mon, 19 Oct
 2020 09:11:09 +0000
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::d527:e75b:546c:a85b]) by AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::d527:e75b:546c:a85b%6]) with mapi id 15.20.3499.014; Mon, 19 Oct 2020
 09:11:09 +0000
Subject: Re: [PATCH v2 net] staging: octeon: Drop on uncorrectable alignment
 or FCS error
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20201016101858.11374-1-alexander.sverdlin@nokia.com>
 <20201016101858.11374-2-alexander.sverdlin@nokia.com>
 <20201017210235.GU456889@lunn.ch>
From:   Alexander Sverdlin <alexander.sverdlin@nokia.com>
Message-ID: <93d7a7a7-69f9-6452-aa2f-2f82636ecde2@nokia.com>
Date:   Mon, 19 Oct 2020 11:11:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201017210235.GU456889@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [131.228.32.167]
X-ClientProxiedBy: CH2PR19CA0004.namprd19.prod.outlook.com
 (2603:10b6:610:4d::14) To AM0PR07MB4531.eurprd07.prod.outlook.com
 (2603:10a6:208:6e::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ulegcpsvhp1.emea.nsn-net.net (131.228.32.167) by CH2PR19CA0004.namprd19.prod.outlook.com (2603:10b6:610:4d::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Mon, 19 Oct 2020 09:11:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 29aa640b-016e-44b5-4bb5-08d8740eeb21
X-MS-TrafficTypeDiagnostic: AM0PR07MB4177:
X-Microsoft-Antispam-PRVS: <AM0PR07MB41773B9A42113DD549080816881E0@AM0PR07MB4177.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JwoAPQ159M4ODzmlSUsfl6dUkVN2Tf5vWFUZ7yOhKxOPopADJicULeBr8s3GKikenaKVKuO5q1nvG96ZdPUjeW4z8UnbhIq5GDjBxOrO2bUqKCuMeu20rL2rjp61QrZBf7qd5GJU/fr0QVs5kwcfn7uRA7CMJgFPDg0R2qXpvSyYTx4DML518G5dAr4yh+SB59Ahe5m1zFEfVLhlnJyZVsq1EOxEb5Wn0nMNukpRa+iSZdYLEGDNewvuNXYqROXrnRn38pr2FCYBQCYm9lPKBhB5mRgSNLv6LqMsjZpxENsxZjAW/2J/RtTuThv8m2hh4H+cD3sXVk6zSWGFWzzEb/snkQO6FRRtONulyvj336wlbVQ7K25Xb6dcIg2JI3m8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB4531.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(5660300002)(2906002)(956004)(66946007)(66476007)(2616005)(316002)(53546011)(26005)(8676002)(6486002)(6506007)(478600001)(8936002)(54906003)(66556008)(52116002)(6666004)(31686004)(6512007)(86362001)(44832011)(4326008)(31696002)(36756003)(16526019)(6916009)(186003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: HRk3gZ6CvYPfIhIfpZ1GxmpZywRoLPFsYXK72laqnHl2nI8vcmE4Rmnmub46KojH7CS+myHreWlNFl0WAP2UTj2cc/diSVJnyf2Mcs9V95ctD0y/gWvTSEW14B8ZiKgyinjJMUlkAOw8imNt4IVwz6eMPUQOuYk6xxB6JWdzGNN3SdcWFIMrstlaj+1vWWsJBMwVUw4h3jldVkr0YwithjpjrWWvWVHJzN1YSTrWKTttRR6v5r0CaoSGwLEbvH1M5Mm4flrZ1G6OKUzIs8Z8SiUaZ+3p0zFiL46CIirQGwYNLODWIC9FQK3VM/EAbhZ1VD7xQXJrXo3QnoMN7PP9uR2FgkCUikTI+kt9lleo9Ylv97+uOmnbfwOV71xccW/RCIHMkHiKObRU+ZbXd1Q0GEnTB8lRocNSTcTjXxMBPBJFFywvv2Z72n9iKx0ponPeh//Gd/0lE50KVeq0ff2ayFWI8IQm6YxNen7jIx7rqazcBBiwnPbRsdDjTe6w70d143qFhJkUN9rFsyaHlhGWBidJCBS+La7O231T4f409OaVEohx0cTiyqPS/aRSt7l1BqrdLpAnPlnDpHOmv5MrhtPOZOcg2KUMkwsWCg7xg//QPzjit7LCkFbx2KQCw/w8zf3BhkUcAnxL1fVKuo2uQw==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29aa640b-016e-44b5-4bb5-08d8740eeb21
X-MS-Exchange-CrossTenant-AuthSource: AM0PR07MB4531.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2020 09:11:09.7256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HneRJ/Oe6Wlj551v1xgrx0f/8CPrcH9bC3Y88RTJUACbb6itG+f40YJeCHennz79lggXnNw3WXBEQ0WkiApglqObRvufvrMFbx9unrEjxPg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR07MB4177
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,

thank you for your review!

On 17/10/2020 23:02, Andrew Lunn wrote:
>> diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
>> index 2c16230..9ebd665 100644
>> --- a/drivers/staging/octeon/ethernet-rx.c
>> +++ b/drivers/staging/octeon/ethernet-rx.c
>> @@ -69,15 +69,17 @@ static inline int cvm_oct_check_rcv_error(struct cvmx_wqe *work)
>>  	else
>>  		port = work->word1.cn38xx.ipprt;
>>  
>> -	if ((work->word2.snoip.err_code == 10) && (work->word1.len <= 64)) {
>> +	if ((work->word2.snoip.err_code == 10) && (work->word1.len <= 64))
> It would be nice to replace all these err_code magic numbers with #defines.
> 
> You should also replace 64 with ETH_ZLEN + ETH_FCS_LEN. I also wonder
> if <= should be just < ?

I think all your comments are valid points, but are rather topics
for separate patches. In this one I've addressed one issue: the structure of
ifs and elses is so deeply nested, that it lead to one logic mistake:
broken packets which cannot be corrected are still not dropped.

Even my patch has two changes in one: error correction and style correction,
but I consider this justified because one was a result of another.

>>  		/*
>>  		 * Ignore length errors on min size packets. Some
>>  		 * equipment incorrectly pads packets to 64+4FCS
>>  		 * instead of 60+4FCS.  Note these packets still get
>>  		 * counted as frame errors.
>>  		 */
>> -	} else if (work->word2.snoip.err_code == 5 ||
>> -		   work->word2.snoip.err_code == 7) {
>> +		return 0;
>> +
>> +	if (work->word2.snoip.err_code == 5 ||
>> +	    work->word2.snoip.err_code == 7) {
>>  		/*
>>  		 * We received a packet with either an alignment error
>>  		 * or a FCS error. This may be signalling that we are
>> @@ -108,7 +110,10 @@ static inline int cvm_oct_check_rcv_error(struct cvmx_wqe *work)
>>  				/* Port received 0xd5 preamble */
>>  				work->packet_ptr.s.addr += i + 1;
>>  				work->word1.len -= i + 5;
>> -			} else if ((*ptr & 0xf) == 0xd) {
>> +				return 0;
>> +			}
>> +
>> +			if ((*ptr & 0xf) == 0xd) {
> The comments are not so clear what is going on here. Can this
> incorrectly match a destination MAC address of xD:XX:XX:XX:XX:XX.
> 
>>  				/* Port received 0xd preamble */
>>  				work->packet_ptr.s.addr += i;
>>  				work->word1.len -= i + 4;

-- 
Best regards,
Alexander Sverdlin.
