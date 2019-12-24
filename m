Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED9D412A41D
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 21:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfLXUno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 15:43:44 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:39288 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbfLXUno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 15:43:44 -0500
Received: by mail-pj1-f65.google.com with SMTP id t101so1620462pjb.4
        for <netdev@vger.kernel.org>; Tue, 24 Dec 2019 12:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xJkAFJNKb7+JBIVKe7Q2UHPZYHFCwDAm/nBEVuo9poI=;
        b=DbDFpgZoAngLWWFrn+O56lZ/3x4KmyVa3FmdRZQ+aItYYppccx9bPatGnFDoH+UN5e
         U415WIk8XAMA/9Z1rJs6SdotWvqPEYBVhhL9hf95tZRv5H3bdkIL1lLZH3rQO7sLloQD
         zxeJqLiRRfsRy+BXnER4v22BVeFp+TOYV52w8QgzeVuuetMJ3czPDVIFikrWOCuDs3Bg
         5M6420XaX60TsAVdglbdj+1GJGSv+ZwIQyqAzL9b97vzdQ1tH2Db2unkoM1yn19nJT2h
         7SMblp6CekBHt3El50Qr8A9kOI8EFOqJMWeiytkdv5N/7nKvjUVal/+qRTtIGXa1s+P1
         Eg+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xJkAFJNKb7+JBIVKe7Q2UHPZYHFCwDAm/nBEVuo9poI=;
        b=N2bB9vaF11fwot/UOXBc3TAPaXCcMJkEMxfHVbHMJTyGqSjww+xTHPCMdmRRMp69ge
         gyLZBqt+3eoxVgTdKZF7Pnx1K2OXl4ZuTutDhvAER42tFlcx3hGscnSM+OFJrjmFIahM
         P4wS+MGoU+iPIJCrtJgLpWzlyzhoWz6719GvSvrgwXUt+ebxp6ny6PCNGKDeHoajEVjp
         AO6oa2cPR9xTLWZF2mp0anakefCCqkIUo687cXqEbqasJD4Ia3COeb0Tr4kbQWL5EXVo
         h7rHlth+hKfAs6zBVO6Du15dGzoA5fbSJjSNUyLz+/eyjYyTUiEFh6rU5Yfqtd23a9V8
         MLcQ==
X-Gm-Message-State: APjAAAUOxEPLBLxXFcgv+HGWUA7J71xsuNdq5uBvsKQaWs/6iw6vtgZN
        7pFfIpw4KMxm8BW7KBiCwfDLzHhzNygrENfA6HfRcA==
X-Google-Smtp-Source: APXvYqw8EznWQA7nNRzrMIVsKKp1PJ2d4UOZXvIl9G4nFHZSeA5JFc/ctSFw9/U0JtG0UNCVqTdrjO+Cz4JxGkKYNxE=
X-Received: by 2002:a17:90a:dc82:: with SMTP id j2mr4177573pjv.70.1577220223443;
 Tue, 24 Dec 2019 12:43:43 -0800 (PST)
MIME-Version: 1.0
References: <20191223123336.13066-1-sladkani@proofpoint.com>
In-Reply-To: <20191223123336.13066-1-sladkani@proofpoint.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 24 Dec 2019 12:43:32 -0800
Message-ID: <CAM_iQpWLryJ+gPyzQEwj1kF+z7sfY50mtwmNX=swn44LP0npQw@mail.gmail.com>
Subject: Re: [PATCH net-next] net/sched: act_mirred: Ensure mac_len is pulled
 prior redirect to a non mac_header_xmit target device
To:     shmulik@metanetworks.com
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Shmulik Ladkani <sladkani@proofpoint.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 4:33 AM <shmulik@metanetworks.com> wrote:
>
> From: Shmulik Ladkani <sladkani@proofpoint.com>
>
> There's no skb_pull performed when a mirred action is set at egress of a
> mac device, with a target device/action that expects skb->data to point
> at the network header.
>
> As a result, either the target device is errornously given an skb with
> data pointing to the mac (egress case), or the net stack receives the
> skb with data pointing to the mac (ingress case).
>
> E.g:
>  # tc qdisc add dev eth9 root handle 1: prio
>  # tc filter add dev eth9 parent 1: prio 9 protocol ip handle 9 basic \
>    action mirred egress redirect dev tun0
>
>  (tun0 is a tun device. result: tun0 errornously gets the eth header
>   instead of the iph)
>
> Revise the push/pull logic of tcf_mirred_act() to not rely on the
> skb_at_tc_ingress() vs tcf_mirred_act_wants_ingress() comparison, as it
> does not cover all "pull" cases.
>
> Instead, calculate whether the required action on the target device
> requires the data to point at the network header, and compare this to
> whether skb->data points to network header - and make the push/pull
> adjustments as necessary.

This is a bug fix, please target it for -net and add a proper Fixes tag.

BTW, please make the subject shorter.

Thanks.
