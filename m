Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E50D423965
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 10:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237558AbhJFILm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 04:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237411AbhJFILl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 04:11:41 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38353C061749
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 01:09:49 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mY1zk-0008Aa-9F; Wed, 06 Oct 2021 10:09:44 +0200
Date:   Wed, 6 Oct 2021 10:09:44 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com, bluca@debian.org
Subject: Re: [PATCH iproute2 v3 1/3] configure: support --param=value style
Message-ID: <20211006080944.GA32194@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org,
        stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org
References: <cover.1633455436.git.aclaudi@redhat.com>
 <caa9b65bef41acd51d45e45e1a158edb1eeefe7d.1633455436.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <caa9b65bef41acd51d45e45e1a158edb1eeefe7d.1633455436.git.aclaudi@redhat.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrea,

A remark regarding coding style:

On Wed, Oct 06, 2021 at 12:08:04AM +0200, Andrea Claudi wrote:
[...]
> diff --git a/configure b/configure
> index 7f4f3bd9..d57ce0f8 100755
> --- a/configure
> +++ b/configure
> @@ -501,18 +501,30 @@ if [ $# -eq 1 ] && [ "$(echo $1 | cut -c 1)" != '-' ]; then
>  else
>  	while true; do
>  		case "$1" in
> -			--include_dir)
> -				INCLUDE=$2
> -				shift 2 ;;
> -			--libbpf_dir)
> -				LIBBPF_DIR="$2"
> -				shift 2 ;;
> -			--libbpf_force)
> -				if [ "$2" != 'on' ] && [ "$2" != 'off' ]; then
> +			--include_dir | --include_dir=*)

So here the code combines the two cases,

> +				INCLUDE="${1#*=}"
> +				if [ "$INCLUDE" == "--include_dir" ]; then

just to fiddle it apart again. Did you consider leaving the old cases in
place and adding separate ones for the --opt=val cases like so:

| 			--include_dir=*)
| 				INCLUDE="${1#*=}"
| 				shift
| 				;;

[...]
> +			--libbpf_force | --libbpf_force=*)
> +				LIBBPF_FORCE="${1#*=}"
> +				if [ "$LIBBPF_FORCE" == "--libbpf_force" ]; then
> +					LIBBPF_FORCE="$2"
> +					shift
> +				fi
> +				if [ "$LIBBPF_FORCE" != 'on' ] && [ "$LIBBPF_FORCE" != 'off' ]; then

To avoid duplication here, I would move semantic checks into a second
step. This would allow for things like:

| --libbpf_force=invalid --libbpf_force=on

but separating the syntactic parsing from semantic checks might be
beneficial by itself, too.

Cheers, Phil
