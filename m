Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013D9316AA9
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 17:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbhBJQEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 11:04:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47614 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbhBJQD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 11:03:57 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1l9rxQ-0002Bd-0K; Wed, 10 Feb 2021 16:03:12 +0000
To:     Sean Wang <sean.wang@mediatek.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Soul Huang <Soul.Huang@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
From:   Colin Ian King <colin.king@canonical.com>
Subject: re: mt76: mt7921: add MCU support
Message-ID: <57068965-649f-ef8e-0dd2-9d25b8bec1c7@canonical.com>
Date:   Wed, 10 Feb 2021 16:03:11 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Static analysis with Coverity on linux-next has found an issue with the
following commit:

commit 1c099ab44727c8e42fe4de4d91b53cec3ef02860
Author: Sean Wang <sean.wang@mediatek.com>
Date:   Thu Jan 28 03:33:39 2021 +0800

    mt76: mt7921: add MCU support

The analysis is as follows:

390 static void
391 mt7921_mcu_tx_rate_report(struct mt7921_dev *dev, struct sk_buff *skb,
392                          u16 wlan_idx)
393 {
394        struct mt7921_mcu_wlan_info_event *wtbl_info =
395                (struct mt7921_mcu_wlan_info_event *)(skb->data);
396        struct rate_info rate = {};
397        u8 curr_idx = wtbl_info->rate_info.rate_idx;
398        u16 curr = le16_to_cpu(wtbl_info->rate_info.rate[curr_idx]);
399        struct mt7921_mcu_peer_cap peer = wtbl_info->peer_cap;
400        struct mt76_phy *mphy = &dev->mphy;

   1. var_decl: Declaring variable stats without initializer.

401        struct mt7921_sta_stats *stats;
402        struct mt7921_sta *msta;
403        struct mt76_wcid *wcid;
404

   2. Condition wlan_idx >= 288, taking false branch.

405        if (wlan_idx >= MT76_N_WCIDS)
406                return;

   3. Condition 0 /* !((((sizeof ((*dev).mt76.wcid[wlan_idx]) == sizeof
(char) || sizeof ((*dev).mt76.wcid[wlan_idx]) == sizeof (short)) ||
sizeof ((*dev).mt76.wcid[wlan_idx]) == sizeof (int)) || sizeof
((*dev).mt76.wcid[wlan_idx]) == sizeof (long)) || sizeof
((*dev).mt76.wcid[wlan_idx]) == sizeof (long long)) */, taking false branch.

   4. Condition debug_lockdep_rcu_enabled(), taking true branch.
   5. Condition !__warned, taking true branch.
   6. Condition 0, taking false branch.
   7. Condition rcu_read_lock_held(), taking false branch.
407        wcid = rcu_dereference(dev->mt76.wcid[wlan_idx]);
   8. Condition !wcid, taking true branch.
408        if (!wcid) {

Uninitialized pointer write (UNINIT)
   9. uninit_use: Using uninitialized value stats.

409                stats->tx_rate = rate;
410                return;
411        }

Line 409 dereferences pointer stats, however, this pointer has not yet
been initialized.  The initialization occurs later:

413        msta = container_of(wcid, struct mt7921_sta, wcid);
414        stats = &msta->stats;

Colin
