Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF1E03B346
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 12:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389497AbfFJKer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 06:34:47 -0400
Received: from mail.us.es ([193.147.175.20]:46378 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389408AbfFJKer (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 06:34:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 495F16D4F5
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 12:34:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3A386DA716
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 12:34:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2FF4FDA711; Mon, 10 Jun 2019 12:34:45 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C0701DA70C;
        Mon, 10 Jun 2019 12:34:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 10 Jun 2019 12:33:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4F1B6406B68B;
        Mon, 10 Jun 2019 12:34:23 +0200 (CEST)
Date:   Mon, 10 Jun 2019 12:34:17 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz Pawelczyk <havner@gmail.com>
Subject: Re: [PATCH v4] extensions: libxt_owner: Add supplementary groups
 option
Message-ID: <20190610103417.jg7xnaprczu2kkq2@salvia>
References: <CGME20190610094353eucas1p29eb71e82aa621c1e387513571a78710b@eucas1p2.samsung.com>
 <20190610094238.24904-1-l.pawelczyk@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610094238.24904-1-l.pawelczyk@samsung.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 11:42:38AM +0200, Lukasz Pawelczyk wrote:
> The --suppl-groups option causes GIDs specified with --gid-owner to be
> also checked in the supplementary groups of a process.

Could you also extend iptables/extensions/libxt_owner.t ?

Thanks.

> Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
> ---
> 
> Changes from v3:
>  - removed XTOPT_INVERT from O_SUPPL_GROUPS,
>    it wasn't meant to be invertable
>     
> Changes from v2:
>  - XT_SUPPL_GROUPS -> XT_OWNER_SUPPL_GROUPS
>     
> Changes from v1:
>  - complementary -> supplementary
>  - manual (iptables-extensions)
> 
>  extensions/libxt_owner.c           | 24 +++++++++++++++++-------
>  extensions/libxt_owner.man         |  4 ++++
>  include/linux/netfilter/xt_owner.h |  7 ++++---
>  3 files changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
> index 87e4df31..1702b478 100644
> --- a/extensions/libxt_owner.c
> +++ b/extensions/libxt_owner.c
> @@ -56,6 +56,7 @@ enum {
>  	O_PROCESS,
>  	O_SESSION,
>  	O_COMM,
> +	O_SUPPL_GROUPS,
>  };
>  
>  static void owner_mt_help_v0(void)
> @@ -87,7 +88,8 @@ static void owner_mt_help(void)
>  "owner match options:\n"
>  "[!] --uid-owner userid[-userid]      Match local UID\n"
>  "[!] --gid-owner groupid[-groupid]    Match local GID\n"
> -"[!] --socket-exists                  Match if socket exists\n");
> +"[!] --socket-exists                  Match if socket exists\n"
> +"    --suppl-groups                   Also match supplementary groups set with --gid-owner\n");
>  }
>  
>  #define s struct ipt_owner_info
> @@ -131,6 +133,7 @@ static const struct xt_option_entry owner_mt_opts[] = {
>  	 .flags = XTOPT_INVERT},
>  	{.name = "socket-exists", .id = O_SOCK_EXISTS, .type = XTTYPE_NONE,
>  	 .flags = XTOPT_INVERT},
> +	{.name = "suppl-groups", .id = O_SUPPL_GROUPS, .type = XTTYPE_NONE},
>  	XTOPT_TABLEEND,
>  };
>  
> @@ -275,6 +278,11 @@ static void owner_mt_parse(struct xt_option_call *cb)
>  			info->invert |= XT_OWNER_SOCKET;
>  		info->match |= XT_OWNER_SOCKET;
>  		break;
> +	case O_SUPPL_GROUPS:
> +		if (!(info->match & XT_OWNER_GID))
> +			xtables_param_act(XTF_BAD_VALUE, "owner", "--suppl-groups", "you need to use --gid-owner first");
> +		info->match |= XT_OWNER_SUPPL_GROUPS;
> +		break;
>  	}
>  }
>  
> @@ -455,9 +463,10 @@ static void owner_mt_print(const void *ip, const struct xt_entry_match *match,
>  {
>  	const struct xt_owner_match_info *info = (void *)match->data;
>  
> -	owner_mt_print_item(info, "owner socket exists", XT_OWNER_SOCKET, numeric);
> -	owner_mt_print_item(info, "owner UID match",     XT_OWNER_UID,    numeric);
> -	owner_mt_print_item(info, "owner GID match",     XT_OWNER_GID,    numeric);
> +	owner_mt_print_item(info, "owner socket exists", XT_OWNER_SOCKET,       numeric);
> +	owner_mt_print_item(info, "owner UID match",     XT_OWNER_UID,          numeric);
> +	owner_mt_print_item(info, "owner GID match",     XT_OWNER_GID,          numeric);
> +	owner_mt_print_item(info, "incl. suppl. groups", XT_OWNER_SUPPL_GROUPS, numeric);
>  }
>  
>  static void
> @@ -487,9 +496,10 @@ static void owner_mt_save(const void *ip, const struct xt_entry_match *match)
>  {
>  	const struct xt_owner_match_info *info = (void *)match->data;
>  
> -	owner_mt_print_item(info, "--socket-exists",  XT_OWNER_SOCKET, true);
> -	owner_mt_print_item(info, "--uid-owner",      XT_OWNER_UID,    true);
> -	owner_mt_print_item(info, "--gid-owner",      XT_OWNER_GID,    true);
> +	owner_mt_print_item(info, "--socket-exists",  XT_OWNER_SOCKET,       true);
> +	owner_mt_print_item(info, "--uid-owner",      XT_OWNER_UID,          true);
> +	owner_mt_print_item(info, "--gid-owner",      XT_OWNER_GID,          true);
> +	owner_mt_print_item(info, "--suppl-groups",   XT_OWNER_SUPPL_GROUPS, true);
>  }
>  
>  static int
> diff --git a/extensions/libxt_owner.man b/extensions/libxt_owner.man
> index 49b58cee..e2479865 100644
> --- a/extensions/libxt_owner.man
> +++ b/extensions/libxt_owner.man
> @@ -15,5 +15,9 @@ given user. You may also specify a numerical UID, or an UID range.
>  Matches if the packet socket's file structure is owned by the given group.
>  You may also specify a numerical GID, or a GID range.
>  .TP
> +\fB\-\-suppl\-groups\fP
> +Causes group(s) specified with \fB\-\-gid-owner\fP to be also checked in the
> +supplementary groups of a process.
> +.TP
>  [\fB!\fP] \fB\-\-socket\-exists\fP
>  Matches if the packet is associated with a socket.
> diff --git a/include/linux/netfilter/xt_owner.h b/include/linux/netfilter/xt_owner.h
> index 20817617..e7731dcc 100644
> --- a/include/linux/netfilter/xt_owner.h
> +++ b/include/linux/netfilter/xt_owner.h
> @@ -4,9 +4,10 @@
>  #include <linux/types.h>
>  
>  enum {
> -	XT_OWNER_UID    = 1 << 0,
> -	XT_OWNER_GID    = 1 << 1,
> -	XT_OWNER_SOCKET = 1 << 2,
> +	XT_OWNER_UID          = 1 << 0,
> +	XT_OWNER_GID          = 1 << 1,
> +	XT_OWNER_SOCKET       = 1 << 2,
> +	XT_OWNER_SUPPL_GROUPS = 1 << 3,
>  };
>  
>  struct xt_owner_match_info {
> -- 
> 2.20.1
> 
