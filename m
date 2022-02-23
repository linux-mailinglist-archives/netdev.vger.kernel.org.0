Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33EB4C06E5
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 02:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbiBWBaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 20:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbiBWBaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 20:30:22 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA8549F8C
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 17:29:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=a0Y1P5YGLxQXD/g6FUhaClEN/0LpPN9nAZ+/vAJynrM=; b=W7NztS7FjI/JcLAT+et0lT/ItI
        YM6nWXat/DJu3nHnpMmMbzOyIRac8zL8JVsVuRhxL3rXTtzg1oCIoYn/nNQed2SH59m3Jmx7XMz2d
        0/26dm0PL5MJGDXWvnnkcva67286UCZ57OoPGh7a1X6PNTxTfxcToHM4MbBHxEKE6S4V4+/9VzEWY
        sBpOSz/krLfE4bpiqGxvzTf51rFig5Hk/XcbjRx0T2Wf2P/OAa/2c6IRwLj0F/zdGLW+KuPS+Ohoe
        rSFsvtTIyD9KvIPDblu9UCrBuFU1WtQbRPq06+UO7OxEgk9WNDptfw0XVv+ucRdkWnFD5PZ+vqEZ0
        48RYNqew==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMgTZ-00C7fh-1Y; Wed, 23 Feb 2022 01:29:53 +0000
Date:   Tue, 22 Feb 2022 17:29:53 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     xiangxia.m.yue@gmail.com
Cc:     netdev@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>
Subject: Re: [net-next] net: core: use shared sysctl macro
Message-ID: <YhWOETp0UB9IpU6R@bombadil.infradead.org>
References: <20220222125628.39363-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222125628.39363-1-xiangxia.m.yue@gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 08:56:28PM +0800, xiangxia.m.yue@gmail.com wrote:
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index 6353d6db69b2..b2ac6542455f 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -42,12 +42,13 @@ struct ctl_dir;
>  #define SYSCTL_ZERO			((void *)&sysctl_vals[1])
>  #define SYSCTL_ONE			((void *)&sysctl_vals[2])
>  #define SYSCTL_TWO			((void *)&sysctl_vals[3])
> -#define SYSCTL_FOUR			((void *)&sysctl_vals[4])
> -#define SYSCTL_ONE_HUNDRED		((void *)&sysctl_vals[5])
> -#define SYSCTL_TWO_HUNDRED		((void *)&sysctl_vals[6])
> -#define SYSCTL_ONE_THOUSAND		((void *)&sysctl_vals[7])
> -#define SYSCTL_THREE_THOUSAND		((void *)&sysctl_vals[8])
> -#define SYSCTL_INT_MAX			((void *)&sysctl_vals[9])
> +#define SYSCTL_THREE			((void *)&sysctl_vals[4])
> +#define SYSCTL_FOUR			((void *)&sysctl_vals[5])
> +#define SYSCTL_ONE_HUNDRED		((void *)&sysctl_vals[6])
> +#define SYSCTL_TWO_HUNDRED		((void *)&sysctl_vals[7])
> +#define SYSCTL_ONE_THOUSAND		((void *)&sysctl_vals[8])
> +#define SYSCTL_THREE_THOUSAND		((void *)&sysctl_vals[9])
> +#define SYSCTL_INT_MAX			((void *)&sysctl_vals[10])

xiangxia, thanks for you patch!

I welcome this change but can you please also extend lib/test_sysctl.c
(selftests) and/or kernel/sysctl-test.c (UML kunit test) to ensure we
don't regress any existing mappings here.

The test can be really simply and would seem stupid but it would be of
great help. It would just make sure SYSCTL_ONE == 1, SYSCTL_TWO == 2, etc.

I think using kunit makes more sense here. Once you then then have this
test, you can use it to verify you have not introduced a regression and
re-send the patch.

Thanks!

  Luis
