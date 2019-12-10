Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11CDC118D66
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 17:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbfLJQT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 11:19:56 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36189 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727178AbfLJQTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 11:19:55 -0500
Received: by mail-lj1-f193.google.com with SMTP id r19so20615436ljg.3;
        Tue, 10 Dec 2019 08:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2UJwpPxTmgJirV0HhLgIu9KxcelTqVACRWkbnPRqdXw=;
        b=SHyfEii4cHYSpUUUf8yHgzMwTkoUmpA+2DbH0p2WIsE8et/f+zzQrzHfz7/kIImePS
         muYCDokc00ROSePRJEg69xJ/WJpyYeSNnj4kwt2BHfTJu/rkYeHRYcpIcb1RoFjr1Tps
         I2hVlc9ILas3UF3kW6kwcAyo58I8pp5fkSMMax04kmi34WuSgA8kMMRLJsnzkEUx3k5i
         8HWj2VLOr/Jmouxd1J8fLv/ADypej0rMSBLksbfUDXB6tKzMzGL7H0mA5/N589L5e6/0
         4DxaOeRNi3W1PhgPUOIBNGx3KohJEbX7b3F6i216X59xTexGp0EmGeYVQByljOHOW+zb
         rA7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2UJwpPxTmgJirV0HhLgIu9KxcelTqVACRWkbnPRqdXw=;
        b=MNi++PUZvhi3FKd8Z2amx/msgDAEZdceaLH/Sp63sO/BUKaXSKsN3anPabMQc8dLUb
         00kTyXVX6/lYZb831o0yU33vbcW/Sq+yN3/pKr0xnT/IL0dLItdkX4u8VClt5xDTcbzD
         1uYsQbnW859VYZNCWLb972b0/7NGJn9fzOHGv7gfhORChs0i9tHW/DtW8NLOOQK7TKC6
         95BxhduyK+DSJZaV+mNg631oEHvMP8FstyFg/YuYn0igRCySP/MB9VpDIPl4yBhw7Tmd
         P07frWKiMWgKl6R8xVo4WXiIblXY+Z9ibJsZ9/CTn5WQJyLSG2X+nmfBLYlnD5S/dr17
         /eGQ==
X-Gm-Message-State: APjAAAXEfmBTS29k8nSzhjrGOTXJdjzuEwB7sCzZuVZbQJZz684Acfoq
        nWr9Zrah00pZWdrbHr86//Xmqlh3O2lUA32AeMk=
X-Google-Smtp-Source: APXvYqyDojG+mrwcWES+IUhtdDFtMIf9/7ssfii7yxG/bQF2QYcR98TRnHnYAGTQMn8ahHCSYSxsxa0KnE6wNcfoLWg=
X-Received: by 2002:a2e:99cd:: with SMTP id l13mr6947971ljj.243.1575994793358;
 Tue, 10 Dec 2019 08:19:53 -0800 (PST)
MIME-Version: 1.0
References: <20191209000114.1876138-1-ast@kernel.org> <20191209000114.1876138-2-ast@kernel.org>
In-Reply-To: <20191209000114.1876138-2-ast@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 10 Dec 2019 08:19:42 -0800
Message-ID: <CAADnVQJVabzj-aytRnZrFCwRJAf+g_wZ-zWiO7D0bUm7UVpDQw@mail.gmail.com>
Subject: Re: [PATCH bpf 1/3] ftrace: Fix function_graph tracer interaction
 with BPF trampoline
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Steven Rostedt <rostedt@goodmis.org>, X86 ML <x86@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 8, 2019 at 4:03 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Depending on type of BPF programs served by BPF trampoline it can call original
> function. In such case the trampoline will skip one stack frame while
> returning. That will confuse function_graph tracer and will cause crashes with
> bad RIP. Teach graph tracer to skip functions that have BPF trampoline attached.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Steven, please take a look.
