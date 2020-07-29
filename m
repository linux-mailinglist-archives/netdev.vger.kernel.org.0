Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACBD2326B3
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 23:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgG2VUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 17:20:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbgG2VUG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 17:20:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90533206D4;
        Wed, 29 Jul 2020 21:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596057605;
        bh=UyDRAes5mNhgHAKYCr72yyxBUxcjpXvWbfXnp7JWZT8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1VrxSGttW2uw0C+qHGFfXFFoBe7itxYguxpPV51eLw4qEyCXawzzf7wzjJMyGPgnD
         mOZINA2OkqqRWxEb9EA0jIUusGZPmC9GyWO8PMgXS187E4B2cNXD+JT7QM1rNUSqDe
         bfe06IBflW6nAPTG9jcZ45zzQV8woF01rKJ/tdEI=
Date:   Wed, 29 Jul 2020 14:20:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Li,Rongqing" <lirongqing@baidu.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 2/6] i40e: prefetch struct page of Rx buffer
 conditionally
Message-ID: <20200729142003.7fe30d67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8e1471fdcaed4f46825cd8ff112a8c36@baidu.com>
References: <20200728190842.1284145-1-anthony.l.nguyen@intel.com>
        <20200728190842.1284145-3-anthony.l.nguyen@intel.com>
        <20200728131423.2430b3f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8e1471fdcaed4f46825cd8ff112a8c36@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jul 2020 06:20:47 +0000 Li,Rongqing wrote:
> > Looks like something that belongs in a common header not (potentially
> > multiple) C sources.  
> 
> Not clear, how should I change?

Can you add something like:

static inline void prefetch_page_address(struct page *page)
{
#if defined(WANT_PAGE_VIRTUAL) || defined(HASHED_PAGE_VIRTUAL)
	prefetch(page);
#endif
}

to mm.h or prefetch.h or i40e.h or some other header? That's preferred
over adding #ifs directly in the source code.
