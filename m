Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D962E4DBD34
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 03:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346323AbiCQCre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 22:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236570AbiCQCrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 22:47:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49989201B6
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 19:46:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D79B661556
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 02:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36A5C340EC;
        Thu, 17 Mar 2022 02:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647485176;
        bh=hKLT5DwSWpRodrIMgWXSGy3vOwYPZpxWCEecFRl/ZBw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cZ1PZOZy79Vau7fzIeh6L8irt48SYKLgr2HCOlSagPoETcWrKwHf7Ivox3dXo7l/i
         vdu55mM9TKB3xz1mgWQ8nlEAlZ7xIh+1+hf3gJRN9cPbX8jzSioYURLg4xmJqMt6cR
         4q98OViiTXw0oByKQRUOPU0/qjxCxKtGq4JbY5Sli/Lz58DOaQ7nXxSoofVz13RwZO
         ggv9Az7+r8zJXndibP08utCLfz5flgeGqUefMWBYX3drgjg5cMcqUMtJh35fAdPX3G
         vdC5gWkiahfgouY6YrKoV+ii+yJoC97VKqr0/tIBNH3Mjygmzhmw4E6zxsWsS0ceUL
         dnZIpz/N5MXrA==
Date:   Wed, 16 Mar 2022 19:46:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Rao Shoaib <Rao.Shoaib@oracle.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 net 2/2] af_unix: Support POLLPRI for OOB.
Message-ID: <20220316194614.3e38cadc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220315183855.15190-3-kuniyu@amazon.co.jp>
References: <20220315183855.15190-1-kuniyu@amazon.co.jp>
        <20220315183855.15190-3-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Mar 2022 03:38:55 +0900 Kuniyuki Iwashima wrote:
> The commit 314001f0bf92 ("af_unix: Add OOB support") introduced OOB for
> AF_UNIX, but it lacks some changes for POLLPRI.  Let's add the missing
> piece.
> 
> In the selftest, normal datagrams are sent followed by OOB data, so this
> commit replaces `POLLIN | POLLPRI` with just `POLLPRI` in the first test
> case.
> 
> Fixes: 314001f0bf92 ("af_unix: Add OOB support")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 0c37e5595aae..f94afaa5a696 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -2049,7 +2049,7 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
>   */
>  #define UNIX_SKB_FRAGS_SZ (PAGE_SIZE << get_order(32768))
>  
> -#if (IS_ENABLED(CONFIG_AF_UNIX_OOB))
> +#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
>  static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other)
>  {
>  	struct unix_sock *ousk = unix_sk(other);
> @@ -2115,7 +2115,7 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>  
>  	err = -EOPNOTSUPP;
>  	if (msg->msg_flags & MSG_OOB) {
> -#if (IS_ENABLED(CONFIG_AF_UNIX_OOB))
> +#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
>  		if (len)
>  			len--;
>  		else
> @@ -2186,7 +2186,7 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>  		sent += size;
>  	}
>  
> -#if (IS_ENABLED(CONFIG_AF_UNIX_OOB))
> +#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
>  	if (msg->msg_flags & MSG_OOB) {
>  		err = queue_oob(sock, msg, other);
>  		if (err)

If we want to keep this change structured as a fix and backported we
should avoid making unnecessary changes. Fixes need to be minimal
as per stable rules. 

Could you make removal of the brackets a patch separate from this
series and targeted at net-next?
