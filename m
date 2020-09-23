Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE012764A5
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 01:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgIWXgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 19:36:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726784AbgIWXgf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 19:36:35 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4660F20C09;
        Wed, 23 Sep 2020 23:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600904194;
        bh=2Dla7xdUQwE4mECr9B60cS+Y7FYMXy1gICdGz9LO4zg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VcC0Pjoa0hR3SX8qefJyMl84/fYCMDieTzLgkVJzQK3oH8T7mhhOGP6eNyvXPl9/0
         Pzph+eZTJ947UPohfPnUg8s9GA9TVwfgtsjE4YZeadJocNWaVinEWVSbDFGGeKMCep
         QlklDMheQSrQ7z9iyZifOzWS+BTBMhs1xV+DbKQ0=
Date:   Wed, 23 Sep 2020 16:36:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool-next 5/5] pause: add support for dumping
 statistics
Message-ID: <20200923163632.43269739@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200923224510.h3kpgczd6wkpoitp@lion.mk-sys.cz>
References: <20200915235259.457050-1-kuba@kernel.org>
        <20200915235259.457050-6-kuba@kernel.org>
        <20200923224510.h3kpgczd6wkpoitp@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Sep 2020 00:45:10 +0200 Michal Kubecek wrote:
> > +		if (mnl_attr_validate(tb[stats[i].attr], MNL_TYPE_U64)) {
> > +			fprintf(stderr, "malformed netlink message (statistic)\n");
> > +			goto err_close_stats;
> > +		}
> > +
> > +		n = snprintf(fmt, sizeof(fmt), "  %s: %%" PRId64 "\n",
> > +			     stats[i].name);  
> 
> The stats are unsigned so the format should be PRIu64 here.

Good catch.

> > @@ -173,8 +236,9 @@ int nl_gpause(struct cmd_context *ctx)
> >  		return 1;
> >  	}
> >  
> > +	flags = nlctx->ctx->show_stats ? ETHTOOL_FLAG_STATS : 0;
> >  	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_PAUSE_GET,
> > -				      ETHTOOL_A_PAUSE_HEADER, 0);
> > +				      ETHTOOL_A_PAUSE_HEADER, flags);
> >  	if (ret < 0)
> >  		return ret;
> >    
> 
> When the stats are supported by kernel but not provided by a device,
> the request will succeed and usual output without stats will be shown.
> However, when stats are requested on a pre-5.10 kernel not recognizing
> ETHTOOL_FLAG_STATS, the request will fail:
> 
>     mike@lion:~/work/git/ethtool> ./ethtool --debug 0x10 -I -a eth0  
>     netlink error: unrecognized request flags
>     netlink error: Operation not supported
>     offending message and attribute:
>         ETHTOOL_MSG_PAUSE_GET
>             ETHTOOL_A_PAUSE_HEADER
>                 ETHTOOL_A_HEADER_DEV_NAME = "eth0"
>     ===>        ETHTOOL_A_HEADER_FLAGS = 0x00000004  
> 
> We should probably repeat the request with flags=0 in this case but that
> would require keeping the offset of ETHTOOL_A_HEADER_FLAGS attribute and
> checking for -EOPNOTSUPP with this offset in nlsock_process_ack().

Makes sense, will do.
