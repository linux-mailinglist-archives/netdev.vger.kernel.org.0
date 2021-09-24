Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66214179D1
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 19:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347776AbhIXRXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 13:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348014AbhIXRWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 13:22:43 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273B4C0614ED
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 10:21:10 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id r4so7252205ybp.4
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 10:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s4aBU9hVptJACVXCGvcssMyH4GtcIwSagpPyw2kwXkY=;
        b=Qg8lIckWZ6QdcUhs3oi3WYUQvebJvsPzGz4Ggd06zDmyXsPv09i+j1hxlq89HJeAJ4
         jpzTkzF0TfKy2qFxodY3KTvJRuSt14izCkjmyfQkjMz+JRK0lD5W9hrdCB7i8GvS3DTy
         RueUXWzAodwjLjwYjQgS7Igq2UQlJAOrDs2Uc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s4aBU9hVptJACVXCGvcssMyH4GtcIwSagpPyw2kwXkY=;
        b=4mdsvNZitidzIiSs4Z7e4yMfiowBo0tktJ7g/TIFoXeqFxq28WzL/P5WvosuzszNgq
         z/TysO5IkCzRtBlvSV6q6q/foyeLDGSLKZ09GKka4B/3zbM+oCRg7RCVWPWKtxfx8saT
         ahq5qCJJeRRfHPbOF5Totu1w3WGYacDOfFD9QvRo0z0BF7hmJVgaXOTLiPlzBajO/nE9
         tN1oa5aAlzGq5+xOMmRR+hGZyynGM6z8JCqmj3m3w/IIcLP/sgaXtx+LkVx75eo3yfZn
         JBgAkYPVPiCm4MS2D3bUw1F/mydVEvF24VxqXNAdeMl1KR0B/N2ZttQyb9ZYIHwoaQoo
         DQrQ==
X-Gm-Message-State: AOAM532WMzD3VouN7m9eHaSWb3/eR7yNzqGQ0Q4ryZaOVFHG9/SgwdrR
        Ms6jGPAgAXtHyCswChOAlXONoLPwXZS/B34GCJ07+Q==
X-Google-Smtp-Source: ABdhPJw7sidVyzpxBf4Z23QuW71wp38GW2fuO1RQ+xJSKeJDQqvrm+cVUNF71j/yXC17knITQy0pQ0WvIe2Kt0WgTO0=
X-Received: by 2002:a05:6902:1248:: with SMTP id t8mr14318420ybu.85.1632504069110;
 Fri, 24 Sep 2021 10:21:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1632420430.git.leonro@nvidia.com> <e7708737fadf4fe6f152afc76145c728c201adad.1632420430.git.leonro@nvidia.com>
 <CAKOOJTz4A2ER8MQE1dW27Spocds09SYafjeuLcFDJ0nL6mKyOw@mail.gmail.com>
 <YU0JlzFOa7kpKgnd@unreal> <20210923183956.506bfde2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210923183956.506bfde2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Fri, 24 Sep 2021 10:20:32 -0700
Message-ID: <CAKOOJTwh6TnNM4uSM2rbaij=xO92UzF2hs11pgOFUniOb3HAkA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/6] bnxt_en: Check devlink allocation and
 registration status
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexander Lobakin <alobakin@pm.me>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com,
        Igor Russkikh <irusskikh@marvell.com>,
        intel-wired-lan@lists.osuosl.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Javed Hasan <jhasan@marvell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        netdev <netdev@vger.kernel.org>,
        Sathya Perla <sathya.perla@broadcom.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 6:39 PM Jakub Kicinski <kuba@kernel.org> wrote:

> On Fri, 24 Sep 2021 02:11:19 +0300 Leon Romanovsky wrote:
> > > minor nit: There's obviously nothing incorrect about doing this (and
> > > adding the additional error label in the cleanup code above), but bnxt
> > > has generally adopted a style of having cleanup functions being
> > > idempotent. It generally makes error handling simpler and less error
> > > prone.
> >
> > I would argue that opposite is true. Such "impossible" checks hide unwind
> > flow errors, missing releases e.t.c.
>
> +1, fwiw

I appreciate that being more explicit can improve visibility, but it
does not make error handling inherently less error prone, nor is it
simpler (ie. the opposite isn't true). Idempotency is orthogonal to
unwind flow or the presence or not of a particular unwind handler (one
can still enforce either in review). But, if release handlers are
independent (most in bnxt are), then permitting other orderings can be
perfectly valid and places less burden on achieving the canonical form
for correctness (ie. usage is simpler and less error prone). That's
not to say we should throw caution to the wind and allow arbitrary
unwind flows, but it does mean certain mistakes don't result in actual
bugs. There are other flexibility benefits too. A single, unwind
everything, handler can be reused in more than one context.

That said, isn't the more important question what style and
assumptions the surrounding code has adopted? In this particular case,
I checked that this change wouldn't introduce the possibility of a
double unwind, but in other contexts in this driver code base,
changing error handling in this piecemeal way might actually introduce
a bug in contexts where the caller has assumed the overall function is
idempotent. Isn't local consistency of style a more important concern,
especially given that you are not predominantly responsible for
maintenance of this driver? Dealing with this exception to the norm in
our driver certainly places an additional burden on us to remember to
treat this particular case with special care. We should either rework
all of bnxt error handling to adopt the more accepted canonical form,
or we should adopt the surrounding conventions. What we shouldn't do
is mix approaches in one driver.

Regards,
Edwin Peer
