Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB0C6379E8
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 18:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbfFFQnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 12:43:02 -0400
Received: from mail-ot1-f52.google.com ([209.85.210.52]:44914 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727593AbfFFQnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 12:43:01 -0400
Received: by mail-ot1-f52.google.com with SMTP id b7so2551252otl.11
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 09:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4MrkfoYZoYG57aLnatnkGbEbCVRXNHEiYzY3rceOg/0=;
        b=NWYFb+j3HCi6G1WnKBoYCehDrTq0lkgOtTtNjNlA5xMOa9ZOn6I7YsjOGTlmGvsVxU
         qwqLU/WLfaBlKMXZglNjRmzKHn4ejIhZkT95IAfg1VZBdOUILzmw01vfnI+g1ruZFY8E
         vh9ZZLyfw2Li7CxRYtqs1XtAu+hq6/nWERXmg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4MrkfoYZoYG57aLnatnkGbEbCVRXNHEiYzY3rceOg/0=;
        b=clGT0Pw18L5zDeQzi7KnK1ZEO28J0UCui7XRyz8I79krD7AGtY4LNgFNMiL6d3ziTj
         BGXBOscS6U2Uyze04JVBdoNen2kdoFMZyxAT46zgyl2ySk8D2On0wJ7ZN+NsDTKgr8F4
         Kjp8Uk7Eug7Tor9ksaDSei79LQzamauhiTE3PaKHPDM3Qe+I5sliQlTy9ZSEra+VJ4HU
         yWCQB5o41PDpu2qSbAyEsu/s8j2VOOuwA0YSrzoHUS1MgcR6rLa1vSca8ypeqKQ+8QQl
         c0d5govJxCC7TakLIxk5Ckjc5hDcxErqsUVAsaTKMRUBpndqZqeamtFFXNeMI4ZUf1JG
         afkg==
X-Gm-Message-State: APjAAAV6jXvfksD+xSKlGIB6OVgmMRYPzjCqcEI5421Cw6g6De5V72dG
        G3c1Bd6GszSlM+YE4lzDP0BIxm7/lk+MhA5270NPjw==
X-Google-Smtp-Source: APXvYqzImCMc02u0bQfiNkPHOa4YJ0osGVZhHakje4u2A30dMqohZn9op4WkY86l4taKjqgKJFJMQXo6Oe1JETQc43I=
X-Received: by 2002:a9d:1b21:: with SMTP id l30mr9931635otl.5.1559839381032;
 Thu, 06 Jun 2019 09:43:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190531202132.379386-1-andriin@fb.com> <20190531202132.379386-7-andriin@fb.com>
In-Reply-To: <20190531202132.379386-7-andriin@fb.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Thu, 6 Jun 2019 17:42:49 +0100
Message-ID: <CACAyw99wD+7mXXeger6WoBTTu3aYHDW8EJV9_tP7MfXOnT0ODg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 6/8] libbpf: allow specifying map definitions
 using BTF
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for sending this RFC! For me, the biggest draw is that map-in-map
would be so much nicer to use, plus automatic dumping of map values.

Others on the thread have raised this point already: not everybody lives
on the bleeding edge or can control all of their dependencies. To me this means
that having a good compatibility story is paramount. I'd like to have very clear
rules how the presence / absence of fields is handled.

For example:
- Fields that are present but not understood are an error. This makes
sense because
  the user can simply omit the field in their definition if they do
not use it. It's also necessary
  to preserve the freedom to add new fields in the future without
risking user breakage.
- If libbpf adds support for a new field, it must be optional. Seems
like this is what current
  map extensions already do, so maybe a no-brainer.

Somewhat related to this: I really wish that BTF was self-describing,
e.g. possible
to parse without understanding all types. I mentioned this in another
thread of yours,
but the more we add features where BTF is required the more important it becomes
IMO.

Finally, some nits inline:

On Fri, 31 May 2019 at 21:22, Andrii Nakryiko <andriin@fb.com> wrote:
>
> The outline of the new map definition (short, BTF-defined maps) is as follows:
> 1. All the maps should be defined in .maps ELF section. It's possible to
>    have both "legacy" map definitions in `maps` sections and BTF-defined
>    maps in .maps sections. Everything will still work transparently.

I'd prefer using a new map section "btf_maps" or whatever. No need to
worry about code that deals with either type.

> 3. Key/value fields should be **a pointer** to a type describing
>    key/value. The pointee type is assumed (and will be recorded as such
>    and used for size determination) to be a type describing key/value of
>    the map. This is done to save excessive amounts of space allocated in
>    corresponding ELF sections for key/value of big size.

My biggest concern with the pointer is that there are cases when we want
to _not_ use a pointer, e.g. your proposal for map in map and tail calling.
There we need value to be a struct, an array, etc. The burden on the user
for this is very high.

> 4. As some maps disallow having BTF type ID associated with key/value,
>    it's possible to specify key/value size explicitly without
>    associating BTF type ID with it. Use key_size and value_size fields
>    to do that (see example below).

Why not just make them use the legacy map?

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
