Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE63231B21
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 10:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgG2IW1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Jul 2020 04:22:27 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:35093 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726336AbgG2IW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 04:22:27 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-266-Lc9u-frSMPqs63oowZ_ntQ-1; Wed, 29 Jul 2020 09:22:23 +0100
X-MC-Unique: Lc9u-frSMPqs63oowZ_ntQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 29 Jul 2020 09:22:22 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 29 Jul 2020 09:22:22 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christoph Hellwig' <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>
CC:     Jan Engelhardt <jengelh@inai.de>, Ido Schimmel <idosch@idosch.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 4/4] net: improve the user pointer check in
 init_user_sockptr
Thread-Topic: [PATCH 4/4] net: improve the user pointer check in
 init_user_sockptr
Thread-Index: AQHWZP2RVAfIUnVwRE6QL/zdEP2h6akeNCoA
Date:   Wed, 29 Jul 2020 08:22:22 +0000
Message-ID: <f945879557b24678916f15fbc97150ba@AcuMS.aculab.com>
References: <20200728163836.562074-1-hch@lst.de>
 <20200728163836.562074-5-hch@lst.de>
In-Reply-To: <20200728163836.562074-5-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig
> Sent: 28 July 2020 17:39
> 
> Make sure not just the pointer itself but the whole range lies in
> the user address space.  For that pass the length and then use
> the access_ok helper to do the check.

Now that the address is never changed it is enough to check the
base address (although this would be slightly safer if sockaddr_t
were 'const').
This is especially true given some code paths ignore the length
(so the length must be checked later - which it will be).

Isn't TASK_SIZE the wrong 'constant'.
Looks pretty 'heavy' on x86-64.
You just need something between valid user and valid kernel addresses.
So (1ull << 63) is fine on x86-64 (and probably all 64bit with
non-overlapping user/kernel addresses).
For i386 you need (3ul << 30) - probably also common.

	David

> 
> Fixes: 6d04fe15f78a ("net: optimize the sockptr_t for unified kernel/user address spaces")
> Reported-by: David Laight <David.Laight@ACULAB.COM>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/sockptr.h     | 18 ++++++------------
>  net/ipv4/bpfilter/sockopt.c |  2 +-
>  net/socket.c                |  2 +-
>  3 files changed, 8 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/sockptr.h b/include/linux/sockptr.h
> index 9e6c81d474cba8..96840def9d69cc 100644
> --- a/include/linux/sockptr.h
> +++ b/include/linux/sockptr.h
> @@ -27,14 +27,6 @@ static inline sockptr_t KERNEL_SOCKPTR(void *p)
>  {
>  	return (sockptr_t) { .kernel = p };
>  }
> -
> -static inline int __must_check init_user_sockptr(sockptr_t *sp, void __user *p)
> -{
> -	if ((unsigned long)p >= TASK_SIZE)
> -		return -EFAULT;
> -	sp->user = p;
> -	return 0;
> -}
>  #else /* CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE */
>  typedef struct {
>  	union {
> @@ -53,14 +45,16 @@ static inline sockptr_t KERNEL_SOCKPTR(void *p)
>  {
>  	return (sockptr_t) { .kernel = p, .is_kernel = true };
>  }
> +#endif /* CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE */
> 
> -static inline int __must_check init_user_sockptr(sockptr_t *sp, void __user *p)
> +static inline int __must_check init_user_sockptr(sockptr_t *sp, void __user *p,
> +		size_t size)
>  {
> -	sp->user = p;
> -	sp->is_kernel = false;
> +	if (!access_ok(p, size))
> +		return -EFAULT;
> +	*sp = (sockptr_t) { .user = p };
>  	return 0;
>  }
> -#endif /* CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE */
> 
>  static inline bool sockptr_is_null(sockptr_t sockptr)
>  {
> diff --git a/net/ipv4/bpfilter/sockopt.c b/net/ipv4/bpfilter/sockopt.c
> index 94f18d2352d007..545b2640f0194d 100644
> --- a/net/ipv4/bpfilter/sockopt.c
> +++ b/net/ipv4/bpfilter/sockopt.c
> @@ -65,7 +65,7 @@ int bpfilter_ip_get_sockopt(struct sock *sk, int optname,
> 
>  	if (get_user(len, optlen))
>  		return -EFAULT;
> -	err = init_user_sockptr(&optval, user_optval);
> +	err = init_user_sockptr(&optval, user_optval, len);
>  	if (err)
>  		return err;
>  	return bpfilter_mbox_request(sk, optname, optval, len, false);
> diff --git a/net/socket.c b/net/socket.c
> index 94ca4547cd7c53..aff52e81653ce3 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -2105,7 +2105,7 @@ int __sys_setsockopt(int fd, int level, int optname, char __user *user_optval,
>  	if (optlen < 0)
>  		return -EINVAL;
> 
> -	err = init_user_sockptr(&optval, user_optval);
> +	err = init_user_sockptr(&optval, user_optval, optlen);
>  	if (err)
>  		return err;
> 
> --
> 2.27.0

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

