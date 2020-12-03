Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BED62CDDC1
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731686AbgLCSdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:33:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:56586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728065AbgLCSdi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 13:33:38 -0500
Date:   Thu, 3 Dec 2020 10:32:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607020378;
        bh=+PelqTg7DtmYZKbWnP749lFmcSvoDCRASpH02wnQYYo=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=k3yuY35KeIpMn+H5tyuBASudVFK7BZFOpkZTlsAcjcrc+t+p8J9ELBheszRjabIw0
         EXG/hu/0bve8RGGf6jSTXQWoeJLSMO+iV4AiWb91w96YsOog+Gcod2hl+DEW3kBYys
         DaKyENbxiROsQP/sHftjgK8esglpXo5GnCfklE2+cP3x9SXkLCjn3IPFg+azFq4Vfg
         4kGioSI8eTt6k4Su3hSgzpsYD31Oz1c/h//bM4yWwz5hSXZ0wwgImmDljB5aIIMT7b
         RfNcHyUmDbW/wJSnl8X5Vg6UxQhBttD3b3Sp/yof6EPI6tTTq0kUKxcfzwidLVnPpR
         oQaE66jZDSTqA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-imx@nxp.com
Subject: Re: [PATCH 3/4] net: ethernet: stmmac: free tx skb buffer in
 stmmac_resume()
Message-ID: <20201203103256.059d59e9@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202085949.3279-5-qiangqing.zhang@nxp.com>
References: <20201202085949.3279-1-qiangqing.zhang@nxp.com>
        <20201202085949.3279-5-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Dec 2020 16:59:48 +0800 Joakim Zhang wrote:
> From: Fugang Duan <fugang.duan@nxp.com>
> 
> When do suspend/resume test, there have WARN_ON() log dump from
> stmmac_xmit() funciton, the code logic:
> 	entry = tx_q->cur_tx;
> 	first_entry = entry;
> 	WARN_ON(tx_q->tx_skbuff[first_entry]);
> 
> In normal case, tx_q->tx_skbuff[txq->cur_tx] should be NULL because
> the skb should be handled and freed in stmmac_tx_clean().
> 
> But stmmac_resume() reset queue parameters like below, skb buffers
> may not be freed.
> 	tx_q->cur_tx = 0;
> 	tx_q->dirty_tx = 0;
> 
> So free tx skb buffer in stmmac_resume() to avoid warning and
> memory leak.

Also needs Fixes
