Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0401473069
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 15:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbfGXN7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 09:59:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41014 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbfGXN7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 09:59:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RAl0a6XDBiz9KDbwHW5cZpAX7aqNsCFK4D5fjNEt504=; b=G3KNP7bVg9plKS5fOyhdPIFM9
        FCUqbYqDja3G744oXtV3DyJdNz9NpPJ/LkXGIVx0fG4F8s4cPNePyGW5UPiGQr096HX+TNnt4N6v+
        oceg3Cj5KycotFytiEFIpsdxTLiz4WsZRygEt7keJcijolBO0BdW7FzYS/ZVDlaFPwMU8ZuZqJF5R
        UmUbnSVYgGWDqhfFUS+vBoOTYmeG3aM/fLjdxWdn73OcJxKyJPDQN3jIH5z1uxUMfXsHep6eiSYLF
        yOCteZLHTcXEOx8p9Sa3r3plfNMIzHxXe+cGiIAVMkItva8kHok7oClOufqb4OeZRC03MLXMuFMTD
        hPsQ7dARw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hqHnL-00052P-7I; Wed, 24 Jul 2019 13:59:03 +0000
Date:   Wed, 24 Jul 2019 06:59:03 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Qian Cai <cai@lca.pw>
Cc:     davem@davemloft.net, jeffrey.t.kirsher@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] net/ixgbevf: fix a compilation error of skb_frag_t
Message-ID: <20190724135903.GU363@bombadil.infradead.org>
References: <1563975157-30691-1-git-send-email-cai@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563975157-30691-1-git-send-email-cai@lca.pw>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 09:32:37AM -0400, Qian Cai wrote:
>  	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++)
> -		count += TXD_USE_COUNT(skb_shinfo(skb)->frags[f].size);
> +		count += TXD_USE_COUNT(skb_shinfo(skb)->frags[f].bv_len);
>  #else

No, this is the wrong fix.  Use the fine accessor instead:

+		count += TXD_USE_COUNT(skb_frag_size(&skb_shinfo(skb)->frags[f]));

although now there's a line length problem.  Most drivers do:

		skb_frag_t frag = &skb_shinfo(skb)->frags[f];
		count += TXD_USE_COUNT(skb_frag_size(frag));
