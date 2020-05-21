Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B90271DD3A8
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbgEURCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:02:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728581AbgEURCS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 13:02:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2361F207F7;
        Thu, 21 May 2020 17:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590080537;
        bh=wDiA74+rTfqPS90oH60fYDdJ95Pmx+8UHFq1uqnf1/w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dZyU1emoIop7B2NTpQrMyCsxxp08NtUernMRjpQTi68yPU/EwpZ2vIHb7MNLj2doH
         rqwLfkrDSEGQUS6MkBLyKkJgLvfF7eeOIpJaDNtw1WFSwRHx8dq505jG4UpRvEN379
         3b9RrJtsV98PLdLYtO0S1XRMbF77YnChQfgrmi1M=
Date:   Thu, 21 May 2020 10:02:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Edward Cree <ecree@solarflare.com>, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        jiri@resnulli.us, dcaratti@redhat.com, marcelo.leitner@gmail.com
Subject: Re: [PATCH net-next v2 0/4] Implement classifier-action terse dump
 mode
Message-ID: <20200521100214.700348e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <vbf1rndz76r.fsf@mellanox.com>
References: <20200515114014.3135-1-vladbu@mellanox.com>
        <649b2756-1ddf-2b3e-cd13-1c577c50eaa2@solarflare.com>
        <vbf1rndz76r.fsf@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 May 2020 17:36:12 +0300 Vlad Buslov wrote:
> Hi Edward, Cong,
> 
> On Mon 18 May 2020 at 18:37, Edward Cree <ecree@solarflare.com> wrote:
> > On 15/05/2020 12:40, Vlad Buslov wrote:  
> >> In order to
> >> significantly improve filter dump rate this patch sets implement new
> >> mode of TC filter dump operation named "terse dump" mode. In this mode
> >> only parameters necessary to identify the filter (handle, action cookie,
> >> etc.) and data that can change during filter lifecycle (filter flags,
> >> action stats, etc.) are preserved in dump output while everything else
> >> is omitted.  
> > I realise I'm a bit late, but isn't this the kind of policy that shouldn't
> >  be hard-coded in the kernel?  I.e. if next year it turns out that some
> >  user needs one parameter that's been omitted here, but not the whole dump,
> >  are they going to want to add another mode to the uapi?
> > Should this not instead have been done as a set of flags to specify which
> >  pieces of information the caller wanted in the dump, rather than a mode
> >  flag selecting a pre-defined set?
> >
> > -ed  
> 
> I've been thinking some more about this. While the idea of making
> fine-grained dump where user controls exact contents field-by-field is
> unfeasible due to performance considerations, we can try to come up with
> something more coarse-grained but not fully hardcoded (like current terse
> dump implementation). Something like having a set of flags that allows
> to skip output of groups of attributes.
> 
> For example, CLS_SKIP_KEY flag would skip the whole expensive classifier
> key dump without having to go through all 200 lines of conditionals in

Do you really need to dump classifiers? If you care about stats 
the actions could be sufficient if the offload code was fixed
appropriately... Sorry I had to say that.

> fl_dump_key() while ACT_SKIP_OPTIONS would skip outputting TCA_OPTIONS
> compound attribute (and expensive call to tc_action_ops->dump()). This
> approach would also leave the door open for further more fine-grained
> flags, if the need arises. For example, new flags
> CLS_SKIP_KEY_{L2,L3,L4} can be introduced to more precisely control
> which parts of cls key should be skipped.

L2, L3, etc. will be meaningless for a lot of classifiers.

> The main drawback of such approach is that it is impossible to come up
> with universal set of flags that would be applicable for all
> classifiers. Key (in some form) is applicable to most classifiers, but
> it still doesn't make sense for matchall or bpf. Some classifiers have
> 'flags', some don't. Hardware-offloaded classifiers have in_hw_count.
> Considering this, initial set of flags will be somewhat flower-centric.
> 
> What do you think?

Simplest heuristic is to dump everything that can't get changed without
a notification. Which I think you're quite close to already..
