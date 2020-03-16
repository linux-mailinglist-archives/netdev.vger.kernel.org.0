Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D735F1874B2
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 22:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732680AbgCPV1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 17:27:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732567AbgCPV1G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 17:27:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AC6220674;
        Mon, 16 Mar 2020 21:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584394025;
        bh=ByFbSzJVWgdFq+YLsDUbQUMWfF9YnlXP4tK40egVP6o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TUboG2+OR+AxjMSzAzpKPmVg1sAtnXwheFEIwAx5Tb8XCAXsAzvICUFPVQ+NoMBHP
         BSGNBVINYuM6GND6dWnJKK4ws+YQlzt1mH6lr2e7dAE66k+12UvQ7aK478mSegyasG
         Z2s8G+VMaK7YXSrf4YEvye2fVvXh/Fv0wvOREcvc=
Date:   Mon, 16 Mar 2020 14:27:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Bird, Tim" <Tim.Bird@sony.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "wad@chromium.org" <wad@chromium.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>
Subject: Re: [PATCH v2 0/4] kselftest: add fixture parameters
Message-ID: <20200316142702.20497d0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <202003161356.6CD6783@keescook>
References: <20200314005501.2446494-1-kuba@kernel.org>
        <202003132049.3D0CDBB2A@keescook>
        <MWHPR13MB08957F02680872A2C30DD7F4FDF90@MWHPR13MB0895.namprd13.prod.outlook.com>
        <20200316130416.4ec9103b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <202003161356.6CD6783@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Mar 2020 14:01:33 -0700 Kees Cook wrote:
> On Mon, Mar 16, 2020 at 01:04:16PM -0700, Jakub Kicinski wrote:
> > Variant sounds good too, although the abbreviation would be VAR?
> > Which isn't ideal. 
> > 
> > But I really don't care so whoever cares the most please speak up :P  
> 
> Let's go with "variant" and just spell it out.
> 
> > > BTW - Fuego has a similar feature for naming a collection of test
> > > parameters with specific values (if I understand this proposed
> > > feature correctly).  Fuego's feature was named a long time ago
> > > (incorrectly, I think) and it continues to bug me to this day.
> > > It was named 'specs', and after giving it considerable thought
> > > I've been meaning to change it to 'variants'.
> > > 
> > > Just a suggestion for consideration.  The fact that Fuego got this
> > > wrong is what motivates my suggestion today.  You have to live
> > > with this kind of stuff a long time. :-)
> > > 
> > > We ran into some issues in Fuego with this concept, that motivate
> > > the comments below.  I'll use your 'instance' terminology in my comments
> > > although the terminology is different in Fuego.
> > >   
> > > > Also a change in reporting:
> > > > 
> > > > 	struct __fixture_params_metadata no_param = { .name = "", };
> > > > 
> > > > Let's make ".name = NULL" here, and then we can detect instantiation:
> > > > 
> > > > 	printf("[ RUN      ] %s%s%s.%s\n", f->name, p->name ? "." : "",
> > > > 				p->name ?: "", t->name);  
> > 
> > Do I have to make it NULL or is it okay to test p->name[0] ?
> > That way we can save one ternary operator from the litany..  
> 
> I did consider Tim's idea of having them all say 'default', but since
> the bulk of tests aren't going to have variants, I don't want to spam
> the report with words I have to skip over.
> 
> And empty-check (instead of NULL) is fine by me.
> 
> > To me global.default.XYZ is a mouthful. so in my example (perhaps that
> > should have been part of the cover letter) I got:
> > 
> > [ RUN      ] global.keysizes             <= non-fixture test
> > [       OK ] global.keysizes             
> > [ RUN      ] tls_basic.base_base         <= fixture: "tls_basic", no params
> > [       OK ] tls_basic.base_base         
> > [ RUN      ] tls12.sendfile              <= fixture: "tls", param: "12"
> > [       OK ] tls12.sendfile                 
> > [ RUN      ] tls13.sendfile              <= fixture: "tls", param: "13"
> > [       OK ] tls13.sendfile                 (same fixture, diff param)
> > 
> > And users can start inserting underscores themselves if they really
> > want. (For TLS I was considering different ciphers but they don't impact
> > testing much.)  
> 
> The reason I'd like a dot is just for lay-person grep-ability and
> to avoid everyone needing to remember to add separator prefixes --
> there should just be a common one. e.g.  searching for "tls13" in the
> tree wouldn't find the test (since it's actually named "tls" and "13"
> is separate places). (I mean, sure, searching for "tls" is also insane,
> but I think I made my point.)

Ack, can't argue with grep-ability :)
