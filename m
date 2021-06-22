Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C9A3B0CE8
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbhFVScP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbhFVScO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 14:32:14 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2526C061574;
        Tue, 22 Jun 2021 11:29:57 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id n7so24796054wri.3;
        Tue, 22 Jun 2021 11:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6JFgiOQERZSIy0aWNl2Nl9CVI7uX5ANotzhjU2/vxGw=;
        b=jIbmPpEhJU74qAsdco+GdmvRW7QJEL+iz1azILolEbS/x6/m088dbH2Nhzl5jhr/uv
         etvI7XLpDyh+bk/6gXuIHY0qMATunpX6fjQ3NrttjO4u+HbNcinf7bkJCQxK8sTSc08K
         EoD9Afn5HGSgn+Bsc3DifuEAeAh+2YmhjR3IlZwggW4YcAmA9YQCwSPGdwxp3nKxdqb0
         AQpC8x/zK57rBdJwxzz/0ypiXYBTz0TsUo7L7khGcxjucRoKlrGGs87Kw19J6/FIvrnb
         9tkX8QHrq7pPq5oeKCHiUkpSBUye9lJpHvG33iEiCVYT4O+Za7+fJOl62iM2ikc3EotX
         D6bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6JFgiOQERZSIy0aWNl2Nl9CVI7uX5ANotzhjU2/vxGw=;
        b=paUN1JQgOkHGrH9gDnIUcxdCdJIaPHCWjHPN8cbpST/fJn+Pl3QXWs5JbHWfqw9Q4y
         YJKdbm9XJRdYL9daGjL40gDjL0OKGCM7wy7WJxbQv8BRY3yP7jUDO1P5DZbZYebJwUtX
         U7TdNhftsMtWUAwuQMIjxsjTOGzDgzUrzPsSuVa4AkEe4ABcatLyUfcq3aMIwr2Be7Oo
         sNo4yEFPzxxM2BbvXHtaU7LoM16F2b1FdFbiBCCGHiX3RT53U9tha6+t2TxGNM55GNGk
         ZD9TdOfR7LsZ6PKfvC/rH/ZVepJ9Al2mMTk8OE7D9uiikpmzzrks46aq7I903qqCbdxT
         gQaA==
X-Gm-Message-State: AOAM533ylD3ZWMDCcWKBXeRCfsj8tA+FLNxXA2+unrJypPuVJKcAu6ZP
        CcVpOKNrcDBw4yI+YFYbt5Oil6kUQFTkCGkUXMY=
X-Google-Smtp-Source: ABdhPJzLN9lgHu7OvRNCUQaRpxm70alEhzgPPZOlg1pCZqZyJEQ8nIDs/TQ1ghwGdgr8Y400beOlOs0T7GCv1ZBoo3g=
X-Received: by 2002:a5d:5741:: with SMTP id q1mr2127032wrw.65.1624386596637;
 Tue, 22 Jun 2021 11:29:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210616020901.2759466-1-mudongliangabcd@gmail.com>
In-Reply-To: <20210616020901.2759466-1-mudongliangabcd@gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Tue, 22 Jun 2021 14:29:45 -0400
Message-ID: <CAB_54W51MxDwN5oPxBqioaNhq-eB1QfXNMyUpmNZOWNDM3MmnA@mail.gmail.com>
Subject: Re: [PATCH v2] ieee802154: hwsim: Fix memory leak in hwsim_add_one
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        syzbot+b80c9959009a9325cdff@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 15 Jun 2021 at 22:09, Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> No matter from hwsim_remove or hwsim_del_radio_nl, hwsim_del fails to
> remove the entry in the edges list. Take the example below, phy0, phy1
> and e0 will be deleted, resulting in e1 not freed and accessed in the
> future.
>
>               hwsim_phys
>                   |
>     ------------------------------
>     |                            |
> phy0 (edges)                 phy1 (edges)
>    ----> e1 (idx = 1)             ----> e0 (idx = 0)
>
> Fix this by deleting and freeing all the entries in the edges list
> between hwsim_edge_unsubscribe_me and list_del(&phy->list).
>
> Reported-by: syzbot+b80c9959009a9325cdff@syzkaller.appspotmail.com
> Fixes: 1c9f4a3fce77 ("ieee802154: hwsim: fix rcu handling")
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>

Acked-by: Alexander Aring <aahringo@redhat.com>

Thanks!
