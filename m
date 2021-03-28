Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7145934BFBC
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 01:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbhC1XPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 19:15:00 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:47148 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231424AbhC1XO1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 19:14:27 -0400
X-Greylist: delayed 1189 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Mar 2021 19:14:27 EDT
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1lQeIk-0002kb-7d; Mon, 29 Mar 2021 00:54:34 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: rtlwifi/rtl8192cu AP mode broken with PS STA
Message-ID: <e2924d81-0e30-2dd0-292b-428fea199484@maciej.szmigiero.name>
Date:   Mon, 29 Mar 2021 00:54:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

It looks like rtlwifi/rtl8192cu AP mode is broken when a STA is using PS,
since the driver does not update its beacon to account for TIM changes,
so a station that is sleeping will never learn that it has packets
buffered at the AP.

Looking at the code, the rtl8192cu driver implements neither the set_tim()
callback, nor does it explicitly update beacon data periodically, so it
has no way to learn that it had changed.

This results in the AP mode being virtually unusable with STAs that do
PS and don't allow for it to be disabled (IoT devices, mobile phones,
etc.).

I think the easiest fix here would be to implement set_tim() for example
the way rt2x00 driver does: queue a work or schedule a tasklet to update
the beacon data on the device.

Thanks,
Maciej
