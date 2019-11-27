Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA4F10B114
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 15:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfK0OXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 09:23:12 -0500
Received: from lan.nucleusys.com ([92.247.61.126]:45012 "EHLO
        zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726634AbfK0OXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 09:23:11 -0500
X-Greylist: delayed 1729 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Nov 2019 09:23:11 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=nucleusys.com; s=x; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xXUEy5RjR0d6ad7vv4cQTn7Eal/AhJZwP7ZGEUNr3Lo=; b=mGrnGONOKUqGDPCmlQtiAxHvR/
        BLCTWyqt+faFgoJu+gbTWlHyp87X5KyQwLOG8wnmjkjFgcZaYlXmWln1O/WVFNJYyXFXKIQJfeQ9K
        6nDVQyfi5Qqig6uF5dfo6/xeZoC9QQn5Y1nfcsLRUPYbk6rMzk7m6pvbitJ8NKes/1Wo=;
Received: from 78-83-66-117.spectrumnet.bg ([78.83.66.117] helo=p310)
        by zztop.nucleusys.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <petkan@nucleusys.com>)
        id 1iZxlr-0003EE-Rw; Wed, 27 Nov 2019 15:54:20 +0200
Date:   Wed, 27 Nov 2019 15:54:19 +0200
From:   Petko Manolov <petkan@nucleusys.com>
To:     Thor Thayer <thor.thayer@linux.intel.com>
Cc:     netdev@vger.kernel.org
Subject: Altera TSE driver not working in 100mbps mode
Message-ID: <20191127135419.7r53qw6vtp747x62@p310>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
X-Spam-Score: -1.0 (-)
X-Spam-Report: Spam detection software, running on the system "zztop.nucleusys.com",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  Hi Thor, In my effort to move Altera TSE driver from PHYLIB
    to PHYLINK i ran into a problem. The driver would not work properly on 100Mbit/s
    links. This is true for the original driver in linux-5.4.y as well a [...]
 Content analysis details:   (-1.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
  0.0 TVD_RCVD_IP            Message was received from an IP address
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	Hi Thor,

In my effort to move Altera TSE driver from PHYLIB to PHYLINK i ran into a 
problem.  The driver would not work properly on 100Mbit/s links.  This is true 
for the original driver in linux-5.4.y as well as for my PHYLINK/SFP enabled 
version.

This is a DT fragment of what i've been trying with 5.4.y kernels and the 
stock driver:

                tse_sub_2: ethernet@0xc0300000 {
                        status = "disabled";

                        compatible = "altr,tse-msgdma-1.0";
                        reg =   <0xc0300000 0x00000400>,
                                <0xc0301000 0x00000020>,
                                <0xc0302000 0x00000020>,
                                <0xc0303000 0x00000008>,
                                <0xc0304000 0x00000020>,
                                <0xc0305000 0x00000020>;
                        reg-names = "control_port", "rx_csr", "rx_desc", "rx_resp", "tx_csr", "tx_desc";
                        interrupt-parent =< &intc >;
                        interrupts = <0 54 4>, <0 55 4>;
                        interrupt-names = "rx_irq", "tx_irq";
                        rx-fifo-depth = <2048>;
                        tx-fifo-depth = <2048>;
                        address-bits = <48>;
                        max-frame-size = <1500>;
                        local-mac-address = [ 00 0C ED 00 00 06 ];
                        altr,has-supplementary-unicast;
                        altr,has-hash-multicast-filter;
                        phy-handle = <0>;
                        fixed-link {
                                speed = <1000>;
                                full-duplex;
                        };
                };

Trying "speed = <100>;" above also doesn't change much, except that the link is 
reported (as expected) as 100Mbps.

With the PHYLINK code the above fragment is pretty much the same except for:

                        sfp = <&sfp0>;
                        phy-mode = "sgmii";
                        managed = "in-band-status";

Both (old and new) drivers are working fine on 1Gbps links with optics and 
copper SFPs.  With PHYLINK code (and in auto-negotiation mode) the link speed 
and duplex is properly detected as 100Mbps.  MAC and PCS also look correctly set 
up, but the device is still unable to receive or transmit packages.


Please let me know should you need more details.


thanks,
Petko
