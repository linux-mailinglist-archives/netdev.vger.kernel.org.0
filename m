Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB91227FD40
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 12:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731921AbgJAKYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 06:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgJAKYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 06:24:41 -0400
X-Greylist: delayed 1400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 01 Oct 2020 03:24:41 PDT
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708F2C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 03:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=r356dJaXk06tIQ6jUr0f06tgcRqDpQ5QfCLEdeDlm9E=; b=Jnlqv74RDRFjmJWg/zNTnXN7gI
        xrQJEHDSIbyahUEi+TppLRpP7w53kAzMX8pAVYOGzgUAVNpbvlzrsi7QDU9rKUj5QPLJI0RHesVbQ
        jV9ZHDHoJ46WoFxBuUZXqRdz99yrJBG+p/EeV0iz45aOaTAx9GPtBZDFbLbs0G6F+GYY=;
Received: from p4ff134da.dip0.t-ipconnect.de ([79.241.52.218] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1kNvOb-0004eR-6n; Thu, 01 Oct 2020 12:01:05 +0200
Subject: Re: [PATCH net-next 5/5] net: improve napi threaded config
To:     Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20200930192140.4192859-1-weiwan@google.com>
 <20200930192140.4192859-6-weiwan@google.com>
From:   Felix Fietkau <nbd@nbd.name>
Message-ID: <03d4edde-dce3-b263-39eb-d217f06936da@nbd.name>
Date:   Thu, 1 Oct 2020 12:01:03 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20200930192140.4192859-6-weiwan@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020-09-30 21:21, Wei Wang wrote:
> This commit mainly addresses the threaded config to make the switch
> between softirq based and kthread based NAPI processing not require
> a device down/up.
> It also moves the kthread_create() call to the sysfs handler when user
> tries to enable "threaded" on napi, and properly handles the
> kthread_create() failure. This is because certain drivers do not have
> the napi created and linked to the dev when dev_open() is called. So
> the previous implementation does not work properly there.
> 
> Signed-off-by: Wei Wang <weiwan@google.com>
> ---
> Changes since RFC:
> changed the thread name to napi/<dev>-<napi-id>
> 
>  net/core/dev.c       | 49 +++++++++++++++++++++++++-------------------
>  net/core/net-sysfs.c |  9 +++-----
>  2 files changed, 31 insertions(+), 27 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index b4f33e442b5e..bf878d3a9d89 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -1490,17 +1490,24 @@ EXPORT_SYMBOL(netdev_notify_peers);
>  
>  static int napi_threaded_poll(void *data);
>  
> -static void napi_thread_start(struct napi_struct *n)
> +static int napi_kthread_create(struct napi_struct *n)
>  {
> -	if (test_bit(NAPI_STATE_THREADED, &n->state) && !n->thread)
> -		n->thread = kthread_create(napi_threaded_poll, n, "%s-%d",
> -					   n->dev->name, n->napi_id);
> +	int err = 0;
> +
> +	n->thread = kthread_create(napi_threaded_poll, n, "napi/%s-%d",
> +				   n->dev->name, n->napi_id);
> +	if (IS_ERR(n->thread)) {
> +		err = PTR_ERR(n->thread);
> +		pr_err("kthread_create failed with err %d\n", err);
> +		n->thread = NULL;
> +	}
> +
> +	return err;
If I remember correctly, using kthread_create with no explicit first
wakeup means the task will sit there and contribute to system loadavg
until it is woken up the first time.
Shouldn't we use kthread_run here instead?

- Felix
