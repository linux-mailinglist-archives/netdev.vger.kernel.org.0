Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1ED134E3CC
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 11:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhC3JAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 05:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbhC3I7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 04:59:53 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756CBC061762
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 01:59:53 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id w3so23686893ejc.4
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 01:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=cthzB+PK6lUgctUa4gYAlMsHLCsT4Ifk6ykP0EohgUM=;
        b=T4f3uyskXvKZ68W9afDGzcQBG34nmj5oJeTCDurAJV8ykRP9zkgHkwkGRT+pkJcEx6
         Dy1rFT8w8j4Kg2RAaAlTz30mJKe2ayZ4L++vOAbcMWoHT+JVJnQdZJwt5mCdQCK1/M7N
         6qinIx+oz5Cq/RG7Z7VXuwknqRp7T5HheiOhylVg0S9FKt+UBDqBoyaBErOiSWAkUAiT
         /NOa3EIFs3/UfCS3lmvxovPiYgCVQ5CDBP9q2Nxzlvb/rkG+nPMispbKO+9ED/RvM2iZ
         WUt02KojGdqu4MwuQMhtyonSUDBH+FNDI7QmBosPZpOZfjCB2O9ZrAc4Mt1ZkjAYIvJs
         9jWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=cthzB+PK6lUgctUa4gYAlMsHLCsT4Ifk6ykP0EohgUM=;
        b=dTObfdpbpZSChbMaVVpSciZb0cKWWT/ifHfPGtL3MnF6tSIyloZ/tkHqlgin6hrlEI
         uAW8Iqtf/sxvF9CPbA7+bUbHI5rlr5QC6Yy/AubalLWU3tyMmmF5snqlFhhAGgWEjaIw
         C33EwVEK0R1tys/RZmvYxWbJw2ozFcYhnU3ouWY1jCHq14fxI6hC1L38jRp7yFwgfJY/
         aLaC2YXJQ8UD8nw+37Y5fTcDUZqNE4ycRyAzKcfyRsRLshY8vJbMdRblweRdNpjgC2bc
         rx1+jyGQN0+nPV+nhnO/PW2V28W3M3IdfQsKuk70Fqpp1KmlRtidoRzSnGAjx1ONME/F
         HO1w==
X-Gm-Message-State: AOAM533+NUVPrwIEgOtcRdgJbIpL2J6JfMuMBerlMeSCf47cTaNaR6oi
        ZGdXcrptE/DFkurJoRm3IOc7wMrjmkxn8zmlOA2WDNnKyLE=
X-Google-Smtp-Source: ABdhPJwf51TG5+x2pGgBUtUf3Cznx84rKg5jrW7vQpAp2qx/m/361fIpyZWqRP5BnpKmxKtwNCpVqTDf34O94eD/C2Q=
X-Received: by 2002:a17:906:8a61:: with SMTP id hy1mr19048186ejc.59.1617094792112;
 Tue, 30 Mar 2021 01:59:52 -0700 (PDT)
MIME-Version: 1.0
From:   Navin P <navinp0304@gmail.com>
Date:   Tue, 30 Mar 2021 14:29:41 +0530
Message-ID: <CALO2TqLB04BGHH9XwXc+TBo1bf3rshCCp61U=FWu76ujNhffMQ@mail.gmail.com>
Subject: Mismatch between tcp_output.c and tcp_fastopen.c in net/ipv4
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

 I've a question regarding bytes_received and bytes_sent.

 https://elixir.bootlin.com/linux/latest/source/net/ipv4/tcp_output.c#L1385

 In net/ipv4/tcp_output.c
 if (skb->len != tcp_header_size) {
tcp_event_data_sent(tp, sk);
tp->data_segs_out += tcp_skb_pcount(skb);
tp->bytes_sent += skb->len - tcp_header_size;
}


https://elixir.bootlin.com/linux/latest/source/net/ipv4/tcp_fastopen.c#L220

In net/ipv4/tcp_fastopen.c

/* u64_stats_update_begin(&tp->syncp) not needed here,
 * as we certainly are not changing upper 32bit value (0)
 */
tp->bytes_received = skb->len;

Above we miss tcp_header_size.

1. Shouldn't bytes_received be skb->len - tcp_header_size for
consistency ? I'm not sure if skb->len - tcp_header_size is correct .

2. Should it not be skb->len - tcp_header_size - ip_header_size -
skb->mac_len  ?


Regards,
Navin
