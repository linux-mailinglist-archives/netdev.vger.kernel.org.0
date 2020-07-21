Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73892286C2
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730373AbgGUREV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:04:21 -0400
Received: from mx3.wp.pl ([212.77.101.10]:39522 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728931AbgGUREU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 13:04:20 -0400
Received: (wp-smtpd smtp.wp.pl 11509 invoked from network); 21 Jul 2020 19:04:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1595351056; bh=Yjt3vVyWDwk2jHqIw8Uvx83qk5IOcrjcn4mBpQxBBJs=;
          h=From:To:Cc:Subject;
          b=lwx5GDoBjz7d+r31V1SFtMsxhjoVCHFB31cvN468rVme11HCoqekrcXOGUo+5Ef5E
           EWMWm4XscyZCLyNMoGi4SBgo3lKdDXf4I3txK4BIA3cw0hV4dScTVtU15fAU7ZOgj4
           JjlvG+c1T24cz6405X3eHkLYWrcSOxuTetajBmyU=
Received: from unknown (HELO kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com) (kubakici@wp.pl@[163.114.132.7])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <jiri@resnulli.us>; 21 Jul 2020 19:04:16 +0200
Date:   Tue, 21 Jul 2020 10:04:06 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        Tom Herbert <tom@herbertland.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: Re: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to
 flash update
Message-ID: <20200721100406.67c17ce9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200721135356.GB2205@nanopsycho>
References: <20200717183541.797878-1-jacob.e.keller@intel.com>
        <20200717183541.797878-7-jacob.e.keller@intel.com>
        <20200720100953.GB2235@nanopsycho>
        <20200720085159.57479106@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200721135356.GB2205@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: d0e90928b5409b4e803e29524f20ca3b
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000003 [IQBl]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jul 2020 15:53:56 +0200 Jiri Pirko wrote:
> Mon, Jul 20, 2020 at 05:51:59PM CEST, kubakici@wp.pl wrote:
> >On Mon, 20 Jul 2020 12:09:53 +0200 Jiri Pirko wrote:  
> >> This looks odd. You have a single image yet you somehow divide it
> >> into "program" and "config" areas. We already have infra in place to
> >> take care of this. See DEVLINK_ATTR_FLASH_UPDATE_COMPONENT.
> >> You should have 2 components:
> >> 1) "program"
> >> 2) "config"
> >> 
> >> Then it is up to the user what he decides to flash.  
> >
> >99.9% of the time users want to flash "all". To achieve "don't flash
> >config" with current infra users would have to flash each component   
> 
> Well you can have multiple component what would overlap:
> 1) "program" + "config" (default)
> 2) "program"
> 3) "config"

Say I have FW component and UNDI driver. Now I'll have 4 components?
fw.prog, fw.config, undi.prog etc? Are those extra ones visible or just
"implied"? If they are visible what version does the config have?

Also (3) - flashing config from one firmware version and program from
another - makes a very limited amount of sense to me.

> >one by one and then omit the one(s) which is config (guessing which 
> >one that is based on the name).
> >
> >Wouldn't this be quite inconvenient?  
> 
> I see it as an extra knob that is actually somehow provides degradation
> of components.

Hm. We have the exact opposite view on the matter. To me components
currently correspond to separate fw/hw entities, that's a very clear
meaning. PHY firmware, management FW, UNDI. Now we would add a
completely orthogonal meaning to the same API. 

Why?

In the name of "field reuse"?

> >In case of MLX is PSID considered config?  
> 
> Nope.

