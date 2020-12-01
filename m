Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514112CB059
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgLAWmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgLAWmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 17:42:47 -0500
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE9CC0613CF
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 14:42:04 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4Clxss1F3PzQlRs;
        Tue,  1 Dec 2020 23:41:37 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1606862495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lG2fNia44jX+Q4D4S4CrfDJhYn/N3E7WILFMvoDXUMc=;
        b=TehRpV16mU4Rj6k3IJ4ubEY6uiBqIgWsxv4XafAxp+1Dcbt1g+0nSXI9P06YkwAWgLXqoa
        T5Z94OPKL02VSKfN0drEYlS/pK5IBoRRN+iJ6KDmRnz4gjkQBd+o+0YjpNFr1smWYAvUud
        IWI6uvp/IbJHTWV9Zm5g60wDdvxYlMQvIvBRtuNW7v9uNXacpTb5Q149NcNmtrKlHwbHzg
        KSLa/CFxus2ZMSTP4vkKhOetlPdeRIsLgXI3sDQ1wHQzgLadKSYBN7H5bgvmSpmiJlviza
        Snw5yTFPoq3dfloe++RmMDMGICmHMIFCE4XYTQhZzgFvDGM27utWJbvz5xGvwg==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id HAIXImRp-Vmc; Tue,  1 Dec 2020 23:41:32 +0100 (CET)
References: <cover.1606774951.git.me@pmachata.org> <96d90dc75f2c1676b03a119307f068d818b35798.1606774951.git.me@pmachata.org> <20201130163904.14110c5c@hermes.local>
From:   Petr Machata <me@pmachata.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Petr Machata <me@pmachata.org>, netdev@vger.kernel.org,
        dsahern@gmail.com, Po.Liu@nxp.com, toke@toke.dk,
        dave.taht@gmail.com, edumazet@google.com, tahiliani@nitk.edu.in,
        leon@kernel.org
Subject: Re: [PATCH iproute2-next 3/6] lib: Move sprint_size() from tc here, add print_size()
Message-ID: <87k0u1no8g.fsf@nvidia.com>
In-reply-to: <20201130163904.14110c5c@hermes.local>
Date:   Tue, 01 Dec 2020 23:41:29 +0100
MIME-Version: 1.0
Content-Type: text/plain
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -2.74 / 15.00 / 15.00
X-Rspamd-Queue-Id: 4BD83171A
X-Rspamd-UID: 11440c
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Stephen Hemminger <stephen@networkplumber.org> writes:

> On Mon, 30 Nov 2020 23:59:39 +0100
> Petr Machata <me@pmachata.org> wrote:
>
>> +char *sprint_size(__u32 sz, char *buf)
>> +{
>> +	size_t len = SPRINT_BSIZE - 1;
>> +	double tmp = sz;
>> +
>> +	if (sz >= 1024*1024 && fabs(1024*1024*rint(tmp/(1024*1024)) - sz) < 1024)
>> +		snprintf(buf, len, "%gMb", rint(tmp/(1024*1024)));
>> +	else if (sz >= 1024 && fabs(1024*rint(tmp/1024) - sz) < 16)
>> +		snprintf(buf, len, "%gKb", rint(tmp/1024));
>> +	else
>> +		snprintf(buf, len, "%ub", sz);
>> +
>> +	return buf;
>> +}
>
> Add some whitespace here and maybe some constants like mb and kb?

Sure.

> Also, instead of magic SPRINT_BSIZE, why not take a len param (and
> name it snprint_size)?

Because keeping the interface like this makes it possible to reuse the
macroized bits in q_cake. I feel like the three current users are
auditable enough that the implied length is not a big deal. And no new
users should pop up, as the comment at the function makes clear.

> Yes when you copy/paste code it is good time to get it back to current
> style standards.
