Return-Path: <netdev+bounces-8927-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68639726515
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:54:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8AF11C20D8F
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:54:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC1A2370EE;
	Wed,  7 Jun 2023 15:54:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A185934D94
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 15:54:14 +0000 (UTC)
X-Greylist: delayed 2539 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 07 Jun 2023 08:54:11 PDT
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8034719AE
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:54:11 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-SKSmLqLxPKCDpAD3Rt-ZTg-1; Wed, 07 Jun 2023 11:00:28 -0400
X-MC-Unique: SKSmLqLxPKCDpAD3Rt-ZTg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 529DE28015B2;
	Wed,  7 Jun 2023 15:00:27 +0000 (UTC)
Received: from hog (unknown [10.45.224.200])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A22DB492B00;
	Wed,  7 Jun 2023 15:00:25 +0000 (UTC)
Date: Wed, 7 Jun 2023 17:00:23 +0200
From: Sabrina Dubroca <sd@queasysnail.net>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Cc: Simon Horman <simon.horman@corigine.com>,
	Linux Network Development Mailing List <netdev@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Benedict Wong <benedictwong@google.com>,
	Yan Yan <evitayan@google.com>
Subject: Re: [PATCH v2] xfrm: fix inbound ipv4/udp/esp packets to UDPv6
 dualstack sockets
Message-ID: <ZICbhz1PqGU3I408@hog>
References: <20221026083203.2214468-1-zenczykowski@gmail.com>
 <20230605110654.809655-1-maze@google.com>
 <ZH3cN8IIJ1fhlsUW@corigine.com>
 <CANP3RGfWATmOzb4=DXb=+K7iij4HPBp0Uq79r0NjxGyvAaKNgA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CANP3RGfWATmOzb4=DXb=+K7iij4HPBp0Uq79r0NjxGyvAaKNgA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

2023-06-06, 06:38:04 +0900, Maciej =C5=BBenczykowski wrote:
> On Mon, Jun 5, 2023 at 9:59=E2=80=AFPM Simon Horman <simon.horman@corigin=
e.com> wrote:
> > Hi Maciej,
> >
> > Does the opposite case also need to be handled in xfrm4_udp_encap_rcv()=
?
>=20
> I believe the answer is no:
> - ipv4 (AF_INET) sockets only ever receive (native) ipv4 traffic.
> - ipv6 (AF_INET6) ipv6-only sockets only ever receive (native) ipv6 traff=
ic.
> - ipv6 (AF_INET6) dualstack (ie. not ipv6-only) sockets can receive
> both (native) ipv4 and (native) ipv6 traffic.
>=20
> Ipv6 dualstack sockets map the ipv4 address space into the IPv6
> "IPv4-mapped" range of ::ffff:0.0.0.0/96,
> ie. 1.2.3.4 -> ::ffff:1.2.3.4 aka ::ffff:0102:0304
>=20
> Whether ipv6 sockets default to dualstack or not is controlled by a
> sysctl (net.ipv6.bindv6only - not entirely well named, it actually
> affects the socket() system call, and bind() only as a later
> consequence of that, it thus does also affect whether connect() to
> ipv4 mapped addresses works or not), but can also be toggled manually
> via IPV6_V6ONLY socket option.
>=20
> Basically a dualstack ipv6 socket is a more-or-less drop-in
> replacement for ipv4 sockets (*entirely* so for TCP/UDP, and likely
> SCTP, DCCP & UDPLITE, though I think there might be some edge cases
> like ICMP sockets or RAW sockets that do need AF_INET - any such
> exceptions should probably be considered kernel bugs / missing
> features -> hence this patch).
>=20
> ---
>=20
> I believe we don't need to test the sk for:
>   !ipv6_only_sock(sk), ie. !sk->sk_ipv6only
> before we do the dispatch to the v4 code path,
> because if the socket is ipv6-only then there should [IMHO/AFAICT] be
> no way for ipv4 packets to arrive here in the first place.
>=20
> ---
>=20
> Note: I can guarantee the currently existing code is wrong,
> both because we've experimentally discovered AF_INET6 dualstack
> sockets don't work for v4,
> and because the code obviously tries to read payload length from the
> ipv6 header,
> which of course doesn't exist for skb->protocol ETH_P_IP packets.
>=20
> However, I'm still not entirely sure this patch is 100% bug free...
> though it seems straightforward enough...

Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>

Thanks Maciej.

--=20
Sabrina


