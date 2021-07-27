Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868063D71B3
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 11:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236038AbhG0JHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 05:07:45 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:23978 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235923AbhG0JHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 05:07:44 -0400
X-Greylist: delayed 543 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jul 2021 05:07:44 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1627376136;
    s=strato-dkim-0002; d=fpond.eu;
    h=Subject:References:In-Reply-To:Message-ID:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=q5Rktl2PlNUu2QVqtqx6PFhsTCy5lEM2oJyqAN8SUV4=;
    b=WJy32QIa2WNsz92EGLgzGLpr7SR1c0QgRSlo/zQm6D4XVUkd0q4MVW9DaTEujkm8V6
    LHEVCB9sHyLWvbDLxKZcf3YjsA+NfKcKyLHCQdRXNc5ayhnVnrxAmZG66FEG+U15Gux/
    /W5Ql1e+tQq2iE3ysppWqMG/CmMM4KbD2ZvL2LIU2NIlFgHUWs6iU2KZ/Lr9JrtBBNHa
    IGJA2SLwd3wBzWufmOiyEbG5UyXpJX7Vi4aXtOsObyoEuPmRZb9m7BiQPSaQeUNTIYWr
    JAQIlUaxMvEtkAuxjVBOHLAjDbm7ZbZfWGI4AxamRfEZ/iISOsouoKrcEoalHP6KzBgr
    j0kA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73amq+g13rqGzvv3qxio1R8fCt/7N+Odk="
X-RZG-CLASS-ID: mo00
Received: from oxapp04-03.back.ox.d0m.de
    by smtp-ox.front (RZmta 47.28.1 AUTH)
    with ESMTPSA id n07311x6R8tan0s
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Tue, 27 Jul 2021 10:55:36 +0200 (CEST)
Date:   Tue, 27 Jul 2021 10:55:36 +0200 (CEST)
From:   Ulrich Hecht <uli@fpond.eu>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        sergei.shtylyov@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Message-ID: <1879319092.816143.1627376136422@webmail.strato.com>
In-Reply-To: <20210727082147.270734-2-yoshihiro.shimoda.uh@renesas.com>
References: <20210727082147.270734-1-yoshihiro.shimoda.uh@renesas.com>
 <20210727082147.270734-2-yoshihiro.shimoda.uh@renesas.com>
Subject: Re: [PATCH 1/2] ravb: Fix descriptor counters' conditions
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.5-Rev16
X-Originating-Client: open-xchange-appsuite
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 07/27/2021 10:21 AM Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com> wrote:
> 
>  
> The descriptor counters ({cur,dirty}_[rt]x) acts as free counters
> so that conditions are possible to be incorrect when a left value
> was overflowed.
> 
> So, for example, ravb_tx_free() could not free any descriptors
> because the following condition was checked as a signed value,
> and then "NETDEV WATCHDOG" happened:
> 
>     for (; priv->cur_tx[q] - priv->dirty_tx[q] > 0; priv->dirty_tx[q]++) {
> 
> To fix the issue, add get_num_desc() to calculate numbers of
> remaining descriptors.
> 
> Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb_main.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 805397088850..70fbac572036 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -172,6 +172,14 @@ static const struct mdiobb_ops bb_ops = {
>  	.get_mdio_data = ravb_get_mdio_data,
>  };
>  
> +static u32 get_num_desc(u32 from, u32 subtract)
> +{
> +	if (from >= subtract)
> +		return from - subtract;
> +
> +	return U32_MAX - subtract + 1 + from;
> +}

This is a very roundabout way to implement an unsigned subtraction. :)
I think it would make more sense to simply return 0 if "subtract" is larger than "from".
(Likewise for sh_eth).

CU
Uli
