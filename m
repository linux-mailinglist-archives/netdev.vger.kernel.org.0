Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E7054AEEC
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 12:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236027AbiFNK7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 06:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiFNK6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 06:58:46 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5515D286C1;
        Tue, 14 Jun 2022 03:58:43 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1655204320; bh=XY227SjZimMDP/m7qB4ABMwXhSX1786bA3oIzbKiaUc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=xkWqfznOqILQ619kFm+0+grH1kaZ1DDdengTctr4FwFNl0JVXLe02rhbYPGZypOPX
         8oF9YoxH6LAylRdWdyVowW0vcKCs32zdOSLdnElWIBSvG+1YkBnBrrYnzv4b2O+oDS
         0lAxJG3t5BiaHUZimrk3xf2iRHPrd7RwmkNXqSNFRS7uHeALQPSQYbHOQcCZw6MHsC
         S+mPk5hnhgp28Ckrdb9CGZRWRyK/CioJkJsdN+1QL4bXE9bVYQpyjlqZW5cAHY3OB4
         BY4CytX+6ayn+lGVt2OHcgORbXM2q1vHJr4SgNbnM2XUVvTqiOKEcphDblFuYfEMva
         vqBkelVkeSfDA==
To:     Pavel Skripkin <paskripkin@gmail.com>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Subject: Re: [PATCH v6 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
In-Reply-To: <d57bbedc857950659bfacac0ab48790c1eda00c8.1655145743.git.paskripkin@gmail.com>
References: <d57bbedc857950659bfacac0ab48790c1eda00c8.1655145743.git.paskripkin@gmail.com>
Date:   Tue, 14 Jun 2022 12:58:40 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87o7yvzf33.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pavel Skripkin <paskripkin@gmail.com> writes:

> Syzbot reported use-after-free Read in ath9k_hif_usb_rx_cb() [0]. The
> problem was in incorrect htc_handle->drv_priv initialization.
>
> Probable call trace which can trigger use-after-free:
>
> ath9k_htc_probe_device()
>   /* htc_handle->drv_priv =3D priv; */
>   ath9k_htc_wait_for_target()      <--- Failed
>   ieee80211_free_hw()		   <--- priv pointer is freed
>
> <IRQ>
> ...
> ath9k_hif_usb_rx_cb()
>   ath9k_hif_usb_rx_stream()
>    RX_STAT_INC()		<--- htc_handle->drv_priv access
>
> In order to not add fancy protection for drv_priv we can move
> htc_handle->drv_priv initialization at the end of the
> ath9k_htc_probe_device() and add helper macro to make
> all *_STAT_* macros NULL safe, since syzbot has reported related NULL
> deref in that macros [1]
>
> Link: https://syzkaller.appspot.com/bug?id=3D6ead44e37afb6866ac0c7dd121b4=
ce07cb665f60 [0]
> Link: https://syzkaller.appspot.com/bug?id=3Db8101ffcec107c0567a0cd8acbba=
cec91e9ee8de [1]
> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
> Reported-and-tested-by: syzbot+03110230a11411024147@syzkaller.appspotmail=
.com
> Reported-and-tested-by: syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail=
.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

Alright, since we've heard no more objections and the status quo is
definitely broken, let's get this merged and we can follow up with any
other fixes as necessary...

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
