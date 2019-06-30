Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 452325B193
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 22:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfF3UjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 16:39:03 -0400
Received: from ja.ssi.bg ([178.16.129.10]:43360 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726669AbfF3UjD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 16:39:03 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x5UKafTT007280;
        Sun, 30 Jun 2019 23:36:41 +0300
Date:   Sun, 30 Jun 2019 23:36:41 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Arnd Bergmann <arnd@arndb.de>
cc:     Kees Cook <keescook@chromium.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <jmorris@namei.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 4/4] ipvs: reduce kernel stack usage
In-Reply-To: <20190628123819.2785504-4-arnd@arndb.de>
Message-ID: <alpine.LFD.2.21.1906302308280.3788@ja.home.ssi.bg>
References: <20190628123819.2785504-1-arnd@arndb.de> <20190628123819.2785504-4-arnd@arndb.de>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Fri, 28 Jun 2019, Arnd Bergmann wrote:

> With the new CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL option, the stack
> usage in the ipvs debug output grows because each instance of
> IP_VS_DBG_BUF() now has its own buffer of 160 bytes that add up
> rather than reusing the stack slots:
> 
> net/netfilter/ipvs/ip_vs_core.c: In function 'ip_vs_sched_persist':
> net/netfilter/ipvs/ip_vs_core.c:427:1: error: the frame size of 1052 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> net/netfilter/ipvs/ip_vs_core.c: In function 'ip_vs_new_conn_out':
> net/netfilter/ipvs/ip_vs_core.c:1231:1: error: the frame size of 1048 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> net/netfilter/ipvs/ip_vs_ftp.c: In function 'ip_vs_ftp_out':
> net/netfilter/ipvs/ip_vs_ftp.c:397:1: error: the frame size of 1104 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> net/netfilter/ipvs/ip_vs_ftp.c: In function 'ip_vs_ftp_in':
> net/netfilter/ipvs/ip_vs_ftp.c:555:1: error: the frame size of 1200 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> 
> Since printk() already has a way to print IPv4/IPv6 addresses using
> the %pIS format string, use that instead, combined with a macro that
> creates a local sockaddr structure on the stack. These will still
> add up, but the stack frames are now under 200 bytes.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I'm not sure this actually does what I think it does. Someone
> needs to verify that we correctly print the addresses here.
> I've also only added three files that caused the warning messages
> to be reported. There are still a lot of other instances of
> IP_VS_DBG_BUF() that could be converted the same way after the
> basic idea is confirmed.
> ---
>  include/net/ip_vs.h             | 71 +++++++++++++++++++--------------
>  net/netfilter/ipvs/ip_vs_core.c | 44 ++++++++++----------
>  net/netfilter/ipvs/ip_vs_ftp.c  | 20 +++++-----
>  3 files changed, 72 insertions(+), 63 deletions(-)
> 
> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index 3759167f91f5..3dfbeef67be6 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h
> @@ -227,6 +227,16 @@ static inline const char *ip_vs_dbg_addr(int af, char *buf, size_t buf_len,
>  		       sizeof(ip_vs_dbg_buf), addr,			\
>  		       &ip_vs_dbg_idx)
>  
> +#define IP_VS_DBG_SOCKADDR4(fam, addr, port)				\
> +	(struct sockaddr*)&(struct sockaddr_in)				\
> +	{ .sin_family = (fam), .sin_addr = (addr)->in, .sin_port = (port) }
> +#define IP_VS_DBG_SOCKADDR6(fam, addr, port)				\
> +	(struct sockaddr*)&(struct sockaddr_in6) \
> +	{ .sin6_family = (fam), .sin6_addr = (addr)->in6, .sin6_port = (port) }
> +#define IP_VS_DBG_SOCKADDR(fam, addr, port) (fam == AF_INET ?		\
> +			IP_VS_DBG_SOCKADDR4(fam, addr, port) :		\
> +			IP_VS_DBG_SOCKADDR6(fam, addr, port))
> +
>  #define IP_VS_DBG(level, msg, ...)					\
>  	do {								\
>  		if (level <= ip_vs_get_debug_level())			\
> @@ -251,6 +261,7 @@ static inline const char *ip_vs_dbg_addr(int af, char *buf, size_t buf_len,
>  #else	/* NO DEBUGGING at ALL */
>  #define IP_VS_DBG_BUF(level, msg...)  do {} while (0)
>  #define IP_VS_ERR_BUF(msg...)  do {} while (0)
> +#define IP_VS_DBG_SOCKADDR(fam, addr, port) NULL
>  #define IP_VS_DBG(level, msg...)  do {} while (0)
>  #define IP_VS_DBG_RL(msg...)  do {} while (0)
>  #define IP_VS_DBG_PKT(level, af, pp, skb, ofs, msg)	do {} while (0)
> @@ -1244,31 +1255,31 @@ static inline void ip_vs_control_del(struct ip_vs_conn *cp)
>  {
>  	struct ip_vs_conn *ctl_cp = cp->control;
>  	if (!ctl_cp) {
> -		IP_VS_ERR_BUF("request control DEL for uncontrolled: "
> -			      "%s:%d to %s:%d\n",
> -			      IP_VS_DBG_ADDR(cp->af, &cp->caddr),
> -			      ntohs(cp->cport),
> -			      IP_VS_DBG_ADDR(cp->af, &cp->vaddr),
> -			      ntohs(cp->vport));
> +		pr_err("request control DEL for uncontrolled: "
> +		       "%pISp to %pISp\n",

	ip_vs_dbg_addr() used compact form (%pI6c), so it would be
better to use %pISc and %pISpc everywhere in IPVS...

	Also, note that before now port was printed with %d and
ntohs() was used, now port should be in network order, so:

- ntohs() should be removed
- htons() should be added, if missing. At first look, this case
is not present in IPVS, we have only ntohs() usage

Regards

--
Julian Anastasov <ja@ssi.bg>
