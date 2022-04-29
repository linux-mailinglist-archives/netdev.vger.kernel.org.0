Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A092051411A
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 05:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236582AbiD2DmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 23:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236224AbiD2DmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 23:42:18 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDEBA5E9A
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 20:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651203541; x=1682739541;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=hbI67oUZUKEUm3P+EJ8M8Uh3g2wNFyH+0FXYQT3fUko=;
  b=a5obPdzK/1iAFvrsvnU+CSo8Fopjg2DDYWyB5y8VJaREhczXgisYkXbA
   SFI/Wg+qT8koZ4g6TMwHSFZCYP0adHMTSQK939OwCKYPFj+TXKaR97qPZ
   mPA50PGdoBYQVkd4zYEKgh2TFbOIAXVVrz+qEWlbnuwAOiV/res1nS7TR
   Petc+XkIhbG1n+YJgdqCmuM3Y4N8BvywUoLrHRhAIxUpYJSQbGYkYTHP6
   WzI5NSGDNcGXkdGivKVS63/eRiQRG20rm5CEW6Kw/STAbb5wTqMDM9tuc
   fD20wsdPpKuOiffMOW/SLaHwQs8Jaro+OXZAvhdnbjSZIJ+r0T0Aj1gmi
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="291685473"
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="291685473"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 20:39:01 -0700
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="560073529"
Received: from davideli-mobl.amr.corp.intel.com ([10.209.69.78])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 20:39:01 -0700
Date:   Thu, 28 Apr 2022 20:39:01 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: Re: [PATCH net-next 0/6] mptcp: Path manager mode selection
In-Reply-To: <20220428185739.39cdbb33@kernel.org>
Message-ID: <23ff3b49-2563-1874-fa35-3af55d3088e7@linux.intel.com>
References: <20220427225002.231996-1-mathew.j.martineau@linux.intel.com> <20220428185739.39cdbb33@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu, 28 Apr 2022, Jakub Kicinski wrote:

> On Wed, 27 Apr 2022 15:49:56 -0700 Mat Martineau wrote:
>> MPTCP already has an in-kernel path manager (PM) to add and remove TCP
>> subflows associated with a given MPTCP connection. This in-kernel PM has
>> been designed to handle typical server-side use cases, but is not very
>> flexible or configurable for client devices that may have more
>> complicated policies to implement.
>>
>> This patch series from the MPTCP tree is the first step toward adding a
>> generic-netlink-based API for MPTCP path management, which a privileged
>> userspace daemon will be able to use to control subflow
>> establishment. These patches add a per-namespace sysctl to select the
>> default PM type (in-kernel or userspace) for new MPTCP sockets. New
>> self-tests confirm expected behavior when userspace PM is selected but
>> there is no daemon available to handle existing MPTCP PM events.
>>
>> Subsequent patch series (already staged in the MPTCP tree) will add the
>> generic netlink path management API.
>
> Could you link to those patches, maybe? Feels a little strange to add
> this sysctl to switch to user space mode now, before we had a chance
> to judg^W review the netlink interface.
>

Hi Jakub -

Sure, no problem. If you'd prefer a pull request for this feature as a 
whole I could stage that.

Here's a tag (note: do not merge this as-is, the committer ids and full 
history aren't suitable) -> 
https://github.com/multipath-tcp/mptcp_net-next/commits/netdev-review-userspace-path-manager

The last 26 commits there cover the full userspace path manager kernel 
code, with the first 6 of those being this series.

Userspace path managers makes use of generic netlink MPTCP events that 
have already been upstream for a while, and the full series adds four 
netlink commands for userspace:

* MPTCP_PM_CMD_ANNOUNCE: advertise an address that's available for 
additional subflow connections.

* MPTCP_PM_CMD_REMOVE: revoke an advertisement

* MPTCP_PM_CMD_SUBFLOW_CREATE: initiate a new subflow on an existing MPTCP 
connection

* MPTCP_PM_CMD_SUBFLOW_DESTROY: close a subflow on an existing MPTCP 
connection

There's one commit for each command, each with an obvious title ("mptcp: 
netlink: Add MPTCP_PM_CMD_<name>")


> Does the pm_type switch not fit more neatly into the netlink interface
> itself?

We (on the MPTCP ML) did discuss that as a design option, and landed on 
the sysctl.

The stack can handle having no userspace PM daemon present since MPTCP 
connections can still be initiated without the PM and operate in single 
subflow mode at first. When the daemon starts up later it can manage the 
existing sockets and start announcing addresses or adding subflows. We 
wanted to avoid accidentally ending up with a mix of kernel-PM-managed and 
userspace-PM-managed sockets depending on when the daemon loaded.

Userspace PM daemons could depend on carrier policy or other complex 
dependencies, so it made sense to allow setting the sysctl early and leave 
more flexibility for launching the daemon later.

--
Mat Martineau
Intel
