Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95323D6773
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 18:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388126AbfJNQgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 12:36:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45028 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731506AbfJNQgU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 12:36:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4C4AHoecHaRVs6owdq4L/8qk8V8sJuk7zI1TUgCxcq4=; b=ig97LvZXfW21DgDM43kUkVOIrz
        4ZH+JgQkPgpKXgRnRGI9Sv7HEOA3XQ93BnCcCuDoDojsXmKcn0YefmcluxRPRgaopfE+GANShEsMr
        z3obX+c0pn5hzj+9ze92NY1NvmeO65ZcuczeKUqurVKVOs9+LjUKx3NIyWir+iwr615U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iK3KO-0006KZ-G4; Mon, 14 Oct 2019 18:36:12 +0200
Date:   Mon, 14 Oct 2019 18:36:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>
Subject: Re: [PATCH v2 net-next 06/12] net: aquantia: implement data PTP
 datapath
Message-ID: <20191014163612.GP21165@lunn.ch>
References: <cover.1570531332.git.igor.russkikh@aquantia.com>
 <093d91dcc66abeb4d3ef83eef829badd7389d792.1570531332.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <093d91dcc66abeb4d3ef83eef829badd7389d792.1570531332.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> --- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
> @@ -8,12 +8,24 @@
>   */
>  
> +static inline int aq_ptp_tm_offset_egress_get(struct aq_ptp_s *aq_ptp)
> +{
> +	return atomic_read(&aq_ptp->offset_egress);
> +}
> +
> +static inline int aq_ptp_tm_offset_ingress_get(struct aq_ptp_s *aq_ptp)
> +{
> +	return atomic_read(&aq_ptp->offset_ingress);
> +}

inline should not be used in C files. Let the compiler decide.

> +
> +void aq_ptp_tm_offset_set(struct aq_nic_s *aq_nic, unsigned int mbps)
> +{
> +	struct aq_ptp_s *aq_ptp = aq_nic->aq_ptp;
> +	int i, egress, ingress;
> +
> +	if (!aq_ptp)
> +		return;
> +
> +	egress = 0;
> +	ingress = 0;
> +
> +	for (i = 0; i < ARRAY_SIZE(ptp_offset); i++) {
> +		if (mbps == ptp_offset[i].mbps) {
> +			egress = ptp_offset[i].egress;
> +			ingress = ptp_offset[i].ingress;
> +			break;
> +		}
> +	}
> +
> +	atomic_set(&aq_ptp->offset_egress, egress);
> +	atomic_set(&aq_ptp->offset_ingress, ingress);

It seems odd you have wrappers for atomic_read, but not atomic_set. Do
the wrappers actually add anything?

> +}
> +
> +static int __aq_ptp_skb_put(struct ptp_skb_ring *ring, struct sk_buff *skb)
> +{
> +	unsigned int next_head = (ring->head + 1) % ring->size;
> +
> +	if (next_head == ring->tail)
> +		return -1;

ENOMEM?

> +
> +	ring->buff[ring->head] = skb_get(skb);
> +	ring->head = next_head;
> +
> +	return 0;
> +}
> +

  Andrew
