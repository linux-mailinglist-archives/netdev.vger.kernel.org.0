Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38CA411B6CB
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 17:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388783AbfLKQDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 11:03:16 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44251 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388777AbfLKQDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 11:03:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576080194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6gfZXNRDfcJ0EDIOFFIp2NIhgwIPnf16ocIK/xP3HK0=;
        b=a2z+nRqkyNePq+R9e3R+wfhJsWoBFRn2uXDHxVTrmyHcTtuOcY/hoMUG57fnn6Ld1KDZpb
        Vyik2anr01X/Sp/HGb4D+12lrIKGScE7KlN0tQOihnEs60JOhwJckF1tGx1NOxZF9+dHMY
        w7W+87jqp6AJHv8FEFLzcR8nVt09z00=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-rq718VDdPLyesbBonSjsUA-1; Wed, 11 Dec 2019 11:03:13 -0500
X-MC-Unique: rq718VDdPLyesbBonSjsUA-1
Received: by mail-qk1-f198.google.com with SMTP id l4so3054627qkb.22
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 08:03:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6gfZXNRDfcJ0EDIOFFIp2NIhgwIPnf16ocIK/xP3HK0=;
        b=mo7XIF5vxJtx71S3xqG6xqfZthvu0ed6Is5sSBv6z4QTMiJ9RPdZ7hbrq7UIybOiaR
         IVERW2+wVHsHN+eKtSXSMxaGCe2ainxWjpHdbda8OPTa+MX4tJtXsdgretghpbzg/Lfi
         mDS+YcskdUMnpjZFaBQLl70boKl3M9YdHPYO3GL9e2vXM81pMje9+ms+Fx55VV6kgmXU
         8DQhfMgf0VqUi7z/V+/tVuYgWliBzFyR1WhzfPfgj0CUGdSEEypO9QC6Id+Miz5bMaw3
         Evn8xHC/AgaCgLtbkv7iVxDiFDcrFFAHmGUyfDW2+yYdYt9NxjTb/JzTeW5q3mnJ1iCk
         qM9A==
X-Gm-Message-State: APjAAAVPxG96Q5Ep2vgjNPVYtauxvl9J116H23n+PY0mIbHZiS/n7ga0
        EC78+z7XPXGSIT6khgbcIuDWroDm6XhgLiy34F5nElD+KwaS1Rxgxk3et35viIwa4jCa0I99UNX
        +cNV0jFIU++Plii71
X-Received: by 2002:a05:620a:2010:: with SMTP id c16mr3515481qka.386.1576080192423;
        Wed, 11 Dec 2019 08:03:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqwQQ2Bwv6/Qhu4cPFoF7Ygb0/S4EIjerRyxmrHRlOtQFWaSfcUrQlX7U0QxQDZ6VV+soS6Sdg==
X-Received: by 2002:a05:620a:2010:: with SMTP id c16mr3515454qka.386.1576080192203;
        Wed, 11 Dec 2019 08:03:12 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id q14sm1027460qtp.48.2019.12.11.08.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 08:03:11 -0800 (PST)
Date:   Wed, 11 Dec 2019 11:03:07 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vhost/vsock: accept only packets with the right dst_cid
Message-ID: <20191211110235-mutt-send-email-mst@kernel.org>
References: <20191206143912.153583-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191206143912.153583-1-sgarzare@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 06, 2019 at 03:39:12PM +0100, Stefano Garzarella wrote:
> When we receive a new packet from the guest, we check if the
> src_cid is correct, but we forgot to check the dst_cid.
> 
> The host should accept only packets where dst_cid is
> equal to the host CID.
> 
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Stefano can you clarify the impact pls?
E.g. is this needed on stable? Etc.

Thanks!

> ---
>  drivers/vhost/vsock.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 50de0642dea6..c2d7d57e98cf 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -480,7 +480,9 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
>  		virtio_transport_deliver_tap_pkt(pkt);
>  
>  		/* Only accept correctly addressed packets */
> -		if (le64_to_cpu(pkt->hdr.src_cid) == vsock->guest_cid)
> +		if (le64_to_cpu(pkt->hdr.src_cid) == vsock->guest_cid &&
> +		    le64_to_cpu(pkt->hdr.dst_cid) ==
> +		    vhost_transport_get_local_cid())
>  			virtio_transport_recv_pkt(&vhost_transport, pkt);
>  		else
>  			virtio_transport_free_pkt(pkt);
> -- 
> 2.23.0

