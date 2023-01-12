Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A77C76687B8
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 00:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjALXEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 18:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbjALXEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 18:04:05 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C27D60CF;
        Thu, 12 Jan 2023 15:04:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:To:From:Date:Reply-To:Cc:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oxhT9ylaxQ16NsVLSuIMHVv4tpp/+AVtIOvb7Y1IYVk=; b=1/RWb++s2auqBMHCuVdDM4OXHp
        Jr7llaNQDsVyX+S4HCztiHtw3izfBlFZsH+6JlgH6NanyYiYBKOHoKLZk5QgnTRRC7qRYqMnQbF80
        0RURUg9iorvb1xgRg2A7uD2mh8JcCLlIto/YDtxewsoT5eOQ+VaEMIUa0Ot+158hxq+TyNm0+EQQ+
        qON3JrZEf4Tt1bUu8MsVJg66/rQ3c0Gd/c5V0kBei01TOmn/GFV/TaZLJMDk5/pVuHj9kIKOFcl3F
        sh6Qjdkl9hx1plRooR7ZjEiZ8vx6Nfaek15783LwFxlF3/k2Q3tiCagf1wqRQqjco8By4h+1n2DF2
        YkvuyW1g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36072)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pG6c1-00076F-PE; Thu, 12 Jan 2023 23:03:57 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pG6c0-0002ZX-Nh; Thu, 12 Jan 2023 23:03:56 +0000
Date:   Thu, 12 Jan 2023 23:03:56 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: 6.1: possible bug with netfilter conntrack?
Message-ID: <Y8CR3CvOIAa6QIZ4@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I've noticed that my network at home is rather struggling, and having
done some investigation, I find that the router VM is dropping packets
due to lots of:

nf_conntrack: nf_conntrack: table full, dropping packet

I find that there are about 2380 established and assured connections
with a destination of my incoming mail server with destination port 25,
and 2 packets. In the reverse direction, apparently only one packet was
sent according to conntrack. E.g.:

tcp      6 340593 ESTABLISHED src=180.173.2.183 dst=78.32.30.218
sport=49694 dport=25 packets=2 bytes=92 src=78.32.30.218
dst=180.173.2.183 sport=25 dport=49694 packets=1 bytes=44 [ASSURED]
use=1

However, if I look at the incoming mail server, its kernel believes
there are no incoming port 25 connetions, which matches exim.

I hadn't noticed any issues prior to upgrading from 5.16 to 6.1 on the
router VM, and the firewall rules have been the same for much of
2021/2022.

Is this is known issue? Something changed between 5.16 and 6.1 in the
way conntrack works?

I'm going to be manually clearing the conntrack table so stuff works
again without lots of packet loss on my home network...

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
