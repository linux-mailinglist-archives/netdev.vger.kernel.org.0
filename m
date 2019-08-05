Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2216C813E3
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 10:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfHEIEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 04:04:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:37608 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726518AbfHEIEv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 04:04:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2D628AF83;
        Mon,  5 Aug 2019 08:04:49 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 0F7B9E00A4; Mon,  5 Aug 2019 10:04:48 +0200 (CEST)
Date:   Mon, 5 Aug 2019 10:04:48 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Vivien Didelot <vivien.didelot@gmail.com>, f.fainelli@gmail.com,
        andrew@lunn.ch, davem@davemloft.net, linville@redhat.com,
        cphealy@gmail.com
Subject: Re: [PATCH ethtool] ethtool: dump nested registers
Message-ID: <20190805080448.GA31971@unicorn.suse.cz>
References: <20190802193455.17126-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802193455.17126-1-vivien.didelot@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 02, 2019 at 03:34:54PM -0400, Vivien Didelot wrote:
> Usually kernel drivers set the regs->len value to the same length as
> info->regdump_len, which was used for the allocation. In case where
> regs->len is smaller than the allocated info->regdump_len length,
> we may assume that the dump contains a nested set of registers.
> 
> This becomes handy for kernel drivers to expose registers of an
> underlying network conduit unfortunately not exposed to userspace,
> as found in network switching equipment for example.
> 
> This patch adds support for recursing into the dump operation if there
> is enough room for a nested ethtool_drvinfo structure containing a
> valid driver name, followed by a ethtool_regs structure like this:
> 
>     0      regs->len                        info->regdump_len
>     v              v                                        v
>     +--------------+-----------------+--------------+-- - --+
>     | ethtool_regs | ethtool_drvinfo | ethtool_regs |       |
>     +--------------+-----------------+--------------+-- - --+
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> ---

I'm not sure about this approach. If these additional objects with their
own registers are represented by a network device, we can query their
registers directly. If they are not (which, IIUC, is the case in your
use case), we should use an appropriate interface. AFAIK the CPU ports
are already represented in devlink, shouldn't devlink be also used to
query their registers?

>  ethtool.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/ethtool.c b/ethtool.c
> index 05fe05a08..c0e2903c5 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -1245,7 +1245,7 @@ static int dump_regs(int gregs_dump_raw, int gregs_dump_hex,
>  
>  	if (gregs_dump_raw) {
>  		fwrite(regs->data, regs->len, 1, stdout);
> -		return 0;
> +		goto nested;
>  	}
>  
>  	if (!gregs_dump_hex)
> @@ -1253,7 +1253,7 @@ static int dump_regs(int gregs_dump_raw, int gregs_dump_hex,
>  			if (!strncmp(driver_list[i].name, info->driver,
>  				     ETHTOOL_BUSINFO_LEN)) {
>  				if (driver_list[i].func(info, regs) == 0)
> -					return 0;
> +					goto nested;
>  				/* This version (or some other
>  				 * variation in the dump format) is
>  				 * not handled; fall back to hex
> @@ -1263,6 +1263,15 @@ static int dump_regs(int gregs_dump_raw, int gregs_dump_hex,
>  
>  	dump_hex(stdout, regs->data, regs->len, 0);
>  
> +nested:
> +	/* Recurse dump if some drvinfo and regs structures are nested */
> +	if (info->regdump_len > regs->len + sizeof(*info) + sizeof(*regs)) {
> +		info = (struct ethtool_drvinfo *)(&regs->data[0] + regs->len);
> +		regs = (struct ethtool_regs *)(&regs->data[0] + regs->len + sizeof(*info));
> +
> +		return dump_regs(gregs_dump_raw, gregs_dump_hex, info, regs);
> +	}
> +
>  	return 0;
>  }
>  

For raw and hex dumps, this will dump only the payloads without any
metadata allowing to identify what are the additional blocks for the
other related objects, i.e. where they start, how long they are and what
they belong to. That doesn't seem very useful.

Michal Kubecek
