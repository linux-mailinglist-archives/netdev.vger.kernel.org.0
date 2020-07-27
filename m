Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F369622F7EC
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbgG0SnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727880AbgG0Sm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 14:42:59 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E58C0619D2
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:42:59 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id s23so12989774qtq.12
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tup9MI4sbjqIE70wBBQUb0zvEEbXi/n84/0hCym5Uuk=;
        b=UZiHlnRmAO8cZUak8kr9EDZdCDV7vkhgcf76mGmQvXvhw6uDKTiZ/SBbR/ujlyZz/h
         7Jfy3yaXggfcisvFLsmo3pq770aHWzIjZmgbTE0fWMQdwdChyXnMgmykevCtU35iT0QH
         GPP3Yc0JgdMoyAfP8lr/96A+nNYE+J6qfmUOI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tup9MI4sbjqIE70wBBQUb0zvEEbXi/n84/0hCym5Uuk=;
        b=JJ4O8ocgjEZTsZSDAMghhmekS6pPJv2Ekoc6r9Sor9feFiUdA7Kw1GI9V6Trjn5hhD
         dXCenV+KqbfXXk+0tvyKcFNm0d+7CKodyQCPMcw1El2VeIrRK0Fq//Iz3Q0zYViK0ERk
         Gl4LDwYRzR0Rf1IaV3NeTN0pG7ci4/G7Nwd7HNTS1y0EjG/S5RWu4oSuZwewBT5v/elu
         eirmKC+0DJXk5nZ8Nkx0E45cvSDB0tbJW2kIIXEhvCpM25JjqiFy21zFRzYxkYbm9OoP
         E7WOT20DCk5fYKRYHQLOLb4Qgxi8A9vovStIB7mc7PsgXPj11jWVcDp7FfXNRDHR0vQi
         yw/w==
X-Gm-Message-State: AOAM532G6r9NTyzAPwAycljEB5S7tqiqXPLMRhYRFi5qziRX/LQXIDh9
        GHJroUhSH9BlmJ5lfrwbJiDPMIP0vi7V6hLXdSEU4Q==
X-Google-Smtp-Source: ABdhPJxSkNPjBOSJ/9/J+I7DYiGQxRnaLNe9tDTZPQyfGNmOH5kmRwqaQWoE6pLv3TXGimkZhozAjjHzDJ/wsyLgAwk=
X-Received: by 2002:ac8:4815:: with SMTP id g21mr23998288qtq.148.1595875378755;
 Mon, 27 Jul 2020 11:42:58 -0700 (PDT)
MIME-Version: 1.0
References: <1595820586-2203-1-git-send-email-michael.chan@broadcom.com> <20200727.113629.107398328821127489.davem@davemloft.net>
In-Reply-To: <20200727.113629.107398328821127489.davem@davemloft.net>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 27 Jul 2020 11:42:47 -0700
Message-ID: <CACKFLikM-gk8NbjvViEk7SZ97JL2JCW-d2tDy80u5ru2avdFKA@mail.gmail.com>
Subject: Re: [PATCH net-next 00/10] bnxt_en update.
To:     David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 11:36 AM David Miller <davem@davemloft.net> wrote:
>
> From: Michael Chan <michael.chan@broadcom.com>
> Date: Sun, 26 Jul 2020 23:29:36 -0400
>
> > This patchset removes the PCIe histogram and other debug register
> > data from ethtool -S. The removed data are not counters and they have
> > very large and constantly fluctuating values that are not suitable for
> > the ethtool -S decimal counter display.
> >
> > The rest of the patches implement counter rollover for all hardware
> > counters that are not 64-bit counters.  Different generations of
> > hardware have different counter widths.  The driver will now query
> > the counter widths of all counters from firmware and implement
> > rollover support on all non-64-bit counters.
> >
> > The last patch adds the PCIe histogram and other PCIe register data back
> > using the ethtool -d interface.
>
> I guess you missed the necessary infiniband driver updates necessary
> with the firmware interface changes?

Yes, I missed it in v1, but v2 that I sent out afterwards has fixed it.  Thanks.
