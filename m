Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6086F529F2A
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 12:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243414AbiEQKRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 06:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344541AbiEQKRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 06:17:00 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843D44CD49;
        Tue, 17 May 2022 03:14:01 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1652782439; bh=FgLlz7yX3If1Y6jUp+qPllpmpLPTg7kdgt59d0KH3GU=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=kvpDqQveB2NW67xPPY6OyXlsFGsGQ+9IgrnaHQ09tj25bU6d5fC4v0rs5uMf1Clum
         tgEnkIIYgCsOY+EU2zm25nkrz/bieQom7u6OAIbFw3JoL67esL3eXhazO14fvQWzdQ
         L0dEv1VVn+66gwn7kxJbuek5YbVwZoopUgnDQNWUZ3WFAXDPTLzr6hZpCFpjZCPLSp
         GDmeh0EzvfAc62RVv5Ocm13EDJ2FDfPGZq9l+JbuZMAxgPqTV9WFWUy/DV1sz+V8zY
         Mgb3xNr2yIo/whq1DKzqjNF4wIjVkK1gGaTAQM+GJ6UcbQRF5gAwAsb4aKZ2/7inHZ
         67IaLaZaGTfLQ==
To:     Pavel Skripkin <paskripkin@gmail.com>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Subject: Re: [PATCH v4 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
In-Reply-To: <f158608e209a6f45c76ec856474a796df93d9dcf.1652553719.git.paskripkin@gmail.com>
References: <f158608e209a6f45c76ec856474a796df93d9dcf.1652553719.git.paskripkin@gmail.com>
Date:   Tue, 17 May 2022 12:13:58 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <874k1ocvq1.fsf@toke.dk>
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

Pavel Skripkin <paskripkin@gmail.com> writes:

> Syzbot reported use-after-free Read in ath9k_hif_usb_rx_cb() [0]. The
> problem was in incorrect htc_handle->drv_priv initialization.
>
> Probable call trace which can trigger use-after-free:
>
> ath9k_htc_probe_device()
>   /* htc_handle->drv_priv = priv; */
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
> all *_STAT_* macros NULL save, since syzbot has reported related NULL

s/save/safe here as well :)

-Toke
