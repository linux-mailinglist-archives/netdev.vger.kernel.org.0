Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE14800BB
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 21:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391984AbfHBTO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 15:14:57 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:38051 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfHBTO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 15:14:57 -0400
Received: by mail-ot1-f65.google.com with SMTP id d17so79263503oth.5
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 12:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=snjsQoK9qQrtuVFdIq7bwQHzffOHdQm1tW8UX0mjAlg=;
        b=syxuhksqtUNnfC7lc7G2YJcnEKtTMjV240l4HscIomm0oyH0fedD+oMBPyP9zC7ASA
         +yNzQ65opeQSArkEyUm5nzVKe3+KIlelVzdoEINn05L5dnXn+riQ62AUuPaLZOfFCdx8
         8zNfKNIuxKpnlynAPA3mwDke5b3eb6D/LmLt41WH6zzM7Pz7iRSrkBPKDdyg+ZwYcsEz
         jkd6MCWlnGVUaC4Qz7f8Mf9sd2ftTY0EyE/PQBFGoK3WsCKcQqk6UZIeW8oqppGDQx6h
         I2CKFBuUJ6gHeveB8WYmkztRg2kDqXT59he9aX3bHbZdGqsiwBuIEhsnLGl51FbH+lGe
         uEcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=snjsQoK9qQrtuVFdIq7bwQHzffOHdQm1tW8UX0mjAlg=;
        b=A92+yoMHUK4qMc8f+mfOp4ig0lDiuXtYsWCo9g60jKgfZ1agfp1KPV7+I4pN2cp9GE
         lj3+jQoy+gGlqdfu3v4KaecjTKmsy6S2lhpDz9dPuqDcdcKJeC79Oj2KwT4y7QtyL2mU
         qsdZY3ig83VevNpotGq9k2mjYgg1MrYGZE6dvwAaaRk7rgnhoxZxLn0fTipsHpdhgWaH
         HGHZfPRCuEj0IFluc04fueZZO3VYkOM0AWgAZ3h2i63K54Z6hYf4PUaC5I+kUYTfuGi4
         rw8urZfB+t023t3CcNDdFt+TrJj7NUpHTHJTV795UjjrE0pfR0mejd3bg2bH7K9SGISu
         +u+A==
X-Gm-Message-State: APjAAAWITx7BxwTTpSBpZAkvNwi6fWE8QNwkJS912Xa85qsttitYQNET
        1qPLt1jqtQ3DufE+QxeKRg5UHV/+oImrZ0SnknRoSg==
X-Google-Smtp-Source: APXvYqxEhvLJuoH//ZrGeva5RMXgEDIVtUagAJBqB+LkMXw8o+9uwzL1HtitCwRklqUc5RZXj9wPxg3iE8Q/vPIeNAs=
X-Received: by 2002:a9d:5cc1:: with SMTP id r1mr16268740oti.341.1564773295759;
 Fri, 02 Aug 2019 12:14:55 -0700 (PDT)
MIME-Version: 1.0
References: <CABOR3+yUiu1BzCojFQFADUKc5BT2-Ew_j7KFNpjP8WoMYZ+SMA@mail.gmail.com>
In-Reply-To: <CABOR3+yUiu1BzCojFQFADUKc5BT2-Ew_j7KFNpjP8WoMYZ+SMA@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 2 Aug 2019 15:14:38 -0400
Message-ID: <CADVnQy=dvmksVaDu61+w-qtv2g_iNbWPFgbSJDtx9QaasmHonw@mail.gmail.com>
Subject: Re: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory limits
To:     Bernd <ecki@zusammenkunft.net>
Cc:     netdev <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 2, 2019 at 3:03 PM Bernd <ecki@zusammenkunft.net> wrote:
>
> Hello,
>
> While analyzing a aborted upload packet capture I came across a odd
> trace where a sender was not responding to a duplicate SACK but
> sending further segments until it stalled.
>
> Took me some time until I remembered this fix, and actually the
> problems started since the security fix was applied.
>
> I see a high counter for TCPWqueueTooBig - and I don=E2=80=99t think that=
=E2=80=99s an
> actual attack.
>
> Is there a probability for triggering the limit with connections with
> big windows and large send buffers and dropped segments? If so what
> would be the plan? It does not look like it is configurable. The trace
> seem to have 100 (filled) inflight segments.
>
> Gruss
> Bernd
> --
> http://bernd.eckenfels.net

What's the exact kernel version you are using?

Eric submitted a patch recently that may address your issue:
   tcp: be more careful in tcp_fragment()
  https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=
=3Db617158dc096709d8600c53b6052144d12b89fab

Would you be able to test your workload with that commit
cherry-picked, and see if the issue still occurs?

That commit was targeted to many stable releases, so you may be able
to pick up that fix from a stable branch.

cheers,
neal
