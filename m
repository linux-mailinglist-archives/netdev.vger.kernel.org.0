Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60DA3185850
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 03:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbgCOCDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 22:03:17 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36180 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbgCOCDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 22:03:17 -0400
Received: by mail-pg1-f195.google.com with SMTP id z4so1652061pgu.3
        for <netdev@vger.kernel.org>; Sat, 14 Mar 2020 19:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3h+QncnAB09TWCYL27NLqTa11Pwiiscnbsp8TxCxAc8=;
        b=jEW/lyRVkgQRIXqJQ0Z2WMVDjaezSyJn7iL+/nvztvXW/fazC5dSUR+S9YMo3MCd7I
         ihAjvvPpUBRg0B1Fg6sa+R7C5gyAhuJCiOhnvJltafzljsTsm0L/rB6HMd2nitvC4K+L
         7/H+CQMAP2ka5tPGEiECUwQ/k994FzyjBXhTY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3h+QncnAB09TWCYL27NLqTa11Pwiiscnbsp8TxCxAc8=;
        b=ZNfCs+O4TGE1YI/k130Ycvlxp3B7Z5iElbNctJTA/6l9nbez+SK4Z440ul0U0Sv1f0
         VDsqHxUHT8BmR7aO1uXBzms55gMWtqZ7fXBzzdyc+nMrv2rcEWWxwQJVXUzTcHrZS31j
         y3dzM2hqQ8jfFTFYb+PQLLhtG3fC2wwWXSU8prupRT4XGsdXB6ykg23l2tK0ujsIH/lC
         WBmktelyn+8lNaPXjfeQn7RkVUQuTyWEHhlhbcyzhMAeRrJje2N9vvO5dpYaN4aIkdMI
         caVjaVssShbzZRO20RRpipNLbJRPLIVr6GFDmuMa0NrVf7SxTnK7HiJOqFEX/ka9bRkl
         C/RA==
X-Gm-Message-State: ANhLgQ3j/DUr1EPRhjPLLnbRypew+b9BW66hKmVYt142NLrIzWEMy3+/
        hZvn4YJzSPTkp3EoxR5i1+ZPVLYleL0=
X-Google-Smtp-Source: ADFU+vsGNRO6Sy5MiKEQG1qD/mEertqXEUL8325OvqCnRukOE7ad8Azx4YO+qmoMUWNYbSb1UD2Rkg==
X-Received: by 2002:a62:7dd7:: with SMTP id y206mr18056169pfc.79.1584160911993;
        Fri, 13 Mar 2020 21:41:51 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b9sm29102851pgi.75.2020.03.13.21.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 21:41:51 -0700 (PDT)
Date:   Fri, 13 Mar 2020 21:41:50 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     shuah@kernel.org, luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 0/4] kselftest: add fixture parameters
Message-ID: <202003132049.3D0CDBB2A@keescook>
References: <20200314005501.2446494-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200314005501.2446494-1-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 05:54:57PM -0700, Jakub Kicinski wrote:
> Note that we loose a little bit of type safety
> without passing parameters as an explicit argument.
> If user puts the name of the wrong fixture as argument
> to CURRENT_FIXTURE() it will happily cast the type.

This got me to take a much closer look at things. I really didn't like
needing to repeat the fixture name in CURRENT_FIXTURE() calls, and then
started coming to all the same conclusions you did in your v1, that I
just didn't quite see yet in my first review. :P

Apologies for my wishy-washy-ness on this, but here's me talking myself
out of my earlier criticisms:

- "I want tests to be run in declaration order" In v1, this is actually
  mostly retained: they're still in declaration order, but they're
  grouped by fixture (which are run in declaration order). That, I think,
  is totally fine. Someone writing code that interleaves between fixtures
  is madness, and having the report retain that ordering seems awful. I
  had thought the declaration ordering was entirely removed, but I see on
  closer inspection that's not true.

- "I'd like everything attached to _metadata" This results in the
  type unsafety you call out here. And I stared at your v2 trying to
  find a way around it, but to get the type attached, it has to be
  part of the __TEST_F_IMPL() glue, and that means passing it along
  side "self", which means plumbing it as a function argument
  everywhere.

So, again, sorry for asking to iterate on v1 instead of v2, though the
v2 _really_ helped me see the problems better. ;)

Something I'd like for v3: instead of "parameters" can we call it
"instances"? It provides a way to run separate instances of the same
fixtures. Those instances have parameters (i.e. struct fields), so I'd
prefer the "instance" naming.

Also a change in reporting:

	struct __fixture_params_metadata no_param = { .name = "", };

Let's make ".name = NULL" here, and then we can detect instantiation:

	printf("[ RUN      ] %s%s%s.%s\n", f->name, p->name ? "." : "",
				p->name ?: "", t->name);

That'll give us single-instance fixtures an unchanged name:

	fixture.test1
	fixture.test2

and instanced fixtures will be:

	fixture.wayA.test1
	fixture.wayA.test2
	fixture.wayB.test1
	fixture.wayB.test2


And finally, since we're in the land of endless macros, I think it
could be possible to make a macro to generate the __register_foo()
routine bodies. By the end of the series there are three nearly identical
functions in the harness for __register_test(), __register_fixture(), and
__register_fixture_instance(). Something like this as an earlier patch to
refactor the __register_test() that can be used by the latter two in their
patches (and counting will likely need to be refactored earlier too):

#define __LIST_APPEND(head, item)				\
{								\
	/* Circular linked list where only prev is circular. */	\
	if (head == NULL) {					\
		head = item;					\
		item->next = NULL;				\
		item->prev = item;				\
		return;						\
	}							\
	if (__constructor_order == _CONSTRUCTOR_ORDER_FORWARD) {\
		item->next = NULL;				\
		item->prev = head->prev;			\
		item->prev->next = item;			\
		head->prev = item;				\
	} else {						\
		p->next = head;					\
		p->next->prev = item;				\
		p->prev = item;					\
		head = item;					\
	}							\
}

Which should let it be used, ultimately, as:

static inline void __register_test(struct __test_metadata *t)
__LIST_APPEND(__test_list, t)

static inline void __register_fixture(struct __fixture_metadata *f)
__LIST_APPEND(__fixture_list, f)

static inline void
__register_fixture_instance(struct __fixture_metadata *f,
			    struct __fixture_instance_metadata *p)
__LIST_APPEND(f->instances, p)


Thanks for working on this!

-Kees

-- 
Kees Cook
