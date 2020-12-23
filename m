Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B17B2E22B1
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 00:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbgLWX1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 18:27:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727147AbgLWX07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 18:26:59 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F28C061794
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 15:26:19 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id m23so696873ioy.2
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 15:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RDekLG10XPaNPOpSt8r9JBcLST8ouhm7/KnAYeWr4tM=;
        b=Bx0AUVV+Pv5o2D1TAccD8RahxZurHjujt2TDtG55Ip2Bet9v4wDSZRTdCouKgpYwP0
         2wFZsZeQyVLFxyxsyteoqTCOr73ajq2Oa4GTm67pSiBzv3PXR5g/ZZsV8f3adKlzCcDy
         LMdYjbMeeIIYRLFGECLotUi+Vjb3jtejK4D8tBdDmZ76wxEaSSJ8ZKOb2Rjn4fPRErso
         L/T0EZcjSNdBoq2OZXrG8w6QLd4TvdMNxwz3i+XFLkh5T+xXln7wN1LEg6SbxAYhix5p
         TB2871m3A0PAYd/cOxMYLrQ5/Ktxt6rt62jRw5Wo6amX1yZZGwdJEUWULAtplT8hpk9w
         MTXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RDekLG10XPaNPOpSt8r9JBcLST8ouhm7/KnAYeWr4tM=;
        b=Q8vIt02wWSMOLfTBSvWXBOL1khKikbKG1wzoun5gmynb2M/TXCmmeT3bFWFIWx3vUf
         BD2UdMCgiOCfM1yztG++2740hPH6haT39I306g5nimAKMkOmsbCdwQfqd/1XodQ0xPbI
         w7s4Oi9tsTP9zi1Lhb3IHvPDb9D4nXcphIdE1ajpP6G24+TVxRgm5EXvPyMPKTjKuMu3
         +9R860WFQrwvNfXdSoI+SNWXADGTZTWHzkIkO6gTwVPwP/w1gKwlccCySjMHDvU76lTE
         ysOrnWZzT9gu9jZuAbx9twdUV9AIQ/tHt/vVIh00Nu7cPCi0C8OnAtCjkYbPtDYKDA0K
         I31A==
X-Gm-Message-State: AOAM531qXYnJTeJOSdXzxYkgVELQlcJd8alL3iX9AjR1L+bt9DaximYm
        g5NQztS680KKMxOXp3J0UDqNAq+kAOYRwiaX2SaTdmd33xg=
X-Google-Smtp-Source: ABdhPJxJc2IM4++7b0iU0WCdoGxd8gRuf8VnqBvvUSR3yqkUDnqoaAH8KgjB1QRPM67xIaOAx3G/m4aYODuOF7Xq61U=
X-Received: by 2002:a5e:9812:: with SMTP id s18mr23679912ioj.138.1608765978712;
 Wed, 23 Dec 2020 15:26:18 -0800 (PST)
MIME-Version: 1.0
References: <20201223212323.3603139-1-atenart@kernel.org>
In-Reply-To: <20201223212323.3603139-1-atenart@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 23 Dec 2020 15:26:08 -0800
Message-ID: <CAKgT0Ufm74TZc8bq12e8gk4uwBe40t0wZO7LJ5Uh8gXMxFr=wQ@mail.gmail.com>
Subject: Re: [PATCH net v3 0/4] net-sysfs: fix race conditions in the xps code
To:     Antoine Tenart <atenart@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 1:23 PM Antoine Tenart <atenart@kernel.org> wrote:
>
> Hello all,
>
> This series fixes race conditions in the xps code, where out of bound
> accesses can occur when dev->num_tc is updated, triggering oops. The
> root cause is linked to locking issues. An explanation is given in each
> of the commit logs.
>
> We had a discussion on the v1 of this series about using the xps_map
> mutex instead of the rtnl lock. While that seemed a better compromise,
> v2 showed the added complexity wasn't best for fixes. So we decided to
> go back to v1 and use the rtnl lock.
>
> Because of this, the only differences between v1 and v3 are improvements
> in the commit messages.
>
> Thanks!
> Antoine
>
> Antoine Tenart (4):
>   net-sysfs: take the rtnl lock when storing xps_cpus
>   net-sysfs: take the rtnl lock when accessing xps_cpus_map and num_tc
>   net-sysfs: take the rtnl lock when storing xps_rxqs
>   net-sysfs: take the rtnl lock when accessing xps_rxqs_map and num_tc
>
>  net/core/net-sysfs.c | 65 ++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 53 insertions(+), 12 deletions(-)
>

The series looks fine to me. Not the prettiest in the case of showing
the maps, but I don't think much can be done about that since we have
to return an error type and release the rtnl_lock.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
