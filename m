Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 639DF163539
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 22:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgBRVkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 16:40:42 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:44567 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgBRVkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 16:40:42 -0500
Received: by mail-ot1-f67.google.com with SMTP id h9so21016972otj.11;
        Tue, 18 Feb 2020 13:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=absML5Rt6ZupsC+GvFjujXUs8xFi6ZxOgzvL0Pb76xo=;
        b=cFRQdCDeYyV7eVqFyveH1nO4INItX7gc13AjeWHU9UD3ekV35B9QJG9JCDsIg/90ff
         KbaARgRVkrdQgc6/HjX5C0y/99Qyd30y+sGd4EmzZAkEkQD/UgHjuSZJrAipz2UpoJeQ
         lhvF57BxFL17R9VaSbyulo5oAiQUAZJGZPpuu1mpN4GPBzNhmYFz6BhTauiHfPgwv3jL
         I6Y4LhXDeXmsLKIy0vmtfIvNSvEY2Zo8dXQyQ5mbn22Nk2y6qEFg4iIpdKKN7d0Y0PUU
         ZmlRmOA/8UhVz2wavPCpzagg2OyucHpW7gBmtbRQd6mlxRVU4p9wiHX9gwN0Lo2thFZJ
         0uVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=absML5Rt6ZupsC+GvFjujXUs8xFi6ZxOgzvL0Pb76xo=;
        b=K6CjHQhKflSp2COfeQGwOLFqCr+iqvhzZK0GEV77xDgmJEd3+frMDIGy4PbuIrS/VX
         komeGqlUGXUZgNSsx2hrF11VBHAcjI/FVaJlDVPMJHUAv5OUF3Ku8K2m3bfXrq1O6aav
         a6q/GgX4nKTKvdUcfaVAaH7q81EHiGMmxMoosCW47rr4A2+Q1jxW9nonbpwA3EpogchY
         xReaouLwP+mjxIrWGgs+VVjDMRj4ozMnFU35np0OmMjyOPjGyBQhw9gcB1FcQp1i1r27
         u0S8DkdtssW5Xcj7X8ZNSYphd4yYl2W+3UDmo4Do1vw2Xwz06gRxtAV00r1nF4YRVjPG
         dRSw==
X-Gm-Message-State: APjAAAVk0hQg6pomzMe1ucEIDZwk1G/ga0vUce6gOU6GdZRc4uQ5pWmN
        T9lyqpP6kt6gvAqSdPTHZa8HeyJvSJcyjB91Du/q/jWd
X-Google-Smtp-Source: APXvYqxU1slM4rCdozwMFpWT3Xlqu/h77XTf3eV4aFXRt+TkAcnIjw5mtD/NHG/6n+5827ucNXmkiQGYdNYoxzV/jyk=
X-Received: by 2002:a9d:20a:: with SMTP id 10mr16704954otb.319.1582062040428;
 Tue, 18 Feb 2020 13:40:40 -0800 (PST)
MIME-Version: 1.0
References: <20200213065352.6310-1-xiyou.wangcong@gmail.com> <20200218213524.5yuccwnl2eie6p6x@salvia>
In-Reply-To: <20200218213524.5yuccwnl2eie6p6x@salvia>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 18 Feb 2020 13:40:26 -0800
Message-ID: <CAM_iQpWfb7xgd2LuRmaXhRSJskJPsupFk0A7=dRXtMEjZJjr3w@mail.gmail.com>
Subject: Re: [Patch nf] netfilter: xt_hashlimit: unregister proc file before
 releasing mutex
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        syzbot <syzbot+d195fd3b9a364ddd6731@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 1:35 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Wed, Feb 12, 2020 at 10:53:52PM -0800, Cong Wang wrote:
> > Before releasing the global mutex, we only unlink the hashtable
> > from the hash list, its proc file is still not unregistered at
> > this point. So syzbot could trigger a race condition where a
> > parallel htable_create() could register the same file immediately
> > after the mutex is released.
> >
> > Move htable_remove_proc_entry() back to mutex protection to
> > fix this. And, fold htable_destroy() into htable_put() to make
> > the code slightly easier to understand.
>
> Probably revert previous one?

The hung task could appear again if we move the cleanup
back under mutex.
