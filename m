Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9B63E84DE
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 22:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbhHJU7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 16:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbhHJU7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 16:59:00 -0400
Received: from tulum.helixd.com (unknown [IPv6:2604:4500:0:9::b0fd:3c92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5775CC0613C1
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 13:58:32 -0700 (PDT)
Received: from [IPv6:2600:8801:8800:12e8:bca6:fa07:303d:4438] (unknown [IPv6:2600:8801:8800:12e8:bca6:fa07:303d:4438])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        (Authenticated sender: dalcocer@helixd.com)
        by tulum.helixd.com (Postfix) with ESMTPSA id A7379203D6;
        Tue, 10 Aug 2021 13:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tulum.helixd.com;
        s=mail; t=1628629104;
        bh=V+CpTfYEiunqmVLrkkm47x71CQkdC1OaC40eXjg3j0U=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=YLJWn8vi1GUipS5p53KfgVVmElsTOSIGmOlYLYVbVm94Y2wGB1F+61Eh5OeGS6vCA
         KWCh9UmEgs9wVjmaOqd6I0DFPeKZNmq99+1MfedNe0EYngA651Bsbo0izG7RZOZLnh
         8+2lLKxI3GKltT4zVh46Xtp0yqoFhZXM5OI6sobM=
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
From:   Dario Alcocer <dalcocer@helixd.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <bcd589bd-eeb4-478c-127b-13f613fdfebc@helixd.com>
 <527bcc43-d99c-f86e-29b0-2b4773226e38@helixd.com>
 <fb7ced72-384c-9908-0a35-5f425ec52748@helixd.com> <YQGgvj2e7dqrHDCc@lunn.ch>
 <59790fef-bf4a-17e5-4927-5f8d8a1645f7@helixd.com> <YQGu2r02XdMR5Ajp@lunn.ch>
 <11b81662-e9ce-591c-122a-af280f1e1f59@helixd.com>
 <fea36eed-eaff-4381-b2fd-628b60237aab@helixd.com>
 <de5758c6-4379-1b70-19ff-d6dd2b3ea269@helixd.com>
 <4902bb0e-87ad-3fa4-f7af-bbe7b43ad68f@helixd.com> <YQ7Xo3UII/1Gw/G1@lunn.ch>
 <ac33ec5f-568e-e43c-5d58-48876a7d9b0d@helixd.com>
Message-ID: <404e5b00-59ee-1165-4f7c-d0853c730354@helixd.com>
Date:   Tue, 10 Aug 2021 13:58:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <ac33ec5f-568e-e43c-5d58-48876a7d9b0d@helixd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Well, I misread the schematic; the DSA ports are connected via four pins 
on each of the MV88E6176 chips (S_RXP, S_RXN, S_TXP, S_TXN):

S_RXP (PHY 0x1E) <---> S_TXP (PHY 0x1A)
S_RXN (PHY 0x1E) <---> S_TXN (PHY 0x1A)
S_TXP (PHY 0x1E) <---> S_RXP (PHY 0x1A)
S_TXN (PHY 0x1E) <---> S_RXN (PHY 0x1A)

As you mentioned before, 1G requires 4 pairs. Thus, it seems that 
phy-mode = "1000base-x" and speed = <1000> cannot be used for the SERDES 
link.

So far, I've tried phy-mode = "mii" with speed = <100>, with no success.

Are there more appropriate values I should use to configure the SERDES 
phy-mode and speed device-tree resources?
