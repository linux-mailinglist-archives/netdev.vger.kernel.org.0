Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C9342574A
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242238AbhJGQEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233255AbhJGQEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 12:04:01 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7E4C061570
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 09:02:07 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mYVqM-0005vL-RF; Thu, 07 Oct 2021 18:02:02 +0200
Date:   Thu, 7 Oct 2021 18:02:02 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com, bluca@debian.org, haliu@redhat.com
Subject: Re: [PATCH iproute2 v4 0/5] configure: add support for libdir and
 prefix option
Message-ID: <20211007160202.GG32194@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org,
        stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org,
        haliu@redhat.com
References: <cover.1633612111.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1633612111.git.aclaudi@redhat.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrea,

On Thu, Oct 07, 2021 at 03:40:00PM +0200, Andrea Claudi wrote:
> This series add support for the libdir parameter in iproute2 configure
> system. The idea is to make use of the fact that packaging systems may
> assume that 'configure' comes from autotools allowing a syntax similar
> to the autotools one, and using it to tell iproute2 where the distro
> expects to find its lib files.
> 
> Patches 1-2 fix a parsing issue on current configure options, that may
> trigger an endless loop when no value is provided with some options;

Hmm, "shift 2" is nasty. Good to be reminded that it fails if '$# < 2'.
I would avoid the loop using single shifts:

| case "$1" in
| --include_dir)
| 	shift
| 	INCLUDE=$1
| 	shift
| 	;;
| [...]

> Patch 3 introduces support for the --opt=value style on current options,
> for uniformity;

My idea to avoid code duplication was to move the semantic checks out of
the argument parsing loop, basically:

| [ -d "$INCLUDE" ] || usage 1
| case "$LIBBPF_FORCE" in
| 	on|off|"") ;;
| 	*) usage 1 ;;
| esac

after the loop or even before 'echo "# Generated config ...'. This
reduces the parsing loop to cases like:

| --include_dir)
| 	shift
| 	INCLUDE=$1
| 	shift
| 	;;
| --include_dir=*)
| 	INCLUDE=${1#*=}
| 	shift
| 	;;

> Patch 4 add the --prefix option, that may be used by some packaging
> systems when calling the configure script;

So this parses into $PREFIX and when checking it assigns to $prefix but
neither one of the two variables is used afterwards? Oh, there's patch
5 ...

> Patch 5 add the --libdir option, and also drops the static LIBDIR var
> from the Makefile

Can't you just:

| [ -n "$PREFIX" ] && echo "PREFIX=\"$PREFIX\"" >>config.mk
| [ -n "$LIBDIR" ] && echo "LIBDIR=\"$LIBDIR\"" >>config.mk

and leave the default ("?=") cases in Makefile in place?

Either way, calling 'eval' seems needless. I would avoid it at all
costs, "eval is evil". ;)

Cheers, Phil
