Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063984C9ADA
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 03:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238218AbiCBCD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 21:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiCBCD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 21:03:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED03B289A9;
        Tue,  1 Mar 2022 18:03:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8872361668;
        Wed,  2 Mar 2022 02:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8784AC340EE;
        Wed,  2 Mar 2022 02:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646186595;
        bh=s7k6aRxfxCIh/rpY0Mm41+2wCLMLFpGjdtj8D5mnN6Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Um2yvFya4FM/XJHG9lFQ4B8GKPdtereJZ6FQNHUiRly1W0L+QReG8uzDi06KuvUuS
         RAHrKN0CPoO3n6GzWW1YIBzakiIFmYdDG/4UsbeZKO0dcYKV4M9fIGYasnfhbKrwP1
         qv8+FJdlm7DI7xT3c5m6dWwIGncEs3U2GmwDur8PEx57a53Ok0aVvWd55Z8E7Nkcjf
         R9xZk8wBqnnvSZiN+NIK1Kofm7hS5h7nuaGOnHSHWyAikx0WlMwi02UkQR/F61k6QL
         GfxNFwoWbtO7UqhQPsrMYcjW1Syte2/02bwwAdlTtmUVeyM9EWpLtTzrnjJmgeEQHY
         fj7URS9LCJm3g==
Date:   Tue, 1 Mar 2022 18:03:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH v5 net-next 06/13] net: ip: Handle delivery_time in ip
 defrag
Message-ID: <20220301180314.45c0bb84@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220301053709.933219-1-kafai@fb.com>
References: <20220301053631.930498-1-kafai@fb.com>
        <20220301053709.933219-1-kafai@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Feb 2022 21:37:09 -0800 Martin KaFai Lau wrote:
> diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
> index 63540be0fc34..8ad0c1d6d024 100644
> --- a/include/net/inet_frag.h
> +++ b/include/net/inet_frag.h
> @@ -90,6 +90,7 @@ struct inet_frag_queue {
>  	ktime_t			stamp;
>  	int			len;
>  	int			meat;
> +	__u8			mono_delivery_time;
>  	__u8			flags;
>  	u16			max_size;
>  	struct fqdir		*fqdir;

kdoc missing for this one, also we can ignore the __u8 in flags and
stick to non-uAPI types this time
