Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48071B478D
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 16:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgDVOnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 10:43:39 -0400
Received: from nautica.notk.org ([91.121.71.147]:43100 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbgDVOni (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 10:43:38 -0400
Received: by nautica.notk.org (Postfix, from userid 1001)
        id 8F580C01A; Wed, 22 Apr 2020 16:43:34 +0200 (CEST)
Date:   Wed, 22 Apr 2020 16:43:19 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, daniel@iogearbox.net,
        Jamal Hadi Salim <hadi@mojatatu.com>
Subject: Re: [PATCH iproute2 v2 1/2] bpf: Fix segfault when custom pinning is
 used
Message-ID: <20200422144319.GA25914@nautica>
References: <20200422102808.9197-1-jhs@emojatatu.com>
 <20200422102808.9197-2-jhs@emojatatu.com>
 <CAPpH65zpv6xD08KK-Gjwx4LxNsViu6Jy2DXgQ+inUodoE5Uhgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPpH65zpv6xD08KK-Gjwx4LxNsViu6Jy2DXgQ+inUodoE5Uhgw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrea Claudi wrote on Wed, Apr 22, 2020:
> > -       ret = asprintf(&tmp, "%s/../", bpf_get_work_dir(ctx->type));
> > +       ret = snprintf(tmp, PATH_MAX, "%s/../", bpf_get_work_dir(ctx->type));
> 
> Shouldn't we check for the last argument length before? We should have
> enough space for "/../" and the terminator, so we need the last
> argument length to be less than PATH_MAX-5, right?

snprintf will return the length that would be written if there had been
room so most codes just check the return value instead (something like
if (ret >= sizeof(tmp)) error)

OTOH this will actually be caught by the later strcat guard, because rem
will always contain at least on / the while will always be entered and
strlen(tmp) + (>=0) + 2 will always be > PATH_MAX, so this function will
error out.
I'll admit it's not clear, though :)

I'm actually not sure snprintf can return < 0... wide character
formatting functions can but basic ones not really, there's hardly any
snprintf return checking in iproute2 code...


Anyway, with all that said this patch currently technically works for
me, despite being not so clear, so can add my reviewed-by on whatever
final version you take (check < 0 or >= PATH_MAX or none or both), if
you'd like :)

-- 
Dominique
