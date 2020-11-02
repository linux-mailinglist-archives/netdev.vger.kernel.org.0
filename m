Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24BAC2A326D
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 19:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgKBSAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 13:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgKBSAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 13:00:22 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C388C0617A6;
        Mon,  2 Nov 2020 10:00:20 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kZe7i-00HNsA-H4; Mon, 02 Nov 2020 19:00:06 +0100
Message-ID: <47b04bd1da38a2356546284eb3576156899965de.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 08/11] ath9k: work around false-positive gcc
 warning
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kalle Valo <kvalo@codeaurora.org>, Arnd Bergmann <arnd@kernel.org>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 02 Nov 2020 18:59:49 +0100
In-Reply-To: <87tuu7ohbo.fsf@codeaurora.org> (sfid-20201102_172730_808878_841241B0)
References: <20201026213040.3889546-1-arnd@kernel.org>
         <20201026213040.3889546-8-arnd@kernel.org> <87tuu7ohbo.fsf@codeaurora.org>
         (sfid-20201102_172730_808878_841241B0)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-11-02 at 18:26 +0200, Kalle Valo wrote:
> Arnd Bergmann <arnd@kernel.org> writes:
> 
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > gcc-10 shows a false-positive warning with CONFIG_KASAN:
> > 
> > drivers/net/wireless/ath/ath9k/dynack.c: In function 'ath_dynack_sample_tx_ts':
> > include/linux/etherdevice.h:290:14: warning: writing 4 bytes into a region of size 0 [-Wstringop-overflow=]
> >   290 |  *(u32 *)dst = *(const u32 *)src;
> >       |  ~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~
> > 
> > Until gcc is fixed, work around this by using memcpy() in place
> > of ether_addr_copy(). Hopefully gcc-11 will not have this problem.
> > 
> > Link: https://godbolt.org/z/sab1MK
> > Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=97490
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/net/wireless/ath/ath9k/dynack.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/drivers/net/wireless/ath/ath9k/dynack.c b/drivers/net/wireless/ath/ath9k/dynack.c
> > index fbeb4a739d32..e4eb96b26ca4 100644
> > --- a/drivers/net/wireless/ath/ath9k/dynack.c
> > +++ b/drivers/net/wireless/ath/ath9k/dynack.c
> > @@ -247,8 +247,14 @@ void ath_dynack_sample_tx_ts(struct ath_hw *ah, struct sk_buff *skb,
> >  	ridx = ts->ts_rateindex;
> >  
> >  	da->st_rbf.ts[da->st_rbf.t_rb].tstamp = ts->ts_tstamp;
> > +#if defined(CONFIG_KASAN) && (CONFIG_GCC_VERSION >= 100000) && (CONFIG_GCC_VERSION < 110000)
> > +	/* https://gcc.gnu.org/bugzilla/show_bug.cgi?id=97490 */
> > +	memcpy(da->st_rbf.addr[da->st_rbf.t_rb].h_dest, hdr->addr1, ETH_ALEN);
> > +	memcpy(da->st_rbf.addr[da->st_rbf.t_rb].h_src, hdr->addr2, ETH_ALEN);
> > +#else
> >  	ether_addr_copy(da->st_rbf.addr[da->st_rbf.t_rb].h_dest, hdr->addr1);
> >  	ether_addr_copy(da->st_rbf.addr[da->st_rbf.t_rb].h_src, hdr->addr2);
> > +#endif
> 
> Isn't there a better way to handle this? I really would not want
> checking for GCC versions become a common approach in drivers.
> 
> I even think that using memcpy() always is better than the ugly ifdef.

If you put memcpy() always somebody will surely go and clean it up to
use ether_addr_copy() soon ...

That said, if there's a gcc issue with ether_addr_copy() then how come
it's specific to this place?

johannes

