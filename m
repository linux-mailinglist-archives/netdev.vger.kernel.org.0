Return-Path: <netdev+bounces-1663-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34D626FEB33
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 07:31:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3431281453
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 05:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2DEC1F196;
	Thu, 11 May 2023 05:31:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F27371
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 05:31:36 +0000 (UTC)
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527372105;
	Wed, 10 May 2023 22:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sImtSEdeoH0kaJWNfpZ5Fj7UjlwzA50TxaE7LHZUU+U=; b=BfOwgjFL6GdoKA3/MhZfq945FU
	B8H7AiawPq2LjLZFlbJYtIgzCNaJ/ZSK7ikij7A1I1uUx1Svhbn3BfRlkeFgvvMTfMnzbDHvZFJqA
	+eDL/3DBjN/IYXh9Ox2V3iUrezO5oMRkPFkWIOPwQNl7Pwu8QjoTAsn0em1THyhgjM/5mFalU93R4
	INtQ6qCQ+L5vad3oJq3q83POwFVrVfa8W8s6REmY2jjjc1YGjjrBK/d2MV/4rc6Zwt4NlTj4E9PHJ
	JZj0hlTv7esatCf8mZh1n8tVEbHkG2PQKQs5uQHULGyXhr/7G8P7zSURKG+YXjdkJOjZ7x5MIUn8L
	LRcQVDkw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
	id 1pwyth-001cUh-1C;
	Thu, 11 May 2023 05:31:25 +0000
Date: Thu, 11 May 2023 06:31:25 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: ye.xingchen@zte.com.cn
Cc: mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost_net: Use fdget() and fdput()
Message-ID: <20230511053125.GI3390869@ZenIV>
References: <202305051424047152799@zte.com.cn>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202305051424047152799@zte.com.cn>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 05, 2023 at 02:24:04PM +0800, ye.xingchen@zte.com.cn wrote:
> From: Ye Xingchen <ye.xingchen@zte.com.cn>
> 
> convert the fget()/fput() uses to fdget()/fdput().
> 
> Signed-off-by: Ye Xingchen <ye.xingchen@zte.com.cn>
> ---
>  drivers/vhost/net.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index ae2273196b0c..5b3fe4805182 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -1466,17 +1466,17 @@ static struct ptr_ring *get_tap_ptr_ring(struct file *file)
> 
>  static struct socket *get_tap_socket(int fd)
>  {
> -	struct file *file = fget(fd);
> +	struct fd f = fdget(fd);
>  	struct socket *sock;
> 
> -	if (!file)
> +	if (!f.file)
>  		return ERR_PTR(-EBADF);
> -	sock = tun_get_socket(file);
> +	sock = tun_get_socket(f.file);
>  	if (!IS_ERR(sock))
>  		return sock;
> -	sock = tap_get_socket(file);
> +	sock = tap_get_socket(f.file);
>  	if (IS_ERR(sock))
> -		fput(file);
> +		fdput(f);
>  	return sock;

NAK.  For the same reason why the sockfd_lookup() counterpart of that
patch is broken.  After your change there's no way for the caller
to tell whether we have bumped the refcount of file in question;
this can't possibly work.

