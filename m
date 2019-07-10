Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9186C64B8E
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 19:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbfGJRje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 13:39:34 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51617 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727095AbfGJRje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 13:39:34 -0400
Received: by mail-wm1-f66.google.com with SMTP id 207so3150593wma.1
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 10:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y3CMm9mxDpEXkg8rFuq5PpsMz6RjvoHn+dnReX9EweY=;
        b=l8YbJNddcsWYxU54P5Rwxl0dyDjUnyFXsJcC1g0wptajDwmRE+Kzp6DUvWwwbjugAs
         pSYZIdHE8zx8RejuxRnSVkIaZyi4QXrKStZBdi2hIeSumlginRGgP3lBBe+MN1mr4DpN
         1X0M/QodLwX9buU9bv1VNzz5SqYdK3nc55ug3DR8htYCRximno4g+NPBxS818plRh2ZQ
         kAZuiFC7Hn9j98ke2IBGiPSDSspcGvVXxyhlsWViQmnqvZZaBA7g4nIxqvQ22BiSjSH5
         nvVLeQVMPWpNqMWKJV/emSBn/3vdQIf5ntfRmFxxR4lHh4aMs/tU931Ew1MobcPBa3nm
         m6Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y3CMm9mxDpEXkg8rFuq5PpsMz6RjvoHn+dnReX9EweY=;
        b=Qmo/l02uP/QBG2nECPZj5eLGitbYx91D65xGgsk4gKSP2JSe7x71VzYYFw6wBEYkG2
         k3B03tyLyTzJfE+n6DgTaMWnUx8UQhQJSutrDwDqRbD6SJZ5di8JM9kd9TmYrDg9FJjb
         /sxjeOkOhP1zhC0OaRMStUZKMwhn7GUHiQRnpQG+QmhYsUlnZsYPQ+vkXHxSXGOHakIL
         qmpHhfFVDs//3JyfKNwNhvcPrB50vMOoyFKXnuNaMvvcYjNqrB9TcUN/kMVuK6Mi10Y5
         NJ9bu0k+zuPU6gFCriXZG1pYFebK+uZPfl2SN6EmfFq9htdicgnh7U9MwKa3qc7g+Ss9
         d0Dg==
X-Gm-Message-State: APjAAAUCDIeJjcEC8eZAqSssXXPg/zzCUNWgj7m+OcQAee6AzEan8njB
        g2KI4K+987iQZxmEbRzzoaVS8hnJ
X-Google-Smtp-Source: APXvYqytCaJrVqttDR+hvGk4Nks3dE4tjwjRaJ7pgkA4gbRz5fnsNYGO0NTnbP3dnMyxoMfKo/k/nw==
X-Received: by 2002:a1c:a584:: with SMTP id o126mr6400541wme.147.1562780372234;
        Wed, 10 Jul 2019 10:39:32 -0700 (PDT)
Received: from [192.168.8.147] (31.172.185.81.rev.sfr.net. [81.185.172.31])
        by smtp.gmail.com with ESMTPSA id d1sm1666268wrs.94.2019.07.10.10.39.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 10:39:30 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 0/3] net: batched receive in GRO path
To:     Edward Cree <ecree@solarflare.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>
References: <7920e85c-439e-0622-46f8-0602cf37e306@solarflare.com>
 <c80a9e7846bf903728327a1ca2c3bdcc078057a2.camel@redhat.com>
 <677040f4-05d1-e664-d24a-5ee2d2edcdbd@solarflare.com>
 <1735314f-3c6a-45fc-0270-b90cc4d5d6ba@gmail.com>
 <4516a34a-5a88-88ef-e761-7512dff4f3ce@solarflare.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <38ff0ce0-7e26-1683-90f0-adc9c0ac9abe@gmail.com>
Date:   Wed, 10 Jul 2019 19:39:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <4516a34a-5a88-88ef-e761-7512dff4f3ce@solarflare.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/10/19 6:47 PM, Edward Cree wrote:
> On 10/07/2019 16:41, Eric Dumazet wrote:
>> On 7/10/19 4:52 PM, Edward Cree wrote:
>>> Hmm, I was caught out by the call to napi_poll() actually being a local
>>>  function pointer, not the static function of the same name.  How did a
>>>  shadow like that ever get allowed?
>>> But in that case I _really_ don't understand napi_busy_loop(); nothing
>>>  in it seems to ever flush GRO, so it's relying on either
>>>  (1) stuff getting flushed because the bucket runs out of space, or
>>>  (2) the next napi poll after busy_poll_stop() doing the flush.
>>> What am I missing, and where exactly in napi_busy_loop() should the
>>>  gro_normal_list() call go?
>> Please look at busy_poll_stop()
> I did look there, but now I've looked again and harder, and I think I get it:
> busy_poll_stop() calls napi->poll(), which (eventually, possibly in the
>  subsequent poll that we schedule if rc == budget) calls napi_complete_done()
>  which does the flush.
> In which case, the same applies to the napi->rx_list, which similarly gets
>  handled in napi_complete_done().  So I don't think napi_busy_loop() needs a
>  gro_normal_list() adding to it(?)

I advise you to try busypoll then, with TCP_RR, with say 50 usec delay in /proc/sys/net/core/busy_read

Holding a small packet in the list up to the point we call busy_poll_stop()
will basically make busypoll non working anymore.

napi_complete_done() has special behavior when busy polling is active.


> 
> As a general rule, I think we need to gro_normal_list() in those places, and
>  only those places, that call napi_gro_flush().  But as I mentioned in the
>  patch 3/3 description, I'm still confused by the (few) drivers that call
>  napi_gro_flush() themselves.
> 
> -Ed
> 
