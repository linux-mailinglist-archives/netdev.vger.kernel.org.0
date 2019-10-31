Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE9F4EB441
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 16:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbfJaPwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 11:52:34 -0400
Received: from www.os-cillation.de ([87.106.250.87]:34756 "EHLO
        www.os-cillation.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbfJaPwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 11:52:34 -0400
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Oct 2019 11:52:33 EDT
Received: by www.os-cillation.de (Postfix, from userid 1030)
        id 484517D3; Thu, 31 Oct 2019 16:44:28 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        s17988253.onlinehome-server.info
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.5 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from core2019.osc.gmbh (p578a635d.dip0.t-ipconnect.de [87.138.99.93])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by www.os-cillation.de (Postfix) with ESMTPSA id ED63E8B;
        Thu, 31 Oct 2019 16:44:27 +0100 (CET)
Received: from [192.168.3.92] (hd2019.osc.gmbh [192.168.3.92])
        by core2019.osc.gmbh (Postfix) with ESMTPA id AE5868E008B;
        Thu, 31 Oct 2019 16:44:25 +0100 (CET)
From:   Hendrik Donner <hd@os-cillation.de>
Subject: [Possible regression?] ip route deletion behavior change
Openpgp: preference=signencrypt
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
Message-ID: <603d815f-f6db-3967-c0df-cbf084a1cbcd@os-cillation.de>
Date:   Thu, 31 Oct 2019 16:44:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

analyzing a network issue on our embedded system product i found a change in behavior 
regarding the removal of routing table entries when an IP address is removed.

On older kernel releases before commit 5a56a0b3a45dd0cc5b2f7bec6afd053a474ed9f5
(simplified example):

Routing table:

# ip r
default via 10.0.2.2 dev enp0s3 proto dhcp src 10.0.2.15 metric 1024
10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.15
10.0.2.2 dev enp0s3 proto dhcp scope link src 10.0.2.15 metric 1024
10.20.0.0/14 via 10.0.2.2 dev enp0s3 src 10.20.40.100

The last route was manually added with ip r add.

Removing the IP 10.20.40.100 from enp0s3 also removes the last route:

# ip r
default via 10.0.2.2 dev enp0s3 proto dhcp src 10.0.2.15 metric 1024
10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.15
10.0.2.2 dev enp0s3 proto dhcp scope link src 10.0.2.15 metric 1024

After the mentioned commit - so since v4.10 - the route will no longer be removed. At 
least for my team that's a surprising change in behavior because our system relies on
the old behavior.

Reverting the commit restores the old behavior.

I'm aware that our use case is a bit odd, but according to the commit message commit 
5a56a0b3a45dd0cc5b2f7bec6afd053a474ed9f5 was meant to fix VRF related behavior while
having the described (maybe unintended?) user visible side effect for non-VRF usage.

Is that a regression in routing table management?

Best regards,
Hendrik

(I'm not subscribed to the mailing list, please keep me in replies)


