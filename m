Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0C9E1873CA
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 21:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732524AbgCPUEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 16:04:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732436AbgCPUEU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 16:04:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01C3520658;
        Mon, 16 Mar 2020 20:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584389059;
        bh=Xwa8ruFtzyte+EsDEJIYBy2/t4S0bIe89Tc3YaQoSr0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c/+y9xa56uhBvkveqc2ysEboJLvoLTXf/DVu2Bi8ddCfYr0BbX1Gb7O6fY/58RCP1
         6M1/fZzAIJNlgX5yHcQNzJWyLfVhxqnGedbJnlyexDy1KW/9VkO67+B+k+EmbaV07T
         Fy3LdujZRe+T9pPLpMpsrDzDoCR6KJqZDx5xy1o8=
Date:   Mon, 16 Mar 2020 13:04:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Bird, Tim" <Tim.Bird@sony.com>
Cc:     Kees Cook <keescook@chromium.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "wad@chromium.org" <wad@chromium.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>
Subject: Re: [PATCH v2 0/4] kselftest: add fixture parameters
Message-ID: <20200316130416.4ec9103b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <MWHPR13MB08957F02680872A2C30DD7F4FDF90@MWHPR13MB0895.namprd13.prod.outlook.com>
References: <20200314005501.2446494-1-kuba@kernel.org>
        <202003132049.3D0CDBB2A@keescook>
        <MWHPR13MB08957F02680872A2C30DD7F4FDF90@MWHPR13MB0895.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Mar 2020 15:55:12 +0000 Bird, Tim wrote:
> > -----Original Message-----
> > From: Kees Cook
> > 
> > On Fri, Mar 13, 2020 at 05:54:57PM -0700, Jakub Kicinski wrote:  
> > > Note that we loose a little bit of type safety
> > > without passing parameters as an explicit argument.
> > > If user puts the name of the wrong fixture as argument
> > > to CURRENT_FIXTURE() it will happily cast the type.  
> > 
> > This got me to take a much closer look at things. I really didn't like
> > needing to repeat the fixture name in CURRENT_FIXTURE() calls, and then
> > started coming to all the same conclusions you did in your v1, that I
> > just didn't quite see yet in my first review. :P

No worries, it took me a little bit of internal back and forth to
produce v1, and it's still not at all perfect :S

> > Apologies for my wishy-washy-ness on this, but here's me talking myself
> > out of my earlier criticisms:
> > 
> > - "I want tests to be run in declaration order" In v1, this is actually
> >   mostly retained: they're still in declaration order, but they're
> >   grouped by fixture (which are run in declaration order). That, I think,
> >   is totally fine. Someone writing code that interleaves between fixtures
> >   is madness, and having the report retain that ordering seems awful. I
> >   had thought the declaration ordering was entirely removed, but I see on
> >   closer inspection that's not true.
> > 
> > - "I'd like everything attached to _metadata" This results in the
> >   type unsafety you call out here. And I stared at your v2 trying to
> >   find a way around it, but to get the type attached, it has to be
> >   part of the __TEST_F_IMPL() glue, and that means passing it along
> >   side "self", which means plumbing it as a function argument
> >   everywhere.
> > 
> > So, again, sorry for asking to iterate on v1 instead of v2, though the
> > v2 _really_ helped me see the problems better. ;)
> > 
> > Something I'd like for v3: instead of "parameters" can we call it
> > "instances"? It provides a way to run separate instances of the same
> > fixtures. Those instances have parameters (i.e. struct fields), so I'd
> > prefer the "instance" naming.  
> 
> Could I humbly suggest "variant" as a possible name here?
> IMHO "instance" carries along some semantics related to object
> oriented programming, which I think is a bit confusing.  (Maybe that's
> intentional though, and you prefer that?)

I like parameter or argument, since the data provided to the test 
is constant, and used to guide the instantiation (i.e. "setup"). 
"self" looks more like an instance of a class from OOP point of view.

Variant sounds good too, although the abbreviation would be VAR?
Which isn't ideal. 

But I really don't care so whoever cares the most please speak up :P

> BTW - Fuego has a similar feature for naming a collection of test
> parameters with specific values (if I understand this proposed
> feature correctly).  Fuego's feature was named a long time ago
> (incorrectly, I think) and it continues to bug me to this day.
> It was named 'specs', and after giving it considerable thought
> I've been meaning to change it to 'variants'.
> 
> Just a suggestion for consideration.  The fact that Fuego got this
> wrong is what motivates my suggestion today.  You have to live
> with this kind of stuff a long time. :-)
> 
> We ran into some issues in Fuego with this concept, that motivate
> the comments below.  I'll use your 'instance' terminology in my comments
> although the terminology is different in Fuego.
> 
> > Also a change in reporting:
> > 
> > 	struct __fixture_params_metadata no_param = { .name = "", };
> > 
> > Let's make ".name = NULL" here, and then we can detect instantiation:
> > 
> > 	printf("[ RUN      ] %s%s%s.%s\n", f->name, p->name ? "." : "",
> > 				p->name ?: "", t->name);

Do I have to make it NULL or is it okay to test p->name[0] ?
That way we can save one ternary operator from the litany..

> > That'll give us single-instance fixtures an unchanged name:
> > 
> > 	fixture.test1
> > 	fixture.test2  
> 
> We ended up in Fuego adding a 'default' instance name for 
> all tests.  That way, all the parsers don't have to be coded to distinguish
> if the test identifier includes an instance name or not, which turns
> out to be a tough problem.
> 
> So single-instance tests would be:
>             fixture.default.test1
>             fixture.default.test2

Interesting! That makes sense to me, thanks for sharing the experience.
That's why I just appended the param/instance/variant name to the
fixture name.

To me global.default.XYZ is a mouthful. so in my example (perhaps that
should have been part of the cover letter) I got:

[ RUN      ] global.keysizes             <= non-fixture test
[       OK ] global.keysizes             
[ RUN      ] tls_basic.base_base         <= fixture: "tls_basic", no params
[       OK ] tls_basic.base_base         
[ RUN      ] tls12.sendfile              <= fixture: "tls", param: "12"
[       OK ] tls12.sendfile                 
[ RUN      ] tls13.sendfile              <= fixture: "tls", param: "13"
[       OK ] tls13.sendfile                 (same fixture, diff param)

And users can start inserting underscores themselves if they really
want. (For TLS I was considering different ciphers but they don't impact
testing much.)

> > 
> > and instanced fixtures will be:
> > 
> > 	fixture.wayA.test1
> > 	fixture.wayA.test2
> > 	fixture.wayB.test1
> > 	fixture.wayB.test2
> >   
> 
> Parsing of the test identifiers starts to become a thorny issue 
> as you get longer and longer sequences of test-name parts
> (test suite, test fixture, sub-test, test-case, measurement, instance, etc.)
> It becomes considerably more difficult if  you have more than
> one optional element in the identifier, so it's useful to
> avoid any optional element you can.
> 
> > 
> > And finally, since we're in the land of endless macros, I think it
> > could be possible to make a macro to generate the __register_foo()
> > routine bodies. By the end of the series there are three nearly identical
> > functions in the harness for __register_test(), __register_fixture(), and
> > __register_fixture_instance(). Something like this as an earlier patch to
> > refactor the __register_test() that can be used by the latter two in their
> > patches (and counting will likely need to be refactored earlier too):
> > 
> > #define __LIST_APPEND(head, item)				\
> > {								\
> > 	/* Circular linked list where only prev is circular. */	\
> > 	if (head == NULL) {					\
> > 		head = item;					\
> > 		item->next = NULL;				\
> > 		item->prev = item;				\
> > 		return;						\
> > 	}							\
> > 	if (__constructor_order == _CONSTRUCTOR_ORDER_FORWARD) {\
> > 		item->next = NULL;				\
> > 		item->prev = head->prev;			\
> > 		item->prev->next = item;			\
> > 		head->prev = item;				\
> > 	} else {						\
> > 		p->next = head;					\
> > 		p->next->prev = item;				\
> > 		p->prev = item;					\
> > 		head = item;					\
> > 	}							\
> > }
> > 
> > Which should let it be used, ultimately, as:
> > 
> > static inline void __register_test(struct __test_metadata *t)
> > __LIST_APPEND(__test_list, t)
> > 
> > static inline void __register_fixture(struct __fixture_metadata *f)
> > __LIST_APPEND(__fixture_list, f)
> > 
> > static inline void
> > __register_fixture_instance(struct __fixture_metadata *f,
> > 			    struct __fixture_instance_metadata *p)
> > __LIST_APPEND(f->instances, p)  
> 
> With my suggestion of 'variant', this would change to:
> 
> static inline void
> __register_fixture_variant(struct __fixture_metadata *f,
> 			    struct __fixture_variant_metadata *p)
> __LIST_APPEND(f->variants, p)
> 
> 
> Just my 2 cents.
>  -- Tim

