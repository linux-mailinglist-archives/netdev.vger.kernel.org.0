Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 435ED34F6F7
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 04:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbhCaCtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 22:49:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230160AbhCaCsl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 22:48:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDA0C619D3;
        Wed, 31 Mar 2021 02:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617158921;
        bh=a5Zjyrdx2349NQa+T6hwW+EkY6zzo08x0wON8Albck0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JyYkbrwxvlLCuuAPfmHI6bRXSEeJdXHgcFsylOTFBa2xy0MUCh5nWZ4Ow9nlrd3/V
         H9w4cS5Xfu9ROLY+OiwxN4iMV/fdt5bWHSCVkoZyD/CovlkHgQ6CCnR1ewMhCLRlhU
         5qUzg5xAcFIne/G5vjEMNNd3SgFOlhGqboSpZN2/JFUnx9A2KIKIv7j+l0TL5foCId
         Q3Coyiv4AtYNDcj6tLcm2xsIhcL1fkjyD2B9+mPQz+6WrUKajpEpfNbn2M12aRpDPG
         XnKJSYbPMqRXCWeOQYUhRRGmWPeFyrk1s5K7Zjnx2J/62L8mjWeQDizTP2ncVIE6z6
         wjblHUoZ+kFgQ==
Date:   Tue, 30 Mar 2021 19:48:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH net-next v2 5/6] net: stmmac: Add support for XDP_TX
 action
Message-ID: <20210330194839.0b8596f2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210330024949.14010-6-boon.leong.ong@intel.com>
References: <20210330024949.14010-1-boon.leong.ong@intel.com>
        <20210330024949.14010-6-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Mar 2021 10:49:48 +0800 Ong Boon Leong wrote:
> +	__netif_tx_lock(nq, cpu);
> +	res = stmmac_xdp_xmit_xdpf(priv, queue, xdpf);
> +	if (res == STMMAC_XDP_TX) {
> +		stmmac_flush_tx_descriptors(priv, queue);
> +		stmmac_tx_timer_arm(priv, queue);
> +	}
> +	__netif_tx_unlock(nq);

You may want to update nq->trans_start, see commit ec107e775d843
