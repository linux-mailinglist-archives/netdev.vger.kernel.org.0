Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B80258A42
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 10:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgIAIUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 04:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgIAIUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 04:20:39 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40151C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 01:20:39 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id x2so465650ilm.0
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 01:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GidK5vLHoMLtRO6oix32yakLUL0qUZ3WOH9e89I+SuQ=;
        b=JWDmWWI2C+/q0ErrIxsPoQGB9SLKNmgMZwhlDmezzeSX5mGrH1H4d7Qza+mQ7Tft9/
         nho0o7iksQUkSJNldr31Kt4cC20TXRffDpzHFSvCtXUMTgh8CO3qv5uzlGr15axSysJE
         /M0YbP5QOcxoxto7+xqf5A/mUF+lsCrMkQFu2XYxy2l5uSW8zHwKhgyUrsU15pUiKvEc
         CB2h4JMATfmHV2LuqLbrwRuYJQ2GeuRZ7lanR9ZCbTGdO0jZcV9pyv9nrPCf2+88o2pz
         KacrlNthIMzRA6kNRiI5vRVI4x3Q+lRf7ViIviUgJT0lIwkrlP7t9CV6s/qHIexreAUt
         0JpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GidK5vLHoMLtRO6oix32yakLUL0qUZ3WOH9e89I+SuQ=;
        b=KrMIXEIyCbDYHJEuZU7er9LFCoIUhS7gI4rRqAO8Fc++94Q2frCVfOjlipNib627EJ
         ZVdbD45Gbhqpg9zIMGkhErwNWj+7epRc4nTjXRXx6kxCnKWwv7i5mTqZMuCzErtghE4Y
         G9X4VrIMjn8bJcOEG0EJykcaq3DwHnOngJ5hUQSfnS8ZReQs2+hzCYSiHB9XoVftHSJt
         a4fxM0RsgrqAX3JUOkdFrrcQmqdf9U0cLJpPL0EpVLOiYhaXhAAolJXG25j9yxxIlX0V
         m/hxDr53XV3aAy+BX2KebeQ4Jug2mDyf/CrybusiC+/q95WlLLWhAeU80V0pZN0yLNgi
         J9/w==
X-Gm-Message-State: AOAM530LluIuB5D+IDqph7EnqlnBFs1SPUqigo2PVihDu9EgyOs4fBG3
        zGuDbdMgHvrc+gTgsBQJNH5QQg/PqnWxuupxAmgdBw==
X-Google-Smtp-Source: ABdhPJwhr0RCITIwox3r04V/w0AmGDllGJiZkmxR1qFoL1vbi6uQfoIjEDLNqJArtfxjgnGhwKtB6wvQGQJY2w/Cl2s=
X-Received: by 2002:a92:bb0e:: with SMTP id w14mr344384ili.68.1598948438458;
 Tue, 01 Sep 2020 01:20:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200901065758.1141786-1-brianvv@google.com>
In-Reply-To: <20200901065758.1141786-1-brianvv@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 1 Sep 2020 10:20:27 +0200
Message-ID: <CANn89iL+C5QWxbqKbxcdAa=BtDkEg-tm5dNnvrvXJrMRXQb=mg@mail.gmail.com>
Subject: Re: [PATCH] net: ipv6: fix __rt6_purge_dflt_routers when forwarding
 is not set on all ifaces
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 1, 2020 at 8:58 AM Brian Vazquez <brianvv@google.com> wrote:
>
> The problem is exposed when the system has multiple ifaces and
> forwarding is enabled on a subset of them, __rt6_purge_dflt_routers will
> clean the default route on all the ifaces which is not desired.

What is the exact problem you want to fix ?

>
> This patches fixes that by cleaning only the routes where the iface has
> forwarding enabled.

This seems like a new feature, and this might break some setups.

linux always had removed any IPv6 address and default route it learnt via SLAAC.
(this might be to conform to one RFC or known security rule).
It would be nice to add a nice comment giving references.

>
> Fixes: 830218c1add1 ("net: ipv6: Fix processing of RAs in presence of VRF")

Please provide a test, or a better commit message ?

If your patch targets the net tree, then it should only fix a bug.

Thanks.
