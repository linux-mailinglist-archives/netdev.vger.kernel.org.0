Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA0753BB93
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 17:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236329AbiFBPbD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 2 Jun 2022 11:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234580AbiFBPbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 11:31:02 -0400
Received: from mail.holtmann.org (coyote.holtmann.net [212.227.132.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 55A2E13C1F6
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 08:31:01 -0700 (PDT)
Received: from smtpclient.apple (p4ff9fc30.dip0.t-ipconnect.de [79.249.252.48])
        by mail.holtmann.org (Postfix) with ESMTPSA id 5FA22CED19;
        Thu,  2 Jun 2022 17:24:41 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH v2] Bluetooth: clear the temporary linkkey in
 hci_conn_cleanup
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20220602151456.v2.1.I9f2f4ef058af96a5ad610a90c6938ed17a7d103f@changeid>
Date:   Thu, 2 Jun 2022 17:24:40 +0200
Cc:     BlueZ <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <CB19541D-F4AD-47D9-A1DC-52A0519EFB69@holtmann.org>
References: <20220602151456.v2.1.I9f2f4ef058af96a5ad610a90c6938ed17a7d103f@changeid>
To:     Alain Michaud <alainmichaud@google.com>
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alain,

> If a hardware error occurs and the connections are flushed without a
> disconnection_complete event being signaled, the temporary linkkeys are
> not flushed.
> 
> This change ensures that any outstanding flushable linkkeys are flushed
> when the connection are flushed from the hash table.
> 
> Signed-off-by: Alain Michaud <alainm@chromium.org>
> 
> ---
> 
> Changes in v2:
> -Address Feedback from Luiz
> 
> net/bluetooth/hci_conn.c  | 3 +++
> net/bluetooth/hci_event.c | 4 ++--
> 2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
> index 352d7d612128..5911ca0c5239 100644
> --- a/net/bluetooth/hci_conn.c
> +++ b/net/bluetooth/hci_conn.c
> @@ -118,6 +118,9 @@ static void hci_conn_cleanup(struct hci_conn *conn)
> 	if (test_bit(HCI_CONN_PARAM_REMOVAL_PEND, &conn->flags))
> 		hci_conn_params_del(conn->hdev, &conn->dst, conn->dst_type);
> 
> +	if (test_and_clear_bit(HCI_CONN_FLUSH_KEY, &conn->flags))
> +		hci_remove_link_key(hdev, &conn->dst);
> +
> 	hci_chan_list_flush(conn);
> 
> 	hci_conn_hash_del(hdev, conn);
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 6b83f9b0082c..b67fdd1ad8da 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -2729,7 +2729,7 @@ static void hci_cs_disconnect(struct hci_dev *hdev, u8 status)
> 	mgmt_conn = test_and_clear_bit(HCI_CONN_MGMT_CONNECTED, &conn->flags);
> 
> 	if (conn->type == ACL_LINK) {
> -		if (test_bit(HCI_CONN_FLUSH_KEY, &conn->flags))
> +		if (test_and_clear_bit(HCI_CONN_FLUSH_KEY, &conn->flags))
> 			hci_remove_link_key(hdev, &conn->dst);
> 	}
> 
> @@ -3372,7 +3372,7 @@ static void hci_disconn_complete_evt(struct hci_dev *hdev, void *data,
> 				reason, mgmt_connected);
> 
> 	if (conn->type == ACL_LINK) {
> -		if (test_bit(HCI_CONN_FLUSH_KEY, &conn->flags))
> +		if (test_and_clear_bit(HCI_CONN_FLUSH_KEY, &conn->flags))
> 			hci_remove_link_key(hdev, &conn->dst);

do you mind splitting this into two patches. The test_and_clear_bit() change is obviously correct, but it is fix that is not described in the commit message.

Or if you think that it makes sense to keep this together, please add a paragraph about it in the commit message.

Regards

Marcel

