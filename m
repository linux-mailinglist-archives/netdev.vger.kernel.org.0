Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41391C0BA2
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 03:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgEABUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 21:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727889AbgEABUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 21:20:54 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C1AC035494;
        Thu, 30 Apr 2020 18:20:54 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id s8so3876992pgq.1;
        Thu, 30 Apr 2020 18:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w9nAkTdde0aWRNB9DAgUVMfwmX62ORkF4udEKd02RaI=;
        b=cbNw6uH5G2bAiizIZrR1Nik1ixHWr6qyAr+7R82K2UsotJUJblBN2EddBQnTHHdFaN
         8+Eg9RLbiyj5nCQtarPbdVhWDm+KhnrHNEZfgZFzV+9zrvTHJpJjaAk20AYnS6N9RVGi
         9XXCd5FsPaZYvp9zSWr0DN7wfkx5yVHJIo8xb+ZrvNYfiAqtorYOY+8hcQsymsM8YKIl
         m+2j8aK0V2f03DLjsUnll3B6yO++UleokUWwna6pcRvOkq/9djq3Xh9O1qCPrqzb4izP
         ioEQ7+AWRFOsXt/z4Z+75kZk9HN6e+/1PQclK4Brkc1LnjUJStctG1hRfYS+8+6NSy12
         fnEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w9nAkTdde0aWRNB9DAgUVMfwmX62ORkF4udEKd02RaI=;
        b=PtlGQgIyTPOSWUKUzVQc4NHipmHjUChUcX9TgtZb+FIveDdqbBpGkTm4v1af/K1Lrr
         2hMbJKx0K+ycyxzco/x09rGQ7iWH4GzNeG3uwjtDI5xztNnvzVNHsziaF9pstItvsl0H
         VvxUz1rvQcJBskkJl/YtK5BJZeLcKl9oAQjnc4LKEzq0OL6UXoa/e+80MJIyNPxSrwiW
         1KuX/8YYkCe2uJPiHN6G91D1b4DBPzdnBlGhHLxbT8AvZbu9ewSkxD8l5ni9TBA/jpMt
         eXqnk0QwVeN8OToIUM+Jy9Rcxcdt6t+vBdDFh0qpnFev1O+qmgcSHFyTCsyhTgJtM9gY
         qYRA==
X-Gm-Message-State: AGi0PuZC4ZZgWNAh3vUBiRbRRefQuOXYOymWPzTVpqu+RBi7FWwaQJ3m
        O0Ly32sgVgBhnkLwpcfEhMD5x807
X-Google-Smtp-Source: APiQypJpqZVcgBivnOdGyr0qHFmtIQkpHUtgv2ZAxPQs3Ro+JWRqBxjgdzJOUcr2P5s7hBffF8UFIA==
X-Received: by 2002:a63:cc:: with SMTP id 195mr1739819pga.373.1588296053737;
        Thu, 30 Apr 2020 18:20:53 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id x12sm806255pfq.209.2020.04.30.18.20.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 18:20:52 -0700 (PDT)
Subject: Re: [PATCH net-next] net: bcmgenet: Move wake-up event out of side
 band ISR
To:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1588289211-26190-1-git-send-email-opendmb@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <13b16678-12d0-57af-52c0-f9a0926235ee@gmail.com>
Date:   Thu, 30 Apr 2020 18:20:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1588289211-26190-1-git-send-email-opendmb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/30/2020 4:26 PM, Doug Berger wrote:
> The side band interrupt service routine is not available on chips
> like 7211, or rather, it does not permit the signaling of wake-up
> events due to the complex interrupt hierarchy.
> 
> Move the wake-up event accounting into a .resume_noirq function,
> account for possible wake-up events and clear the MPD/HFB interrupts
> from there, while leaving the hardware untouched until the resume
> function proceeds with doing its usual business.
> 
> Because bcmgenet_wol_power_down_cfg() now enables the MPD and HFB
> interrupts, it is invoked by a .suspend_noirq function to prevent
> the servicing of interrupts after the clocks have been disabled.
> 
> Signed-off-by: Doug Berger <opendmb@gmail.com>

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
