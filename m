Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3CA28FB46
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 00:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731895AbgJOWh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 18:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731394AbgJOWh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 18:37:56 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6298DC061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 15:37:55 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id u74so370126vsc.2
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 15:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9S2JLAqGZsH4z/tGSHbw7geQ9XQmkwSlZEfCbkTojUo=;
        b=EBWSxJ+0QIrEOjHtInqjqieA70u/BbSMEMkC27yslFsheBlsxUCLCtcL1Q+oJ+kM+t
         30bhZ2u5YpA3EaZbfqkrvlKz/8mKbUVrGitSicsOcZhTbozVZ3tseUSFQwimvm7yFxjL
         IdGLVvILuJNqsx6LcShe5dCXlbyw9OWbhfYif94UJz+CYpBk6TPVDklQkNkD5dlivp6b
         8zVw5MklIRJVwFglPO9Skjo/Q8Q0bPKx1LoRDJDfEDII2fauKbSkC0xFM0fYz8dOk8f3
         Q6GrGJprGm2qGiyjBkoR7WU3pc1ZrHydjq+eVWTcHruU0KrUJ82qBRfjcScnlCFD0GPg
         at1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9S2JLAqGZsH4z/tGSHbw7geQ9XQmkwSlZEfCbkTojUo=;
        b=lYflFuKjK61y4pE8lKTtJTQQ2Hh4AFQ6G4W4odnGDwTtYcGoCHdjIoyhvWJv6BaFhh
         gf91k476+G3ay+wQxJD19FIpsuxbUpjOGe4Aj9JZNDZmmQqT4kQHJGBOFH8cB/YhbT/M
         eeXk3Y9wQkHLI8gc4nhV4mBNvSw1tEr/9dVqy2Qdd59cokojKRbjU69l/rKtCLxDl4hA
         6U44ab5vgAV5LzUxwat+AuxKalF2bG0tv2Dc6u9SlS1SRZkGgcYau2InS1ucsfvOGNK2
         YC8AN0UngeAZMlWMxd+sIXEADrljW7wsFMObHe4kAWeyskm6smB2v65tKRNO0cRuAvgQ
         VWTA==
X-Gm-Message-State: AOAM532COy0xhLHLAjQ7Ju6pfGuef7T2yufUxsYjFMvlyVAa/76R8RrA
        JB/GegNwbPlfQ7/dL8kLmoLvcbpMyAbofK/9pPNKGA==
X-Google-Smtp-Source: ABdhPJwXFvyDLF0j/cP5ghD/fErjt+cZvHb864mC3+5Nj5tc0wJcYO818UzKDquOaC0aPACADsyovTD/wQaV9HgYgEo=
X-Received: by 2002:a67:ffc1:: with SMTP id w1mr418337vsq.52.1602801474350;
 Thu, 15 Oct 2020 15:37:54 -0700 (PDT)
MIME-Version: 1.0
References: <87eelz4abk.fsf@marvin.dmesg.gr> <CADVnQym6OPVRcJ6PdR3hjN5Krcn0pugshdLZsrnzNQe1c52HXA@mail.gmail.com>
 <CAK6E8=fCwjP47DvSj4YQQ6xn25bVBN_1mFtrBwOJPYU6jXVcgQ@mail.gmail.com> <87blh33zr7.fsf@marvin.dmesg.gr>
In-Reply-To: <87blh33zr7.fsf@marvin.dmesg.gr>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 15 Oct 2020 18:37:37 -0400
Message-ID: <CADVnQym2cJGRP8JnRAdzHfWEeEbZrmXd3eXD-nFP6pRNK7beWw@mail.gmail.com>
Subject: Re: TCP sender stuck in persist despite peer advertising non-zero window
To:     Apollon Oikonomopoulos <apoikos@dmesg.gr>
Cc:     Yuchung Cheng <ycheng@google.com>, Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: multipart/mixed; boundary="0000000000008702dd05b1bd4c0e"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000008702dd05b1bd4c0e
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 15, 2020 at 6:12 PM Apollon Oikonomopoulos <apoikos@dmesg.gr> wrote:
>
> Yuchung Cheng <ycheng@google.com> writes:
>
> > On Thu, Oct 15, 2020 at 1:22 PM Neal Cardwell <ncardwell@google.com> wrote:
> >>
> >> On Thu, Oct 15, 2020 at 2:31 PM Apollon Oikonomopoulos <apoikos@dmesg.gr> wrote:
> >> >
> >> > Hi,
> >> >
> >> > I'm trying to debug a (possible) TCP issue we have been encountering
> >> > sporadically during the past couple of years. Currently we're running
> >> > 4.9.144, but we've been observing this since at least 3.16.
> >> >
> >> > Tl;DR: I believe we are seeing a case where snd_wl1 fails to be properly
> >> > updated, leading to inability to recover from a TCP persist state and
> >> > would appreciate some help debugging this.
> >>
> >> Thanks for the detailed report and diagnosis. I think we may need a
> >> fix something like the following patch below.
>
> That was fast, thank you!
>
> >>
> >> Eric/Yuchung/Soheil, what do you think?
> > wow hard to believe how old this bug can be. The patch looks good but
> > can Apollon verify this patch fix the issue?
>
> Sure, I can give it a try and let the systems do their thing for a couple of
> days, which should be enough to see if it's fixed.

Great, thanks!

> Neal, would it be possible to re-send the patch as an attachment? The
> inlined version does not apply cleanly due to linewrapping and
> whitespace changes and, although I can re-type it, I would prefer to test
> the exact same thing that would be merged.

Sure, I have attached the "git format-patch" format of the commit. It
does seem to apply cleanly to the v4.9.144 kernel you mentioned you
are using.

Thanks for testing this!

best,
neal

--0000000000008702dd05b1bd4c0e
Content-Type: application/x-patch; 
	name="0001-tcp-fix-to-update-snd_wl1-in-bulk-receiver-fast-path.patch"
Content-Disposition: attachment; 
	filename="0001-tcp-fix-to-update-snd_wl1-in-bulk-receiver-fast-path.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kgbe8cb10>
X-Attachment-Id: f_kgbe8cb10

RnJvbSA0MmIzN2M3MmFhNzNhYWFiZDBjMDFiOGMwNWMyMjA1MjM2Mjc5MDIxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOZWFsIENhcmR3ZWxsIDxuY2FyZHdlbGxAZ29vZ2xlLmNvbT4K
RGF0ZTogVGh1LCAxNSBPY3QgMjAyMCAxNjowNjoxMSAtMDQwMApTdWJqZWN0OiBbUEFUQ0hdIHRj
cDogZml4IHRvIHVwZGF0ZSBzbmRfd2wxIGluIGJ1bGsgcmVjZWl2ZXIgZmFzdCBwYXRoCgpJbiB0
aGUgaGVhZGVyIHByZWRpY3Rpb24gZmFzdCBwYXRoIGZvciBhIGJ1bGsgZGF0YSByZWNlaXZlciwg
aWYgbm8KZGF0YSBpcyBuZXdseSBhY2tub3dsZWRnZWQgdGhlbiB3ZSBkbyBub3QgY2FsbCB0Y3Bf
YWNrKCkgYW5kIGRvIG5vdApjYWxsIHRjcF9hY2tfdXBkYXRlX3dpbmRvdygpLiBUaGlzIG1lYW5z
IHRoYXQgYSBidWxrIHJlY2VpdmVyIHRoYXQKcmVjZWl2ZXMgbGFyZ2UgYW1vdW50cyBvZiBkYXRh
IGNhbiBoYXZlIHRoZSBpbmNvbWluZyBzZXF1ZW5jZSBudW1iZXJzCndyYXAsIHNvIHRoYXQgdGhl
IGNoZWNrIGluIHRjcF9tYXlfdXBkYXRlX3dpbmRvdyBmYWlsczoKICAgYWZ0ZXIoYWNrX3NlcSwg
dHAtPnNuZF93bDEpCgpUaGUgZml4IGlzIHRvIHVwZGF0ZSBzbmRfd2wxIGluIHRoZSBoZWFkZXIg
cHJlZGljdGlvbiBmYXN0IHBhdGggZm9yIGEKYnVsayBkYXRhIHJlY2VpdmVyLCBzbyB0aGF0IGl0
IGtlZXBzIHVwIGFuZCBkb2VzIG5vdCBzZWUgd3JhcHBpbmcKcHJvYmxlbXMuCgpTaWduZWQtb2Zm
LWJ5OiBOZWFsIENhcmR3ZWxsIDxuY2FyZHdlbGxAZ29vZ2xlLmNvbT4KUmVwb3J0ZWQtQnk6IEFw
b2xsb24gT2lrb25vbW9wb3Vsb3MgPGFwb2lrb3NAZG1lc2cuZ3I+Ci0tLQogbmV0L2lwdjQvdGNw
X2lucHV0LmMgfCAyICsrCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspCgpkaWZmIC0t
Z2l0IGEvbmV0L2lwdjQvdGNwX2lucHV0LmMgYi9uZXQvaXB2NC90Y3BfaW5wdXQuYwppbmRleCBi
MWNlMjA1NDI5MWQuLjc1YmU5N2Y2YTdkYSAxMDA2NDQKLS0tIGEvbmV0L2lwdjQvdGNwX2lucHV0
LmMKKysrIGIvbmV0L2lwdjQvdGNwX2lucHV0LmMKQEAgLTU3NjYsNiArNTc2Niw4IEBAIHZvaWQg
dGNwX3Jjdl9lc3RhYmxpc2hlZChzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBza19idWZmICpza2Ip
CiAJCQkJdGNwX2RhdGFfc25kX2NoZWNrKHNrKTsKIAkJCQlpZiAoIWluZXRfY3NrX2Fja19zY2hl
ZHVsZWQoc2spKQogCQkJCQlnb3RvIG5vX2FjazsKKwkJCX0gZWxzZSB7CisJCQkJdGNwX3VwZGF0
ZV93bCh0cCwgVENQX1NLQl9DQihza2IpLT5zZXEpOwogCQkJfQogCiAJCQlfX3RjcF9hY2tfc25k
X2NoZWNrKHNrLCAwKTsKLS0gCjIuMjkuMC5yYzEuMjk3LmdmYTk3NDNlNTAxLWdvb2cKCg==
--0000000000008702dd05b1bd4c0e--
