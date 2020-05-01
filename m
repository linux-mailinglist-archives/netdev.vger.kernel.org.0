Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421CD1C0DEA
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 07:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgEAFyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 01:54:18 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:46660 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726452AbgEAFyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 01:54:18 -0400
Received: from mxbackcorp1g.mail.yandex.net (mxbackcorp1g.mail.yandex.net [IPv6:2a02:6b8:0:1402::301])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 06D422E0997;
        Fri,  1 May 2020 08:54:11 +0300 (MSK)
Received: from sas2-32987e004045.qloud-c.yandex.net (sas2-32987e004045.qloud-c.yandex.net [2a02:6b8:c08:b889:0:640:3298:7e00])
        by mxbackcorp1g.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id sQZ2gNUITo-s9A8R1rw;
        Fri, 01 May 2020 08:54:10 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1588312450; bh=XMwVjRdapCx1ZzgjFo7tQjSSW8ZXx9fgUKdnncFJSfs=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=Vi83saj26yYQO+yf6DyXfGp7sI/ffpMvCROf3BSrOUrxbVNQ1Q1ENJaXbNZ1gMwPL
         c5elxGEp+fN8M4A8xyZowUlD83s1Rg1e4ZebJ2O8tKW92ZoUlxJMeb8zpo9lJNTBd6
         u2eFuoChOoDXZdcUKnxJ5njGWVqbONHMtz2ru5q0=
Authentication-Results: mxbackcorp1g.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-vpn.dhcp.yndx.net (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b081:1422::1:2])
        by sas2-32987e004045.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id tn6P5JhdNK-s9WudR5I;
        Fri, 01 May 2020 08:54:09 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH net-next 0/2] inet_diag: add cgroup attribute and filter
To:     David Miller <davem@davemloft.net>, zeil@yandex-team.ru
Cc:     netdev@vger.kernel.org, tj@kernel.org, cgroups@vger.kernel.org,
        bpf@vger.kernel.org
References: <20200430155115.83306-1-zeil@yandex-team.ru>
 <20200430.125506.1341002176317746009.davem@davemloft.net>
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Message-ID: <7fb067b2-6c35-6573-82fe-edce194a7e46@yandex-team.ru>
Date:   Fri, 1 May 2020 08:54:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430.125506.1341002176317746009.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/04/2020 22.55, David Miller wrote:
> From: Dmitry Yakunin <zeil@yandex-team.ru>
> Date: Thu, 30 Apr 2020 18:51:13 +0300
> 
>> This patch series extends inet diag with cgroup v2 ID attribute and
>> filter. Which allows investigate sockets on per cgroup basis. Patch for
>> ss is already sent to iproute2-next mailing list.
> 
> Ok, this looks fine, series applied.
> 
> Although I wish you could have done something like only emit the cgroup
> attribute if it is a non-default value (zero, or whatever it is).
> 
> Every time a new socket attribute is added, it makes long dumps more
> and more expensive.
> 

Maybe then put it under condition

	if (ext & (1 << (INET_DIAG_CLASS_ID - 1)) ||
	    ext & (1 << (INET_DIAG_TCLASS - 1))) {

like legacy cgroup id INET_DIAG_CLASS_ID above.

(userspace requests it by INET_DIAG_TCLASS because INET_DIAG_CLASS_ID does not fit into field)
