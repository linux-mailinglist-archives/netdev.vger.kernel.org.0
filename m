Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61047DC9FB
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 17:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394066AbfJRP4x convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 18 Oct 2019 11:56:53 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:31758 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726506AbfJRP4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 11:56:53 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id uk-mta-3-mj2RpJsmO5m7JJzP7Fxiaw-1;
 Fri, 18 Oct 2019 16:56:50 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 18 Oct 2019 16:56:49 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 18 Oct 2019 16:56:49 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Xin Long' <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
CC:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCHv3 net-next 1/5] sctp: add SCTP_ADDR_POTENTIALLY_FAILED
 notification
Thread-Topic: [PATCHv3 net-next 1/5] sctp: add SCTP_ADDR_POTENTIALLY_FAILED
 notification
Thread-Index: AQHVgla8fu139gUWN06qp6czSulnBKdgkqoQ
Date:   Fri, 18 Oct 2019 15:56:49 +0000
Message-ID: <fb115b1444764b3eacdf69ebd9cf9681@AcuMS.aculab.com>
References: <cover.1571033544.git.lucien.xin@gmail.com>
 <7d08b42f4c1480caa855776d92331fe9beed001d.1571033544.git.lucien.xin@gmail.com>
In-Reply-To: <7d08b42f4c1480caa855776d92331fe9beed001d.1571033544.git.lucien.xin@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: mj2RpJsmO5m7JJzP7Fxiaw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've found v3 :-)
But it isn't that much better than v2.

From: Xin Long
> Sent: 14 October 2019 07:15
> SCTP Quick failover draft section 5.1, point 5 has been removed
> from rfc7829. Instead, "the sender SHOULD (i) notify the Upper
> Layer Protocol (ULP) about this state transition", as said in
> section 3.2, point 8.
> 
> So this patch is to add SCTP_ADDR_POTENTIALLY_FAILED, defined
> in section 7.1, "which is reported if the affected address
> becomes PF". Also remove transport cwnd's update when moving
> from PF back to ACTIVE , which is no longer in rfc7829 either.
> 
> v1->v2:
>   - no change
> v2->v3:
>   - define SCTP_ADDR_PF SCTP_ADDR_POTENTIALLY_FAILED
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/uapi/linux/sctp.h |  2 ++
>  net/sctp/associola.c      | 17 ++++-------------
>  2 files changed, 6 insertions(+), 13 deletions(-)
> 
> diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> index 6bce7f9..f4ab7bb 100644
> --- a/include/uapi/linux/sctp.h
> +++ b/include/uapi/linux/sctp.h
> @@ -410,6 +410,8 @@ enum sctp_spc_state {
>  	SCTP_ADDR_ADDED,
>  	SCTP_ADDR_MADE_PRIM,
>  	SCTP_ADDR_CONFIRMED,
> +	SCTP_ADDR_POTENTIALLY_FAILED,
> +#define SCTP_ADDR_PF	SCTP_ADDR_POTENTIALLY_FAILED
>  };
> 
> 
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 1ba893b..4f9efba 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -801,14 +801,6 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
>  			spc_state = SCTP_ADDR_CONFIRMED;
>  		else
>  			spc_state = SCTP_ADDR_AVAILABLE;
> -		/* Don't inform ULP about transition from PF to
> -		 * active state and set cwnd to 1 MTU, see SCTP
> -		 * Quick failover draft section 5.1, point 5
> -		 */
> -		if (transport->state == SCTP_PF) {
> -			ulp_notify = false;
> -			transport->cwnd = asoc->pathmtu;
> -		}

This is wrong.
If the old state is PF and the application hasn't exposed PF the event should be
ignored.

>  		transport->state = SCTP_ACTIVE;
>  		break;
> 
> @@ -817,19 +809,18 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
>  		 * to inactive state.  Also, release the cached route since
>  		 * there may be a better route next time.
>  		 */
> -		if (transport->state != SCTP_UNCONFIRMED)
> +		if (transport->state != SCTP_UNCONFIRMED) {
>  			transport->state = SCTP_INACTIVE;
> -		else {
> +			spc_state = SCTP_ADDR_UNREACHABLE;
> +		} else {
>  			sctp_transport_dst_release(transport);
>  			ulp_notify = false;
>  		}
> -
> -		spc_state = SCTP_ADDR_UNREACHABLE;
>  		break;
> 
>  	case SCTP_TRANSPORT_PF:
>  		transport->state = SCTP_PF;
> -		ulp_notify = false;

Again the event should be supressed if PF isn't exposed.

> +		spc_state = SCTP_ADDR_POTENTIALLY_FAILED;
>  		break;
> 
>  	default:
> --
> 2.1.0

I also haven't spotted where the test that the application has actually enabled
state transition events is in the code.
I'd have thought it would be anything is built and allocated.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

