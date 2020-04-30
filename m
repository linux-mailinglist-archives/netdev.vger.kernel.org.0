Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9721BECEC
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 02:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgD3AR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 20:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726279AbgD3AR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 20:17:28 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC65C035494
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 17:17:28 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id 23so4081341qkf.0
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 17:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1LcZpMIJKwMMB4P7bQ/qnwwqH/5XLPhoT1gl4phKwbM=;
        b=ip9LeCIwNDWYR5WAeEeugCgtjWbsYuryyOAnzq/Q9U8kK804RUCmohWNwRY09Dc6Gt
         UqxmGXcfJqLn96vddLK4RMV/h9u7FE/zZxVpLWdhZWfuea/BmTmSMYEVEUZN7clwkRIi
         qsnzxTlKqKiV/d/qblrWmJCgw3NScodfTHOOMlNov5sg40U5a8rfqvZBml9S5aR5+Osy
         6mYa6z1nUHFHbM+NJT7Wyy4l6+hwaN0oKENnfk3QQ5XN5+qrFe8WQsUiJIHDuAZ4CETR
         ngxhpN0qX34ET9PQtHg5pzs1Aciyuf2IKWiyU9FwRaC+t4mvRhn6xqHnBJDaf6BB6zvW
         SisA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1LcZpMIJKwMMB4P7bQ/qnwwqH/5XLPhoT1gl4phKwbM=;
        b=SgZYa8Fv4afmOpqgFXwIFrvJEfz0p+s1G3Fb0T5ZuyOkkhJkS+ROXZdda9goC+c/mL
         VLx2ZTueo7HDdr+EKxt+jKL4DMnQG+8Vsrz6Yh5bmF23LIrcydlfxzMNQflzXYepI7k4
         00DaD+cTGFf0tBrg+kcuDHjW0qXiRODMzhPzgxrPrPgVO0JbMSKQjDUjVx7xZ+4hyhY1
         AKIRNPoHOq9CAMX6bGlXqLfd0JVypYSaE5r9YYCZm8ki9M5v8Uc6ef6JDCEDXUu03fwQ
         WFR0MkAoxCvTqWQ32gYiyAaMrGrP53B/f9z5LInEktqw1Ff0L6IFtaMfc+txj7zEueaL
         RPBg==
X-Gm-Message-State: AGi0PubR2omvR2bSARqaSza3wKMfFfpLqjMYQFNa7PIB39TRdaUp6es5
        vLwsOqE/9oX2fbx8Jbs2vvKJiau8
X-Google-Smtp-Source: APiQypKsxYXLrypudrFyusjxssVWBM82tV1XWkyp+yiZ0/7DgGDDY+pT5kCdNQzpStW07I8LgJiRSg==
X-Received: by 2002:a37:a0d5:: with SMTP id j204mr1133743qke.112.1588205847626;
        Wed, 29 Apr 2020 17:17:27 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:ec9c:e6ab:797a:4bad? ([2601:282:803:7700:ec9c:e6ab:797a:4bad])
        by smtp.googlemail.com with ESMTPSA id c23sm578078qka.12.2020.04.29.17.17.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 17:17:26 -0700 (PDT)
Subject: Re: [PATCH v4 bpf-next 09/15] net: Support xdp in the Tx path for
 packets as an skb
To:     Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200427224633.15627-1-dsahern@kernel.org>
 <20200427224633.15627-10-dsahern@kernel.org>
 <f4a4d21a-90b7-0f88-3f99-1961d264bafd@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <52e49a06-8bd9-1286-da7a-624472eb020d@gmail.com>
Date:   Wed, 29 Apr 2020 18:17:24 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <f4a4d21a-90b7-0f88-3f99-1961d264bafd@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/20 9:05 AM, Daniel Borkmann wrote:
> I didn't see anything in the patch series on this (unless I missed it), but
> don't we need to force turning off GSO/TSO for the device where XDP
> egress is
> attached? Otherwise how is this safe? E.g. generic XDP uses
> netif_elide_gro()
> to bypass GRO once enabled. In this case on egress, if helpers like
> bpf_xdp_adjust_head()
> or bpf_xdp_adjust_tail() adapt GSO skbs then drivers will operate on
> wrong GSO
> info. Not sure if this goes into undefined behavior here?

yep, I need to disable gso / tso.

> 
> Overall, for the regular stack, I expect the performance of XDP egress
> to be
> worse than e.g. tc egress, for example, when TSO is disabled but not GSO
> then
> you parse the same packet multiple times given post-GSO whereas with tc
> egress
> it would operate just fine on a GSO skb. Plus all the limitations
> generic XDP
> has with skb_cloned(skb), skb_is_nonlinear(skb), etc, where we need to
> linearize
> so calling it 'XDP egress' might lead to false assumptions. Did you do a
> comparison
> on that as well?

Are suggesting that skb path and xdp_frame paths have different attach
options to make it clearer that attaching to the skb path requires
offloads to be disabled? Or do you think the name 'XDP egress' is wrong?

This option is a building block to let people choose how they want to
deploy a solution. If the overwhelming majority of traffic takes the XDP
redirect path and only a small set (e.g., broadcast, multicast, first
packet of a flow) takes the slow path, the overall solution is solid and
better performing than sending all of the traffic up the stack.

> 
> Also, I presume the XDP egress is intentionally not called when programs
> return
> XDP_TX but only XDP_REDIRECT? Why such design decision?

XDP_REDIRECT sends frame through the networking stack to go from device
1 to device 2 which can be a completely different context (e.g.,
redirect from host NIC to VM tap device).

XDP_TX is within a driver. The driver just ran a program on the packet
and nothing about the context has changed. That said, I did label the
egress attach as "core" to mean it is run in core networking code.
Moving forward if a feature comes up that warrants a change (e.g., Tx
queue selection) there are options - from drivers adding support to run
the attached egress program or using the driver attach mode to
explicitly state that it is run in the driver and covers XDP_TX.
