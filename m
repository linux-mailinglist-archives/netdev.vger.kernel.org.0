Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1F514D90A
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 11:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbgA3Keg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 05:34:36 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:53868 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727219AbgA3Kee (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 05:34:34 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id EAB3020491
        for <netdev@vger.kernel.org>; Thu, 30 Jan 2020 11:34:32 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EjfZ30Mzb9EJ for <netdev@vger.kernel.org>;
        Thu, 30 Jan 2020 11:34:32 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8413520322
        for <netdev@vger.kernel.org>; Thu, 30 Jan 2020 11:34:32 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 30 Jan 2020
 11:34:32 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 33B303180220;
 Thu, 30 Jan 2020 11:34:32 +0100 (CET)
Date:   Thu, 30 Jan 2020 11:34:32 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Thomas Egerer <thomas.egerer@secunet.com>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH net] xfrm: Interpret XFRM_INF as 32 bit value for non-ESN
 states
Message-ID: <20200130103432.GK27973@gauss3.secunet.de>
References: <8a3e5a49-5906-b6a6-beb7-0479bc64dcd0@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8a3e5a49-5906-b6a6-beb7-0479bc64dcd0@secunet.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 03:31:14PM +0100, Thomas Egerer wrote:
> Currently, when left unconfigured, hard and soft packet limit are set to
> XFRM_INF ((__u64)~0). This can be problematic for non-ESN states, as
> their 'natural' packet limit is 2^32 - 1 packets. When reached, instead
> of creating an expire event, the states become unusable and increase
> their respective 'state expired' counter in the xfrm statistics. The
> only way for them to actually expire is based on their lifetime limits.
> 
> This patch reduces the packet limit of non-ESN states with XFRM_INF as
> their soft/hard packet limit to their maximum achievable sequence
> number in order to trigger an expire, which can then be used by an IKE
> daemon to reestablish the connection.
> 
> Signed-off-by: Thomas Egerer <thomas.egerer@secunet.com>
> ---
>  net/xfrm/xfrm_user.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
> index b88ba45..84d4008 100644
> --- a/net/xfrm/xfrm_user.c
> +++ b/net/xfrm/xfrm_user.c
> @@ -505,6 +505,13 @@ static void copy_from_user_state(struct xfrm_state *x, struct xfrm_usersa_info *
>  
>  	if (!x->sel.family && !(p->flags & XFRM_STATE_AF_UNSPEC))
>  		x->sel.family = p->family;
> +
> +	if ((x->props.flags & XFRM_STATE_ESN) == 0 {

You need one more close bracket here:

/home/klassert/git/ipsec/net/xfrm/xfrm_user.c: In function ‘copy_from_user_state’:
/home/klassert/git/ipsec/net/xfrm/xfrm_user.c:509:45: error: expected ‘)’ before ‘{’ token
  if ((x->props.flags & XFRM_STATE_ESN) == 0 {
                                             ^
/home/klassert/git/ipsec/net/xfrm/xfrm_user.c:515:1: error: expected expression before ‘}’ token
 }
 ^

Please fix and resend.

Thanks.
