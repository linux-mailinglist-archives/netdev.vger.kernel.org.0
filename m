Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2883747D9
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 20:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234346AbhEESHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 14:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbhEESHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 14:07:40 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8032FC061574
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 11:06:43 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id y7so4239008ejj.9
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 11:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6epz3P+nTKg7PGMJTEsKPXBtOf+Ja81Rjg0mXQ3TlRc=;
        b=clqFxRqZjIIweBhdHhX3Wcftn/TGbaVdBLItUnVanmqKcg93+jVS4Lr2CRCMMIODsa
         HbatwDaZquVOIuCu64bQX3AaOluFydimbQQ9OrFwUrOx5kvPYyTtjPoENjadgJRmhB30
         QmoS83GfoPDAYMhxB5JxYuUO9fIgessBRcZctUBU/66Jrsr456HGgYxpLm3rOK84Wa2n
         1oVjt1fEw5OoLfCuQNTmeGL2ZILevqedw7lqdmadQFszVK5oXOtOrpI0vlHcaN3soLwP
         gk/ZdEYbvbzOVwK8DQt/ZLANZd8PFAdicXtTpwoM5jLU7DTKvLYFY1yqlQyUkcS0FqOq
         Y3pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6epz3P+nTKg7PGMJTEsKPXBtOf+Ja81Rjg0mXQ3TlRc=;
        b=CoU/PcSnL7Zr2a5/f3WXtPVxi+ylAMy76Uh4JX9IDdiV+ulo2a92YDVOYBJcrTWqK1
         So2GSUJ4Y0BK0tnAoG2Vnrw/OLvQtF53lCvjOlKfuUZlhJiasO7C6PPoryGh+ms7EURi
         yuQDrriGCh4qZxVg6GuILfTsFhL8iwvrLNaCCnFoAEH334MvqyjbX+XeZkQjW2oTM+u6
         PRftr5wwginkTJMqJvQu1VdCsH0X2uI8GWSggXjIdiHS0AZbFt/HjTyWExrOZns9V+NM
         HMObA5wLeHvP1DbhMj4cgKdTJrg1wRWaSQsE+Ik0D+tiuwJv9XXbClSJTOLS5fUCPMBS
         Qsqw==
X-Gm-Message-State: AOAM530vIZ9tBBqkUjGQmrCgCr0zeRVCHL2138gaBYxobOF854HwCDKU
        SobkTIZcbSc6t6U9znL4dw4UrOV5DBYbFkJVgRQ=
X-Google-Smtp-Source: ABdhPJw1Q+wj6QwfSlxgePQPlcdmcsKrVxtscN2eKBkdYxrGireWc9VLf5giOR/w8rUblUrltu9KpAjOCPMptVNSMAY=
X-Received: by 2002:a17:906:600b:: with SMTP id o11mr28742823ejj.345.1620238002262;
 Wed, 05 May 2021 11:06:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210429190926.5086-1-smalin@marvell.com> <20210429190926.5086-27-smalin@marvell.com>
 <daa07a1c-add4-9f27-5f55-05b1191e85c1@suse.de>
In-Reply-To: <daa07a1c-add4-9f27-5f55-05b1191e85c1@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Wed, 5 May 2021 21:06:31 +0300
Message-ID: <CAKKgK4yrkON+Nmfj7DNgiTzkujrsnxtbxqQ_oZhcs9jeR_bEaA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 26/27] qedn: Add Connection and IO level recovery flows
To:     Hannes Reinecke <hare@suse.de>
Cc:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/21 2:57PM, Hannes Reinecke wrote:
> On 4/29/21 9:09 PM, Shai Malin wrote:
> > This patch will present the connection level functionalities:
> >   - conn clear-sq: will release the FW restrictions in order to flush a=
ll
> >     the pending IOs.
> >   - drain: in case clear-sq is stuck, will release all the device FW
> >     restrictions in order to flush all the pending IOs.
> >   - task cleanup - will flush the IO level resources.
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > ---
> >   drivers/nvme/hw/qedn/qedn.h      |   8 ++
> >   drivers/nvme/hw/qedn/qedn_conn.c | 133 ++++++++++++++++++++++++++++++=
-
> >   drivers/nvme/hw/qedn/qedn_main.c |   1 +
> >   drivers/nvme/hw/qedn/qedn_task.c |  27 ++++++-
> >   4 files changed, 166 insertions(+), 3 deletions(-)
> >
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Thanks.

>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Kernel Storage Architect
> hare@suse.de                              +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=
=B6rffer
