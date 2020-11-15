Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95252B3209
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 04:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgKODLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 22:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbgKODLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 22:11:25 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3159BC0613D1;
        Sat, 14 Nov 2020 19:11:25 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id 35so2272710ple.12;
        Sat, 14 Nov 2020 19:11:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=ukfVupsoBY8wkZwTJBGd3ADBH/ygOk7x7LJMOM5IEEs=;
        b=MRiaFED49X65sqy4dYNQV9EFlBoCtJ6jSM8VjfGy4myZ6wJA1DPfztU0Nf6wyZ9KWR
         2pQinrVzpg6N+MqlYJvUHOdpDCit4uvnhLcbbllPLO2YqBhNRfKbsjYT5X1mKGeIV2ZT
         OeAUHv7gSb0H1SCPElq75gskVmOGpll/ZScs2QC3qom7uuU/q2d8FsdfkQx3KggP1jAr
         uf7sHrUoH3+4E0koW5VuyhZPSRZCknpxfupKLJ7OmYVQlQI/GFlFbI42NqXHVvDncdtx
         9dPsZU2vbvyNJYf/L18ux2G6xRH6sN6dSSqgH1nJCaTRgBt1+ztCzWASqTXRi3qWAtxC
         6qKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=ukfVupsoBY8wkZwTJBGd3ADBH/ygOk7x7LJMOM5IEEs=;
        b=Zgh5CllNAynf/aiHivlyGZRs6jcW/8Ybit7dNcVwxYlqPt1FfiITzm4S5iANOIYI/a
         YUX5QzOo2ZsUY0dRh5+KKdB9sZX0ma4AZfwwdAc1d3aKsLhfGl3c5CdVvDOYkIRSNRpB
         4gm8mVrJr/2dpxc1PpoTBDsFEGIctIsxZt0tD436jR2cA5PdmXymKMldsQ06nyHjiclm
         H9kVvkKEF+v1rLSJ/o4ZBqOLQy8HsXjzQz/p67hzeit8xEKgLT3Fv3juZnOs8wRw1+9/
         jT8b0zx6TtMtdy3fjz2bM3U2TXb4XCx7Iqp6RWHYvgCzKUtWqpwUE/b3vI3tFf2gbl3w
         xflA==
X-Gm-Message-State: AOAM530Xb2an3wVysVsWqpI4fTmkiH3RZXkuT1cYPlMQDlkghAAnALM4
        8cC/VRHvs0TZS1JTxaIlhMp52yxLUQm8EZT8UZeAcj5FJC0=
X-Google-Smtp-Source: ABdhPJxAe48x9dK9XEgFFP9VHg3XUEQUtTeUxG4WEeqSrj2uudH/qNksnYN0iH19bOhP4w7TGgiv3QQ6We+qVh8/pzs=
X-Received: by 2002:a17:902:9890:b029:d8:e265:57ae with SMTP id
 s16-20020a1709029890b02900d8e26557aemr3458405plp.78.1605409884682; Sat, 14
 Nov 2020 19:11:24 -0800 (PST)
MIME-Version: 1.0
References: <20201114103625.323919-1-xie.he.0141@gmail.com>
In-Reply-To: <20201114103625.323919-1-xie.he.0141@gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sat, 14 Nov 2020 19:11:13 -0800
Message-ID: <CAJht_EMN14idYb9uY6eSASVb+ZHM6jZ3c=Kr5mTSjVE+2aYyoA@mail.gmail.com>
Subject: Re: [PATCH net] net: x25: Correct locking for x25_kill_by_device and x25_kill_by_neigh
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 2:36 AM Xie He <xie.he.0141@gmail.com> wrote:
>
> This patch adds correct locking for x25_kill_by_device and
> x25_kill_by_neigh, and removes the incorrect locking in x25_connect and
> x25_disconnect.

I see if I do this change, I need to make sure the sock lock is not
held when calling x25_remove_socket, to prevent deadlock.

Sorry. I'll deal with this issue and resubmit.

I also see that in x25_find_listener and __x25_find_socket, when we
traverse x25_list, we should probably also hold the sock lock when we
read the element of the list, and continue to hold the lock when we
find the sock we want.
