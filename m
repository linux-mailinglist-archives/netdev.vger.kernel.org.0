Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1357B23597C
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 19:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbgHBRZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 13:25:59 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:36399 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgHBRZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 13:25:58 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 072HPoOX027835;
        Sun, 2 Aug 2020 10:25:50 -0700
Date:   Sun, 2 Aug 2020 22:42:28 +0530
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ganji Aravind <ganji.aravind@chelsio.com>, netdev@vger.kernel.org,
        davem@davemloft.net, vishal@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: Add support to flash firmware config
 image
Message-ID: <20200802171221.GA29010@chelsio.com>
References: <20200730151138.394115-1-ganji.aravind@chelsio.com>
 <20200730162335.6a6aa4cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200731110904.GA1571@chelsio.com>
 <20200731110008.598a8ea7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200731211733.GA25665@chelsio.com>
 <20200801212202.7e4f3be2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200801212202.7e4f3be2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday, August 08/01/20, 2020 at 21:22:02 -0700, Jakub Kicinski wrote:
> On Sat, 1 Aug 2020 02:47:38 +0530 Rahul Lakkireddy wrote:
> > I thought /lib/firmware is where firmware related files need to be
> > placed and ethtool --flash needs to be used to program them to
> > their respective locations on adapter's flash.
> 
> Our goal is to provide solid, common interfaces for Linux users to rely
> on. Not give way to vendor specific "solutions" like uploading ini files
> to perform device configuration.
> 
> > Note that we don't have devlink support in our driver yet. And,
> > we're a bit confused here on why this already existing ethtool
> > feature needs to be duplicated to devlink.
> 
> To be clear - I'm suggesting the creation of a more targeted APIs 
> to control the settings you have encoded _inside_ the ini file. 
> Not a new interface for an whole sale config upload.
> 
> Worst case scenario - if the settings are really device specific 
> you can try to use devlink device parameters.

The config file contains very low-level firmware and device specific
params and most of them are dependent on the type of Chelsio NIC.
The params are mostly device dependent register-value pairs.
We don't see users messing around with the params on their own
without consultation. The users only need some mechanism to flash
the custom config file shared by us on to their adapter. After
device restart, the firmware will automatically pick up the flashed
config file and redistribute the resources, as per their requested
use-case.

We're already foreseeing very long awkward list (more than 50 params)
for mapping the config file to devlink-dev params and are hoping this
is fine. Here's a sample on how it would look.

hw_sge_reg_1008=0x40800
hw_sge_reg_100c=0x22222222
hw_sge_reg_10a0=0x01040810
hw_tp_reg_7d04=0x00010000
hw_tp_reg_7dc0=0x0e2f8849

and so on.

Thanks,
Rahul
