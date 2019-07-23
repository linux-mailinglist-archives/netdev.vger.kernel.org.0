Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E893472162
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 23:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389123AbfGWVPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 17:15:50 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34469 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbfGWVPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 17:15:49 -0400
Received: by mail-lj1-f195.google.com with SMTP id p17so42441210ljg.1;
        Tue, 23 Jul 2019 14:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hhyvluOoTz6hgw5ip4v2KxMbz6NbJ07oc61JlnqjEM8=;
        b=ag+X+s84YWEie1fceAUy2++meeB+kSxP0+mhhMtmwXyYSptozBvB6gKWmx4eKUO0An
         N4j7zQ12U8Xl3itWlVj867Ter9FEgfhO7Uyg7EwwbrLx3zzC3GdooxdHYxfW7zUe+E9A
         99E4bvB6/1R9cPHsWKfNYkan8P829LuRkhe/tqg6e5cEl0/RAksoB8IjtY9pKPiUQo3k
         gBu/U1Sx6emat87lHT18hk8hv1nx05EGwiZoyk+dkSIO9/rOVzstO7gEw80bcEYuIt8m
         if5LeGMkiMdMrO+I5scU3Ld4NUMjcIRvzvnxDnUhmA11ZBXRWZfEEehs5TE4h4Cy/ige
         aYig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hhyvluOoTz6hgw5ip4v2KxMbz6NbJ07oc61JlnqjEM8=;
        b=hhTYuSPyoCj1HcDJuP99jSLvtVoC3pdEGFZZqcLQ6YJAIvm7XG1dNEeVSCdrjH/qX6
         hEwYKRx5t7BH/NlbZ7SVQMISOuT5xpi1hBT9AJZSmfZxfTTQ+2jBA/A/kh6h/8dWNbiT
         rrAA9W4vcApEDDhyX9P8lTpg4E7642D8FGMxA8MSGIqRpqhyMbpkvX87zkU5sPxlGMAb
         xFoL5W6SCR2oF7+6rV4MqqmONfWbdXYc5Q51V22DfZ2Lpl0w0AEfLBpO/zodwUIGegM0
         l3y5B6P4n9yXMLwrQJ09OLFlIDnwtfotmTtKvBspc61Oos3I43xUFbaT0Af+BRQDn9Az
         SPYw==
X-Gm-Message-State: APjAAAVx0Mcedv0ri6WiCjXaH3rxb4wHxz/o58g0os0MFgqBlIjL36At
        SYRrP0t5DBs3KJEOwlf+CHJLpUG5EL6/ZEDNY6U=
X-Google-Smtp-Source: APXvYqxetMwDuTg7iLYPc0l3vXIDU8F3o18xFNIxn45uS1oWNqEZCabVnUBOS14oqsHptNk5Yh/PX5IUXbwp/dYakF4=
X-Received: by 2002:a2e:7818:: with SMTP id t24mr13714260ljc.210.1563916547604;
 Tue, 23 Jul 2019 14:15:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190723101538.136328-1-edumazet@google.com>
In-Reply-To: <20190723101538.136328-1-edumazet@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 23 Jul 2019 14:15:36 -0700
Message-ID: <CAADnVQLZoTTcD11V69snu6=SHgLUW97tenHrcCa2w_3gmw=29Q@mail.gmail.com>
Subject: Re: [PATCH bpf 0/2] bpf: gso_segs fixes
To:     Eric Dumazet <edumazet@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stanislav Fomichev <sdf@google.com>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 3:15 AM Eric Dumazet <edumazet@google.com> wrote:
>
> First patch changes the kernel, second patch
> adds a new test.
>
> Note that other patches might be needed to take
> care of similar issues in sock_ops_convert_ctx_access()
> and SOCK_OPS_GET_FIELD()

Nice catch!
Applied to bpf tree. Thanks
