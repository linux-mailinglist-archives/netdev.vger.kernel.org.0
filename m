Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A534D47C7
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 14:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242299AbiCJNLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 08:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242142AbiCJNLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 08:11:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E370C4D629
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 05:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646917803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tLCt4+oXBNeRGeTMGj6f6sRTS6x+CPbNF8lNBRcqCQI=;
        b=Rq4sAGWoH9rB6PQsErrtHo8fcPupPWWUwYnhKc0X58rw6wi9QmTcmlLPgcp8hUUCkgWV25
        ioYeXzcOGOzL+47eGt4XpiXxcEFL1fBDi3yDb2+F7bsAt6m5sHpiSBN6WPmcE9rWDSL86P
        kZafM5Tm5RefeQu1+22XBstvn8JWy7Q=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-486-GdVVqn1oPyuxKxqbCeSW7A-1; Thu, 10 Mar 2022 08:10:01 -0500
X-MC-Unique: GdVVqn1oPyuxKxqbCeSW7A-1
Received: by mail-wm1-f71.google.com with SMTP id c62-20020a1c3541000000b003815245c642so4050491wma.6
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 05:10:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tLCt4+oXBNeRGeTMGj6f6sRTS6x+CPbNF8lNBRcqCQI=;
        b=7coPlVk6uSWMoTdILTua08KucaAIEXjvk0/9o4t7BPQoixRBefJc71J7RtGktfHg1i
         vgHun2O2x7bz0TUnL21r9Zc+58tekC48LLzrTINpF8en5e3c+/kug9o5t76Wg96Prq5Z
         bx34tK7GjNbcDzDiPu1bJJe3B0J1QkJKR9eefC8TJSV1/kgroIAlJQvhSr0LoWUuJb8B
         kXDonFGPIYadYDS0RouTu4X7lCAJhMaF27iq0Aq1z4UU9GELMy1eJ+pWIOddt2czcUYj
         ailVh+ZRx1FXExqu4DFiogUQSPvu/0jGFX0C2BVqT++roJW3vOpJxXDtoA1IYiol5jVg
         B8Gw==
X-Gm-Message-State: AOAM530zU1vx9WY0vG3+vLfRko3N9wZq/99C2vGy5zJAoO20BVCmNIY3
        kUm4Xygw6+/KEWIjhxkKxwU84hfXeEcm5OYdy0kKGvrLoDiJI7zYF6c/B8a5fdI9UaxDohd0WNz
        9NmHsBCKxueM5Zff/
X-Received: by 2002:a05:600c:4ed0:b0:389:d27f:edb6 with SMTP id g16-20020a05600c4ed000b00389d27fedb6mr3729418wmq.82.1646917800530;
        Thu, 10 Mar 2022 05:10:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxQyiWOUzYxcbWxFGGWxoefhXwy+3ImxBpIZ52iOn87ZQzXPJMSab0U6KITKkbgp8AheG7ZCg==
X-Received: by 2002:a05:600c:4ed0:b0:389:d27f:edb6 with SMTP id g16-20020a05600c4ed000b00389d27fedb6mr3729392wmq.82.1646917800143;
        Thu, 10 Mar 2022 05:10:00 -0800 (PST)
Received: from redhat.com ([2.53.27.107])
        by smtp.gmail.com with ESMTPSA id i5-20020a1c3b05000000b00382871cf734sm8012017wma.25.2022.03.10.05.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 05:09:59 -0800 (PST)
Date:   Thu, 10 Mar 2022 08:09:56 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jiyong Park <jiyong@google.com>
Cc:     sgarzare@redhat.com, stefanha@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, kuba@kernel.org, adelva@google.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vsock: refactor vsock_for_each_connected_socket
Message-ID: <20220310080748-mutt-send-email-mst@kernel.org>
References: <20220310125425.4193879-1-jiyong@google.com>
 <20220310125425.4193879-3-jiyong@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310125425.4193879-3-jiyong@google.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 09:54:25PM +0900, Jiyong Park wrote:
> vsock_for_each_connected_socket now cycles over sockets of a specific
> transport only, rather than asking callers to do the filtering manually,
> which is error-prone.
> 
> Signed-off-by: Jiyong Park <jiyong@google.com>

Pls just squash these two patches. Downstream will do its own thing,
probably distict from your patch 1 and depending on what its
requirements are.

> ---
>  drivers/vhost/vsock.c            |  7 ++-----
>  include/net/af_vsock.h           |  3 ++-
>  net/vmw_vsock/af_vsock.c         |  9 +++++++--
>  net/vmw_vsock/virtio_transport.c | 12 ++++--------
>  net/vmw_vsock/vmci_transport.c   |  8 ++------
>  5 files changed, 17 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 853ddac00d5b..e6c9d41db1de 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -722,10 +722,6 @@ static void vhost_vsock_reset_orphans(struct sock *sk)
>  	 * executing.
>  	 */
>  
> -	/* Only handle our own sockets */
> -	if (vsk->transport != &vhost_transport.transport)
> -		return;
> -
>  	/* If the peer is still valid, no need to reset connection */
>  	if (vhost_vsock_get(vsk->remote_addr.svm_cid))
>  		return;
> @@ -757,7 +753,8 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
>  
>  	/* Iterating over all connections for all CIDs to find orphans is
>  	 * inefficient.  Room for improvement here. */
> -	vsock_for_each_connected_socket(vhost_vsock_reset_orphans);
> +	vsock_for_each_connected_socket(&vhost_transport.transport,
> +					vhost_vsock_reset_orphans);
>  
>  	/* Don't check the owner, because we are in the release path, so we
>  	 * need to stop the vsock device in any case.
> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> index ab207677e0a8..f742e50207fb 100644
> --- a/include/net/af_vsock.h
> +++ b/include/net/af_vsock.h
> @@ -205,7 +205,8 @@ struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr);
>  struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
>  					 struct sockaddr_vm *dst);
>  void vsock_remove_sock(struct vsock_sock *vsk);
> -void vsock_for_each_connected_socket(void (*fn)(struct sock *sk));
> +void vsock_for_each_connected_socket(struct vsock_transport *transport,
> +				     void (*fn)(struct sock *sk));
>  int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk);
>  bool vsock_find_cid(unsigned int cid);
>  
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index 38baeb189d4e..f04abf662ec6 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -334,7 +334,8 @@ void vsock_remove_sock(struct vsock_sock *vsk)
>  }
>  EXPORT_SYMBOL_GPL(vsock_remove_sock);
>  
> -void vsock_for_each_connected_socket(void (*fn)(struct sock *sk))
> +void vsock_for_each_connected_socket(struct vsock_transport *transport,
> +				     void (*fn)(struct sock *sk))
>  {
>  	int i;
>  
> @@ -343,8 +344,12 @@ void vsock_for_each_connected_socket(void (*fn)(struct sock *sk))
>  	for (i = 0; i < ARRAY_SIZE(vsock_connected_table); i++) {
>  		struct vsock_sock *vsk;
>  		list_for_each_entry(vsk, &vsock_connected_table[i],
> -				    connected_table)
> +				    connected_table) {
> +			if (vsk->transport != transport)
> +				continue;
> +
>  			fn(sk_vsock(vsk));
> +		}
>  	}
>  
>  	spin_unlock_bh(&vsock_table_lock);
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index 61b24eb31d4b..5afc194a58bb 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -358,17 +358,11 @@ static void virtio_vsock_event_fill(struct virtio_vsock *vsock)
>  
>  static void virtio_vsock_reset_sock(struct sock *sk)
>  {
> -	struct vsock_sock *vsk = vsock_sk(sk);
> -
>  	/* vmci_transport.c doesn't take sk_lock here either.  At least we're
>  	 * under vsock_table_lock so the sock cannot disappear while we're
>  	 * executing.
>  	 */
>  
> -	/* Only handle our own sockets */
> -	if (vsk->transport != &virtio_transport.transport)
> -		return;
> -
>  	sk->sk_state = TCP_CLOSE;
>  	sk->sk_err = ECONNRESET;
>  	sk_error_report(sk);
> @@ -391,7 +385,8 @@ static void virtio_vsock_event_handle(struct virtio_vsock *vsock,
>  	switch (le32_to_cpu(event->id)) {
>  	case VIRTIO_VSOCK_EVENT_TRANSPORT_RESET:
>  		virtio_vsock_update_guest_cid(vsock);
> -		vsock_for_each_connected_socket(virtio_vsock_reset_sock);
> +		vsock_for_each_connected_socket(&virtio_transport.transport,
> +						virtio_vsock_reset_sock);
>  		break;
>  	}
>  }
> @@ -669,7 +664,8 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
>  	synchronize_rcu();
>  
>  	/* Reset all connected sockets when the device disappear */
> -	vsock_for_each_connected_socket(virtio_vsock_reset_sock);
> +	vsock_for_each_connected_socket(&virtio_transport.transport,
> +					virtio_vsock_reset_sock);
>  
>  	/* Stop all work handlers to make sure no one is accessing the device,
>  	 * so we can safely call virtio_reset_device().
> diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
> index cd2f01513fae..735d5e14608a 100644
> --- a/net/vmw_vsock/vmci_transport.c
> +++ b/net/vmw_vsock/vmci_transport.c
> @@ -803,11 +803,6 @@ static void vmci_transport_handle_detach(struct sock *sk)
>  	struct vsock_sock *vsk;
>  
>  	vsk = vsock_sk(sk);
> -
> -	/* Only handle our own sockets */
> -	if (vsk->transport != &vmci_transport)
> -		return;
> -
>  	if (!vmci_handle_is_invalid(vmci_trans(vsk)->qp_handle)) {
>  		sock_set_flag(sk, SOCK_DONE);
>  
> @@ -887,7 +882,8 @@ static void vmci_transport_qp_resumed_cb(u32 sub_id,
>  					 const struct vmci_event_data *e_data,
>  					 void *client_data)
>  {
> -	vsock_for_each_connected_socket(vmci_transport_handle_detach);
> +	vsock_for_each_connected_socket(&vmci_transport,
> +					vmci_transport_handle_detach);
>  }
>  
>  static void vmci_transport_recv_pkt_work(struct work_struct *work)
> -- 
> 2.35.1.723.g4982287a31-goog

