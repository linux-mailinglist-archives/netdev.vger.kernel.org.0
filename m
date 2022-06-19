Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47981550A6F
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 13:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236914AbiFSL5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 07:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbiFSL5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 07:57:33 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA8F120B3;
        Sun, 19 Jun 2022 04:57:32 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1o2tYW-0001jE-BM; Sun, 19 Jun 2022 13:57:28 +0200
Message-ID: <43d48a1e-d5a6-3dbe-b3d5-6157f34d15c1@leemhuis.info>
Date:   Sun, 19 Jun 2022 13:57:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] Bluetooth: hci_sync: complete LE connection on any event
Content-Language: en-US
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kernel@pengutronix.de, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220616092418.738877-1-a.fatoum@pengutronix.de>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20220616092418.738877-1-a.fatoum@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1655639852;befdf198;
X-HE-SMSGID: 1o2tYW-0001jE-BM
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

On 16.06.22 11:24, Ahmad Fatoum wrote:
> Commit 6cd29ec6ae5e ("Bluetooth: hci_sync: Wait for proper events when
> connecting LE") changed HCI core to wait for specific events before
> posting completion for a new LE connection. This commit introduced
> regressions partially fixed in commits a56a1138cbd8
> ("Bluetooth: hci_sync: Fix not using conn_timeout") and
> and c9f73a2178c1 ("Bluetooth: hci_conn: Fix hci_connect_le_sync").
> 
> Yet, a regression still remains where devices that worked previously
> now timeout[1][2]. Restore working order by reverting the commit in
> question until this issue can be properly resolved.
> 
> [1]: https://lore.kernel.org/linux-bluetooth/a1ce1743-e450-6cdb-dfab-56a3e3eb9aed@pengutronix.de/
> [2]: https://github.com/bluez/bluez/issues/340

That way regzbot will miss the tags and not associate the fix with the
regression. You can leave it like that and add these, as explained in
the kernel docs (see for example submitting-patches.rst):

Link:
https://lore.kernel.org/linux-bluetooth/a1ce1743-e450-6cdb-dfab-56a3e3eb9aed@pengutronix.de/
Link: https://github.com/bluez/bluez/issues/340

Or your remove the two footnotes and do it like this:

Link:
https://lore.kernel.org/linux-bluetooth/a1ce1743-e450-6cdb-dfab-56a3e3eb9aed@pengutronix.de/
[1]
Link: https://github.com/bluez/bluez/issues/340 [2]

> Fixes: 6cd29ec6ae5e ("Bluetooth: hci_sync: Wait for proper events when connecting LE")
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> ---
> Event callbacks like hci_le_meta_evt() use hci_skb_event(hdev->sent_cmd)
> for matching. I suspect the timeout is due to intermittent frames,
> e.g. because of remote unpairing, replacing the sent_cmd and thus
> breaking renewed pairing as the frames couldn't be matched. This is too
> complex for me to fix and we have been carrying this fix for a month now,
> so I think it's best we revert this upstream for now.
> 
> #regzb Link: https://lore.kernel.org/linux-bluetooth/a1ce1743-e450-6cdb-dfab-56a3e3eb9aed@pengutronix.de/

Thx for trying to do the right thing, but that didn't work out, as
"Link:" doesn't need a "#regzb". Maybe regzbot should handle this, not
sure, will keep it in mind.

Anyway, let's make regzbot aware of this thread, as you intended (thx
again):

#regzbot ^backmonitor
https://lore.kernel.org/linux-bluetooth/a1ce1743-e450-6cdb-dfab-56a3e3eb9aed@pengutronix.de/

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.
