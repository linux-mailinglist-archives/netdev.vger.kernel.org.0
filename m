Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5611AFC15
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 18:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgDSQmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 12:42:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48554 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgDSQmy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 12:42:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=iFsgbsnFgsbhPnlwLkM/14implnwlgFFSCTSxq+tcOw=; b=zkki5Y4g8r/noSSk8K8IMG45Dk
        ABEzJAmZy53zZSiAiqq06tQWxQUDcE9CUBbSbL9pfMZStX/PZRiXzT39drwbUYMd2NfyC1enPFhHj
        vESZVSEWGOnAyt8s9fgFKY5i0ORHuMm+V2LShbCvmICvbmgdmSV0QGvM8GHbssEJkxps=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQD1v-003ewJ-1B; Sun, 19 Apr 2020 18:42:51 +0200
Date:   Sun, 19 Apr 2020 18:42:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Subject: Re: [RFC PATCH net-next] net: bridge: fix client roaming from DSA
 user port
Message-ID: <20200419164251.GM836632@lunn.ch>
References: <20200419161946.19984-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200419161946.19984-1-dqfext@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 12:19:46AM +0800, DENG Qingfang wrote:
> When a client roams from a DSA user port to a soft-bridged port (such as WiFi
> interface), the left-over MAC entry in the switch HW is not deleted, causing
> inconsistency between Linux fdb and the switch MAC table. As a result, the
> client cannot talk to other hosts which are on that DSA user port until the
> MAC entry expires.
> 
> Solve this by notifying switchdev fdb to delete the leftover entry when an
> entry is updated. Remove the added_by_user check in DSA
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
> I tried this on mt7530 and mv88e6xxx, but only mt7530 works.
> In previous discussion[1], Andrew Lunn said "try playing with auto learning
> for the CPU port" but it didn't work on mv88e6xxx either

Hi Deng

We should probably first define how we expect moving MAC to work. Then
we can make any core fixes, and driver fixes.

For DSA, we have assumed that the software bridge and the hardware
bridge are independent, each performs its own learning. Only static
entries are kept in sync.

How should this separate learning work for a MAC address which moves?

    Andrew
