Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794AF1EFE29
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 18:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgFEQna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 12:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgFEQna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 12:43:30 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96D2C08C5C2
        for <netdev@vger.kernel.org>; Fri,  5 Jun 2020 09:43:29 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s10so5437282pgm.0
        for <netdev@vger.kernel.org>; Fri, 05 Jun 2020 09:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0ejkDDgC1ptVP6tIC68TfOgCwch5hBfnFFCcljdYyEs=;
        b=m6r8nCIeQuRJGGb6ifJbf7jeC4lJCAevIAGU8HaxY7NrpkmLNA+Yww+KEO6Z76u8zw
         3uAXHVGHqHw6gAeg6Sn6GOwcEuIKVk6V4sPtFd+7AzJoC7ou9YrYGD4C8zZFgQjJC4nC
         4MRf6hV+xTD0iQxCRVAJkXCXbfThsqwQ0/OID30ABPqdBJfN6UAMdN8WXrYbCbecxc4o
         PALK7RGkS5UfzkRCy+sfn7qvO53Don1lJb3fin+QdMhkXYsWGRd0Py794ssmrCofFF7P
         wrogH5jZqFV/rjmpGFEGRKEd5jv6JrfEBB60PdV2lC6JYQBn4eEau8ROl/Xc0CpM5YTg
         osSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0ejkDDgC1ptVP6tIC68TfOgCwch5hBfnFFCcljdYyEs=;
        b=HdpOt1KdIdY6OUpFgAKD4aC+V0hswIJY7oX11dkYNRUK80XEUUyS9Q9PuH2NuZN4Th
         VxtvmWWJbd4WVOWUSBQca3/W9yvzDTtljDkpclDaAxYrX6WcuiSva0Mx+5WJYRN7nqYf
         Z7WX+SqRhEtQBZB2bNVklXDEQvI8dxekKfPd1EN1dqXxcXuBeR/4aJIfP7XS8o2cTza/
         8x7yimLewqa0N7Nv8zOz23sVErtcix7QGsYV3rROQj38SGELtCra8UhBOhma6BmGmLiX
         Ed5n9xyNbDdiPj6zqk7kS7/F3yhUeYcBcqrJzTi+8Rhcpq8i8GOboAzKGHryPg6ezaFI
         32Sg==
X-Gm-Message-State: AOAM532ChY9hmQ3ofvy0VDT5rIT5JjdU0+KcodeIscWHN9XdclZQWndN
        n55lEmUF8oMioHfmakcjc1XJOg3J
X-Google-Smtp-Source: ABdhPJwWWNDPZkG4V6YNnS1Cf1/oB7y4fYlMKdNLXWWPWO5LseNAsnjSznU4otxxAm//3muVyPP60A==
X-Received: by 2002:a63:7c5a:: with SMTP id l26mr9515148pgn.397.1591375409219;
        Fri, 05 Jun 2020 09:43:29 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id 207sm102999pfw.190.2020.06.05.09.43.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 09:43:28 -0700 (PDT)
Subject: Re: [PATCH] qrtr: Convert qrtr_ports from IDR to XArray
To:     Matthew Wilcox <willy@infradead.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
References: <20200605120037.17427-1-willy@infradead.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <9aa67df2-a539-29eb-c9e9-4dddcb73ec19@gmail.com>
Date:   Fri, 5 Jun 2020 09:43:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200605120037.17427-1-willy@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/5/20 5:00 AM, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> The XArray interface is easier for this driver to use.  Also fixes a
> bug reported by the improper use of GFP_ATOMIC.
> 

This does not look stable candidate.

If you try to add a Fixes: tag, you might discover that this bug is old,
and I do not believe XArray has been backported to stable branches ?


Please submit a fix suitable for old kernels (as old as v4.7)

Then when net-next is open in ~2 weeks, the Xarray stuff can be proposed.

Thanks.

> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  net/qrtr/qrtr.c | 39 +++++++++++++--------------------------
>  1 file changed, 13 insertions(+), 26 deletions(-)
> 
> diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> index 2d8d6131bc5f..488f8f326ee5 100644
> --- a/net/qrtr/qrtr.c
> +++ b/net/qrtr/qrtr.c
> @@ -20,6 +20,7 @@
>  /* auto-bind range */
>  #define QRTR_MIN_EPH_SOCKET 0x4000
>  #define QRTR_MAX_EPH_SOCKET 0x7fff
> +#define QRTR_PORT_RANGE	XA_LIMIT(QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET)
>  
>  /**
>   * struct qrtr_hdr_v1 - (I|R)PCrouter packet header version 1
> @@ -106,8 +107,7 @@ static LIST_HEAD(qrtr_all_nodes);
>  static DEFINE_MUTEX(qrtr_node_lock);
>  
>  /* local port allocation management */
> -static DEFINE_IDR(qrtr_ports);
> -static DEFINE_MUTEX(qrtr_port_lock);
> +static DEFINE_XARRAY_ALLOC(qrtr_ports);
>  
>  /**
>   * struct qrtr_node - endpoint node
> @@ -623,7 +623,7 @@ static struct qrtr_sock *qrtr_port_lookup(int port)
>  		port = 0;
>  
>  	rcu_read_lock();
> -	ipc = idr_find(&qrtr_ports, port);
> +	ipc = xa_load(&qrtr_ports, port);
>  	if (ipc)
>  		sock_hold(&ipc->sk);
>  	rcu_read_unlock();
> @@ -665,9 +665,7 @@ static void qrtr_port_remove(struct qrtr_sock *ipc)
>  
>  	__sock_put(&ipc->sk);
>  
> -	mutex_lock(&qrtr_port_lock);
> -	idr_remove(&qrtr_ports, port);
> -	mutex_unlock(&qrtr_port_lock);
> +	xa_erase(&qrtr_ports, port);
>  
>  	/* Ensure that if qrtr_port_lookup() did enter the RCU read section we
>  	 * wait for it to up increment the refcount */
> @@ -688,25 +686,18 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
>  {
>  	int rc;
>  
> -	mutex_lock(&qrtr_port_lock);
>  	if (!*port) {
> -		rc = idr_alloc(&qrtr_ports, ipc,
> -			       QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET + 1,
> -			       GFP_ATOMIC);
> -		if (rc >= 0)
> -			*port = rc;
> +		rc = xa_alloc(&qrtr_ports, port, ipc, QRTR_PORT_RANGE,
> +				GFP_KERNEL);
>  	} else if (*port < QRTR_MIN_EPH_SOCKET && !capable(CAP_NET_ADMIN)) {
>  		rc = -EACCES;
>  	} else if (*port == QRTR_PORT_CTRL) {
> -		rc = idr_alloc(&qrtr_ports, ipc, 0, 1, GFP_ATOMIC);
> +		rc = xa_insert(&qrtr_ports, 0, ipc, GFP_KERNEL);
>  	} else {
> -		rc = idr_alloc(&qrtr_ports, ipc, *port, *port + 1, GFP_ATOMIC);
> -		if (rc >= 0)
> -			*port = rc;
> +		rc = xa_insert(&qrtr_ports, *port, ipc, GFP_KERNEL);
>  	}
> -	mutex_unlock(&qrtr_port_lock);
>  
> -	if (rc == -ENOSPC)
> +	if (rc == -EBUSY)
>  		return -EADDRINUSE;
>  	else if (rc < 0)
>  		return rc;
> @@ -720,20 +711,16 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
>  static void qrtr_reset_ports(void)
>  {
>  	struct qrtr_sock *ipc;
> -	int id;
> -
> -	mutex_lock(&qrtr_port_lock);
> -	idr_for_each_entry(&qrtr_ports, ipc, id) {
> -		/* Don't reset control port */
> -		if (id == 0)
> -			continue;
> +	unsigned long index;
>  
> +	rcu_read_lock();
> +	xa_for_each_start(&qrtr_ports, index, ipc, 1) {
>  		sock_hold(&ipc->sk);
>  		ipc->sk.sk_err = ENETRESET;
>  		ipc->sk.sk_error_report(&ipc->sk);
>  		sock_put(&ipc->sk);
>  	}
> -	mutex_unlock(&qrtr_port_lock);
> +	rcu_read_unlock();
>  }
>  
>  /* Bind socket to address.
> 
