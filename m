Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9EAE14277
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 23:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfEEVRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 17:17:35 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:37180 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727892AbfEEVRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 17:17:35 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 051F2886BF;
        Mon,  6 May 2019 09:17:33 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1557091053;
        bh=cinv3AbBUuC1maLA2NjvzwalNYEktsZCJLbhMl8hKGw=;
        h=From:To:CC:Subject:Date:References;
        b=iJR7d9O/fSZGE9BApCt5gv2g+iYlL0qAloRvZ+yseaOiot24qxgrPe9iGyfuhK3lu
         zieEaNcjOWqfcEHgCjWTZZCO4aBePKbVxHRl/AP0uCBWZxjIU6vCUpiZwdNmQc3oEF
         kfGhvKhZFcIG9SVszFbwInwxbaW8qTuW78uV3roAyNs6ZIa11Xqf+eps16CsCOqAIm
         poI5EspwE0M4/74w9/xrqaL6ogZKxtTRhQnir3AVHa5c12oo244nkN0Bs0WBH6UTJ6
         PQdW5Gx6pC3IhVPzBk2XoRTRp7wuILdn1MFb6KqhNQGstBk1QwrVF+84dH4+wLORVZ
         OjR6u8tsXZlQg==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5ccf52ed0000>; Mon, 06 May 2019 09:17:33 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1156.6; Mon, 6 May 2019 09:17:32 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1156.000; Mon, 6 May 2019 09:17:32 +1200
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Arvind Sankar <niveditas98@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        "jon.maloy@ericsson.com" <jon.maloy@ericsson.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tipc: Avoid copying bytes beyond the supplied data
Thread-Topic: [PATCH] tipc: Avoid copying bytes beyond the supplied data
Thread-Index: AQHVAJSPla9XQI+X40m6eIT6p/LBgg==
Date:   Sun, 5 May 2019 21:17:31 +0000
Message-ID: <989ea285ce154a5d95fb48965ddbe342@svr-chch-ex1.atlnz.lc>
References: <20190502031004.7125-1-chris.packham@alliedtelesis.co.nz>
 <20190504.004449.945185836330139212.davem@davemloft.net>
 <306471ba2dc54014a77b090d2cf6a7c7@svr-chch-ex1.atlnz.lc>
 <20190505205656.GA27130@rani.riverdale.lan>
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

On 6/05/19 8:57 AM, Arvind Sankar wrote:=0A=
> On Sun, May 05, 2019 at 08:20:14PM +0000, Chris Packham wrote:=0A=
>> On 4/05/19 4:45 PM, David Miller wrote:=0A=
>>> From: Chris Packham <chris.packham@alliedtelesis.co.nz>=0A=
>>> Date: Thu,  2 May 2019 15:10:04 +1200=0A=
>>>=0A=
>>>> TLV_SET is called with a data pointer and a len parameter that tells u=
s=0A=
>>>> how many bytes are pointed to by data. When invoking memcpy() we need=
=0A=
>>>> to careful to only copy len bytes.=0A=
>>>>=0A=
>>>> Previously we would copy TLV_LENGTH(len) bytes which would copy an ext=
ra=0A=
>>>> 4 bytes past the end of the data pointer which newer GCC versions=0A=
>>>> complain about.=0A=
>>>>=0A=
>>>>    In file included from test.c:17:=0A=
>>>>    In function 'TLV_SET',=0A=
>>>>        inlined from 'test' at test.c:186:5:=0A=
>>>>    /usr/include/linux/tipc_config.h:317:3:=0A=
>>>>    warning: 'memcpy' forming offset [33, 36] is out of the bounds [0, =
32]=0A=
>>>>    of object 'bearer_name' with type 'char[32]' [-Warray-bounds]=0A=
>>>>        memcpy(TLV_DATA(tlv_ptr), data, tlv_len);=0A=
>>>>        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=0A=
>>>>    test.c: In function 'test':=0A=
>>>>    test.c::161:10: note:=0A=
>>>>    'bearer_name' declared here=0A=
>>>>        char bearer_name[TIPC_MAX_BEARER_NAME];=0A=
>>>>             ^~~~~~~~~~~=0A=
>>>>=0A=
>>>> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>=0A=
>>>=0A=
>>> But now the pad bytes at the end are uninitialized.=0A=
>>>=0A=
>>> The whole idea is that the encapsulating TLV object has to be rounded=
=0A=
>>> up in size based upon the given 'len' for the data.=0A=
>>>=0A=
>>=0A=
>> TLV_LENGTH() does not account for any padding bytes due to the=0A=
>> alignment. TLV_SPACE() does but that wasn't used in the code before my=
=0A=
>> change.=0A=
>>=0A=
>> Are you suggesting something like this=0A=
>>=0A=
>>=0A=
>> -        if (len && data)=0A=
>> -               memcpy(TLV_DATA(tlv_ptr), data, tlv_len);=0A=
>> +        if (len && data) {=0A=
>> +               memcpy(TLV_DATA(tlv_ptr), data, len);=0A=
>> +               memset(TLV_DATA(tlv_ptr) + len, 0, TLV_SPACE(len) -=0A=
>> TLV_LENGTH(len));=0A=
>> +        }=0A=
>>=0A=
>>=0A=
> =0A=
> For zeroing out the padding, should that be done in TCM_SET in the same=
=0A=
> file as well? That one only copies data_len bytes but doesn't zero out=0A=
> any alignment padding.=0A=
> =0A=
=0A=
Thanks for pointing out TCM_SET it at least adds some weight to my =0A=
TLV_SET change.=0A=
=0A=
For both TLV_SET and TCM_SET both have the potential problem of SPACE - =0A=
LENGTH bytes being uninitialised. TCM_SET additionally has some reserved =
=0A=
bytes that aren't set either.=0A=
=0A=
Both of these could be solved with a memset(msg, 0, SPACE(data_len)); at =
=0A=
the start. I'm not sure what the performance impact of this would be but =
=0A=
trying to figure out the difference between SPACE and LENGTH plus the =0A=
pointer arithmetic wouldn't be free either.=0A=
