Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3342E270F7
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730046AbfEVUqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:46:22 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:38626 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729772AbfEVUqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 16:46:21 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id B5DB8886BF;
        Thu, 23 May 2019 08:46:18 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1558557978;
        bh=3TZ47huYluY/3pZX8nifhcITp1KX8KmXysMv4Yc/iNE=;
        h=From:To:CC:Subject:Date:References;
        b=VclfOne2fcbB7xqG/eBg/fE+Jqjoxr+UYjMCTS/ss8UMIFgtfefsSldzHvmrJxXy4
         W8LEg/+hVJc6H8WLwRkSY/6liz83z8twT/a4bfGZQcNMjxAup8N1xy1uvLHr1lhpQ8
         YejxZFqzMf5FQ+gQM/4NoCVPP9sniCz/FJkVXiHn/Y/2nCY95bmf4sKMOJ70jAaaj4
         Zh6kZx+5osL4vRRy2vB8XqCR3j/nGYGCymDeigvR39ivF3pjXdcscMDPWmaieF2rsV
         V6ISolUAtnm2uHCROjL88KIr27HLeYl9rV45a+sEGvCamGLlB1lESGWYHFRWhRrfQw
         EDrFp01I1/JiQ==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5ce5b5190000>; Thu, 23 May 2019 08:46:17 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1156.6; Thu, 23 May 2019 08:46:14 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1156.000; Thu, 23 May 2019 08:46:14 +1200
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Ying Xue <ying.xue@windriver.com>,
        "jon.maloy@ericsson.com" <jon.maloy@ericsson.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "niveditas98@gmail.com" <niveditas98@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tipc: Avoid copying bytes beyond the supplied data
Thread-Topic: [PATCH v2] tipc: Avoid copying bytes beyond the supplied data
Thread-Index: AQHVDr6UzD7ShqRrH0SCh8JWI9STBw==
Date:   Wed, 22 May 2019 20:46:13 +0000
Message-ID: <00ce1b1e52ac4b729d982c86127334aa@svr-chch-ex1.atlnz.lc>
References: <20190520034536.22782-1-chris.packham@alliedtelesis.co.nz>
 <2830aab3-3fa9-36d2-5646-d5e4672ae263@windriver.com>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:22:3a2c:4aff:fe70:2b02]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ying,=0A=
=0A=
On 22/05/19 7:58 PM, Ying Xue wrote:=0A=
> On 5/20/19 11:45 AM, Chris Packham wrote:=0A=
>> TLV_SET is called with a data pointer and a len parameter that tells us=
=0A=
>> how many bytes are pointed to by data. When invoking memcpy() we need=0A=
>> to careful to only copy len bytes.=0A=
>>=0A=
>> Previously we would copy TLV_LENGTH(len) bytes which would copy an extra=
=0A=
>> 4 bytes past the end of the data pointer which newer GCC versions=0A=
>> complain about.=0A=
>>=0A=
>>   In file included from test.c:17:=0A=
>>   In function 'TLV_SET',=0A=
>>       inlined from 'test' at test.c:186:5:=0A=
>>   /usr/include/linux/tipc_config.h:317:3:=0A=
>>   warning: 'memcpy' forming offset [33, 36] is out of the bounds [0, 32]=
=0A=
>>   of object 'bearer_name' with type 'char[32]' [-Warray-bounds]=0A=
>>       memcpy(TLV_DATA(tlv_ptr), data, tlv_len);=0A=
>>       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=0A=
>>   test.c: In function 'test':=0A=
>>   test.c::161:10: note:=0A=
>>   'bearer_name' declared here=0A=
>>       char bearer_name[TIPC_MAX_BEARER_NAME];=0A=
>>            ^~~~~~~~~~~=0A=
>>=0A=
>> We still want to ensure any padding bytes at the end are initialised, do=
=0A=
>> this with a explicit memset() rather than copy bytes past the end of=0A=
>> data. Apply the same logic to TCM_SET.=0A=
>>=0A=
>> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>=0A=
> =0A=
> Acked-by: Ying Xue <ying.xue@windriver.com>=0A=
> =0A=
> =0A=
> But please make the same changes in usr/include/linux/tipc_config.h=0A=
> =0A=
=0A=
I don't understand this comment. There is no usr/include in the kernel =0A=
source.=0A=
=0A=
On most distros that is generated from include/uapi in the kernel source =
=0A=
and packaged as part of libc or a kernel-headers package. So once this =0A=
patch is accepted and makes it into the distros =0A=
/usr/include/linux/tipc_config.h will have this fix.=0A=
=0A=
Adding Cc: stable might help get it there sooner. But I wanted to get it =
=0A=
reviewed/accepted first.=0A=
=0A=
>> ---=0A=
>>=0A=
>> Changes in v2:=0A=
>> - Ensure padding bytes are initialised in both TLV_SET and TCM_SET=0A=
>>=0A=
>>   include/uapi/linux/tipc_config.h | 10 +++++++---=0A=
>>   1 file changed, 7 insertions(+), 3 deletions(-)=0A=
>>=0A=
>> diff --git a/include/uapi/linux/tipc_config.h b/include/uapi/linux/tipc_=
config.h=0A=
>> index 4b2c93b1934c..4955e1a9f1bc 100644=0A=
>> --- a/include/uapi/linux/tipc_config.h=0A=
>> +++ b/include/uapi/linux/tipc_config.h=0A=
>> @@ -307,8 +307,10 @@ static inline int TLV_SET(void *tlv, __u16 type, vo=
id *data, __u16 len)=0A=
>>   	tlv_ptr =3D (struct tlv_desc *)tlv;=0A=
>>   	tlv_ptr->tlv_type =3D htons(type);=0A=
>>   	tlv_ptr->tlv_len  =3D htons(tlv_len);=0A=
>> -	if (len && data)=0A=
>> -		memcpy(TLV_DATA(tlv_ptr), data, tlv_len);=0A=
>> +	if (len && data) {=0A=
>> +		memcpy(TLV_DATA(tlv_ptr), data, len);=0A=
>> +		memset(TLV_DATA(tlv_ptr) + len, 0, TLV_SPACE(len) - tlv_len);=0A=
>> +	}=0A=
>>   	return TLV_SPACE(len);=0A=
>>   }=0A=
>>   =0A=
>> @@ -405,8 +407,10 @@ static inline int TCM_SET(void *msg, __u16 cmd, __u=
16 flags,=0A=
>>   	tcm_hdr->tcm_len   =3D htonl(msg_len);=0A=
>>   	tcm_hdr->tcm_type  =3D htons(cmd);=0A=
>>   	tcm_hdr->tcm_flags =3D htons(flags);=0A=
>> -	if (data_len && data)=0A=
>> +	if (data_len && data) {=0A=
>>   		memcpy(TCM_DATA(msg), data, data_len);=0A=
>> +		memset(TCM_DATA(msg) + data_len, 0, TCM_SPACE(data_len) - msg_len);=
=0A=
>> +	}=0A=
>>   	return TCM_SPACE(data_len);=0A=
>>   }=0A=
>>   =0A=
>>=0A=
> =0A=
=0A=
