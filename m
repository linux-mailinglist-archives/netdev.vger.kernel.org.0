Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E263611747C
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 19:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfLISmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 13:42:45 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:45407 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfLISmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 13:42:44 -0500
Received: by mail-yw1-f68.google.com with SMTP id d12so6171265ywl.12
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 10:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h/brMn6X4DuXeS1XkWWhrmC78cVoaKxmWsFonfiedmY=;
        b=QPYUngSkZT72BLFfztk8fN5xqUMBXXxnHUF+uYHijo5RZ9V1Uh6js/n1Txhhf+EtTm
         Sr79gq5ukMUHj2fJFTqsigThFOoWjDRTd1a47O/grNKTAtCZihKVYe0mMvvJ87Q/XN8n
         uB6zINHPx2fI7McECW2K4pjYGbnKP+aePwTGMfpRrDJqNoBx10u8DAqmZ726lZ8Y0OHI
         ItrSUF4/B0Edf1mkJCzUDH1Itpd5i7Hsl2Q920NxYFFW+/oM8S7bzjn/U8ToMf/zeGGd
         LCcLez9mtCF4ZcKC42ubA1IF5qAYdAXnqy9hzqoXVIBk9skgMW6IfgQk4vZDpGaIyYC6
         dTsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h/brMn6X4DuXeS1XkWWhrmC78cVoaKxmWsFonfiedmY=;
        b=g90JZv70PDJU5M7jaDABX3LQr0WUwUqP7/HatxZUSR3nYoNlSWGqs0MLt+jYhBYgxI
         3y0MVD09YzzO+LNsog+2IWO15DWoq3up4LTW5j32d4VjKmRyf8ORFPokmL1feYQzyfpw
         ObDW36YFPx2Gv/z0qpgloqizBpSDT4Y4JTDeT54etdNGmOxEF6g7G8OBEVWZBIKIA4Mb
         AbUzrk8Op/8nOcg212PXZa/+qKcct846wpo53tVW3xJA2JODDnYoH0oGtBvXt13SiBn8
         KGU4+I+8ekumNFf3MWe5CQ8wP6dvLVgv1juqcTSFkd3Y+EVTXwDwQwcuuN4OfIRtaRX5
         5Icw==
X-Gm-Message-State: APjAAAWSpxFaLWgn4bEIGcPtRcIYYNCE2P8cdyxTGvS7GGpYwWRtNlFN
        R5LsB8dv57BWIV26roUTbw2phCFk+1fpqUe/Et829A==
X-Google-Smtp-Source: APXvYqzOAWtmPTTNovTejuVt94ODr9I/KZiR7MRV6kvA5SZxqPk6QHqrLaE7pmL843lqNdHHiEPg3nA9sNpQgg38eQk=
X-Received: by 2002:a81:3c95:: with SMTP id j143mr21269560ywa.466.1575916963332;
 Mon, 09 Dec 2019 10:42:43 -0800 (PST)
MIME-Version: 1.0
References: <20191207221034.31268-1-edumazet@google.com> <20191209.095046.1448956021137333118.davem@davemloft.net>
In-Reply-To: <20191209.095046.1448956021137333118.davem@davemloft.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 Dec 2019 10:42:32 -0800
Message-ID: <CANn89iJKD7W-2a6djh-UwVUzwMknHTnh0QmJUTuGWSduMaHwbA@mail.gmail.com>
Subject: Re: [PATCH net] bonding: fix bond_neigh_init()
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 9, 2019 at 9:50 AM David Miller <davem@davemloft.net> wrote:

> Aha, now I see this.
>
> I moved the neigh_cleanup() removal to net and applied this too, all queued
> up for -stable too.


Yes, sorry for this, but when I cooked the first patch I did not know
yet a bugfix would follow shortly after.

Thanks.
