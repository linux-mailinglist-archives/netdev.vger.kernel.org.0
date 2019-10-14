Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13DA6D5936
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 03:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729706AbfJNBEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 21:04:43 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:46020 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729626AbfJNBEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 21:04:43 -0400
Received: by mail-pf1-f171.google.com with SMTP id y72so9385167pfb.12;
        Sun, 13 Oct 2019 18:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YzG3KM3RT2WWNMNWSIDxDogfU5yp9qDqHwkm5rPExKs=;
        b=Xhkqgi1Pg/bppNNm0DoT+I/QPfD+8v7ZAeEmVw+dVIt79iCpgLXod8EG0HnFiGjokO
         CuaHrtaqxJcY9198X7ib/qFW9RUQDUfd/Pvr/dqt6tNJ1uOZtFG+yUbT0LzCvr/Le6m6
         cjDnTgH0Zrgz5IDgR5mGuRg0D3ar+f4zvoUR8Kx6WqycUiZG293+xoAYbxEjxmCS7rQt
         zmsnKgxxTIpKbKdjF1gWqTMcM9Qte3CmYTg67Fq77wnWXWHXTxqyJ0eqLYRR5J3MM7G8
         xF7HFUCXY4UHIkl+6vQl9AhGVEjxm8Tctb545B51jSoUiq18aWQgkh3zJCASWYFG9ewT
         WKHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YzG3KM3RT2WWNMNWSIDxDogfU5yp9qDqHwkm5rPExKs=;
        b=ECvVPsa8WnEU3vsXuS7hlNVZAfzsAEjD6f2aYOqTHpi1myOe3IsAgd813Gg//HzUjR
         PXyAGxFToPzg2DDpo13Cg+FkKFNUILA3FN6DmRL1KJdMOgl2+5MNSQCQZejTZKSEcWV/
         MuVQ4BIW+z+qMBAMvm3oE+XZLxOer0GUDgwjwR4y8GCX5A0Uyci0IhSCn6kRHHCIcHut
         3inucNpxbldmqpqJUqCz+oQeEs7n2EF+kqTZIphR2OVm6hq+dVpHDBFp6z3BiIcehFGi
         0zBZ3D4N3NToOOoen8rX1b3mC/AxqAHPKXV94iryI2w6vYC76yV0qIqmU1yCbJje7PAQ
         UNMQ==
X-Gm-Message-State: APjAAAU03XbJimW2TQhynCDCwpbFg82ZAuCU4s/AW1y/RafpJWqp3iQT
        sMyOZvtprkR+tyKj2LQDocq8WWOT
X-Google-Smtp-Source: APXvYqxh6x4IIGtg0eAAor/Q+e0C8x7y9NUoVPUDkBYKRvhscp/49KtncVxz64zOYRV4aVztRUEHmQ==
X-Received: by 2002:aa7:90da:: with SMTP id k26mr29685604pfk.145.1571015082344;
        Sun, 13 Oct 2019 18:04:42 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id b3sm14592521pfd.125.2019.10.13.18.04.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Oct 2019 18:04:41 -0700 (PDT)
Subject: Re: [PATCH] net: core: datagram: tidy up copy functions a bit
To:     Vito Caputo <vcaputo@pengaru.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191012115509.jrqe43yozs7kknv5@shells.gnugeneration.com>
 <8fab6f9c-70a6-02fd-5b2d-66a013c10a4f@gmail.com>
 <20191013200158.mhvwkdnsjk7ecuqu@shells.gnugeneration.com>
 <6864f888-1b62-36c5-6ac5-d5db01c5fcfb@gmail.com>
 <20191013224148.omivenr6fwmq66fe@shells.gnugeneration.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1a031958-97e7-a16e-7dd7-034262e68d66@gmail.com>
Date:   Sun, 13 Oct 2019 18:04:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191013224148.omivenr6fwmq66fe@shells.gnugeneration.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/13/19 3:41 PM, Vito Caputo wrote:

> I read it, thank you for your responses.
> 
> Do you have any guidance to offer someone wanting to contribute with 1-2
> hours available per day?  I don't want to cause a nuisance, but would
> like to help where I can.  My flawed assumption was that small, isolated
> hygienic contributions without functionally changing anything would be
> appropriate.

I suggest you look at the syzkaller huge queue of bugs.

You will learn more interesting stuff, and you will help the community
in a more quantifiable way.

https://syzkaller.appspot.com/upstream


