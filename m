Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2C9A17F54B
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 11:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgCJKpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 06:45:18 -0400
Received: from edrik.securmail.fr ([45.91.125.3]:62815 "EHLO
        edrik.securmail.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbgCJKpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 06:45:18 -0400
X-Greylist: delayed 528 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Mar 2020 06:45:17 EDT
Received: by edrik.securmail.fr (Postfix, from userid 58)
        id A5C7BB0E7A; Tue, 10 Mar 2020 11:36:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=swordarmor.fr;
        s=swordarmor; t=1583836587;
        bh=pLJ4A856/V4dGBCFqbnahLZhpanWRvW4sPEXds3wuBE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=dHD9okYBTKEW92Rh3XuewhvttA+sTz8SSDVLP8aG5+9XsD1gMYCpnLHDCxmuqOW5k
         beCr1SlYa3riw5DM0F9Jw5wnbnll7rsSOnbeCbAAPpmb1weZ8uRBDdKXAvI2pIvqiQ
         2M0B9lOJu/GH0e9Pmo9xKJ1HzbY4eShxqdKX+3F4=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on edrik.securmail.fr
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU autolearn=unavailable
        autolearn_force=no version=3.4.2
Received: from mew.swordarmor.fr (mew.swordarmor.fr [IPv6:2a00:5884:102:1::4])
        (using TLSv1.2 with cipher DHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: alarig@swordarmor.fr)
        by edrik.securmail.fr (Postfix) with ESMTPSA id E6928B0E70;
        Tue, 10 Mar 2020 11:35:44 +0100 (CET)
Authentication-Results: edrik.securmail.fr/E6928B0E70; dmarc=none (p=none dis=none) header.from=swordarmor.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=swordarmor.fr;
        s=swordarmor; t=1583836545;
        bh=pLJ4A856/V4dGBCFqbnahLZhpanWRvW4sPEXds3wuBE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=i7Wj34fxAMWjnGf5+Wozixy6kMFh1qd6yeJK9P9kAtPwsfn/Wny4IChGRqaqO0QSX
         EFSwucysrW9z27ziFnuvAjI86J+aIUNMNtuaZW9gAV+6y2uG2uxuA0INFgptNvnlDO
         Dv9UStFbMiP7906Hu3GO6b4+QKwPAkZ3r+ZSNo2U=
Date:   Tue, 10 Mar 2020 11:35:41 +0100
From:   Alarig Le Lay <alarig@swordarmor.fr>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, jack@basilfillan.uk,
        Vincent Bernat <bernat@debian.org>
Subject: Re: IPv6 regression introduced by commit
 3b6761d18bc11f2af2a6fc494e9026d39593f22c
Message-ID: <20200310103541.aplhwhfsvcflczhp@mew.swordarmor.fr>
References: <20200305081747.tullbdlj66yf3w2w@mew.swordarmor.fr>
 <d8a0069a-b387-c470-8599-d892e4a35881@gmail.com>
 <20200308105729.72pbglywnahbl7hs@mew.swordarmor.fr>
 <27457094-b62a-f029-e259-f7a274fee49d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <27457094-b62a-f029-e259-f7a274fee49d@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On dim.  8 mars 20:15:14 2020, David Ahern wrote:
> If you are using x86 based CPU you can do this:
>     perf probe ip6_dst_alloc%return ret=%ax
> 
>     perf record -e probe:* -a -g -- sleep 10
>     --> run this during the flapping
> 
>     perf script

For this probe I see that: https://paste.swordarmor.fr/raw/pt9b

> this will show if the flapping is due to dst alloc failures.
> 
> Other things to try:
>     perf probe ip6_dst_gc
>     perf stat -e probe:* -a -I 1000
>     --> will show calls/sec to running dst gc

https://paste.swordarmor.fr/raw/uBnm

>     perf probe __ip6_rt_update_pmtu
>     perf stat -e probe:* -a -I 1000
>     --> will show calls/sec to mtu updating

This probe always stays at 0 even when the NDP is failing.
 
>     perf probe rt6_insert_exception
>     perf state -e probe:* -a -I 1000
>     --> shows calls/sec to inserting exceptions

Same as the last one.

> (in each you can remove the previous probe using 'perf probe -d <name>'
> or use -e <exact name> to only see data for the one event).
> 
> > I have the problem with 5.3 (proxmox 6), so unless FIB handling has been
> > changed since then, I doubt that it will works, but I will try on
> > Monday.
> > 
> 
> a fair amount of changes went in through 5.4 including improvements to
> neighbor handling. 5.4 (I think) also had changes around dumping the
> route cache.

Regards,
-- 
Alarig
