Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4EE865D68D
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 15:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbjADOuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 09:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239492AbjADOu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 09:50:29 -0500
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C2715FD9;
        Wed,  4 Jan 2023 06:50:28 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1672843827; bh=RhUpPXeqy4zC5y8o4T9vwm1JBnek7Qt8unzveh+tzmo=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=VIRw2osON36t0QF3/yrBlGaq3Ih0Q6GmhBRC2GsIoPwVo6s8zcdY6C0S5CJisP9yN
         /wfYwGdmhvOxUidk53E9pKqIgYrag23LZDP9uKpT9Sx5asaJWujBBB8x0f4R3r6azx
         EUGC7Bf3qRjQSRVqzrSZJgtAXC0hHj0eyevRqEqeEMpipcApkWDcBcV63eIfBQNxHY
         XmcOTxlhTJ50dZjDvg0Dt1NY9U1IKM8OctWJnmOoRTp1JrRvhnDkCbf/hZoeBfhmnZ
         vANTjpX1eoQaU+B+Jrmw95Q7greuDN0sKGhmpL67gc8woeOwNep88lR0I+VPsIWTC9
         9a2yl6wQakmvA==
To:     Fedor Pchelkin <pchelkin@ispras.ru>, Kalle Valo <kvalo@kernel.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Zekun Shen <bruceshenzk@gmail.com>,
        Joe Perches <joe@perches.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+e9632e3eb038d93d6bc6@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] wifi: ath9k: hif_usb: clean up skbs if
 ath9k_hif_usb_rx_stream() fails
In-Reply-To: <20230104123615.51511-1-pchelkin@ispras.ru>
References: <20230104123615.51511-1-pchelkin@ispras.ru>
Date:   Wed, 04 Jan 2023 15:50:26 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87tu161hhp.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fedor Pchelkin <pchelkin@ispras.ru> writes:

> Syzkaller detected a memory leak of skbs in ath9k_hif_usb_rx_stream().
> While processing skbs in ath9k_hif_usb_rx_stream(), the already allocated
> skbs in skb_pool are not freed if ath9k_hif_usb_rx_stream() fails. If we
> have an incorrect pkt_len or pkt_tag, the input skb is considered invalid
> and dropped. All the associated packets already in skb_pool should be
> dropped and freed. Added a comment describing this issue.
>
> The patch also makes remain_skb NULL after being processed so that it
> cannot be referenced after potential free. The initialization of hif_dev
> fields which are associated with remain_skb (rx_remain_len,
> rx_transfer_len and rx_pad_len) is moved after a new remain_skb is
> allocated.=20
>
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
>
> Fixes: 6ce708f54cc8 ("ath9k: Fix out-of-bound memcpy in ath9k_hif_usb_rx_=
stream")
> Fixes: 44b23b488d44 ("ath9k: hif_usb: Reduce indent 1 column")
> Reported-by: syzbot+e9632e3eb038d93d6bc6@syzkaller.appspotmail.com
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
