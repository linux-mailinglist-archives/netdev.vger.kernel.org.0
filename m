Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE98440DCEF
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 16:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236152AbhIPOiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 10:38:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235955AbhIPOiB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 10:38:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BF9061164;
        Thu, 16 Sep 2021 14:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631803001;
        bh=Qqm3TnW06OUx8Ms7O6IvNEY02BAkvJWTijFgoy80DEE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i2dYB1Q/8dDVkoHSuQjVDxUoB0+X6m3HY6uMVbtTI2Rd72glxkzVfk3PFP1mnM5c8
         NTrarVJzkGHRnxpPkfjXQKatE78vXH5MWvJ8VTbkU9OD9WijEp2dWwPQW932a8yv2t
         WnazG6f/eLOmyjO0/N3zULc1ZQ6V7lSznpUrrsPyQtfsowfUGvML4kNO8vFB7lUWLp
         be38ebWGA4DZ6IGJm9nPZzZljRwvhdWY2m31EB1Iyhnbu3sPEEXMooE0FGD4ZZlvft
         w9w2sKTEClRhg9INYp1Sjpryfxavp4Wza4KytogJ2eoz++8RaQGJzo2ZYJxkSH69+z
         ZxcuGvUk367QQ==
Date:   Thu, 16 Sep 2021 07:36:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     pshelar@ovn.org, davem@davemloft.net, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] openvswitch: Fix condition check by using nla_ok()
Message-ID: <20210916073640.7e87718a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1631756603-3706451-1-git-send-email-jiasheng@iscas.ac.cn>
References: <1631756603-3706451-1-git-send-email-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Sep 2021 01:43:23 +0000 Jiasheng Jiang wrote:
> Just using 'rem > 0' might be unsafe, so it's better
> to use the nla_ok() instead.
> Because we can see from the nla_next() that
> '*remaining' might be smaller than 'totlen'. And nla_ok()
> will avoid it happening.
> 
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>

Are the attributes coming from the user space here or are generated 
by the kernel / were already validated?  Depending on that this is
either a fix and needs to be backported or a possible cleanup.

Please repost with the explanation where attrs come from in the commit
message, and if it's indeed a bug please add a Fixes tag.

If we do need the nla_ok() we should probably also switch to
nla_for_each_attr() and nla_for_each_nested().
