Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910B23836AB
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 17:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243597AbhEQPfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 11:35:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:52508 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244705AbhEQPdB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 11:33:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1621265504; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D78x0RQykGxtuFVKDLK2tegONNqQIINNV1fp5HE+u1o=;
        b=UlpURxft8mCNp5WtrDPvtUpGOpEsRnDR0jJF0c7mh+vDsIm6ScJ7qTGjqT60UiVDQRJ6k0
        41KGiWtA9xdJD4l8MO7kltHMJ9fUX+Dq08VZR9dbQatXEsB9+Cf/xLGKQnaKCC2nOvEHGu
        Hwt42g0mrif5bw2UWDSVartMsW1ZQPg=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4AAFDB038;
        Mon, 17 May 2021 15:31:44 +0000 (UTC)
Subject: Re: [PATCH 7/8] xen/netfront: don't trust the backend response data
 blindly
To:     Juergen Gross <jgross@suse.com>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210513100302.22027-1-jgross@suse.com>
 <20210513100302.22027-8-jgross@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
Message-ID: <18aa307e-edf0-cb8b-1fd2-2b5c89522d02@suse.com>
Date:   Mon, 17 May 2021 17:31:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210513100302.22027-8-jgross@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.05.2021 12:03, Juergen Gross wrote:
> @@ -429,6 +453,12 @@ static void xennet_tx_buf_gc(struct netfront_queue *queue)
>  	} while (more_to_do);
>  
>  	xennet_maybe_wake_tx(queue);
> +
> +	return;
> +
> + err:
> +	queue->info->broken = true;
> +	dev_alert(dev, "Disabled for further use\n");
>  }

If in blkfront the ability to revive a device via a suspend/resume cycle
is "a nice side effect", wouldn't it be nice for all frontends to behave
similarly in this regard? I.e. wouldn't you want to also clear this flag
somewhere? And shouldn't additionally / more generally a disconnect /
connect cycle allow proper operation again?

> @@ -472,6 +502,13 @@ static void xennet_tx_setup_grant(unsigned long gfn, unsigned int offset,
>  
>  	*tx = info->tx_local;
>  
> +	/*
> +	 * The request is not in its final form, as size and flags might be
> +	 * modified later, but even if a malicious backend will send a response
> +	 * now, nothing bad regarding security could happen.
> +	 */
> +	queue->tx_pending[id] = true;

I'm not sure I can agree with what the comment says. If the backend
sent a response prematurely, wouldn't the underlying slot(s) become
available for re-use, and hence potentially get filled / updated by
two parties?

Jan
