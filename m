Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87EAAAEB52
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 15:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732101AbfIJNT0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 10 Sep 2019 09:19:26 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:23347 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725935AbfIJNTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 09:19:25 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-123-QuiXHtS5M4SMgtHxCJ9lwg-1; Tue, 10 Sep 2019 14:19:21 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 10 Sep 2019 14:19:21 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 10 Sep 2019 14:19:21 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Xin Long' <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
CC:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH net-next 5/5] sctp: add spt_pathcpthld in struct
 sctp_paddrthlds
Thread-Topic: [PATCH net-next 5/5] sctp: add spt_pathcpthld in struct
 sctp_paddrthlds
Thread-Index: AQHVZuRCrtt5derbnkaX0GdcwfdxAKck5i9w
Date:   Tue, 10 Sep 2019 13:19:21 +0000
Message-ID: <9fc7ca1598e641cda3914840a4416aab@AcuMS.aculab.com>
References: <cover.1568015756.git.lucien.xin@gmail.com>
 <604e6ac718c29aa5b1a8c4b164a126b82bc42a2f.1568015756.git.lucien.xin@gmail.com>
In-Reply-To: <604e6ac718c29aa5b1a8c4b164a126b82bc42a2f.1568015756.git.lucien.xin@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: QuiXHtS5M4SMgtHxCJ9lwg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long
> Sent: 09 September 2019 08:57
> Section 7.2 of rfc7829: "Peer Address Thresholds (SCTP_PEER_ADDR_THLDS)
> Socket Option" extends 'struct sctp_paddrthlds' with 'spt_pathcpthld'
> added to allow a user to change ps_retrans per sock/asoc/transport, as
> other 2 paddrthlds: pf_retrans, pathmaxrxt.
> 
> Note that ps_retrans is not allowed to be greater than pf_retrans.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/uapi/linux/sctp.h |  1 +
>  net/sctp/socket.c         | 10 ++++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> index a15cc28..dfd81e1 100644
> --- a/include/uapi/linux/sctp.h
> +++ b/include/uapi/linux/sctp.h
> @@ -1069,6 +1069,7 @@ struct sctp_paddrthlds {
>  	struct sockaddr_storage spt_address;
>  	__u16 spt_pathmaxrxt;
>  	__u16 spt_pathpfthld;
> +	__u16 spt_pathcpthld;
>  };
> 
>  /*
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 5e2098b..5b9774d 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -3954,6 +3954,9 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,

This code does:
	if (optlen < sizeof(struct sctp_paddrthlds))
		return -EINVAL;

So adding an extra field breaks existing application binaries
that use this option.

I've not checked the other patches or similar fubar.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

