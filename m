Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 838906D2E30
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 06:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbjDAEqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 00:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233525AbjDAEqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 00:46:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25701EFC5
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 21:46:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09E1C6243D
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 04:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E517C433D2;
        Sat,  1 Apr 2023 04:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680324377;
        bh=jEwNSviOa//AP0m4qEv/jGVBGyJhLygpb2cjMjJjcYc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Dw9Y4nezv+h9LSMKFWmw6ypHc053s3Db37FIIoqyEAXuf8FvGTS3VUy70Bv9Kj7OI
         YFDmtYJU12PVLNJWi7qM1fkSNmquo2CKtsEo/DssaCND1ck1EmhVYddi+6YDMOycTL
         7VjT4WnYu7OpsSHGzz/9R8O8FL3kU6Ja+Wge/b1X47ig3Mim3ZYQ/pXwXWZI7EyaoU
         ecsg6QdFVrxILg1E4mOZMFsHEFoUDCvMHPl1/uX7ltOv0Vq3dcp5M/bj7uEtlbFQcw
         2xKyornlHzzv7Gkgk4u8/pvJF/WPU3dpXh/oDl4fywJ6y3zNfHwEpsaEIR7hUxcJzM
         QqJolgybYQGWQ==
Date:   Fri, 31 Mar 2023 21:46:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Corinna Vinschen <vinschen@redhat.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: stmmac: fix up RX flow hash indirection table
 when setting channels
Message-ID: <20230331214616.228c458d@kernel.org>
In-Reply-To: <20230331092347.268996-1-vinschen@redhat.com>
References: <20230331092347.268996-1-vinschen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Mar 2023 11:23:47 +0200 Corinna Vinschen wrote:
>  	priv->plat->rx_queues_to_use = rx_cnt;
>  	priv->plat->tx_queues_to_use = tx_cnt;
> +	for (i = 0; i < ARRAY_SIZE(priv->rss.table); i++)
> +		priv->rss.table[i] = ethtool_rxfh_indir_default(i, rx_cnt);

You need to check if (!netif_is_rxfh_configured())
if user set the config to not RSS to all queues we shouldn't reset.
