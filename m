Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E7933A4DA
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 13:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235441AbhCNMpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 08:45:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235438AbhCNMoq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Mar 2021 08:44:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB03964EE2;
        Sun, 14 Mar 2021 12:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615725886;
        bh=S2lNUzFkQg/ukExFJRH46e5SvDEvpLzcqaKUvYvAyX8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DOdiUW3sa6eMnD4hirleRWzU5MlTsVOo1zdRQ2rAtZKzkpyIVkrTRa4g3Rsz/MB5k
         BwcONK11OQgNw4dzvd8M3Q8Kb6U+Ew/VbDMQjXk8nMMs62NWrMs+RqVkw7JgKUnGy2
         UOQu0hpOdPItWBMSA7MBRzwBokJ45nw5m5Za5YOY=
Date:   Sun, 14 Mar 2021 13:44:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Fatih Yildirim <yildirim.fatih@gmail.com>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [BUG] net: rds: rds_send_probe memory leak
Message-ID: <YE4FO01xILz98/K6@kroah.com>
References: <a3036ea4ee2a06e4b3acd3b438025754d11f65fc.camel@gmail.com>
 <YE3K+zeWnJ/hVpQS@kroah.com>
 <b1b796b48a75b3ef3d6cebac89b0be45c5bf4611.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1b796b48a75b3ef3d6cebac89b0be45c5bf4611.camel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 14, 2021 at 03:19:05PM +0300, Fatih Yildirim wrote:
> On Sun, 2021-03-14 at 09:36 +0100, Greg KH wrote:
> > On Sun, Mar 14, 2021 at 11:23:10AM +0300, Fatih Yildirim wrote:
> > > Hi Santosh,
> > > 
> > > I've been working on a memory leak bug reported by syzbot.
> > > https://syzkaller.appspot.com/bug?id=39b72114839a6dbd66c1d2104522698a813f9ae2
> > > 
> > > It seems that memory allocated in rds_send_probe function is not
> > > freed.
> > > 
> > > Let me share my observations.
> > > rds_message is allocated at the beginning of rds_send_probe
> > > function.
> > > Then it is added to cp_send_queue list of rds_conn_path and
> > > refcount
> > > is increased by one.
> > > Next, in rds_send_xmit function it is moved from cp_send_queue list
> > > to
> > > cp_retrans list, and again refcount is increased by one.
> > > Finally in rds_loop_xmit function refcount is increased by one.
> > > So, total refcount is 4.
> > > However, rds_message_put is called three times, in rds_send_probe,
> > > rds_send_remove_from_sock and rds_send_xmit functions. It seems
> > > that
> > > one more rds_message_put is needed.
> > > Would you please check and share your comments on this issue?
> > 
> > Do you have a proposed patch that syzbot can test to verify if this
> > is
> > correct or not?
> > 
> > thanks,
> > 
> > gre gk-h
> 
> Hi Greg,
> 
> Actually, using the .config and the C reproducer, syzbot reports the
> memory leak in rds_send_probe function. Also by enabling
> CONFIG_RDS_DEBUG=y, the debug messages indicates the similar as I
> mentioned above. To give an example, below is the RDS_DEBUG messages.
> Allocated address 000000008a7476e5 has initial ref_count 1. Then there
> are three rds_message_addref calls for the same address making the
> refcount 4, but only three rds_message_put calls which leave the
> address still allocated.
> 
> [   60.570681] rds_message_addref(): addref rm 000000008a7476e5 ref 1
> [   60.570707] rds_message_put(): put rm 000000008a7476e5 ref 2
> [   60.570845] rds_message_addref(): addref rm 000000008a7476e5 ref 1
> [   60.570870] rds_message_addref(): addref rm 000000008a7476e5 ref 2
> [   60.570960] rds_message_put(): put rm 000000008a7476e5 ref 3
> [   60.570995] rds_message_put(): put rm 000000008a7476e5 ref 2
> 

Ok, so the next step is to try your proposed change to see if it works
or not.  What prevents you from doign that?

No need to ask people if your analysis of an issue is true or not, no
maintainer or developer usually has the time to deal with that.  We much
rather would like to see patches of things you have tested to resolve
issues.

thanks,

greg k-h
