Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B65D06B867D
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjCNAAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjCNAAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:00:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C903515C86;
        Mon, 13 Mar 2023 17:00:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 212ABCE12A9;
        Tue, 14 Mar 2023 00:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD17C433EF;
        Tue, 14 Mar 2023 00:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678752047;
        bh=r/YJr3Z/GGarg/wo29j7/aQal24kbrU+shrDMuBHZbA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OX+olGZHoWhyOWTXP4D3fooulNEteWLpzhlHJ0GAEudUwfLKXc0jGXFYWkqiiHWE/
         qgNthO8+ErvPnn5oyfXG0TP9trhtpBc06qa3t55qSXrdIbKb6uJbHs16ugkrl58BJp
         rAuTNRN/qp3jNFPw4245F0eSP1AFu7W7sDl911RsaYqRc9FOl6epTw+FbQso9JhyZv
         iod8k60a1tMiPWvapZgeDRZpK22c0n0cqWiTbVn3EdWgoEmdIPKcyaJKW63MviT4Cl
         KpKu5hj+qXlIgjL21idh2SMoD2pjD84dtEP0lnqeTOUGM+Bqi0c1Cer0vcOHgHlIaX
         poGaUbk8k5DZQ==
Date:   Mon, 13 Mar 2023 17:00:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zheng Wang <zyytlz.wz@163.com>
Cc:     timur@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        1395428693sheep@gmail.com, alex000young@gmail.com
Subject: Re: [PATCH net] net: qcom/emac: Fix use after free bug in
 emac_remove due to race condition
Message-ID: <20230313170046.287bae8d@kernel.org>
In-Reply-To: <20230310105734.1574078-1-zyytlz.wz@163.com>
References: <20230310105734.1574078-1-zyytlz.wz@163.com>
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

On Fri, 10 Mar 2023 18:57:34 +0800 Zheng Wang wrote:
> +	netif_carrier_off(netdev);
> +	netif_tx_disable(netdev);
> +	cancel_work_sync(&adpt->work_thread);
>  	unregister_netdev(netdev);
>  	netif_napi_del(&adpt->rx_q.napi);

same problem as in the natsemi driver
