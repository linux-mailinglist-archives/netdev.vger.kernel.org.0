Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC036FF30F
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731965AbfKPQXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:23:02 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:46531 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728589AbfKPQXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 11:23:00 -0500
Received: by mail-il1-f193.google.com with SMTP id q1so11983559ile.13;
        Sat, 16 Nov 2019 08:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cGFJ1UHhdiIJEXOLGXqJSQjnNZL8uc3rgdnRctzpxO8=;
        b=QV7A147BcDqcwv+64KmJqy7g4WfpYsm+HaDVJzDbChVyz1FSbc+3XjWg7GsZXk9Gdg
         6j28bmx8Z76qAf/uv6xMSznCQsx63zkFJXYvjWxbSQPZDxKx19th/30FKKGp59H7m6KF
         GA4oo0XTZl3yweQT61wv4mtKdX+qJjiW3s3qCdb+W0fVpdKYdPAq4/ygzTYnmWQ0X7ZX
         XAOk0SLRwj969h5oL0ltAd3YeHrLhJ7q8jZA5yD6Ma9nTz+AOfONhWvcjT0mKobBnj3/
         UGnnxQmQuR/RFNnc+cpcUYm5EeH7WP0uLSIvAvOljRvyfi8Gky0KKuNI6hRZN7ArwrL5
         lv7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cGFJ1UHhdiIJEXOLGXqJSQjnNZL8uc3rgdnRctzpxO8=;
        b=gxXA5444UFFdSxrerPVEAm/iihhP44PBL/odwBWvJr65BCCNP1FjPtPpskPa7SDMmK
         G58xgTYwCqhweZyamri7M8qNpCdqX3j4yX2zAN6eRl0jhAvZiFMWflKUs6+HOLti/LU2
         odC4xT7QZV/kWeCLFnvgxQrMm4CuVsgmYwnIuayakESVMIhshekCqIuLFNwWmOw17Bmv
         p31dcRZce6+7xt9An462OBBaRz2tLhxae4U0Fr1NM4eT+xrIQRa0N6xa9cIJ2uUaTq4n
         TuLM2uIjr9nCfuO1bANN+llf22gJ9JLeBhdEp0MosVYucQPcJGC61e8pp2bwOidhYwDk
         pbCA==
X-Gm-Message-State: APjAAAXRxI3Yw57wMtCiSbBGDvBxHjk0c6PAVlkgmXCtSFpQyOLa3Zhe
        4Sh3mIwp66NHNRKxZywbwT/6GyVwcxQxhYErLlbZnRUX
X-Google-Smtp-Source: APXvYqx1R8rTJgYa6Kg9YWmHBdE/q+WJXVJOhIsP/ndz5fykjzfUIkaZTuN/os8z6qJWgW/RX5NOiLkI2+rIaNmQyC4=
X-Received: by 2002:a92:b656:: with SMTP id s83mr6767761ili.282.1573921379066;
 Sat, 16 Nov 2019 08:22:59 -0800 (PST)
MIME-Version: 1.0
References: <20191116154113.7417-1-sashal@kernel.org> <20191116154113.7417-100-sashal@kernel.org>
In-Reply-To: <20191116154113.7417-100-sashal@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Sat, 16 Nov 2019 17:23:28 +0100
Message-ID: <CAOi1vP8ZTyaGsn-hXtnr+AnCrEQfSB6sTLYwkkZ8P1oY9EgPXg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 100/237] libceph: don't consume a ref on
 pagelist in ceph_msg_data_add_pagelist()
To:     Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Ceph Development <ceph-devel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 16, 2019 at 4:43 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Ilya Dryomov <idryomov@gmail.com>
>
> [ Upstream commit 894868330a1e038ea4a65dbb81741eef70ad71b1 ]
>
> Because send_mds_reconnect() wants to send a message with a pagelist
> and pass the ownership to the messenger, ceph_msg_data_add_pagelist()
> consumes a ref which is then put in ceph_msg_data_destroy().  This
> makes managing pagelists in the OSD client (where they are wrapped in
> ceph_osd_data) unnecessarily hard because the handoff only happens in
> ceph_osdc_start_request() instead of when the pagelist is passed to
> ceph_osd_data_pagelist_init().  I counted several memory leaks on
> various error paths.
>
> Fix up ceph_msg_data_add_pagelist() and carry a pagelist ref in
> ceph_osd_data.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/ceph/mds_client.c  | 2 +-
>  net/ceph/messenger.c  | 1 +
>  net/ceph/osd_client.c | 8 ++++++++
>  3 files changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 09db6d08614d2..94494d05a94cb 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2184,7 +2184,6 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
>
>         if (req->r_pagelist) {
>                 struct ceph_pagelist *pagelist = req->r_pagelist;
> -               refcount_inc(&pagelist->refcnt);
>                 ceph_msg_data_add_pagelist(msg, pagelist);
>                 msg->hdr.data_len = cpu_to_le32(pagelist->length);
>         } else {
> @@ -3289,6 +3288,7 @@ static void send_mds_reconnect(struct ceph_mds_client *mdsc,
>         mutex_unlock(&mdsc->mutex);
>
>         up_read(&mdsc->snap_rwsem);
> +       ceph_pagelist_release(pagelist);
>         return;
>
>  fail:
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index f7d7f32ac673c..2c8cd339d59ea 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -3323,6 +3323,7 @@ void ceph_msg_data_add_pagelist(struct ceph_msg *msg,
>
>         data = ceph_msg_data_create(CEPH_MSG_DATA_PAGELIST);
>         BUG_ON(!data);
> +       refcount_inc(&pagelist->refcnt);
>         data->pagelist = pagelist;
>
>         list_add_tail(&data->links, &msg->data);
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 76c41a84550e7..c3494c1fb3a9a 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -126,6 +126,9 @@ static void ceph_osd_data_init(struct ceph_osd_data *osd_data)
>         osd_data->type = CEPH_OSD_DATA_TYPE_NONE;
>  }
>
> +/*
> + * Consumes @pages if @own_pages is true.
> + */
>  static void ceph_osd_data_pages_init(struct ceph_osd_data *osd_data,
>                         struct page **pages, u64 length, u32 alignment,
>                         bool pages_from_pool, bool own_pages)
> @@ -138,6 +141,9 @@ static void ceph_osd_data_pages_init(struct ceph_osd_data *osd_data,
>         osd_data->own_pages = own_pages;
>  }
>
> +/*
> + * Consumes a ref on @pagelist.
> + */
>  static void ceph_osd_data_pagelist_init(struct ceph_osd_data *osd_data,
>                         struct ceph_pagelist *pagelist)
>  {
> @@ -362,6 +368,8 @@ static void ceph_osd_data_release(struct ceph_osd_data *osd_data)
>                 num_pages = calc_pages_for((u64)osd_data->alignment,
>                                                 (u64)osd_data->length);
>                 ceph_release_page_vector(osd_data->pages, num_pages);
> +       } else if (osd_data->type == CEPH_OSD_DATA_TYPE_PAGELIST) {
> +               ceph_pagelist_release(osd_data->pagelist);
>         }
>         ceph_osd_data_init(osd_data);
>  }

Hi Sasha,

This commit was part of a larger series and shouldn't be backported on
its own.  Please drop it.

Thanks,

                Ilya
