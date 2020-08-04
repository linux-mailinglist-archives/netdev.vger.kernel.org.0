Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C77423BA80
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 14:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgHDMjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 08:39:39 -0400
Received: from mx.wizbit.be ([87.237.14.2]:57420 "EHLO mx.wizbit.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbgHDMjc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 08:39:32 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Aug 2020 08:39:31 EDT
Received: from [87.237.14.4] (87-237-14-7.powered-by.benesol.be [87.237.14.7])
        by wizbit.localdomain (Postfix) with ESMTP id 56CFA6003;
        Tue,  4 Aug 2020 14:32:20 +0200 (CEST)
Message-ID: <5F295578.4040004@mail.wizbit.be>
Date:   Tue, 04 Aug 2020 14:32:56 +0200
From:   Bram Yvakh <bram-yvahk@mail.wizbit.be>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To:     sd@queasysnail.net
CC:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>, xmu@redhat.com
Subject: Re: [PATCH ipsec] xfrmi: drop ignore_df check before updating pmtu
References: <70e7c2a65afed5de117dbc16082def459bd39d93.1596531053.git.sd@queasysnail.net>
In-Reply-To: <70e7c2a65afed5de117dbc16082def459bd39d93.1596531053.git.sd@queasysnail.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/08/2020 11:37, Sabrina Dubroca wrote:
> xfrm interfaces currently test for !skb->ignore_df when deciding
> whether to update the pmtu on the skb's dst. Because of this, no pmtu
> exception is created when we do something like:
>
>     ping -s 1438 <dest>
>
> By dropping this check, the pmtu exception will be created and the
> next ping attempt will work.
>
>
> Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> ---
>  net/xfrm/xfrm_interface.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
> index b615729812e5..ade2eba863b3 100644
> --- a/net/xfrm/xfrm_interface.c
> +++ b/net/xfrm/xfrm_interface.c
> @@ -292,7 +292,7 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
>  	}
>  
>  	mtu = dst_mtu(dst);
> -	if (!skb->ignore_df && skb->len > mtu) {
> +	if (skb->len > mtu) {
>   

To me dropping the 'ignore_df' check looks incorrect;
When I submitted patches last year for VTI which related to
ptmu/df-bit[1]  I did some testing and also some comparison (also with GRE)
(I also briefly tested with xfrmi but given that the VTI patches were
mostly ignored I did not pursue that further[2])

The conclusion for my testing with GRE: (only the last item is relevant
but rest included for context)
* with 'pmtudisc' set for the GRE device: outgoing GRE packet has the
DF-bit set (this did suffer from some issues when the
to-be-forwarded-packet did not have the DF bit set)
* with 'nopmtudisc' set for the GRE device: outgoing GRE packet copies
DF-bit from the to-be-forwarded packet (this did suffer from some issues
when client did set DF bit..)
* with 'nopmtudisc' and 'ignore-df' bit set: outgoing GRE packet never
has the DF bit set: packet can be fragmented at will

How I understand things (based on my testing last year): when
'ignore-df' is set then the DF-bit should *not* be set. This in turns
means that path-mtu discovery is not possible (which is why it has to be
used in combination with 'nopmtudisc').
In the patch above the 'ignore_df' is removed which looks wrong: if
'ignore_df' is set then the size of the packet should not be checked
since the packet may be fragmented at will.
(I also suppose that means that setting 'ignore_df' is not an option (or
no longer) an option for xfrmi?)

I'm also not sure what the exact case is/was that lead to this patch;
can you shed some light on it?
(What I would expect: if 'ignore_df' is set then pmtu discovery does not
happen.)

[1]:
https://lore.kernel.org/netdev/1552865877-13401-1-git-send-email-bram-yvahk@mail.wizbit.be/
and
https://lore.kernel.org/netdev/1552865877-13401-2-git-send-email-bram-yvahk@mail.wizbit.be/
[2]: https://lore.kernel.org/netdev/5C8EDF7F.2010100@mail.wizbit.be/

>   
>  		skb_dst_update_pmtu_no_confirm(skb, mtu);
>  
>  		if (skb->protocol == htons(ETH_P_IPV6)) {
>   

