Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5890D1D20CA
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 23:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgEMVT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 17:19:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbgEMVT0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 17:19:26 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3637020575;
        Wed, 13 May 2020 21:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589404766;
        bh=M760Z5EIHmQSa1pcHuaDOrPi6Fsrsl1yv8HmTcM+LWk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l/XkmD8PhsJWAvp47ZMsX8KAG4jKWYwBEpCwLxKDV79WhfBMKp0KKkWgsxCqPkgyu
         T3BjRZOAgUGZKLxJVipHp+EIfHp/cxNj1wM0HLvBTg4GBqLyINkqGYH/xMduC+Nrja
         s5T3RCQUSf80WdPP8YlN7xPg665LbW8L2uEPvYTk=
Date:   Wed, 13 May 2020 14:19:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     davem@davemloft.net, jiri@resnulli.us, netdev@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH net-next] devlink: refactor end checks in
 devlink_nl_cmd_region_read_dumpit
Message-ID: <20200513141924.486bae36@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <022f15a5-92b2-1531-a1cc-8fe007bfcdda@intel.com>
References: <20200513172822.2663102-1-kuba@kernel.org>
        <022f15a5-92b2-1531-a1cc-8fe007bfcdda@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 May 2020 13:56:40 -0700 Jacob Keller wrote:
> > @@ -4294,8 +4289,21 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
> >  		goto out_unlock;
> >  	}
> >  
> > +	if (attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR] &&
> > +	    attrs[DEVLINK_ATTR_REGION_CHUNK_LEN]) {
> > +		if (!start_offset)
> > +			start_offset =
> > +				nla_get_u64(attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR]);
> > +
> > +		end_offset = nla_get_u64(attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR]);  
> 
> At  first, reading this confused me a bit, but it makes sense. The end
> is always "beginning + length".
> 
> If the start_offset is set before, this simply means that we needed to
> read over multiple buffers. Ok.

Yup, I just moved this from below, didn't seem bad enough to rewrite.

> > +		end_offset += nla_get_u64(attrs[DEVLINK_ATTR_REGION_CHUNK_LEN]);
> > +	}
> > +
> > +	if (end_offset > region->size)
> > +		end_offset = region->size;
> > +
> >  	/* return 0 if there is no further data to read */
> > -	if (start_offset >= region->size) {
> > +	if (start_offset == end_offset) {  
> 
> Why change this to ==? isn't it possible to specify a start_offset that
> is out of bounds? I think this should still be >=

See 5 lines above :) I moved the capping of end_offset from
devlink_nl_region_read_snapshot_fill() to here. We can keep
it greater equal, but that reads a little defensive.

> >  		err = 0;
> >  		goto out_unlock;
> >  	}
