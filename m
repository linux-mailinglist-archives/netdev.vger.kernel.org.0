Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9DF3E330B
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 05:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhHGDwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 23:52:49 -0400
Received: from smtprelay0174.hostedemail.com ([216.40.44.174]:58550 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230144AbhHGDwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 23:52:47 -0400
Received: from omf16.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 50B54202FE;
        Sat,  7 Aug 2021 03:52:30 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf16.hostedemail.com (Postfix) with ESMTPA id 180B6255112;
        Sat,  7 Aug 2021 03:52:28 +0000 (UTC)
Message-ID: <37c7bbbb01ede99974fc9ce3c3f5dad4845df9ee.camel@perches.com>
Subject: Re: [PATCH net-next 2/2] bonding: combine netlink and console error
 messages
From:   Joe Perches <joe@perches.com>
To:     Jonathan Toppins <jtoppins@redhat.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Date:   Fri, 06 Aug 2021 20:52:27 -0700
In-Reply-To: <a36c7639a13963883f49c272ed7993c9625a712a.1628306392.git.jtoppins@redhat.com>
References: <cover.1628306392.git.jtoppins@redhat.com>
         <a36c7639a13963883f49c272ed7993c9625a712a.1628306392.git.jtoppins@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: 180B6255112
X-Spam-Status: No, score=-0.76
X-Stat-Signature: a577bogzupnxsjdub1xh6gonof1eoazw
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+/yXwzhyRhXkajZ0vJp1z3F0z122Pyujo=
X-HE-Tag: 1628308348-626008
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-08-06 at 23:30 -0400, Jonathan Toppins wrote:
> There seems to be no reason to have different error messages between
> netlink and printk. It also cleans up the function slightly.
[]
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
[]
> +#define BOND_NL_ERR(bond_dev, extack, errmsg) do {		\
> +	NL_SET_ERR_MSG(extack, errmsg);				\
> +	netdev_err(bond_dev, "Error: " errmsg "\n");		\
> +} while (0)
> +
> +#define SLAVE_NL_ERR(bond_dev, slave_dev, extack, errmsg) do {	\
> +	NL_SET_ERR_MSG(extack, errmsg);				\
> +	slave_err(bond_dev, slave_dev, "Error: " errmsg "\n");	\
> +} while (0)

If you are doing this, it's probably smaller object code to use
	"%s", errmsg 
as the errmsg string can be reused

#define BOND_NL_ERR(bond_dev, extack, errmsg)			\
do {								\
	NL_SET_ERR_MSG(extack, errmsg);				\
	netdev_err(bond_dev, "Error: %s\n", errmsg);		\
} while (0)

#define SLAVE_NL_ERR(bond_dev, slave_dev, extack, errmsg)	\
do {								\
	NL_SET_ERR_MSG(extack, errmsg);				\
	slave_err(bond_dev, slave_dev, "Error: %s\n", errmsg);	\
} while (0)


