Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B3B50676D
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 11:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347800AbiDSJIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 05:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240297AbiDSJIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 05:08:52 -0400
Received: from zeeaster.vergenet.net (zeeaster.vergenet.net [206.189.110.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0949965B8
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 02:06:10 -0700 (PDT)
Received: from madeliefje.horms.nl (86-88-72-229.fixed.kpn.net [86.88.72.229])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by zeeaster.vergenet.net (Postfix) with ESMTPSA id 9476420156;
        Tue, 19 Apr 2022 09:05:39 +0000 (UTC)
Received: by madeliefje.horms.nl (Postfix, from userid 7100)
        id 548CA35C8; Tue, 19 Apr 2022 11:05:39 +0200 (CEST)
Date:   Tue, 19 Apr 2022 11:05:39 +0200
From:   Simon Horman <horms@verge.net.au>
To:     xiangxia.m.yue@gmail.com
Cc:     netdev@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>
Subject: Re: [PATCH v3 2/2] net: sysctl: introduce sysctl SYSCTL_THREE
Message-ID: <Yl57Y6f/6KqwMRlE@vergenet.net>
References: <20220415163912.26530-1-xiangxia.m.yue@gmail.com>
 <20220415163912.26530-3-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415163912.26530-3-xiangxia.m.yue@gmail.com>
Organisation: Horms Solutions BV
X-Virus-Scanned: clamav-milter 0.103.5 at zeeaster
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 16, 2022 at 12:39:12AM +0800, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> This patch introdues the SYSCTL_THREE.

...

> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index 7d9cfc730bd4..5851c2a92c0d 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -26,7 +26,7 @@ static const struct file_operations proc_sys_dir_file_operations;
>  static const struct inode_operations proc_sys_dir_operations;
>  
>  /* shared constants to be used in various sysctls */
> -const int sysctl_vals[] = { -1, 0, 1, 2, 4, 100, 200, 1000, 3000, INT_MAX, 65535 };
> +const int sysctl_vals[] = { 0, 1, 2, 3, 4, 100, 200, 1000, 3000, INT_MAX, 65535, -1 };
>  EXPORT_SYMBOL(sysctl_vals);
>  
>  const unsigned long sysctl_long_vals[] = { 0, 1, LONG_MAX };
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index 6353d6db69b2..80263f7cdb77 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -38,10 +38,10 @@ struct ctl_table_header;
>  struct ctl_dir;
>  
>  /* Keep the same order as in fs/proc/proc_sysctl.c */
> -#define SYSCTL_NEG_ONE			((void *)&sysctl_vals[0])
> -#define SYSCTL_ZERO			((void *)&sysctl_vals[1])
> -#define SYSCTL_ONE			((void *)&sysctl_vals[2])
> -#define SYSCTL_TWO			((void *)&sysctl_vals[3])
> +#define SYSCTL_ZERO			((void *)&sysctl_vals[0])
> +#define SYSCTL_ONE			((void *)&sysctl_vals[1])
> +#define SYSCTL_TWO			((void *)&sysctl_vals[2])
> +#define SYSCTL_THREE			((void *)&sysctl_vals[3])
>  #define SYSCTL_FOUR			((void *)&sysctl_vals[4])
>  #define SYSCTL_ONE_HUNDRED		((void *)&sysctl_vals[5])
>  #define SYSCTL_TWO_HUNDRED		((void *)&sysctl_vals[6])
> @@ -51,6 +51,7 @@ struct ctl_dir;
>  
>  /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
>  #define SYSCTL_MAXOLDUID		((void *)&sysctl_vals[10])
> +#define SYSCTL_NEG_ONE			((void *)&sysctl_vals[11])
>  
>  extern const int sysctl_vals[];

...

> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index 7f645328b47f..efab2b06d373 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -1767,8 +1767,6 @@ static int ip_vs_zero_all(struct netns_ipvs *ipvs)
>  
>  #ifdef CONFIG_SYSCTL
>  
> -static int three = 3;
> -
>  static int
>  proc_do_defense_mode(struct ctl_table *table, int write,
>  		     void *buffer, size_t *lenp, loff_t *ppos)
> @@ -1977,7 +1975,7 @@ static struct ctl_table vs_vars[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec_minmax,
>  		.extra1		= SYSCTL_ZERO,
> -		.extra2		= &three,
> +		.extra2		= SYSCTL_THREE,
>  	},
>  	{
>  		.procname	= "nat_icmp_send",

Subjectively, I'm ambivalent towards the merit of this patchset,
perhaps there is some justification for it that I missed.

Objectively, I don't see anything here that would break IPVS.

IPVS portion:

Reviewed-by: Simon Horman <horms@verge.net.au>

