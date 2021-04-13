Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C8435DAA4
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhDMJHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:07:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229562AbhDMJHT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 05:07:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32D9D60FEF;
        Tue, 13 Apr 2021 09:06:56 +0000 (UTC)
Date:   Tue, 13 Apr 2021 11:06:54 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Jonathon Reinhart <jonathon.reinhart@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net: Make tcp_allowed_congestion_control readonly in
 non-init netns
Message-ID: <20210413090654.nwroe4bgwmiuyvsp@wittgenstein>
References: <20210413070848.7261-1-jonathon.reinhart@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210413070848.7261-1-jonathon.reinhart@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 03:08:48AM -0400, Jonathon Reinhart wrote:
> Currently, tcp_allowed_congestion_control is global and writable;
> writing to it in any net namespace will leak into all other net
> namespaces.
> 
> tcp_available_congestion_control and tcp_allowed_congestion_control are
> the only sysctls in ipv4_net_table (the per-netns sysctl table) with a
> NULL data pointer; their handlers (proc_tcp_available_congestion_control
> and proc_allowed_congestion_control) have no other way of referencing a
> struct net. Thus, they operate globally.
> 
> Because ipv4_net_table does not use designated initializers, there is no
> easy way to fix up this one "bad" table entry. However, the data pointer
> updating logic shouldn't be applied to NULL pointers anyway, so we
> instead force these entries to be read-only.
> 
> These sysctls used to exist in ipv4_table (init-net only), but they were
> moved to the per-net ipv4_net_table, presumably without realizing that
> tcp_allowed_congestion_control was writable and thus introduced a leak.
> 
> Because the intent of that commit was only to know (i.e. read) "which
> congestion algorithms are available or allowed", this read-only solution
> should be sufficient.
> 
> The logic added in recent commit
> 31c4d2f160eb: ("net: Ensure net namespace isolation of sysctls")
> does not and cannot check for NULL data pointers, because
> other table entries (e.g. /proc/sys/net/netfilter/nf_log/) have
> .data=NULL but use other methods (.extra2) to access the struct net.
> 
> Fixes: 9cb8e048e5d9: ("net/ipv4/sysctl: show tcp_{allowed, available}_congestion_control in non-initial netns")
> Signed-off-by: Jonathon Reinhart <jonathon.reinhart@gmail.com>
> ---

Thanks for catching this. I think this works fine as a fix.

What I wonder is whether we have a need to make
tcp_allowed_congestion_control per-netns proper. That would be a bit
more work of course and we don't need to do it right now.

(Fwiw, we should really have a document describing the sysctls which are
namespaced and how.)

>  net/ipv4/sysctl_net_ipv4.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index a09e466ce11d..a62934b9f15a 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -1383,9 +1383,19 @@ static __net_init int ipv4_sysctl_init_net(struct net *net)
>  		if (!table)
>  			goto err_alloc;
>  
> -		/* Update the variables to point into the current struct net */
> -		for (i = 0; i < ARRAY_SIZE(ipv4_net_table) - 1; i++)
> -			table[i].data += (void *)net - (void *)&init_net;
> +		for (i = 0; i < ARRAY_SIZE(ipv4_net_table) - 1; i++) {
> +			if (table[i].data) {
> +				/* Update the variables to point into
> +				 * the current struct net
> +				 */
> +				table[i].data += (void *)net - (void *)&init_net;
> +			} else {
> +				/* Entries without data pointer are global;
> +				 * Make them read-only in non-init_net ns
> +				 */
> +				table[i].mode &= ~0222;
> +			}
> +		}

Just for future reference if we would need to distinguish between
entries that do have data set and such that don't here we could also do
the below. This works because the tcp_{available,allowed}_[..] do
allocated into a local ctl_table variable anyway.

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index f55095d3ed16..a1c8f5fe7501 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -877,12 +877,14 @@ static struct ctl_table ipv4_net_table[] = {
        },
        {
                .procname       = "tcp_available_congestion_control",
+               .data           = ERR_PTR(-EINVAL),
                .maxlen         = TCP_CA_BUF_MAX,
                .mode           = 0444,
                .proc_handler   = proc_tcp_available_congestion_control,
        },
        {
                .procname       = "tcp_allowed_congestion_control",
+               .data           = ERR_PTR(-EINVAL),
                .maxlen         = TCP_CA_BUF_MAX,
                .mode           = 0644,
                .proc_handler   = proc_allowed_congestion_control,
@@ -1379,8 +1381,18 @@ static __net_init int ipv4_sysctl_init_net(struct net *net)
                        goto err_alloc;

                /* Update the variables to point into the current struct net */
-               for (i = 0; i < ARRAY_SIZE(ipv4_net_table) - 1; i++)
-                       table[i].data += (void *)net - (void *)&init_net;
+               for (i = 0; i < ARRAY_SIZE(ipv4_net_table) - 1; i++) {
+                       if (!IS_ERR(table[i].data)) {
+                               /* Update the variables to point into
+                                * the current struct net. */
+                               table[i].data += (void *)net - (void *)&init_net;
+                       } else {
+                               /* Entries without data pointer are global;
+                                * Make them read-only in non-init_net ns.
+                                */
+                               table[i].mode &= ~0222;
+                       }
+               }
        }
