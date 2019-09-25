Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1FBBE361
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 19:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442924AbfIYRbL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 25 Sep 2019 13:31:11 -0400
Received: from mga12.intel.com ([192.55.52.136]:5238 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbfIYRbL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 13:31:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 10:31:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,548,1559545200"; 
   d="scan'208";a="390293772"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.82])
  by fmsmga006.fm.intel.com with ESMTP; 25 Sep 2019 10:31:10 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     "Guedes\, Andre" <andre.guedes@intel.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "jhs\@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong\@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri\@resnulli.us" <jiri@resnulli.us>,
        "davem\@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net v3] net/sched: cbs: Fix not adding cbs instance to list
In-Reply-To: <99755D97-F59A-4E68-87AE-6CE88EDE66A3@intel.com>
References: <20190924050458.14223-1-vinicius.gomes@intel.com> <99755D97-F59A-4E68-87AE-6CE88EDE66A3@intel.com>
Date:   Wed, 25 Sep 2019 10:31:45 -0700
Message-ID: <87d0fo8epq.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andre,

"Guedes, Andre" <andre.guedes@intel.com> writes:

> Hi Vinicius,
>
>> On Sep 23, 2019, at 10:04 PM, Vinicius Costa Gomes <vinicius.gomes@intel.com> wrote:
>> 
>> The problem happens because that when offloading is enabled, the cbs
>> instance is not added to the list.
>> 
>> Also, the current code doesn't handle correctly the case when offload
>> is disabled without removing the qdisc: if the link speed changes the
>> credit calculations will be wrong. When we create the cbs instance
>> with offloading enabled, it's not added to the notification list, when
>> later we disable offloading, it's not in the list, so link speed
>> changes will not affect it.
>> 
>> The solution for both issues is the same, add the cbs instance being
>> created unconditionally to the global list, even if the link state
>> notification isn't useful "right now".
>
> I believe we could fix both issues described above and still don’t
> notify the qdisc about link state if we handled the list
> insertion/removal in cbs_change() instead.
>
> Reading the cbs code more carefully, it seems it would be beneficial
> to refactor the offload handling. For example, we currently init the
> qdisc_watchdog even if it’s not useful when offload is enabled. Now,
> we’re going to notify the qdisc even if it’s not useful too.

I like your idea, but even after reading your email and the code a
couple of times, I couldn't come up with anything quickly that wouldn't
complicate things (i.e. add more code), I would need to experiment a
bit. (btw, qdisc_watchdog_init() is just initializing some fields in a
struct, and the notification part should be quite rare in practice).

So my suggestion is to keep this patch as is, as it solves a real crash
that a colleague faced. Later, we can try and simplify things even more.

Cheers,
--
Vinicius

P.S.: I think I am still a bit traumatized but getting the init() and
destroy() right were the hardest parts when we were trying to uptream
this. That's why I am hesitant about adding more code to those flows.
