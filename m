Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A43F9C4E3
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 18:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbfHYQgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 12:36:12 -0400
Received: from mail.nic.cz ([217.31.204.67]:47882 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727889AbfHYQgM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Aug 2019 12:36:12 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id A9258140B7D;
        Sun, 25 Aug 2019 18:36:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566750970; bh=BkTKcqpYtfSTaddEkRcTQRqAx5P9YJWwnzYZivHFggM=;
        h=Date:From:To;
        b=K/YzIwHLsVNGkcmeyA6gI77GFpH1Ba7st3Jg28nYBtoGQaOsOf90b4Suh92ybtI1Z
         6xGjSvrAdcQIrxpH34LvYl7SougD+wac6bar2jvruQaRNffeg8QUAfYaVKzIsGYNOc
         6ntTJteNkJO7vbr0lx4UZUtopbKoiBzCq1Qkqf5k=
Date:   Sun, 25 Aug 2019 18:36:09 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v3 4/6] net: dsa: mv88e6xxx: simplify SERDES
 code for Topaz and Peridot
Message-ID: <20190825183609.4a9cc0d7@nic.cz>
In-Reply-To: <20190825120232.GG6729@t480s.localdomain>
References: <20190825035915.13112-1-marek.behun@nic.cz>
        <20190825035915.13112-5-marek.behun@nic.cz>
        <20190825120232.GG6729@t480s.localdomain>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 25 Aug 2019 12:02:32 -0400
Vivien Didelot <vivien.didelot@gmail.com> wrote:

> Aren't you relying on -ENODEV as well?

Vivien, I am not relying o -ENODEV. I changed the serdes_get_lane
semantics:
 - previously:
   - if port has a lane for current cmode, return given lane number
   - otherwise return -ENODEV
   - if other error occured during serdes_get_lane, return that error
     (this never happened, because all implementations only need port
     number and cmode, and cmode is cached, so no function was called
     that could err)
 - after this commit:
   - if port has a lane for current cmode, return 0 and put lane number
     into *lane
   - otherwise return 0 and put -1 into *lane
   - if error occured, return that error number

I removed the -ENODEV semantics for "no lane on port" event.
There are two reasons for this:
  1. once you requested lane number to be put into a place pointed to
     by a pointer, rather than the return value, the code seemed better
     to me (you may of course disagree, this is a personal opinion) when
     I did:
       if (err)
           return err;
       if (lane < 0)
           return 0;
     rather than
       if (err == -ENODEV)
           return 0;
       if (err)
           return err;
  2. some future implementation may actually need to call some MDIO
     read/write functions, which may or may not return -ENODEV. That
     could conflict with the -ENODEV returned when there is no lane.

Marek
