Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4474D549B
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 23:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244881AbiCJWbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 17:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233618AbiCJWbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 17:31:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116063EBA4;
        Thu, 10 Mar 2022 14:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C16C7B82901;
        Thu, 10 Mar 2022 22:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09D3C340E8;
        Thu, 10 Mar 2022 22:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646951413;
        bh=iy+o1LnqleDh1BskAEpi+cMnfNXsytjJLxNfLpCVTu0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e5J6+cKAEWI1GK0QG0Voz1ubX9ZfLTcKcmUQyFZhOBQr5x60xj5Rz1rhig0/owiAI
         5++cIKKhdDFeDRFRK+IqLv0gUvKy3PvemJ2oSrgP3r4FETzdCZUbmlo6Ywe34fyFru
         0AHlxS0+fc4M/LurSmvdb/a01gBLT7X/fEm8c/kohSwSXbV4sLDSlEMVuC2tVSoasV
         NaIZBWQFhDq3P+5HN60cERXnO81KkydPZKoFUBIuoACat1RMpvOMgrWAwhtEoC5xqa
         5LrC2a4p53VTlQj1RI8OuuXjmbyKAYI4SoObQIU+cfVcBvDGw5MNIl69Twu+rB1gdo
         y8lfcLfwdRFPg==
Date:   Thu, 10 Mar 2022 14:30:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     davem@davemloft.net,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] net: ipv6: fix skb_over_panic in __ip6_append_data
Message-ID: <20220310143011.00c21f53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220310221328.877987-1-tadeusz.struk@linaro.org>
References: <CA+FuTScPUVpyK6WYXrePTg_533VF2wfPww4MOJYa17v0xbLeGQ@mail.gmail.com>
        <20220310221328.877987-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Mar 2022 14:13:28 -0800 Tadeusz Struk wrote:
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index 4788f6b37053..6d45112322a0 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -1649,6 +1649,16 @@ static int __ip6_append_data(struct sock *sk,
>  			skb->protocol = htons(ETH_P_IPV6);
>  			skb->ip_summed = csummode;
>  			skb->csum = 0;
> +
> +			/*
> +			 *	Check if there is still room for payload
> +			 */

TBH I think the check is self-explanatory. Not worth a banner comment,
for sure.

> +			if (fragheaderlen >= mtu) {
> +				err = -EMSGSIZE;
> +				kfree_skb(skb);
> +				goto error;
> +			}

Not sure if Willem prefers this placement, but seems like we can lift
this check out of the loop, as soon as fragheaderlen and mtu are known.

>  			/* reserve for fragmentation and ipsec header */
>  			skb_reserve(skb, hh_len + sizeof(struct frag_hdr) +
>  				    dst_exthdrlen);
