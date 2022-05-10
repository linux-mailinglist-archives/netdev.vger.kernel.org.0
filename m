Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC4B520ACA
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 03:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbiEJBnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 21:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbiEJBm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 21:42:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AE62BDC
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 18:39:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1E75B810EA
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 01:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A484C385C5;
        Tue, 10 May 2022 01:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652146740;
        bh=wYAqNlOd8X8AHHgsuq0w1JlfvMBpR/XOu1fl32X4omQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Z1pSs3+fO7Q+YFPGgD+rDyEMeXkeXwoQsZxFpFMQ8CjFLykPxACrSCZ6B7m4Kzlo7
         mJW+qOe+uQG1fS8DDWQlrG43//PEqG2ECaADfkkSAT6Qe5ZxNxr3H0UwXBnVB3INs7
         igVcPzZNwa+eh7qJ54XrQJEc9I7G0CnFHY9Y9V0Se8sAK79RjITlOOGQUbokYFBkcF
         fKTT4vLrPnmnZroVHRpgT3OEIj1uDoS0bxbIoJaiZLSB521RkW1AJXASB/kqQWuN7N
         /6XAVuOgwp9ZXHavdr1hPoONe7Gt2pCoZ3vKDtorKZWLLje7Q5MgFJ+O7DTxnPIaRC
         IdQxo4P1Ennzw==
Message-ID: <b84e51fa-f410-956e-7304-7a49d297f254@kernel.org>
Date:   Mon, 9 May 2022 19:38:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH v2 net-next] net: neigh: add netlink filtering based on
 LLADDR for dump
Content-Language: en-US
To:     Florent Fourcot <florent.fourcot@wifirst.fr>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20220509205646.20814-1-florent.fourcot@wifirst.fr>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220509205646.20814-1-florent.fourcot@wifirst.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/22 2:56 PM, Florent Fourcot wrote:
> neighbours table dump supports today two filtering:
>  * based on interface index
>  * based on master index
> 
> This patch adds a new filtering, based on layer two address. That will
> help to replace something like it:
> 
>  ip neigh show | grep aa:11:22:bb:ee:ff
> 
> by a better command:
> 
>  ip neigh show lladdr aa:11:22:bb:ee:ff
> 

that is done by a GET without the NLM_F_DUMP flag set; doing a table
dump and filtering to get the one entry is wrong.

