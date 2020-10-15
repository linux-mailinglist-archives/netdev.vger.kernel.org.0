Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF6D28EA6A
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 03:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732019AbgJOBop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 21:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732292AbgJOBol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 21:44:41 -0400
Received: from smtp.gentoo.org (woodpecker.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96945C061755;
        Wed, 14 Oct 2020 18:44:41 -0700 (PDT)
To:     mathy.vanhoef@kuleuven.be
Cc:     johannes@sipsolutions.net,
        "davem@davemloft.net" <davem@davemloft.net>, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        denkenz@gmail.com
From:   Thomas Deutschmann <whissi@gentoo.org>
Organization: Gentoo Foundation, Inc
Subject: [Regression 5.9][Bisected 1df2bdba528b] Wifi GTK rekeying fails:
 Sending of EAPol packages broken
Message-ID: <4a7f92dc-13bb-697f-1730-ac288e74b730@gentoo.org>
Date:   Thu, 15 Oct 2020 03:44:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

after upgrading to linux-5.9.0 I noticed that my wifi got disassociated 
every 10 minutes when access point triggered rekeying for GTK.

This happened with iwd but not with wpa_supplicant. iwd was logging

> wlan0: disassociated from aa:bb:cc:dd:ap:01 (Reason: 2=PREV_AUTH_NOT_VALID)
> wlan0: authenticate with aa:bb:cc:dd:ap:01
> wlan0: send auth to aa:bb:cc:dd:ap:01 (try 1/3)
> wlan0: authenticated
> wlan0: associate with aa:bb:cc:dd:ap:01 (try 1/3)
> wlan0: RX AssocResp from aa:bb:cc:dd:ap:01 (capab=0x1511 status=0 aid=1)
> wlan0: associated

With the help of iwd developers (many thanks!) we noticed that EAPoL 
packets didn't reach access point. As workaround, using the legacy way 
to send EAPoL packets by setting

> [General]
> ControlPortOverNL80211=False

in iwd's main.conf, worked. So it became clear that this is a kernel 
problem.

I now finished bisecting the kernel and 
1df2bdba528b5a7a30f1b107b6924aa79af5e00e [1] is the first bad commit:

> commit 1df2bdba528b5a7a30f1b107b6924aa79af5e00e
> Author: Mathy Vanhoef
> Date:   Thu Jul 23 14:01:48 2020 +0400
> 
>     mac80211: never drop injected frames even if normally not allowed
> 
>     In ieee80211_tx_dequeue there is a check to see if the dequeued frame
>     is allowed in the current state. Injected frames that are normally
>     not allowed are being be dropped here. Fix this by checking if a
>     frame was injected and if so always allowing it.
> 
>     Signed-off-by: Mathy Vanhoef
>     Link: https://lore.kernel.org/r/20200723100153.31631-1-Mathy.Vanhoef@kuleuven.be
>     Signed-off-by: Johannes Berg
> 
>  net/mac80211/tx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Complete bisect log:

> git bisect start
> # good: [665c6ff082e214537beef2e39ec366cddf446d52] Linux 5.8.15
> git bisect good 665c6ff082e214537beef2e39ec366cddf446d52
> # bad: [bbf5c979011a099af5dc76498918ed7df445635b] Linux 5.9
> git bisect bad bbf5c979011a099af5dc76498918ed7df445635b
> # good: [bcf876870b95592b52519ed4aafcf9d95999bc9c] Linux 5.8
> git bisect good bcf876870b95592b52519ed4aafcf9d95999bc9c
> # bad: [47ec5303d73ea344e84f46660fff693c57641386] Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
> git bisect bad 47ec5303d73ea344e84f46660fff693c57641386
> # good: [8f7be6291529011a58856bf178f52ed5751c68ac] Merge tag 'mmc-v5.9' of git://git.kernel.org/pub/scm/linux/kernel/git/ulfh/mmc
> git bisect good 8f7be6291529011a58856bf178f52ed5751c68ac
> # bad: [76769c38b45d94f5492ff9be363ac7007fd8e58b] Merge tag 'mlx5-updates-2020-08-03' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
> git bisect bad 76769c38b45d94f5492ff9be363ac7007fd8e58b
> # good: [94d9f78f4d64b967273a676167bd34ddad2f978c] docs: networking: timestamping: add section for stacked PHC devices
> git bisect good 94d9f78f4d64b967273a676167bd34ddad2f978c
> # good: [5ee30564c85c94b7dc78aa6cce09e9712b2ad70d] ice: update reporting of autoneg capabilities
> git bisect good 5ee30564c85c94b7dc78aa6cce09e9712b2ad70d
> # good: [bd69058f50d5ffa659423bcfa6fe6280ce9c760a] net: ll_temac: Use devm_platform_ioremap_resource_byname()
> git bisect good bd69058f50d5ffa659423bcfa6fe6280ce9c760a
> # skip: [7dbc63f0a5402293e887e89a7974c5e48405565d] ice: Misc minor fixes
> git bisect skip 7dbc63f0a5402293e887e89a7974c5e48405565d
> # good: [1303a51c24100b3b1915d6f9072fe5ae5bb4c5f6] cfg80211/mac80211: add connected to auth server to station info
> git bisect good 1303a51c24100b3b1915d6f9072fe5ae5bb4c5f6
> # skip: [f34f55557ac9a4dfbfbf36c70585d1648ab5cd90] ice: Allow 2 queue pairs per VF on SR-IOV initialization
> git bisect skip f34f55557ac9a4dfbfbf36c70585d1648ab5cd90
> # bad: [cc5d229a122106733a85c279d89d7703f21e4d4f] fsl/fman: check dereferencing null pointer
> git bisect bad cc5d229a122106733a85c279d89d7703f21e4d4f
> # good: [6fc8c827dd4fa615965c4eac9bbfd465f6eb8fb4] tcp: syncookies: create mptcp request socket for ACK cookies with MPTCP option
> git bisect good 6fc8c827dd4fa615965c4eac9bbfd465f6eb8fb4
> # bad: [b90a1269184a3ff374562d243419ad2fa9d3b1aa] Merge branch 'net-openvswitch-masks-cache-enhancements'
> git bisect bad b90a1269184a3ff374562d243419ad2fa9d3b1aa
> # skip: [829eb208e80d6db95c0201cb8fa00c2f9ad87faf] rtnetlink: add support for protodown reason
> git bisect skip 829eb208e80d6db95c0201cb8fa00c2f9ad87faf
> # bad: [0e8642cf369a37b718c15effa6ffd52c00fd7d15] tcp: fix build fong CONFIG_MPTCP=n
> git bisect bad 0e8642cf369a37b718c15effa6ffd52c00fd7d15
> # skip: [48040793fa6003d211f021c6ad273477bcd90d91] tcp: add earliest departure time to SCM_TIMESTAMPING_OPT_STATS
> git bisect skip 48040793fa6003d211f021c6ad273477bcd90d91
> # good: [bc5cbd73eb493944b8665dc517f684c40eb18a4a] iavf: use generic power management
> git bisect good bc5cbd73eb493944b8665dc517f684c40eb18a4a
> # skip: [8f3f330da28ede9d106cd9d5c5ccd6a3e7e9b50b] tun: add missing rcu annotation in tun_set_ebpf()
> git bisect skip 8f3f330da28ede9d106cd9d5c5ccd6a3e7e9b50b
> # skip: [9466a1ccebbe54ac57fb8a89c2b4b854826546a8] mptcp: enable JOIN requests even if cookies are in use
> git bisect skip 9466a1ccebbe54ac57fb8a89c2b4b854826546a8
> # good: [09a071f52bbedddef626e71c0fd210838532f347] Documentation: intel: Replace HTTP links with HTTPS ones
> git bisect good 09a071f52bbedddef626e71c0fd210838532f347
> # bad: [75e6b594bbaeeb3f8287a2e6eb8811384b8c7195] cfg80211: invert HE BSS color 'disabled' to 'enabled'
> git bisect bad 75e6b594bbaeeb3f8287a2e6eb8811384b8c7195
> # bad: [1df2bdba528b5a7a30f1b107b6924aa79af5e00e] mac80211: never drop injected frames even if normally not allowed
> git bisect bad 1df2bdba528b5a7a30f1b107b6924aa79af5e00e
> # good: [180ac48ee62f53c26787350a956c5ac371cbe0b7] mac80211: calculate skb hash early when using itxq
> git bisect good 180ac48ee62f53c26787350a956c5ac371cbe0b7
> # good: [322cd27c06450b2db2cb6bdc68f3814149baf767] cfg80211/mac80211: avoid bss color setting in non-HE modes
> git bisect good 322cd27c06450b2db2cb6bdc68f3814149baf767
> # good: [fd17dba1c860d39f655a3a08387c21e3ceca8c55] cfg80211: Add support to advertize OCV support
> git bisect good fd17dba1c860d39f655a3a08387c21e3ceca8c55
> # first bad commit: [1df2bdba528b5a7a30f1b107b6924aa79af5e00e] mac80211: never drop injected frames even if normally not allowed


See also:
=========
[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1df2bdba528b5a7a30f1b107b6924aa79af5e00e


-- 
Regards,
Thomas Deutschmann / Gentoo Linux Developer
C4DD 695F A713 8F24 2AA1 5638 5849 7EE5 1D5D 74A5
