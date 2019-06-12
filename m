Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92EF942D94
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 19:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408506AbfFLRdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 13:33:07 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:47054 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407844AbfFLRdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 13:33:07 -0400
Received: by mail-lf1-f66.google.com with SMTP id z15so10132570lfh.13
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 10:33:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZDaptEHLSaWv0/yscgWZ7Z0Qpkpt3zya2Vb1Aqws+7k=;
        b=RPOmX3LYuDSoHYLUuPQQTXy4M2vbBdH+NUbOU9CFXCQFv1wFWuq7pqKINnaMQuSbts
         qGJ+MNne5an7UQQEqoHlZO/h+kB/Kj+U5xczS2xTACbIhXyC7HoS+ouWj7VeJOxWsRND
         cJQDKh3I152KQ548tdW7Y3yw6I+mbUhJfecMl9v0+9awmQMmkVVUiMPM6e8Mwy+ZmPot
         ZklbPg1qm2G3Tez1QezXdD/argVq0bWXGGwHcmFXCSPpMV6zgi8m4Qvv5a1pPFZC9ecB
         gnMILjYwnyHajZBOAVf3Szi01waRSXm0l0JL7Y2BU9lIbPXOTleERAWkMFNIjZX7Qxhw
         vPkw==
X-Gm-Message-State: APjAAAXRLnXvjAvfFRrq7hgy4j5efe8i2KKz6+t0EIPRJcgM4hQ2/1mA
        wHyoa7lI3CCpa90k+E2idiq0KKLPmmvx+vbh3dLCfCAHD34=
X-Google-Smtp-Source: APXvYqywOfOkCJOltaKObzYfHeW9YjQNvLyBpbdZfv12RhvZ/3nJq7xJys2GcOQRH9NgmkOQ83BXid1tgQIz96q58A8=
X-Received: by 2002:a19:ed07:: with SMTP id y7mr44341815lfy.56.1560360785426;
 Wed, 12 Jun 2019 10:33:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190611180326.30597-1-mcroce@redhat.com> <20190612085307.35e42bf4@hermes.lan>
 <CAGnkfhyT0W=CYU8FJYrDtzqxtcHakO5CWx2qzLuWOXVj6dyKMA@mail.gmail.com>
In-Reply-To: <CAGnkfhyT0W=CYU8FJYrDtzqxtcHakO5CWx2qzLuWOXVj6dyKMA@mail.gmail.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Wed, 12 Jun 2019 19:32:29 +0200
Message-ID: <CAGnkfhz-W64f-j+Sgbi47BO6VKfyaYQ1W865sihXhCjChh_kFQ@mail.gmail.com>
Subject: Re: [PATCH iproute2] testsuite: don't clobber /tmp
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 6:04 PM Matteo Croce <mcroce@redhat.com> wrote:
>
> On Wed, Jun 12, 2019 at 5:55 PM Stephen Hemminger
> <stephen@networkplumber.org> wrote:
> >
> > On Tue, 11 Jun 2019 20:03:26 +0200
> > Matteo Croce <mcroce@redhat.com> wrote:
> >
> > > Even if not running the testsuite, every build will leave
> > > a stale tc_testkenv.* file in the system temp directory.
> > > Conditionally create the temp file only if we're running the testsuite.
> > >
> > > Signed-off-by: Matteo Croce <mcroce@redhat.com>
> > > ---
> > >  testsuite/Makefile | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/testsuite/Makefile b/testsuite/Makefile
> > > index 7f247bbc..5353244b 100644
> > > --- a/testsuite/Makefile
> > > +++ b/testsuite/Makefile
> > > @@ -14,7 +14,9 @@ TESTS_DIR := $(dir $(TESTS))
> > >
> > >  IPVERS := $(filter-out iproute2/Makefile,$(wildcard iproute2/*))
> > >
> > > -KENVFN := $(shell mktemp /tmp/tc_testkenv.XXXXXX)
> > > +ifeq ($(MAKECMDGOALS),alltests)
> > > +     KENVFN := $(shell mktemp /tmp/tc_testkenv.XXXXXX)
> > > +endif
> > >  ifneq (,$(wildcard /proc/config.gz))
> > >       KCPATH := /proc/config.gz
> > >  else
> > > @@ -94,3 +96,4 @@ endif
> > >               rm "$$TMP_ERR" "$$TMP_OUT"; \
> > >               sudo dmesg > $(RESULTS_DIR)/$@.$$o.dmesg; \
> > >       done
> > > +     @$(RM) $(KENVFN)
> >
> > My concern is that there are several targets in this one Makefile.
> >
> > Why not use -u which gives name but does not create the file?
>
> As the manpage says, this is unsafe, as a file with the same name can
> be created in the meantime.
> Another option is to run the mktemp in the target shell, but this will
> require to escape every single end of line to make it a single shell
> command, e.g.:
>
>         KENVFN=$$(mktemp /tmp/tc_testkenv.XXXXXX); \
>         if [ "$(KCPATH)" = "/proc/config.gz" ]; then \
>                 gunzip -c $(KCPATH) >$$KENVFN; \
>         ...
>         done ; \
>         $(RM) $$KENVFN
>
> --
> Matteo Croce
> per aspera ad upstream

Anyway, looking for "tc" instead of "alltests" is probably better, as
it only runs mktemp when at least the tc test is selected, both
manually or via make check from topdir, eg.g

ifeq ($(MAKECMDGOALS),tc)

Do you agree?
-- 
Matteo Croce
per aspera ad upstream
