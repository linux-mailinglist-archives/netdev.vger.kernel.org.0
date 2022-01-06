Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BADF486B7E
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 21:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244030AbiAFU6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 15:58:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244010AbiAFU6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 15:58:21 -0500
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB18C061245
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 12:58:21 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1641502699; bh=C9BcoSH0YjwnNI0VjYApNu89dU1pl2HGWnHRp7HWhAg=;
        h=From:To:Subject:In-Reply-To:References:Date:From;
        b=DsdFeWPaRgGlp0o2NmZhOKBDw1qe38YBCvogKpfJTlOEWO0J0I/z25W6lp2lti4jo
         lNqvGVlmSQcIwGclMm0kDll9ZHM4xLbFSBpWRjwt7U2E0Wu9gOnXqsbY3g2hSrMD36
         IoACHMtPddXjpeZGKYfumFGJZD/rXSEMKIZ+p2iGCplcLQ5+ifXpNAEiEcD/lPAbO7
         HGivjakn8pOBLKOexhcTRn5WWtV+uIfobWaX50P29tF/0WJ2zx4T1CyI8cmXgZyPrk
         DRjdbQJ/+m/4agulz8vJh6xXGQSCY6J4NlCACFU55fgjyvbG8O6RaBMSn66mE+mCYu
         g9972LOfbGyVw==
To:     Kevin Bracey <kevin@bracey.fi>, netdev@vger.kernel.org
Subject: Re: [PATCH net] sch_cake: revise Diffserv docs
In-Reply-To: <20220105203554.2371666-1-kevin@bracey.fi>
References: <20220105203554.2371666-1-kevin@bracey.fi>
Date:   Thu, 06 Jan 2022 21:58:19 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87h7aga8es.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kevin Bracey <kevin@bracey.fi> writes:

> Documentation incorrectly stated that CS1 is equivalent to LE for
> diffserv8. But when LE was added to the table, CS1 was pushed into tin
> 1, leaving only LE in tin 0.
>
> Also "TOS1" no longer exists, as that is the same codepoint as LE.
>
> Make other tweaks properly distinguishing codepoints from classes and
> putting current Diffserve codepoints ahead of legacy ones.
>
> Signed-off-by: Kevin Bracey <kevin@bracey.fi>

Thank you for the fix. A few comments below. I'm on the fence as to
whether this should be a fix against -net, or if it's better to just
target net-next. If you do think it should go into -net as a fix, please
add an appropriate Fixes tag, probably:

Fixes: b8392808eb3f ("sch_cake: add RFC 8622 LE PHB support to CAKE diffserv handling")

> ---
>  net/sched/sch_cake.c | 40 ++++++++++++++++++++--------------------
>  1 file changed, 20 insertions(+), 20 deletions(-)
>
> diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
> index 857aaebd49f4..64692414c0e5 100644
> --- a/net/sched/sch_cake.c
> +++ b/net/sched/sch_cake.c
> @@ -2342,9 +2342,7 @@ static int cake_config_precedence(struct Qdisc *sch)
>  
>  /*	List of known Diffserv codepoints:
>   *
> - *	Least Effort (CS1, LE)
> - *	Best Effort (CS0)
> - *	Max Reliability & LLT "Lo" (TOS1)
> + *	Default Forwarding (DF/CS0)

I'm fine with adding the Default Forwarding designation, but please keep
the "Best Effort" moniker as well; it's commonly used in colloquial
speech, so I'd like to keep it here for people who go looking.

>   *	Max Throughput (TOS2)
>   *	Min Delay (TOS4)
>   *	LLT "La" (TOS5)
> @@ -2352,6 +2350,7 @@ static int cake_config_precedence(struct Qdisc *sch)
>   *	Assured Forwarding 2 (AF2x) - x3
>   *	Assured Forwarding 3 (AF3x) - x3
>   *	Assured Forwarding 4 (AF4x) - x3
> + *	Precedence Class 1 (CS1)
>   *	Precedence Class 2 (CS2)
>   *	Precedence Class 3 (CS3)
>   *	Precedence Class 4 (CS4)
> @@ -2360,8 +2359,9 @@ static int cake_config_precedence(struct Qdisc *sch)
>   *	Precedence Class 7 (CS7)
>   *	Voice Admit (VA)
>   *	Expedited Forwarding (EF)
> -
> - *	Total 25 codepoints.
> + *	Lower Effort (LE)
> + *
> + *	Total 26 codepoints.
>   */
>  
>  /*	List of traffic classes in RFC 4594, updated by RFC 8622:
> @@ -2375,12 +2375,12 @@ static int cake_config_precedence(struct Qdisc *sch)
>   *	Realtime Interactive (CS4)     - eg. games
>   *	Multimedia Streaming (AF3x)    - eg. YouTube, NetFlix, Twitch
>   *	Broadcast Video (CS3)
> - *	Low Latency Data (AF2x,TOS4)      - eg. database
> - *	Ops, Admin, Management (CS2,TOS1) - eg. ssh
> - *	Standard Service (CS0 & unrecognised codepoints)
> - *	High Throughput Data (AF1x,TOS2)  - eg. web traffic
> - *	Low Priority Data (CS1,LE)        - eg. BitTorrent
> -
> + *	Low-Latency Data (AF2x,TOS4)      - eg. database
> + *	Ops, Admin, Management (CS2)      - eg. ssh
> + *	Standard Service (DF & unrecognised codepoints)
> + *	High-Throughput Data (AF1x,TOS2)  - eg. web traffic
> + *	Low-Priority Data (LE,CS1)        - eg. BitTorrent
> + *
>   *	Total 12 traffic classes.
>   */
>  
> @@ -2390,12 +2390,12 @@ static int cake_config_diffserv8(struct Qdisc *sch)
>   *
>   *		Network Control          (CS6, CS7)
>   *		Minimum Latency          (EF, VA, CS5, CS4)
> - *		Interactive Shell        (CS2, TOS1)
> + *		Interactive Shell        (CS2)
>   *		Low Latency Transactions (AF2x, TOS4)
>   *		Video Streaming          (AF4x, AF3x, CS3)
> - *		Bog Standard             (CS0 etc.)
> - *		High Throughput          (AF1x, TOS2)
> - *		Background Traffic       (CS1, LE)
> + *		Bog Standard             (DF etc.)
> + *		High Throughput          (AF1x, TOS2, CS1)
> + *		Background Traffic       (LE)
>   *
>   *		Total 8 traffic classes.
>   */
> @@ -2437,9 +2437,9 @@ static int cake_config_diffserv4(struct Qdisc *sch)
>  /*  Further pruned list of traffic classes for four-class system:
>   *
>   *	    Latency Sensitive  (CS7, CS6, EF, VA, CS5, CS4)
> - *	    Streaming Media    (AF4x, AF3x, CS3, AF2x, TOS4, CS2, TOS1)
> - *	    Best Effort        (CS0, AF1x, TOS2, and those not specified)
> - *	    Background Traffic (CS1, LE)
> + *	    Streaming Media    (AF4x, AF3x, CS3, AF2x, TOS4, CS2)
> + *	    Best Effort        (DF, AF1x, TOS2, and those not specified)
> + *	    Background Traffic (LE, CS1)
>   *
>   *		Total 4 traffic classes.
>   */
> @@ -2477,9 +2477,9 @@ static int cake_config_diffserv4(struct Qdisc *sch)
>  static int cake_config_diffserv3(struct Qdisc *sch)
>  {
>  /*  Simplified Diffserv structure with 3 tins.
> - *		Low Priority		(CS1, LE)
> + *		Low Priority		(LE, CS1)
>   *		Best Effort
> - *		Latency Sensitive	(TOS4, VA, EF, CS6, CS7)
> + *		Latency Sensitive	(CS7, CS6, EF, VA, TOS4)

While you're fixing things up, could you please also swap the order of
the lines here, so it goes from high-to-low priority like the others?

-Toke
