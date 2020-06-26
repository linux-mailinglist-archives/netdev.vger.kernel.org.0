Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC1620B984
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 21:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725816AbgFZT6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 15:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725275AbgFZT6J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 15:58:09 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97541206BE;
        Fri, 26 Jun 2020 19:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593201489;
        bh=GC2lLesfdJnBgKU0FxJqMOrdz4kBj/wjLgwMjrW1dEc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HlXcGdaRrnm8G2XVsAWRx678lmEYLuuevvv3fDI2PtGeLSWiBicK/MkuA4xjRUzhq
         on3Ssq00/pZXQK8Zd2l1H+O1QUxTStM+yEAOgzVzaRsK73sw9KAmmr+q8Hvp3nxgb8
         C3jxu1zms7OwKRHH7bZv8d2d4l/B72gGI494OBXk=
Date:   Fri, 26 Jun 2020 12:58:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Alice Michael <alice.michael@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: Re: [net-next v3 11/15] iecm: Add splitq TX/RX
Message-ID: <20200626125806.0b1831a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200626020737.775377-12-jeffrey.t.kirsher@intel.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
        <20200626020737.775377-12-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jun 2020 19:07:33 -0700 Jeff Kirsher wrote:
> @@ -1315,7 +1489,18 @@ iecm_tx_splitq_clean(struct iecm_queue *tx_q, u16 end, int napi_budget,
>   */
>  static inline void iecm_tx_hw_tstamp(struct sk_buff *skb, u8 *desc_ts)

Pretty sure you don't need the inline here. It's static function with
one caller.

>  {
> -	/* stub */
> +	struct skb_shared_hwtstamps hwtstamps;
> +	u64 tstamp;
> +
> +	/* Only report timestamp to stack if requested */
> +	if (!likely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
> +		return;
> +
> +	tstamp = (desc_ts[0] | (desc_ts[1] << 8) | (desc_ts[2] & 0x3F) << 16);
> +	hwtstamps.hwtstamp =
> +		ns_to_ktime(tstamp << IECM_TW_TIME_STAMP_GRAN_512_DIV_S);
> +
> +	skb_tstamp_tx(skb, &hwtstamps);
>  }

Why is there time stamp reading support if you have no ts_info
configuration on ethtool side at all and no PHC support?
