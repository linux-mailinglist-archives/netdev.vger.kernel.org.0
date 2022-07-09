Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8B456C620
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 05:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiGIDGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 23:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGIDGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 23:06:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE077B791;
        Fri,  8 Jul 2022 20:06:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCB6BB82A35;
        Sat,  9 Jul 2022 03:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D39EC341C0;
        Sat,  9 Jul 2022 03:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657335964;
        bh=U1K6nef6J4x5j2XZwh1q8ZuqeJJFO88Lt/OQry2fCKw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RC3lVRzP8QHAXO23r0o/AgJAlXIPlF75VO9wbzqXPFl0327gY9yesP6+YxwL+rKH7
         Rn+U+mCqgj6lq0AST5RPzgzIEVOXJ5Tmbghas1cnC9jRHj8cq/L/8/2Vw1akeYYPXi
         YVZdONr1SOKWKW6HXF16WCx/FUpllbuefJ8amYI/mjTb2aVokXg20+MF4tKFiZsUA6
         rksCcjmuIbgI2WhmTC9pmxqbdD38c+s1ui9h73vJgqM3IH/3/sErpWvi4Y1xVN1Wrl
         3XW8GqvdFH+eg6tBLruRl8Id1JAFqItTKC0QntSVnDRuxazNHbZiWBRgVaVAnRODZC
         iUoyEclRJLfGg==
Date:   Fri, 8 Jul 2022 20:06:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hawkins Jiawei <yin31149@gmail.com>
Cc:     syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com,
        andrii@kernel.org, ast@kernel.org, borisp@nvidia.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, guwen@linux.alibaba.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kgraul@linux.ibm.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        skhan@linuxfoundation.org, 18801353760@163.com,
        paskripkin@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] smc: fix refcount bug in sk_psock_get (2)
Message-ID: <20220708200602.1059bc09@kernel.org>
In-Reply-To: <20220709024659.6671-1-yin31149@gmail.com>
References: <00000000000026328205e08cdbeb@google.com>
        <20220709024659.6671-1-yin31149@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  9 Jul 2022 10:46:59 +0800 Hawkins Jiawei wrote:
> Reported-and-tested-by: syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com
> Signed-off-by: hawk <18801353760@163.com>
> ---
>  net/ipv4/tcp.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 9984d23a7f3e..a1e6cab2c748 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -3395,10 +3395,23 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
>  	}
>  	case TCP_ULP: {
>  		char name[TCP_ULP_NAME_MAX];
> +		struct sock *smc_sock;
>  
>  		if (optlen < 1)
>  			return -EINVAL;
>  
> +		/* SMC sk_user_data may be treated as psock,
> +		 * which triggers a refcnt warning.
> +		 */
> +		rcu_read_lock();
> +		smc_sock = rcu_dereference_sk_user_data(sk);
> +		if (level == SOL_TCP && smc_sock &&
> +		    smc_sock->__sk_common.skc_family == AF_SMC) {

This should prolly be under the socket lock?

Can we add a bit to SK_USER_DATA_PTRMASK and have ULP-compatible
users (sockmap) opt into ULP cooperation? Modifying TCP is backwards,
layer-wise.

> +			rcu_read_unlock();
> +			return -EOPNOTSUPP;
> +		}
> +		rcu_read_unlock();
> +
