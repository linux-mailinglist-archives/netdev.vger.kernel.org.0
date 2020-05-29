Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48761E7FC7
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 16:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgE2OKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 10:10:44 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26593 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726975AbgE2OKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 10:10:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590761441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TErd239L9m87GMKq1OnfAdElyOZMwB2hfVFAiSe/inE=;
        b=MYB1hTtlWi2MUOt9skQLTS0gURR+b3Ap/+9y3iL4wpdvlb2rr5WupjOo/3GCT+6GFoYoP8
        bkmV+EVheqR1m5+Yhro01nH1YmQVNhn/HVUH/hUtntHrEmjha631K5gHd/INYepwl2GYxe
        BZOLRewg1R1OXnIC7ObzhLB4w1o1OwQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-xbUC7XRMO6W2FPuw0xTSNw-1; Fri, 29 May 2020 10:10:39 -0400
X-MC-Unique: xbUC7XRMO6W2FPuw0xTSNw-1
Received: by mail-wm1-f69.google.com with SMTP id k185so854109wme.8
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 07:10:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TErd239L9m87GMKq1OnfAdElyOZMwB2hfVFAiSe/inE=;
        b=LZaa4RYC19y2OPOeMSkr517FWliw6YuZV14tgQih+HSMJwDdzhHHbkQl4X7QdZKWMB
         WpFEWbsyXI9T6vmJmBHzT8Jg156W1zRRawfTrXkEl+TmKrMwbZ3E8EcpBsgusbKaTg1q
         0pVRVBA5SfHJtcutO5sREhWLF4KYec+cJjoWbKIp4zp4g06JtozPiQetlblJmGEP4nky
         H/zN84hlVSrzDmKst6dNhK5y7frEBYjrrTaKsoJGDLWB3qQ/XxF8bKA7JIECdjx2412T
         2usy6ybRllnJetywKoS5XxNql/Yd+/di22hddZvpxNF0D3r6wgXs5mLOLgjaWZB+j3OH
         cH9A==
X-Gm-Message-State: AOAM533ROl1w+X+dwtRVu86B727b+0JNt5S7DJZkVUhI3dwU0lOR7n7f
        e95NvfIGTkt/V5PJdan8F7tkrPZyx39XXwJU8oQ0VYSHqAFy/oC+rS4Wlw5lTLWZF8gZ/bOwThH
        thfsdrVh52bZ5ag2u
X-Received: by 2002:adf:9c84:: with SMTP id d4mr8354242wre.327.1590761437219;
        Fri, 29 May 2020 07:10:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyU77CJCETVAQ/MakEhpXlB82Ntk+mmoh9WlUWbgSUeZEVhUvd9NyaJdmipxrh62Yze6wV5Xg==
X-Received: by 2002:adf:9c84:: with SMTP id d4mr8354212wre.327.1590761436822;
        Fri, 29 May 2020 07:10:36 -0700 (PDT)
Received: from steredhat ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id u7sm10292389wrm.23.2020.05.29.07.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 07:10:36 -0700 (PDT)
Date:   Fri, 29 May 2020 16:10:33 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jia He <justin.he@arm.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaly Xin <Kaly.Xin@arm.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] virtio_vsock: Fix race condition in
 virtio_transport_recv_pkt
Message-ID: <20200529141033.iqtmu3giph6dekuj@steredhat>
References: <20200529133123.195610-1-justin.he@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529133123.195610-1-justin.he@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jia,
thanks for the patch! I have some comments.

On Fri, May 29, 2020 at 09:31:23PM +0800, Jia He wrote:
> When client tries to connect(SOCK_STREAM) the server in the guest with NONBLOCK
> mode, there will be a panic on a ThunderX2 (armv8a server):
> [  463.718844][ T5040] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
> [  463.718848][ T5040] Mem abort info:
> [  463.718849][ T5040]   ESR = 0x96000044
> [  463.718852][ T5040]   EC = 0x25: DABT (current EL), IL = 32 bits
> [  463.718853][ T5040]   SET = 0, FnV = 0
> [  463.718854][ T5040]   EA = 0, S1PTW = 0
> [  463.718855][ T5040] Data abort info:
> [  463.718856][ T5040]   ISV = 0, ISS = 0x00000044
> [  463.718857][ T5040]   CM = 0, WnR = 1
> [  463.718859][ T5040] user pgtable: 4k pages, 48-bit VAs, pgdp=0000008f6f6e9000
> [  463.718861][ T5040] [0000000000000000] pgd=0000000000000000
> [  463.718866][ T5040] Internal error: Oops: 96000044 [#1] SMP
> [...]
> [  463.718977][ T5040] CPU: 213 PID: 5040 Comm: vhost-5032 Tainted: G           O      5.7.0-rc7+ #139
> [  463.718980][ T5040] Hardware name: GIGABYTE R281-T91-00/MT91-FS1-00, BIOS F06 09/25/2018
> [  463.718982][ T5040] pstate: 60400009 (nZCv daif +PAN -UAO)
> [  463.718995][ T5040] pc : virtio_transport_recv_pkt+0x4c8/0xd40 [vmw_vsock_virtio_transport_common]
> [  463.718999][ T5040] lr : virtio_transport_recv_pkt+0x1fc/0xd40 [vmw_vsock_virtio_transport_common]
> [  463.719000][ T5040] sp : ffff80002dbe3c40
> [...]
> [  463.719025][ T5040] Call trace:
> [  463.719030][ T5040]  virtio_transport_recv_pkt+0x4c8/0xd40 [vmw_vsock_virtio_transport_common]
> [  463.719034][ T5040]  vhost_vsock_handle_tx_kick+0x360/0x408 [vhost_vsock]
> [  463.719041][ T5040]  vhost_worker+0x100/0x1a0 [vhost]
> [  463.719048][ T5040]  kthread+0x128/0x130
> [  463.719052][ T5040]  ret_from_fork+0x10/0x18
> 
> The race condition as follows:
> Task1                            Task2
> =====                            =====
> __sock_release                   virtio_transport_recv_pkt
>   __vsock_release                  vsock_find_bound_socket (found)
>     lock_sock_nested
>     vsock_remove_sock
>     sock_orphan
>       sk_set_socket(sk, NULL)
>     ...
>     release_sock
>                                 lock_sock
>                                    virtio_transport_recv_connecting
>                                      sk->sk_socket->state (panic)
> 
> This fixes it by checking vsk again whether it is in bound/connected table.
> 
> Signed-off-by: Jia He <justin.he@arm.com>
> Cc: stable@vger.kernel.org
> ---
>  net/vmw_vsock/virtio_transport_common.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 69efc891885f..0dbd6a45f0ed 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -1132,6 +1132,17 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
>  
>  	lock_sock(sk);
>  
> +	/* Check it again if vsk is removed by vsock_remove_sock */
> +	spin_lock_bh(&vsock_table_lock);
> +	if (!__vsock_in_bound_table(vsk) && !__vsock_in_connected_table(vsk)) {
> +		spin_unlock_bh(&vsock_table_lock);
> +		(void)virtio_transport_reset_no_sock(t, pkt);
> +		release_sock(sk);
> +		sock_put(sk);
> +		goto free_pkt;
> +	}
> +	spin_unlock_bh(&vsock_table_lock);
> +

As an a simpler alternative, can we check the sk_shutdown or the socket
state without check again both bound and connected tables?

This is a data path, so we should take it faster.

I mean something like this:

	if (sk->sk_shutdown == SHUTDOWN_MASK) {
		...
	}

or

	if (sock_flag(sk, SOCK_DEAD)) {
		...
	}

I prefer the first option, but I think also the second option should
work.

Thanks,
Stefano

>  	/* Update CID in case it has changed after a transport reset event */
>  	vsk->local_addr.svm_cid = dst.svm_cid;
>  
> -- 
> 2.17.1
> 

