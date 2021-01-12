Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F402F2EF0
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 13:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733258AbhALMVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 07:21:52 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17325 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727687AbhALMVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 07:21:51 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffd94370000>; Tue, 12 Jan 2021 04:21:11 -0800
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 Jan 2021 12:21:08
 +0000
References: <20210112103317.978952-1-roid@nvidia.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     Roi Dayan <roid@nvidia.com>
CC:     <netdev@vger.kernel.org>, Petr Machata <petrm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2 v4 1/1] build: Fix link errors on some systems
In-Reply-To: <20210112103317.978952-1-roid@nvidia.com>
Date:   Tue, 12 Jan 2021 13:21:04 +0100
Message-ID: <87h7nm73db.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610454071; bh=utXdyayaJZDXILvAgWy5RKXlSzbarRo9UAtn/7e9Ph4=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=DEISHSRIiTmM2i7IuqWO/A9QjCr6d6kpgfSWZbBOasIDlc/6AJcU7WqgNRMvkmddY
         TqdG6ewuIDvN69Ded8jrrOk9A+RFg4oHLJOuHMVBkHy311xrz88H4w2PpbAD6MgWzn
         Mg5dj9ZeSNqbymRIrNf21Y7UAkBQnBprMeggyYnvx09XC0as9CN628gOaUyTcBvJmR
         llTDl/X4ehViqZPeIzxWQpKJAIXWAGfTVMf83CnN5ZtNbVfpUm5qhC+xK/EEelfL4x
         SkbFZqd/P3ovnL/9SrgPXyQ/LGk9DCP1B4Mrnfxi4nBARR6Xe2TOIt3BoQUGCjYN7D
         fNhAsEE4ECh6g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Roi Dayan <roid@nvidia.com> writes:

> Since moving get_rate() and get_size() from tc to lib, on some
> systems we fail to link because of missing math lib.
> Move the functions that require math lib to their own c file
> and add -lm to dcb that now use those functions.
>
> ../lib/libutil.a(utils.o): In function `get_rate':
> utils.c:(.text+0x10dc): undefined reference to `floor'
> ../lib/libutil.a(utils.o): In function `get_size':
> utils.c:(.text+0x1394): undefined reference to `floor'
> ../lib/libutil.a(json_print.o): In function `sprint_size':
> json_print.c:(.text+0x14c0): undefined reference to `rint'
> json_print.c:(.text+0x14f4): undefined reference to `rint'
> json_print.c:(.text+0x157c): undefined reference to `rint'
>
> Fixes: f3be0e6366ac ("lib: Move get_rate(), get_rate64() from tc here")
> Fixes: 44396bdfcc0a ("lib: Move get_size() from tc here")
> Fixes: adbe5de96662 ("lib: Move sprint_size() from tc here, add print_size()")
>
> Signed-off-by: Roi Dayan <roid@nvidia.com>

Looking good:

    $ ldd ip/ip | grep libm.so
    $ ldd dcb/dcb | grep libm.so
            libm.so.6 => /lib64/libm.so.6 (0x00007f204d0c2000)

Reviewed-by: Petr Machata <petrm@nvidia.com>
Tested-by: Petr Machata <petrm@nvidia.com>
