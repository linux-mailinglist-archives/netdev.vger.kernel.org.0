Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCFE209A43
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 09:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390123AbgFYHHv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jun 2020 03:07:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55238 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389406AbgFYHHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 03:07:50 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-D24BkyzOOzCvQI9FAp2mtQ-1; Thu, 25 Jun 2020 03:07:46 -0400
X-MC-Unique: D24BkyzOOzCvQI9FAp2mtQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB418107ACF6;
        Thu, 25 Jun 2020 07:07:44 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-113-132.ams2.redhat.com [10.36.113.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C402391D99;
        Thu, 25 Jun 2020 07:07:43 +0000 (UTC)
Date:   Thu, 25 Jun 2020 09:07:41 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     steffen.klassert@secunet.com, netdev@vger.kernel.org
Subject: Re: [PATCH ipsec-next v2 2/6] xfrm: replay: get rid of duplicated
 notification code
Message-ID: <20200625070741.GA2939559@bistromath.localdomain>
References: <20200624080804.7480-1-fw@strlen.de>
 <20200624080804.7480-3-fw@strlen.de>
MIME-Version: 1.0
In-Reply-To: <20200624080804.7480-3-fw@strlen.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

2020-06-24, 10:08:00 +0200, Florian Westphal wrote:
> After previous patch, we can consolidate some code:
> 
> xfrm_replay_notify, xfrm_replay_notify_bmp and _esn all contain the
> same code at the end.
> 
> Remove it from xfrm_replay_notify_bmp/esn and reuse the one
> in xfrm_replay_notify.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/xfrm/xfrm_replay.c | 22 ++++------------------
>  1 file changed, 4 insertions(+), 18 deletions(-)
> 
> diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
> index e42a7afb8ee5..fac2f3af4c1a 100644
> --- a/net/xfrm/xfrm_replay.c
> +++ b/net/xfrm/xfrm_replay.c
> @@ -56,10 +56,10 @@ void xfrm_replay_notify(struct xfrm_state *x, int event)
>  		break;
>  	case XFRM_REPLAY_MODE_BMP:
>  		xfrm_replay_notify_bmp(x, event);
> -		return;
> +		goto notify;
>  	case XFRM_REPLAY_MODE_ESN:
>  		xfrm_replay_notify_esn(x, event);
> -		return;
> +		goto notify;

These two functions have some early returns that skip the
notification, but now the notification will be sent in all cases:

	static void xfrm_replay_notify_bmp(struct xfrm_state *x, int event)
	{
		<snip>

		switch (event) {
		case XFRM_REPLAY_UPDATE:
			if (...) {
				if (x->xflags & XFRM_TIME_DEFER)
					event = XFRM_REPLAY_TIMEOUT;
				else
					return;
			}

			break;


And this also changes the value that ends up in c.data.aevent. That
change will be lost after this patch.

>  	}
>  
>  	switch (event) {
> @@ -86,6 +86,8 @@ void xfrm_replay_notify(struct xfrm_state *x, int event)
>  	}
>  
>  	memcpy(&x->preplay, &x->replay, sizeof(struct xfrm_replay_state));
> +
> +notify:
>  	c.event = XFRM_MSG_NEWAE;
>  	c.data.aevent = event;
>  	km_state_notify(x, &c);

-- 
Sabrina

