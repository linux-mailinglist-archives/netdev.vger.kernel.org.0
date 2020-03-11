Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C82DC181B4A
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 15:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbgCKOdC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 11 Mar 2020 10:33:02 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:50336 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729309AbgCKOdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 10:33:02 -0400
Received: from [172.20.10.2] (x59cc8a78.dyn.telefonica.de [89.204.138.120])
        by mail.holtmann.org (Postfix) with ESMTPSA id A6AF1CECDF;
        Wed, 11 Mar 2020 15:42:28 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH] Bluetooth: include file and function names in logs
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200310095959.1.I864ded253b57454e732ab5acb1cae5b22c67cfae@changeid>
Date:   Wed, 11 Mar 2020 15:32:59 +0100
Cc:     Joseph Hwang <josephsih@chromium.org>,
        Yoni Shavit <yshavit@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <017831DA-9E5C-438A-A094-2826255076EC@holtmann.org>
References: <20200310095959.1.I864ded253b57454e732ab5acb1cae5b22c67cfae@changeid>
To:     Manish Mandlik <mmandlik@google.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

> Include file and function names in bluetooth kernel logs to
> help debugging.
> 
> Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> ---
> 
> include/net/bluetooth/bluetooth.h | 19 +++++++++++++++----
> 1 file changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
> index 1576353a27732..2024d9c53d687 100644
> --- a/include/net/bluetooth/bluetooth.h
> +++ b/include/net/bluetooth/bluetooth.h
> @@ -150,10 +150,21 @@ void bt_warn_ratelimited(const char *fmt, ...);
> __printf(1, 2)
> void bt_err_ratelimited(const char *fmt, ...);
> 
> -#define BT_INFO(fmt, ...)	bt_info(fmt "\n", ##__VA_ARGS__)
> -#define BT_WARN(fmt, ...)	bt_warn(fmt "\n", ##__VA_ARGS__)
> -#define BT_ERR(fmt, ...)	bt_err(fmt "\n", ##__VA_ARGS__)
> -#define BT_DBG(fmt, ...)	pr_debug(fmt "\n", ##__VA_ARGS__)
> +static inline const char *basename(const char *path)
> +{
> +	const char *str = strrchr(path, '/');
> +
> +	return str ? (str + 1) : path;
> +}
> +
> +#define BT_INFO(fmt, ...)	bt_info("%s:%s() " fmt "\n",		\
> +				basename(__FILE__), __func__, ##__VA_ARGS__)
> +#define BT_WARN(fmt, ...)	bt_warn("%s:%s() " fmt "\n",		\
> +				basename(__FILE__), __func__, ##__VA_ARGS__)
> +#define BT_ERR(fmt, ...)	bt_err("%s:%s() " fmt "\n",		\
> +				basename(__FILE__), __func__, ##__VA_ARGS__)
> +#define BT_DBG(fmt, ...)	pr_debug("%s:%s() " fmt "\n",		\
> +				basename(__FILE__), __func__, ##__VA_ARGS__)
> 
> #define bt_dev_info(hdev, fmt, ...)				\
> 	BT_INFO("%s: " fmt, (hdev)->name, ##__VA_ARGS__)

this is NAK from my side. We don’t want to include __FILE__ and __func__ names in the standard messages. I am however working in revamping the whole printk and debug of the Bluetooth subsystem. I will send around the initial pieces of my work as a RFC soon.

Regards

Marcel

