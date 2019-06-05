Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 376F93560F
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 06:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFEE6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 00:58:33 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33162 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfFEE6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 00:58:33 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so864835wmh.0
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 21:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tvZ0sXc7T+PfuYrXldyLNvmzWS0RxOt+TFpjmhqi7iY=;
        b=Ce6uT+rSj9byp1iphLj+PvFUcXE4c9IZ7n90+TpSWkTGiqj3QikS46XQC9HwI30Rqh
         F2h91arNPZRohyYSAqfvwPHzcF0d5vND/ceOpMxI8Lfyan8vc9iTeofYdKHfhI9PfXxD
         rpWfXOJvYsQT+0SyWsgOa8Py3dgrhURPw2WVPNlJkawAilI04eR2Fc2XzixPezt979TR
         xERAFSwPiI/VY4phslX8F98I6yHsc4LW/vUhT5Nyx28dHSRyCEk38q/xz/YWkDEjCuwO
         qSw6dptsShDauZN97+Pk+vtmaAMYb4Gm9b852omnpSRqOuTqjcMVr/81TrsAWZ2gpXYf
         Iqow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tvZ0sXc7T+PfuYrXldyLNvmzWS0RxOt+TFpjmhqi7iY=;
        b=jihxVrhF3X9Jq5Ze+PcglizlaxtSxk5HgpQ9nfeJn2jD0NmKQjqbgVhw5Bn5AwbMo6
         BIVTAJhDuPxWFRHK1hZi2V64dT7R7k8hTIoX12fwKkWL5gSiabKqglLUaiGb/SkGkTh6
         VULb5+87uTSYYKtVW4hm7UfrBrnwekpejhAxCS9CxKmalAc3fV91MpZcxU0wevODq+Io
         ByFsPfjNxco8p6hKSjWpCcLp45x04iJ2us+gO1LIojXiV7UWCe77CTsJerr7eMvRjs5i
         kI6OAxAmTRqzj+d1kP0aJk8Xue2k7wDKRaO6fDenJwJdN4jvSCf3z+/clq1pVJtk2gh4
         MFHA==
X-Gm-Message-State: APjAAAXy3VgtDo0+3X5j/cCDGnxgrQw81Uz0vpiE8EynWspZoA2Hxx4F
        OaBGyMNrs0bk+KVXzmsldPek7jHhVZhKJ0ul9fwDAQ==
X-Google-Smtp-Source: APXvYqw9RLrse0P7VjccV/LhirPa6MoDx3BCgDbjB0A9EMgsAq5O+rPAKND21GC8a5C7yEX4Wfsxb7BCrAB/0lcPSL8=
X-Received: by 2002:a05:600c:23d2:: with SMTP id p18mr10838383wmb.108.1559710710540;
 Tue, 04 Jun 2019 21:58:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190507091118.24324-1-liuhangbin@gmail.com> <20190508.093541.1274244477886053907.davem@davemloft.net>
 <CAHo-OozeC3o9avh5kgKpXq1koRH0fVtNRaM9mb=vduYRNX0T7g@mail.gmail.com>
 <20190605014344.GY18865@dhcp-12-139.nay.redhat.com> <eef3b598-2590-5c62-e79d-76eb46fae5ff@cumulusnetworks.com>
In-Reply-To: <eef3b598-2590-5c62-e79d-76eb46fae5ff@cumulusnetworks.com>
From:   Lorenzo Colitti <lorenzo@google.com>
Date:   Wed, 5 Jun 2019 13:58:18 +0900
Message-ID: <CAKD1Yr30Wj+Kk-ao2tFLU5apNjAVNYKeYJ+jZsb=5HTtd3+5-Q@mail.gmail.com>
Subject: Re: [PATCH net] fib_rules: return 0 directly if an exactly same rule
 exists when NLM_F_EXCL not supplied
To:     David Ahern <dsa@cumulusnetworks.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>,
        Yaro Slav <yaro330@gmail.com>,
        Thomas Haller <thaller@redhat.com>,
        Alistair Strachan <astrachan@google.com>,
        Greg KH <greg@kroah.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        Mateusz Bajorski <mateusz.bajorski@nokia.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 5, 2019 at 12:58 PM David Ahern <dsa@cumulusnetworks.com> wrote:
> I think it is crazy to add multiple identical rules given the linear
> effect on performance.

Not sure if this is what you were implying or not, but our code
doesn't maintain multiple identical rules in steady state. It only
uses them for make-before-break when something changes.

> But, since it breaks Android, it has to be reverted.

Well... the immediate problem on Android is that we cannot live with
this going to LTS, since it is going to break devices in the field.

As for making this change in 5.3: we might be able to structure the
code differently in a future Android release, assuming the same
userspace code can work on kernels back to 4.4 (not sure it can, since
the semantics changed in 4.8). But even if we can fix this in Android,
this change is still breaking compatibility with existing other
userspace code. Are there concrete performance optimizations that
you'd like to make that can't be made unless you change the semantics
here? Are those optimizations worth breaking the backwards
compatibility guarantees for?
