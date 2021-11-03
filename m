Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFE144464D
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 17:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbhKCQzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 12:55:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:51478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229894AbhKCQzq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 12:55:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80F6661053;
        Wed,  3 Nov 2021 16:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635958389;
        bh=J/ra1n98grRc6lMGiqPOQ/9x9bqlQ58qR8j6CXKXVjY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I7dCim+4lJ0ht9otBx8c9K4OQ8+0cDYEOJaRHqU8+Ms2gX9XCqVB9WUIZ+jJIxNHQ
         C1PmAHjvcfsCu5wHOMDWVvehch3ZpbTFu6QMbrGszcTx1l8kSwNyNchIHLtNX7Gb8j
         L1gdAw4PD9ynY+2qe2ilIAc3k2Li18sXlNoiKmtJqLQXbjA50FB/E/3vXr5CPGqDw7
         GSLvO4734bb7oAjpSWLNIUgZf3Fl+XCNj6pdXAxGbABi3BJdPq+xH4tf6VCNgsXtfa
         CL/jiMnbdKPMESYVjuW16o2g2N/3BdNLXtmQCvmApz2+A0iPFjIRwrJrQfqddUjWzs
         vArvUgLgmVn3w==
Date:   Wed, 3 Nov 2021 09:53:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     butt3rflyh4ck <butterflyhuangxx@gmail.com>
Cc:     mostrows@earthlink.net, "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Guillaume Nault <gnault@redhat.com>
Subject: Re: A kernel-infoleak bug in pppoe_getname() in
 drivers/net/ppp/pppoe.c
Message-ID: <20211103095308.7ff68a7f@kicinski-fedora-PC1C0HJN>
In-Reply-To: <CAFcO6XMgwuz97EJN+8jh9PJ9seaUbousDBOh9sduM6MZ6MRHxA@mail.gmail.com>
References: <CAFcO6XMgwuz97EJN+8jh9PJ9seaUbousDBOh9sduM6MZ6MRHxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Nov 2021 00:14:31 +0800 butt3rflyh4ck wrote:
> Hi, I report a kernel-infoleak bug in pppoe_getname()) in
> drivers/net/ppp/pppoe.c.
> And we can call getname ioctl to invoke pppoe_getname().
> 
> ###anaylze
> ```
> static int pppoe_getname(struct socket *sock, struct sockaddr *uaddr,
>   int peer)
> {
> int len = sizeof(struct sockaddr_pppox);
> struct sockaddr_pppox sp;    ///--->  define a 'sp' in stack but does
> not clear it
> 
> sp.sa_family = AF_PPPOX;   ///---> sp.sa_family is a short type, just

But the structure is marked as __packed.

> 2 byte sizes.
> sp.sa_protocol = PX_PROTO_OE;
> memcpy(&sp.sa_addr.pppoe, &pppox_sk(sock->sk)->pppoe_pa,
>        sizeof(struct pppoe_addr));
> 
> memcpy(uaddr, &sp, len);
> 
> return len;
> }
> ```
> There is an anonymous 2-byte hole after sa_family, make sure to clear it.
> 
> ###fix
> use memset() to clear the struct sockaddr_pppox sp.
> ```
> diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
> index 3619520340b7..fec328ad7202 100644
> --- a/drivers/net/ppp/pppoe.c
> +++ b/drivers/net/ppp/pppoe.c
> @@ -723,6 +723,11 @@ static int pppoe_getname(struct socket *sock,
> struct sockaddr *uaddr,
>         int len = sizeof(struct sockaddr_pppox);
>         struct sockaddr_pppox sp;
> 
> +       /* There is an anonymous 2-byte hole after sa_family,
> +        * make sure to clear it.
> +        */
> +       memset(&sp, 0, len);
> +
>         sp.sa_family    = AF_PPPOX;
>         sp.sa_protocol  = PX_PROTO_OE;
>         memcpy(&sp.sa_addr.pppoe, &pppox_sk(sock->sk)->pppoe_pa,
> ```
> The attachment is a patch.

