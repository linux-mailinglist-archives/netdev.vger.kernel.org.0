Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA03D49137
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 22:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbfFQUUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 16:20:51 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36672 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbfFQUUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 16:20:50 -0400
Received: by mail-ed1-f66.google.com with SMTP id k21so18015730edq.3;
        Mon, 17 Jun 2019 13:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q266JJLz9ryqY/0+UZPE9Zx3GwNDeNz9U54dOM54ABo=;
        b=DJU/AxKh1gkT+BwYaOUm45TFhmBocQ+BYriarZHUpE5xGoefIfXr5NbNgWaomMJs3E
         IsJj0TXe8WmIkbSlc2Xgg3sDpS/bvXCv478/F49tv8MQqJLLOc+Y7g8eHrbyMTL6ZmgX
         JyylsfstvA45mQOzoE+MK3ewU9nHPZ4r7J8VeYmzxxAk08VPJs8Zx/OuFX2a9KQe6CBL
         2eYaFp/lhbSswMv3LDdnIsjRoyAzmK0Rjfa/9Q7dveHCx1lpQYRmrhrROgK8AKPEeabN
         qM068o5tJyRGaZvTlm0FDIVvpiyMUCWNQcKtGLsasQrLD+YbGuMzSoanumKs60Mx3EcI
         j29w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q266JJLz9ryqY/0+UZPE9Zx3GwNDeNz9U54dOM54ABo=;
        b=hNrvJBdYAhJ9AaYuXGdlJO+orDa2JoKOcVXM3zhjGkjmTgdo+eUXcMIx2rnpFAl5Vq
         kF8I7hmZG646FM9ooK3+N9x4nHogGiAUVgv7PCoBifPaYP74BBbLUHXPkQPm39wZ0hW9
         X3GNCwQvkqKEht/BRO/196F2R+vWOjtoiaZBppnVHQrhpkE35cnUJUN7+gea4Fr+Rx+i
         ifM6Al5JCBOHz6H1EVCUdapkEPt66P5faxTsoBVbPT5dnmMKbY85PikE8NJUo0M4hSK2
         pxqpEFnxR91gKkt/lwXhNLYJBiHPTXYKXX4dspWQc6OiOrmCc9Be1724xUl2QxhJ80iF
         8xDQ==
X-Gm-Message-State: APjAAAV2V11cEeAjk9qcYstrKxi4Oc+HMTaZI9/E/vFU4BKumsMbh8am
        Rl4oprP88Of/G/ULoSLz88bSZPjksOe6ixB8Vux2og==
X-Google-Smtp-Source: APXvYqwYyze36Ba6mvrpY0VMn5Nb1Ipj791THppaVjCXkkZZXPLGdKOHvIBTyOzWsUS302zZQUDbjIUijIvuMpuai7o=
X-Received: by 2002:a17:906:cd1f:: with SMTP id oz31mr11019140ejb.226.1560802848743;
 Mon, 17 Jun 2019 13:20:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190617190507.12730-1-fklassen@appneta.com>
In-Reply-To: <20190617190507.12730-1-fklassen@appneta.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 17 Jun 2019 16:20:12 -0400
Message-ID: <CAF=yD-JuSE_Pvy9QR-m=YqrVQoBverzKW+saMLC=HFgDzTPdOA@mail.gmail.com>
Subject: Re: [PATCH net v4] net/udp_gso: Allow TX timestamp with UDP GSO
To:     Fred Klassen <fklassen@appneta.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 3:05 PM Fred Klassen <fklassen@appneta.com> wrote:
>
> Fixes an issue where TX Timestamps are not arriving on the error queue
> when UDP_SEGMENT CMSG type is combined with CMSG type SO_TIMESTAMPING.
> This can be illustrated with an updated updgso_bench_tx program which
> includes the '-T' option to test for this condition. It also introduces
> the '-P' option which will call poll() before reading the error queue.
>
>     ./udpgso_bench_tx -4ucTPv -S 1472 -l2 -D 172.16.120.18
>     poll timeout
>     udp tx:      0 MB/s        1 calls/s      1 msg/s
>
> The "poll timeout" message above indicates that TX timestamp never
> arrived.
>
> This patch preserves tx_flags for the first UDP GSO segment. Only the
> first segment is timestamped, even though in some cases there may be
> benefital in timestamping both the first and last segment.
>
> Factors in deciding on first segment timestamp only:
>
> - Timestamping both first and last segmented is not feasible. Hardware
> can only have one outstanding TS request at a time.
>
> - Timestamping last segment may under report network latency of the
> previous segments. Even though the doorbell is suppressed, the ring
> producer counter has been incremented.
>
> - Timestamping the first segment has the upside in that it reports
> timestamps from the application's view, e.g. RTT.
>
> - Timestamping the first segment has the downside that it may
> underreport tx host network latency. It appears that we have to pick
> one or the other. And possibly follow-up with a config flag to choose
> behavior.
>
> v2: Remove tests as noted by Willem de Bruijn <willemb@google.com>
>     Moving tests from net to net-next
>
> v3: Update only relevant tx_flag bits as per
>     Willem de Bruijn <willemb@google.com>
>
> v4: Update comments and commit message as per
>     Willem de Bruijn <willemb@google.com>
>
> Fixes: ee80d1ebe5ba ("udp: add udp gso")
> Signed-off-by: Fred Klassen <fklassen@appneta.com>

Acked-by: Willem de Bruijn <willemb@google.com>
