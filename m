Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8282B2FE2
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 19:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgKNSy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 13:54:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:50456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbgKNSyZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 13:54:25 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B58892065E;
        Sat, 14 Nov 2020 18:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605380065;
        bh=wwWlmNEE2oGxhesTon0cMMUtpHFh/OEjU82UmhLkgFQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QIGW9Y80OwBrBEhsHVRq3e2nqap03lcqypLWnGeHEzQRYghBCduUQbDlqpotHwFvW
         AwnslJUIwrRYat9/aFDKcZtypIkme2cM0DVyB5/Fly5YIRcZQtnFILX+EqeQrHU+ma
         r+xRkFIls87zv3RvKM/1Gt6miwsvRImwpBSX1b4c=
Date:   Sat, 14 Nov 2020 10:54:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH V3 net-next 06/10] net: hns3: add ethtool priv-flag for
 DIM
Message-ID: <20201114105423.07c2ce67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1605151998-12633-7-git-send-email-tanhuazhong@huawei.com>
References: <1605151998-12633-1-git-send-email-tanhuazhong@huawei.com>
        <1605151998-12633-7-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 11:33:14 +0800 Huazhong Tan wrote:
> Add a control private flag in ethtool for enable/disable
> DIM feature.
> 
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

Please work on a common ethtool API for the configuration instead of
using private flags.

Private flags were overused because the old IOCTL-based ethtool was
hard to extend, but we have a netlink API now.

For example here you're making a choice between device and DIM
implementation of IRQ coalescing. You can add a new netlink attribute
to the ETHTOOL_MSG_COALESCE_GET/ETHTOOL_MSG_COALESCE_SET commands which
controls the type of adaptive coalescing (if enabled).


One question I don't think we have a strong answer for is how to handle
this extension from ethtool_ops point of view. Should we add a new
"extended" op which drivers may start implementing? Or separate the
structure passed in to the ops from the one used as uAPI?

Thoughts anyone?


Huazhong Tan, since the DIM and EQ/CQ patches may require more
infrastructure work feel free to repost the first 4 patches separately,
I can apply those as is.
