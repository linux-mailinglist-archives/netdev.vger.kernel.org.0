Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29EFB283F97
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 21:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbgJETZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 15:25:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgJETZr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 15:25:47 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40113207EA;
        Mon,  5 Oct 2020 19:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601925946;
        bh=6KOeAriQkvjlghW2MUYSa0a+9SmiJLuFl6G9X4YLLBs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Lk/eYpNZVfuTf1agoT2lkWy0z0erXmIc0OmwPNO2zJk1shYA22OJ2b35HjKM75DBK
         aylvs6PJoQ0effiysx9jKpTo6FWRHdKh6yY7UlfytZpAqXwwY4muUPHXW+gCnT978a
         dX1mnU6CG3+J7pZ0VMYUQPlDSkiLWgK01A2yM0Ik=
Date:   Mon, 5 Oct 2020 12:25:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        jiri@resnulli.us, andrew@lunn.ch, mkubecek@suse.cz
Subject: Re: [PATCH net-next 6/6] ethtool: specify which header flags are
 supported per command
Message-ID: <20201005122544.70aad7f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1dc47668cc015c5a1bff10072e64e55a3436cbb7.camel@sipsolutions.net>
References: <20201005155753.2333882-1-kuba@kernel.org>
        <20201005155753.2333882-7-kuba@kernel.org>
        <1dc47668cc015c5a1bff10072e64e55a3436cbb7.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 05 Oct 2020 20:58:57 +0200 Johannes Berg wrote:
> On Mon, 2020-10-05 at 08:57 -0700, Jakub Kicinski wrote:
> > 
> > @@ -47,19 +61,16 @@ int ethnl_parse_header_dev_get(struct ethnl_req_info *req_info,
> >  		NL_SET_ERR_MSG(extack, "request header missing");
> >  		return -EINVAL;
> >  	}
> > +	/* Use most permissive header policy here, ops should specify their
> > +	 * actual header policy via NLA_POLICY_NESTED(), and the real
> > +	 * validation will happen in genetlink code.
> > +	 */
> >  	ret = nla_parse_nested(tb, ETHTOOL_A_HEADER_MAX, header,
> > -			       ethnl_header_policy, extack);
> > +			       ethnl_header_policy_stats, extack);  
> 
> Would it make sense to just remove the validation here? It's already
> done, so it just costs extra cycles and can't really fail, and if there
> are more diverse policies in the future this might also very quickly get
> out of hand?

I was slightly worried I missed a command and need last line of defence,
but you're right, I'll just pass a NULL for the policy in v2 :)
