Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2501A640
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 03:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbfEKBwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 21:52:43 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44315 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728079AbfEKBwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 21:52:43 -0400
Received: by mail-lj1-f195.google.com with SMTP id e13so6541553ljl.11;
        Fri, 10 May 2019 18:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QZgSkVUHKowxOY3ttbiTuekIEG1VZzpVE0s+32U3kMs=;
        b=RdLSqvSNLixaZCRt8jp5GwmQFLx01KUk3em7GcvaZsGmqpELm3fzyIJlhvqVzP9Oo+
         ipWCGNRM62GurFBCQEArsXGIYBH1+njkV8w0K4q/oA7B75FtR0bWBtIKCsRtX84d5aw/
         dkBzoNBqqPcIa7vvxyuMwGSwzfT22f5LgDielu7Hn/Y/eO6ztaijT7HYurmoMaelh6PN
         tCysyZl059BGO5v2B0SYE04kUaCZv8eSM+g7Yyw+NmNAeKoGc6zaIcGChhlLA39zzcNF
         T287l9rdC8u4p1TssM++2X3DmzsPdWZHXQSifjxyNFDyN5ZJK9HUAWfW/mFISmVhSWQS
         VHFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QZgSkVUHKowxOY3ttbiTuekIEG1VZzpVE0s+32U3kMs=;
        b=UBWBVN5tOHVfe549EVYQODbrK++PwMZQ6XwTjHk+ecvkXN/iOXx6aCHdxQb5mmx60o
         c8UFUPlT8NnP87tDQVJnoQcKmcdifPp9RwDzEvjxyyn3WHaBTE5rPGSCk3m/ls48tcgC
         39c3a6njeHcV/0Qd4JvGI3u2/rSq/SzXRSUdc7gbZHBfPAqDnQRgmrgx0azg2whoxYhZ
         kHjZBE9wT9WsvSlspfnog0whz1eemVPkf7a3BXOvvBgngLJ14c2Gbk6jwQOHzxJh7Lbl
         ioYja8qKBpgoldd6E55MvFJq8WUSMhaBf0+cWxi/eJLJUQ3pWn2tnxoIEyeIHySof0c0
         FaoQ==
X-Gm-Message-State: APjAAAUWh4F78S14J4LHdBtXqkLVNs6DCLUk+eyTzYPfQq3ogmltHuNT
        zeL+pY1kPlJlFM+NTxCrco6JahhW/nhsrXfpb/nfCg==
X-Google-Smtp-Source: APXvYqzCLdeFzy8JSy8d5kLuiGsYjvb2Oq/z3hRPqIcbDSrmlR1VkNtTa1ZWHrnqf0zjoRRRgdupj/hUrVDHvFFaOjA=
X-Received: by 2002:a2e:6c02:: with SMTP id h2mr7460928ljc.103.1557539560832;
 Fri, 10 May 2019 18:52:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190511010310.17323-1-daniel@iogearbox.net>
In-Reply-To: <20190511010310.17323-1-daniel@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 10 May 2019 18:52:27 -0700
Message-ID: <CAADnVQLanwjQOp5QBEQCB-AWP6Q3ZEjk+EOJ4CF1HLBc1dwSpA@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf: fix out of bounds backwards jmps due to dead
 code removal
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 10, 2019 at 6:03 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> systemtap folks reported the following splat recently:
...
> Note that unprivileged case is not affected from this.
>
> Fixes: 52875a04f4b2 ("bpf: verifier: remove dead code")
> Fixes: 2cbd95a5c4fb ("bpf: change parameters of call/branch offset adjustment")
> Reported-by: Frank Ch. Eigler <fche@redhat.com>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied. Thanks!
