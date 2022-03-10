Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C15F54D4757
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 13:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242139AbiCJMya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 07:54:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbiCJMy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 07:54:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7A8BF13EFAB
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 04:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646916807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=So8QGMYxxpfWPmmqVHh//vVEMI1rn7kHfqT22Jc73Ss=;
        b=Am9Y7TW4QHg1jCzMc4jJmsfG6TTb90FZ/MT+jV5mKiym07lBkx6LlbF6DO2BuDkuvMgjt5
        +3Y2NH33KyfEH7Hqoy3GfXRhDe+AWMm/C7zMEm+4PTYIfj1s7/zFvA3W2GLm+QW8XoOkE7
        Swy4MJNMq3+5Kvl2/IgzUOQ68egQ4+Y=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-206-fZNp-yzyPYu5OdBnoVWfWA-1; Thu, 10 Mar 2022 07:53:26 -0500
X-MC-Unique: fZNp-yzyPYu5OdBnoVWfWA-1
Received: by mail-wm1-f72.google.com with SMTP id x5-20020a1c7c05000000b00389bcc8df46so2277588wmc.0
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 04:53:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=So8QGMYxxpfWPmmqVHh//vVEMI1rn7kHfqT22Jc73Ss=;
        b=Jx8vzcpRxi8ry9vy9s5JlsNAsdl8o9mE6B2ZztPgEuHnF+85tHRZ2XVZGHbJqQQZD8
         d6aK572FUvo8yjRjfyyQLQ6iqdvdjqiqQ/fia2GNCXhhhwvwghnuSt78DHX15L84PAp/
         wEq8kdhxgweb12fbESy44LzFRjbvcKklD/3TYxWu6+U362UPkuZtDjZSTXUkBj+q33/L
         46bs2PPhKPt+xIT4m8kH3i9wdtzLUCsvRtqtRra/1vljaI32dHGFbe1bimv8jZ8n16jg
         TKO5bytsKy7EJK70ts24Qq0LywAOGosGTiDK19RRfTkaTaHktsaYx3x6h2upukE5tqTy
         7tsQ==
X-Gm-Message-State: AOAM533apw9IJn1TA1NRcOiv0hqbnvb/2alXGu9taV5igGr38XJob4hZ
        ExipXd2CzKWAg3mLGXQ5lvXK7eS12q3q+oW2kNLiSsgXA7vWK0XvM6RtOQp+BAR/e8KyP6mLm+7
        +fKWvkHcnYOQ59ER9
X-Received: by 2002:a5d:64e6:0:b0:203:731b:c2d0 with SMTP id g6-20020a5d64e6000000b00203731bc2d0mr3548361wri.607.1646916805254;
        Thu, 10 Mar 2022 04:53:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyVSQr2CaW1ajxiMtTys/vVlt+a+IEGxRB+maLH0EBTGCpgkrUpq+Z/gNxWdqTxDDthQkSJvw==
X-Received: by 2002:a5d:64e6:0:b0:203:731b:c2d0 with SMTP id g6-20020a5d64e6000000b00203731bc2d0mr3548340wri.607.1646916804999;
        Thu, 10 Mar 2022 04:53:24 -0800 (PST)
Received: from redhat.com ([2.53.27.107])
        by smtp.gmail.com with ESMTPSA id g5-20020a5d64e5000000b00203914f5313sm523262wri.114.2022.03.10.04.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 04:53:24 -0800 (PST)
Date:   Thu, 10 Mar 2022 07:53:20 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jiyong Park <jiyong@google.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, adelva@google.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vsock: each transport cycles only on its own sockets
Message-ID: <20220310075217-mutt-send-email-mst@kernel.org>
References: <20220310124936.4179591-1-jiyong@google.com>
 <20220310124936.4179591-2-jiyong@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310124936.4179591-2-jiyong@google.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This message had 
In-Reply-To: <20220310124936.4179591-1-jiyong@google.com>
in its header but 20220310124936.4179591-2-jiyong@google.com was
not sent to the list.
Please don't do that. Instead, please write and send a proper
cover letter. Thanks!


On Thu, Mar 10, 2022 at 09:49:35PM +0900, Jiyong Park wrote:
> When iterating over sockets using vsock_for_each_connected_socket, make
> sure that a transport filters out sockets that don't belong to the
> transport.
> 
> There actually was an issue caused by this; in a nested VM
> configuration, destroying the nested VM (which often involves the
> closing of /dev/vhost-vsock if there was h2g connections to the nested
> VM) kills not only the h2g connections, but also all existing g2h
> connections to the (outmost) host which are totally unrelated.
> 
> Tested: Executed the following steps on Cuttlefish (Android running on a
> VM) [1]: (1) Enter into an `adb shell` session - to have a g2h
> connection inside the VM, (2) open and then close /dev/vhost-vsock by
> `exec 3< /dev/vhost-vsock && exec 3<&-`, (3) observe that the adb
> session is not reset.
> 
> [1] https://android.googlesource.com/device/google/cuttlefish/
> 
> Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
> Signed-off-by: Jiyong Park <jiyong@google.com>
> ---
>  drivers/vhost/vsock.c            | 4 ++++
>  net/vmw_vsock/virtio_transport.c | 7 +++++++
>  net/vmw_vsock/vmci_transport.c   | 5 +++++
>  3 files changed, 16 insertions(+)
> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 37f0b4274113..853ddac00d5b 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -722,6 +722,10 @@ static void vhost_vsock_reset_orphans(struct sock *sk)
>  	 * executing.
>  	 */
>  
> +	/* Only handle our own sockets */
> +	if (vsk->transport != &vhost_transport.transport)
> +		return;
> +
>  	/* If the peer is still valid, no need to reset connection */
>  	if (vhost_vsock_get(vsk->remote_addr.svm_cid))
>  		return;
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index fb3302fff627..61b24eb31d4b 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -24,6 +24,7 @@
>  static struct workqueue_struct *virtio_vsock_workqueue;
>  static struct virtio_vsock __rcu *the_virtio_vsock;
>  static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
> +static struct virtio_transport virtio_transport; /* forward declaration */
>  
>  struct virtio_vsock {
>  	struct virtio_device *vdev;
> @@ -357,11 +358,17 @@ static void virtio_vsock_event_fill(struct virtio_vsock *vsock)
>  
>  static void virtio_vsock_reset_sock(struct sock *sk)
>  {
> +	struct vsock_sock *vsk = vsock_sk(sk);
> +
>  	/* vmci_transport.c doesn't take sk_lock here either.  At least we're
>  	 * under vsock_table_lock so the sock cannot disappear while we're
>  	 * executing.
>  	 */
>  
> +	/* Only handle our own sockets */
> +	if (vsk->transport != &virtio_transport.transport)
> +		return;
> +
>  	sk->sk_state = TCP_CLOSE;
>  	sk->sk_err = ECONNRESET;
>  	sk_error_report(sk);
> diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
> index 7aef34e32bdf..cd2f01513fae 100644
> --- a/net/vmw_vsock/vmci_transport.c
> +++ b/net/vmw_vsock/vmci_transport.c
> @@ -803,6 +803,11 @@ static void vmci_transport_handle_detach(struct sock *sk)
>  	struct vsock_sock *vsk;
>  
>  	vsk = vsock_sk(sk);
> +
> +	/* Only handle our own sockets */
> +	if (vsk->transport != &vmci_transport)
> +		return;
> +
>  	if (!vmci_handle_is_invalid(vmci_trans(vsk)->qp_handle)) {
>  		sock_set_flag(sk, SOCK_DONE);
>  
> -- 
> 2.35.1.723.g4982287a31-goog

