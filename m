Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 862A9EABD
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 21:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbfD2TOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 15:14:55 -0400
Received: from mail.us.es ([193.147.175.20]:34022 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729054AbfD2TOz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 15:14:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 11B2CB6C64
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 21:14:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F3431DA70D
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 21:14:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E8726DA709; Mon, 29 Apr 2019 21:14:52 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B5289DA704;
        Mon, 29 Apr 2019 21:14:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 29 Apr 2019 21:14:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 900074265A31;
        Mon, 29 Apr 2019 21:14:50 +0200 (CEST)
Date:   Mon, 29 Apr 2019 21:14:50 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: TC stats / hw offload question
Message-ID: <20190429191450.kzhhe3zqnbt6f2ap@salvia>
References: <ec4092a6-196d-7eca-04be-0654e762c0b2@solarflare.com>
 <20190424141139.5c5vhihie5mryxlt@salvia>
 <26afcaaf-abdf-42ad-1715-5af9c6f3c2ef@solarflare.com>
 <58c74d0f-b92e-31f9-9828-24fb04129534@solarflare.com>
 <20190425223346.zqfadtphmhuj7ohp@salvia>
 <e09faf92-c947-5b98-78d3-a37a28c0fc59@solarflare.com>
 <20190426184943.idewf2rqebvslcva@salvia>
 <97133878-8e78-287b-9854-431b116b0788@solarflare.com>
 <20190429152128.4mbqyipjv25jiiko@salvia>
 <e30859ad-a4e9-b0fb-f37d-4e8dcf638fdb@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e30859ad-a4e9-b0fb-f37d-4e8dcf638fdb@solarflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 05:25:10PM +0100, Edward Cree wrote:
> On 29/04/2019 16:21, Pablo Neira Ayuso wrote:
> > On Mon, Apr 29, 2019 at 03:11:06PM +0100, Edward Cree wrote:
> >> This is a bit of a mess; the best idea I've got is for the
> >>  TC_CLSFLOWER_STATS call to include a tcfa_index.  Then the driver
> >>  returns counter stats for that index, and tcf_exts_stats_update()
> >>  only updates those actions whose index matches.  But then
> >>  fl_hw_update_stats() would have to iterate over all the indices in
> >>  f->exts.  What do you think?
> > You could extend struct flow_stats to pass an array of stats to the
> > driver, including one stats per action and the counter index. Then,
> > tcf_exts_stats_update() uses this array of stats to update per-action
> > stats.
> Yes, but that means allocating the flow_stats.stats array each time;

We use the stack to attach a reasonable size array, eg. 16 actions,
otherwise fall back to kmalloc(). I haven't seen any driver in the
tree supporting more than that so far.

>  I'd rather avoid memory allocation unless it's necessary.  As long as
>  we can move the preempt_disable() inside the loop that's currently in
>  tcf_exts_stats_update() (i.e. only disable pre-emption across each
>  individual call to tcf_action_stats_update()) I think we can.
> I think I prefer my approach (ask for one tcfa_index at a time); but
>  unmodified drivers that don't look at the passed index would return
>  zeroes for actions after the first, so we'll need some way to handle
>  those drivers separately (e.g. one tc_setup_cb_call with "answer
>  this one if you don't do indices" and a bunch more with specified
>  index values).  I think that requires much less change to the
>  existing drivers than putting an array back in the API, and keeps as
>  much of the work as possible in the core where it won't have to be
>  replicated in every driver.

That's all right. This chunk update will not be particularly large, so
we can change it anytime in the future.

> I'll put an RFC patch together soonish if no objections.

Sure, thanks.
