Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCAD7A47C
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 11:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731583AbfG3JgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 05:36:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43680 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731501AbfG3JgF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 05:36:05 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 469ECC028353;
        Tue, 30 Jul 2019 09:36:05 +0000 (UTC)
Received: from localhost (unknown [10.43.2.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D12DC60856;
        Tue, 30 Jul 2019 09:36:04 +0000 (UTC)
Date:   Tue, 30 Jul 2019 11:35:33 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Jian-Hong Pan <jian-hong@endlessm.com>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Laight <David.Laight@aculab.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] rtw88: pci: Use general byte arrays as the elements of
 RX ring
Message-ID: <20190730093533.GC3174@redhat.com>
References: <20190725080925.6575-1-jian-hong@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725080925.6575-1-jian-hong@endlessm.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Tue, 30 Jul 2019 09:36:05 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 04:09:26PM +0800, Jian-Hong Pan wrote:
> Each skb as the element in RX ring was expected with sized buffer 8216
> (RTK_PCI_RX_BUF_SIZE) bytes. However, the skb buffer's true size is
> 16640 bytes for alignment after allocated, x86_64 for example. And, the

rtw88 advertise IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454, so maximum AMSDU
packet can be approximately 12kB. This might be accidental, but having
16kB skb's allow to handle such big AMSDUs. If you shrink buf size,
you can probably override memory after buffer end.

> difference will be enlarged 512 times (RTK_MAX_RX_DESC_NUM).
> To prevent that much wasted memory, this patch follows David's
> suggestion [1] and uses general buffer arrays, instead of skbs as the
> elements in RX ring.
> 
> [1] https://www.spinics.net/lists/linux-wireless/msg187870.html
> 
> Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> Cc: <stable@vger.kernel.org>

This does not fix any serious problem, it actually most likely 
introduce memory corruption problem described above. Should not
be targeted to stable anyway.

> -			dev_kfree_skb_any(skb);
> +			devm_kfree(rtwdev->dev, buf);

For what this is needed? devm_ allocations are used exactly to avoid
manual freeing.

> +		len = pkt_stat.pkt_len + pkt_offset;
> +		skb = dev_alloc_skb(len);
> +		if (WARN_ONCE(!skb, "rx routine starvation\n"))
>  			goto next_rp;
>  
>  		/* put the DMA data including rx_desc from phy to new skb */
> -		skb_put_data(new, skb->data, new_len);
> +		skb_put_data(skb, rx_desc, len);

Coping big packets it quite inefficient. What drivers usually do is 
copy only for small packets and for big ones allocate new rx buf
(drop packet alloc if fail) and pas old buf to network stack via
skb_add_rx_frag(). See iwlmvm as example.

Stanislaw
