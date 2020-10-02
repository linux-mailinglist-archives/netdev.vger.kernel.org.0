Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B56281882
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 19:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387934AbgJBRDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 13:03:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbgJBRDP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 13:03:15 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 165E920758;
        Fri,  2 Oct 2020 17:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601658195;
        bh=TznxtBp7+DoJN7xfCueA14ScCRn/KHnXlyNKI+6ynKg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RNxvPeaSEJ6ctf7E3cuwWpKuZFL/hOdcKYmx+tkNFEVrQFZp38Ah38NxebFeRK1AK
         0jqBE4JKK38sLV+elQyw7QDKxDClCdQ4eqnL9baE+CT3YnbHafos4l9jndZ8HgOa3s
         BdFD9qjxw0YGZhdnMyLi76f8+qkPIzNqg036zZtY=
Message-ID: <cda8be83538b9cac786b12ea8324248e88f62be1.camel@kernel.org>
Subject: Re: [net V2 05/15] net/mlx5: Add retry mechanism to the command
 entry index allocation
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Date:   Fri, 02 Oct 2020 10:03:14 -0700
In-Reply-To: <20201001162336.45f552b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201001195247.66636-1-saeed@kernel.org>
         <20201001195247.66636-6-saeed@kernel.org>
         <20201001162336.45f552b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-01 at 16:23 -0700, Jakub Kicinski wrote:
> On Thu,  1 Oct 2020 12:52:37 -0700 saeed@kernel.org wrote:
> > +static int cmd_alloc_index_retry(struct mlx5_cmd *cmd)
> > +{
> > +	unsigned long alloc_end = jiffies + msecs_to_jiffies(1000);
> > +	int idx;
> > +
> > +retry:
> > +	idx = cmd_alloc_index(cmd);
> > +	if (idx < 0 && time_before(jiffies, alloc_end)) {
> > +		/* Index allocation can fail on heavy load of commands.
> > This is a temporary
> > +		 * situation as the current command already holds the
> > semaphore, meaning that
> > +		 * another command completion is being handled and it
> > is expected to release
> > +		 * the entry index soon.
> > +		 */
> > +		cond_resched();
> > +		goto retry;
> > +	}
> > +	return idx;
> > +}
> 
> This looks excessive. At least add some cpu_relax(), or udelay()?

cpu_relax() should also work fine, it is just that we have 100%
certainty that the allocation will success real soon.

