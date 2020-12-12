Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595492D8A7C
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 00:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408138AbgLLXAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 18:00:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:41376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgLLW7o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 17:59:44 -0500
Date:   Sat, 12 Dec 2020 14:59:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607813943;
        bh=eksXrUy9J7lcb/jfsVAG+iZF3Vn2ZprlXCYYGtli7FQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=jM5CzX9lAwZSYOppyjaj4xMdlqznCIw15+iiMQ32bWO3ZXGVCoNkqmXYSJ5x/fusT
         FOw45beMCibpR22wyXlxpvH35Cg2GPOs1f0vfWfxFo6ypKlC2zYwEZfGmYuM3pXetK
         93kR/9q2BsL8sPVClQ3L/0ajUUn5Ez6Jjd/La7tEr8DRg6GLF34IbemF7M4C0iSIDd
         fTd+8pkdL9tFtcn2xKAegSSy5IrA5e+FfK7xq3zispBA2nY56WRxXOqccuKxNM18vq
         Pcmk6ZUgbVU9ihosn2xsES1ELKoYYtjmWmeSIWWoiKYhXf4mzyOyG+e2YE+EIvbFTo
         sZwGc/qz81Wqw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>, Hillf Danton <hdanton@sina.com>
Subject: Re: [PATCH net-next v4 3/3] net: add sysfs attribute to control
 napi threaded mode
Message-ID: <20201212145902.1285a8ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201209005444.1949356-4-weiwan@google.com>
References: <20201209005444.1949356-1-weiwan@google.com>
        <20201209005444.1949356-4-weiwan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Dec 2020 16:54:44 -0800 Wei Wang wrote:
> +static void dev_disable_threaded_all(struct net_device *dev)
> +{
> +	struct napi_struct *napi;
> +
> +	list_for_each_entry(napi, &dev->napi_list, dev_list)
> +		napi_set_threaded(napi, false);
> +}

This is an implementation detail which should be hidden in dev.c IMHO.
Since the sysfs knob is just a device global on/off the iteration over
napis and all is best hidden away.

(sorry about the delayed review BTW, hope we can do a minor revision
and still hit 5.12)

> +static int modify_napi_threaded(struct net_device *dev, unsigned long val)
> +{
> +	struct napi_struct *napi;
> +	int ret;
> +
> +	if (list_empty(&dev->napi_list))
> +		return -EOPNOTSUPP;
> +
> +	list_for_each_entry(napi, &dev->napi_list, dev_list) {
> +		ret = napi_set_threaded(napi, !!val);
> +		if (ret) {
> +			/* Error occurred on one of the napi,
> +			 * reset threaded mode on all napi.
> +			 */
> +			dev_disable_threaded_all(dev);
> +			break;
> +		}
> +	}
> +
> +	return ret;
> +}
