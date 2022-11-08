Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C60462064D
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 02:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbiKHBse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 20:48:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiKHBsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 20:48:33 -0500
X-Greylist: delayed 539 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Nov 2022 17:48:31 PST
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F4E95BA
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 17:48:29 -0800 (PST)
Received: from [192.168.14.220] (unknown [159.196.94.94])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 8B53820032;
        Tue,  8 Nov 2022 09:39:23 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1667871566;
        bh=Jya3lfIxQ9OGSG3opWaCaimfCadq0hLXQLsSld+q/tE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References;
        b=RQqVTPdoxbyJmlzCKC76ZyzJycxuPNcWasADkNJiX2JjN+35h/NKOCQapqYoFmn1s
         zqKHMWUjsP6GgkPHw7lbhYas1bDEbByEJNSnhQhXzZAAToiqkWW+4ht5+T7zhkKdGv
         9ph1Sb0u8sVVrruSKkwBwvzekEssR9oPg5q62O1YklOQag+ij4KHIYcm5fOeo1NKU6
         XMtmg+uP9id0P/horlhfL3Tz3f5Kss0o/K5sN6U9QJSWlBXmQ+OqHIWYPxfPAhn2w8
         9R03SgxE3bEYSZFueQg2ocOuaB79CyGhAXXnk34xeekQPf9b37F1UETVFd4TZmlx7S
         tcVDKbQChVM9g==
Message-ID: <affb2f94fdcf3346174b27b525ea968001faa57c.camel@codeconstruct.com.au>
Subject: Re: [PATCH net] mctp: Fix an error handling path in mctp_init()
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     Wei Yongjun <weiyongjun@huaweicloud.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Wei Yongjun <weiyongjun1@huawei.com>, netdev@vger.kernel.org
Date:   Tue, 08 Nov 2022 09:39:22 +0800
In-Reply-To: <20221107152756.180628-1-weiyongjun@huaweicloud.com>
References: <20221107152756.180628-1-weiyongjun@huaweicloud.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.0-2 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-11-07 at 15:27 +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
>=20
> If mctp_neigh_init() return error, the routes resources should
> be released in the error handling path. Otherwise some resources
> leak.
>=20
> Fixes: 4d8b9319282a ("mctp: Add neighbour implementation")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Acked-by: Matt Johnston <matt@codeconstruct.com.au>

Thanks for catching that.

Matt

>=20
> diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
> index b6b5e496fa40..fc9e728b6333 100644
> --- a/net/mctp/af_mctp.c
> +++ b/net/mctp/af_mctp.c
> @@ -665,12 +665,14 @@ static __init int mctp_init(void)
> =20
>  	rc =3D mctp_neigh_init();
>  	if (rc)
> -		goto err_unreg_proto;
> +		goto err_unreg_routes;
> =20
>  	mctp_device_init();
> =20
>  	return 0;
> =20
> +err_unreg_routes:
> +	mctp_routes_exit();
>  err_unreg_proto:
>  	proto_unregister(&mctp_proto);
>  err_unreg_sock:

