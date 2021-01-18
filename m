Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634B62FAA89
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 20:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437625AbhARTtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 14:49:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:49074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437610AbhARTtC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 14:49:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E17020848;
        Mon, 18 Jan 2021 19:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610999301;
        bh=WPHuKKzRvPi0zk6ZUQY8uD+8H4NfLDmuY8qz3/S7FAs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Br8H+Q8kEIw4klzRw3grTn5QwaAPKW9jy26vXr7R+Gm1uikd4cQREgExOCgEMhnC9
         1zPT0dT/j2zPip/bSvAA7OS9VI6Ii7x6x384l2GhoX0x9WYG3Q2V++n6wKyRYxJ4F1
         DeZrN/fkRQakx0KNaM5/uGJG5CjGH7gDcG8hARWwZbIaHxnVyo/VCLvIANp5J9Xu3M
         Xe5CPx9MvphqutQDPoc70kgOQf5cC0HhaQxj+u+nwWBWKZUq4ww3/drpJpvr5w2WUX
         ieDaUC55bjzwN9E6QwF/jCiSQ4xVYmu1vOWi6Okd+u4m4/IhI/ZRvGTXNUuwt5D4JB
         mJMSkuETZpjCg==
Date:   Mon, 18 Jan 2021 11:48:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        Guangbin Huang <huangguangbin2@huawei.com>
Subject: Re: [PATCH net-next] net: hns3: debugfs add dump tm info of nodes,
 priority and qset
Message-ID: <20210118114820.4e40a6ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d2fc48f6-aa2f-081a-dbce-312b869b8e04@huawei.com>
References: <1610694569-43099-1-git-send-email-tanhuazhong@huawei.com>
        <20210116182306.65a268a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d2fc48f6-aa2f-081a-dbce-312b869b8e04@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jan 2021 19:20:23 +0800 Huazhong Tan wrote:
> On 2021/1/17 10:23, Jakub Kicinski wrote:
> > On Fri, 15 Jan 2021 15:09:29 +0800 Huazhong Tan wrote:  
> >> From: Guangbin Huang <huangguangbin2@huawei.com>
> >>
> >> To increase methods to dump more tm info, adds three debugfs commands
> >> to dump tm info of nodes, priority and qset. And a new tm file of debugfs
> >> is created for only dumping tm info.
> >>
> >> Unlike previous debugfs commands, to dump each tm information, user needs
> >> to enter two commands now. The first command writes parameters to tm and
> >> the second command reads info from tm. For examples, to dump tm info of
> >> priority 0, user needs to enter follow two commands:
> >> 1. echo dump priority 0 > tm
> >> 2. cat tm
> >>
> >> The reason for adding new tm file is because we accepted Jakub Kicinski's
> >> opinion as link https://lkml.org/lkml/2020/9/29/2101. And in order to
> >> avoid generating too many files, we implement write ops to allow user to
> >> input parameters.  
> > Why are you trying to avoid generating too many files? How many files
> > would it be? What's the size of each dump/file?  
> 
> The maximum number of tm node, priority and qset are 8, 256,
> 1280, if we create a file for each one, then there are 8 node
> files, 256 priority files, 1280 qset files. It seems a little
> bit hard for using as well.

Would the information not fit in one file per type with multiple rows? 
Can you show example outputs?

For example if I'm reading right the Qset only has 5 attributes:

"qset id: %u\n"		qset_id
"QS map pri id: %u\n"		map->priority
"QS map link_vld: %u\n"	map->link_vld);
"QS schedule mode: %s\n"	(qs_sch_mode->sch_mode & HCLGE_TM_TX_SCHD_DWRR_MSK) ?
				 "dwrr" : "sp");
"QS dwrr: %u\n"		qs_weight->dwrr
