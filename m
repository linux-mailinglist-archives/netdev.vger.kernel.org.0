Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126DC6CA76C
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbjC0OVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbjC0OV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:21:28 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D513C6595;
        Mon, 27 Mar 2023 07:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=YuhfnajKnda+rBY8XrxRXnL4rcLtfbo0joIpZbuQtjY=; t=1679926778; x=1681136378; 
        b=chtbjZ95GAT8BE4yoj9BvYDT9wzVn3YtmJyy4wMSp2hknExra8WT56hAxnvQGx1NxaQkQ0/tN41
        dNLZhdxIhWYGP0dyHOVMtUGjKuF/+WsRDPhjjxbUaZi69IT1Rk5kxgXfQ2mURR7fu2aN95EvO0pA9
        QKNM7sjA1566ihp9NSYW2nn3Jxz0TYzdRyXp464OwE0L/Php7+/A9oyCcYcT24O6nuKDa3K2LmgEc
        /cS1uAoEm5i/TpEbHfDhUo7MATlseGn+qhMqim1WCBvrm27JNN/MvpNmvmhZSeEW+o53xxuJ7WiGk
        S9ph5XUslCH7hbC1SnENLPkkDPvGiiF/Nz0Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pgnh9-00Fj9h-1a;
        Mon, 27 Mar 2023 16:19:35 +0200
Message-ID: <00659771ed54353f92027702c5bbb84702da62ce.camel@sipsolutions.net>
Subject: traceability of wifi packet drops
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 27 Mar 2023 16:19:34 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

So I just ran into this problem with a colleague again; we don't have
good visibility into why in the wifi stack a packet is dropped.

In the network stack we have skb drop reasons for (part of?) this, but
we don't really use this in wifi/mac80211 yet.

Unfortunately we have probably >100 distinct drop reasons in the wifi
stack, so annotating those is not only tedious, it would also double the
list of SKB drop reasons from currently ~75.

Any good ideas? I even thought about just encoding the line number
wherever we use RX_DROP_UNUSABLE / RX_DROP_MONITOR, but that's kind of
awkward too. Obviously we could change the internal API to completely
get rid of enum ieee80211_rx_result and use enum skb_drop_reason
instead, but then we'd probably need to carve out some space to also
differentiate DROP_MONITOR and DROP_UNUSABLE, perhaps something like


	SKB_DROP_REASON_MAC80211_MASK		0x03ff0000
	SKB_DROP_REASON_MAC80211_TYPE_MASK	0x03000000
	SKB_DROP_REASON_MAC80211_TYPE_UNUSABLE	0x01000000
	SKB_DROP_REASON_MAC80211_TYPE_MONITOR	0x02000000

	SKB_DROP_REASON_MAC80211_DUP		(SKB_DROP_REASON_MAC80211_TYPE_UNUSABLE | 1)
	SKB_DROP_REASON_MAC80211_BAD_BIP_KEYIDX	(SKB_DROP_REASON_MAC80211_TYPE_MON=
ITOR | 1)


etc.


That'd be a LOT of annotations (and thus work) though, and a lot of new
IDs/names, for something that's not really used all that much, i.e. a
file number / line number within mac80211 would be completely
sufficient, so the alternative could be to just have a separate
tracepoint inside mac80211 with a line number or so?

Anyone have any great ideas?

Thanks,
johannes
