Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54859C3035
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 11:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfJAJar convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 1 Oct 2019 05:30:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44172 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbfJAJar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 05:30:47 -0400
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2ECF85945B
        for <netdev@vger.kernel.org>; Tue,  1 Oct 2019 09:30:47 +0000 (UTC)
Received: by mail-lj1-f200.google.com with SMTP id e3so3907265ljj.16
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 02:30:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=j4UjdwwciBVRjCwhEvj+BSlcvwlX1pGSkfY8Zt8n0ak=;
        b=qpRnxUjd4q1SfOKa9UPZGtKTisycbDu29Yi74Vd3W7gxESJXw+MwDeCnZrPvfRQv87
         AzzePqGb2cJIYZr9ZsgwmyfeUaAZQFEb3qwMT21KeLc32hpV68bQobS0uatj5RkA1iwI
         vWMPGXycNQ/cgcuRM9uwkyvTv9Qlf7OCN7zgvTsH7UnyWoIRUyVhn9ObRlyB83xcPTB6
         7+qbgeotZt+bZTNzc/tW8eR1eiMzNjTt3f3c98yKaRH/xrYKFyMQJuHqytNY05+zExql
         z1CboAAjaqdO8JL5DuvNZpJUXQ4Ku6absNSh6US3Q8eEczv/vH4pfH9AonemSxryowIY
         Vu3A==
X-Gm-Message-State: APjAAAW1V+PpZFSl7bsEo5n5b+vfqgsCYMBRF6zc8aRXO3uCinjPeuB2
        SRISWgZg9Q9eqiab/OZENduF8e0r8/9VBZH4rXvpkcG6m/3813BPPLBSGSplLx5biXOUrDWaiWD
        hXWCBT2umbPVmhfMR
X-Received: by 2002:a2e:890c:: with SMTP id d12mr933869lji.85.1569922245779;
        Tue, 01 Oct 2019 02:30:45 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz594zWJifbnKKITD9pn4eaDVgw1AJ1tMqQX6grprbSVRCgeNM8w15Ar8WKEeqBSZo2Ows0EQ==
X-Received: by 2002:a2e:890c:: with SMTP id d12mr933864lji.85.1569922245643;
        Tue, 01 Oct 2019 02:30:45 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id e10sm3862190ljg.38.2019.10.01.02.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 02:30:44 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0716718063D; Tue,  1 Oct 2019 11:30:44 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net] net: socionext: netsec: always grab descriptor lock
In-Reply-To: <24b0644bf4e2c1de36e774a8cd95bd39697f9b12.1569918386.git.lorenzo@kernel.org>
References: <24b0644bf4e2c1de36e774a8cd95bd39697f9b12.1569918386.git.lorenzo@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 01 Oct 2019 11:30:43 +0200
Message-ID: <87o8z0vmm4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> writes:

> Always acquire tx descriptor spinlock even if a xdp program is not loaded
> on the netsec device since ndo_xdp_xmit can run concurrently with
> netsec_netdev_start_xmit and netsec_clean_tx_dring. This can happen
> loading a xdp program on a different device (e.g virtio-net) and
> xdp_do_redirect_map/xdp_do_redirect_slow can redirect to netsec even if
> we do not have a xdp program on it.
>
> Fixes: ba2b232108d3 ("net: netsec: add XDP support")
> Tested-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Yeah, the "must load XDP program on dest interface" pattern is not a
good UI, so avoiding it when possible is good. Thanks for fixing this!

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
