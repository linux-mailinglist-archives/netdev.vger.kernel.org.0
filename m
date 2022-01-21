Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214AD4964ED
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 19:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381982AbiAUSWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 13:22:14 -0500
Received: from giacobini.uberspace.de ([185.26.156.129]:38914 "EHLO
        giacobini.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236001AbiAUSWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 13:22:13 -0500
Received: (qmail 15978 invoked by uid 990); 21 Jan 2022 18:22:11 -0000
Authentication-Results: giacobini.uberspace.de;
        auth=pass (plain)
Message-ID: <4f3d6dcf-c142-9a99-df97-6190c8f2abc9@eknoes.de>
Date:   Fri, 21 Jan 2022 19:22:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH] Bluetooth: hci_event: Ignore multiple conn complete
 events
Content-Language: en-US
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220121173622.192744-1-soenke.huster@eknoes.de>
From:   =?UTF-8?Q?S=c3=b6nke_Huster?= <soenke.huster@eknoes.de>
In-Reply-To: <20220121173622.192744-1-soenke.huster@eknoes.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Bar: -
X-Rspamd-Report: MIME_GOOD(-0.1) BAYES_HAM(-2.999992) SUSPICIOUS_RECIPS(1.5)
X-Rspamd-Score: -1.599992
Received: from unknown (HELO unkown) (::1)
        by giacobini.uberspace.de (Haraka/2.8.28) with ESMTPSA; Fri, 21 Jan 2022 19:22:11 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I just noticed that just checking for handle does not work, as obviously 0x0 could also be a handle value and therefore it can't be distinguished, whether it is not set yet or it is 0x0.

On 21.01.22 18:36, Soenke Huster wrote:
> When a HCI_CONNECTION_COMPLETE event is received multiple times
> for the same handle, the device is registered multiple times which leads
> to memory corruptions. Therefore, consequent events for a single
> connection are ignored.
> 
> The conn->state can hold different values so conn->handle is
> checked to detect whether a connection is already set up.
> 
> Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=215497
> Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
> ---
> This fixes the referenced bug and several use-after-free issues I discovered.
> I tagged it as RFC, as I am not 100% sure if checking the existence of the
> handle is the correct approach, but to the best of my knowledge it must be
> set for the first time in this function for valid connections of this event,
> therefore it should be fine.
> 
> net/bluetooth/hci_event.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 681c623aa380..71ccb12c928d 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -3106,6 +3106,17 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, void *data,
>  		}
>  	}
>  
> +	/* The HCI_Connection_Complete event is only sent once per connection.
> +	 * Processing it more than once per connection can corrupt kernel memory.
> +	 *
> +	 * As the connection handle is set here for the first time, it indicates
> +	 * whether the connection is already set up.
> +	 */
> +	if (conn->handle) {
> +		bt_dev_err(hdev, "Ignoring HCI_Connection_Complete for existing connection");
> +		goto unlock;
> +	}
> +
>  	if (!ev->status) {
>  		conn->handle = __le16_to_cpu(ev->handle);
>  
