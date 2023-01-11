Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE023665676
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 09:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbjAKIuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 03:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbjAKIuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 03:50:14 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92250DF1F;
        Wed, 11 Jan 2023 00:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673427014; x=1704963014;
  h=references:from:to:cc:subject:date:in-reply-to:
   message-id:mime-version:content-transfer-encoding;
  bh=ikQdH8m796ihx32dJUgR1hV1YKER/WpBzoyYK0/iPXE=;
  b=Ar+Y/igd97NTRl5y/sqSLcqJOmyJ+iJkEfYdcDpqdY4dxN3HlhJMbbAh
   WwKBvlLuMl88dLOFIAdDN9vhXrwKRVypJgioiK24oloOKIgUXOWEQ5ED1
   4shygitr5idsJXVYmJx8oMXNz9pLyUQvBWqwEneyJJ+ImUUxGXViEVAjp
   E=;
X-IronPort-AV: E=Sophos;i="5.96,315,1665446400"; 
   d="scan'208";a="285453292"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-bbc6e425.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 08:50:10 +0000
Received: from EX13D27EUB004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-bbc6e425.us-east-1.amazon.com (Postfix) with ESMTPS id 9216381161;
        Wed, 11 Jan 2023 08:50:05 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX13D27EUB004.ant.amazon.com (10.43.166.152) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 11 Jan 2023 08:50:05 +0000
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.43.162.56) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.7; Wed, 11 Jan 2023 08:49:57 +0000
References: <20230108143843.2987732-1-trix@redhat.com>
 <CANn89iLFtrQm-E5BRwgKFw4xRZiOOdWg-WTFi5eZsg7ycq2szg@mail.gmail.com>
 <pj41zlpmbmba16.fsf@u570694869fb251.ant.amazon.com>
 <db824c89-13f2-3349-9dd0-0fb7559c6273@redhat.com>
User-agent: mu4e 1.6.10; emacs 28.0.91
From:   Shay Agroskin <shayagr@amazon.com>
To:     Tom Rix <trix@redhat.com>
CC:     Eric Dumazet <edumazet@google.com>, <akiyano@amazon.com>,
        <darinzon@amazon.com>, <ndagan@amazon.com>, <saeedb@amazon.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <nathan@kernel.org>, <ndesaulniers@google.com>, <khalasa@piap.pl>,
        <wsa+renesas@sang-engineering.com>, <yuancan@huawei.com>,
        <tglx@linutronix.de>, <42.hyeyoo@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <llvm@lists.linux.dev>
Subject: Re: [PATCH] net: ena: initialize dim_sample
Date:   Wed, 11 Jan 2023 10:46:50 +0200
In-Reply-To: <db824c89-13f2-3349-9dd0-0fb7559c6273@redhat.com>
Message-ID: <pj41zllem9bglr.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.43.162.56]
X-ClientProxiedBy: EX13D27UWA003.ant.amazon.com (10.43.160.56) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Tom Rix <trix@redhat.com> writes:

> On 1/10/23 8:58 AM, Shay Agroskin wrote:
>>
>> Eric Dumazet <edumazet@google.com> writes:
>>
>>> On Sun, Jan 8, 2023 at 3:38 PM Tom Rix <trix@redhat.com>=20
>>> wrote:
>>>>
>>>> clang static analysis reports this problem
>>>> drivers/net/ethernet/amazon/ena/ena_netdev.c:1821:2: warning:
>>>> Passed-by-value struct
>>>> =C2=A0 argument contains uninitialized data (e.g., field:=20
>>>> 'comp_ctr')
>>>> [core.CallAndMessage]
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 net_dim(&ena_napi->dim, dim=
_sample);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~
>>>>
>>>> net_dim can call dim_calc_stats() which uses the comp_ctr=20
>>>> element,
>>>> so it must be initialized.
>>>
>>> This seems to be a dim_update_sample() problem really, when=20
>>> comp_ctr
>>> has been added...
>>>
>>> Your patch works, but we could avoid pre-initializing=20
>>> dim_sample in
>>> all callers,
>>> then re-writing all but one field...
>>>
>>> diff --git a/include/linux/dim.h b/include/linux/dim.h
>>> index
>>> 6c5733981563eadf5f06c59c5dc97df961692b02..4604ced4517268ef8912cd8053ac8=
f4d2630f977
>>> 100644
>>> --- a/include/linux/dim.h
>>> +++ b/include/linux/dim.h
>>> @@ -254,6 +254,7 @@ dim_update_sample(u16 event_ctr, u64=20
>>> packets, u64
>>> bytes, struct dim_sample *s)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 s->pkt_ctr=C2=A0=C2=A0 =3D p=
ackets;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 s->byte_ctr=C2=A0 =3D bytes;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 s->event_ctr =3D event_ctr;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 s->comp_ctr=C2=A0 =3D 0;
>>> =C2=A0}
>>>
>>> =C2=A0/**
>>
>> Hi,
>>
>> I'd rather go with Eric's solution to this issue than zero the=20
>> whole
>> struct in ENA
>
> Please look at the other callers of dim_update_sample.=C2=A0 The=20
> common
> pattern is to initialize the struct.
>
> This alternative will work, but the pattern of initializing the=20
> struct
> the other (~20) callers should be refactored.
>
> Tom
>

While Eric's patch might be bigger if you also remove the=20
pre-initialization in the other drivers, the Linux code itself=20
would be smaller (granted not significantly) and
it make less room for pitfalls in adding DIM support in other=20
drivers.

Is there a good argument against using Eric's patch other than=20
'the other patch would be bigger' ?

Shay

>>
>> Thanks,
>> Shay
>>

