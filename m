Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705403B6F6D
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 10:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbhF2IcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 04:32:19 -0400
Received: from mail.fink.org ([79.134.252.20]:33152 "EHLO mail.fink.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232489AbhF2IcS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 04:32:18 -0400
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jun 2021 04:32:17 EDT
X-Footer: Zmluay5vcmc=
Received: from progrey.fink.org ([79.134.238.40])
        (authenticated user list@fink.org)
        by mail.fink.org (Kerio Connect 9.3.1 patch 1) with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Tue, 29 Jun 2021 10:23:51 +0200
Subject: Re: [PATCH net] sctp: prevent info leak in sctp_make_heartbeat()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <YNrXoNAiQama8Us8@mwanda>
From:   Andreas Fink <afink@list.fink.org>
Message-ID: <886e4daf-c239-c1ce-da52-4b4684449908@list.fink.org>
Date:   Tue, 29 Jun 2021 10:23:49 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:52.0)
 Gecko/20100101 PostboxApp/7.0.48
MIME-Version: 1.0
In-Reply-To: <YNrXoNAiQama8Us8@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Does that gcc extension work with all compilers, especially clang?

Dan Carpenter wrote on 29.06.21 10:19:
> The "hbinfo" struct has a 4 byte hole at the end so we have to zero it
> out to prevent stack information from being disclosed.
>
> Fixes: fe59379b9ab7 ("sctp: do the basic send and recv for PLPMTUD probe")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Btw = {} is the newest way to initialize holes.
>
> In the past we have debated whether = {} will *always* zero out struct
> holes and it wasn't clear from the C standard.  But it turns out that
> "= {}" is not part of the standard but is instead a GCC extension and it
> does clear the holes.  In GCC (not the C standard) then = {0}; is also
> supposed to initialize holes in there was a bug in one version where it
> didn't.
>
> So that's nice, because adding memset()s to zero everywhere was ugly.
>
>  net/sctp/sm_make_chunk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 587fb3cb88e2..3a290f620e96 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -1162,7 +1162,7 @@ struct sctp_chunk *sctp_make_new_encap_port(const struct sctp_association *asoc,
>  struct sctp_chunk *sctp_make_heartbeat(const struct sctp_association *asoc,
>  				       const struct sctp_transport *transport)
>  {
> -	struct sctp_sender_hb_info hbinfo;
> +	struct sctp_sender_hb_info hbinfo = {};
>  	struct sctp_chunk *retval;
>  
>  	retval = sctp_make_control(asoc, SCTP_CID_HEARTBEAT, 0,


