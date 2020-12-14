Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3DCC2D9432
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 09:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439302AbgLNIg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 03:36:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:60310 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439298AbgLNIg0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 03:36:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5570DAC10;
        Mon, 14 Dec 2020 08:35:45 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 31006603AD; Mon, 14 Dec 2020 09:35:42 +0100 (CET)
Date:   Mon, 14 Dec 2020 09:35:42 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     "John W. Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org, Roy Novich <royno@nvidia.com>
Subject: Re: [PATCH ethtool] ethtool: do_sset return correct value on fail
Message-ID: <20201214083542.qfzq4k3bi5qvp2rh@lion.mk-sys.cz>
References: <20201213142503.25509-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201213142503.25509-1-tariqt@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 13, 2020 at 04:25:03PM +0200, Tariq Toukan wrote:
> From: Roy Novich <royno@nvidia.com>
> 
> The return value for do_sset was constant and returned 0.
> This value is misleading when returned on operation failure.
> Changed return value to the correct function err status.
> 
> Fixes: 32c8037055f5 ("Initial import of ethtool version 3 + a few patches.")
> Signed-off-by: Roy Novich <royno@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  ethtool.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/ethtool.c b/ethtool.c
> index 1d9067e774af..5cc875c64591 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -3287,7 +3287,7 @@ static int do_sset(struct cmd_context *ctx)
>  		}
>  	}
>  
> -	return 0;
> +	return err;
>  }
>  
>  static int do_gregs(struct cmd_context *ctx)

I'm afraid it's not as easy as this. The problem with -s/--set
subcommand is that its parameters are in fact implemented by three
separate requests (for ioctl, four requests for netlink). Each of them
may fail or succeed independently of others. Currently do_sset() always
returns 0 which is indeed unfortunate but it's not clear what should we
return if some requests fail and some succeed.

With your patch, do_sset() would always return the result of last
request it sent to kernel which is inconsistent; consider e.g.

  ethtool -s eth0 mdix on wol g

If the ETHTOOL_SLINKSETTINGS request setting MDI-X succeeds and
ETHTOOL_SWOL setting WoL fails, the result would be a failure. But if
setting MDI-X fails and setting WoL succeeds, do_sset() would report
success.

So if we really want to change the behaviour after so many years, it
should be consistent: either return non-zero exit code if any request
fails or if all fail. (Personally, I would prefer the latter.) And we
should probably modify nl_sset() to behave the same way as it currently
bails out on first failed request.

Michal
