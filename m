Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E97D9DC8D5
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 17:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392802AbfJRPeo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 18 Oct 2019 11:34:44 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:59458 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389582AbfJRPeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 11:34:44 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-167-cKzciky-MNq8KxeuKcqTzA-1; Fri, 18 Oct 2019 16:34:40 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 18 Oct 2019 16:34:39 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 18 Oct 2019 16:34:39 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Xin Long' <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
CC:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCHv2 net-next 2/5] sctp: add pf_expose per netns and sock and
 asoc
Thread-Topic: [PATCHv2 net-next 2/5] sctp: add pf_expose per netns and sock
 and asoc
Thread-Index: AQHVfcscH+sPaksZF0uqjgObulWL8KdglgNw
Date:   Fri, 18 Oct 2019 15:34:39 +0000
Message-ID: <0779b5aeb9a84b4692b08be7478e0373@AcuMS.aculab.com>
References: <cover.1570533716.git.lucien.xin@gmail.com>
 <8fcf707443f7218d3fb131b827c679f423c5ecaf.1570533716.git.lucien.xin@gmail.com>
In-Reply-To: <8fcf707443f7218d3fb131b827c679f423c5ecaf.1570533716.git.lucien.xin@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: cKzciky-MNq8KxeuKcqTzA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long
> Sent: 08 October 2019 12:25
> As said in rfc7829, section 3, point 12:
> 
>   The SCTP stack SHOULD expose the PF state of its destination
>   addresses to the ULP as well as provide the means to notify the
>   ULP of state transitions of its destination addresses from
>   active to PF, and vice versa.  However, it is recommended that
>   an SCTP stack implementing SCTP-PF also allows for the ULP to be
>   kept ignorant of the PF state of its destinations and the
>   associated state transitions, thus allowing for retention of the
>   simpler state transition model of [RFC4960] in the ULP.
> 
> Not only does it allow to expose the PF state to ULP, but also
> allow to ignore sctp-pf to ULP.
> 
> So this patch is to add pf_expose per netns, sock and asoc. And in
> sctp_assoc_control_transport(), ulp_notify will be set to false if
> asoc->expose is not set.
> 
> It also allows a user to change pf_expose per netns by sysctl, and
> pf_expose per sock and asoc will be initialized with it.
> 
> Note that pf_expose also works for SCTP_GET_PEER_ADDR_INFO sockopt,
> to not allow a user to query the state of a sctp-pf peer address
> when pf_expose is not enabled, as said in section 7.3.
...
> index 08d14d8..a303011 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c
> @@ -1220,6 +1220,9 @@ static int __net_init sctp_defaults_init(struct net *net)
>  	/* Enable pf state by default */
>  	net->sctp.pf_enable = 1;
> 
> +	/* Enable pf state exposure by default */
> +	net->sctp.pf_expose = 1;
> +

For compatibility with existing applications pf_expose MUST default to 0.
I'm not even sure it makes sense to have a sysctl for it.

...
> @@ -5521,8 +5522,15 @@ static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
> 
>  	transport = sctp_addr_id2transport(sk, &pinfo.spinfo_address,
>  					   pinfo.spinfo_assoc_id);
> -	if (!transport)
> -		return -EINVAL;
> +	if (!transport) {
> +		retval = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (transport->state == SCTP_PF && !transport->asoc->pf_expose) {
> +		retval = -EACCES;
> +		goto out;
> +	}

Ugg...
To avoid reporting the unexpected 'SCTP_PF' state you probable need
to lie about the state (probably reporting 'working' - or whatever state
it would be in if PF detection wasn't enabled.

...
> --- a/net/sctp/sysctl.c
> +++ b/net/sctp/sysctl.c
> @@ -318,6 +318,13 @@ static struct ctl_table sctp_net_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec,
>  	},
> +	{
> +		.procname	= "pf_expose",
> +		.data		= &init_net.sctp.pf_expose,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec,
> +	},

Setting this will break existing applications.
So I don't think the default should be settable.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

