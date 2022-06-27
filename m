Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA6455DE46
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbiF0JEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 05:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233127AbiF0JET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 05:04:19 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53811634B
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 02:04:18 -0700 (PDT)
Received: from [IPV6:2003:e9:d74e:f826:4917:6f43:fd50:6bb6] (p200300e9d74ef82649176f43fd506bb6.dip0.t-ipconnect.de [IPv6:2003:e9:d74e:f826:4917:6f43:fd50:6bb6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 829E6C04B4;
        Mon, 27 Jun 2022 11:04:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1656320652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tqxBSMP2wDu38wyUbk5uJUpI3MGUgBwribcrUBf6WmU=;
        b=Qe8zDfq4Bqqrhh/pP6Wr91FvmAFEmHffGUctQFmNjegSZvszV3O4HrlBagsPYF1oLYrQrn
        H7BZ8biv8I7IZbExgXtrVXxMNb22OeOi6V+Jl+KWfsaMLpX/u/JwhqWCkKitqjAqTat64f
        4jGAqNR9/1faaqnJYm1iL/fK3qmNepeub+/EDyFuWj42YwXNaZXVgW9dzjQdF5Pid5oq2w
        sIEYl1EwkoOmHkVsnrSp6dEzHiZ8TEUTd7b8HIa4nM+FOStdDIHMa7eybEVkiwdVciCNip
        50e2qupzZlxscM4VlwMpv49Q/w0ViHDTkj983QJG8Iyx4X3b2ypjzmRbjQfnPA==
Message-ID: <bd165a84-57a7-bfe2-7b15-752980d5d175@datenfreihafen.org>
Date:   Mon, 27 Jun 2022 11:04:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] net: mac802154: Fix a Tx warning check
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20220617192914.1275611-1-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220617192914.1275611-1-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 17.06.22 21:29, Miquel Raynal wrote:
> The purpose of the netif_is_down() helper was to ensure that the network
> interface used was still up when performing the transmission. What it
> actually did was to check if _all_ interfaces were up. This was not
> noticed at that time because I did not use interfaces at all before
> discussing with Alexander Aring about how to handle coordinators
> properly.
> 
> Drop the helper and call netif_running() on the right sub interface
> object directly.
> 
> Fixes: 4f790184139b ("net: mac802154: Add a warning in the slow path")
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>   net/mac802154/ieee802154_i.h |  8 ++++++--
>   net/mac802154/tx.c           | 31 ++++++++-----------------------
>   2 files changed, 14 insertions(+), 25 deletions(-)


This patch has been applied to the wpan-next tree and will be
part of the next pull request to net-next. Thanks!

regards
Stefan Schmidt
