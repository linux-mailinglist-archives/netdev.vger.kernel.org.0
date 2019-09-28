Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45406C1206
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 21:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbfI1Tgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 15:36:50 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:33864 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfI1Tgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 15:36:50 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iEIWJ-0003DE-P7; Sat, 28 Sep 2019 21:36:43 +0200
Message-ID: <d1b5d944fef2a2d5875a0f12f3cdc490586da475.camel@sipsolutions.net>
Subject: Re: [PATCH net v4 01/12] net: core: limit nested device depth
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        jakub.kicinski@netronome.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com, schuffelen@google.com, bjorn@mork.no
Date:   Sat, 28 Sep 2019 21:36:41 +0200
In-Reply-To: <20190928164843.31800-2-ap420073@gmail.com> (sfid-20190928_184915_401198_09506C74)
References: <20190928164843.31800-1-ap420073@gmail.com>
         <20190928164843.31800-2-ap420073@gmail.com>
         (sfid-20190928_184915_401198_09506C74)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

>  int netdev_walk_all_upper_dev_rcu(struct net_device *dev,
>  				  int (*fn)(struct net_device *dev,
>  					    void *data),
>  				  void *data)
>  {
[...]
>  	}
>  
>  	return 0;
> +
>  }

that seems like an oversight, probably from editing the patch in
different versions?

> +static int __netdev_update_upper_level(struct net_device *dev, void *data)
> +{
> +	dev->upper_level = __netdev_upper_depth(dev) + 1;
> +	return 0;
> +}
> +
> +static int __netdev_update_lower_level(struct net_device *dev, void *data)
> +{
> +	dev->lower_level = __netdev_lower_depth(dev) + 1;
> +	return 0;
> +}

Is there any point in the return value here? You don't really use it,
afaict? I guess I might see the point if it was used for tail-call
optimisation or such?


Also, I dunno, I guess netdevs aren't as much under pressure as SKBs :-)
but do we actually gain much from storing the nesting level at all? You
have to maintain it all the time anyway when adding/removing and that's
the only place where you also check it, so perhaps it wouldn't be that
bad to just count at that time?

But then again the counting would probably be recursive again ...

>  	return 0;
> +
>  }
>  EXPORT_SYMBOL_GPL(netdev_walk_all_lower_dev_rcu);

same nit as above
 
> +	__netdev_update_upper_level(dev, NULL);
> +	netdev_walk_all_lower_dev(dev, __netdev_update_upper_level, NULL);
> +
> +	__netdev_update_lower_level(upper_dev, NULL);
> +	netdev_walk_all_upper_dev(upper_dev, __netdev_update_lower_level, NULL);

Actually, if I'm reading this correctly you already walk all the levels
anyway? Then couldn't you calculate the depth at this time and return
it, instead of storing it? Though, if it actually overflowed then you'd
have to walk *again* to undo that?

Hmm, actually, if you don't store the value you don't even need to walk
here I guess, or at least you would only have to do it to verify you
*can* attach, but wouldn't have to in detach?

So it looks to me like on attach (i.e. this code, quoted from
__netdev_upper_dev_link) you're already walking the entire graph to
update the level values, and could probably instead calculate the
nesting depth to validate it?
And then on netdev_upper_dev_unlink() you wouldn't even have to walk the
graph at all, since you only need that to update the values that you
stored.

But maybe I'm misinterpreting this completely?

Thanks,
johannes


