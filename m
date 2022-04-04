Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7EE4F1B7E
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379453AbiDDVTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379920AbiDDSVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 14:21:40 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F340022B37;
        Mon,  4 Apr 2022 11:19:41 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1649096380; bh=QeGEmumyI0bTa9hQLQemEOhMF26a8yF+DIu+jq5TyfY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=HrYvVqyGRySL75m2K8ZelMvByGERl3maQTxqymSD5ngY6PMSZtZoYnBE8FgM6o8QM
         eIg1adhWgbIqFEvCXL113vtpCOxgqtdGHHIM4xwbdrG90Z2j2qguM1JRuJQkCWuakc
         c2NV6E9tCUBOL1EGDy+CbJ/4ScrbnkPnQ3KXadHutzyI2n+1Si/zRyCJm8i7w252Cs
         Bjl6+Z0ZZ38DFtbwtVZBIkjVTkqgdfBkd9nPwFFqyw0Rr53yv+Agu33VEqM6KEmHf6
         Ao3XL2h20VfE24/iLt/y49+1/7QIczHhCrG1iiGB9kw4m6r4vRONdXiLGl4jAs8C3D
         vYk+BoZAScemg==
To:     Peter Seiderer <ps.report@gmx.net>, linux-wireless@vger.kernel.org
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] ath9k: fix ath_get_rate_txpower() to respect the
 rate list end tag
In-Reply-To: <20220402153014.31332-1-ps.report@gmx.net>
References: <20220402153014.31332-1-ps.report@gmx.net>
Date:   Mon, 04 Apr 2022 20:19:39 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87ilroemo4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Peter Seiderer <ps.report@gmx.net> writes:

> Stop reading (and copying) from ieee80211_tx_rate to ath_tx_info.rates
> after list end tag (count == 0, idx < 0), prevents copying of garbage
> to card registers.

In the normal case I don't think this patch does anything, since any
invalid rate entries will already be skipped (just one at a time instead
of all at once). So this comment is a bit misleading.

Also, Minstrel could in principle produce a rate sequence where the
indexes are all positive, but there's one in the middle with a count of
0, couldn't it? With this patch, the last entries of such a sequence
would now be skipped...

-Toke
