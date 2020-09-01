Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA535259D3D
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 19:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbgIARcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 13:32:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726301AbgIARcF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 13:32:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1F9320866;
        Tue,  1 Sep 2020 17:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598981525;
        bh=O4vHFpIToPRhXlpSKyt985EwP3xCzYuhaSm2dqyu9fk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rxgr3gd/PMosdiCHD0DzyN0syxnOZPa4L71MsBrDjXgEjhRXZNSwH3xKuoYg56jxf
         uNQWjM8S5y2okdrd6nxgWBFiKFF8rWoYV3OlBS4NsZBSdjnxmtHPjFkVQEhRWBHvf/
         CdhhH4/oEuUdMf2Sm5bzXYIjpNrJ4OktqGgH7l9M=
Date:   Tue, 1 Sep 2020 10:32:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        zeil@yandex-team.ru, khlebnikov@yandex-team.ru, pabeni@redhat.com,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: Re: [PATCH net-next] net: diag: add workaround for inode truncation
Message-ID: <20200901103203.223bc13a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200901093613.28a36553@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200831235956.2143127-1-kuba@kernel.org>
        <26351e38-ccbc-c0ce-f12e-96f85913a6dc@gmail.com>
        <20200901093613.28a36553@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Sep 2020 09:36:13 -0700 Jakub Kicinski wrote:
> On Tue, 1 Sep 2020 08:55:29 +0200 Eric Dumazet wrote:
> > On 8/31/20 4:59 PM, Jakub Kicinski wrote:  
> > > Dave reports that struct inet_diag_msg::idiag_inode is 32 bit,
> > > while inode's type is unsigned long. This leads to truncation.
> > > 
> > > Since there is nothing we can do about the size of existing
> > > fields - add a new attribute to carry 64 bit inode numbers.  
> > 
> > Last time I checked socket inode numbers were 32bit ?
> > 
> > Is there a plan changing this ?  
> 
> Ugh, you're right that appears to be a local patch :/ 
> 
> I should have checked, sorry for the noise.

Looking at get_next_ino() - it seems like the risk of overflow is very
real, no?  Should we not address this?
