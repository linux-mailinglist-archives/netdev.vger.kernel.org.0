Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 230232D023
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 22:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfE1UQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 16:16:05 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:32956 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfE1UQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 16:16:05 -0400
Received: by mail-ua1-f67.google.com with SMTP id 49so8562925uas.0
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 13:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=2PbUTDuXiAxR50haxEpsxltfONNocyGAYpvkm6Pt77c=;
        b=ko5bLkd/y0RUxLPfQLyJORMqZAJZ0nVfF3nCqs0In1f2QhZLPWX2amL/jAibl3e+om
         BKfY2EVCPBKAgbqF0xzsmG3zFZSODPaVgkcJvPPJS6P8c09Ynx5nItSJcyyyeaP2nefj
         CuP4vKDfBze7YiB/IpCx+JdxGf0Jtst4YpN2xBl+Xa5Prij4hddFW32YgRkGpdYv1fwa
         D9okItb0t5RHxS2Ud3wks5da82bFdQ4RuEjuQW+OBYGSHdgFk+HB+UwFJZcTxFzD1l7L
         e+JP8BYNU8JOi/yTfL8cFdYJHujER2/IFT3zbnXOzSVLtovwT2XyS4cAwYN7Sz2AAbHO
         QhQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=2PbUTDuXiAxR50haxEpsxltfONNocyGAYpvkm6Pt77c=;
        b=ANQewgcsK49cHjOcyKVUYEk+dgHZw0LRUDoYq3/7bPzgHhYFxfeqjfzvXzQa7bx67H
         KbxsIvKprIQFKUt9qotY4UePAc6TvEO/x/spCSHP+si1/CfNZqdJEeKRxtIseXuU/30d
         N+bUKKcLWvB3Xt9wvr0M0ysbQorlSQWwfcya5UirUuOaX9EhVa8PvWc73RiJinklkkcc
         eQytQKD5avbD8V79jmJ46NOMYs8+mzz3GTgBrRC/8tns2A/m3Jf/472YWyEPVbZ/wa2T
         eMVHboVaFSNw3rOrkVFB+pQblyCTQ2S5/QYKHPfpEGfthIClmo6KqBrvftsc6XmoooIB
         OH8Q==
X-Gm-Message-State: APjAAAWFgsDlPAreyGT5U+6pDU/N1dlozKUPptKhlb3KFWCqEBwIm5lN
        oWj1JMkQ3eqQttEk3xpeQlKJz27V9LWmV2JbP1OBN6q0
X-Google-Smtp-Source: APXvYqyQ0hLU7UwIkXoY/QKHPtDLXWNKslpvQscksQMWS+akarx5ZiaNucaVpZ6BllxPV6E6PXcqbQMtRLQ2JTb++yo=
X-Received: by 2002:ab0:24d:: with SMTP id 71mr80022849uas.31.1559074564237;
 Tue, 28 May 2019 13:16:04 -0700 (PDT)
MIME-Version: 1.0
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
Date:   Tue, 28 May 2019 13:15:53 -0700
Message-ID: <CAJpBn1zrkKMteogJt__6zx6gE+=pO2P5Opv0fSNhZNm9GLGWDQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/1] net: mscc: ocelot: Implement port
 policers via tc command
To:     Joergen Andreasen <joergen.andreasen@microchip.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 May 2019 14:49:17 +0200, Joergen Andreasen wrote:
> Hardware offload of matchall classifier and police action are now
> supported via the tc command.
> Supported police parameters are: rate and burst.
>
> Example:
>
> Add:
> tc qdisc add dev eth3 handle ffff: ingress
> tc filter add dev eth3 parent ffff: prio 1 handle 2   \
>       matchall skip_sw                                \
>       action police rate 100Mbit burst 10000
>
> Show:
> tc -s -d qdisc show dev eth3
> tc -s -d filter show dev eth3 ingress
>
> Delete:
> tc filter del dev eth3 parent ffff: prio 1
> tc qdisc del dev eth3 handle ffff: ingress
>
> Signed-off-by: Joergen Andreasen <joergen.andreasen@microchip.com>

Looks reasonable :)

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
