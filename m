Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C57E25F0E7
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 00:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgIFWHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 18:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbgIFWHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 18:07:43 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E75C061573
        for <netdev@vger.kernel.org>; Sun,  6 Sep 2020 15:07:42 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id 96so1982281qtc.13
        for <netdev@vger.kernel.org>; Sun, 06 Sep 2020 15:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sYIZgxLmeTGkVwtmSEdIxcskLAXiHj1ZBeF4r4LWVAU=;
        b=W7Da2gYp78afiQu9it5Lv/FeyHUqopJCiVdTK61T2//vTnmm270+BFY2ptox3+o5Zr
         t8I1V8IdW1BfEjEeV7xV2hsprde4f1zokoe+HE5BEO7XFni46+kJFW8ck/h7S+k19fxo
         rFjMOVKjeQ0Rd+LmHrFphp/FNEgd+ibkt3E5E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sYIZgxLmeTGkVwtmSEdIxcskLAXiHj1ZBeF4r4LWVAU=;
        b=Q5PZRkugnvXnfTRtyBllIS35jtzjVHzw7G6wgAjngsaaYGdX5OZDrzWlLD4692DWN1
         aP/z5hvUxXT3/KSEwHfnWfeVmRXCYafCVYhirXMwqIxb7ck9IVwYT8RjUTC/4lZ4OM2R
         PrGQFcI4dQRhN+PmDbxqUhFFZkR4FtuZYsIlQ74xzI8fva0ZgpEtLfhJ17VP7QZNobVB
         uUKwqp3WzMcCwMo6WkDWo4StkI6otdlikm6N3I1I+mk6ltwAv+IptqoAeq3rn7zzghaQ
         VPShMfH83ZOV1v6Bm6JqawZpdtSrwmond4350F92hlCiRYplu4SMmpjDLywOkCnEQTz8
         d9hQ==
X-Gm-Message-State: AOAM530W8Pz6h56JJ0DoiZ0QgvwV4AwJlxif5iRxf+YUqvKeXd6hyI5b
        heaYiY0AClvCcCVeMC4BMs353yYB2LcQWYGhgypc8w==
X-Google-Smtp-Source: ABdhPJy8k/CBIAfbTRnACT9eeV/QztQoyHct2vYSEOa9Qz7ovz+JtOIX+u8m0LWI12/MP0h1g0d4kGuXY7HWTlIVS/c=
X-Received: by 2002:ac8:319d:: with SMTP id h29mr17458600qte.32.1599430057611;
 Sun, 06 Sep 2020 15:07:37 -0700 (PDT)
MIME-Version: 1.0
References: <1599360937-26197-1-git-send-email-michael.chan@broadcom.com>
 <1599360937-26197-3-git-send-email-michael.chan@broadcom.com> <20200906122534.54e16e08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200906122534.54e16e08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Sun, 6 Sep 2020 15:07:02 -0700
Message-ID: <CACKFLin=-9=2x0MFuRfXM1HwFQ7uZSZ4i0HymRZDBVKcnK73NA@mail.gmail.com>
Subject: Re: [PATCH net 2/2] bnxt_en: Fix NULL ptr dereference crash in bnxt_fw_reset_task()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 6, 2020 at 12:25 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> devlink can itself scheduler a recovery via:
>
>   bnxt_fw_fatal_recover() -> bnxt_fw_reset()
>

Yes, this is how it is initiated when we call devlink_health_report()
to report the error condition.  From bnxt_fw_reset(), we use a
workqueue because we have to go through many states, requiring
sleeping/polling to transition through the states.

> no? Maybe don't make the devlink recovery path need to go via a
> workqueue?

Current implementation is going through a work queue.
