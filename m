Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5376A7A3A
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 05:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjCBEBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 23:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCBEBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 23:01:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E2D61A9
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 20:00:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01E7E614EE
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 04:00:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2D8C433EF;
        Thu,  2 Mar 2023 04:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677729657;
        bh=5ZR5R461dbheEtOod7k3G6pML8D5tqcmb2vtRg8QCC4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B64GTatHY6nXIU0nCdRH2l0i+xRSMLzlGZXJBwgzYF2MLn4xLibZSKUtR/qLJWuV8
         Y0S1beQc75UeoifLTwsoBkPQnGcu0rwOccOOKk3YhuLGSZjgr/kaat5ibsB0IR01NU
         ntUGjabsWBNoMxsgmfiFYIvAcPy5yQ6eH0n3tHfXOQ+wzhpK9LYsV/1EExJhJwjc7T
         rqNpHw1BkZRjlB9tBjhsorLXdRKlXI62RbtiiY9K9Mmj+mFF8dhf8JlX/fjvOrYo+R
         Gzn1tY8bx0CaYOOIEK2bbwHTmSGeWcElN4hU4nbZHRqsH74McZpaQqR4yMG9tT9UWC
         c/lvAjpUHSSFg==
Date:   Wed, 1 Mar 2023 20:00:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH RFC v1 net-next 1/5] ethtool: Add support for
 configuring tx_push_buf_len
Message-ID: <20230301200055.69e86e53@kernel.org>
In-Reply-To: <20230301175916.1819491-2-shayagr@amazon.com>
References: <20230301175916.1819491-1-shayagr@amazon.com>
        <20230301175916.1819491-2-shayagr@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Mar 2023 19:59:12 +0200 Shay Agroskin wrote:
> @@ -98,7 +100,12 @@ static int rings_fill_reply(struct sk_buff *skb,
>  	    (kr->cqe_size &&
>  	     (nla_put_u32(skb, ETHTOOL_A_RINGS_CQE_SIZE, kr->cqe_size))) ||
>  	    nla_put_u8(skb, ETHTOOL_A_RINGS_TX_PUSH, !!kr->tx_push) ||
> -	    nla_put_u8(skb, ETHTOOL_A_RINGS_RX_PUSH, !!kr->rx_push))
> +	    nla_put_u8(skb, ETHTOOL_A_RINGS_RX_PUSH, !!kr->rx_push) ||
> +	    (kr->tx_push_buf_len &&
> +	     (nla_put_u32(skb, ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN_MAX,
> +			  kr->tx_push_buf_max_len) ||
> +	      nla_put_u32(skb, ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN,
> +			  kr->tx_push_buf_len))))

Why gate both on kr->tx_push_buf_len and not current and max separately?
Is kr->tx_push_buf_len == 0 never a valid setting?

Otherwise LGTM!

Could you add this chunk to expose the value in the YAML spec?

diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
index 35c462bce56f..2dd6aef582e4 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -163,6 +163,12 @@ doc: Partial family for Ethtool Netlink.
       -
         name: rx-push
         type: u8
+      -
+        name: tx-push-buf-len
+        type: u32
+      -
+        name: tx-push-buf-len-max
+        type: u32
 
   -
     name: mm-stat
@@ -309,6 +315,8 @@ doc: Partial family for Ethtool Netlink.
             - cqe-size
             - tx-push
             - rx-push
+            - tx-push-buf-len
+            - tx-push-buf-len-max
       dump: *ring-get-op
     -
       name: rings-set
