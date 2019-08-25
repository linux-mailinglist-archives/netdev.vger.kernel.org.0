Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCB559C58B
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 20:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbfHYScU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 14:32:20 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39915 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728863AbfHYScU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 14:32:20 -0400
Received: by mail-pl1-f194.google.com with SMTP id z3so8744931pln.6
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 11:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U3m17TISxgf6BUYIDX0cfztJuO/ssulmKc6XAVFQoKc=;
        b=BIPJMU3z8XrlwKDnv+ytHYIify/lU5Pde/kcx6iQK/RPBwUQdSijfRszyWmkQLALgu
         ryvKkcqUa3ReZnSwEdw+S23t5eSh+fu4XQArZqkpZhBW9IbqTKS0KTdSlq1ijWhKG3oZ
         qArLBbBPRLcpNAuA1KEC/Z0eQ3dkE5mx6RjGxtZsVTH7T4nlklAl6ps6e+u/xiNgWvKX
         6GdMwI2FBXY/Vxf/pwDpe11b09VfWZfRNhcPYwdGv/POEnr/oimxufb3aIchwyCQHOZA
         v0sLm1ngO56Mg68qN8I/6xH61rvkjWy0Bmay6tp5CJlFhIA9wMf/GdVRJjoqr1Duw0Bf
         Wprg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U3m17TISxgf6BUYIDX0cfztJuO/ssulmKc6XAVFQoKc=;
        b=Wn4lsn04S7hVX8jv6bgx1VCdvLEf4WX/BRO6qXUOsnl7Obdvjx+DrkGgVZyH76SzYe
         yfSjGh5vIFdNybzHL29O5pKPJ2OzOpYWHAJIWMArHcCI8EPaYE59kXgBbL3dVIWMDdtr
         VHi5iO68bxgfXWn/xMuZd8eXDA6qXziMD9Ckt6UeGOs9pfM6ubILWSdZYcC8i1XgYMmg
         DRC1FKpYSrfx0DvsfEdoLqTDR7Qg/FkdprwmkxbNHOoBiVZphQJ/w+kap3ryoYfJJ0HN
         gUIK5ZJKzgYwUaE45QLl9Nj4pzFfpKzF+4pc9jga4irDdtxGq4JTFRjfu3DxxhXzqq25
         qayg==
X-Gm-Message-State: APjAAAVF3rtZqPSufG71o5FuUD+YN4e7IoyMoRr8xAzOtl9hMv6j8dcz
        sqMuVcxho6jUqj9YW1Or3qzQm4iJlolZIElOpYM8syRZ
X-Google-Smtp-Source: APXvYqyAnzof4Go0ZdJ0F3jPkFdK1Bl38suRuWMuRihaVQJpJeTYQeM0CXgnQx0T+EgWYX4z8atGylvvbdfGslHIcqI=
X-Received: by 2002:a17:902:26b:: with SMTP id 98mr15459607plc.61.1566757939921;
 Sun, 25 Aug 2019 11:32:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190820223259.22348-1-willy@infradead.org> <20190820223259.22348-30-willy@infradead.org>
 <vbftvaa4bny.fsf@mellanox.com>
In-Reply-To: <vbftvaa4bny.fsf@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 25 Aug 2019 11:32:08 -0700
Message-ID: <CAM_iQpXXKwKUhzU1wwXrXqwXSEq-OJ4diBhSuR04kitLKs=g0g@mail.gmail.com>
Subject: Re: [PATCH 29/38] cls_flower: Convert handle_idr to XArray
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 21, 2019 at 11:27 AM Vlad Buslov <vladbu@mellanox.com> wrote:
> At first I was confused why you bring up rtnl lock in commit message
> (flower classifier has 'unlocked' flag set and can't rely on it anymore)
> but looking at the code I see that we lost rcu read lock here in commit
> d39d714969cd ("idr: introduce idr_for_each_entry_continue_ul()") and you
> are correctly bringing it back. Adding Cong to advise if it is okay to
> wait for this patch to be accepted or we need to proceed with fixing the
> missing RCU lock as a standalone patch.

Hmm? Isn't ->walk() still called with RTNL lock? tcf_chain_dump()
calls __tcf_get_next_proto() which asserts RTNL.

So why does it still need RCU read lock when having RTNL?
