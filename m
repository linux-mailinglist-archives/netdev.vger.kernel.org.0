Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500C460D4C9
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 21:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbiJYTiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 15:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiJYTit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 15:38:49 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C24F419A;
        Tue, 25 Oct 2022 12:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666726729; x=1698262729;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OYfu/Ih3RtDuymYcrXVSOOOZhD0CiItWCsuhin+KdPw=;
  b=SjMbf8/ro4jC5Hdp69h0QQPZirfeG96hZAbhckwkIU5axcNiGMNjig30
   74oI1W8FoKxQ7oLRCLcS6t6HbE7rj4pfJGsWz5txqNpDBxdCQ6VGpCPVf
   crfRsWJVgXSaosbDyr3l5/cjkIKQIk4TporPrXsrgkvhJ/IxjJvBn97G+
   vLY67RrJ0bteUc4SX1harK61g6de3+8wMvO/6u8lbLlSDWxr3dU0+qFIV
   iFtahP9bN1MGKL/3vr34JcJzhoQDuk4Ao9hogQQKDKxDO11tlUk2E6pkM
   mFPagZ2ijDAhKZRDp7bM4BYC6frqlO+EC0bRC9KvB1qPpjg6Kvj0+rgK3
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="369840837"
X-IronPort-AV: E=Sophos;i="5.95,212,1661842800"; 
   d="scan'208";a="369840837"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 12:38:48 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="736954700"
X-IronPort-AV: E=Sophos;i="5.95,212,1661842800"; 
   d="scan'208";a="736954700"
Received: from swatthag-mobl1.amr.corp.intel.com (HELO desk) ([10.209.27.104])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 12:38:47 -0700
Date:   Tue, 25 Oct 2022 12:38:45 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     scott.d.constable@intel.com, daniel.sneddon@linux.intel.com,
        Jakub Kicinski <kuba@kernel.org>, dave.hansen@intel.com,
        Johannes Berg <johannes@sipsolutions.net>,
        Paolo Abeni <pabeni@redhat.com>,
        antonio.gomez.iglesias@linux.intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, gregkh@linuxfoundation.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Branch Target Injection (BTI) gadget in minstrel
Message-ID: <20221025193845.z7obsqotxi2yiwli@desk>
References: <cover.1666651511.git.pawan.kumar.gupta@linux.intel.com>
 <Y1fDiJtxTe8mtBF8@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y1fDiJtxTe8mtBF8@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 01:07:52PM +0200, Peter Zijlstra wrote:
>On Mon, Oct 24, 2022 at 03:57:45PM -0700, Pawan Gupta wrote:
>
>> The other goal of this series is to start a discussion on whether such
>> hard to exploit, but theoretical possible attacks deems to be mitigated.
>>
>> In general Branch Target Injection class of attacks involves an adversary
>> controlling an indirect branch target to misspeculate to a disclosure gadget.
>> For a successful attack an adversary also needs to control the register
>> contents used by the disclosure gadget.
>
>I'm thinking this is going about it wrong. You're going to be randomly
>sprinking LFENCEs around forever if you go down this path making stuff
>slower and slower.

Right, an alternative to LFENCE is to mask the indexes(wherever
possible) for gadgets that are called frequently. But still its not a
clean solution.

>Not to mention that it's going to bitrot; the function might change but
>the LFENCE will stay, protecting nothing but still being slow.

Totally agree with this.

>I think the focus should be on finding the source sites, not protecting
>the target sites. Where can an attacker control the register content and
>have an indirect jump/call.

That is an interesting approach. I am wondering what mitigation can
be applied at source? LFENCE before an indirect branch can greatly
reduce the speculation window, but will not completely eliminate it.
Also LFENCE at sources could be costlier than masking the indexes at
targets or LFENCE at the targets.

>Also, things like FineIBT will severely limit the viability of all this.

Yes.

>And how is sprinking random LFENCEs around better than running with
>spectre_v2=eibrs,retpoline which is the current recommended mitigation
>against all this IIRC (or even eibrs,lfence for lesser values of
>paranoia).

Its a trade-off between performance and spot fixing (hopefully handful
of) gadgets. Even the gadget in question here is not demonstrated to be
exploitable. If this scenario changes, polluting the kernel all over is
definitely not the right approach.
