Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B7F2EA37B
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 03:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbhAECwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 21:52:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39153 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbhAECwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 21:52:10 -0500
Received: from 50-125-80-157.hllk.wa.frontiernet.net ([50.125.80.157] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1kwcRT-0005VP-UF; Tue, 05 Jan 2021 02:51:28 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id E655161DDA; Mon,  4 Jan 2021 18:51:25 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id DE922A0409;
        Mon,  4 Jan 2021 18:51:25 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     "Finer, Howard" <hfiner@rbbn.com>
cc:     "andy@greyhouse.net" <andy@greyhouse.net>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: bonding driver issue when configured for active/backup and using ARP monitoring
In-reply-to: <MN2PR03MB47524C92E45EB4C1B70D595CB7D20@MN2PR03MB4752.namprd03.prod.outlook.com>
References: <MN2PR03MB47526B686EF6E0F8D81A9397B7F50@MN2PR03MB4752.namprd03.prod.outlook.com> <14769.1607114585@famine> <MN2PR03MB47524C92E45EB4C1B70D595CB7D20@MN2PR03MB4752.namprd03.prod.outlook.com>
Comments: In-reply-to "Finer, Howard" <hfiner@rbbn.com>
   message dated "Mon, 04 Jan 2021 23:08:38 +0000."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9067.1609815085.1@famine>
Date:   Mon, 04 Jan 2021 18:51:25 -0800
Message-ID: <9069.1609815085@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Finer, Howard <hfiner@rbbn.com> wrote:

>Please advise if there is any update here, and if not how we can go about
>getting an update to the driver to rectify the issue.

	As it happens, I've been looking at this today, and have a
couple of questions about your configuration:

	- Is there an IP address on the same subnet as the arp_ip_target
configured directly on the bond, or on a VLAN logically above the bond?

	- Is the "arp_ip_target" address reachable via an interface
other than the bond (or VLAN above it)?  This can be checked via "ip
route get [arp_ip_target]", i.e., if the target address for bond0 is
1.2.3.4, the command "ip route get 1.2.3.4" will return something like

1.2.3.4 dev bond0 src [...]

	If an interface other than bond0 (or a VLAN above it) is listed,
then there's a path to the arp_ip_target that doesn't go through the
bond.

	The ARP monitor logic can only handle a limited set of
configurations, so if your configuration is outside of that it can
misbehave in some ways.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
