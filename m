Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9359025EE2
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 09:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbfEVH6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 03:58:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:52566 "EHLO
        mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbfEVH6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 03:58:15 -0400
Received: from ALA-HCA.corp.ad.wrs.com ([147.11.189.40])
        by mail.windriver.com (8.15.2/8.15.1) with ESMTPS id x4M7vurP026148
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Wed, 22 May 2019 00:57:56 -0700 (PDT)
Received: from [128.224.155.90] (128.224.155.90) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.50) with Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 22 May
 2019 00:57:55 -0700
Subject: Re: [PATCH v2] tipc: Avoid copying bytes beyond the supplied data
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        <jon.maloy@ericsson.com>, <davem@davemloft.net>,
        <niveditas98@gmail.com>
CC:     <netdev@vger.kernel.org>, <tipc-discussion@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
References: <20190520034536.22782-1-chris.packham@alliedtelesis.co.nz>
From:   Ying Xue <ying.xue@windriver.com>
Message-ID: <2830aab3-3fa9-36d2-5646-d5e4672ae263@windriver.com>
Date:   Wed, 22 May 2019 15:47:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520034536.22782-1-chris.packham@alliedtelesis.co.nz>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.155.90]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/20/19 11:45 AM, Chris Packham wrote:
> TLV_SET is called with a data pointer and a len parameter that tells us
> how many bytes are pointed to by data. When invoking memcpy() we need
> to careful to only copy len bytes.
> 
> Previously we would copy TLV_LENGTH(len) bytes which would copy an extra
> 4 bytes past the end of the data pointer which newer GCC versions
> complain about.
> 
>  In file included from test.c:17:
>  In function 'TLV_SET',
>      inlined from 'test' at test.c:186:5:
>  /usr/include/linux/tipc_config.h:317:3:
>  warning: 'memcpy' forming offset [33, 36] is out of the bounds [0, 32]
>  of object 'bearer_name' with type 'char[32]' [-Warray-bounds]
>      memcpy(TLV_DATA(tlv_ptr), data, tlv_len);
>      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>  test.c: In function 'test':
>  test.c::161:10: note:
>  'bearer_name' declared here
>      char bearer_name[TIPC_MAX_BEARER_NAME];
>           ^~~~~~~~~~~
> 
> We still want to ensure any padding bytes at the end are initialised, do
> this with a explicit memset() rather than copy bytes past the end of
> data. Apply the same logic to TCM_SET.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>

Acked-by: Ying Xue <ying.xue@windriver.com>


But please make the same changes in usr/include/linux/tipc_config.h

> ---
> 
> Changes in v2:
> - Ensure padding bytes are initialised in both TLV_SET and TCM_SET
> 
>  include/uapi/linux/tipc_config.h | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/tipc_config.h b/include/uapi/linux/tipc_config.h
> index 4b2c93b1934c..4955e1a9f1bc 100644
> --- a/include/uapi/linux/tipc_config.h
> +++ b/include/uapi/linux/tipc_config.h
> @@ -307,8 +307,10 @@ static inline int TLV_SET(void *tlv, __u16 type, void *data, __u16 len)
>  	tlv_ptr = (struct tlv_desc *)tlv;
>  	tlv_ptr->tlv_type = htons(type);
>  	tlv_ptr->tlv_len  = htons(tlv_len);
> -	if (len && data)
> -		memcpy(TLV_DATA(tlv_ptr), data, tlv_len);
> +	if (len && data) {
> +		memcpy(TLV_DATA(tlv_ptr), data, len);
> +		memset(TLV_DATA(tlv_ptr) + len, 0, TLV_SPACE(len) - tlv_len);
> +	}
>  	return TLV_SPACE(len);
>  }
>  
> @@ -405,8 +407,10 @@ static inline int TCM_SET(void *msg, __u16 cmd, __u16 flags,
>  	tcm_hdr->tcm_len   = htonl(msg_len);
>  	tcm_hdr->tcm_type  = htons(cmd);
>  	tcm_hdr->tcm_flags = htons(flags);
> -	if (data_len && data)
> +	if (data_len && data) {
>  		memcpy(TCM_DATA(msg), data, data_len);
> +		memset(TCM_DATA(msg) + data_len, 0, TCM_SPACE(data_len) - msg_len);
> +	}
>  	return TCM_SPACE(data_len);
>  }
>  
> 
