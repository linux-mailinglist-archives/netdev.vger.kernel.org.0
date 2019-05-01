Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 765D61064A
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 11:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfEAJ1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 05:27:50 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34923 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbfEAJ1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 05:27:50 -0400
Received: by mail-lj1-f194.google.com with SMTP id z26so15088737ljj.2
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 02:27:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XqKy8I+a4T0E223MovLI7JFFmULW34ElM/2ZaJcNK4s=;
        b=KHwWO3/Xsy0QHfHzhX2ZJ+huUw9RaHYTlYXYT02s0DIJdxSaHyVvDkC005L6HHRff3
         4RXlADG+DN3Hn6jsPuYMadmAhF5Cm8DqNDKbK/3JwWcF1yuh/uwyMwFcfN2+ZIMP/Ub3
         ns5J4MDqHLxx7nYU0QRBHY5PRSxWcYa0RRJwja2/SsO61jWVU2Ondfri9BU4lyAm+oAn
         6zsq/FIJ9AWFs83caNt6/W8xJuofNaCx5L26MwJnOMJuZCyapCb45rXc8ONS+qZlnnTg
         MIA9fYaoLLMslApB1PxJ0ljUPMDQGGbZPtz98r/4u99sSr79Z2Yt8OBozI6KJaE9ct/6
         QuAg==
X-Gm-Message-State: APjAAAVLcB4yp9Om7gF/rFaZ/ohla46mMBVHWdNrxi7AEDpMpvsNPYyx
        ZdJg0D1YpgbrPB5efUUk3KXCVjL4tkCQiSfIw0d/rQ==
X-Google-Smtp-Source: APXvYqyfcdKdmTzQ8IDTm8A6KvrZpfBsYY5e4SzYQbGiU178aoFr95yoxbDZs5+rGpEjE6DYrQH5+YnXMs0fV9fhFn4=
X-Received: by 2002:a2e:9f53:: with SMTP id v19mr6467840ljk.0.1556702868264;
 Wed, 01 May 2019 02:27:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190429173805.4455-1-mcroce@redhat.com> <CAM_iQpXB83o+Nnbef8-h_8cg6rTVZn194uZvP1-VKPcJ+xMEjA@mail.gmail.com>
In-Reply-To: <CAM_iQpXB83o+Nnbef8-h_8cg6rTVZn194uZvP1-VKPcJ+xMEjA@mail.gmail.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Wed, 1 May 2019 11:27:12 +0200
Message-ID: <CAGnkfhzPZjqnemq+Sh=pAQPsoadYD2UYfdVf8UHt-Dd7gqhVOg@mail.gmail.com>
Subject: Re: [PATCH net] cls_matchall: avoid panic when receiving a packet
 before filter set
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Vlad Buslov <vladbu@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 30, 2019 at 11:25 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Apr 29, 2019 at 10:38 AM Matteo Croce <mcroce@redhat.com> wrote:
> >
> > When a matchall classifier is added, there is a small time interval in
> > which tp->root is NULL. If we receive a packet in this small time slice
> > a NULL pointer dereference will happen, leading to a kernel panic:
>
> Hmm, why not just check tp->root against NULL in mall_classify()?
>
> Also, which is the offending commit here? Please add a Fixes: tag.
>
> Thanks.

Hi,

I just want to avoid an extra check which would be made for every packet.
Probably the benefit over a check is negligible, but it's still a
per-packet thing.
If you prefer a simple check, I can make a v2 that way.

For the fixes tag, I didn't put it as I'm not really sure about the
offending commit. I guess it's the following, what do you think?

commit ed76f5edccc98fa66f2337f0b3b255d6e1a568b7
Author: Vlad Buslov <vladbu@mellanox.com>
Date:   Mon Feb 11 10:55:38 2019 +0200

    net: sched: protect filter_chain list with filter_chain_lock mutex

-- 
Matteo Croce
per aspera ad upstream
