Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7DB3E39D0
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 12:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhHHKC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 06:02:59 -0400
Received: from smtprelay0193.hostedemail.com ([216.40.44.193]:60260 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230354AbhHHKC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 06:02:58 -0400
Received: from omf16.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id C386D181D3025;
        Sun,  8 Aug 2021 10:02:38 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf16.hostedemail.com (Postfix) with ESMTPA id 86E95255108;
        Sun,  8 Aug 2021 10:02:37 +0000 (UTC)
Message-ID: <745ab8a85430ad4268a86b0957aa690c1a7a6d0f.camel@perches.com>
Subject: Re: [PATCH net-next 2/2] bonding: combine netlink and console error
 messages
From:   Joe Perches <joe@perches.com>
To:     Jonathan Toppins <jtoppins@redhat.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Date:   Sun, 08 Aug 2021 03:02:35 -0700
In-Reply-To: <f519f9eb-aefd-4d0a-01ce-4ed37b7930ef@redhat.com>
References: <cover.1628306392.git.jtoppins@redhat.com>
         <a36c7639a13963883f49c272ed7993c9625a712a.1628306392.git.jtoppins@redhat.com>
         <37c7bbbb01ede99974fc9ce3c3f5dad4845df9ee.camel@perches.com>
         <f519f9eb-aefd-4d0a-01ce-4ed37b7930ef@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.62
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 86E95255108
X-Stat-Signature: xp76j3p7soenw57a8bias8zr65oqfbqa
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18sWdJ0gR/negchCb2xjZXqr9B6PKsIgFM=
X-HE-Tag: 1628416957-534976
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-08-07 at 17:54 -0400, Jonathan Toppins wrote:
> On 8/6/21 11:52 PM, Joe Perches wrote:
> > On Fri, 2021-08-06 at 23:30 -0400, Jonathan Toppins wrote:
> > > There seems to be no reason to have different error messages between
> > > netlink and printk. It also cleans up the function slightly.
> > []
> > > diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> > []
> > > +#define BOND_NL_ERR(bond_dev, extack, errmsg) do {		\
> > > +	NL_SET_ERR_MSG(extack, errmsg);				\
> > > +	netdev_err(bond_dev, "Error: " errmsg "\n");		\
> > > +} while (0)
> > > +
> > > +#define SLAVE_NL_ERR(bond_dev, slave_dev, extack, errmsg) do {	\
> > > +	NL_SET_ERR_MSG(extack, errmsg);				\
> > > +	slave_err(bond_dev, slave_dev, "Error: " errmsg "\n");	\
> > > +} while (0)
> > 
> > If you are doing this, it's probably smaller object code to use
> > 	"%s", errmsg
> > as the errmsg string can be reused
> > 
> > #define BOND_NL_ERR(bond_dev, extack, errmsg)			\
> > do {								\
> > 	NL_SET_ERR_MSG(extack, errmsg);				\
> > 	netdev_err(bond_dev, "Error: %s\n", errmsg);		\
> > } while (0)
> > 
> > #define SLAVE_NL_ERR(bond_dev, slave_dev, extack, errmsg)	\
> > do {								\
> > 	NL_SET_ERR_MSG(extack, errmsg);				\
> > 	slave_err(bond_dev, slave_dev, "Error: %s\n", errmsg);	\
> > } while (0)
> > 
> > 
> 
> I like the thought and would agree if not for how NL_SET_ERR_MSG is 
> coded. Unfortunately it does not appear as though doing the above change 
> actually generates smaller object code. Maybe I have incorrectly 
> interpreted something?

No, it's because you are compiling allyesconfig or equivalent.
Try defconfig with bonding.


