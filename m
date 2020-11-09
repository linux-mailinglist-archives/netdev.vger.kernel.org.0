Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F7F2AC98C
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 00:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbgKIXwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 18:52:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727311AbgKIXwj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 18:52:39 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C22AD206BE;
        Mon,  9 Nov 2020 23:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604965959;
        bh=XnyYnvUV1ykojWFJ3UIc+rnrXL2IVhaSjrVIJNr0lUs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LC/r7N29SIA6bb18tQVCdOomTa3K8k7Fv6f7fEKXZsf6exwFMRJ37MVwwoLZRjLlJ
         GsC7uFtL4dN1HB5DZH5AF2X/UcoUKoXFJL/BaQF4kNTA9gu/6D2GLHGCSKkVzuNtDP
         oZanTBN9muzTmFZelHBDwfJ5PNYc0NQ9EJXFacFE=
Date:   Mon, 9 Nov 2020 15:52:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, gnault@redhat.com, jchapman@katalix.com
Subject: Re: [RFC PATCH 0/2] add ppp_generic ioctl to bridge channels
Message-ID: <20201109155237.69c2b867@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201106181647.16358-1-tparkin@katalix.com>
References: <20201106181647.16358-1-tparkin@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Nov 2020 18:16:45 +0000 Tom Parkin wrote:
> This small RFC series implements a suggestion from Guillaume Nault in
> response to my previous submission to add an ac/pppoe driver to the l2tp
> subsystem[1].
> 
> Following Guillaume's advice, this series adds an ioctl to the ppp code
> to allow a ppp channel to be bridged to another.  Quoting Guillaume:
> 
> "It's just a matter of extending struct channel (in ppp_generic.c) with
> a pointer to another channel, then testing this pointer in ppp_input().
> If the pointer is NULL, use the classical path, if not, forward the PPP
> frame using the ->start_xmit function of the peer channel."
> 
> This allows userspace to easily take PPP frames from e.g. a PPPoE
> session, and forward them over a PPPoL2TP session; accomplishing the
> same thing my earlier ac/pppoe driver in l2tp did but in much less code!

I have little understanding of the ppp code, but I can't help but
wonder why this special channel connection is needed? We have great
many ways to redirect traffic between interfaces - bpf, tc, netfilter,
is there anything ppp specific that is required here?
