Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864A24067C5
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 09:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhIJHhj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 10 Sep 2021 03:37:39 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:44475 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbhIJHhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 03:37:38 -0400
Received: from smtpclient.apple (p5b3d2185.dip0.t-ipconnect.de [91.61.33.133])
        by mail.holtmann.org (Postfix) with ESMTPSA id 989BDCED3D;
        Fri, 10 Sep 2021 09:36:25 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH 1/2] Bluetooth: call sock_hold earlier in sco_conn_del
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210903031306.78292-2-desmondcheongzx@gmail.com>
Date:   Fri, 10 Sep 2021 09:36:25 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        eric.dumazet@gmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <7AEB2618-111A-45F4-8C00-CF40FCBE92EC@holtmann.org>
References: <20210903031306.78292-1-desmondcheongzx@gmail.com>
 <20210903031306.78292-2-desmondcheongzx@gmail.com>
To:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Desmond,

> In sco_conn_del, conn->sk is read while holding on to the
> sco_conn.lock to avoid races with a socket that could be released
> concurrently.
> 
> However, in between unlocking sco_conn.lock and calling sock_hold,
> it's possible for the socket to be freed, which would cause a
> use-after-free write when sock_hold is finally called.
> 
> To fix this, the reference count of the socket should be increased
> while the sco_conn.lock is still held.
> 
> Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
> ---
> net/bluetooth/sco.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
> index b62c91c627e2..4a057f99b60a 100644
> --- a/net/bluetooth/sco.c
> +++ b/net/bluetooth/sco.c
> @@ -187,10 +187,11 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
> 	/* Kill socket */
> 	sco_conn_lock(conn);
> 	sk = conn->sk;

please add a comment here on why we are doing it.

> +	if (sk)
> +		sock_hold(sk);
> 	sco_conn_unlock(conn);
> 
> 	if (sk) {
> -		sock_hold(sk);
> 		lock_sock(sk);
> 		sco_sock_clear_timer(sk);
> 		sco_chan_del(sk, err);

Regards

Marcel

