Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E1D3D71C1
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 11:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236073AbhG0JN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 05:13:59 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.167]:23541 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235942AbhG0JN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 05:13:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1627377235;
    s=strato-dkim-0002; d=fpond.eu;
    h=Subject:References:In-Reply-To:Message-ID:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=XqBcMoIkFDWH7t7weL/F33n8KKtmIXCBVhETpaRVRYU=;
    b=hR3wmLtFn5vSE8vRpYx0Tb/uRawFMqt4Z2cVf+mr0MSvQOQfnljNwgIZQAON4FulI6
    eAGYm3wk1qTLkMJ7B/VLskcuWM8/Z9gQAuCEGmsR8pbWBjzjPmq8s2l+tppn2LSjJipT
    A6YILLUuVoxfc9WaZHV1U1FneXi9EO7AvzXCMB0P+8g5y1qMsh/lCcB7imYI1jc/mopA
    eGWXKLs8TJGtXLO5zVlPPsTw226pjFxj+BNP2Kge0+jJTCLUqw27+wOxcGz5Pr5GODKO
    qSCxMVxS1DKxNlVOC8O/Dtrm2EK0hUn6GZ8B0zmVyV706tr6Dc+ym3u6v5G+tXJz9cST
    2S2Q==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73amq+g13rqGzvv3qxio1R8fCt/7N+Odk="
X-RZG-CLASS-ID: mo00
Received: from oxapp04-03.back.ox.d0m.de
    by smtp-ox.front (RZmta 47.28.1 AUTH)
    with ESMTPSA id n07311x6R9Dtn97
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Tue, 27 Jul 2021 11:13:55 +0200 (CEST)
Date:   Tue, 27 Jul 2021 11:13:55 +0200 (CEST)
From:   Ulrich Hecht <uli@fpond.eu>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        sergei.shtylyov@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Message-ID: <1863500318.822017.1627377235170@webmail.strato.com>
In-Reply-To: <1879319092.816143.1627376136422@webmail.strato.com>
References: <20210727082147.270734-1-yoshihiro.shimoda.uh@renesas.com>
 <20210727082147.270734-2-yoshihiro.shimoda.uh@renesas.com>
 <1879319092.816143.1627376136422@webmail.strato.com>
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


> On 07/27/2021 10:55 AM Ulrich Hecht <uli@fpond.eu> wrote:
> 
>  
> > On 07/27/2021 10:21 AM Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com> wrote:
> > 
> >  
> > The descriptor counters ({cur,dirty}_[rt]x) acts as free counters
> > so that conditions are possible to be incorrect when a left value
> > was overflowed.
> > 
> > So, for example, ravb_tx_free() could not free any descriptors
> > because the following condition was checked as a signed value,
> > and then "NETDEV WATCHDOG" happened:
> > 
> >     for (; priv->cur_tx[q] - priv->dirty_tx[q] > 0; priv->dirty_tx[q]++) {
> > 
> > To fix the issue, add get_num_desc() to calculate numbers of
> > remaining descriptors.
> > 
> > Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
> > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > ---
> >  drivers/net/ethernet/renesas/ravb_main.c | 22 +++++++++++++++-------
> >  1 file changed, 15 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> > index 805397088850..70fbac572036 100644
> > --- a/drivers/net/ethernet/renesas/ravb_main.c
> > +++ b/drivers/net/ethernet/renesas/ravb_main.c
> > @@ -172,6 +172,14 @@ static const struct mdiobb_ops bb_ops = {
> >  	.get_mdio_data = ravb_get_mdio_data,
> >  };
> >  
> > +static u32 get_num_desc(u32 from, u32 subtract)
> > +{
> > +	if (from >= subtract)
> > +		return from - subtract;
> > +
> > +	return U32_MAX - subtract + 1 + from;
> > +}
>
> This is a very roundabout way to implement an unsigned subtraction. :)
> I think it would make more sense to simply return 0 if "subtract" is larger than "from".
> (Likewise for sh_eth).

...and the tests for "> 0" should be rewritten as "!= 0". Sorry, not fully awake yet.

CU
Uli
