Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D72E295554
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 01:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507305AbgJUXtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 19:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2507293AbgJUXtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 19:49:12 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1092EC0613CE
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 16:49:11 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4CGnJh6Xl7zQlKL;
        Thu, 22 Oct 2020 01:49:08 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1603324142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ro0uW4Gm8fMOKTcs/f19Si6fIoH99Mcx+GA4CBw8sWw=;
        b=r/CM+juhKSdlN1pTEXXaQduztUZE/tUWUne+GapSJteA1w26GVelivVRYg3ebb5DuTuxgJ
        9jjzUY0HullmQ7+nUyzQJi9tNxGP7bAsmEAcSVXCH/ClbN9vzMX1SvZzwvOGt7ynS298sl
        5/Mr1abguBiL7812VzbFUiw0WYW2ixmIu8IDRG4++OawCVT4nyRDqcBYqguO2w4E0b0+Fb
        k9Z8QkJvkW13GZJWEU2ColpTIsJ2Zw5Trk0sfqOmzNZ/TYN672d88QvuLcQn7ur42KSSed
        aM0aPgXWRWc52BRyM0NKjY8jAWpsua+qusnyWcLgRehU6SvbQ8DduSWvxHvU/w==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id K2aVCmCavvVU; Thu, 22 Oct 2020 01:49:01 +0200 (CEST)
References: <20201020114141.53391942@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <877drkk4qu.fsf@nvidia.com> <20201021112838.3026a648@hermes.local>
From:   Petr Machata <me@pmachata.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        dsahern@gmail.com, john.fastabend@gmail.com, jiri@nvidia.com,
        idosch@nvidia.com
Subject: Re: [PATCH iproute2-next 15/15] dcb: Add a subtool for the DCB ETS object
In-reply-to: <20201021112838.3026a648@hermes.local>
Date:   Thu, 22 Oct 2020 01:48:58 +0200
Message-ID: <873627jg2d.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -3.70 / 15.00 / 15.00
X-Rspamd-Queue-Id: 9B9EA271
X-Rspamd-UID: 45dd1d
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Stephen Hemminger <stephen@networkplumber.org> writes:

> On Tue, 20 Oct 2020 22:43:37 +0200
> Petr Machata <me@pmachata.org> wrote:
>
>> Jakub Kicinski <kuba@kernel.org> writes:
>>
>> > On Tue, 20 Oct 2020 02:58:23 +0200 Petr Machata wrote:
>> >> +static void dcb_ets_print_cbs(FILE *fp, const struct ieee_ets *ets)
>> >> +{
>> >> +	print_string(PRINT_ANY, "cbs", "cbs %s ", ets->cbs ? "on" : "off");
>> >> +}
>> >
>> > I'd personally lean in the direction ethtool is taking and try to limit
>> > string values in json output as much as possible. This would be a good
>> > fit for bool.
>>
>> Yep, makes sense. The value is not user-toggleable, so the on / off
>> there is just arbitrary.
>>
>> I'll consider it for "willing" as well. That one is user-toggleable, and
>> the "on" / "off" makes sense for consistency with the command line. But
>> that doesn't mean it can't be a boolean in JSON.
>
> There are three ways of representing a boolean. You chose the worst.
> Option 1: is to use a json null value to indicate presence.
>       this works well for a flag.
> Option 2: is to use json bool.
> 	this looks awkward in non-json output
> Option 3: is to use a string
>      	but this makes the string output something harder to consume
> 	in json.

What seems to be used commonly for these on/off toggles is the following
pattern:

	print_string(PRINT_FP, NULL, "willing %s ", ets->willing ? "on" : "off");
	print_bool(PRINT_JSON, "willing", NULL, true);

That way the JSON output is easy to query and the FP output is obvious
and compatible with the command line. Does that work for you?
