Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB7411634B1
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 22:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbgBRVUf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Feb 2020 16:20:35 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:38502 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbgBRVUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 16:20:35 -0500
Received: from marcel-macpro.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 9C238CECC6;
        Tue, 18 Feb 2020 22:29:57 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [Bluez PATCH v1] bluetooth: fix passkey uninitialized when used
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200218190509.Bluez.v1.1.I04681c6e295c27088c0b4ed7bb9b187d1bb4ed19@changeid>
Date:   Tue, 18 Feb 2020 22:20:32 +0100
Cc:     Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        clang-built-linux@googlegroups.com
Content-Transfer-Encoding: 8BIT
Message-Id: <D9045CD6-997B-4018-8AB0-40F15C71BF5C@holtmann.org>
References: <20200218190509.Bluez.v1.1.I04681c6e295c27088c0b4ed7bb9b187d1bb4ed19@changeid>
To:     Howard Chung <howardchung@google.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Howard,

> From: "howardchung@google.com" <howardchung@google.com>

any chance you fix your git setting to provide a From: with full name and email like you have in the signed-off-by line.

> 
> This issue cause a warning here
> https://groups.google.com/forum/#!topic/clang-built-linux/kyRKCjRsGoU
> 
> Signed-off-by: Howard Chung <howardchung@google.com>
> ---
> 
> net/bluetooth/smp.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
> index 50e0ac692ec4..fa40de69e487 100644
> --- a/net/bluetooth/smp.c
> +++ b/net/bluetooth/smp.c
> @@ -2179,10 +2179,12 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
> 		 */
> 		if (hci_find_ltk(hcon->hdev, &hcon->dst, hcon->dst_type,
> 				 hcon->role)) {
> +			/* Set passkey to 0. The value can be any number since
> +			 * it'll be ignored anyway.
> +			 */
> 			err = mgmt_user_confirm_request(hcon->hdev, &hcon->dst,
> 							hcon->type,
> -							hcon->dst_type,
> -							passkey, 1);
> +							hcon->dst_type, 0, 1);
> 			if (err)
> 				return SMP_UNSPECIFIED;
> 			set_bit(SMP_FLAG_WAIT_USER, &smp->flags);

Since I have to look at this again, I wonder if we do this correctly. Either we have a bug there or not enough comments on why the code is correct.

        if (hcon->out) {
                u8 cfm[16];

                err = smp_f4(smp->tfm_cmac, smp->remote_pk, smp->local_pk,
                             smp->rrnd, 0, cfm);
                if (err)
                        return SMP_UNSPECIFIED;

                if (crypto_memneq(smp->pcnf, cfm, 16))
                        return SMP_CONFIRM_FAILED;
        } else {
                smp_send_cmd(conn, SMP_CMD_PAIRING_RANDOM, sizeof(smp->prnd),
                             smp->prnd);
                SMP_ALLOW_CMD(smp, SMP_CMD_DHKEY_CHECK);

                /* Only Just-Works pairing requires extra checks */
                if (smp->method != JUST_WORKS)
                        goto mackey_and_ltk;

                /* If there already exists long term key in local host, leave
                 * the decision to user space since the remote device could
                 * be legitimate or malicious.
                 */
                if (hci_find_ltk(hcon->hdev, &hcon->dst, hcon->dst_type,
                                 hcon->role)) {
                        err = mgmt_user_confirm_request(hcon->hdev, &hcon->dst,
                                                        hcon->type,
                                                        hcon->dst_type,
                                                        passkey, 1);
                        if (err)
                                return SMP_UNSPECIFIED;
                        set_bit(SMP_FLAG_WAIT_USER, &smp->flags);
                }
        }

mackey_and_ltk:
        /* Generate MacKey and LTK */
        err = sc_mackey_and_ltk(smp, smp->mackey, smp->tk);
        if (err)
                return SMP_UNSPECIFIED;

        if (smp->method == JUST_WORKS || smp->method == REQ_OOB) {
                if (hcon->out) {
                        sc_dhkey_check(smp);
                        SMP_ALLOW_CMD(smp, SMP_CMD_DHKEY_CHECK);
                }
                return 0;
        }

        err = smp_g2(smp->tfm_cmac, pkax, pkbx, na, nb, &passkey);
        if (err)
                return SMP_UNSPECIFIED;

        err = mgmt_user_confirm_request(hcon->hdev, &hcon->dst, hcon->type,
                                        hcon->dst_type, passkey, 0);
        if (err)
                return SMP_UNSPECIFIED;

        set_bit(SMP_FLAG_WAIT_USER, &smp->flags);

        return 0;
}

Since we are already !hcon->out and smp->method == JUST_WORKS, why are we moving into mackey_and_ltk path? If we have already an LTK, then we just should bail out after setting SMP_FLAG_WAIT_USER, right?

@@ -2115,7 +2115,7 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
        struct l2cap_chan *chan = conn->smp;
        struct smp_chan *smp = chan->data;
        struct hci_conn *hcon = conn->hcon;
-       u8 *pkax, *pkbx, *na, *nb;
+       u8 *pkax, *pkbx, *na, *nb, confirm_hint;
        u32 passkey;
        int err;
 
@@ -2179,13 +2179,9 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
                 */
                if (hci_find_ltk(hcon->hdev, &hcon->dst, hcon->dst_type,
                                 hcon->role)) {
-                       err = mgmt_user_confirm_request(hcon->hdev, &hcon->dst,
-                                                       hcon->type,
-                                                       hcon->dst_type,
-                                                       passkey, 1);
-                       if (err)
-                               return SMP_UNSPECIFIED;
-                       set_bit(SMP_FLAG_WAIT_USER, &smp->flags);
+                       passkey = 0;
+                       confirm_hint = 1;
+                       goto confirm;
                }
        }
 
@@ -2207,8 +2203,11 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
        if (err)
                return SMP_UNSPECIFIED;
 
+       confirm_hint = 0;
+
+confirm:
        err = mgmt_user_confirm_request(hcon->hdev, &hcon->dst, hcon->type,
-                                       hcon->dst_type, passkey, 0);
+                                       hcon->dst_type, passkey, confirm_hint);
        if (err)
                return SMP_UNSPECIFIED;

So isn’t this the better approach and actually cleaner code? And I would still add a comment above setting passkey = 0.

Am I missing anything?

Regards

Marcel

