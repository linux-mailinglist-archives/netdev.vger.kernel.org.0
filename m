Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0618F7545
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 14:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfKKNqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 08:46:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33802 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbfKKNqY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 08:46:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MJCGuEOTpY/MewY0GwTlqiXigGfEZUSiVxvb4IrZmwM=; b=fNLK7gKZBvb4o2j648isCTujU+
        KlJcM1TY+Y9bxONb+tCgt2aLjjGSj1vhZ3Xu0OJWVbYdkhN278w9E+myU96IrhaO97qfOu12zce8d
        ll850KxtM4IZWknKkFuZYOPT2y6XnClCB6tzyDLdxmGsvvKz+q7kgRVgAByBJlUC5Bgs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iUA1H-0002Je-VR; Mon, 11 Nov 2019 14:46:15 +0100
Date:   Mon, 11 Nov 2019 14:46:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     ilias.apalodimas@linaro.org, brouer@redhat.com, lorenzo@kernel.org
Cc:     netdev <netdev@vger.kernel.org>
Subject: Regression in mvneta with XDP patches
Message-ID: <20191111134615.GA8153@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo, Jesper, Ilias

I just found that the XDP patches to mvneta have caused a regression.

This one breaks networking:

commit 8dc9a0888f4c8e27b25e48ff1b4bc2b3a845cc2d (HEAD)
Author: Lorenzo Bianconi <lorenzo@kernel.org>
Date:   Sat Oct 19 10:13:23 2019 +0200

    net: mvneta: rely on build_skb in mvneta_rx_swbm poll routine
    
    Refactor mvneta_rx_swbm code introducing mvneta_swbm_rx_frame and
    mvneta_swbm_add_rx_fragment routines. Rely on build_skb in oreder to
    allocate skb since the previous patch introduced buffer recycling using
    the page_pool API.
    This patch fixes even an issue in the original driver where dma buffers
    are accessed before dma sync.
    mvneta driver can run on not cache coherent devices so it is
    necessary to sync DMA buffers before sending them to the device
    in order to avoid memory corruptions. Running perf analysis we can
    see a performance cost associated with this DMA-sync (anyway it is
    already there in the original driver code). In follow up patches we
    will add more logic to reduce DMA-sync as much as possible.

I'm using an Linksys WRT1900ac, which has an Armada XP SoC. Device
tree is arch/arm/boot/dts/armada-xp-linksys-mamba.dts.

With this patch applied, transmit appears to work O.K. My dhcp server
is seeing good looking BOOTP requests and replying. However what is
being received by the WRT1900ac is bad.

11:36:20.038558 d8:f7:00:00:00:00 (oui Unknown) > 00:00:00:00:5a:45 (oui Ethernet) Null Informati4
        0x0000:  0000 0000 0000 0000 0000 0000 0000 0000  ................
        0x0010:  0000 0000 0000 0000 0000 0000 0000 0000  ................
        0x0020:  0000 0000 0000 0000 0000 0000 0000 0000  ................
        0x0030:  0000 0000 0000                           ......
11:36:26.924914 d8:f7:00:00:00:00 (oui Unknown) > 00:00:00:00:5a:45 (oui Ethernet) Null Informati4
        0x0000:  0000 0000 0000 0000 0000 0000 0000 0000  ................
        0x0010:  0000 0000 0000 0000 0000 0000 0000 0000  ................
        0x0020:  0000 0000 0000 0000 0000 0000 0000 0000  ................
        0x0030:  0000 0000 0000                           ......
11:36:27.636597 4c:69:6e:75:78:20 (oui Unknown) > 6e:20:47:4e:55:2f (oui Unknown), ethertype Unkn 
        0x0000:  2873 7472 6574 6368 2920 4c69 6e75 7820  (stretch).Linux.
        0x0010:  352e 342e 302d 7263 362d 3031 3438 312d  5.4.0-rc6-01481-
        0x0020:  6739 3264 3965 3038 3439 3662 382d 6469  g92d9e08496b8-di
        0x0030:  7274 7920 2333 2053 756e 204e 6f76 2031  rty.#3.Sun.Nov.1
        0x0040:  3020 3136 3a31 373a 3531 2043 5354 2032  0.16:17:51.CST.2
        0x0050:  3031 3920 6172 6d76 376c 0e04 009c 0080  019.armv7l......
        0x0060:  100c 0501 0a00 000e 0200 0000 0200 1018  ................
        0x0070:  1102 fe80 0000 0000 0000 eefa aaff fe01  ................
        0x0080:  12fe 0200 0000 0200 0804 6574 6830 fe09  ..........eth0..
        0x0090:  0012 0f03 0100 0000 00fe 0900 120f 0103  ................
        0x00a0:  ec00 0010 0000 e3ed 5509 0000 0000 0000  ........U.......
        0x00b0:  0000 0000 0000 0000 0000 0000 0000 0000  ................
        0x00c0:  0000 0000 0000 0000 0000 0000 0000 0000  ................
        0x00d0:  0000 0000 0000 0000 0000 0000 0000 0000  ................
        0x00e0:  0000 0000 0000

This actually looks like random kernel memory.

     Andrew
