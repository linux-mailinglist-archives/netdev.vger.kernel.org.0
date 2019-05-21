Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0CA825375
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 17:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbfEUPFi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 May 2019 11:05:38 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:42152 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728901AbfEUPFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 11:05:37 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-21-_M09KjGmMdmqceX7-0YdFg-1; Tue, 21 May 2019 16:05:32 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Tue,
 21 May 2019 16:05:31 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 21 May 2019 16:05:31 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Chang-Hsien Tsai' <luke.tw@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>
Subject: RE: [PATCH] samples: bpf: fix: change the buffer size for read()
Thread-Topic: [PATCH] samples: bpf: fix: change the buffer size for read()
Thread-Index: AQHVDmrXJNlfWPhJGUGAbU++g5yjzKZ1sAZw
Date:   Tue, 21 May 2019 15:05:31 +0000
Message-ID: <bf57f48d5318450b95746f9f91418153@AcuMS.aculab.com>
References: <20190519090544.26971-1-luke.tw@gmail.com>
In-Reply-To: <20190519090544.26971-1-luke.tw@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: _M09KjGmMdmqceX7-0YdFg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chang-Hsien Tsai
> Sent: 19 May 2019 10:06
> If the trace for read is larger than 4096,
> the return value sz will be 4096.
> This results in off-by-one error on buf.
> 
>     static char buf[4096];
>     ssize_t sz;
> 
>     sz = read(trace_fd, buf, sizeof(buf));
>     if (sz > 0) {
>         buf[sz] = 0;
>         puts(buf);
>     }
> 
> Signed-off-by: Chang-Hsien Tsai <luke.tw@gmail.com>
> ---
>  samples/bpf/bpf_load.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/samples/bpf/bpf_load.c b/samples/bpf/bpf_load.c
> index eae7b635343d..d4da90070b58 100644
> --- a/samples/bpf/bpf_load.c
> +++ b/samples/bpf/bpf_load.c
> @@ -678,7 +678,7 @@ void read_trace_pipe(void)
>  		static char buf[4096];
>  		ssize_t sz;
> 
> -		sz = read(trace_fd, buf, sizeof(buf));
> +		sz = read(trace_fd, buf, sizeof(buf)-1);
>  		if (sz > 0) {
>  			buf[sz] = 0;
>  			puts(buf);

Why not change the puts() to fwrite(buf, sz, 1, stdout) ?
Then you don't need the '\0' terminator.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

