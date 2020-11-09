Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393A12AB837
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 13:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729724AbgKIM3H convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 9 Nov 2020 07:29:07 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:58153 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727774AbgKIM3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 07:29:07 -0500
Received: from marcel-macbook.fritz.box (p4fefcf0f.dip0.t-ipconnect.de [79.239.207.15])
        by mail.holtmann.org (Postfix) with ESMTPSA id F40CCCECC5;
        Mon,  9 Nov 2020 13:36:12 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v7 4/5] mgmt: Add supports of variable length parameter in
 mgmt_config
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201109155659.v7.4.I9231b35b0be815c32c3a3ec48dcd1d68fa65daf4@changeid>
Date:   Mon, 9 Nov 2020 13:29:03 +0100
Cc:     Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        mmandlik@chromium.org, alainm@chromium.org, mcchou@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C2493728-6973-4858-90A1-7A13EAB1942B@holtmann.org>
References: <20201109155659.v7.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
 <20201109155659.v7.4.I9231b35b0be815c32c3a3ec48dcd1d68fa65daf4@changeid>
To:     Howard Chung <howardchung@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Howard,

> This adds support of variable length parameter in mgmt_config.

I don’t see how this commit message describes the change correctly.

> 
> Signed-off-by: Howard Chung <howardchung@google.com>
> ---
> 
> (no changes since v1)
> 
> net/bluetooth/mgmt_config.c | 140 +++++++++++++++++++++---------------
> 1 file changed, 84 insertions(+), 56 deletions(-)
> 
> diff --git a/net/bluetooth/mgmt_config.c b/net/bluetooth/mgmt_config.c
> index 2d3ad288c78ac..b735e59c7fd51 100644
> --- a/net/bluetooth/mgmt_config.c
> +++ b/net/bluetooth/mgmt_config.c
> @@ -11,72 +11,100 @@
> #include "mgmt_util.h"
> #include "mgmt_config.h"
> 
> -#define HDEV_PARAM_U16(_param_code_, _param_name_) \
> -{ \
> -	{ cpu_to_le16(_param_code_), sizeof(__u16) }, \
> -	{ cpu_to_le16(hdev->_param_name_) } \
> -}
> +#define HDEV_PARAM_U16(_param_name_) \
> +	struct {\
> +		struct mgmt_tlv entry; \
> +		__le16 value; \
> +	} __packed _param_name_
> 
> -#define HDEV_PARAM_U16_JIFFIES_TO_MSECS(_param_code_, _param_name_) \
> -{ \
> -	{ cpu_to_le16(_param_code_), sizeof(__u16) }, \
> -	{ cpu_to_le16(jiffies_to_msecs(hdev->_param_name_)) } \
> -}
> +#define TLV_SET_U16(_param_code_, _param_name_) \
> +	{ \
> +		{ cpu_to_le16(_param_code_), sizeof(__u16) }, \
> +		  cpu_to_le16(hdev->_param_name_) \
> +	}
> +
> +#define TLV_SET_U16_JIFFIES_TO_MSECS(_param_code_, _param_name_) \
> +	{ \
> +		{ cpu_to_le16(_param_code_), sizeof(__u16) }, \
> +		  cpu_to_le16(jiffies_to_msecs(hdev->_param_name_)) \
> +	}
> 
> int read_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
> 			   u16 data_len)
> {
> -	struct {
> -		struct mgmt_tlv entry;
> -		union {
> -			/* This is a simplification for now since all values
> -			 * are 16 bits.  In the future, this code may need
> -			 * refactoring to account for variable length values
> -			 * and properly calculate the required buffer size.
> -			 */
> -			__le16 value;
> -		};
> -	} __packed params[] = {
> +	int ret;
> +	struct mgmt_rp_read_def_system_config {
> 		/* Please see mgmt-api.txt for documentation of these values */
> -		HDEV_PARAM_U16(0x0000, def_page_scan_type),
> -		HDEV_PARAM_U16(0x0001, def_page_scan_int),
> -		HDEV_PARAM_U16(0x0002, def_page_scan_window),
> -		HDEV_PARAM_U16(0x0003, def_inq_scan_type),
> -		HDEV_PARAM_U16(0x0004, def_inq_scan_int),
> -		HDEV_PARAM_U16(0x0005, def_inq_scan_window),
> -		HDEV_PARAM_U16(0x0006, def_br_lsto),
> -		HDEV_PARAM_U16(0x0007, def_page_timeout),
> -		HDEV_PARAM_U16(0x0008, sniff_min_interval),
> -		HDEV_PARAM_U16(0x0009, sniff_max_interval),
> -		HDEV_PARAM_U16(0x000a, le_adv_min_interval),
> -		HDEV_PARAM_U16(0x000b, le_adv_max_interval),
> -		HDEV_PARAM_U16(0x000c, def_multi_adv_rotation_duration),
> -		HDEV_PARAM_U16(0x000d, le_scan_interval),
> -		HDEV_PARAM_U16(0x000e, le_scan_window),
> -		HDEV_PARAM_U16(0x000f, le_scan_int_suspend),
> -		HDEV_PARAM_U16(0x0010, le_scan_window_suspend),
> -		HDEV_PARAM_U16(0x0011, le_scan_int_discovery),
> -		HDEV_PARAM_U16(0x0012, le_scan_window_discovery),
> -		HDEV_PARAM_U16(0x0013, le_scan_int_adv_monitor),
> -		HDEV_PARAM_U16(0x0014, le_scan_window_adv_monitor),
> -		HDEV_PARAM_U16(0x0015, le_scan_int_connect),
> -		HDEV_PARAM_U16(0x0016, le_scan_window_connect),
> -		HDEV_PARAM_U16(0x0017, le_conn_min_interval),
> -		HDEV_PARAM_U16(0x0018, le_conn_max_interval),
> -		HDEV_PARAM_U16(0x0019, le_conn_latency),
> -		HDEV_PARAM_U16(0x001a, le_supv_timeout),
> -		HDEV_PARAM_U16_JIFFIES_TO_MSECS(0x001b,
> -						def_le_autoconnect_timeout),
> -		HDEV_PARAM_U16(0x001d, advmon_allowlist_duration),
> -		HDEV_PARAM_U16(0x001e, advmon_no_filter_duration),
> +		HDEV_PARAM_U16(def_page_scan_type);
> +		HDEV_PARAM_U16(def_page_scan_int);
> +		HDEV_PARAM_U16(def_page_scan_window);
> +		HDEV_PARAM_U16(def_inq_scan_type);
> +		HDEV_PARAM_U16(def_inq_scan_int);
> +		HDEV_PARAM_U16(def_inq_scan_window);
> +		HDEV_PARAM_U16(def_br_lsto);
> +		HDEV_PARAM_U16(def_page_timeout);
> +		HDEV_PARAM_U16(sniff_min_interval);
> +		HDEV_PARAM_U16(sniff_max_interval);
> +		HDEV_PARAM_U16(le_adv_min_interval);
> +		HDEV_PARAM_U16(le_adv_max_interval);
> +		HDEV_PARAM_U16(def_multi_adv_rotation_duration);
> +		HDEV_PARAM_U16(le_scan_interval);
> +		HDEV_PARAM_U16(le_scan_window);
> +		HDEV_PARAM_U16(le_scan_int_suspend);
> +		HDEV_PARAM_U16(le_scan_window_suspend);
> +		HDEV_PARAM_U16(le_scan_int_discovery);
> +		HDEV_PARAM_U16(le_scan_window_discovery);
> +		HDEV_PARAM_U16(le_scan_int_adv_monitor);
> +		HDEV_PARAM_U16(le_scan_window_adv_monitor);
> +		HDEV_PARAM_U16(le_scan_int_connect);
> +		HDEV_PARAM_U16(le_scan_window_connect);
> +		HDEV_PARAM_U16(le_conn_min_interval);
> +		HDEV_PARAM_U16(le_conn_max_interval);
> +		HDEV_PARAM_U16(le_conn_latency);
> +		HDEV_PARAM_U16(le_supv_timeout);
> +		HDEV_PARAM_U16(def_le_autoconnect_timeout);
> +		HDEV_PARAM_U16(advmon_allowlist_duration);
> +		HDEV_PARAM_U16(advmon_no_filter_duration);
> +	} __packed rp = {
> +		TLV_SET_U16(0x0000, def_page_scan_type),
> +		TLV_SET_U16(0x0001, def_page_scan_int),
> +		TLV_SET_U16(0x0002, def_page_scan_window),
> +		TLV_SET_U16(0x0003, def_inq_scan_type),
> +		TLV_SET_U16(0x0004, def_inq_scan_int),
> +		TLV_SET_U16(0x0005, def_inq_scan_window),
> +		TLV_SET_U16(0x0006, def_br_lsto),
> +		TLV_SET_U16(0x0007, def_page_timeout),
> +		TLV_SET_U16(0x0008, sniff_min_interval),
> +		TLV_SET_U16(0x0009, sniff_max_interval),
> +		TLV_SET_U16(0x000a, le_adv_min_interval),
> +		TLV_SET_U16(0x000b, le_adv_max_interval),
> +		TLV_SET_U16(0x000c, def_multi_adv_rotation_duration),
> +		TLV_SET_U16(0x000d, le_scan_interval),
> +		TLV_SET_U16(0x000e, le_scan_window),
> +		TLV_SET_U16(0x000f, le_scan_int_suspend),
> +		TLV_SET_U16(0x0010, le_scan_window_suspend),
> +		TLV_SET_U16(0x0011, le_scan_int_discovery),
> +		TLV_SET_U16(0x0012, le_scan_window_discovery),
> +		TLV_SET_U16(0x0013, le_scan_int_adv_monitor),
> +		TLV_SET_U16(0x0014, le_scan_window_adv_monitor),
> +		TLV_SET_U16(0x0015, le_scan_int_connect),
> +		TLV_SET_U16(0x0016, le_scan_window_connect),
> +		TLV_SET_U16(0x0017, le_conn_min_interval),
> +		TLV_SET_U16(0x0018, le_conn_max_interval),
> +		TLV_SET_U16(0x0019, le_conn_latency),
> +		TLV_SET_U16(0x001a, le_supv_timeout),
> +		TLV_SET_U16_JIFFIES_TO_MSECS(0x001b,
> +					     def_le_autoconnect_timeout),
> +		TLV_SET_U16(0x001d, advmon_allowlist_duration),
> +		TLV_SET_U16(0x001e, advmon_no_filter_duration),
> 	};
> -	struct mgmt_rp_read_def_system_config *rp = (void *)params;
> 
> 	bt_dev_dbg(hdev, "sock %p", sk);
> 
> -	return mgmt_cmd_complete(sk, hdev->id,
> -				 MGMT_OP_READ_DEF_SYSTEM_CONFIG,
> -				 0, rp, sizeof(params));
> +	ret = mgmt_cmd_complete(sk, hdev->id,
> +				MGMT_OP_READ_DEF_SYSTEM_CONFIG,
> +				0, &rp, sizeof(rp));
> +	return ret;
> }

Regards

Marcel

