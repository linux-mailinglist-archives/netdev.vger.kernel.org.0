Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE34282957
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 09:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgJDHOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 03:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbgJDHOi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Oct 2020 03:14:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA6F9206B5;
        Sun,  4 Oct 2020 07:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601795676;
        bh=nxfiwjn+39b/hJ9+GCFzDel9gA6L4vHMKGgDLhmoKww=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jkWu5Xty8iAAAQiFe3mrFwWXkRKi7AWVNKjc5qGmCO3CGZ7oYj2bgbJbhfYE0kGCl
         JExjhT0Ptekx2bLsH5qZwPT7VtVYpA5AFQ/IpyTGlJKcAYx4QrCiXuby/JzBevwWNP
         j8ZTiTenIx569OdFl14FRmNz+5pZ1hOzS3WUJ2Us=
Date:   Sun, 4 Oct 2020 09:14:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Miller <davem@davemloft.net>, tuba@ece.ufl.edu
Cc:     netdev@vger.kernel.org, kuba@kernel.org, oneukum@suse.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2] net: hso: do not call unregister if not registered
Message-ID: <20201004071433.GA212114@kroah.com>
References: <20201002114323.GA3296553@kroah.com>
 <20201003.170042.489590204097552946.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201003.170042.489590204097552946.davem@davemloft.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 03, 2020 at 05:00:42PM -0700, David Miller wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
> Date: Fri, 2 Oct 2020 13:43:23 +0200
> 
> > @@ -2366,7 +2366,8 @@ static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
> >  
> >  	remove_net_device(hso_net->parent);
> >  
> > -	if (hso_net->net)
> > +	if (hso_net->net &&
> > +	    hso_net->net->reg_state == NETREG_REGISTERED)
> >  		unregister_netdev(hso_net->net);
> >  
> >  	/* start freeing */
> 
> I really want to get out of the habit of drivers testing the internal
> netdev registration state to make decisions.
> 
> Instead, please track this internally.  You know if you registered the
> device or not, therefore use that to control whether you try to
> unregister it or not.

Fair enough.  Tuba, do you want to fix this up in this way, or do you
recommend that someone else do it?

thanks,

greg k-h
