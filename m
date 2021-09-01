Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E773FE133
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 19:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344171AbhIARgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 13:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbhIARgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 13:36:14 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E47C061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 10:35:17 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id a10so203550qka.12
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 10:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NHSH1MwvdrGRonn/snlW8jVKivFppQy0iIhrl7y3n50=;
        b=M+Z9mAcm18zk8Z/Wuomtg/tXRwSMUoqJj3L0winba4fsjjgGsNwcsdwsaNkj61aE1G
         3LqIHVe7bd8vI3EJNT+jR8KAj/sHFhboaaSiRbMiOclKgitxpUHy9wMKiTcjWtsR8A7e
         KZaLWrUpe8XNyP0ayZ9kPiGF6Bx07NcbDDIRU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NHSH1MwvdrGRonn/snlW8jVKivFppQy0iIhrl7y3n50=;
        b=TZCLvowM3y+Rn2QmlNY6R+LCZAqVku6sAWc4Pl+gQ/Yb7LlmOflflB0/UKealOdVpy
         TFW0qN/tXfP+y6ycFtGf7RQXYbgcLDetztau3Q6aoDLDdlG5zMkoFd/3O8+t0bVQ0lPM
         C0fTyp3c7NAMRyP7MQCDrlEXmZcYACC3rjDfJJ7TCFRo7azZbq5x3acH/FXSUQWeSpb8
         4gUfNnMKIfXduftbqcZwqcciADc+A/xo6nDO6kV9XcbCMIlRc91S5BayPgq8iVzD/5/O
         2C4h0ITgRgwRcavMJd/2c7nycTl8TcO4h0aYNcNQ0S/rfiW2h7S+VmIUIPTTSs8AO2St
         n1/g==
X-Gm-Message-State: AOAM533qCfnOvVbUDX3WM+N7ai4aNT0F7xb4gnxqJOM06afNENalYtHl
        yVUyhKzSupGTd/0P8bWeMzKM0LhShqRXs1Z367WRSA==
X-Google-Smtp-Source: ABdhPJzNZso8L0EBGNfENS6+fb0AE2gw+sYRGB6AT3d6fFi7FZmUrVcBehScK4DBLY2bkXXNNriY8wmAAy1bjRmQOTc=
X-Received: by 2002:a37:b2c3:: with SMTP id b186mr783781qkf.424.1630517716337;
 Wed, 01 Sep 2021 10:35:16 -0700 (PDT)
MIME-Version: 1.0
References: <1630222506-19532-1-git-send-email-michael.chan@broadcom.com>
 <1630222506-19532-5-git-send-email-michael.chan@broadcom.com> <20210901165736.GA2510553@roeck-us.net>
In-Reply-To: <20210901165736.GA2510553@roeck-us.net>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Wed, 1 Sep 2021 10:35:06 -0700
Message-ID: <CACKFLikykwhsWmCN-5Du7NWPtErvpjfzf84UXKTtOna8KO2uKg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 04/11] bnxt_en: introduce new firmware message
 API based on DMA pools
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Andrew Gospodarek <gospo@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 1, 2021 at 9:57 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On Sun, Aug 29, 2021 at 03:34:59AM -0400, Michael Chan wrote:
> > From: Edwin Peer <edwin.peer@broadcom.com>
> >
> > This change constitutes a major step towards supporting multiple
> > firmware commands in flight by maintaining a separate response buffer
> > for the duration of each request. These firmware commands are also
> > known as Hardware Resource Manager (HWRM) commands.  Using separate
> > response buffers requires an API change in order for callers to be
> > able to free the buffer when done.
> >
>
> parisc:allmodconfig, and probably others:
>
> drivers/net/ethernet/broadcom/bnxt/bnxt.c: In function 'bnxt_init_board':
> drivers/net/ethernet/broadcom/bnxt/bnxt.c:12280:27: error: 'struct bnxt' has no member named 'db_lock'
>
> There is a difference between "#ifdef writeq" and "#if BITS_PER_LONG == 32".

Yes.  It is already fixed in this commit:

c6132f6f2e682c958f7022ecfd8bec35723a1a9d
bnxt_en: Fix 64-bit doorbell operation on 32-bit kernels

Thanks.
