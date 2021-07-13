Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48603C6FB4
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 13:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235922AbhGML2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 07:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235574AbhGML2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 07:28:35 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E549EC0613EF
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 04:25:45 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id o5so40852259ejy.7
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 04:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V8C4AR1JulD0IJ4qJZ289RJQRxJBo+SCCExitFLHqJk=;
        b=wtJXjCEWs9J3rL4DSbhsQAMH3vsFxI36IhkimPxEp2z4B5KWy98HTgCthwKoCh00MH
         +Cw8MMZs162i1bbwc0H61Fw5Ddld5ixxj9xUkmvXXZrUQ8YV5rCYkVT5n/hIFcFZvbG5
         UGUIKGFHSwYgIS/J+U3XRlILf+pCFDWnBeWFuxoS92ixmz4Ka5l+fJkUYsgiqEz8I8/Q
         1OBeJRTT2X4sFe8UvVyTYuBfz2DBXBRafijnzoDQZ9rYwg7QbMci3cjSlkUfbdcDpKUW
         mrzXomF0nVPSBmTfOX3T/h4LolCD841RkQpBBmtak+CUXtvU4hKRPg/aN6BgjFAqGdri
         H8xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V8C4AR1JulD0IJ4qJZ289RJQRxJBo+SCCExitFLHqJk=;
        b=hEHjNt+06Bo1erajTV/o3I71OP5HrgAvTfFjfPaMpgVAOM7R3WUjAQIOAXhi3YSw/w
         3Jxq02BTT2CiOaJHz/fyOImWk9mzRxxKjNTtH4ijCyV5Uj0ZFyibKRlYcFAiypNLrlGZ
         qVCEI3uT74Pedpx7zeRBfyYfieX6kxRtx7rtMVQIG58kwdW3BJDWvJ2ynnuSV11ZBq8i
         WqEc+Y8foNhjydtgLRltHh2655oQCUeovzpXcnmw0YIjpJRNozqZCKfNsE8tc7moXXuY
         gmVPxRRzVGfAaebTT0Gt/7D4GbHT+/zQa0CBFiFTZfwmFU0DrJiPahDuilXgfmuXmgCa
         Miow==
X-Gm-Message-State: AOAM533Uu47w82QekLhqiQ8ozLNAGeH9cc/uJ1BvTYoJzrtOxD5JIEMb
        O8MtNPBvkBUhRLEQdUsqn/unDzJj+5G05XmbZJHp
X-Google-Smtp-Source: ABdhPJwEjj4lrSamVi9duSpQV4fbH1XcdO8oLpStHQXALyLK5+815GxTksXcYRUer+qlnlDcQeYitChfiKeAXWFWuFI=
X-Received: by 2002:a17:906:d10c:: with SMTP id b12mr4908301ejz.395.1626175544482;
 Tue, 13 Jul 2021 04:25:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210713084656.232-1-xieyongji@bytedance.com> <20210713084656.232-8-xieyongji@bytedance.com>
 <20210713110211.GK1954@kadam>
In-Reply-To: <20210713110211.GK1954@kadam>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 13 Jul 2021 19:25:33 +0800
Message-ID: <CACycT3sJpAqQ1JkO2kekSf=wya1TJSK5hj+Z0zejVbCTU4eG0g@mail.gmail.com>
Subject: Re: [PATCH v9 07/17] virtio: Don't set FAILED status bit on device
 index allocation failure
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        joro@8bytes.org, Greg KH <gregkh@linuxfoundation.org>,
        He Zhe <zhe.he@windriver.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 7:02 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> On Tue, Jul 13, 2021 at 04:46:46PM +0800, Xie Yongji wrote:
> > We don't need to set FAILED status bit on device index allocation
> > failure since the device initialization hasn't been started yet.
>
> The commit message should say what the effect of this change is to the
> user.  Is this a bugfix?  Will it have any effect on runtime at all?
>

Thanks for the reminder. Will update the commit message.

> To me, hearing your thoughts on this is valuable even if you have to
> guess.  "I noticed this mistake during review and I don't think it will
> affect runtime."
>

Yes, that's what I thought.

Thanks,
Yongji
