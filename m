Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0052642BBB
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730289AbfFLQE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:04:59 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37027 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729816AbfFLQE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:04:59 -0400
Received: by mail-lf1-f65.google.com with SMTP id d11so4757567lfb.4
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 09:04:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iqYkbUKWYnXD6Vh0BVKAX4eXKU74Im6PcgsJSkKLcqU=;
        b=GzBkQus/oVVfgzrKQ8+auHAuVRaCjDjEzh9F4vihoBn+srg52O51U39JoUm7xRyFGG
         vSEfGn9a3glxNZLkVvqnNDj5NPUxk18uHE/1I10KV8Ujwy5AIPqbW1j+txTOHQJTojk0
         OrjfuI3wMlhv78Vqn9jqo1qK7uGl+/HeJ0iqFRKjGRNCnZvMxiGxHiqpRcqIjvBC71d4
         q7gdnYq5O20Djb1a19Wj+VC0S2WE4z6mHCWLndlpXqRZ51LD+EinNgT6356ik6QMraLP
         9inyJZSBXLK13FbgoYUJsx2bevq/mQnTul3Ko28Ite+oT7l8jCBjqHhntgpzVVvq7wX0
         wixg==
X-Gm-Message-State: APjAAAVYXWl1iR9OUM2373M01UguShyThyxQBWT4u8TIjBV63aTefXWm
        RG5d9G4DgLZ6iJrS53R8q8AVU25xKByqQji169cfIopOFiM=
X-Google-Smtp-Source: APXvYqwo1uYhgoy5nekOBVbkI8X+etzV+nkOYe0SE3rzSJXqLnyVyVQ0khgTENLlj07YS52+/amqXOjsP5Td9H4oV2o=
X-Received: by 2002:ac2:4466:: with SMTP id y6mr586004lfl.0.1560355497320;
 Wed, 12 Jun 2019 09:04:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190611180326.30597-1-mcroce@redhat.com> <20190612085307.35e42bf4@hermes.lan>
In-Reply-To: <20190612085307.35e42bf4@hermes.lan>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Wed, 12 Jun 2019 18:04:21 +0200
Message-ID: <CAGnkfhyT0W=CYU8FJYrDtzqxtcHakO5CWx2qzLuWOXVj6dyKMA@mail.gmail.com>
Subject: Re: [PATCH iproute2] testsuite: don't clobber /tmp
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 5:55 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Tue, 11 Jun 2019 20:03:26 +0200
> Matteo Croce <mcroce@redhat.com> wrote:
>
> > Even if not running the testsuite, every build will leave
> > a stale tc_testkenv.* file in the system temp directory.
> > Conditionally create the temp file only if we're running the testsuite.
> >
> > Signed-off-by: Matteo Croce <mcroce@redhat.com>
> > ---
> >  testsuite/Makefile | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/testsuite/Makefile b/testsuite/Makefile
> > index 7f247bbc..5353244b 100644
> > --- a/testsuite/Makefile
> > +++ b/testsuite/Makefile
> > @@ -14,7 +14,9 @@ TESTS_DIR := $(dir $(TESTS))
> >
> >  IPVERS := $(filter-out iproute2/Makefile,$(wildcard iproute2/*))
> >
> > -KENVFN := $(shell mktemp /tmp/tc_testkenv.XXXXXX)
> > +ifeq ($(MAKECMDGOALS),alltests)
> > +     KENVFN := $(shell mktemp /tmp/tc_testkenv.XXXXXX)
> > +endif
> >  ifneq (,$(wildcard /proc/config.gz))
> >       KCPATH := /proc/config.gz
> >  else
> > @@ -94,3 +96,4 @@ endif
> >               rm "$$TMP_ERR" "$$TMP_OUT"; \
> >               sudo dmesg > $(RESULTS_DIR)/$@.$$o.dmesg; \
> >       done
> > +     @$(RM) $(KENVFN)
>
> My concern is that there are several targets in this one Makefile.
>
> Why not use -u which gives name but does not create the file?

As the manpage says, this is unsafe, as a file with the same name can
be created in the meantime.
Another option is to run the mktemp in the target shell, but this will
require to escape every single end of line to make it a single shell
command, e.g.:

        KENVFN=$$(mktemp /tmp/tc_testkenv.XXXXXX); \
        if [ "$(KCPATH)" = "/proc/config.gz" ]; then \
                gunzip -c $(KCPATH) >$$KENVFN; \
        ...
        done ; \
        $(RM) $$KENVFN

-- 
Matteo Croce
per aspera ad upstream
