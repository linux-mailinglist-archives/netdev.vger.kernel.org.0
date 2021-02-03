Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CE030D04A
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 01:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbhBCA3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 19:29:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:58576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231844AbhBCA3e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 19:29:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0885464F6A;
        Wed,  3 Feb 2021 00:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612312133;
        bh=9sOtX+VhRvenbNcun/nzOIkHz+oX4oIkdr4kXCrKI/s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WOy2DzDwyoOEPDf8WBXWGvrrWGRkkvwD5LwmMlaCio9lZ5oT+DMKDIfE5ZE+FZk2m
         MBLzM+qI6PJxsffYclHBRPO7t1X+LnV111V72/cYTHegTIPrTGRfU8mHk1uMCS8Y+U
         lJ/kWZ4Yvcpu1C/rN+BBd2B8/ZHJNYt5YjDbxSOOMPFtmk30BIwQg67IwkQchWfp/x
         V6CAUD2PoBpy1GMs9jl9vVfaxoUUUf2S+zHlpcgGxMJfPRAz+LlV6SUhCj2sXAxrvo
         Wp6/ZvAUv/gk5JJQU8yvNnYE6r1qe9JpT+MyAtmbASDTEwPf9SV9uzjAPFG2UDYpM5
         w0rFrPR2Pakqw==
Date:   Tue, 2 Feb 2021 16:28:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next v9 3/3] net: add sysfs attribute to control
 napi threaded mode
Message-ID: <20210202162851.1ba89f80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210129181812.256216-4-weiwan@google.com>
References: <20210129181812.256216-1-weiwan@google.com>
        <20210129181812.256216-4-weiwan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 10:18:12 -0800 Wei Wang wrote:
> This patch adds a new sysfs attribute to the network device class.
> Said attribute provides a per-device control to enable/disable the
> threaded mode for all the napi instances of the given network device,
> without the need for a device up/down.
> User sets it to 1 or 0 to enable or disable threaded mode.
> 
> Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Co-developed-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Wei Wang <weiwan@google.com>

> +static int napi_set_threaded(struct napi_struct *n, bool threaded)
> +{
> +	int err = 0;
> +
> +	if (threaded == !!test_bit(NAPI_STATE_THREADED, &n->state))
> +		return 0;
> +
> +	if (!threaded) {
> +		clear_bit(NAPI_STATE_THREADED, &n->state);

Can we put a note in the commit message saying that stopping the
threads is slightly tricky but we'll do it if someone complains?

Or is there a stronger reason than having to wait for thread to finish
up with the NAPI not to stop them?

> +		return 0;
> +	}
> +
> +	if (!n->thread) {
> +		err = napi_kthread_create(n);
> +		if (err)
> +			return err;
> +	}
> +
> +	/* Make sure kthread is created before THREADED bit
> +	 * is set.
> +	 */
> +	smp_mb__before_atomic();
> +	set_bit(NAPI_STATE_THREADED, &n->state);
> +
> +	return 0;
> +}
> +
> +static void dev_disable_threaded_all(struct net_device *dev)
> +{
> +	struct napi_struct *napi;
> +
> +	list_for_each_entry(napi, &dev->napi_list, dev_list)
> +		napi_set_threaded(napi, false);
> +	dev->threaded = 0;
> +}
> +
> +int dev_set_threaded(struct net_device *dev, bool threaded)
> +{
> +	struct napi_struct *napi;
> +	int ret;
> +
> +	dev->threaded = threaded;
> +	list_for_each_entry(napi, &dev->napi_list, dev_list) {
> +		ret = napi_set_threaded(napi, threaded);
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
> +
>  void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>  		    int (*poll)(struct napi_struct *, int), int weight)
>  {
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index daf502c13d6d..884f049ee395 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -538,6 +538,55 @@ static ssize_t phys_switch_id_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(phys_switch_id);
>  
> +static ssize_t threaded_show(struct device *dev,
> +			     struct device_attribute *attr, char *buf)
> +{
> +	struct net_device *netdev = to_net_dev(dev);
> +	int ret;
> +
> +	if (!rtnl_trylock())
> +		return restart_syscall();
> +
> +	if (!dev_isalive(netdev)) {
> +		ret = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	if (list_empty(&netdev->napi_list)) {
> +		ret = -EOPNOTSUPP;
> +		goto unlock;
> +	}

Maybe others disagree but I'd take this check out. What's wrong with
letting users see that threaded napi is disabled for devices without
NAPI?

This will also help a little devices which remove NAPIs when they are
down.

I've been caught off guard in the past by the fact that kernel returns
-ENOENT for XPS map when device has a single queue.

> +	ret = sprintf(buf, fmt_dec, netdev->threaded);
> +
> +unlock:
> +	rtnl_unlock();
> +	return ret;
> +}
> +
> +static int modify_napi_threaded(struct net_device *dev, unsigned long val)
> +{
> +	int ret;
> +
> +	if (list_empty(&dev->napi_list))
> +		return -EOPNOTSUPP;
> +
> +	if (val != 0 && val != 1)
> +		return -EOPNOTSUPP;
> +
> +	ret = dev_set_threaded(dev, val);
> +
> +	return ret;

return dev_set_threaded(dev, val);

> +}
