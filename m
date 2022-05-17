Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C32A52AE46
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 00:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbiEQWsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 18:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbiEQWse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 18:48:34 -0400
X-Greylist: delayed 554 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 17 May 2022 15:48:33 PDT
Received: from einhorn-mail-out.in-berlin.de (einhorn.in-berlin.de [192.109.42.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C1352E6E
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 15:48:33 -0700 (PDT)
X-Envelope-From: thomas@x-berg.in-berlin.de
Received: from x-berg.in-berlin.de (x-change.in-berlin.de [217.197.86.40])
        by einhorn.in-berlin.de  with ESMTPS id 24HMcbtL364300
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 00:38:37 +0200
Received: from thomas by x-berg.in-berlin.de with local (Exim 4.94.2)
        (envelope-from <thomas@x-berg.in-berlin.de>)
        id 1nr5pt-0007Y6-GD; Wed, 18 May 2022 00:38:37 +0200
Date:   Wed, 18 May 2022 00:38:37 +0200
From:   Thomas Osterried <thomas@osterried.de>
To:     Lu Wei <luwei32@huawei.com>
Cc:     jreuter@yaina.de, ralf@linux-mips.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] ax25: merge repeat codes in
 ax25_dev_device_down()
Message-ID: <YoQj7eND7/2KSBFs@x-berg.in-berlin.de>
References: <20220516062804.254742-1-luwei32@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516062804.254742-1-luwei32@huawei.com>
Sender: Thomas Osterried <thomas@x-berg.in-berlin.de>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

three comments.


1. We need time for questions and discussions

In the past, we had several problems with patches that went upstream which
obviously not have been tested.
We have several requests by our community at linux-hams, that we need
to have a chance to read a patch proposal, and have time to test it,
before things become worse.


2. Due to some patches that went in the current torwalds-tree, ax25 became
unusable in a production environment (!).

I'll come to this in another mail, with description and proposal for a fix.
We are currently testing it and like to send it on linux-hams with request
to comment and test.


3. About this patch for ax25_dev_device_down() which reached netdev-next:

Looks good regarding the changes.

But when looking at it, it raises a question due to an older patch, that introduced
dev_put_track().
It's just a question of comprehension:
  If the position of the device that has to be removed is
    - at the head of the device list: do dev_put_track()
    - in the the device list or at the end: dev_put_track()
    - not in the device list: do _not_ dev_put_track().
      Why? - Not obviously clear. I think, because an interface could exist,
      but is set to down and thus is not part of the list (-> then you can't see
      it as /proc/sys/net/ax25/<name>).


-> Personally, I'd consider

- this better readable:

	int found = 0;

	if (ax25_dev_list == ax25_dev) {
		ax25_dev_list = s->next;
		found = 1;
	} else {
		for (s = ax25_dev_list; s != NULL && s->next != NULL; s = s->next) {
			if (s->next == ax25_dev) {
				s->next = s->next->next;
				found = 1;
				break;
			}
		}
	}

	spin_unlock_bh(&ax25_dev_lock);
	ax25_dev_put(ax25_dev);
	dev->ax25_ptr = NULL;
	if (found)
		dev_put_track(dev, &ax25_dev->dev_tracker);
	ax25_dev_put(ax25_dev);


- ..or with goto:

	int found = 1;

	if (ax25_dev_list == ax25_dev) {
		ax25_dev_list = s->next;
		goto out;
	}
	for (s = ax25_dev_list; s != NULL && s->next != NULL; s = s->next) {
		if (s->next == ax25_dev) {
			s->next = s->next->next;
			goto out;
		}
	}
	found = 0;

out:
	spin_unlock_bh(&ax25_dev_lock);
	ax25_dev_put(ax25_dev);
	dev->ax25_ptr = NULL;
	if (found)
		dev_put_track(dev, &ax25_dev->dev_tracker);
	ax25_dev_put(ax25_dev);



- ..than this:

	if ((s = ax25_dev_list) == ax25_dev) {
		ax25_dev_list = s->next;
		goto unlock_put;
	}

	while (s != NULL && s->next != NULL) {
		if (s->next == ax25_dev) {
			s->next = ax25_dev->next;
			goto unlock_put;
		}

		s = s->next;
	}
	spin_unlock_bh(&ax25_dev_lock);
	dev->ax25_ptr = NULL;
	ax25_dev_put(ax25_dev);
	return;

unlock_put:
	spin_unlock_bh(&ax25_dev_lock);
	ax25_dev_put(ax25_dev);
	dev->ax25_ptr = NULL;
	dev_put_track(dev, &ax25_dev->dev_tracker);
	ax25_dev_put(ax25_dev);



vy 73,
	- Thomas  dl9sau


On Mon, May 16, 2022 at 02:28:04PM +0800, Lu Wei wrote:
> Merge repeat codes to reduce the duplication.
> 
> Signed-off-by: Lu Wei <luwei32@huawei.com>
> ---
>  net/ax25/ax25_dev.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
> index d2a244e1c260..b80fccbac62a 100644
> --- a/net/ax25/ax25_dev.c
> +++ b/net/ax25/ax25_dev.c
> @@ -115,23 +115,13 @@ void ax25_dev_device_down(struct net_device *dev)
>  
>  	if ((s = ax25_dev_list) == ax25_dev) {
>  		ax25_dev_list = s->next;
> -		spin_unlock_bh(&ax25_dev_lock);
> -		ax25_dev_put(ax25_dev);
> -		dev->ax25_ptr = NULL;
> -		dev_put_track(dev, &ax25_dev->dev_tracker);
> -		ax25_dev_put(ax25_dev);
> -		return;
> +		goto unlock_put;
>  	}
>  
>  	while (s != NULL && s->next != NULL) {
>  		if (s->next == ax25_dev) {
>  			s->next = ax25_dev->next;
> -			spin_unlock_bh(&ax25_dev_lock);
> -			ax25_dev_put(ax25_dev);
> -			dev->ax25_ptr = NULL;
> -			dev_put_track(dev, &ax25_dev->dev_tracker);
> -			ax25_dev_put(ax25_dev);
> -			return;
> +			goto unlock_put;
>  		}
>  
>  		s = s->next;
> @@ -139,6 +129,14 @@ void ax25_dev_device_down(struct net_device *dev)
>  	spin_unlock_bh(&ax25_dev_lock);
>  	dev->ax25_ptr = NULL;
>  	ax25_dev_put(ax25_dev);
> +	return;
> +
> +unlock_put:
> +	spin_unlock_bh(&ax25_dev_lock);
> +	ax25_dev_put(ax25_dev);
> +	dev->ax25_ptr = NULL;
> +	dev_put_track(dev, &ax25_dev->dev_tracker);
> +	ax25_dev_put(ax25_dev);
>  }
>  
>  int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
> -- 
> 2.17.1
> 
> 
