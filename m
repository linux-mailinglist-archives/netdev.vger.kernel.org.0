Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4292490C1
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 00:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgHRWZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 18:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726852AbgHRWZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 18:25:48 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029A6C061342
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 15:25:48 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id q14so19034882ilj.8
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 15:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=erRIyjYXonsYT08esyQAeDBVBcUsHuLyzmq7Tg2jmEg=;
        b=r5LgrMUXJ2KQ6T9ZQuFkKbK7ys8/sUktLMxgaxVl1OJASuaI1TDXLsT0HWbUFk2Oy6
         AXdiQsAzChb4O3cSDU5thuIzhbxQO7ZEvUiVIpbfPBn/KFEWO++K2hlSE0yl8TZipUai
         OXxl/gl1zk+GMwoKcs+8gYtnHYOnPwNfvUlkBSXwnhiYAxyjElyAj4tcNLowIu2KZHfD
         KoBF0OdbI/bWlbClWniqF5XiIn0VGtBpzM/GB+WSBdhl01uvAEbttQ/bkKMsalsnGU2W
         kYEPxVWxMualMNSp3WFI4wXwl7yunisydaqHQjEVyMj+u/YOYEunXY9PsjLXbU2m7jWU
         8c2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=erRIyjYXonsYT08esyQAeDBVBcUsHuLyzmq7Tg2jmEg=;
        b=iq15aP+TzqXZ5wHPQr7jMhG1wVKpE7gBqMSAW39YWcBhRc2lTzI1oZY82cwk6P9HXr
         TcDqoSlxQj3oMKScHastgNee+1z8gxGyQZBDpI3vqxvvPOP/u4dhXjSxulErguG9s6Dj
         EkxegFXysEPsHlbZ4sMY+5HyN5ocNPtIKhJ6Big4bL9L0dPiEk+YObkRx835HedyrKvj
         BIiXlOkeALIignm+ssTREmmQd0QxUiYe6fmVxc62/COhOPAvmC5f64/Yx9tnCQtz1Wdv
         xV6LPTK3yIEDQbiV99o4jBn3tWkOmrxM/v4SoozZjthYWUDh50Y8dhl10ZOcU9uuSY5x
         vtZA==
X-Gm-Message-State: AOAM532eymrD/lRpJauvhBZvzbcmj8mHOt7qvbB+PkAxUFr/6YdoMBYM
        2wJEmU2uCjycXNxZJE4LbtyvwEHXWkVhxVNUrrIaJA==
X-Google-Smtp-Source: ABdhPJw2sQLzCwoVZt14wNNYEdfsQuf31nQZqxyVTtehzu+6E+wJgwyt/WkJGjx+4cdDFdAGEhKESBL6kMuPZK+sZ1c=
X-Received: by 2002:a92:de43:: with SMTP id e3mr18755287ilr.124.1597789547245;
 Tue, 18 Aug 2020 15:25:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200818194417.2003932-1-awogbemila@google.com>
 <20200818194417.2003932-7-awogbemila@google.com> <20200818.131657.963549389331033291.davem@davemloft.net>
In-Reply-To: <20200818.131657.963549389331033291.davem@davemloft.net>
From:   David Awogbemila <awogbemila@google.com>
Date:   Tue, 18 Aug 2020 15:25:36 -0700
Message-ID: <CAL9ddJcSHYosJBdOhs6-KHmWRDrLwLXd-NaFsgJWB7gNi3DRUg@mail.gmail.com>
Subject: Re: [PATCH net-next 06/18] gve: Batch AQ commands for creating and
 destroying queues.
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Sagi Shahar <sagis@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Got it. I'll fix this.

On Tue, Aug 18, 2020 at 1:17 PM David Miller <davem@davemloft.net> wrote:
>
> From: David Awogbemila <awogbemila@google.com>
> Date: Tue, 18 Aug 2020 12:44:05 -0700
>
> > -int gve_adminq_execute_cmd(struct gve_priv *priv,
> > -                        union gve_adminq_command *cmd_orig)
> > +static int gve_adminq_issue_cmd(struct gve_priv *priv,
> > +                             union gve_adminq_command *cmd_orig)
> >  {
> >       union gve_adminq_command *cmd;
> > +     u32 tail;
> >       u32 opcode;
>
> Please use reverse christmas tree ordering for local variables.
>
> Thanks.
