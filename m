Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDCB42FF65
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 02:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239180AbhJPATj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 20:19:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231881AbhJPATj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 20:19:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED4AA610E8;
        Sat, 16 Oct 2021 00:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634343452;
        bh=7CDEhIHuAdev8iPFa+WCOGzX8h13TKFDedoPu5F4BEs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a3yMEmCNBOgx1lNj+4RccKWLS1FJAsTLO2NmD6Mlzg/Vrko/ofNFbWJVpO4QMapio
         XfXrSi4gz88LxIMK6twKdSRXYScccL16qqWi1obhf+xZMutMOl2hVtpff/Mshke3FF
         LdR+dR8s0YCpE4mdr0k4kKD3tahuWYurhLrM+Zs6Ph1L415KRSv2N8bDYXzGNczXfV
         2G0hoU83+3NMQa3aLUhCYHyExpopxk+EluWUWP47pPGj+FlUlnpD4PdvdboDmxijl0
         uJFD9uBhxIGYXA7qvQRDgwXRZBItrjiP++MG8kzYhAjaBaOek2HJFYD+pnmVI9kY4S
         VJJEjUvaSEyPA==
Date:   Fri, 15 Oct 2021 17:17:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, idosch@idosch.org,
        f.fainelli@gmail.com, vkochan@marvell.com, tchornyi@marvell.com
Subject: Re: [RFC net-next 3/6] ethernet: prestera: use
 eth_hw_addr_set_port()
Message-ID: <20211015171730.5651f0f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211015235130.6sulfh2ouqt3dgfh@skbuf>
References: <20211015193848.779420-1-kuba@kernel.org>
        <20211015193848.779420-4-kuba@kernel.org>
        <20211015235130.6sulfh2ouqt3dgfh@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 16 Oct 2021 02:51:30 +0300 Vladimir Oltean wrote:
> > @@ -341,8 +342,8 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
> >  	/* firmware requires that port's MAC address consist of the first
> >  	 * 5 bytes of the base MAC address
> >  	 */
> > -	memcpy(dev->dev_addr, sw->base_mac, dev->addr_len - 1);
> > -	dev->dev_addr[dev->addr_len - 1] = port->fp_id;
> > +	memcpy(addr, sw->base_mac, dev->addr_len - 1);
> > +	eth_hw_addr_set_port(dev, addr, port->fp_id);  
> 
> Instead of having yet another temporary copy, can't we zero out
> sw->base_mac[ETH_ALEN - 1] in prestera_switch_set_base_mac_addr()?

Will do unless Marvel & friends tell us FW cares about the last byte
(prestera_hw_switch_mac_set() send the whole thing).
