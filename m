Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F55E6266FD
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 05:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbiKLElO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 23:41:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbiKLElN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 23:41:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E15BCB7;
        Fri, 11 Nov 2022 20:41:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4332B827CF;
        Sat, 12 Nov 2022 04:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4C2C433D6;
        Sat, 12 Nov 2022 04:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668228060;
        bh=EBlCpgBnNdI9ZinSRuVqiqhM75tqO7ekqihYJFVrp+k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f/xiNtX4Y50G+0xNYtowYC7HvTdUZlT0DNORQFM06QZtnaVlGTD2LDvTVqdwDCxqb
         lFRkbDv26tjKFpkcBJNgX4OHlbvHqZEOOHnQCNsdypSJwLkSyX7X6f2SE/B+/IdgOx
         Rer1opj26libyYPSIxEQbyqQhBPdnUK3os+vjD2CuEo/14IXoJnE7ssF+D6UAFE8jR
         jIZpspMjWx5HpUPgwq3y8fOK+0jLTR5HYFcBHKAs9a7a5OORYXxUY3MAiozkN38U/7
         klRZXQZgRGgplZnrMG8hRPXGMriyGPtggRDf9lRIVmJ9zaiGITQXYPODcIInIbj0il
         tGaf1u52ihFxw==
Date:   Fri, 11 Nov 2022 20:40:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/4] net: dsa: add support for DSA rx
 offloading via metadata dst
Message-ID: <20221111204059.17b8ce95@kernel.org>
In-Reply-To: <20221111233714.pmbc5qvq3g3hemhr@skbuf>
References: <20221110212212.96825-1-nbd@nbd.name>
        <20221110212212.96825-2-nbd@nbd.name>
        <20221111233714.pmbc5qvq3g3hemhr@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Nov 2022 01:37:14 +0200 Vladimir Oltean wrote:
> Jakub, what do you think? Refcounting or no refcounting?

I would not trust my word over Felix's.. but since you asked I'd vote
for refcounted. There's probably a handful of low level redirects
(generic XDP, TC, NFT) that can happen and steal the packet, and
keep it alive for a while. I don't think they will all necessarily
clear the dst.
