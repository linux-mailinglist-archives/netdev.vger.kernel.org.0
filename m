Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 097D818BDD7
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 18:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgCSRUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 13:20:48 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46885 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgCSRUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 13:20:48 -0400
Received: by mail-ed1-f67.google.com with SMTP id ca19so3637080edb.13
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 10:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mGnzjLPuiF5jh+YmVcnbPs/rygoBzTtr0yQpmvu1C/U=;
        b=ho5WkQIp7FBmmWnNEs8qarjlXHQ/bMpYIjVlz5diN+cFqHjIA9Cfpaie2yvrq56MzY
         6TnA04IH3cBRxYREMcsiPUpLCig/QPzuawQ7+ZDABjg2D7iZ5uNSWio6VnyJC48k22lp
         9sUOw53EsymdqqmachpMBK4cZKv94z+KiqobI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mGnzjLPuiF5jh+YmVcnbPs/rygoBzTtr0yQpmvu1C/U=;
        b=juY6MB5qTOSwKYgOooQN6SMmdpGJNdNWPD3EIghvka3q152DueqMVt7+2o2Xj/Tcpm
         vMF+/xUktai1fYuGalUtyesgkIypaeEQ0VkHjusc9WgIKBnSXuwTmcKxxPdOa3ijgObc
         qSGVwgrwwSIFFKBaNVnhiSW30vIdog+mp+/CTGPiev68dyc/J1S9ChZrTp3vRew3OBXP
         B5DEYcCLXKcyJ3uV9Z9oZEiAJVhJDrP/yiELtApEqKph+BBbl+Op3pryEl3ldAKioxup
         +0M20EXmyaSju8PQEJuvmDnqYM9q9Ls4f13cKJsmslPliQEdSfKD5NPLFxWnNhEvhqDw
         4TxQ==
X-Gm-Message-State: ANhLgQ1/BA6J2VnSo+kA50YggRJRyuiwBIUdvL4b1GDjxmCwqKG6xteK
        SI4EyO7P8iQqr33HmGNUOvpiqZdCPmw=
X-Google-Smtp-Source: ADFU+vuPThJQTr4g0NcJMOieyn4USA91OlPTx1Z5kK7B5llp+xFcL5QQ1fC2Ca4RUtNAbeXo9yXfqw==
X-Received: by 2002:a05:6402:c8e:: with SMTP id cm14mr3912337edb.163.1584638441696;
        Thu, 19 Mar 2020 10:20:41 -0700 (PDT)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com. [209.85.221.46])
        by smtp.gmail.com with ESMTPSA id j26sm177050ejd.6.2020.03.19.10.20.41
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 10:20:41 -0700 (PDT)
Received: by mail-wr1-f46.google.com with SMTP id w10so4119705wrm.4
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 10:20:41 -0700 (PDT)
X-Received: by 2002:a19:c7:: with SMTP id 190mr2779646lfa.30.1584637965843;
 Thu, 19 Mar 2020 10:12:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200318204302.693307984@linutronix.de> <20200318204408.521507446@linutronix.de>
In-Reply-To: <20200318204408.521507446@linutronix.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 19 Mar 2020 10:12:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj3bwUD9=y4Wd6=Dh1Xwib+N3nYuKA=hd3-y+0OUeLcOQ@mail.gmail.com>
Message-ID: <CAHk-=wj3bwUD9=y4Wd6=Dh1Xwib+N3nYuKA=hd3-y+0OUeLcOQ@mail.gmail.com>
Subject: Re: [patch V2 11/15] completion: Use simple wait queues
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 1:47 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> There is no semantical or functional change:

Ack, with just the explanation, I'm no longer objecting to this.

Plus you fixed and cleaned up the odd usb gadget code separately
(well, most of it).

              Linus
