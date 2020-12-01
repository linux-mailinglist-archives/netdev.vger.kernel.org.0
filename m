Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26D02CA7CE
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 17:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392101AbgLAQK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 11:10:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54585 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388182AbgLAQK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 11:10:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606838970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hLqVxjcStzpNiF08tbsyS3QuxJVq8CqTw3nkGbV3M3o=;
        b=ABCBMxAAIHZnsA9FaPBGZ9rijBVScOtPoU47cgrHYhGcmne6cawwRIRlshYNQrgjQXwBGF
        HoI1IuxGEFkEs2ZmFUq7CKtpC7l3nR4+1sbrngVNeh3W0fAq2MwYcnudlkh1zctdYWMbCP
        BAjF8DyQMDuExJw7JxG0c4ix0tYuYIw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-QAN0Qd75NFKdOOaNVmetYg-1; Tue, 01 Dec 2020 11:09:28 -0500
X-MC-Unique: QAN0Qd75NFKdOOaNVmetYg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90076AFA80;
        Tue,  1 Dec 2020 16:09:26 +0000 (UTC)
Received: from carbon (unknown [10.36.110.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9226A60854;
        Tue,  1 Dec 2020 16:09:20 +0000 (UTC)
Date:   Tue, 1 Dec 2020 17:09:19 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Leesoo Ahn <dev@ooseel.net>
Cc:     brouer@redhat.com, lsahn@ooseel.net,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: xdp: Give compiler __always_inline hint for
 xdp_rxq_info_init()
Message-ID: <20201201170919.08934eed@carbon>
In-Reply-To: <20201130114825.10898-1-lsahn@ooseel.net>
References: <20201130114825.10898-1-lsahn@ooseel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 20:48:25 +0900
Leesoo Ahn <dev@ooseel.net> wrote:

> The function has only a statement of calling memset() to
> clear xdp_rxq object. Let it always be an inline function.

No, this is the wrong approach.

The function is already "static", and the compiler have likely already
inlined this code, but we leave it up to the compiler to choose.
Besides this is slowpath code, why are you even trying to optimize this?

 
> Signed-off-by: Leesoo Ahn <lsahn@ooseel.net>
> ---
>  net/core/xdp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 48aba933a5a8..dab72b9a71a1 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -151,7 +151,7 @@ void xdp_rxq_info_unreg(struct xdp_rxq_info *xdp_rxq)
>  }
>  EXPORT_SYMBOL_GPL(xdp_rxq_info_unreg);
>  
> -static void xdp_rxq_info_init(struct xdp_rxq_info *xdp_rxq)
> +static __always_inline void xdp_rxq_info_init(struct xdp_rxq_info *xdp_rxq)
>  {
>  	memset(xdp_rxq, 0, sizeof(*xdp_rxq));
>  }



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

