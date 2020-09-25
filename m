Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318B5278E5B
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 18:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbgIYQZy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 25 Sep 2020 12:25:54 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:34083 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729123AbgIYQZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 12:25:54 -0400
Received: from [172.20.10.2] (dynamic-046-114-136-219.46.114.pool.telefonica.de [46.114.136.219])
        by mail.holtmann.org (Postfix) with ESMTPSA id 82CBFCECDE;
        Fri, 25 Sep 2020 18:32:49 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v1] Bluetooth: Enforce key size of 16 bytes on FIPS level
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200921163021.v1.1.Id3160295d33d44a59fa3f2a444d74f40d132ea5c@changeid>
Date:   Fri, 25 Sep 2020 18:25:48 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <4819769E-04AD-42A7-BC2C-9C628EEDE3F3@holtmann.org>
References: <20200921163021.v1.1.Id3160295d33d44a59fa3f2a444d74f40d132ea5c@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> According to the spec Ver 5.2, Vol 3, Part C, Sec 5.2.2.8:
> Device in security mode 4 level 4 shall enforce:
> 128-bit equivalent strength for link and encryption keys required
> using FIPS approved algorithms (E0 not allowed, SAFER+ not allowed,
> and P-192 not allowed; encryption key not shortened)
> 
> This patch rejects connection with key size below 16 for FIPS level
> services.
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> 
> ---
> 
> net/bluetooth/l2cap_core.c | 7 ++++++-
> 1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index ade83e224567..306616ec26e6 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -1515,8 +1515,13 @@ static bool l2cap_check_enc_key_size(struct hci_conn *hcon)
> 	 * that have no key size requirements. Ensure that the link is
> 	 * actually encrypted before enforcing a key size.
> 	 */
> +	int min_key_size = hcon->hdev->min_enc_key_size;
> +
> +	if (hcon->sec_level == BT_SECURITY_FIPS)
> +		min_key_size = 16;
> +
> 	return (!test_bit(HCI_CONN_ENCRYPT, &hcon->flags) ||
> -		hcon->enc_key_size >= hcon->hdev->min_enc_key_size);
> +		hcon->enc_key_size >= min_key_size);
> }

I think this is fine at this position. It is a L2CAP socket requirement to be in FIPS mode since you will set it via socket option. However I would extend the comment above to describe what is going on. And generally the variable declaration might be better placed before the comment.

Regards

Marcel

