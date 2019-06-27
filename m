Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3234658355
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 15:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfF0NVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 09:21:42 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:46414 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfF0NVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 09:21:42 -0400
Received: by mail-wr1-f45.google.com with SMTP id n4so2525223wrw.13;
        Thu, 27 Jun 2019 06:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=oA5GMdnGrxF6sTzzRcKYXpIVUL/ec5EzcBXgMsfLGhA=;
        b=en28+nAK8m6rZ3ZTvk3LC0DPGjptazamkjHHl1rH5uXYhTNzshicqWF/MxlyQbCGJy
         wLuU0DGTApf9VNNPze75OixM7kRciu2fpb0vhYmy2Qq0CBAOPb0e3EI+cV+xrurrGXHw
         iJoKglsPEo/6pRu3GO3DRVtQSbU/1zlHfqC1MI86vbuySlVzM6qCnnxsbqiuHhGMHBZM
         0Z2uQxO4DI9vj8fnrTnkqG8z40Zz78NmesPA9e8cPBS2YS/rdZSQVsg+YWOmHHh8Gd+w
         uSRHJa9BgPGfPAadm4ccZc3zSKMSCriq+sWFz8/sPtW6YfLFC3KvkDEa3WNDPYknY2nq
         60tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=oA5GMdnGrxF6sTzzRcKYXpIVUL/ec5EzcBXgMsfLGhA=;
        b=jiy/F09TtQLKTIT/w5xqwB1KDoVEO+tWexwQiHQAQdKykyiiRYcihIza+a/+Fgq6U/
         k/EVOEDcaEs9F+XQbo75Jl4a+0D0x1RuCkzbK1xua13q6sY8VgrDHjYImo87Vg6ZXxz8
         SYnVnyw9YQ1wyvqgni7UbocthBItVa/DA0A3JtW+xkjFL0XQnNEWDhGXcQjVl5HOKfnx
         i+MTkt0+Z7qTQyf/ZtdbxJu4m1CgWogcS+a1q9zRdQjKez2FdKuF+KSg6ON2eNveWcWs
         HQNLC9UzZuZ9bS22esXcPX2BHMv2tDFC+kKSre8auufwUH09YYRnUMQyNEFwZZ/YwOpT
         63cg==
X-Gm-Message-State: APjAAAXl2jcVUKw00yd8B+K6IhckV+l6/Qc8zxuB86Htv7GzwuTKJM5k
        hsA2GJxLU8vRz6wvzJzzgKsOgRzB
X-Google-Smtp-Source: APXvYqz8Px8uNRXsni/Sj397utzkvUuRY9u81z04/43rRNRo8t9A9KODuzgnmA0SgLx39801L+DiTA==
X-Received: by 2002:a5d:4090:: with SMTP id o16mr3463732wrp.292.1561641700045;
        Thu, 27 Jun 2019 06:21:40 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id y4sm3712762wrn.68.2019.06.27.06.21.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 06:21:39 -0700 (PDT)
Date:   Thu, 27 Jun 2019 15:21:37 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     jacmet@sunsite.dk, davem@davemloft.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [BUG] net: dm9600: false link status
Message-ID: <20190627132137.GB29016@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

I own an USB dongle which is a "Davicom DM96xx USB 10/100 Ethernet".
According to the CHIP_ID, it is a DM9620.

Since I needed for bringing network to uboot for a board, I have started to create its uboot's driver.
My uboot driver is based on the dm9600 Linux driver.

The dongle was working but very very slowy (24Kib/s).
After some debug i found that the main problem was that it always link to 10Mbit/s Half-duplex. (according to the MAC registers)

For checking the status of the dongle I have plugged it on a Linux box which give me:
dm9601 6-2:1.0 enp0s29f0u2: link up, 100Mbps, full-duplex, lpa 0xFFFF

But in fact the Linux driver is tricked.

I have added debug of MDIO write/read and got:
[157550.926974] dm9601 6-2:1.0 (unnamed net_device) (uninitialized): dm9601_mdio_write() phy_id=0x00, loc=0x00, val=0x8000
[157550.931962] dm9601 6-2:1.0 (unnamed net_device) (uninitialized): dm9601_mdio_write() phy_id=0x00, loc=0x04, val=0x05e1
[157550.951967] dm9601 6-2:1.0 (unnamed net_device) (uninitialized): dm9601_mdio_read() phy_id=0x00, loc=0x00, returns=0xffff
[157550.951971] dm9601 6-2:1.0 (unnamed net_device) (uninitialized): dm9601_mdio_write() phy_id=0x00, loc=0x00, val=0xffff
[157567.781989] dm9601 6-2:1.0 enp0s29f0u2: dm9601_mdio_read() phy_id=0x00, loc=0x01, returns=0xffff
[157567.796985] dm9601 6-2:1.0 enp0s29f0u2: dm9601_mdio_read() phy_id=0x00, loc=0x01, returns=0xffff
[157567.811989] dm9601 6-2:1.0 enp0s29f0u2: dm9601_mdio_read() phy_id=0x00, loc=0x04, returns=0xffff
[157567.826974] dm9601 6-2:1.0 enp0s29f0u2: dm9601_mdio_read() phy_id=0x00, loc=0x05, returns=0xffff
[157567.841972] dm9601 6-2:1.0 enp0s29f0u2: dm9601_mdio_read() phy_id=0x00, loc=0x00, returns=0xffff
[157567.856974] dm9601 6-2:1.0 enp0s29f0u2: dm9601_mdio_read() phy_id=0x00, loc=0x01, returns=0xffff
[157567.871990] dm9601 6-2:1.0 enp0s29f0u2: dm9601_mdio_read() phy_id=0x00, loc=0x04, returns=0xffff
[157567.886974] dm9601 6-2:1.0 enp0s29f0u2: dm9601_mdio_read() phy_id=0x00, loc=0x05, returns=0xffff
[157567.906010] dm9601 6-2:1.0 enp0s29f0u2: dm9601_mdio_read() phy_id=0x00, loc=0x01, returns=0xffff
[157567.920986] dm9601 6-2:1.0 enp0s29f0u2: dm9601_mdio_read() phy_id=0x00, loc=0x01, returns=0xffff
[157567.935975] dm9601 6-2:1.0 enp0s29f0u2: dm9601_mdio_read() phy_id=0x00, loc=0x04, returns=0xffff
[157567.950974] dm9601 6-2:1.0 enp0s29f0u2: dm9601_mdio_read() phy_id=0x00, loc=0x05, returns=0xffff
[157567.965974] dm9601 6-2:1.0 enp0s29f0u2: dm9601_mdio_read() phy_id=0x00, loc=0x00, returns=0xffff
[157567.980970] dm9601 6-2:1.0 enp0s29f0u2: dm9601_mdio_read() phy_id=0x00, loc=0x01, returns=0xffff
[157567.995973] dm9601 6-2:1.0 enp0s29f0u2: dm9601_mdio_read() phy_id=0x00, loc=0x04, returns=0xffff
[157568.010971] dm9601 6-2:1.0 enp0s29f0u2: dm9601_mdio_read() phy_id=0x00, loc=0x05, returns=0xffff
[157568.025973] dm9601 6-2:1.0 enp0s29f0u2: dm9601_mdio_read() phy_id=0x00, loc=0x01, returns=0xffff
[157568.040969] dm9601 6-2:1.0 enp0s29f0u2: dm9601_mdio_read() phy_id=0x00, loc=0x01, returns=0xffff
[157568.055971] dm9601 6-2:1.0 enp0s29f0u2: dm9601_mdio_read() phy_id=0x00, loc=0x04, returns=0xffff
[157568.070970] dm9601 6-2:1.0 enp0s29f0u2: dm9601_mdio_read() phy_id=0x00, loc=0x05, returns=0xffff
[157568.085971] dm9601 6-2:1.0 enp0s29f0u2: dm9601_mdio_read() phy_id=0x00, loc=0x00, returns=0xffff
[157568.100971] dm9601 6-2:1.0 enp0s29f0u2: dm9601_mdio_read() phy_id=0x00, loc=0x01, returns=0xffff
[157568.115973] dm9601 6-2:1.0 enp0s29f0u2: dm9601_mdio_read() phy_id=0x00, loc=0x04, returns=0xffff
[157568.130970] dm9601 6-2:1.0 enp0s29f0u2: dm9601_mdio_read() phy_id=0x00, loc=0x05, returns=0xffff

So the problem is the same than in my uboot driver, the PHY always return 0xFFFF.

I have tried lots of hack but fail to bring the PHY up.

So it exsists two problem:
- Linux saying 100Mbps, full-duplex even if it is false.
- the PHY which seems in bad state.

For further information, the PHY is the internal one.
On the dongle, only the davicom chip is present (along with some resistors/capacitors and a quartz), so I think of the absence of an external PHY.

Regards
