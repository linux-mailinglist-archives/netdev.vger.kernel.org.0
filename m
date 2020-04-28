Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE711BBC75
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 13:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgD1LbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 07:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbgD1LbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 07:31:25 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E11C03C1A9;
        Tue, 28 Apr 2020 04:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ylQbBiXQ1XZjJdtQzUusq8uMeJuZTJZ9b4+3voifqaU=; b=KL8eNcqbyZKTMuYIZogU6YA6F
        DOr6EzB7OJWGOWDMIqAw1dh+FqW+g1aTLKcCQLzNoOWIZWS+BsxppaS+NpWxjjo00+6+Zuz5bk+x7
        s+Nie7soMOwcCEbQk9FRh1gmWpqmZB86bP1L6Hp2Zsg8uH0UbEPpl5Rhh6n2R9SYU+Tvn7Nc6tCLR
        E3R1wP4RRHOdzcD1y4fbcIxyWRkNOgtMCLHUCKA1/LDFnRrKRUbG7kABouKS7G6u4WXG5bpohOsJp
        EfbPbRpeT1ywUu1DLI4TMCAvQ2g+ThJaDe9jREFrDNBjOe3E4F8k9YNFpHVagsJrg2VstCIyKIUln
        X4GqpUTNw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:45098)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jTOSO-0000PW-8x; Tue, 28 Apr 2020 12:31:20 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jTOSN-0007fQ-5e; Tue, 28 Apr 2020 12:31:19 +0100
Date:   Tue, 28 Apr 2020 12:31:19 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     mtk.manpages@gmail.com
Cc:     linux-man@vger.kernel.org, netdev@vger.kernel.org
Subject: connect(2) man page EACCES error (IPv6 usage)
Message-ID: <20200428113118.GR25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

While trying to work out a problem being reported in exim's logs,
it has been found that an update to the connect(2) man page is
needed to clear up the Linux kernel behaviour, which has been this
way since at least the dawn of git history.

The current connect(2) page, as per kernel.org, says:

        EACCES For UNIX domain sockets, which are identified by pathname:
               Write permission is denied on the socket file, or search
               permission is denied for one of the directories in the path
               prefix.  (See also path_resolution(7).)

        EACCES, EPERM
               The user tried to connect to a broadcast address without
               having the socket broadcast flag enabled or the connection
               request failed because of a local firewall rule.

EACCES can also be returned from connect(2) due to a remote firewall
rule as well, or due to one of several "destination unreachable" codes
via the IPv6 protocol - please see: the tab_unreach array in
net/ipv6/icmp6.h.  These codes are ADM_PROHIBITED, POLICY_FAIL, and
REJECT_ROUTE.  Whether all these are appropriate for connect(2), I'm
unsure.  However, ADM_PROHIBITED certainly is, and has been the cause
of the issue I've been seeing with exim.

Besides exim, it also appears if you use telnet to an IPv6 address
which elicits an ADM_PROHIBITED destination unreachable response
from some remote router/firewall.

So, it is not true that it's only restricted to local firewall rules.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
