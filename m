Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D97BA44936
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393390AbfFMRPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:15:42 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37802 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728765AbfFMRPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 13:15:40 -0400
Received: by mail-lf1-f67.google.com with SMTP id d11so7871592lfb.4
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 10:15:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R4j0G4vaM8U/AvnzV/oChYn69gqQ5r6f/n52TNHyYKE=;
        b=eXi360XVDVaWJOvlp/DqKS2hM5nYu756DBnjqZaItWJ4yvaqKVuwF8cZR4vHIDkmpz
         L3G7GsdzZp+ms7xE+OFzF3/9lgDtdzEkQj+X8Jkm9G42cMECV38kC14RAYscEO9JV6lp
         zOPuYZEZpiv/xYpbCorM+NMcUMGA2rYkNspOusLeMIgOJXGkESkQZ7SknsoP5Cc4kGe2
         XjFEQ/oHWBQEPulNKGal/p/wtzr7KkhLJGd0AKmscwWyte9IJyPq80enx+azHs4mwgCA
         mgTLAyQjsHBBthoxWz2KCMYHYDcHl8chH17Mh7EbzbEDx8tlY0KA1zuii/RpYpVxaThX
         a8eg==
X-Gm-Message-State: APjAAAX1xm1M3QwhrZhJizTRLHWh+5sAWO8cUyvbVisjYWgD4kKUmgBS
        H52VhlwVjSN8s60gujYnI5HqSrawoU2YrYDTq6tsupLVzMA=
X-Google-Smtp-Source: APXvYqx6hUvMM8oLOqFLSr5HVr31yHCO/3xYVRy985iSYuVIjSiUKD9zPCmgMltLE6rCCPjkkMhlg5ZnrNyUKWgiHmY=
X-Received: by 2002:a19:e308:: with SMTP id a8mr44183983lfh.69.1560446138179;
 Thu, 13 Jun 2019 10:15:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190611180326.30597-1-mcroce@redhat.com> <20190612085307.35e42bf4@hermes.lan>
 <CAGnkfhyT0W=CYU8FJYrDtzqxtcHakO5CWx2qzLuWOXVj6dyKMA@mail.gmail.com>
 <CAGnkfhz-W64f-j+Sgbi47BO6VKfyaYQ1W865sihXhCjChh_kFQ@mail.gmail.com> <20190612111938.1c9da723@hermes.lan>
In-Reply-To: <20190612111938.1c9da723@hermes.lan>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Thu, 13 Jun 2019 19:15:01 +0200
Message-ID: <CAGnkfhyS64WA+947iQFwA9+=yS6Zk856SWBR9Zy7w90xhBmC=Q@mail.gmail.com>
Subject: Re: [PATCH iproute2] testsuite: don't clobber /tmp
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 8:20 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Wed, 12 Jun 2019 19:32:29 +0200
> Matteo Croce <mcroce@redhat.com> wrote:
>
> > On Wed, Jun 12, 2019 at 6:04 PM Matteo Croce <mcroce@redhat.com> wrote:
> > >
> > > On Wed, Jun 12, 2019 at 5:55 PM Stephen Hemminger
> > > <stephen@networkplumber.org> wrote:
> > > >
> > > > On Tue, 11 Jun 2019 20:03:26 +0200
> > > > Matteo Croce <mcroce@redhat.com> wrote:
> > > >
> > > > > Even if not running the testsuite, every build will leave
> > > > > a stale tc_testkenv.* file in the system temp directory.
> > > > > Conditionally create the temp file only if we're running the testsuite.
> > > > >
> > > > > Signed-off-by: Matteo Croce <mcroce@redhat.com>
> > > > > ---
> > > > >  testsuite/Makefile | 5 ++++-
> > > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/testsuite/Makefile b/testsuite/Makefile
> > > > > index 7f247bbc..5353244b 100644
> > > > > --- a/testsuite/Makefile
> > > > > +++ b/testsuite/Makefile
> > > > > @@ -14,7 +14,9 @@ TESTS_DIR := $(dir $(TESTS))
> > > > >
> > > > >  IPVERS := $(filter-out iproute2/Makefile,$(wildcard iproute2/*))
> > > > >
> > > > > -KENVFN := $(shell mktemp /tmp/tc_testkenv.XXXXXX)
> > > > > +ifeq ($(MAKECMDGOALS),alltests)
> > > > > +     KENVFN := $(shell mktemp /tmp/tc_testkenv.XXXXXX)
> > > > > +endif
> > > > >  ifneq (,$(wildcard /proc/config.gz))
> > > > >       KCPATH := /proc/config.gz
> > > > >  else
> > > > > @@ -94,3 +96,4 @@ endif
> > > > >               rm "$$TMP_ERR" "$$TMP_OUT"; \
> > > > >               sudo dmesg > $(RESULTS_DIR)/$@.$$o.dmesg; \
> > > > >       done
> > > > > +     @$(RM) $(KENVFN)
> > > >
> > > > My concern is that there are several targets in this one Makefile.
> > > >
> > > > Why not use -u which gives name but does not create the file?
> > >
> > > As the manpage says, this is unsafe, as a file with the same name can
> > > be created in the meantime.
> > > Another option is to run the mktemp in the target shell, but this will
> > > require to escape every single end of line to make it a single shell
> > > command, e.g.:
> > >
> > >         KENVFN=$$(mktemp /tmp/tc_testkenv.XXXXXX); \
> > >         if [ "$(KCPATH)" = "/proc/config.gz" ]; then \
> > >                 gunzip -c $(KCPATH) >$$KENVFN; \
> > >         ...
> > >         done ; \
> > >         $(RM) $$KENVFN
> > >
> > > --
> > > Matteo Croce
> > > per aspera ad upstream
> >
> > Anyway, looking for "tc" instead of "alltests" is probably better, as
> > it only runs mktemp when at least the tc test is selected, both
> > manually or via make check from topdir, eg.g
> >
> > ifeq ($(MAKECMDGOALS),tc)
> >
> > Do you agree?
>
> Why use /tmp at all for this config file?

To me any path could work, both /tmp or in the current dir, I have no
preference.
The important thing is to remove them wherever they are, as clobbering
the build dir is bad as messing /tmp.

Anyway, I double checked, and the only target which uses that
temporary file is 'alltests' so, if the path is ok, I think that the
condition "ifeq ($(MAKECMDGOALS),alltests)" is the only one which
fixes the issue and keeps the behaviour unaltered.
I did some quick tests and it works for me.

Bye,
-- 
Matteo Croce
per aspera ad upstream
