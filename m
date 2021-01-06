Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21F12EC0DC
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 17:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbhAFQIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 11:08:53 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:19868 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbhAFQIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 11:08:53 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff5e06d0001>; Wed, 06 Jan 2021 08:08:13 -0800
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 6 Jan 2021 16:08:11
 +0000
References: <1609355503-7981-1-git-send-email-roid@nvidia.com>
 <875z4cwus8.fsf@nvidia.com>
 <405e8cce-e2dd-891a-dc8a-7c8b0c77f4c6@nvidia.com>
 <20210106080020.44ffd4d9@hermes.local>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     Roi Dayan <roid@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Petr Machata <me@pmachata.org>
Subject: Re: [PATCH iproute2] build: Fix link errors on some systems
In-Reply-To: <20210106080020.44ffd4d9@hermes.local>
Date:   Wed, 6 Jan 2021 17:08:08 +0100
Message-ID: <87ft3eujyv.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609949293; bh=gJ2dxGvktG6eLGaRh2LVAkdLeH96w4JzejfIYZizidk=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=deR0tS+5guv3nOAjWnuFdgzRTlc2AwD1dyFAaro76mDTln5lYtdXE5h2KY+HaRvmk
         Fc3aXSm3r8hXKklGumMm+3t3xKQkHBgRXlCrv3trZaYAlxTsLiKPioXet3MIaHO7gE
         h/QDvdbP9Al30Cjey7py/mSP5dNeUF5/ln/v9FlkHyobqcqTq3lRUqWGfkjol8Emdj
         nGN+GHtWv0/nIscWRd2qYGZBJ1xTEDaQ9aebPMXHpBh+uXdApUJ5Z0mq2BeJsIRUVn
         jdwAb7DDvGxFVN7V2MUNcyzAo1tDKLL8cA2kCTttnpV5iRIZ/boYhXwX1BS1hevQFC
         GnfW4Fyh93AMg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Stephen Hemminger <stephen@networkplumber.org> writes:

> On Wed, 6 Jan 2021 10:42:35 +0200
> Roi Dayan <roid@nvidia.com> wrote:
>
>> > 
>> > I think that just adding an unnecessary -lm is more of a tidiness issue
>> > than anything else. One way to avoid it is to split the -lm deps out
>> > from util.c / json_print.c to like util_math.c / json_print_math.c. That
>> > way they will be in an .o of their own, and won't be linked in unless
>> > the binary in question needs the code. Then the binaries that do call it
>> > can keep on linking in -lm like they did so far.
>> > 
>> > Thoughts?
>> >   
>
> Adding -lm to just some tools is not really required.
> The linker will ignore the shared library if not used.

I don't think that's true.

$ echo 'int main() {}' | gcc -x c /dev/stdin -lm
$ ldd a.out
	linux-vdso.so.1 (0x00007fff903e5000)
	libm.so.6 => /lib64/libm.so.6 (0x00007fa475d75000)
	libc.so.6 => /lib64/libc.so.6 (0x00007fa475bab000)
	/lib64/ld-linux-x86-64.so.2 (0x00007fa475ee4000)

Anyway, without the split to math / non-math modules, the DSO will
actually end up being necessary, because the undefined references to
floor() etc. in util.o / json_print.o will bring it in. Except of course
not everybody actually uses the code...
