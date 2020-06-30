Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E72820EA5F
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbgF3Aiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727875AbgF3Aip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 20:38:45 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3120EC061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:38:45 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id 80so17093816qko.7
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AePFt2e2HNsSL/8RHPgyc3hZ7Eo54IyCEtaWh2VYsYc=;
        b=gcWmZPtU+JSpAZGqAghU9at1zU0t59RdYfyTYEV3Go/KtcN1GL5aXNaEGJ5EZc2vhB
         WaATY7qsJ2NBuGm3laWEEZtGJGv4F2l2vd4dJnexuHEJ0T+3yD1HZP9U4bHrgPDzp9DJ
         whrfspYCy9xeg/+mUom4c8PVohvDN5+et9g9w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AePFt2e2HNsSL/8RHPgyc3hZ7Eo54IyCEtaWh2VYsYc=;
        b=oixtAuGD9+eTmQN4CFSv2L00pQfav6LOXOGtq/Yp/dHoZuEIg1WAp1eSHHnnpHauMX
         ToICbVjFhdo5pbUdHAbviYQNaMpgx8KDVVNylIAgRlgaxfM6wjRItC4JudqrJ3wA95pM
         mYCylfS/jzpOPxnYCXK5lTUlwHwVnng6+YCkrPnNpqrOEtbBsHyMUfXNyI8ENQfbXpbT
         p9Yd315FG4TboQaCfqm+59udQIprZ7q/rOok6sasf6lwsHJ5HHK6nYWUn8yLnDzS6krc
         z/Fmc1SjYbkySFAxHXbkXCmw9FOp8yfLDrviMY8oG9OyGaxOgXAHiXF7beCsfzsduYSV
         qz+w==
X-Gm-Message-State: AOAM533CL5UGTcYIwl1y3jHZYebcp/5vq/qe0cB43WLX+SApqFYzXD9g
        BTlOFczoC7hP5KFJ74k2GYB8xUHSGT05XiSgsOazUgGR
X-Google-Smtp-Source: ABdhPJyK8q/VCTs50T4jYoPj8L2n5J5a9kQlBKtVaNXOE4Tl3GfQxBKulNjR2u/pFXwA//nryvJCzGco/iwLeMykROM=
X-Received: by 2002:ae9:ef83:: with SMTP id d125mr17543945qkg.287.1593477524277;
 Mon, 29 Jun 2020 17:38:44 -0700 (PDT)
MIME-Version: 1.0
References: <1593412464-503-1-git-send-email-michael.chan@broadcom.com>
 <1593412464-503-7-git-send-email-michael.chan@broadcom.com> <20200629170618.2b265417@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200629170618.2b265417@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 29 Jun 2020 17:38:33 -0700
Message-ID: <CACKFLin7DSADqfm8BjQxtM2sYZZV6Ycq_oHPT0+e53xpCoi1xA@mail.gmail.com>
Subject: Re: [PATCH net-next 6/8] bnxt_en: Implement ethtool -X to set
 indirection table.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 5:06 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 29 Jun 2020 02:34:22 -0400 Michael Chan wrote:
> > With the new infrastructure in place, we can now support the setting of
> > the indirection table from ethtool.
> >
> > The user-configured indirection table will need to be reset to default
> > if we are unable to reserve the requested number of RX rings or if the
> > RSS table size changes.
> >
> > Signed-off-by: Michael Chan <michael.chan@broadcom.com>
>
> Hm. Clearing IFF_RXFH_CONFIGURED seems wrong. The user has clearly
> requested a RSS mapping, if it can't be maintained driver should
> return an error from the operation which attempts to change the ring
> count.

Right.  In this case the user has requested non default RSS map and is
now attempting to change rings.  We have a first level check by
calling bnxt_check_rings().  Firmware will tell us if the requested
rings are available or not.  If not, we will return error and the
existing rings and RSS map will be kept.  This should be the expected
outcome in most cases.

In rare cases, firmware can return success during bnxt_check_rings()
but during the actual ring reservation, it fails to reserve all the
rings it promised were available earlier.  In this case, we fall back
and accept the fewer rings and set the RSS map to default.  I have
never seen this scenario but we need to put the code in just in case
it happens.  It should be rare.
