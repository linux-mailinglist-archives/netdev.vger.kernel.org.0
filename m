Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AC72E9C5F
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 18:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbhADRuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 12:50:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:38394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727705AbhADRuT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 12:50:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABAB220700;
        Mon,  4 Jan 2021 17:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609782578;
        bh=kcC2aLb/ydX3DXhUhdQu9GtQt3MXFKclngl0J6ZWr+M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l+h+ExBCp5rH++ji0sfQxXe09hRHGj/L96JaFdGDkpx1bwBSwYeHjhFZB+Zx8FWBS
         KDsTHrt3d2bub7avUjZeoQ2dtnkaVVa4za6D/hf93A5H7ircv9curo4mnOBzvWNm97
         bYm2tTb6is+9bjZq0t4Hs2dlh1GwIaHE/5QfFyswOul/4LT7nRw+peKRKzz5aZks0K
         0wyi8UpoYkAjpbRu6hKRMbRV+/R8j1IPZ2Ti0g0yfqgn4p6/tBRaPV5OH3meuyBvcV
         4nAEeeWDTa7Blq/kYolLjRLCPXJL3eLza3hUZ/ij+qrER/8nq85wmrj6Q+5mfCxmji
         +WdHqDgb5kHkg==
Date:   Mon, 4 Jan 2021 09:49:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        martin.varghese@nokia.com, Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net] net: bareudp: add missing error handling for
 bareudp_link_config()
Message-ID: <20210104094936.79247c33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAM_iQpW1ZMyb33j4uLNMXXW+vQSS6FB1-BhxSQ7ZShi9dT2ZoQ@mail.gmail.com>
References: <20201231034417.1570553-1-kuba@kernel.org>
        <CAM_iQpW1ZMyb33j4uLNMXXW+vQSS6FB1-BhxSQ7ZShi9dT2ZoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2 Jan 2021 15:49:54 -0800 Cong Wang wrote:
> On Wed, Dec 30, 2020 at 7:46 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > @@ -661,9 +662,14 @@ static int bareudp_newlink(struct net *net, struct net_device *dev,
> >
> >         err = bareudp_link_config(dev, tb);
> >         if (err)
> > -               return err;
> > +               goto err_unconfig;
> >
> >         return 0;
> > +
> > +err_unconfig:  
> 
> I think we can save this goto.

I personally prefer more idiomatic code flow to saving a single LoC.

> > +       list_del(&bareudp->next);
> > +       unregister_netdevice(dev);  
> 
> Which is bareudp_dellink(dev, NULL). ;)

I know, but calling full dellink when only parts of newlink fails felt
weird. And it's not lower LoC, unless called with NULL as second arg,
which again could be surprising to a person changing dellink. 


But I can change both if you feel strongly.
