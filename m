Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37E711004B7
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 12:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbfKRLuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 06:50:32 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31991 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726985AbfKRLub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 06:50:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574077830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P4gdRaiq5NJXwEpEtK5L6jmsMQ23dZMrC6/urd2TGn4=;
        b=C66Kvma75pD60UI4ATU41xKv/hyqb5dnMlwNccZKVFgntw4nVPhHAV/KnmcKY9YPHAfxwn
        Bj6arPli0sKdV0dRSp6LNC/wKOwpAhxE59oCQK246JgMNnc0UWAePICU3NWsHrRpWSlUFu
        2UunJ9RnEpM+IJu77Mgog0UCyr7XGIU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-5lKvKYreO5mE4hWxajZgcQ-1; Mon, 18 Nov 2019 06:50:28 -0500
Received: by mail-wr1-f69.google.com with SMTP id y3so15151231wrm.12
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 03:50:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uwsSsleVAQSgmtTsdOA+w72Xmy5s18Cc0V6ZitNVUH8=;
        b=BcE4hgmprAxM6TfA+2nl7sJzvPkrVN3AXYWCwnsYoys6WTC+CWpcv38wIOuOOSZUnB
         mkTDtYDzXyTz8jFs/OfDBrxAvgr+qydzgb4pSeRp9Bygs+OBNMQjrYlNiV5o0dDasjJo
         yfqyOjUEtIr2t+wqsNhRvgcn3hTV9h1g0p/LAlTc+X3zO+hQSqDFMll85GPTX7baYxrL
         2sX8ffBnPD3eWL1FGe0CYgTVbpPKgad+dXH+fE2xUKzHwIo1LSAMaDnkvqBPwVVAO61r
         cy0lg4aXBWZrVUbACyA+V5uaSWJJ5go/egQlbgFcqJ9tICyKEcjLqC5X6/HcyhrlUQHD
         peqA==
X-Gm-Message-State: APjAAAUKMFdrzSKfqQk6pIN93BHL9BuDWSIpv7MesZNEwxF2r4LM6WyT
        xbCxPraZ8h5rMouv/wpuvUJnmR/UtEq3AAFawJG9fVrGENN7BqlX8msbhc8j78fPeQaLLyijJIX
        eF5evlaWdQyiXwHA8
X-Received: by 2002:a7b:c211:: with SMTP id x17mr27094708wmi.71.1574077827596;
        Mon, 18 Nov 2019 03:50:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqwT1ytJLFJcV1U/5tskHFw15cnFJ3HXvueU1Qa+VEy0QDuO/KsHYfLOkMUfMdSgfmWk9WAswg==
X-Received: by 2002:a7b:c211:: with SMTP id x17mr27094676wmi.71.1574077827292;
        Mon, 18 Nov 2019 03:50:27 -0800 (PST)
Received: from steredhat (a-nu5-32.tin.it. [212.216.181.31])
        by smtp.gmail.com with ESMTPSA id z14sm22287121wrl.60.2019.11.18.03.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 03:50:26 -0800 (PST)
Date:   Mon, 18 Nov 2019 12:50:24 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        kvm <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH net-next v5 4/5] vhost/vsock: split packets to send using
 multiple buffers
Message-ID: <CAGxU2F7wbR-4Y310LJfkJkYFLtaJssmFVR6d=OJd4skYvw6n-A@mail.gmail.com>
References: <20190730154334.237789-1-sgarzare@redhat.com>
 <20190730154334.237789-5-sgarzare@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20190730154334.237789-5-sgarzare@redhat.com>
X-MC-Unique: 5lKvKYreO5mE4hWxajZgcQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,
talking to Michael, we realized that this patch merged upstream (commit
6dbd3e66e7785a2f055bf84d98de9b8fd31ff3f5) solves an issue in the
device emulation in the vhost-vsock module, because the emulation
did not meet the specification, assuming that the buffer in the RX
virtqueue was always 4 KB, without checking the actual size.

We think it's better to apply this patch in -stable.

What do you think?

Thanks,
Stefano

On Tue, Jul 30, 2019 at 5:44 PM Stefano Garzarella <sgarzare@redhat.com> wr=
ote:
>
> If the packets to sent to the guest are bigger than the buffer
> available, we can split them, using multiple buffers and fixing
> the length in the packet header.
> This is safe since virtio-vsock supports only stream sockets.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/vhost/vsock.c                   | 66 ++++++++++++++++++-------
>  net/vmw_vsock/virtio_transport_common.c | 15 ++++--
>  2 files changed, 60 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 6c8390a2af52..9f57736fe15e 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -102,7 +102,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock=
,
>                 struct iov_iter iov_iter;
>                 unsigned out, in;
>                 size_t nbytes;
> -               size_t len;
> +               size_t iov_len, payload_len;
>                 int head;
>
>                 spin_lock_bh(&vsock->send_pkt_list_lock);
> @@ -147,8 +147,24 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsoc=
k,
>                         break;
>                 }
>
> -               len =3D iov_length(&vq->iov[out], in);
> -               iov_iter_init(&iov_iter, READ, &vq->iov[out], in, len);
> +               iov_len =3D iov_length(&vq->iov[out], in);
> +               if (iov_len < sizeof(pkt->hdr)) {
> +                       virtio_transport_free_pkt(pkt);
> +                       vq_err(vq, "Buffer len [%zu] too small\n", iov_le=
n);
> +                       break;
> +               }
> +
> +               iov_iter_init(&iov_iter, READ, &vq->iov[out], in, iov_len=
);
> +               payload_len =3D pkt->len - pkt->off;
> +
> +               /* If the packet is greater than the space available in t=
he
> +                * buffer, we split it using multiple buffers.
> +                */
> +               if (payload_len > iov_len - sizeof(pkt->hdr))
> +                       payload_len =3D iov_len - sizeof(pkt->hdr);
> +
> +               /* Set the correct length in the header */
> +               pkt->hdr.len =3D cpu_to_le32(payload_len);
>
>                 nbytes =3D copy_to_iter(&pkt->hdr, sizeof(pkt->hdr), &iov=
_iter);
>                 if (nbytes !=3D sizeof(pkt->hdr)) {
> @@ -157,33 +173,47 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vso=
ck,
>                         break;
>                 }
>
> -               nbytes =3D copy_to_iter(pkt->buf, pkt->len, &iov_iter);
> -               if (nbytes !=3D pkt->len) {
> +               nbytes =3D copy_to_iter(pkt->buf + pkt->off, payload_len,
> +                                     &iov_iter);
> +               if (nbytes !=3D payload_len) {
>                         virtio_transport_free_pkt(pkt);
>                         vq_err(vq, "Faulted on copying pkt buf\n");
>                         break;
>                 }
>
> -               vhost_add_used(vq, head, sizeof(pkt->hdr) + pkt->len);
> +               vhost_add_used(vq, head, sizeof(pkt->hdr) + payload_len);
>                 added =3D true;
>
> -               if (pkt->reply) {
> -                       int val;
> -
> -                       val =3D atomic_dec_return(&vsock->queued_replies)=
;
> -
> -                       /* Do we have resources to resume tx processing? =
*/
> -                       if (val + 1 =3D=3D tx_vq->num)
> -                               restart_tx =3D true;
> -               }
> -
>                 /* Deliver to monitoring devices all correctly transmitte=
d
>                  * packets.
>                  */
>                 virtio_transport_deliver_tap_pkt(pkt);
>
> -               total_len +=3D pkt->len;
> -               virtio_transport_free_pkt(pkt);
> +               pkt->off +=3D payload_len;
> +               total_len +=3D payload_len;
> +
> +               /* If we didn't send all the payload we can requeue the p=
acket
> +                * to send it with the next available buffer.
> +                */
> +               if (pkt->off < pkt->len) {
> +                       spin_lock_bh(&vsock->send_pkt_list_lock);
> +                       list_add(&pkt->list, &vsock->send_pkt_list);
> +                       spin_unlock_bh(&vsock->send_pkt_list_lock);
> +               } else {
> +                       if (pkt->reply) {
> +                               int val;
> +
> +                               val =3D atomic_dec_return(&vsock->queued_=
replies);
> +
> +                               /* Do we have resources to resume tx
> +                                * processing?
> +                                */
> +                               if (val + 1 =3D=3D tx_vq->num)
> +                                       restart_tx =3D true;
> +                       }
> +
> +                       virtio_transport_free_pkt(pkt);
> +               }
>         } while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
>         if (added)
>                 vhost_signal(&vsock->dev, vq);
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virt=
io_transport_common.c
> index 34a2b42313b7..56fab3f03d0e 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -97,8 +97,17 @@ static struct sk_buff *virtio_transport_build_skb(void=
 *opaque)
>         struct virtio_vsock_pkt *pkt =3D opaque;
>         struct af_vsockmon_hdr *hdr;
>         struct sk_buff *skb;
> +       size_t payload_len;
> +       void *payload_buf;
>
> -       skb =3D alloc_skb(sizeof(*hdr) + sizeof(pkt->hdr) + pkt->len,
> +       /* A packet could be split to fit the RX buffer, so we can retrie=
ve
> +        * the payload length from the header and the buffer pointer taki=
ng
> +        * care of the offset in the original packet.
> +        */
> +       payload_len =3D le32_to_cpu(pkt->hdr.len);
> +       payload_buf =3D pkt->buf + pkt->off;
> +
> +       skb =3D alloc_skb(sizeof(*hdr) + sizeof(pkt->hdr) + payload_len,
>                         GFP_ATOMIC);
>         if (!skb)
>                 return NULL;
> @@ -138,8 +147,8 @@ static struct sk_buff *virtio_transport_build_skb(voi=
d *opaque)
>
>         skb_put_data(skb, &pkt->hdr, sizeof(pkt->hdr));
>
> -       if (pkt->len) {
> -               skb_put_data(skb, pkt->buf, pkt->len);
> +       if (payload_len) {
> +               skb_put_data(skb, payload_buf, payload_len);
>         }
>
>         return skb;
> --
> 2.20.1
>

