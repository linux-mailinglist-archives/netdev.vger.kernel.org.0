Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620F85DB13
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 03:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfGCBn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 21:43:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49726 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbfGCBnZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 21:43:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=r02h9MTl0BX08PCqISfFd+97NJJEJLJZHaEFTSLVzmQ=; b=cz3FRZpIXEdBacZ9X8yxYsqKdd
        3TwMjwPk+OiCunEKlvtvOfTpo6KkvmAV9eMTXyWqDvXf0no9JJEeu7mj5DmuY5uiquynQG+OGpTBH
        9uutB4Lht+UCDAUOwmbgVhpE6NQzm4En/OSanGKvCRVKwVgA87AOB4HRR/zYvQNtgiCk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hiPg9-0000GT-HO; Tue, 02 Jul 2019 22:47:05 +0200
Date:   Tue, 2 Jul 2019 22:47:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org, netdev <netdev@vger.kernel.org>
Subject: Validation of forward_delay seems wrong...
Message-ID: <20190702204705.GC28471@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikolay

The man page says that the bridge forward_delay is in units of
seconds, and should be between 2 and 30.

I've tested on a couple of different kernel versions, and this appears
to be not working correctly:

ip link set br0 type bridge forward_delay 2
RTNETLINK answers: Numerical result out of range

ip link set br0 type bridge forward_delay 199
RTNETLINK answers: Numerical result out of range

ip link set br0 type bridge forward_delay 200
# 

ip link set br0 type bridge forward_delay 3000
#

ip link set br0 type bridge forward_delay 3001
RTNETLINK answers: Numerical result out of range

I've not checked what delay is actually being used here, but clearly
something is mixed up.

grep HZ .config 
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ_FULL is not set
# CONFIG_NO_HZ is not set
CONFIG_HZ_FIXED=0
CONFIG_HZ_100=y
# CONFIG_HZ_200 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_500 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100

Thanks
	Andrew
