Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2176EE0F9
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 13:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbjDYLO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 07:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233877AbjDYLOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 07:14:49 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B395A9;
        Tue, 25 Apr 2023 04:14:46 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1682421284; bh=vrTSialJD2Li5vjQDpn9fTzt12D3cKs5drm5QZYYqCY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=OrJABxrUwNHh6hEAw5k6Y80NDr8Y6rSn1mDeNMtSZmK65oiBYVB6RNr6fmpzYw8PV
         NT32YOiek5iwEUoqbIAwkT3EsBROUL9aZFcwcjh+Mqmb3YmfmebnI4hbZlklYE0HLq
         oTl4+NbXXMelRk8u+tVOcpCQM/jZG06MMFc+FZXW4WzD3n37mK8p9IbPFPN78txUxn
         MuH2zDuAjmWidmU7lY4QJmP2c5h0wbXkS4HkFFthaX5y/JMceqfs+FqP7c2pYFynil
         NkImXfAXBR6eg7oFkiKHbIZrZVw4AZ+/QkiuHEHWJ0Wxd+8LQ0QA2nbxtX69C+MMuZ
         OE23MS4NTyK0g==
To:     Fedor Pchelkin <pchelkin@ispras.ru>, Kalle Vallo <kvalo@kernel.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Sujith <Sujith.Manoharan@atheros.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+f2cb6e0ffdb961921e4d@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] wifi: ath9k: avoid referencing uninit memory in
 ath9k_wmi_ctrl_rx
In-Reply-To: <20230424183348.111355-1-pchelkin@ispras.ru>
References: <20230424183348.111355-1-pchelkin@ispras.ru>
Date:   Tue, 25 Apr 2023 13:14:43 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87sfcojjrw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fedor Pchelkin <pchelkin@ispras.ru> writes:

> For the reasons also described in commit b383e8abed41 ("wifi: ath9k: avoid
> uninit memory read in ath9k_htc_rx_msg()"), ath9k_htc_rx_msg() should
> validate pkt_len before accessing the SKB.
>
> For example, the obtained SKB may have been badly constructed with
> pkt_len =3D 8. In this case, the SKB can only contain a valid htc_frame_h=
dr
> but after being processed in ath9k_htc_rx_msg() and passed to
> ath9k_wmi_ctrl_rx() endpoint RX handler, it is expected to have a WMI
> command header which should be located inside its data payload.=20
>
> Implement sanity checking inside ath9k_wmi_ctrl_rx(). Otherwise, uninit
> memory can be referenced.
>
> Tested on Qualcomm Atheros Communications AR9271 802.11n .
>
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
>
> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
> Reported-and-tested-by: syzbot+f2cb6e0ffdb961921e4d@syzkaller.appspotmail=
.com
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
