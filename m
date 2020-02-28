Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09046173533
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 11:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgB1KXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 05:23:33 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:40331 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbgB1KXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 05:23:32 -0500
Received: by mail-io1-f66.google.com with SMTP id x1so2842829iop.7;
        Fri, 28 Feb 2020 02:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IHJZiLPZ3d84yInYn+06VlShgDYFte97xEhqlxTF18E=;
        b=fdr2DIkB8LHJz9/EjmLx9Q7PWWivAJOWiGOjqHdyhtpkd67QTw1bG8Y8JsDvd9O0kT
         3COh6VCFUO9h6ir3Rb1V5a4ZH9VbnV4HpTfZPV1i6ZTZn9EWNpE4Hp4TOz9JGwB7kuZj
         MnuD+wywq3Q58rCRkg+Ty5og4chuYSvR9lww9m7gbq8ztkGlC1RHozLDAH3ev7PKofwf
         zFLPbG/alRlb1087Dn86bo4NpHY31zlxMLx+Dh9M33yl8+zRapIP+mRKUe8FvOq3V+YO
         PTAbUPTFpxP+QjoFCicgfA2BGRaQR4VytaNJJc6KnCOjvQKQ7MUMslH/Vn0xpMQdAvZN
         IpIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IHJZiLPZ3d84yInYn+06VlShgDYFte97xEhqlxTF18E=;
        b=dv6k+tbvCb4gz0+ZJ7Ly1ip6rMZTMIZ4Yw0fVFJF+iEQNgNBGrzjytnv6+h6Gzzwnd
         VzpYSAyAHv6Kg4We5rR3Si9/0FVcw3pbh8mXP02yqI2l5lZlhxDIfVn/CAsVMPrf0PhN
         1E1OZYuM6XAmFAzQvS15hvE25neht4cko0y9K3l9IU0VXV1uUG5BOMO8uNeTW+uynRCn
         sPrSgj6RvjRXxkXVGEG9fZt751nerbbefh+U91f0pqxOFanzOUH4toI2nhuaf0IiFlr8
         C2Mq19O+Bz1NlkgUuZ0XFXq6AQeM/Tk4cVya4O3CpcxwIvo3r4RtQqzIZ2nzVJ9huwoP
         h1RA==
X-Gm-Message-State: APjAAAVuhOIc3k+F+pImqb3K0lxH1bgo1pLczLgLdeZMlvvkgPjg5HWA
        D2OapSsH1iCIwZ1uq0dHAzfT9P0UIR/4EJAYN9A=
X-Google-Smtp-Source: APXvYqxMrFonMOeeWgF3H4kyIbFxNkNfxuh6QUZc4eEnjbUcCaH4zISiGpEczOH1OFW7Fp0285tV6vjUB4n6kx37qhQ=
X-Received: by 2002:a6b:9188:: with SMTP id t130mr2801012iod.215.1582885411923;
 Fri, 28 Feb 2020 02:23:31 -0800 (PST)
MIME-Version: 1.0
References: <20200228044518.20314-1-gmayyyha@gmail.com>
In-Reply-To: <20200228044518.20314-1-gmayyyha@gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 28 Feb 2020 11:23:25 +0100
Message-ID: <CAOi1vP-K+e0N26qpthLcst8HLE-FAMGSE9XwBhj1dPBiLyN-iA@mail.gmail.com>
Subject: Re: [PATCH] ceph: using POOL FULL flag instead of OSDMAP FULL flag
To:     Yanhu Cao <gmayyyha@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 5:45 AM Yanhu Cao <gmayyyha@gmail.com> wrote:
>
> OSDMAP_FULL and OSDMAP_NEARFULL are deprecated since mimic.
>
> Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> ---
>  fs/ceph/file.c                  |  6 ++++--
>  include/linux/ceph/osd_client.h |  2 ++
>  include/linux/ceph/osdmap.h     |  3 ++-
>  net/ceph/osd_client.c           | 23 +++++++++++++----------
>  4 files changed, 21 insertions(+), 13 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 7e0190b1f821..60ea1eed1b84 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1482,7 +1482,8 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
>         }
>
>         /* FIXME: not complete since it doesn't account for being at quota */
> -       if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_FULL)) {
> +       if (pool_flag(&fsc->client->osdc, ci->i_layout.pool_id,
> +                               CEPH_POOL_FLAG_FULL)) {
>                 err = -ENOSPC;
>                 goto out;
>         }
> @@ -1575,7 +1576,8 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
>         }
>
>         if (written >= 0) {
> -               if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_NEARFULL))
> +               if (pool_flag(&fsc->client->osdc, ci->i_layout.pool_id,
> +                                       CEPH_POOL_FLAG_NEARFULL))

Hi Yanhu,

Have you considered pre-mimic clusters here?  They are still supported
(and will continue to be supported for the foreseeable future).

Thanks,

                Ilya
