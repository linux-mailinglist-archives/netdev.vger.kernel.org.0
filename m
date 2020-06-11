Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DA71F69BB
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 16:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgFKONo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 10:13:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbgFKONo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 10:13:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECB812083E;
        Thu, 11 Jun 2020 14:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591884823;
        bh=0kiUXeRTZ66L3vUIP0L9Xwoi5v+ZUuZDVVJDelcBnp0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dVaGBquUHsmhWX/kn/9h9/JaM05ooLcC2/xQJKi+feAgsBmhaRhYQkpz/UsCny/SI
         xUSVWtgbUqQa5Kv6njM5l0LjIpcq1gLFDKjxEj/LAdGx0y0ZO0+sDnzZjTY89YRYO2
         h3F8Nm778TKQSUW78UgkXsQravd7KrXAqunDowv8=
Date:   Thu, 11 Jun 2020 16:13:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Chen Wandun <chenwandun@huawei.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Cheng Jian <cj.chengjian@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] perf tools: Fix potential memory leak in perf events
 parser
Message-ID: <20200611141337.GB1134057@kroah.com>
References: <ea548157-5cb0-ffa7-9bd5-ff3f9c66b1de@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ea548157-5cb0-ffa7-9bd5-ff3f9c66b1de@web.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 11, 2020 at 03:17:17PM +0200, Markus Elfring wrote:
> > Fix potential memory leak in function parse_events_term__sym_hw()
> > and parse_events_term__clone().
> 
> Would you like to add the tag “Fixes” to the commit message?
> 
> 
> …
> > +++ b/tools/perf/util/parse-events.c
> …
> > @@ -2957,9 +2958,20 @@  int parse_events_term__sym_hw(struct parse_events_term **term,
> >  	sym = &event_symbols_hw[idx];
> >
> >  	str = strdup(sym->symbol);
> > -	if (!str)
> > +	if (!str) {
> > +		if (!config)
> > +			free(temp.config);
> >  		return -ENOMEM;
> > -	return new_term(term, &temp, str, 0);
> > +	}
> > +
> > +	ret = new_term(term, &temp, str, 0);
> > +	if (ret < 0) {
> > +		free(str);
> > +		if (!config)
> > +			free(temp.config);
> > +	}
> > +
> > +	return ret;
> >  }
> …
> 
> How do you think about to add jump targets for a bit of
> common exception handling code in these function implementations?


Hi,

This is the semi-friendly patch-bot of Greg Kroah-Hartman.

Markus, you seem to have sent a nonsensical or otherwise pointless
review comment to a patch submission on a Linux kernel developer mailing
list.  I strongly suggest that you not do this anymore.  Please do not
bother developers who are actively working to produce patches and
features with comments that, in the end, are a waste of time.

Patch submitter, please ignore Markus's suggestion; you do not need to
follow it at all.  The person/bot/AI that sent it is being ignored by
almost all Linux kernel maintainers for having a persistent pattern of
behavior of producing distracting and pointless commentary, and
inability to adapt to feedback.  Please feel free to also ignore emails
from them.

thanks,

greg k-h's patch email bot
