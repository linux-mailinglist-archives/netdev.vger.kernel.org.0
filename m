Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66651426BF4
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 15:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhJHNw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 09:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhJHNwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 09:52:24 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C144CC061570
        for <netdev@vger.kernel.org>; Fri,  8 Oct 2021 06:50:28 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mYqGX-0007Y6-VA; Fri, 08 Oct 2021 15:50:25 +0200
Date:   Fri, 8 Oct 2021 15:50:25 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com, bluca@debian.org, haliu@redhat.com
Subject: Re: [PATCH iproute2 v4 0/5] configure: add support for libdir and
 prefix option
Message-ID: <20211008135025.GM32194@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org,
        stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org,
        haliu@redhat.com
References: <cover.1633612111.git.aclaudi@redhat.com>
 <20211007160202.GG32194@orbyte.nwl.cc>
 <YWBCx6yvm7gDZNId@renaissance-vector>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWBCx6yvm7gDZNId@renaissance-vector>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Oct 08, 2021 at 03:08:23PM +0200, Andrea Claudi wrote:
> On Thu, Oct 07, 2021 at 06:02:02PM +0200, Phil Sutter wrote:
> > On Thu, Oct 07, 2021 at 03:40:00PM +0200, Andrea Claudi wrote:
> > > This series add support for the libdir parameter in iproute2 configure
> > > system. The idea is to make use of the fact that packaging systems may
> > > assume that 'configure' comes from autotools allowing a syntax similar
> > > to the autotools one, and using it to tell iproute2 where the distro
> > > expects to find its lib files.
> > > 
> > > Patches 1-2 fix a parsing issue on current configure options, that may
> > > trigger an endless loop when no value is provided with some options;
> > 
> > Hmm, "shift 2" is nasty. Good to be reminded that it fails if '$# < 2'.
> > I would avoid the loop using single shifts:
> > 
> > | case "$1" in
> > | --include_dir)
> > | 	shift
> > | 	INCLUDE=$1
> > | 	shift
> > | 	;;
> > | [...]
> > 
> 
> This avoid the endless loop and allows configure to terminate correctly,
> but results in an error anyway:
> 
> $ ./configure --include_dir
> ./configure: line 544: shift: shift count out of range

Ah, I didn't see it with bash. I don't think it's a problem though:
Input is invalid, the loop is avoided and (depending on your patches)
there will be another error message complaining about invalid $INCLUDE
value.

> But thanks anyway! Your comment made me think again about this, and I
> think we can use the *) case to actually get rid of the second shift.
> 
> Indeed, when an option is specified, the --opt case will shift and get
> its value, then the next while loop will take the *) case, and the
> second shift is triggered this way.

Which sounds like you'll start accepting things like

| ./configure --include_dir foo bar

> > > Patch 3 introduces support for the --opt=value style on current options,
> > > for uniformity;
> > 
> > My idea to avoid code duplication was to move the semantic checks out of
> > the argument parsing loop, basically:
> > 
> > | [ -d "$INCLUDE" ] || usage 1
> > | case "$LIBBPF_FORCE" in
> > | 	on|off|"") ;;
> > | 	*) usage 1 ;;
> > | esac
> > 
> > after the loop or even before 'echo "# Generated config ...'. This
> > reduces the parsing loop to cases like:
> > 
> > | --include_dir)
> > | 	shift
> > | 	INCLUDE=$1
> > | 	shift
> > | 	;;
> > | --include_dir=*)
> > | 	INCLUDE=${1#*=}
> > | 	shift
> > | 	;;
> >
> 
> Thanks. I didn't think about '-d', this also cover corner cases like:
> 
> $ ./configure --include_dir --libbpf_force off
> 
> that results in INCLUDE="--libbpf_force".

A common case would be (note the typo):

| ./configure --include_dir $MY_INCULDE_DIR --libbpf_force off

> > > Patch 4 add the --prefix option, that may be used by some packaging
> > > systems when calling the configure script;
> > 
> > So this parses into $PREFIX and when checking it assigns to $prefix but
> > neither one of the two variables is used afterwards? Oh, there's patch
> > 5 ...
> > 
> > > Patch 5 add the --libdir option, and also drops the static LIBDIR var
> > > from the Makefile
> > 
> > Can't you just:
> > 
> > | [ -n "$PREFIX" ] && echo "PREFIX=\"$PREFIX\"" >>config.mk
> > | [ -n "$LIBDIR" ] && echo "LIBDIR=\"$LIBDIR\"" >>config.mk
> > 
> > and leave the default ("?=") cases in Makefile in place?
> > 
> > Either way, calling 'eval' seems needless. I would avoid it at all
> > costs, "eval is evil". ;)
> 
> Unfortunately this is needed because some packaging systems uses
> ${prefix} as an argument to --libdir, expecting this to be replaced with
> the value of --prefix. See Luca's review to v1 for an example [1].
> 
> I can always avoid the eval trying to parse "${prefix}" and replacing it
> with the PREFIX value, but in this case "eval" seems a bit more
> practical to me... WDYT?

Do autotools support that? If not, I wouldn't bother.

Cheers, Phil
