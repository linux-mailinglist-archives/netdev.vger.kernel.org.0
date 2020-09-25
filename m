Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0BB278EBA
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 18:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729354AbgIYQhd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 25 Sep 2020 12:37:33 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:59995 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728038AbgIYQhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 12:37:33 -0400
Received: from [172.20.10.2] (dynamic-046-114-136-219.46.114.pool.telefonica.de [46.114.136.219])
        by mail.holtmann.org (Postfix) with ESMTPSA id ABFAECECDE;
        Fri, 25 Sep 2020 18:44:29 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v3] Bluetooth: Check for encryption key size on connect
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200922155548.v3.1.I67a8b8cd4def8166970ca37109db46d731b62bb6@changeid>
Date:   Fri, 25 Sep 2020 18:37:29 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <BC59363A-B32A-4DAA-BAF5-F7FBA01752E6@holtmann.org>
References: <20200922155548.v3.1.I67a8b8cd4def8166970ca37109db46d731b62bb6@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> When receiving connection, we only check whether the link has been
> encrypted, but not the encryption key size of the link.
> 
> This patch adds check for encryption key size, and reject L2CAP
> connection which size is below the specified threshold (default 7)
> with security block.
> 
> Here is some btmon trace.
> @ MGMT Event: New Link Key (0x0009) plen 26    {0x0001} [hci0] 5.847722
>        Store hint: No (0x00)
>        BR/EDR Address: 38:00:25:F7:F1:B0 (OUI 38-00-25)
>        Key type: Unauthenticated Combination key from P-192 (0x04)
>        Link key: 7bf2f68c81305d63a6b0ee2c5a7a34bc
>        PIN length: 0
>> HCI Event: Encryption Change (0x08) plen 4        #29 [hci0] 5.871537
>        Status: Success (0x00)
>        Handle: 256
>        Encryption: Enabled with E0 (0x01)
> < HCI Command: Read Encryp... (0x05|0x0008) plen 2  #30 [hci0] 5.871609
>        Handle: 256
>> HCI Event: Command Complete (0x0e) plen 7         #31 [hci0] 5.872524
>      Read Encryption Key Size (0x05|0x0008) ncmd 1
>        Status: Success (0x00)
>        Handle: 256
>        Key size: 3
> 
> ////// WITHOUT PATCH //////
>> ACL Data RX: Handle 256 flags 0x02 dlen 12        #42 [hci0] 5.895023
>      L2CAP: Connection Request (0x02) ident 3 len 4
>        PSM: 4097 (0x1001)
>        Source CID: 64
> < ACL Data TX: Handle 256 flags 0x00 dlen 16        #43 [hci0] 5.895213
>      L2CAP: Connection Response (0x03) ident 3 len 8
>        Destination CID: 64
>        Source CID: 64
>        Result: Connection successful (0x0000)
>        Status: No further information available (0x0000)
> 
> ////// WITH PATCH //////
>> ACL Data RX: Handle 256 flags 0x02 dlen 12        #42 [hci0] 4.887024
>      L2CAP: Connection Request (0x02) ident 3 len 4
>        PSM: 4097 (0x1001)
>        Source CID: 64
> < ACL Data TX: Handle 256 flags 0x00 dlen 16        #43 [hci0] 4.887127
>      L2CAP: Connection Response (0x03) ident 3 len 8
>        Destination CID: 0
>        Source CID: 64
>        Result: Connection refused - security block (0x0003)
>        Status: No further information available (0x0000)
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> 
> ---
> 
> Changes in v3:
> * Move the check to hci_conn_check_link_mode()
> 
> Changes in v2:
> * Add btmon trace to the commit message
> 
> net/bluetooth/hci_conn.c | 4 ++++
> 1 file changed, 4 insertions(+)
> 
> diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
> index 9832f8445d43..89085fac797c 100644
> --- a/net/bluetooth/hci_conn.c
> +++ b/net/bluetooth/hci_conn.c
> @@ -1348,6 +1348,10 @@ int hci_conn_check_link_mode(struct hci_conn *conn)
> 	    !test_bit(HCI_CONN_ENCRYPT, &conn->flags))
> 		return 0;
> 
> +	if (test_bit(HCI_CONN_ENCRYPT, &conn->flags) &&
> +	    conn->enc_key_size < conn->hdev->min_enc_key_size)
> +		return 0;
> +
> 	return 1;
> }

I am a bit concerned since we had that check and I on purpose moved it. See commit 693cd8ce3f88 for the change where I removed and commit d5bb334a8e17 where I initially added it.

Naively adding the check in that location caused a major regression with Bluetooth 2.0 devices. This makes me a bit reluctant to re-add it here since I restructured the whole change to check the key size a different location.

Now I have to ask, are you running an upstream kernel with both commits above that address KNOB vulnerability?

Regards

Marcel

