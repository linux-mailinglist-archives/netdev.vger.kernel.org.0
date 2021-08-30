Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E343FBF6F
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 01:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238988AbhH3XaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 19:30:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237832AbhH3XaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 19:30:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 803B260FC0;
        Mon, 30 Aug 2021 23:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630366150;
        bh=xq8XScnmTK4fr9P3i7S760aCutNMN+7LDzGhcmVTh4s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aprqEKThxV+fIq/CmJneljvgQ33CjmgOaY7cZuBQkpsGCkoENprHmGElGAfxTWEQq
         CRWRsd1Pjyqdh+3a9EtrIA94B7Slf0p2QkFhkDUYiVsvTIe4sueBas55hGulzNscmb
         DM7d8pAIL630qA2N3o8QN/vsWQntuZUIWxayfp9Q8GT342bxUE5u8aDitg10EYF1ey
         cUIcR2zkOJQiGK3QgB8Q1sqhkmYNyB3BYKnB+xlFU9oD3ohYBLCcjOUJRydYfMGOxG
         9mfzbPSyPXTFoeMtuZ30jYzKikRxJjhfS7nZrPPZtqmnhYLINFHuZh2xmJbYF4ZW0p
         3R0j2vPi4KehQ==
Date:   Mon, 30 Aug 2021 16:29:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        bsd@fb.com
Subject: Re: [RFC v2 net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
 message to get SyncE status
Message-ID: <20210830162909.110753ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210830205758.GA26230@hoboy.vegasvil.org>
References: <20210829080512.3573627-1-maciej.machnikowski@intel.com>
        <20210829080512.3573627-2-maciej.machnikowski@intel.com>
        <20210829151017.GA6016@hoboy.vegasvil.org>
        <PH0PR11MB495126A63998DABA5B5DE184EACA9@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210830205758.GA26230@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Aug 2021 13:57:58 -0700 Richard Cochran wrote:
> > Please take a look at the 10.2 Operation modes of the G.8264 and at the Figure A.1
> > which depicts the EEC. This interface is to report the status of the EEC.  
> 
> Well, I read it, and it is still fairly high level with no mention at
> all of "DPLL".  I hope that the new RTNL states will cover other
> possible EEC implementations, too.
> 
> The "Reference source selection mechanism" is also quite vague.  Your
> patch is more specific:
> 
> +enum if_eec_src {
> +       IF_EEC_SRC_INVALID = 0,
> +       IF_EEC_SRC_UNKNOWN,
> +       IF_EEC_SRC_SYNCE,
> +       IF_EEC_SRC_GNSS,

Hmm, IDK if this really belongs in RTNL. The OCP time card that
Jonathan works on also wants to report signal lock, and it locks
to GNSS. It doesn't have any networking functionality whatsoever.

Can we add a genetlink family for clock info/configuration? From 
what I understood discussing this with Jonathan it sounded like most
clocks today have a vendor-specific character device for configuration
and reading status.

I'm happy to write the plumbing if this seems like an okay idea 
but too much work for anyone to commit.

> +       IF_EEC_SRC_PTP,
> +       IF_EEC_SRC_EXT,
> +       __IF_EEC_SRC_MAX,
> +};
> 
> But I guess your list is reasonable.  It can always be expanded, right?
