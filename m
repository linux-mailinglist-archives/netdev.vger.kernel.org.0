Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFE92CD878
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 15:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730785AbgLCOEQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Dec 2020 09:04:16 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:55853 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730572AbgLCOEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 09:04:15 -0500
Received: from marcel-macbook.holtmann.net (unknown [37.83.193.87])
        by mail.holtmann.org (Postfix) with ESMTPSA id 90B33CECFD;
        Thu,  3 Dec 2020 15:10:46 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.20.0.2.21\))
Subject: Re: [PATCH v1 1/5] Bluetooth: advmon offload MSFT add rssi support
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201203182903.v1.1.I92d2e2a87419730d60136680cbe27636baf94b15@changeid>
Date:   Thu, 3 Dec 2020 15:03:31 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Yun-Hao Chung <howardchung@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <20B6F2AD-1A60-4E3C-84C2-E3CB7294FABC@holtmann.org>
References: <20201203102936.4049556-1-apusaka@google.com>
 <20201203182903.v1.1.I92d2e2a87419730d60136680cbe27636baf94b15@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3654.20.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> MSFT needs rssi parameter for monitoring advertisement packet,
> therefore we should supply them from mgmt.
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> Reviewed-by: Yun-Hao Chung <howardchung@google.com>

I don’t need any Reviewed-by if they are not catching an obvious user API breakage.

> ---
> 
> include/net/bluetooth/hci_core.h | 9 +++++++++
> include/net/bluetooth/mgmt.h     | 9 +++++++++
> net/bluetooth/mgmt.c             | 8 ++++++++
> 3 files changed, 26 insertions(+)
> 
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index 9873e1c8cd16..42d446417817 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -246,8 +246,17 @@ struct adv_pattern {
> 	__u8 value[HCI_MAX_AD_LENGTH];
> };
> 
> +struct adv_rssi_thresholds {
> +	__s8 low_threshold;
> +	__s8 high_threshold;
> +	__u16 low_threshold_timeout;
> +	__u16 high_threshold_timeout;
> +	__u8 sampling_period;
> +};
> +
> struct adv_monitor {
> 	struct list_head patterns;
> +	struct adv_rssi_thresholds rssi;
> 	bool		active;
> 	__u16		handle;
> };
> diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
> index d8367850e8cd..dc534837be0e 100644
> --- a/include/net/bluetooth/mgmt.h
> +++ b/include/net/bluetooth/mgmt.h
> @@ -763,9 +763,18 @@ struct mgmt_adv_pattern {
> 	__u8 value[31];
> } __packed;
> 
> +struct mgmt_adv_rssi_thresholds {
> +	__s8 high_threshold;
> +	__le16 high_threshold_timeout;
> +	__s8 low_threshold;
> +	__le16 low_threshold_timeout;
> +	__u8 sampling_period;
> +} __packed;
> +
> #define MGMT_OP_ADD_ADV_PATTERNS_MONITOR	0x0052
> struct mgmt_cp_add_adv_patterns_monitor {
> 	__u8 pattern_count;
> +	struct mgmt_adv_rssi_thresholds rssi;
> 	struct mgmt_adv_pattern patterns[];
> } __packed;

This is something we can not do. It breaks an userspace facing API. Is the mgmt opcode 0x0052 in an already released kernel?

Regards

Marcel

