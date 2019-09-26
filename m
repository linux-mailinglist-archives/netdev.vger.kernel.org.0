Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F053DBFA26
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 21:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbfIZTdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 15:33:39 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40955 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728464AbfIZTdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 15:33:39 -0400
Received: by mail-pg1-f196.google.com with SMTP id w10so2080862pgj.7;
        Thu, 26 Sep 2019 12:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YNVcgmXz/4TZ89qYi72xdZ0yUZGHtVYXxe8ksb5z6rQ=;
        b=LQcKNvFcjhf52vkDhChHAvJBub24+VVIdIOAN7luWyloJjj814Bt3XCZXIbMU8zj01
         kS1rwkcd2Bg4aPyF0iZm2ti7VXkcCN03q0gQZdi2CTCJZW4UnpQfDmO6u1cIEeN8yyUD
         rU8aQCPP7+ctSxT69wkStouEDALcngcJwVngjR7FkKHWFb8zuKRBB8jtYDII4mzB8EaY
         KgJhQiVnwigoAvPDwF1NzdmCHQHJ9vSStF1HWIbSxnP7TcwpxT5P8YdIdrPPhrFudLzN
         g0jNanX52MuZ6WBfXHPxRwuYD55Gs3lM6BBD/0heBQ112rVUjXhYL1F6zlPm/unQAp35
         3yIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YNVcgmXz/4TZ89qYi72xdZ0yUZGHtVYXxe8ksb5z6rQ=;
        b=m78l8SwNICYAq6oO3nkH6i0XHxZWJp2DPOxxe6HKxwF0L5C0Ce3HbpFZvIbrxfOOEG
         mbogRXgMgY4TBtdDDuspLE+PdRANztUvxfIwQ2fruB6Bnq8VVsm7WHMtaAoJ6GNYEhzB
         ow1k3QTSA3yaTI++7W2y7/B9sqFTRn7zXym0r9moT8u+tl0fSSgFgtqgpK+a7xUpBy65
         Kkgv1jzb/m+oiMIdA/fWdaIV4yiJ64rxZaJcRWZrmJLuVKCa4Zqmt5k7FMWpeIP4/YUk
         bJmbsL37sNbvdjAIP11VrY2gv5llpu8HESw6xjKCzALgUI332DLCQNTirNyB4r8LaVcZ
         psBA==
X-Gm-Message-State: APjAAAV+3uYEeybtAOrjBzeYGIroUT5+z5VoO8m3tyfEj256NW57+bna
        7A3riJEkvINyBnv+g1LPxdQ=
X-Google-Smtp-Source: APXvYqwVC8CgaBAaZrZp18sW5w1ajggjrTQ+D9LBCv7HM3iy9PqeXuOf37BaQp134FgDRzhrNV1kIg==
X-Received: by 2002:a17:90a:cf0c:: with SMTP id h12mr5257802pju.110.1569526418858;
        Thu, 26 Sep 2019 12:33:38 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id v12sm2984732pgr.31.2019.09.26.12.33.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 12:33:37 -0700 (PDT)
Subject: Re: [PATCH] vsock/virtio: add support for MSG_PEEK
To:     Matias Ezequiel Vara Larsen <matiasevara@gmail.com>,
        stefanha@redhat.com
Cc:     davem@davemloft.net, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgarzare@redhat.com
References: <1569522214-28223-1-git-send-email-matiasevara@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <f069a65d-33b9-1fa8-d26e-b76cc51fc7cb@gmail.com>
Date:   Thu, 26 Sep 2019 12:33:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1569522214-28223-1-git-send-email-matiasevara@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/26/19 11:23 AM, Matias Ezequiel Vara Larsen wrote:
> This patch adds support for MSG_PEEK. In such a case, packets are not
> removed from the rx_queue and credit updates are not sent.
> 
> Signed-off-by: Matias Ezequiel Vara Larsen <matiasevara@gmail.com>
> ---
>  net/vmw_vsock/virtio_transport_common.c | 50 +++++++++++++++++++++++++++++++--
>  1 file changed, 47 insertions(+), 3 deletions(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 94cc0fa..938f2ed 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -264,6 +264,50 @@ static int virtio_transport_send_credit_update(struct vsock_sock *vsk,
>  }
>  
>  static ssize_t
> +virtio_transport_stream_do_peek(struct vsock_sock *vsk,
> +				struct msghdr *msg,
> +				size_t len)
> +{
> +	struct virtio_vsock_sock *vvs = vsk->trans;
> +	struct virtio_vsock_pkt *pkt;
> +	size_t bytes, total = 0;
> +	int err = -EFAULT;
> +
> +	spin_lock_bh(&vvs->rx_lock);
> +
> +	list_for_each_entry(pkt, &vvs->rx_queue, list) {
> +		if (total == len)
> +			break;
> +
> +		bytes = len - total;
> +		if (bytes > pkt->len - pkt->off)
> +			bytes = pkt->len - pkt->off;
> +
> +		/* sk_lock is held by caller so no one else can dequeue.
> +		 * Unlock rx_lock since memcpy_to_msg() may sleep.
> +		 */
> +		spin_unlock_bh(&vvs->rx_lock);
> +
> +		err = memcpy_to_msg(msg, pkt->buf + pkt->off, bytes);
> +		if (err)
> +			goto out;
> +
> +		spin_lock_bh(&vvs->rx_lock);
> +
> +		total += bytes;
> +	}
> +
> +	spin_unlock_bh(&vvs->rx_lock);
> +
> +	return total;
> +
> +out:
> +	if (total)
> +		err = total;
> +	return err;
> +}
>

This seems buggy to me.

virtio_transport_recv_enqueue() seems to be able to add payload to the last packet in the queue.

The loop you wrote here would miss newly added chunks while the vvs->rx_lock spinlock has been released.

virtio_transport_stream_do_dequeue() is ok, because it makes sure pkt->off == pkt->len
before cleaning the packet from the queue.



