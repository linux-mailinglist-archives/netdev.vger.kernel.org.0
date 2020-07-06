Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18500215D3A
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 19:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729620AbgGFRdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 13:33:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:32960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729297AbgGFRdI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 13:33:08 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E6B4206E6;
        Mon,  6 Jul 2020 17:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594056787;
        bh=128nVMFg1XExFVQlHEwcKwTf80yqGvLoqim9Nu6G2Bk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wLxL9N6Vu18mTO3TPMB/Oa7Y0LHv8pwPR2GdrW5mhSTG7kjbi6UW6hv8s3LRp1wL8
         g9ED/16vQf41g53jGm7VqHHuzjvJxjzac8nu8wNXJQdLcGSgT6IXxicw47iLXumamC
         D0Rf12SlAzLnLyYctLTNHTuEwGWo7e9q+28QjKYg=
Date:   Mon, 6 Jul 2020 10:33:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net] ionic: centralize queue reset code
Message-ID: <20200706103305.182bd727@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200702233917.35166-1-snelson@pensando.io>
References: <20200702233917.35166-1-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  2 Jul 2020 16:39:17 -0700 Shannon Nelson wrote:
> The queue reset pattern is used in a couple different places,
> only slightly different from each other, and could cause
> issues if one gets changed and the other didn't.  This puts
> them together so that only one version is needed, yet each
> can have slighty different effects by passing in a pointer
> to a work function to do whatever configuration twiddling is
> needed in the middle of the reset.
> 
> Fixes: 4d03e00a2140 ("ionic: Add initial ethtool support")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Is this fixing anything?

I think the pattern of having a separate structure describing all the
parameters and passing that into reconfig is a better path forward,
because it's easier to take that forward in the correct direction of
allocating new resources before old ones are freed. IOW not doing a
full close/open.

E.g. nfp_net_set_ring_size().
