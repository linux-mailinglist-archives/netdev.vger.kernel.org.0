Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A748018E94D
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 15:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgCVOEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 10:04:37 -0400
Received: from mail.aboehler.at ([176.9.113.11]:42216 "EHLO mail.aboehler.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgCVOEh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 10:04:37 -0400
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Mar 2020 10:04:36 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.aboehler.at (Postfix) with ESMTP id 1A4CD618087E
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 14:56:39 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at aboehler.at
Received: from mail.aboehler.at ([127.0.0.1])
        by localhost (aboehler.at [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id sxeBzsYLuQP5 for <netdev@vger.kernel.org>;
        Sun, 22 Mar 2020 14:56:37 +0100 (CET)
Received: from [192.168.17.123] (194-166-175-239.adsl.highway.telekom.at [194.166.175.239])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: andreas@aboehler.at)
        by mail.aboehler.at (Postfix) with ESMTPSA id A095C618087D
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 14:56:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aboehler.at;
        s=default; t=1584885397;
        bh=pwI8Arp3oVvyPb+jT+/ng+o5os/QttYslJw6nMGys2M=;
        h=From:Subject:To:Date:From;
        b=lrTXeAC3E87SHGEssPUQNTZahCtJ+JVzhP/MCQkvM/yo6h/Fs4A1fOfCIIdn8q3V0
         7wXrGVSppL8g2r7/8OQcCKxzV1NrVXal4reAgPAJKd9clbNjxTvnCjkxpUqmIiYtXO
         TqhTdR8yRr/K4a4C9DCKzZXhevan9NqtWNJo9V1U=
From:   =?UTF-8?Q?Andreas_B=c3=b6hler?= <news@aboehler.at>
Subject: [RFC] MDIO firmware upload for offloading CPU
To:     netdev@vger.kernel.org
Message-ID: <27780925-4a60-f922-e1ed-e8e43a9cc8a2@aboehler.at>
Date:   Sun, 22 Mar 2020 14:56:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm working on support for AVM FRITZ!Box routers, specifically the 3390
and 3490. Both contain two SoCs: A Lantiq VDSL SoC that handles VDSL and
Ethernet connections and an Atheros SoC for WiFi. Only the Lantiq has
access to flash memory, the Atheros SoC requires firmware to be uploaded.

AVM has implemented a two-stage firmware upload: The stage 1 firmware is
transferred via MDIO (there is no PHY), the stage 2 firmware is uploaded
via Ethernet. I've got basic support up and running, but I'm unsure how
to proceed:

I implemented a user space utility that uses ioctls to upload the
firmware via MDIO. However, this only works when the switch
driver/ethernet driver is patched to allow MDIO writes to a fixed PHY
(actually, it now allows MDIO writes to an arbitrary address; I patched
the out-of-tree xrx200 driver for now). It is important to note that no
PHY probing must be done, as this confuses the target.

1. How should firmware uploads via MDIO be performed? Preferably in
userspace or in kernel space? Please keep in mind that the protocol is
entirely reverse-engineered.

2. If the firmware upload can/should be done in userspace, how do I best
get access to the MDIO bus?

3. What would be a suitable way to implement it?

Thanks,
Andreas
