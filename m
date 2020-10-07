Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A1A285A66
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 10:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbgJGIYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 04:24:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbgJGIYm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 04:24:42 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 070D42083B;
        Wed,  7 Oct 2020 08:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602059081;
        bh=GxmpJaUjn5SjdafKQrEfNO0D+gsvqEr55tdHjRWf85w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MBllWHyNTIutEnKDMLqK7pYygHFQujFRXsvzOjid+n1/rCA5nNS7ucJGTi4wKRZZj
         T+E7h040cNAsDb1jcmxMMjgePE2YGQ0uUS5Kb8pgOSsCn9gE5467ZhsbqysirA1Y4M
         V97uAwjQAHPdRyYCDwiOyxNMZzLcOjOwgpADWDpQ=
Date:   Wed, 7 Oct 2020 11:24:37 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-team@fb.com, jiri@resnulli.us,
        andrew@lunn.ch, mkubecek@suse.cz,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next v2 0/7] ethtool: allow dumping policies to user
 space
Message-ID: <20201007082437.GV1874917@unreal>
References: <20201005220739.2581920-1-kuba@kernel.org>
 <7586c9e77f6aa43e598103ccc25b43415752507d.camel@sipsolutions.net>
 <20201006.062618.628708952352439429.davem@davemloft.net>
 <20201007062754.GU1874917@unreal>
 <cf5fdfa13cce37fe7dcf46a4e3a113a64c927047.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf5fdfa13cce37fe7dcf46a4e3a113a64c927047.camel@sipsolutions.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 09:30:51AM +0200, Johannes Berg wrote:
> On Wed, 2020-10-07 at 09:27 +0300, Leon Romanovsky wrote:
> >
> > This series and my guess that it comes from ff419afa4310 ("ethtool: trim policy tables")
> > generates the following KASAN out-of-bound error.
>
> Interesting. I guess that is
>
> 	req_info->counts_only = tb[ETHTOOL_A_STRSET_COUNTS_ONLY];
>
> which basically means that before you never actually *use* the
> ETHTOOL_A_STRSET_COUNTS_ONLY flag, but of course it shouldn't be doing
> this ...
>
> Does this fix it?

Yes, it fixed KASAN, but it we got new failure after that.

11:07:51 player_id: 1 shell.py:62 [LinuxEthtoolAgent] DEBUG : running command(/opt/mellanox/ethtool/sbin/ethtool --set-channels eth2 combined 3) with pid: 13409
11:07:51 player_id: 1 protocol.py:605 [OpSetChannels] ERROR : RC:1, STDERR:
netlink error: Unknown attribute type (offset 36)
netlink error: Invalid argument

>
> diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
> index 3f5719786b0f..d8efec516d86 100644
> --- a/net/ethtool/netlink.h
> +++ b/net/ethtool/netlink.h
> @@ -347,7 +347,7 @@ extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
>
>  extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
>  extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
> -extern const struct nla_policy ethnl_strset_get_policy[ETHTOOL_A_STRSET_STRINGSETS + 1];
> +extern const struct nla_policy ethnl_strset_get_policy[ETHTOOL_A_STRSET_COUNTS_ONLY + 1];
>  extern const struct nla_policy ethnl_linkinfo_get_policy[ETHTOOL_A_LINKINFO_HEADER + 1];
>  extern const struct nla_policy ethnl_linkinfo_set_policy[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL + 1];
>  extern const struct nla_policy ethnl_linkmodes_get_policy[ETHTOOL_A_LINKMODES_HEADER + 1];
> diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
> index 0734e83c674c..0baad0ce1832 100644
> --- a/net/ethtool/strset.c
> +++ b/net/ethtool/strset.c
> @@ -103,6 +103,7 @@ const struct nla_policy ethnl_strset_get_policy[] = {
>  	[ETHTOOL_A_STRSET_HEADER]	=
>  		NLA_POLICY_NESTED(ethnl_header_policy),
>  	[ETHTOOL_A_STRSET_STRINGSETS]	= { .type = NLA_NESTED },
> +	[ETHTOOL_A_STRSET_COUNTS_ONLY]	= { .type = NLA_FLAG },
>  };
>
>  static const struct nla_policy get_stringset_policy[] = {
>
> johannes
>
