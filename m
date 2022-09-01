Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA43D5A8BDC
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 05:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiIADSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 23:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiIADS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 23:18:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586C910F950;
        Wed, 31 Aug 2022 20:18:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9C0F61DB4;
        Thu,  1 Sep 2022 03:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C837BC433D7;
        Thu,  1 Sep 2022 03:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662002306;
        bh=16dGpQuZWp80nNIsYZhnXMYclxOAATqFejwDvoEzOw4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A5YbaBMwit/rAEULP1nMwye2THqInMMt1/CP/Mc7VAZgF1TO97g/9Y8yEVdFP53A4
         Qix46e3cHJbpGJWAUkaqPE8JOwWmlFT6HxtNwsbC5Z5lQtydIMzN085iYO+OA8BMD2
         uPNp9QJsgWUWBngDlPTPeKsNC7vMApA18SFVkFR0CMNVLwsAYIdfAOqMxKRk0q+t+v
         74g2X5hxD4v9SQjlM1AsyfxXcPJFcbmGNtCaATgHGoEHSomb+cd748ebPyI8BhN16q
         kaekQvaDyWB5D/3J4P8x6btpDJJeeVZL/oxJn1k1p0jwk8PYmhoNVw+oeRebiujLgC
         OjxgwbP/bl8XA==
Date:   Wed, 31 Aug 2022 20:18:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        syzbot <syzkaller@googlegroups.com>,
        Yajun Deng <yajun.deng@linux.dev>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH 1/2] netlink: Bounds-check nlmsg_len()
Message-ID: <20220831201825.378d748d@kernel.org>
In-Reply-To: <20220901030610.1121299-2-keescook@chromium.org>
References: <20220901030610.1121299-1-keescook@chromium.org>
        <20220901030610.1121299-2-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Aug 2022 20:06:09 -0700 Kees Cook wrote:
>  static inline int nlmsg_len(const struct nlmsghdr *nlh)
>  {
> -	return nlh->nlmsg_len - NLMSG_HDRLEN;
> +	u32 nlmsg_contents_len;
> +
> +	if (WARN_ON_ONCE(check_sub_overflow(nlh->nlmsg_len,
> +					    (u32)NLMSG_HDRLEN,
> +					    &nlmsg_contents_len)))
> +		return 0;
> +	if (WARN_ON_ONCE(nlmsg_contents_len > INT_MAX))
> +		return INT_MAX;
> +	return nlmsg_contents_len;

We check the messages on input, making sure the length is valid wrt
skb->len, and sane, ie > NLMSG_HDRLEN. See netlink_rcv_skb().

Can we not, pretty please? :(
