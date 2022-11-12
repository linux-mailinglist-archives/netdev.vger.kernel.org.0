Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18885626902
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 12:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbiKLLNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 06:13:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbiKLLNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 06:13:33 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082FE100F;
        Sat, 12 Nov 2022 03:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6IVvTJ7xXdP76g3qTEs/lWl0/xdLucKLgA47BvOkZRM=; b=QMrUO1+EZdy+9uySixHhpjE/7t
        3nETsz8RR6MfVTcuoDrt0fahThcJUTpAsm8OB5D24V7ZcCAJFOx4GPlWuWqXT/QGDIRRc0GrGXuWN
        OYJ7HvMzgtZLDE/o6QTcGlYh/1JLvMa1lh88clfqTPIi/AZNPXriYQB/pBYEkGLuhV3A=;
Received: from p200300daa72ee10cb9d33d2e9c9a0fe5.dip0.t-ipconnect.de ([2003:da:a72e:e10c:b9d3:3d2e:9c9a:fe5] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1otoRo-001JKe-EX; Sat, 12 Nov 2022 12:13:16 +0100
Message-ID: <bcb33ba7-b2a3-1fe7-64b2-1e15203e2cce@nbd.name>
Date:   Sat, 12 Nov 2022 12:13:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v3 1/4] net: dsa: add support for DSA rx
 offloading via metadata dst
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20221110212212.96825-1-nbd@nbd.name>
 <20221110212212.96825-2-nbd@nbd.name> <20221111233714.pmbc5qvq3g3hemhr@skbuf>
 <20221111204059.17b8ce95@kernel.org>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20221111204059.17b8ce95@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.11.22 05:40, Jakub Kicinski wrote:
> On Sat, 12 Nov 2022 01:37:14 +0200 Vladimir Oltean wrote:
>> Jakub, what do you think? Refcounting or no refcounting?
> 
> I would not trust my word over Felix's.. but since you asked I'd vote
> for refcounted. There's probably a handful of low level redirects
> (generic XDP, TC, NFT) that can happen and steal the packet, and
> keep it alive for a while. I don't think they will all necessarily
> clear the dst.
I don't really see a valid use case in running generic XDP, TC and NFT 
on a DSA master dealing with packets before the tag receive function has 
been run. And after the tag has been processed, the metadata DST is 
cleared from the skb.
How about this: I send a v4 which uses skb_dst_drop instead of 
skb_dst_set, so that other drivers can use refcounting if it makes sense 
for them. For mtk_eth_soc, I prefer to leave out refcounting for 
performance reasons.
Is that acceptable to you guys?

- Felix
