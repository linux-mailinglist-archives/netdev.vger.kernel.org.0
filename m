Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97AD6CDC88
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 09:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbfJGHn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 03:43:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58434 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726202AbfJGHn5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 03:43:57 -0400
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 72EEE90C87
        for <netdev@vger.kernel.org>; Mon,  7 Oct 2019 07:43:57 +0000 (UTC)
Received: by mail-qt1-f198.google.com with SMTP id s14so14494169qtn.4
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 00:43:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lXk6nBFGAT4BSmxIglRrQ4LU7TGp8TlXjdfd6qKXf1s=;
        b=JyOgtM6bLvA6EiWe0zAN4UPejLAxW5BcfXZke6FIRZwwSumm4CKD7PLB8uXOHLWpc1
         eyqlm1vAh7nG9KcnbXkN5hqEQBMmvLQYTaIH0LKDl1rWkHdVGGUsO2Dkd4G0ZYpL0eG5
         uyXM5l3Rg5cWe8MO7kz3AjAB0SkCZOK3O2giAfVMYLGcGd/OY53i4MatoFrtGoBYhsrz
         wu+pNs18Z4nibwLYpdDDh9RT6446w6LaQaLrx5SNRlJftcci0m7lKOifMiy3jIm/lyi/
         e0NNe7PQnfmHwpfJfDnszpLGwOBgWDkcinJJKVNR3we5WvEqvt1FFbCwoLvnR3Eam5HG
         1IGA==
X-Gm-Message-State: APjAAAWEtuht683DDgCUna2pauPow7UuEvfwhyZy3GBtsDBdpbJ6eHf9
        SqJ6dVlUHyFFM67mLMRKu8Nfi2e7+8MpsMFgSeDqQvqjTFDlHDQ45CHAt83098fpltlI+pa6SK9
        PIfqFZkWYiIUouPRM
X-Received: by 2002:a37:8f86:: with SMTP id r128mr11730766qkd.392.1570434236764;
        Mon, 07 Oct 2019 00:43:56 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwkDu5dwf58X+8XqrTkuWmYKPmGulasUqtYDa0HzyNEwPsxZficIEoe2hRrlOTxmgzFj1vQuA==
X-Received: by 2002:a37:8f86:: with SMTP id r128mr11730756qkd.392.1570434236539;
        Mon, 07 Oct 2019 00:43:56 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id w11sm9017122qtj.10.2019.10.07.00.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 00:43:55 -0700 (PDT)
Date:   Mon, 7 Oct 2019 03:43:50 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     jcfaracco@gmail.com
Cc:     netdev@vger.kernel.org, jasowang@redhat.com, davem@davemloft.net,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, dnmendes76@gmail.com
Subject: Re: [PATCH RFC net-next 0/2] drivers: net: virtio_net: Implement
Message-ID: <20191007034208-mutt-send-email-mst@kernel.org>
References: <20191006184515.23048-1-jcfaracco@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191006184515.23048-1-jcfaracco@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 06, 2019 at 03:45:13PM -0300, jcfaracco@gmail.com wrote:
> From: Julio Faracco <jcfaracco@gmail.com>
> 
> Driver virtio_net is not handling error events for TX provided by 
> dev_watchdog. This event is reached when transmission queue is having 
> problems to transmit packets. To enable it, driver should have 
> .ndo_tx_timeout implemented. This serie has two commits:
> 
> In the past, we implemented a function to recover driver state when this
> kind of event happens, but the structure was to complex for virtio_net
> that moment.

It's more that it was missing a bunch of locks.

> Alternativelly, this skeleton should be enough for now.
>
> For further details, see thread:
> https://lkml.org/lkml/2015/6/23/691
> 
> Patch 1/2:
>   Add statistic field for TX timeout events.
> 
> Patch 2/2:
>   Implement a skeleton function to debug TX timeout events.
> 
> Julio Faracco (2):
>   drivers: net: virtio_net: Add tx_timeout stats field
>   drivers: net: virtio_net: Add tx_timeout function
> 
>  drivers/net/virtio_net.c | 33 ++++++++++++++++++++++++++++++++-
>  1 file changed, 32 insertions(+), 1 deletion(-)
> 
> -- 
> 2.21.0
