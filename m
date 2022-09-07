Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B505B014E
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 12:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiIGKIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 06:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiIGKI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 06:08:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90B1B07E8;
        Wed,  7 Sep 2022 03:08:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 879F76185F;
        Wed,  7 Sep 2022 10:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA523C433C1;
        Wed,  7 Sep 2022 10:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662545307;
        bh=dP9xemqn6VbnteZEmIn3ds2pIeYUmDTcWHEmiXzGBTk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Xi+zWNl38ktfZCKaIUaOuBtI3xHQV5b6MmHRUDjUig8Om3/TXY0VNI+pk5plfcCq4
         NXZEdvYpzKspgBrw59t4Tl638/GAQIYcmaor0Kgnh3pATHhuIvrVpUrI2xye8tLXDM
         81ixy8JsORoIQmmHMfwbSCJlmrY93lcbnDYBIak2LZkWwrqhEK4YtyFhgDX2yrKVlW
         Il3v/E33aIQ0X4cF1z8bXahMi5W0ivMy4SjNwzT12KkUEKKP+nJQm096Nnz0rV798X
         RaFD06sQUbOOyUteNygK59B2cVcvS1gKUMUmNxK5ztx18yxmvV5dJg1db/dPZcnPS1
         1WDRNSTvQXi+Q==
Message-ID: <1e0877bc528f3e9218f0070889c7288a8aaa47ba.camel@kernel.org>
Subject: Re: [PATCH] SUNRPC: Fix potential memory leak in
 xs_udp_send_request()
From:   Jeff Layton <jlayton@kernel.org>
To:     Jianglei Nie <niejianglei2021@163.com>, chuck.lever@oracle.com,
        trond.myklebust@hammerspace.com, anna@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 07 Sep 2022 06:08:25 -0400
In-Reply-To: <20220907071338.56969-1-niejianglei2021@163.com>
References: <20220907071338.56969-1-niejianglei2021@163.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-09-07 at 15:13 +0800, Jianglei Nie wrote:
> xs_udp_send_request() allocates a memory chunk for xdr->bvec with
> xdr_alloc_bvec(). When xprt_sock_sendmsg() finishs, xdr->bvec is not
> released, which will lead to a memory leak.
>=20
> we should release the xdr->bvec with xdr_free_bvec() after
> xprt_sock_sendmsg() like bc_sendto() does.
>=20
> Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
> ---
>  net/sunrpc/xprtsock.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
> index e976007f4fd0..298182a3c168 100644
> --- a/net/sunrpc/xprtsock.c
> +++ b/net/sunrpc/xprtsock.c
> @@ -958,6 +958,7 @@ static int xs_udp_send_request(struct rpc_rqst *req)
>  		return status;
>  	req->rq_xtime =3D ktime_get();
>  	status =3D xprt_sock_sendmsg(transport->sock, &msg, xdr, 0, 0, &sent);
> +	xdr_free_bvec(xdr);
> =20
>  	dprintk("RPC:       xs_udp_send_request(%u) =3D %d\n",
>  			xdr->len, status);

I think you're probably correct here.

I was thinking we might have a similar bug in svc_tcp_sendmsg, but it
looks like that one gets freed in svc_tcp_sendto.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
