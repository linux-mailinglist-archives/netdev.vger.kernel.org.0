Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAF32019DE
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 20:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436547AbgFSR5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 13:57:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34932 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404686AbgFSR4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 13:56:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592589402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WcqrPcvDJb0ExZL7Rd/avo/FZMjKRYWp5ZMPjnD5nIw=;
        b=Fdphpq2kCXX0NpeRFZlLy4pU4p8G4VSh4vGP0L7rqE8CdT8R9r6Bki5YD4iQbRwMqFnreO
        UGr/3u/7vvoEU5dSJhG+EH1yNOgEmHH3qpRxECqFyEWQTcm5fUA49qZ64UpmNXlSs3Qo+y
        QgS3uhgSVOUw88gjBWGWDWBfM3Jebq0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-j4yHKw3tPlitTDLG_L6lhA-1; Fri, 19 Jun 2020 13:56:41 -0400
X-MC-Unique: j4yHKw3tPlitTDLG_L6lhA-1
Received: by mail-qv1-f69.google.com with SMTP id q5so7369235qvp.23
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 10:56:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WcqrPcvDJb0ExZL7Rd/avo/FZMjKRYWp5ZMPjnD5nIw=;
        b=OxEU7n+JGEfcyyIuRIYpol1NFVqn5xpidIVF/JLfAi5fh47d4hqPhyEZWOQ+/907iv
         dMz/clcQMZWQXzBT7UgQywSMQEQdnho34L/NvQzYz7WSkvxtQ2GopU4vpElmsR2+b2T4
         cm3pgYGjmEVuw3F6/h2xkv174xqq9ZtarxKFceWZKdXdabQNSUCTTCEn9ntCTohUIOvH
         XtaBk7d7ZAT4wq8D9xq8INnfa5b0mxkwQDNb5WFswmvjcWOpw0Dtbmob/ZJqj5QcVuk3
         RDCLcxZ4lMLHyC4V56Eq2IdiRt3xBrt4XyPlv8qr2kspRk7ZgH5DyRjUCKofk+lJlUrR
         B0TQ==
X-Gm-Message-State: AOAM530BphhSQHM7sr1DRZS0s8pF2nSt5LT04h48w5Yug9Hm4YqYs2yw
        4Yo+5rRKwOhV9HEYQT0kuadPTiZMO0giUy3BpkKnrlewaSrpOmP5TdsIAjtNk1+M2PIqx5YDNsv
        XRgm4HTBW4cQeJ0eS85M2s1Ube7jIdgfO
X-Received: by 2002:a37:64c6:: with SMTP id y189mr4793913qkb.353.1592589400890;
        Fri, 19 Jun 2020 10:56:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxts4JUG/DUZlXwHieuKsAsn4bVIZKK4d+Lvr6aZFXHNaYrdVkmy8Kqr7GNRfSCb53+bLew1eRqhZdN3cQW/5s=
X-Received: by 2002:a37:64c6:: with SMTP id y189mr4793881qkb.353.1592589400629;
 Fri, 19 Jun 2020 10:56:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200611113404.17810-1-mst@redhat.com> <20200611113404.17810-3-mst@redhat.com>
 <0332b0cf-cf00-9216-042c-e870efa33626@redhat.com>
In-Reply-To: <0332b0cf-cf00-9216-042c-e870efa33626@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 19 Jun 2020 19:56:04 +0200
Message-ID: <CAJaqyWcDb5GefbiBkcaMADFzWup7yvmvOekRmRQ40pqxdgB0eg@mail.gmail.com>
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 5:19 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/6/11 =E4=B8=8B=E5=8D=887:34, Michael S. Tsirkin wrote:
> >   static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
> >   {
> >       kfree(vq->descs);
> > @@ -394,6 +400,9 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev=
 *dev)
> >       for (i =3D 0; i < dev->nvqs; ++i) {
> >               vq =3D dev->vqs[i];
> >               vq->max_descs =3D dev->iov_limit;
> > +             if (vhost_vq_num_batch_descs(vq) < 0) {
> > +                     return -EINVAL;
> > +             }
>
>
> This check breaks vdpa which set iov_limit to zero. Consider iov_limit
> is meaningless to vDPA, I wonder we can skip the test when device
> doesn't use worker.

I tested as

if (dev->use_worker && vhost_vq_num_batch_descs(vq) < 0)

In v9. Please let me know if that is ok for you.

Thanks!

>
> Thanks
>

