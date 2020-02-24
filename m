Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED6E16AD7E
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 18:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgBXRcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 12:32:02 -0500
Received: from smtprelay0065.hostedemail.com ([216.40.44.65]:43667 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727440AbgBXRcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 12:32:02 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 47AD1182CED28;
        Mon, 24 Feb 2020 17:32:01 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:967:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1381:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2693:2828:2859:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6119:7903:9025:9040:9389:10004:10400:10450:10455:10848:11026:11232:11658:11914:12043:12048:12296:12297:12438:12555:12663:12740:12760:12895:12986:13095:13163:13229:13439:14096:14097:14181:14659:14721:19904:19999:21080:21433:21611:21627:21740:21749:21811:21939:30012:30054:30070:30083:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: honey37_4bab943b00d12
X-Filterd-Recvd-Size: 3626
Received: from XPS-9350.home (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf06.hostedemail.com (Postfix) with ESMTPA;
        Mon, 24 Feb 2020 17:31:59 +0000 (UTC)
Message-ID: <6f2e9e5f19ca97c09b29b08256d45d3ff58ec188.camel@perches.com>
Subject: Re: [PATCH v4] staging: qlge: emit debug and dump at same level
From:   Joe Perches <joe@perches.com>
To:     Kaaira Gupta <kgupta@es.iitr.ac.in>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 24 Feb 2020 09:30:31 -0800
In-Reply-To: <20200224171823.GA8240@kaaira-HP-Pavilion-Notebook>
References: <20200224082448.GA6826@kaaira-HP-Pavilion-Notebook>
         <84410699e6acbffca960aa2944e9f5869478b178.camel@perches.com>
         <20200224164721.GA7214@kaaira-HP-Pavilion-Notebook>
         <9f0d39d5972553b86123873294fc9f9566130036.camel@perches.com>
         <20200224171823.GA8240@kaaira-HP-Pavilion-Notebook>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-02-24 at 22:48 +0530, Kaaira Gupta wrote:
> On Mon, Feb 24, 2020 at 08:54:43AM -0800, Joe Perches wrote:
> > On Mon, 2020-02-24 at 22:17 +0530, Kaaira Gupta wrote:
> > > On Mon, Feb 24, 2020 at 05:38:09AM -0800, Joe Perches wrote:
> > > > On Mon, 2020-02-24 at 13:54 +0530, Kaaira Gupta wrote:
> > > > > Simplify code in ql_mpi_core_to_log() by calling print_hex_dump()
> > > > > instead of existing functions so that the debug and dump are
> > > > > emitted at the same KERN_<LEVEL>
> > > > []
> > > > > diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
> > > > []
> > > > > @@ -1324,27 +1324,10 @@ void ql_mpi_core_to_log(struct work_struct *work)
> > > > >  {
> > > > >  	struct ql_adapter *qdev =
> > > > >  		container_of(work, struct ql_adapter, mpi_core_to_log.work);
> > > > > -	u32 *tmp, count;
> > > > > -	int i;
> > > > >  
> > > > > -	count = sizeof(struct ql_mpi_coredump) / sizeof(u32);
> > > > > -	tmp = (u32 *)qdev->mpi_coredump;
> > > > > -	netif_printk(qdev, drv, KERN_DEBUG, qdev->ndev,
> > > > > -		     "Core is dumping to log file!\n");
> > > > 
> > > > There is no real need to delete this line.
> > > > 
> > > > And if you really want to, it'd be better to mention
> > > > the removal in the commit message description.
> > > > 
> > > > As is for this change, there is no "debug" and "dump"
> > > > as the commit message description shows, just "dump".
> > > 
> > > This patch has already been added to the tree,
> > 
> > What tree is that?
> > It's not in -next as of right now.
> 
> Its in staging-next right now.
> This is the link: https://lore.kernel.org/driverdev-devel/cba75ee4d88afdf118631510ad0f971e42c1a31c.camel@perches.com/
> 
> > >  if I amend the commit now
> > > using git rebase, won't it affect the upstream as the SHA-1 of the
> > > commit and it's children will change?
> > 
> > You are sending patches not pull requests.
> > 
> > If it's really in an actual tree that people
> > care about, send another patch putting the
> > netif_printk back.
> 
> I'll submit a patch, but can you please explain me why this function is
> still needed when we are already using print_hex_dump()?

Your commit message did not match the code.

You are changing the code and the output without explanation.

It's fine to both change the code and the output when appropriate.
it's not fine to do so by misstating what you are doing.


