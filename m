Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE85D154AD7
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 19:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgBFSMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 13:12:46 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:52711 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727747AbgBFSMq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Feb 2020 13:12:46 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id d9a24a0a;
        Thu, 6 Feb 2020 18:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=UoMsJlCUQufKURXYWGLwJRUQbeM=; b=Tz+lsj
        K+Hb+gbCTWtPUm1u0UdjAyLgoKoXYz4WxCVbO7vGf9fxwzEkFJ1jCHwBlR8h9jEv
        zpQ77BkmR9zzDRlO67hJIOdh6ySq6wLEc1xnjF3xSV5/zX3Ww0glJvIFYEAn1tRd
        qpTsnsIi+TgD/LkrxUUhopVyJiyUv+4LIHcOLkfXrbNWJJ/fp8DuixB0QNLTaHRn
        b0VYMJbAZ7N2cu+3f+zGfiYtFCToelyuIyqVgS5+K8NlBO1Qvazt4lelAM54uhaP
        Gx35KEzw76rxY3+E+LdVw2AEutIvHHPkoLt+uwJyPhY4lw+9ZCY5IsYhmSl/EXO7
        IgeIRIFX963mY6DA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 551f680d (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 6 Feb 2020 18:11:38 +0000 (UTC)
Received: by mail-ot1-f41.google.com with SMTP id j20so6418788otq.3;
        Thu, 06 Feb 2020 10:12:43 -0800 (PST)
X-Gm-Message-State: APjAAAVD1AJCmF5rTpCSUwvK9Tr5FyeCawPc317zPhE+fkwhqg2zwzhP
        UVT6h07S7vpjEsjKA5hMyB6dzLzSf839RYxo2sI=
X-Google-Smtp-Source: APXvYqwi9AYzuxJrHUrhzrEkIf/41GV7WgHZqF0lxsB7tgmFTyvfWKzBVF/8St753FegXqcTG4UsEkYS2/KswPvedio=
X-Received: by 2002:a9d:7a47:: with SMTP id z7mr32144890otm.179.1581012763147;
 Thu, 06 Feb 2020 10:12:43 -0800 (PST)
MIME-Version: 1.0
References: <1580841629-7102-1-git-send-email-cai@lca.pw> <20200206163844.GA432041@zx2c4.com>
 <453212cf-8987-9f05-ceae-42a4fc3b0876@gmail.com>
In-Reply-To: <453212cf-8987-9f05-ceae-42a4fc3b0876@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 6 Feb 2020 19:12:32 +0100
X-Gmail-Original-Message-ID: <CAHmME9pGhQoY8MjR8uvEZpF66Y_DvReAjKBx8L4SRiqbL_9itw@mail.gmail.com>
Message-ID: <CAHmME9pGhQoY8MjR8uvEZpF66Y_DvReAjKBx8L4SRiqbL_9itw@mail.gmail.com>
Subject: Re: [PATCH v3] skbuff: fix a data race in skb_queue_len()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     cai@lca.pw, Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marco Elver <elver@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 6, 2020 at 6:10 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Unfortunately we do not have ADD_ONCE() or something like that.

I guess normally this is called "atomic_add", unless you're thinking
instead about something like this, which generates the same
inefficient code as WRITE_ONCE:

#define ADD_ONCE(d, s) *(volatile typeof(d) *)&(d) += (s)
