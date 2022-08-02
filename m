Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C17BF5875D2
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 05:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbiHBDIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 23:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235717AbiHBDIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 23:08:35 -0400
Received: from smtp236.sjtu.edu.cn (smtp236.sjtu.edu.cn [202.120.2.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5E619030;
        Mon,  1 Aug 2022 20:08:34 -0700 (PDT)
Received: from mta90.sjtu.edu.cn (unknown [10.118.0.90])
        by smtp236.sjtu.edu.cn (Postfix) with ESMTPS id 2FD961008B38A;
        Tue,  2 Aug 2022 11:08:32 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mta90.sjtu.edu.cn (Postfix) with ESMTP id 19F4C37C894;
        Tue,  2 Aug 2022 11:08:32 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from mta90.sjtu.edu.cn ([127.0.0.1])
        by localhost (mta90.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id LaZN_f53Rf0S; Tue,  2 Aug 2022 11:08:32 +0800 (CST)
Received: from mstore105.sjtu.edu.cn (mstore101.sjtu.edu.cn [10.118.0.105])
        by mta90.sjtu.edu.cn (Postfix) with ESMTP id E00F837C893;
        Tue,  2 Aug 2022 11:08:31 +0800 (CST)
Date:   Tue, 2 Aug 2022 11:08:31 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     eperezma <eperezma@redhat.com>
Cc:     jasowang <jasowang@redhat.com>, sgarzare <sgarzare@redhat.com>,
        Michael Tsirkin <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Message-ID: <104238481.4321239.1659409711735.JavaMail.zimbra@sjtu.edu.cn>
In-Reply-To: <CAJaqyWfgUqdP6mkOUdouvQSst=qc7MOTaigC-EiTg9-gojHqzg@mail.gmail.com>
References: <20220721084341.24183-1-qtxuning1999@sjtu.edu.cn> <20220721084341.24183-4-qtxuning1999@sjtu.edu.cn> <CAJaqyWfgUqdP6mkOUdouvQSst=qc7MOTaigC-EiTg9-gojHqzg@mail.gmail.com>
Subject: Re: [RFC 3/5] vhost_test: batch used buffer
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Originating-IP: [58.45.124.125]
X-Mailer: Zimbra 8.8.15_GA_4308 (ZimbraWebClient - GC103 (Mac)/8.8.15_GA_3928)
Thread-Topic: vhost_test: batch used buffer
Thread-Index: EUV1DBWPmVSAUFFwArkDHJZP+/kacQ==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
From: "eperezma" <eperezma@redhat.com>
To: "Guo Zhi" <qtxuning1999@sjtu.edu.cn>
Cc: "jasowang" <jasowang@redhat.com>, "sgarzare" <sgarzare@redhat.com>, "Michael Tsirkin" <mst@redhat.com>, "netdev" <netdev@vger.kernel.org>, "linux-kernel" <linux-kernel@vger.kernel.org>, "kvm list" <kvm@vger.kernel.org>, "virtualization" <virtualization@lists.linux-foundation.org>
Sent: Friday, July 22, 2022 3:12:47 PM
Subject: Re: [RFC 3/5] vhost_test: batch used buffer

On Thu, Jul 21, 2022 at 10:44 AM Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
>
> Only add to used ring when a batch a buffer have all been used.  And if
> in order feature negotiated, add randomness to the used buffer's order,
> test the ability of vhost to reorder batched buffer.
>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>  drivers/vhost/test.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> index bc8e7fb1e..1c9c40c11 100644
> --- a/drivers/vhost/test.c
> +++ b/drivers/vhost/test.c
> @@ -43,6 +43,9 @@ struct vhost_test {
>  static void handle_vq(struct vhost_test *n)
>  {
>         struct vhost_virtqueue *vq = &n->vqs[VHOST_TEST_VQ];
> +       struct vring_used_elem *heads = kmalloc(sizeof(*heads)
> +                       * vq->num, GFP_KERNEL);
> +       int batch_idx = 0;
>         unsigned out, in;
>         int head;
>         size_t len, total_len = 0;
> @@ -84,11 +87,21 @@ static void handle_vq(struct vhost_test *n)
>                         vq_err(vq, "Unexpected 0 len for TX\n");
>                         break;
>                 }
> -               vhost_add_used_and_signal(&n->dev, vq, head, 0);
> +               heads[batch_idx].id = cpu_to_vhost32(vq, head);
> +               heads[batch_idx++].len = cpu_to_vhost32(vq, len);
>                 total_len += len;
>                 if (unlikely(vhost_exceeds_weight(vq, 0, total_len)))
>                         break;
>         }
> +       if (batch_idx) {
> +               if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER) && batch_idx >= 2) {

Maybe to add a module parameter to test this? Instead of trusting in
feature negotiation, "unorder_used=1" or something like that.

vhost.c:vhost_add_used_and_signal_n should support receiving buffers
in order or out of order whether F_IN_ORDER is negotiated or not.

Thanks!

Maybe to add a module parameter to test this? Instead of trusting in
feature negotiation, "unorder_used=1" or something like that.

vhost.c:vhost_add_used_and_signal_n should support receiving buffers
in order or out of order whether F_IN_ORDER is negotiated or not.

Thanks!

> +                       vhost_add_used_and_signal_n(&n->dev, vq, &heads[batch_idx / 2],
> +                                                   batch_idx - batch_idx / 2);
> +                       vhost_add_used_and_signal_n(&n->dev, vq, heads, batch_idx / 2);
> +               } else {
> +                       vhost_add_used_and_signal_n(&n->dev, vq, heads, batch_idx);
> +               }
> +       }
>
>         mutex_unlock(&vq->mutex);
>  }
> --
> 2.17.1
>
