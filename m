Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC733632F2
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 03:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237154AbhDRBai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 21:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234904AbhDRBai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 21:30:38 -0400
Received: from mail.as397444.net (mail.as397444.net [IPv6:2620:6e:a000:dead:beef:15:bad:f00d])
        by lindbergh.monkeyblade.net (Postfix) with UTF8SMTPS id F1766C06174A
        for <netdev@vger.kernel.org>; Sat, 17 Apr 2021 18:30:09 -0700 (PDT)
Received: by mail.as397444.net (Postfix) with UTF8SMTPSA id 3292553ABC8;
        Sun, 18 Apr 2021 01:30:08 +0000 (UTC)
X-DKIM-Note: Keys used to sign are likely public at https://as397444.net/dkim/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mattcorallo.com;
        s=1618707664; t=1618709408;
        bh=4D5WE+eE9FbeVia3luUOtEHxnrTqtVLyrhRu1uVzJZE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=0GiQ51MMMkw4y+qRa8ihfZJ2muDdmu/C6OKqEOf22XlPkSNp9LCf7DeNctctg6YgU
         L0TJhVyxVCKWFRI1kMJ+oQV2JQHySImXjCSQ/h2w32iM7PscCb6qgxPfRvv7DcYgYy
         5WfHApdA7HkeRAWtHZAjAnDdi+CWKNUVX4rxV+sAkQbtWspMM2MU6Ulle2XuwpZ6O2
         o+6h4ucCQXAA+EYt0+VEQyKt4wxzxy/IrYq9l6owB3xFxMxpVaklmNTAL7y7GWOnzl
         9mmbil97fR5/YbIf+C31aVvADls6BuPAYOnW2THTk9GJROjjMJoJmNKtSrsiGK+/j3
         BwSMmYeTVnv7Q==
Message-ID: <c6467c1c-54f5-8681-6e7d-aa1d9fc2ff32@bluematt.me>
Date:   Sat, 17 Apr 2021 21:30:07 -0400
MIME-Version: 1.0
Subject: Re: PROBLEM: DoS Attack on Fragment Cache
Content-Language: en-US
To:     Willy Tarreau <w@1wt.eu>, Keyu Man <kman001@ucr.edu>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhiyun Qian <zhiyunq@cs.ucr.edu>
References: <02917697-4CE2-4BBE-BF47-31F58BC89025@hxcore.ol>
 <52098fa9-2feb-08ae-c24f-1e696076c3b9@gmail.com>
 <CANn89iL_V0WbeA-Zr29cLSp9pCsthkX9ze4W46gx=8-UeK2qMg@mail.gmail.com>
 <20210417072744.GB14109@1wt.eu>
 <CAMqUL6bkp2Dy3AMFZeNLjE1f-sAwnuBWpXH_FSYTSh8=Ac3RKg@mail.gmail.com>
 <20210417075030.GA14265@1wt.eu>
From:   Matt Corallo <netdev-list@mattcorallo.com>
In-Reply-To: <20210417075030.GA14265@1wt.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

See-also "[PATCH] Reduce IP_FRAG_TIME fragment-reassembly timeout to 1s, from 30s" (and the two resends of it) - given 
the size of the default cache (4MB) and the time that it takes before we flush the cache (30 seconds) you only need 
about 1Mbps of fragments to hit this issue. While DoS attacks are concerning, its also incredibly practical (and I do) 
hit this issue in normal non-adversarial conditions.

Matt

On 4/17/21 03:50, Willy Tarreau wrote:
> On Sat, Apr 17, 2021 at 12:42:39AM -0700, Keyu Man wrote:
>> How about at least allow the existing queue to finish? Currently a tiny new
>> fragment would potentially invalid all previous fragments by letting them
>> timeout without allowing the fragments to come in to finish the assembly.
> 
> Because this is exactly the principle of how attacks are built: reserve
> resources claiming that you'll send everything so that others can't make
> use of the resources that are reserved to you. The best solution precisely
> is *not* to wait for anyone to finish, hence *not* to reserve valuable
> resources that are unusuable by others.
> 
> Willy
> 
