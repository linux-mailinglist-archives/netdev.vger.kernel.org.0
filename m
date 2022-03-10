Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44904D44E1
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 11:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241363AbiCJKne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 05:43:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239955AbiCJKnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 05:43:32 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812D19D4F1
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 02:42:31 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-2dc28791ecbso52866367b3.4
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 02:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PjvVFIKZnpSRC+f09phnGX4Uu5Wyj+AZlMtNPwY4epI=;
        b=N2WsR4ppwa1hiSYpMnQi16CZJFt0xsiOm/GSJGOrjM/kDllAE5FbmrSUzSAPq3085X
         H4N9BU3YlYt74jkDWlHY/hTW7RQKmYd7QyZViNS7vwVuOuys/XZu773r8mFJDW3Fjg1P
         wYXZ1h0iQdak6Lzr/jOpJe1sUd6ncN2JSrZEFKYj8i7jaR+3DFKlmLtIiDQgb5Ci5CjT
         mfddlFomZJOiROWg89ER9sEVMOQLBkuFYlV/1+fpKRwLlzxea9LVM5DialZcX2FS72zk
         E9oZTmf1+JwYLRUbi4RYOuJBspe1qh66RVqCOERCQwpt0dPWO3sgRYq6fNzAB4Kx39rn
         L1GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PjvVFIKZnpSRC+f09phnGX4Uu5Wyj+AZlMtNPwY4epI=;
        b=X/P2XqOCaYogXBtvSsAuGU5BslNwV/qTCb3uA09fz3e+bJq8Wmp99VI164lX4Zca8v
         Dfk0JlofYBbSALgs8eZZDl0akvJEKw1ZSuGH9Oq7FLSr0e7yQSfXPrd8c77dCram/MsL
         S90qRDBERyJ668s5UnbU20ydwMpKEtELvcICrrCLiUn+ffO4YaEOOabQC+bh47H0EZDI
         /6Z8QH9vv/GIUIvIFgaDtJkKR601Q4ePGSh0oBHKQtW/rEChR4MdheerQudYbxLmYW/M
         V5oJAgM8vgv/L3+d72LxwSzPH11nvbMbVaBcSX7Hv4GMTik1FLm5gNa34SzedGUgsDLf
         tYtw==
X-Gm-Message-State: AOAM531WgO/eCBmFQcgfg4UJisxZ9yAdYKp6gFoUWJiKIkIhhJpPEk2X
        +wHWy2e51vNrPbDnn2f89+/Wc4oQeUSNNgERtd9MjQ==
X-Google-Smtp-Source: ABdhPJxsqY3tbTUqohNm2XSgz8up04CIOjs4jevepGkNfFHKU6IKs0Os1NqJ9ZAfQ69oRydLyjunFjUm0eFl3YDC5Dk=
X-Received: by 2002:a81:e85:0:b0:2dc:50d1:145 with SMTP id 127-20020a810e85000000b002dc50d10145mr3361489ywo.314.1646908950510;
 Thu, 10 Mar 2022 02:42:30 -0800 (PST)
MIME-Version: 1.0
References: <20220310081854.2487280-1-jiyong@google.com> <20220310085931.cpgc2cv4yg7sd4vu@sgarzare-redhat>
In-Reply-To: <20220310085931.cpgc2cv4yg7sd4vu@sgarzare-redhat>
From:   Jiyong Park <jiyong@google.com>
Date:   Thu, 10 Mar 2022 19:41:54 +0900
Message-ID: <CALeUXe6heGD9J+5fkLs9TJ7Mn0UT=BSdGNK_wZ4gkor_Ax_SqA@mail.gmail.com>
Subject: Re: [PATCH] vhost/vsock: reset only the h2g connections upon release
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, adelva@google.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefano,

On Thu, Mar 10, 2022 at 5:59 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> Hi Jiyong,
>
> On Thu, Mar 10, 2022 at 05:18:54PM +0900, Jiyong Park wrote:
> >Filtering non-h2g connections out when determining orphaned connections.
> >Otherwise, in a nested VM configuration, destroying the nested VM (which
> >often involves the closing of /dev/vhost-vsock if there was h2g
> >connections to the nested VM) kills not only the h2g connections, but
> >also all existing g2h connections to the (outmost) host which are
> >totally unrelated.
> >
> >Tested: Executed the following steps on Cuttlefish (Android running on a
> >VM) [1]: (1) Enter into an `adb shell` session - to have a g2h
> >connection inside the VM, (2) open and then close /dev/vhost-vsock by
> >`exec 3< /dev/vhost-vsock && exec 3<&-`, (3) observe that the adb
> >session is not reset.
> >
> >[1] https://android.googlesource.com/device/google/cuttlefish/
> >
> >Signed-off-by: Jiyong Park <jiyong@google.com>
> >---
> > drivers/vhost/vsock.c | 4 ++++
> > 1 file changed, 4 insertions(+)
> >
> >diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> >index 37f0b4274113..2f6d5d66f5ed 100644
> >--- a/drivers/vhost/vsock.c
> >+++ b/drivers/vhost/vsock.c
> >@@ -722,6 +722,10 @@ static void vhost_vsock_reset_orphans(struct sock *sk)
> >        * executing.
> >        */
> >
> >+      /* Only the h2g connections are reset */
> >+      if (vsk->transport != &vhost_transport.transport)
> >+              return;
> >+
> >       /* If the peer is still valid, no need to reset connection */
> >       if (vhost_vsock_get(vsk->remote_addr.svm_cid))
> >               return;
> >--
> >2.35.1.723.g4982287a31-goog
> >
>
> Thanks for your patch!
>
> Yes, I see the problem and I think I introduced it with the
> multi-transports support (ooops).
>
> So we should add this fixes tag:
>
> Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
>
>
> IIUC the problem is for all transports that should only cycle on their
> own sockets. Indeed I think there is the same problem if the g2h driver
> will be unloaded (or a reset event is received after a VM migration), it
> will close all sockets of the nested h2g.
>
> So I suggest a more generic solution, modifying
> vsock_for_each_connected_socket() like this (not tested):
>
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index 38baeb189d4e..f04abf662ec6 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -334,7 +334,8 @@ void vsock_remove_sock(struct vsock_sock *vsk)
>   }
>   EXPORT_SYMBOL_GPL(vsock_remove_sock);
>
> -void vsock_for_each_connected_socket(void (*fn)(struct sock *sk))
> +void vsock_for_each_connected_socket(struct vsock_transport *transport,
> +                                    void (*fn)(struct sock *sk))
>   {
>          int i;
>
> @@ -343,8 +344,12 @@ void vsock_for_each_connected_socket(void (*fn)(struct sock *sk))
>          for (i = 0; i < ARRAY_SIZE(vsock_connected_table); i++) {
>                  struct vsock_sock *vsk;
>                  list_for_each_entry(vsk, &vsock_connected_table[i],
> -                                   connected_table)
> +                                   connected_table) {
> +                       if (vsk->transport != transport)
> +                               continue;
> +
>                          fn(sk_vsock(vsk));
> +               }
>          }
>
>
> And all transports that call it.
>
> Thanks,
> Stefano
>

Thanks for the suggestion, which looks much better. It actually worked well.

By the way, the suggested change will alter the kernel-module interface (KMI),
which will make it difficult to land the change on older releases where we'd
like to keep the KMI stable [1]. Would it be OK if we let the supplied function
(fn) be responsible for checking the transport? I think that there, in
the future,
might be a case where one needs to cycle over all sockets for inspection or so.
I admit that this would be prone to error, though.

Please let me know what you think. I don't have a strong preference. I will
submit a revision as you want.

[1] https://source.android.com/devices/architecture/kernel/generic-kernel-image#kmi-stability
