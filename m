Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4871FA1E7
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 22:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731487AbgFOUpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 16:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730995AbgFOUpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 16:45:49 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D56C08C5C2
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 13:45:49 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id e16so13804865qtg.0
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 13:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6NB11slt87BU+4xj4RQk4kGC454YPuIt0Wk8mlOD8qk=;
        b=XyChLv1QYsXD5ZuVVF4fG9lmqfNx/h8JnfCH2w2aLZmyMfg9fW63/yqx3dTabIZAL9
         Q3EN4/VBshdINKbNRUouJBzlsurFl6ppvkSQPivADTlfTNbZ2dBdRYCooQtDBi91uBX3
         fCDFeTuxjseCMpFGuxlKN+UO1Wpkv27H3zh6k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6NB11slt87BU+4xj4RQk4kGC454YPuIt0Wk8mlOD8qk=;
        b=WYWEZ8cq10upDkvIr1yAvZTnomP5r121EDlDdaK+xvf4ZBXzj1Ug6+X5kEwzHNRwHU
         GfLciFA/IFsDrfoRhugh48U1fjS8JKHQpYt//BBBrWW/POz8B9dAytY1VADkBgd2zTAt
         6kxkPmU+jnYd32Qus2S/SRyfVgG1llTPe5651+eeos1LMHYAI/rkeWKu/y6fHfhALPTv
         QImBdFwsWey06StprJ1QfFj7apCNpNGwoxQjEAdrrvA4hJeJMxqCTii03SiE/hwHRR0i
         /BL6hDNWAXByHWVOWAstjv+AvkYcB/YV+/U3Uc5eCcckeEjLmujTeKsuEPLXd9n7gZOL
         +Grg==
X-Gm-Message-State: AOAM531ME67ZZmMeGpRk/rmYrZ47JYn2PXgFpzq8qW9iHBA6WRdezsFV
        bNp79XELWZ6Rpr6KOHhVmUn/5hbPkiPzXC9wt9g9LDnzzqg=
X-Google-Smtp-Source: ABdhPJzS1j33q5F3QlrW3xLt0Lv+QX+HY5yC7a9+YDWovc8HBDcoIFoVVwjf5cJk1ADPwQiREl5cykqHZfnxVpdlK8c=
X-Received: by 2002:ac8:43ce:: with SMTP id w14mr17451952qtn.80.1592253948476;
 Mon, 15 Jun 2020 13:45:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200615190119.382589-1-drc@linux.vnet.ibm.com>
In-Reply-To: <20200615190119.382589-1-drc@linux.vnet.ibm.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 15 Jun 2020 13:45:36 -0700
Message-ID: <CACKFLimd0a=Y8WyvqCt4BD7SU_Cg1vQ=baKs6-uPv0dZuCm=mw@mail.gmail.com>
Subject: Re: [PATCH] tg3: driver sleeps indefinitely when EEH errors exceed eeh_max_freezes
To:     David Christensen <drc@linux.vnet.ibm.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 12:01 PM David Christensen
<drc@linux.vnet.ibm.com> wrote:
>
> The driver function tg3_io_error_detected() calls napi_disable twice,
> without an intervening napi_enable, when the number of EEH errors exceeds
> eeh_max_freezes, resulting in an indefinite sleep while holding rtnl_lock.
>
> The function is called once with the PCI state pci_channel_io_frozen and
> then called again with the state pci_channel_io_perm_failure when the
> number of EEH failures in an hour exceeds eeh_max_freezes.
>
> Protecting the calls to napi_enable/napi_disable with a new state
> variable prevents the long sleep.

This works, but I think a simpler fix is to check tp->pcierr_recovery
in tg3_io_error_detected() and skip most of the tg3 calls (including
the one that disables NAPI) if the flag is true.
